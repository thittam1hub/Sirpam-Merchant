import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../settings/presentation/settings_widgets.dart';
import '../application/backup_controller.dart';
import '../domain/backup_bundle.dart';
import '../domain/csv_export.dart';

/// Backup, restore and spreadsheet exports.
///
/// Everything here works offline: the file goes wherever the vendor sends it
/// (WhatsApp to themselves, Drive, a memory card) and comes back the same way.
class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _working = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _shareText(String text, String fileName, String subject) async {
    final bytes = utf8.encode(text);
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: fileName, mimeType: 'text/plain')],
      subject: subject,
      fileNameOverrides: [fileName],
    );
  }

  /// Owner sends today's books to the shop's own cloud space.
  Future<void> _backupToCloud() async {
    final l10n = context.l10n;
    setState(() => _working = true);
    try {
      await ref.read(backupProvider.notifier).backupToCloud();
      _toast(l10n.backupCloudSavedToast);
    } catch (_) {
      _toast(l10n.backupCloudFailedToast);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  /// Pulls the newest online copy back, after a plain-language confirmation.
  Future<void> _restoreFromCloud() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupCloudRestoreAction),
        content: Text(l10n.backupRestoreWarning),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.backupRestoreAction)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _working = true);
    try {
      final result = await ref.read(backupProvider.notifier).restoreFromCloud();
      if (!result.isOk) {
        _toast(_errorText(result.error!));
        return;
      }
      _toast(l10n.backupRestoredToast);
    } catch (_) {
      _toast(l10n.backupCloudFailedToast);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }


  Future<void> _backupNow() async {
    final l10n = context.l10n;
    final settings = ref.read(settingsProvider);
    final controller = ref.read(backupProvider.notifier);
    setState(() => _working = true);
    try {
      final bundle = controller.bundle(shopName: settings.stallName);
      final now = DateTime.now();
      await _shareText(
        bundle.encode(),
        backupFileName(now),
        l10n.backupShareSubject,
      );
      await controller.markSaved(now.millisecondsSinceEpoch);
      _toast(l10n.backupSavedToast);
    } catch (_) {
      _toast(l10n.backupFailedToast);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  String _errorText(BackupError error) {
    final l10n = context.l10n;
    return switch (error) {
      BackupError.notJson || BackupError.notABackup => l10n.backupErrorNotFile,
      BackupError.tooNew => l10n.backupErrorTooNew,
      BackupError.corrupt => l10n.backupErrorCorrupt,
      BackupError.empty => l10n.backupErrorEmpty,
    };
  }

  Future<void> _restore() async {
    final l10n = context.l10n;
    final picked = await FilePicker.pickFiles(
      type: FileType.any,
      withData: true,
    );
    final bytes = picked?.files.singleOrNull?.bytes;
    if (bytes == null) return;

    String raw;
    try {
      raw = utf8.decode(bytes);
    } catch (_) {
      _toast(l10n.backupErrorNotFile);
      return;
    }

    final peek = readBackup(raw);
    if (!peek.isOk) {
      _toast(_errorText(peek.error!));
      return;
    }
    final bundle = peek.bundle!;
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupRestoreConfirmTitle),
        content: Text(
          l10n.backupRestoreConfirmBody(
            bundle.rowCount,
            bundle.createdAtMs == 0
                ? '—'
                : csvDateTime(bundle.createdAtMs),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.backupRestoreAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _working = true);
    final result = await ref.read(backupProvider.notifier).restore(raw);
    if (mounted) setState(() => _working = false);
    if (!result.isOk) {
      _toast(_errorText(result.error!));
      return;
    }
    _toast(l10n.backupRestoredToast);
  }

  Future<void> _exportSales() async {
    final l10n = context.l10n;
    final sales = ref.read(ledgerProvider).sales;
    await _shareText(
      CsvExport.sales(sales, [
        l10n.exportColDate,
        l10n.exportColItem,
        l10n.exportColMode,
        l10n.exportColCustomer,
        l10n.exportColAmount,
      ]),
      'vendoros-sales.csv',
      l10n.exportSalesTitle,
    );
  }

  Future<void> _exportBills() async {
    final l10n = context.l10n;
    final bills = ref.read(orderProvider).bills;
    await _shareText(
      CsvExport.bills(bills, [
        l10n.exportColBillNo,
        l10n.exportColDate,
        l10n.exportColCustomer,
        l10n.exportColSubtotal,
        l10n.exportColDiscount,
        l10n.exportColTax,
        l10n.exportColTotal,
        l10n.exportColPayment,
        l10n.exportColStatus,
      ]),
      'vendoros-bills.csv',
      l10n.exportBillsTitle,
    );
  }

  Future<void> _exportCredit() async {
    final l10n = context.l10n;
    final balances = ref.read(ledgerProvider).udhaarBalances;
    await _shareText(
      CsvExport.credit(
        balances,
        [l10n.exportColCustomer, l10n.exportColBalance],
      ),
      'vendoros-credit.csv',
      l10n.exportCreditTitle,
    );
  }

  Future<void> _exportStock() async {
    final l10n = context.l10n;
    final inventory = ref.read(inventoryProvider);
    final products = inventory.products.where((p) => !p.deleted).toList();
    await _shareText(
      CsvExport.stock(
        products,
        {for (final p in products) p.id: inventory.onHand(p.id)},
        [
          l10n.exportColCode,
          l10n.exportColItem,
          l10n.exportColCategory,
          l10n.exportColUnit,
          l10n.exportColQty,
          l10n.exportColCost,
          l10n.exportColPrice,
        ],
      ),
      'vendoros-stock.csv',
      l10n.exportStockTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(backupProvider);
    final cloudReady = ref.watch(shopConfigProvider).cloudReady;
    final sizeKb = ref.read(backupProvider.notifier).estimatedKb();
    final lastLine = state.everBackedUp
        ? l10n.backupLastSaved(csvDateTime(state.lastBackupMs))
        : l10n.backupNeverSaved;


    return DetailScaffold(
      title: l10n.backupTitle,
      subtitle: l10n.backupSubtitle,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lastLine,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        l10n.backupSizeHint(sizeKb),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      NeuButton(
                        onPressed: _working ? null : _backupNow,
                        child: Text(l10n.backupNowAction),
                      ),
                      const SizedBox(height: 10),
                      NeuButton(
                        onPressed: _working ? null : _restore,
                        child: Text(l10n.backupRestoreAction),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.backupRestoreWarning,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: NeuColors.danger),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sectionGap),
                NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.backupCloudTitle,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        cloudReady
                            ? (state.everCloudBackedUp
                                ? l10n.backupCloudLast(
                                    csvDateTime(state.lastCloudMs))
                                : l10n.backupCloudNever)
                            : l10n.backupCloudNeedsShop,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      NeuButton(
                        onPressed:
                            _working || !cloudReady ? null : _backupToCloud,
                        child: Text(l10n.backupCloudNowAction),
                      ),
                      const SizedBox(height: 10),
                      NeuButton(
                        onPressed:
                            _working || !cloudReady ? null : _restoreFromCloud,
                        child: Text(l10n.backupCloudRestoreAction),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sectionGap),

                SettingsGroup(
                  label: l10n.exportGroupLabel,
                  children: [
                    NeuTile(
                      icon: Icons.receipt_long_rounded,
                      title: l10n.exportSalesTitle,
                      value: l10n.exportSalesSubtitle,
                      onTap: _exportSales,
                    ),
                    NeuTile(
                      icon: Icons.description_rounded,
                      title: l10n.exportBillsTitle,
                      value: l10n.exportBillsSubtitle,
                      onTap: _exportBills,
                    ),
                    NeuTile(
                      icon: Icons.account_balance_wallet_rounded,
                      title: l10n.exportCreditTitle,
                      value: l10n.exportCreditSubtitle,
                      onTap: _exportCredit,
                    ),
                    NeuTile(
                      icon: Icons.inventory_2_rounded,
                      title: l10n.exportStockTitle,
                      value: l10n.exportStockSubtitle,
                      onTap: _exportStock,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
