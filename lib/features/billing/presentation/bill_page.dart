import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../ledger/domain/sale.dart';

import '../../offers/application/offer_controller.dart';
import '../../offers/domain/offer.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/domain/order.dart';
import '../../orders/domain/shop_config.dart';
import '../../printing/application/bluetooth_printer.dart';
import '../../printing/application/printer_controller.dart';
import '../../printing/application/receipt_printer.dart';
import '../../printing/domain/escpos.dart';
import '../../printing/domain/printer_settings.dart';
import '../../printing/domain/receipt.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../profile/application/profile_controller.dart';
import '../application/receipt_builder.dart';
import '../domain/bill.dart';
import '../domain/tax.dart';

/// Bill sheet for one order: discount, optional GST, split tender, print.
class BillPage extends ConsumerStatefulWidget {
  final String orderId;
  const BillPage({super.key, required this.orderId});

  @override
  ConsumerState<BillPage> createState() => _BillPageState();
}

class _BillPageState extends ConsumerState<BillPage> {
  final _discountFlat = TextEditingController();
  final _discountPct = TextEditingController();
  final _cash = TextEditingController();
  final _upi = TextEditingController();
  final _credit = TextEditingController();
  final _customer = TextEditingController();
  bool _round = true;
  String? _appliedOfferId;
  bool _settling = false;

  @override
  void dispose() {
    _discountFlat.dispose();
    _discountPct.dispose();
    _cash.dispose();
    _upi.dispose();
    _credit.dispose();
    _customer.dispose();
    super.dispose();
  }

  int _paise(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    if (v == null || v <= 0) return 0;
    return (v * 100).round();
  }

  double _pct(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    if (v == null || v <= 0) return 0;
    return v > 100 ? 100 : v;
  }

  /// GST slab table for a registered shop; empty otherwise, which keeps the
  /// old single-rate behaviour for unregistered stalls.
  TaxBreakdown _breakdown(ShopOrder order, ShopConfig shop) {
    if (!shop.gstRegistered) return TaxBreakdown.empty;
    final discount = BillMath.discount(
      subtotalPaise: order.subtotalPaise,
      flatPaise: _paise(_discountFlat),
      percent: _pct(_discountPct),
    );
    return GstMath.breakdown(
      lines: [
        for (final l in order.lines)
          TaxableLine(
              totalPaise: l.totalPaise,
              ratePermille: l.taxPermille,
              hsn: l.hsn),
      ],
      fallbackPermille: GstMath.permilleFromPercent(shop.taxPercent),
      discountPaise: discount,
      inclusive: shop.priceIncludesTax,
    );
  }

  BillTotals _totals(ShopOrder order, ShopConfig shop) {
    final breakdown = _breakdown(order, shop);
    if (breakdown.isEmpty) {
      return BillMath.compute(
        subtotalPaise: order.subtotalPaise,
        discountFlatPaise: _paise(_discountFlat),
        discountPercent: _pct(_discountPct),
        taxPercent: shop.taxPercent,
        roundToRupee: _round,
      );
    }
    return BillMath.computeWithTax(
      subtotalPaise: order.subtotalPaise,
      discountFlatPaise: _paise(_discountFlat),
      discountPercent: _pct(_discountPct),
      taxPaise: breakdown.taxPaise,
      taxIncluded: shop.priceIncludesTax,
      roundToRupee: _round,
    );
  }

  List<BillPayment> _payments() => [
        if (_paise(_cash) > 0)
          BillPayment(mode: SaleMode.cash, amountPaise: _paise(_cash)),
        if (_paise(_upi) > 0)
          BillPayment(mode: SaleMode.upi, amountPaise: _paise(_upi)),
        if (_paise(_credit) > 0)
          BillPayment(mode: SaleMode.credit, amountPaise: _paise(_credit)),
      ];

