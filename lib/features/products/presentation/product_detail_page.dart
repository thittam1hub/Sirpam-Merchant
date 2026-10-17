import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../application/inventory_controller.dart';
import '../domain/inventory_models.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// One product: stock, batches, movement history and every stock action.
class ProductDetailPage extends ConsumerWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final product = inv.byId(productId);

    if (product == null) {
      return DetailScaffold(
        title: l10n.productsTitle,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: NeuBox(
              child: Text(l10n.productMissing,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NeuColors.inkSoft)),
            ),
          ),
        ),
      );
    }

    final onHand = inv.onHand(product.id);
    final batches = inv.batchesFor(product.id);
    final movements = inv.movementsFor(product.id).take(20).toList();
    final df = DateFormat('dd MMM, HH:mm');

    return DetailScaffold(
      title: product.displayName,
      subtitle: product.code,
      fallbackLocation: AppPaths.products,
      actions: [
        NeuIconButton(
          icon: Icons.edit_rounded,
          label: l10n.productEditTitle,
          onPressed: () => context.push(AppRoutes.productEdit(product.id)),
        ),
        NeuIconButton(
          icon: Icons.delete_outline_rounded,
          label: l10n.deleteLabel,
          iconColor: NeuColors.danger,
          onPressed: () => _confirmArchive(context, ref, product),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          l10n.stockOnHand(
                              qtyWithUnit(context, onHand, product.unit)),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: NeuColors.ink)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        StatusPill(
                            '${l10n.fieldPrice}: ${money(product.pricePaise)}'),
                        StatusPill(
                            '${l10n.fieldCost}: ${money(product.costPaise)}'),
                        if (product.marginPct != null)
                          StatusPill(
                              l10n.marginLabel(
                                  product.marginPct!.toStringAsFixed(0)),
                              color: NeuColors.accentDark),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                BarcodeView.qr(data: product.code, size: 84),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ActionRow(children: [
            NeuTextButton(
              label: l10n.detailSell,
              color: NeuColors.accentDark,
              onPressed: () => _sell(context, ref, product, onHand),
            ),
            NeuTextButton(
              label: l10n.detailRestock,
              onPressed: () => _restock(context, ref, product),
            ),
          ]),
          const SizedBox(height: 10),
          ActionRow(children: [
            NeuTextButton(
              label: l10n.detailWastage,
              color: NeuColors.danger,
              onPressed: () => _wastage(context, ref, product),
            ),
            NeuTextButton(
              label: l10n.detailCorrect,
              onPressed: () => _correct(context, ref, product, onHand),
            ),
          ]),
          const SizedBox(height: 10),
          NeuTextButton(
            label: l10n.detailLabel,
            onPressed: () => context.push(AppRoutes.labels(productId: product.id)),
          ),
          SectionTitle(l10n.detailBatches),
          if (batches.isEmpty)
            NeuBox(
                child: Text(l10n.batchesEmpty,
                    style: TextStyle(color: NeuColors.inkSoft)))
          else
            for (final b in batches)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.batchLine(
                              qtyWithUnit(context, b.remainingMilli, product.unit),
                              money(b.costPaise)),
                          style: TextStyle(color: NeuColors.ink),
                        ),
                      ),
                      StatusPill(_expiryText(context, b),
                          color: _expiryColor(b)),
                    ],
                  ),
                ),
              ),
          SectionTitle(l10n.detailHistory),
          if (movements.isEmpty)
            NeuBox(
                child: Text(l10n.historyEmpty,
                    style: TextStyle(color: NeuColors.inkSoft)))
          else
            for (final m in movements)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movementLabel(context, m.kind),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            Text(
                                df.format(
                                    DateTime.fromMillisecondsSinceEpoch(m.ts)),
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      Text(
                        '${qtyWithUnit(context, m.qtyMilli.abs(), product.unit)}  ·  ${money(m.valuePaise)}',
                        style: TextStyle(color: NeuColors.inkSoft),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  static String _expiryText(BuildContext context, StockBatch b) {
    final l10n = context.l10n;
    final now = DateTime.now();
    switch (StockMath.bucket(b, now)) {
      case ExpiryBucket.expired:
        return l10n.expiredTag;
      case ExpiryBucket.today:
        return l10n.expiryTodayTag;
      case ExpiryBucket.soon:
      case ExpiryBucket.later:
        final days = DateTime.fromMillisecondsSinceEpoch(b.expiryAt!)
            .difference(now)
            .inDays;
        return l10n.expirySoonTag(days.clamp(0, 9999));
      case ExpiryBucket.none:
        return l10n.noExpiry;
    }
  }

  static Color _expiryColor(StockBatch b) {
    switch (StockMath.bucket(b, DateTime.now())) {
      case ExpiryBucket.expired:
        return NeuColors.danger;
      case ExpiryBucket.today:
      case ExpiryBucket.soon:
        return NeuColors.warn;
      default:
        return NeuColors.inkSoft;
    }
  }

  Future<void> _confirmArchive(
      BuildContext context, WidgetRef ref, Product product) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeuColors.surface,
        title: Text(l10n.deleteLabel),
        content: Text(l10n.productArchiveConfirm(product.displayName)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancelLabel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.deleteLabel,
                  style: TextStyle(color: NeuColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(inventoryProvider.notifier).archiveProduct(product.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.productArchived)));
    context.go(AppRoutes.products());
  }

  Future<void> _sell(BuildContext context, WidgetRef ref, Product product,
      int onHand) async {
    final l10n = context.l10n;
    final res = await _quantitySheet(
      context,
      title: l10n.detailSell,
      unitHint: unitLabel(context, product.unit),
      secondLabel: l10n.fieldPrice,
      secondPrefill: product.pricePaise == 0
          ? ''
          : (product.pricePaise / 100).toStringAsFixed(2),
    );
    if (res == null || !context.mounted) return;
    final qty = res.qtyMilli;
    final unitPrice = res.secondPaise ?? product.pricePaise;
    final revenue = (qty * unitPrice / 1000).round();

    final fifo = await ref.read(inventoryProvider.notifier).sellStock(
        productId: product.id, qtyMilli: qty, revenuePaise: revenue);
    await ref.read(ledgerProvider.notifier).addSale(
          amountPaise: revenue,
          mode: SaleMode.cash,
          item: product.displayName,
        );
    if (!context.mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    final shortfall = fifo.shortfallMilli;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(shortfall > 0
          ? l10n.sellShortfall(
              qtyWithUnit(context, qty - shortfall, product.unit))
          : l10n.soldRecorded),
    ));
  }

  Future<void> _restock(
      BuildContext context, WidgetRef ref, Product product) async {
    final l10n = context.l10n;
    final res = await _quantitySheet(
      context,
      title: l10n.detailRestock,
      unitHint: unitLabel(context, product.unit),
      secondLabel: l10n.unitCostLabel,
      secondPrefill: product.costPaise == 0
          ? ''
          : (product.costPaise / 100).toStringAsFixed(2),
      askExpiry: true,
    );
    if (res == null || !context.mounted) return;
    await ref.read(inventoryProvider.notifier).receiveStock(
          productId: product.id,
          qtyMilli: res.qtyMilli,
          unitCostPaise: res.secondPaise ?? product.costPaise,
          expiryAt: res.expiryAt,
        );
    if (!context.mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.restocked)));
  }

  Future<void> _wastage(
      BuildContext context, WidgetRef ref, Product product) async {
    final l10n = context.l10n;
    final res = await _quantitySheet(context,
        title: l10n.detailWastage, unitHint: unitLabel(context, product.unit));
    if (res == null || !context.mounted) return;
    await ref
        .read(inventoryProvider.notifier)
        .recordWastage(productId: product.id, qtyMilli: res.qtyMilli);
    if (!context.mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.wastageRecorded)));
  }

  Future<void> _correct(BuildContext context, WidgetRef ref, Product product,
      int onHand) async {
    final l10n = context.l10n;
    final res = await _quantitySheet(context,
        title: l10n.detailCorrect,
        unitHint: unitLabel(context, product.unit),
        qtyPrefill: StockMath.formatQty(onHand));
    if (res == null || !context.mounted) return;
    await ref
        .read(inventoryProvider.notifier)
        .correctStock(productId: product.id, newOnHandMilli: res.qtyMilli);
    if (!context.mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.stockCorrected)));
  }
}

