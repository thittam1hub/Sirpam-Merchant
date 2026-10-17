import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/inventory_models.dart';
import '../../products/domain/stock_math.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/purchase_controller.dart';
import '../domain/purchase.dart';

/// Purchase bills and supplier dues — the money-out side of the books.
class PurchasesPage extends ConsumerWidget {
  const PurchasesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bills = ref.watch(purchaseProvider);
    final live = Purchases.live(bills);
    final dues = Purchases.dues(bills);
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month).millisecondsSinceEpoch;
    final monthSpend = Purchases.spendSince(bills, monthStart);
    final df = DateFormat('d MMM');

    return DetailScaffold(
      title: l10n.purchasesTitle,
      subtitle: l10n.purchasesSubtitle,
      fallbackLocation: AppPaths.stock,
      actions: [
        NeuIconButton(
          icon: Icons.add_rounded,
          label: l10n.purchaseAdd,
          onPressed: () => _addPurchase(context, ref),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          Row(children: [
            Expanded(
              child: _Stat(
                  label: l10n.purchaseTotalDue,
                  value: money(Purchases.totalDuePaise(bills))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Stat(
                  label: l10n.purchaseMonthSpend, value: money(monthSpend)),
            ),
          ]),
          SectionTitle(l10n.purchaseDuesTitle),
          if (dues.isEmpty)
            NeuBox(
              child: Text(l10n.purchaseNoDues,
                  style: TextStyle(color: NeuColors.inkSoft)),
            )
          else
            for (final d in dues)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeuBox(
                  onTap: () => _paySupplier(context, ref, d),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.supplierName.isEmpty
                                ? l10n.purchaseSupplier
                                : d.supplierName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink),
                          ),
                          Text(
                            l10n.purchaseDueBills(d.bills, d.daysOld(now)),
                            style: TextStyle(
                                fontSize: 13, color: NeuColors.inkSoft),
                          ),
                        ],
                      ),
                    ),
                    Text(money(d.duePaise),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NeuColors.danger)),
                  ]),
                ),
              ),
          SectionTitle(l10n.purchaseBillsTitle),
          if (live.isEmpty)
            NeuBox(
              child: Column(children: [
                Text(l10n.purchasesEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NeuColors.inkSoft)),
                const SizedBox(height: 16),
                NeuTextButton(
                  label: l10n.purchaseAdd,
                  color: NeuColors.accentDark,
                  onPressed: () => _addPurchase(context, ref),
                ),
              ]),
            )
          else
            for (final b in live)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeuBox(
                  onTap: () => _billSheet(context, ref, b),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.supplierName.isEmpty
                                ? l10n.purchaseSupplier
                                : b.supplierName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink),
                          ),
                          Text(
                            '${df.format(DateTime.fromMillisecondsSinceEpoch(b.ts))}'
                            '${b.invoiceNo.isEmpty ? '' : ' · ${b.invoiceNo}'}'
                            ' · ${b.lines.length}',
                            style: TextStyle(
                                fontSize: 13, color: NeuColors.inkSoft),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(money(b.totalPaise),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink)),
                        Text(
                          b.settled
                              ? l10n.purchasePaidFull
                              : l10n.purchaseDueOf(money(b.duePaise)),
                          style: TextStyle(
                              fontSize: 12,
                              color: b.settled
                                  ? NeuColors.inkSoft
                                  : NeuColors.danger),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
        ],
      ),
    );
  }

  Future<void> _addPurchase(BuildContext context, WidgetRef ref) async {
    final ok = await ref.guard(context, Permission.recordPurchase,
        action: 'purchase.add');
    if (!ok.ok || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: NeuColors.canvas,
      isScrollControlled: true,
      builder: (_) => const _PurchaseForm(),
    );
  }

  Future<void> _paySupplier(
      BuildContext context, WidgetRef ref, SupplierDue due) async {
    final l10n = context.l10n;
    final ok = await ref.guard(context, Permission.paySupplier,
        amountPaise: due.duePaise, action: 'purchase.pay');
    if (!ok.ok || !context.mounted) return;
    final amount = TextEditingController(
        text: (due.duePaise / 100).toStringAsFixed(2));
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
              Text(l10n.purchasePayTitle(due.supplierName),
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: NeuColors.ink)),
              const SizedBox(height: 12),
              LabeledField(
                  label: l10n.purchasePayAmount,
                  controller: amount,
                  prefixText: '₹ ',
                  autofocus: true,
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true)),
              ActionRow(children: [
                NeuTextButton(
                  label: l10n.purchasePay,
                  color: NeuColors.accentDark,
                  onPressed: () async {
                    final paise =
                        ((double.tryParse(amount.text.trim()) ?? 0) * 100)
                            .round();
                    if (paise <= 0) {
                      Navigator.pop(ctx);
                      return;
                    }
                    final key = due.supplierId.isEmpty
                        ? 'name:${due.supplierName}'
                        : due.supplierId;
                    await ref
                        .read(purchaseProvider.notifier)
                        .paySupplier(key, paise);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
    amount.dispose();
  }

  Future<void> _billSheet(
      BuildContext context, WidgetRef ref, PurchaseBill bill) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: NeuColors.canvas,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: NeuBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bill.supplierName.isEmpty
                      ? l10n.purchaseSupplier
                      : bill.supplierName,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: NeuColors.ink),
                ),
                const SizedBox(height: 10),
                for (final line in bill.lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Expanded(
                          child: Text(
                              '${line.name} × ${StockMath.formatQty(line.qtyMilli)}',
                              style: TextStyle(color: NeuColors.inkSoft))),
                      Text(money(line.totalPaise),
                          style: TextStyle(color: NeuColors.ink)),
                    ]),
                  ),
                const Divider(height: 20),
                _Row(l10n.purchaseSubtotal, money(bill.subtotalPaise)),
                _Row(l10n.purchaseTax, money(bill.taxPaise)),
                _Row(l10n.purchaseTotal, money(bill.totalPaise), bold: true),
                _Row(l10n.purchaseDue, money(bill.duePaise)),
                if (bill.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(bill.note,
                        style: TextStyle(
                            fontSize: 13, color: NeuColors.inkSoft)),
                  ),
                ActionRow(children: [
                  NeuTextButton(
                    label: l10n.deleteLabel,
                    color: NeuColors.danger,
                    onPressed: () async {
                      final ok = await ref.guard(ctx, Permission.recordPurchase,
                          action: 'purchase.delete');
                      if (!ok.ok) return;
                      await ref.read(purchaseProvider.notifier).remove(bill.id);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                  if (!bill.settled)
                    NeuTextButton(
                      label: l10n.purchasePaidFull,
                      color: NeuColors.accentDark,
                      onPressed: () async {
                        final ok = await ref.guard(ctx, Permission.paySupplier,
                            amountPaise: bill.duePaise, action: 'purchase.pay');
                        if (!ok.ok) return;
                        await ref
                            .read(purchaseProvider.notifier)
                            .payBill(bill.id, bill.duePaise);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => NeuBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.ink)),
          ],
        ),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: NeuColors.inkSoft)),
            Text(value,
                style: TextStyle(
                    color: NeuColors.ink,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
          ],
        ),
      );
}