  Future<void> _settle(ShopOrder order, ShopConfig shop) async {
    final totals = _totals(order, shop);
    final breakdown = _breakdown(order, shop);
    final payments = _payments();
    if (BillMath.balance(totals.totalPaise, payments) != 0) return;

    // Two separate checks: making the bill at all, and — only when money is
    // taken off the total — the discount, which carries its own role limit.
    final allowed = await ref.guard(context, Permission.makeBill,
        amountPaise: totals.totalPaise,
        action: 'bill.settle',
        refType: 'order',
        refId: order.id);
    if (!allowed.ok || !mounted) return;
    if (totals.discountPaise > 0) {
      final discountOk = await ref.guard(context, Permission.giveDiscount,
          amountPaise: totals.discountPaise,
          action: 'bill.discount',
          refType: 'order',
          refId: order.id);
      if (!discountOk.ok || !mounted) return;
    }
    final creditPaise = _paise(_credit);
    if (creditPaise > 0) {
      final creditOk = await ref.guard(context, Permission.giveCredit,
          amountPaise: creditPaise,
          action: 'bill.credit',
          refType: 'order',
          refId: order.id);
      if (!creditOk.ok || !mounted) return;
    }

    setState(() => _settling = true);
    final bill = await ref.read(orderProvider.notifier).settle(
          orderId: order.id,
          discountFlatPaise: _paise(_discountFlat),
          discountPercent: _pct(_discountPct),
          taxPercent: shop.taxPercent,
          roundToRupee: _round,
          payments: payments,
          customer: _customer.text.trim(),
          breakdown: breakdown.isEmpty ? null : breakdown,
          taxIncluded: shop.priceIncludesTax,
        );
    if (!mounted) return;
    setState(() => _settling = false);
    final printer = ref.read(printerProvider);
    if (printer.autoPrint) await _print(bill, order);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.billSettled(bill.number))));
    final offerId = _appliedOfferId;
    if (offerId != null && totals.discountPaise > 0) {
      await ref
          .read(offerProvider.notifier)
          .redeem(offerId, totals.discountPaise);
    }
    if (mounted) context.go(AppRoutes.orders());
  }

  ReceiptData _receipt(Bill bill, ShopOrder order, {bool reprint = false}) =>
      ReceiptBuilder.build(
        l10n: context.l10n,
        bill: bill,
        order: order,
        settings: ref.read(settingsProvider),
        profile: ref.read(profileProvider),
        shop: ref.read(shopConfigProvider),
        reprint: reprint,
      );

  Future<void> _print(Bill bill, ShopOrder order,
      {bool reprint = false}) async {
    // Duplicates are the classic till-fiddle, so a reprint is a permission of
    // its own and always lands in the audit trail.
    if (reprint) {
      final allowed = await ref.guard(context, Permission.reprintBill,
          amountPaise: bill.totalPaise,
          action: 'bill.reprint',
          refType: 'bill',
          refId: bill.id);
      if (!allowed.ok || !mounted) return;
    }
    final printer = ref.read(printerProvider);

    final outcome = await ReceiptPrinter.send(
      _receipt(bill, order, reprint: reprint),
      printer,
      jobName: bill.number,
      bluetooth: ref.read(bluetoothPrinterProvider),
    );
    // Every print — first copy or duplicate — lands in the bill's audit trail
    // together with the transport the paper actually came out of.
    await ref.read(orderProvider.notifier).recordPrint(
          bill.id,
          reprint: reprint,
          target:
              outcome == PrintOutcome.printed ? printer.transport.name : 'pdf',
        );
    if (!mounted) return;
    if (outcome == PrintOutcome.fellBackToPdf &&
        printer.transport != PrintTransport.pdf) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.printerFallbackNote)));
    }
  }

  /// Paper preview: exactly the monospaced text the thermal printer receives.
  void _preview(Bill bill, ShopOrder order) {
    final printer = ref.read(printerProvider);
    final text = ReceiptText.render(_receipt(bill, order), printer.width);
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.billPreview),
            Flexible(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(text,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: NeuColors.ink)),
                ),
              ),
            ),
            ActionRow(children: [
              NeuTextButton(
                  label: ctx.l10n.close,
                  onPressed: () => Navigator.of(ctx).pop()),
            ]),
          ]),
        ),
      ),
    );
  }

  Future<void> _void(Bill bill) async {
    final controller = TextEditingController();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(l10n.billVoidTitle),
            Text(l10n.billVoidHint, style: TextStyle(color: NeuColors.inkSoft)),
            const SizedBox(height: 10),
            LabeledField(
                label: l10n.billVoidReason,
                controller: controller,
                autofocus: true),
            ActionRow(children: [
              NeuTextButton(
                  label: l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(false)),
              NeuTextButton(
                  label: l10n.billVoid,
                  color: NeuColors.danger,
                  onPressed: () => Navigator.of(ctx).pop(true)),
            ]),
          ]),
        ),
      ),
    );
    final reason = controller.text.trim();
    controller.dispose();
    if (confirmed != true) return;
    if (reason.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.billVoidReasonRequired)));
      return;
    }
    if (!mounted) return;
    final allowed = await ref.guard(context, Permission.voidBill,
        amountPaise: bill.totalPaise,
        action: 'bill.void',
        refType: 'bill',
        refId: bill.id,
        note: reason);
    if (!allowed.ok || !mounted) return;
    final ok = await ref.read(orderProvider.notifier).voidBill(bill.id, reason);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? l10n.billVoided : l10n.billVoidFailed)));
  }

  Future<void> _share(Bill bill, ShopOrder order) async {
    final data = ReceiptBuilder.build(
      l10n: context.l10n,
      bill: bill,
      order: order,
      settings: ref.read(settingsProvider),
      profile: ref.read(profileProvider),
      shop: ref.read(shopConfigProvider),
    );
    await ReceiptPrinter.share(data, ref.read(printerProvider),
        filename: '${bill.number}.pdf');
  }

  /// Plain-text copy for WhatsApp/SMS — the format most customers actually
  /// want, and the only one that survives a 2G connection.
  Future<void> _shareText(Bill bill, ShopOrder order) async {
    final printer = ref.read(printerProvider);
    final text = ReceiptPrinter.plainText(_receipt(bill, order), printer.width);
    await Share.share(text, subject: bill.number);
  }

  /// One tap straight into WhatsApp. When the customer's number is on the
  /// bill it opens their chat; otherwise WhatsApp asks who to send it to.
  Future<void> _whatsapp(Bill bill, ShopOrder order) async {
    final printer = ref.read(printerProvider);
    final text = ReceiptPrinter.plainText(_receipt(bill, order), printer.width);
    final phone = RegExp(r'\d{10,}').firstMatch(_customer.text)?.group(0) ?? '';
    final ok = await launchUrl(ShareLinks.whatsapp(message: text, phone: phone),
        mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(context.l10n.billWhatsappFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(orderProvider);
    final shop = ref.watch(shopConfigProvider);
    final order = state.orderById(widget.orderId);

    if (order == null) {
      return DetailScaffold(
        title: l10n.billTitle,
        fallbackLocation: AppPaths.orders,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: NeuBox(
              child: Text(l10n.orderEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NeuColors.inkSoft)),
            ),
          ),
        ),
      );
    }

    final existing = order.billId.isEmpty ? null : state.billById(order.billId);
    final totals = _totals(order, shop);
    final breakdown = _breakdown(order, shop);
    final payments = _payments();
    final balance = BillMath.balance(totals.totalPaise, payments);

    return DetailScaffold(
      title: l10n.billTitle,
      subtitle: l10n.orderToken(order.token),
      fallbackLocation: AppPaths.orders,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
        children: [
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in order.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      Expanded(
                          child: Text('${line.qty} × ${line.name}',
                              style: TextStyle(color: NeuColors.ink))),
                      Text(money(line.totalPaise),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: NeuColors.ink)),
                    ]),
                  ),
                const Divider(height: 20),
                _TotalRow(
                    label: l10n.billSubtotal, paise: totals.subtotalPaise),
                if (totals.discountPaise > 0)
                  _TotalRow(
                      label: l10n.billDiscount, paise: -totals.discountPaise),
                if (totals.taxPaise > 0)
                  _TotalRow(label: l10n.billTax, paise: totals.taxPaise),
                for (final slab in breakdown.slabs) ...[
                  _TotalRow(
                      label: '${l10n.billTaxable} ${slab.rateLabel}%',
                      paise: slab.taxablePaise),
                  if (slab.igstPaise > 0)
                    _TotalRow(
                        label: '${l10n.billIgst} ${slab.rateLabel}%',
                        paise: slab.igstPaise)
                  else ...[
                    _TotalRow(
                        label: '${l10n.billCgst} ${slab.halfRateLabel}%',
                        paise: slab.cgstPaise),
                    _TotalRow(
                        label: '${l10n.billSgst} ${slab.halfRateLabel}%',
                        paise: slab.sgstPaise),
                  ],
                ],
                if (totals.roundingPaise != 0)
                  _TotalRow(
                      label: l10n.billRounding, paise: totals.roundingPaise),
                _TotalRow(
                    label: l10n.billTotal,
                    paise: totals.totalPaise,
                    strong: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionTitle(l10n.billDiscount),
          Row(children: [
            Expanded(
              child: LabeledField(
                label: l10n.billDiscountFlat,
                controller: _discountFlat,
                prefixText: '₹',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledField(
                label: l10n.billDiscountPct,
                controller: _discountPct,
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ]),
          Builder(builder: (context) {
            final live = ref.watch(offerProvider.notifier).live();
            if (live.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                for (final offer in live)
                  NeuButton(
                    selected: offer.id == _appliedOfferId,
                    minHeight: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    onPressed: () => setState(() {
                      if (offer.id == _appliedOfferId) {
                        _appliedOfferId = null;
                        _discountFlat.clear();
                        _discountPct.clear();
                        return;
                      }
                      _appliedOfferId = offer.id;
                      _discountPct.clear();
                      if (offer.kind == OfferKind.percent) {
                        _discountFlat.clear();
                        _discountPct.text = '${offer.percent}';
                      } else {
                        _discountFlat.text =
                            (offer.discountOn(order.subtotalPaise) / 100)
                                .toStringAsFixed(2);
                      }
                    }),
                    child: Text(offer.name,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: offer.id == _appliedOfferId
                                ? NeuColors.accentDark
                                : NeuColors.inkSoft)),
                  ),
              ]),
            );
          }),
          NeuSwitch(
            value: _round,
            label: l10n.billRoundToRupee,
            onChanged: (v) => setState(() => _round = v),
          ),
          const SizedBox(height: 16),
          SectionTitle(l10n.billSplit),
          Row(children: [
            Expanded(
              child: LabeledField(
                label: l10n.modeCash,
                controller: _cash,
                prefixText: '₹',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledField(
                label: l10n.modeUpi,
                controller: _upi,
                prefixText: '₹',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: LabeledField(
                label: l10n.modeCredit,
                controller: _credit,
                prefixText: '₹',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  LabeledField(label: l10n.billCustomer, controller: _customer),
            ),
          ]),
          NeuBox(
            inset: true,
            child: Row(children: [
              Expanded(
                child: Text(
                    balance == 0 ? l10n.billFullyPaid : l10n.billBalance,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: NeuColors.inkSoft)),
              ),
              Text(money(balance),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: balance == 0
                          ? NeuColors.accentDark
                          : NeuColors.warn)),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: NeuButton(
                onPressed: () => setState(
                    () => _cash.text = (balance / 100).toStringAsFixed(2)),
                child: Text(l10n.billFillCash,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: NeuColors.inkSoft)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NeuButton(
                onPressed: (_settling || balance != 0 || payments.isEmpty)
                    ? null
                    : () => _settle(order, shop),
                child: Text(l10n.billSettle,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: NeuColors.accentDark)),
              ),
            ),
          ]),
          if (existing != null) ...[
            const SizedBox(height: 18),
            SectionTitle('${l10n.billNumberLabel} ${existing.number}'),
            if (existing.voided)
              NeuBox(
                inset: true,
                child: Text('${l10n.billVoided} · ${existing.voidReason}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: NeuColors.warn)),
              ),
            Row(children: [
              Expanded(
                child: NeuButton(
                  onPressed: existing.voided
                      ? null
                      : () => _print(existing, order, reprint: true),
                  child: Text(l10n.billReprint,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeuColors.inkSoft)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeuButton(
                  onPressed: () => _share(existing, order),
                  onLongPress: () => _shareText(existing, order),
                  child: Text(l10n.billShare,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeuColors.inkSoft)),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: NeuButton(
                  onPressed: () => _preview(existing, order),
                  child: Text(l10n.billPreview,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeuColors.inkSoft)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeuButton(
                  onPressed: () => _whatsapp(existing, order),
                  child: Text(l10n.billWhatsapp,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeuColors.inkSoft)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeuButton(
                  onPressed: existing.voided ? null : () => _void(existing),
                  child: Text(l10n.billVoid,
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: NeuColors.warn)),
                ),
              ),
            ]),
            if (existing.audit.isNotEmpty) ...[
              const SizedBox(height: 16),
              SectionTitle(l10n.billAudit),
              NeuBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final a in existing.audit.reversed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          [
                            DateTime.fromMillisecondsSinceEpoch(a.ts)
                                .toIso8601String()
                                .substring(0, 16)
                                .replaceFirst('T', ' '),
                            a.action,
                            if (a.target.isNotEmpty) a.target,
                            if (a.reason.isNotEmpty) a.reason,
                          ].join(' · '),
                          style:
                              TextStyle(fontSize: 13, color: NeuColors.inkSoft),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final int paise;
  final bool strong;

  const _TotalRow(
      {required this.label, required this.paise, this.strong = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: strong ? 16 : 14,
                    fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
                    color: strong ? NeuColors.ink : NeuColors.inkSoft)),
          ),
          Text(money(paise),
              style: TextStyle(
                  fontSize: strong ? 18 : 14,
                  fontWeight: strong ? FontWeight.w800 : FontWeight.w700,
                  color: strong ? NeuColors.accentDark : NeuColors.ink)),
        ]),
      );
}
