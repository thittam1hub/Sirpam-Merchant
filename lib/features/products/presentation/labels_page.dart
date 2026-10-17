import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../application/inventory_controller.dart';
import '../application/label_sheet.dart';
import '../domain/label_template.dart';
import 'inventory_widgets.dart';

/// Shelf labels: pick products, choose a size and symbology, print an A4 sheet
/// or copy the ZPL / TSPL a thermal printer expects.
class LabelsPage extends ConsumerStatefulWidget {
  final String? productId;
  const LabelsPage({super.key, this.productId});

  @override
  ConsumerState<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends ConsumerState<LabelsPage> {
  late final Set<String> _selected = {
    if (widget.productId != null) widget.productId!,
  };
  LabelSize _size = LabelSize.small;
  LabelSymbology _symbology = LabelSymbology.qr;
  int _copies = 1;

  List<LabelSpec> _specs() {
    final inv = ref.read(inventoryProvider);
    return [
      for (final id in _selected)
        if (inv.byId(id) case final p?)
          LabelSpec(
            title: p.displayName,
            code: p.code,
            priceLine: p.pricePaise == 0 ? '' : money(p.pricePaise),
            infoLine: p.category,
            size: _size,
            symbology: _symbology,
            copies: _copies,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final products = ref.watch(inventoryProvider).liveProducts;

    return DetailScaffold(
      title: l10n.labelsTitle,
      subtitle: l10n.labelsSubtitle,
      fallbackLocation: AppPaths.products,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          SectionTitle(l10n.labelsSize),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in LabelSize.values)
              NeuButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                selected: _size == s,
                onPressed: () => setState(() => _size = s),
                child: Text(
                    '${s.widthMm.toStringAsFixed(0)}×${s.heightMm.toStringAsFixed(0)} mm',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _size == s
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          SectionTitle(l10n.labelsSymbology),
          ActionRow(children: [
            NeuTextButton(
              label: l10n.symbolQr,
              color: _symbology == LabelSymbology.qr
                  ? NeuColors.accentDark
                  : NeuColors.inkSoft,
              onPressed: () => setState(() => _symbology = LabelSymbology.qr),
            ),
            NeuTextButton(
              label: l10n.symbolBarcode,
              color: _symbology == LabelSymbology.code128
                  ? NeuColors.accentDark
                  : NeuColors.inkSoft,
              onPressed: () =>
                  setState(() => _symbology = LabelSymbology.code128),
            ),
          ]),
          SectionTitle(l10n.labelsCopies),
          ActionRow(children: [
            for (final n in [1, 2, 5, 10])
              NeuTextButton(
                label: '$n',
                color: _copies == n ? NeuColors.accentDark : NeuColors.inkSoft,
                onPressed: () => setState(() => _copies = n),
              ),
          ]),
          SectionTitle(l10n.labelsSelect),
          if (products.isEmpty)
            NeuBox(
                child: Text(l10n.productsEmpty,
                    style: TextStyle(color: NeuColors.inkSoft)))
          else
            for (final p in products)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  onTap: () => setState(() => _selected.contains(p.id)
                      ? _selected.remove(p.id)
                      : _selected.add(p.id)),
                  child: Row(
                    children: [
                      Icon(
                          _selected.contains(p.id)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: _selected.contains(p.id)
                              ? NeuColors.accentDark
                              : NeuColors.inkSoft),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.displayName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            Text(p.code,
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      if (_symbology == LabelSymbology.qr)
                        BarcodeView.qr(data: p.code, size: 44)
                      else
                        BarcodeView.code128(
                            data: p.code, width: 90, height: 40, drawText: false),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 8),
          ActionRow(children: [
            NeuTextButton(
              label: l10n.labelsThermal,
              onPressed: () => _copyThermal(context),
            ),
            NeuTextButton(
              label: l10n.labelsPrint,
              color: NeuColors.accentDark,
              onPressed: () => _print(context),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _print(BuildContext context) async {
    final l10n = context.l10n;
    final specs = _specs();
    if (specs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.labelsNone)));
      return;
    }
    final bytes = await LabelSheet.build(specs);
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _copyThermal(BuildContext context) async {
    final l10n = context.l10n;
    final specs = _specs();
    if (specs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.labelsNone)));
      return;
    }
    final payload = [
      for (final s in specs) ...[LabelRenderer.zpl(s), LabelRenderer.tspl(s)],
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: payload));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.labelsCopied)));
  }
}