class _QtyResult {
  final int qtyMilli;
  final int? secondPaise;
  final int? expiryAt;
  const _QtyResult(this.qtyMilli, this.secondPaise, this.expiryAt);
}

Future<_QtyResult?> _quantitySheet(
  BuildContext context, {
  required String title,
  required String unitHint,
  String qtyPrefill = '',
  String? secondLabel,
  String secondPrefill = '',
  bool askExpiry = false,
}) {
  final l10n = context.l10n;
  final qty = TextEditingController(text: qtyPrefill);
  final second = TextEditingController(text: secondPrefill);
  final expiry = TextEditingController();

  return showModalBottomSheet<_QtyResult>(
    context: context,
    backgroundColor: NeuColors.canvas,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
          18, 18, 18, 18 + MediaQuery.of(ctx).viewInsets.bottom),
      child: NeuBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.ink)),
            const SizedBox(height: 14),
            LabeledField(
              label: '${l10n.qtyLabel} ($unitHint)',
              controller: qty,
              autofocus: true,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (secondLabel != null)
              LabeledField(
                label: secondLabel,
                controller: second,
                prefixText: '₹ ',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
            if (askExpiry)
              LabeledField(
                label: l10n.expiryLabel,
                controller: expiry,
                keyboard: TextInputType.number,
              ),
            ActionRow(children: [
              NeuTextButton(
                  label: l10n.cancelLabel,
                  color: NeuColors.inkSoft,
                  onPressed: () => Navigator.pop(ctx)),
              NeuTextButton(
                label: l10n.confirmLabel,
                color: NeuColors.accentDark,
                onPressed: () {
                  final q = StockMath.parseQty(qty.text);
                  if (q == null || q < 0) {
                    Navigator.pop(ctx);
                    return;
                  }
                  final days = int.tryParse(expiry.text.trim());
                  Navigator.pop(
                    ctx,
                    _QtyResult(
                      q,
                      StockMath.parseMoney(second.text),
                      days == null
                          ? null
                          : DateTime.now()
                              .add(Duration(days: days))
                              .millisecondsSinceEpoch,
                    ),
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    ),
  ).whenComplete(() {
    qty.dispose();
    second.dispose();
    expiry.dispose();
  });
}
