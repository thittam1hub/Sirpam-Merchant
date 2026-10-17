import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/inventory_controller.dart';
import '../domain/inventory_models.dart';
import 'inventory_widgets.dart';

/// Suppliers plus a one-tap WhatsApp reorder built from the low-stock list.
class SuppliersPage extends ConsumerWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final suppliers = inv.liveSuppliers;

    return DetailScaffold(
      title: l10n.suppliersTitle,
      subtitle: l10n.suppliersSubtitle,
      fallbackLocation: AppPaths.stock,
      actions: [
        NeuIconButton(
          icon: Icons.add_rounded,
          label: l10n.supplierAdd,
          onPressed: () => _edit(context, ref, null),
        ),
      ],
      body: suppliers.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: NeuBox(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(l10n.suppliersEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: NeuColors.inkSoft)),
                    const SizedBox(height: 16),
                    NeuTextButton(
                        label: l10n.supplierAdd,
                        onPressed: () => _edit(context, ref, null)),
                  ]),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
              itemCount: suppliers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final s = suppliers[i];
                return NeuBox(
                  onTap: () => _edit(context, ref, s),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            if (s.phone.isNotEmpty)
                              Text(s.phone,
                                  style: TextStyle(
                                      fontSize: 13, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      if (s.phone.isNotEmpty)
                        NeuIconButton(
                          icon: Icons.chat_rounded,
                          label: l10n.supplierWhatsapp,
                          onPressed: () => _reorder(context, ref, s),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _reorder(
      BuildContext context, WidgetRef ref, Supplier supplier) async {
    final l10n = context.l10n;
    final inv = ref.read(inventoryProvider);
    final stall = ref.read(settingsProvider).stallName;
    final items = inv.lowStock
        .map((p) => '${p.displayName} — ${qtyWithUnit(context, p.reorderMilli, p.unit)}')
        .join(', ');
    if (items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.stockNothingLow)));
      return;
    }
    final uri = ShareLinks.whatsapp(
        phone: supplier.phone, message: l10n.reorderMessage(stall, items));
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, Supplier? supplier) async {
    final l10n = context.l10n;
    final name = TextEditingController(text: supplier?.name ?? '');
    final phone = TextEditingController(text: supplier?.phone ?? '');
    final note = TextEditingController(text: supplier?.note ?? '');

    await showModalBottomSheet<void>(
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
              LabeledField(
                  label: l10n.supplierName,
                  controller: name,
                  autofocus: supplier == null),
              LabeledField(
                  label: l10n.supplierPhone,
                  controller: phone,
                  keyboard: TextInputType.phone),
              LabeledField(label: l10n.supplierNote, controller: note),
              ActionRow(children: [
                if (supplier != null)
                  NeuTextButton(
                    label: l10n.deleteLabel,
                    color: NeuColors.danger,
                    onPressed: () async {
                      await ref
                          .read(inventoryProvider.notifier)
                          .deleteSupplier(supplier.id);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                NeuTextButton(
                  label: l10n.saveLabel,
                  color: NeuColors.accentDark,
                  onPressed: () async {
                    if (name.text.trim().isEmpty) {
                      Navigator.pop(ctx);
                      return;
                    }
                    await ref.read(inventoryProvider.notifier).saveSupplier(
                          id: supplier?.id,
                          name: name.text.trim(),
                          phone: phone.text.trim(),
                          note: note.text.trim(),
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );

    name.dispose();
    phone.dispose();
    note.dispose();
  }
}