/// New purchase bill: supplier, items (catalog or free text), what was paid.
/// Catalog lines also restock inventory as a received lot.
class _PurchaseForm extends ConsumerStatefulWidget {
  const _PurchaseForm();

  @override
  ConsumerState<_PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends ConsumerState<_PurchaseForm> {
  final _invoice = TextEditingController();
  final _paid = TextEditingController();
  final _note = TextEditingController();
  final _itemName = TextEditingController();
  final _qty = TextEditingController();
  final _cost = TextEditingController();

  String _supplierId = '';
  String _supplierName = '';
  String? _productId;
  final List<PurchaseLine> _lines = [];
  bool _saving = false;

  @override
  void dispose() {
    _invoice.dispose();
    _paid.dispose();
    _note.dispose();
    _itemName.dispose();
    _qty.dispose();
    _cost.dispose();
    super.dispose();
  }

  int get _totalPaise => _lines.fold(0, (a, l) => a + l.totalPaise);

  void _addLine(List<Product> products) {
    final qty = double.tryParse(_qty.text.trim()) ?? 0;
    final cost = double.tryParse(_cost.text.trim()) ?? 0;
    final product =
        products.where((p) => p.id == _productId).firstOrNull;
    final name = product?.displayName ?? _itemName.text.trim();
    if (name.isEmpty || qty <= 0) return;
    setState(() {
      _lines.add(PurchaseLine(
        productId: product?.id ?? '',
        name: name,
        qtyMilli: (qty * 1000).round(),
        unitCostPaise: (cost * 100).round(),
        taxPermille: product?.taxPermille ?? 0,
      ));
      _itemName.clear();
      _qty.clear();
      _cost.clear();
      _productId = null;
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_lines.isEmpty || _saving) return;
    setState(() => _saving = true);
    final paid = ((double.tryParse(_paid.text.trim()) ?? 0) * 100).round();
    final bill = await ref.read(purchaseProvider.notifier).add(
          supplierId: _supplierId,
          supplierName: _supplierName,
          invoiceNo: _invoice.text.trim(),
          lines: _lines,
          paidPaise: paid,
          note: _note.text.trim(),
        );
    if (bill != null) {
      final inventory = ref.read(inventoryProvider.notifier);
      for (final line in _lines) {
        if (line.productId.isEmpty) continue;
        await inventory.receiveStock(
          productId: line.productId,
          qtyMilli: line.qtyMilli,
          unitCostPaise: line.unitCostPaise,
          supplierId: _supplierId,
          note: bill.invoiceNo,
        );
      }
    }
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.purchaseSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final suppliers = inv.liveSuppliers;
    final products = inv.activeProducts;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          18, 18, 18, 18 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: NeuBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.purchaseNewTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: NeuColors.ink)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _supplierId.isEmpty ? null : _supplierId,
                decoration: InputDecoration(
                    labelText: l10n.purchaseSupplier,
                    border: const OutlineInputBorder()),
                items: [
                  for (final s in suppliers)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (v) => setState(() {
                  _supplierId = v ?? '';
                  _supplierName =
                      suppliers.where((s) => s.id == v).firstOrNull?.name ?? '';
                }),
              ),
              const SizedBox(height: 12),
              LabeledField(label: l10n.purchaseInvoiceNo, controller: _invoice),
              SectionTitle(l10n.purchaseItems),
              for (final line in _lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                            '${line.name} × ${StockMath.formatQty(line.qtyMilli)}',
                            style: TextStyle(color: NeuColors.inkSoft))),
                    Text(money(line.totalPaise),
                        style: TextStyle(color: NeuColors.ink)),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => setState(() => _lines.remove(line)),
                    ),
                  ]),
                ),
              DropdownButtonFormField<String>(
                initialValue: _productId,
                decoration: InputDecoration(
                    labelText: l10n.purchaseLinkProduct,
                    border: const OutlineInputBorder()),
                items: [
                  for (final p in products)
                    DropdownMenuItem(value: p.id, child: Text(p.displayName)),
                ],
                onChanged: (v) => setState(() {
                  _productId = v;
                  final p = products.where((e) => e.id == v).firstOrNull;
                  if (p != null && _cost.text.trim().isEmpty) {
                    _cost.text = (p.costPaise / 100).toStringAsFixed(2);
                  }
                }),
              ),
              const SizedBox(height: 8),
              if (_productId == null)
                LabeledField(
                    label: l10n.purchaseFreeItem, controller: _itemName),
              Row(children: [
                Expanded(
                  child: LabeledField(
                      label: l10n.purchaseQty,
                      controller: _qty,
                      keyboard: const TextInputType.numberWithOptions(
                          decimal: true)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LabeledField(
                      label: l10n.purchaseUnitCost,
                      controller: _cost,
                      prefixText: '₹ ',
                      keyboard: const TextInputType.numberWithOptions(
                          decimal: true)),
                ),
              ]),
              NeuTextButton(
                label: l10n.purchaseAddLine,
                onPressed: () => _addLine(products),
              ),
              const SizedBox(height: 12),
              _Row(l10n.purchaseTotal, money(_totalPaise), bold: true),
              LabeledField(
                  label: l10n.purchasePaidNow,
                  controller: _paid,
                  prefixText: '₹ ',
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true)),
              LabeledField(label: l10n.purchaseNote, controller: _note),
              ActionRow(children: [
                NeuTextButton(
                  label: l10n.saveLabel,
                  color: NeuColors.accentDark,
                  onPressed: _save,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
