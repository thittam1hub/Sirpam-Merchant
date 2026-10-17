import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../application/inventory_controller.dart';
import '../domain/inventory_models.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// Create or edit a catalogue entry. A product with no printed barcode gets a
/// generated `VOS-…` code so it can still be labelled and scanned.
class ProductFormPage extends ConsumerStatefulWidget {
  final Product? product;
  final String? initialCode;
  const ProductFormPage({super.key, this.product, this.initialCode});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  late final _name = TextEditingController(text: widget.product?.name ?? '');
  late final _local =
      TextEditingController(text: widget.product?.nameLocal ?? '');
  late final _code = TextEditingController(
      text: widget.product?.code ?? widget.initialCode ?? '');
  late final _category =
      TextEditingController(text: widget.product?.category ?? '');
  late final _cost = TextEditingController(
      text: widget.product == null || widget.product!.costPaise == 0
          ? ''
          : (widget.product!.costPaise / 100).toStringAsFixed(2));
  late final _price = TextEditingController(
      text: widget.product == null || widget.product!.pricePaise == 0
          ? ''
          : (widget.product!.pricePaise / 100).toStringAsFixed(2));
  late final _reorder = TextEditingController(
      text: widget.product == null || widget.product!.reorderMilli == 0
          ? ''
          : StockMath.formatQty(widget.product!.reorderMilli));
  late final _tax = TextEditingController(
      text: widget.product == null || widget.product!.taxPermille == 0
          ? ''
          : (widget.product!.taxPermille / 10)
              .toStringAsFixed(2)
              .replaceFirst(RegExp(r'\.?0+$'), ''));
  late final _hsn = TextEditingController(text: widget.product?.hsn ?? '');
  late StockUnit _unit = widget.product?.unit ?? StockUnit.kg;
  bool _dirty = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _local, _code, _category, _cost, _price, _reorder, _tax, _hsn]) {
      c.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_dirty) _dirty = true;
  }

  @override
  void dispose() {
    for (final c in [_name, _local, _code, _category, _cost, _price, _reorder, _tax, _hsn]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final name = _name.text.trim();
    final local = _local.text.trim();
    if (name.isEmpty && local.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.formInvalid)));
      return;
    }
    await ref.read(inventoryProvider.notifier).saveProduct(
          id: widget.product?.id,
          name: name.isEmpty ? local : name,
          nameLocal: local,
          code: _code.text.trim(),
          category: _category.text.trim(),
          unit: _unit,
          costPaise: StockMath.parseMoney(_cost.text) ?? 0,
          pricePaise: StockMath.parseMoney(_price.text) ?? 0,
          reorderMilli: StockMath.parseQty(_reorder.text) ?? 0,
          taxPermille: ((double.tryParse(_tax.text.trim()) ?? 0) * 10)
              .round()
              .clamp(0, 1000),
          hsn: _hsn.text.trim(),
        );
    if (!mounted) return;
    _saved = true;
    unawaitedHaptic();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.productSaved)));
    AppBackButton.popOrGo(context, AppPaths.products);
  }

  void unawaitedHaptic() => HapticFeedback.mediumImpact();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: widget.product == null ? l10n.productsAdd : l10n.productEditTitle,
      subtitle: l10n.productsSubtitle,
      fallbackLocation: AppPaths.products,
      isDirty: () => _dirty && !_saved,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabeledField(
                    label: l10n.fieldName,
                    controller: _name,
                    autofocus: widget.product == null),
                LabeledField(label: l10n.fieldLocalName, controller: _local),
                LabeledField(
                    label: l10n.fieldCode,
                    controller: _code,
                    hint: l10n.fieldCodeHint),
                LabeledField(label: l10n.fieldCategory, controller: _category),
                Text(l10n.fieldUnit,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: NeuColors.inkSoft)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final u in StockUnit.values)
                      NeuButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        onPressed: () => setState(() {
                          _unit = u;
                          _dirty = true;
                        }),
                        child: Text(unitLabel(context, u),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _unit == u
                                    ? NeuColors.accentDark
                                    : NeuColors.inkSoft)),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                LabeledField(
                    label: l10n.fieldCost,
                    controller: _cost,
                    prefixText: '₹ ',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
                LabeledField(
                    label: l10n.fieldPrice,
                    controller: _price,
                    prefixText: '₹ ',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
                LabeledField(
                    label: l10n.fieldReorder,
                    controller: _reorder,
                    hint: unitLabel(context, _unit),
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
                if (ref.watch(shopConfigProvider).gstRegistered) ...[
                  LabeledField(
                      label: l10n.productTaxRate,
                      controller: _tax,
                      hint: l10n.productTaxHint,
                      keyboard: const TextInputType.numberWithOptions(
                          decimal: true)),
                  LabeledField(label: l10n.productHsn, controller: _hsn),
                ],
                NeuTextButton(
                    label: l10n.saveLabel,
                    color: NeuColors.accentDark,
                    onPressed: _save),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
