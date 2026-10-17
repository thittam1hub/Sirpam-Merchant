import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../../products/presentation/inventory_widgets.dart';

/// How a customer clears an outstanding credit balance.
enum SettleMethod { cash, upi, loan }

/// Settles a credit customer's running balance by cash, UPI or a fresh loan,
/// posting every leg to the ledger so the day book stays truthful.
class SettlePage extends ConsumerStatefulWidget {
  final String customer;
  const SettlePage({super.key, required this.customer});

  @override
  ConsumerState<SettlePage> createState() => _SettlePageState();
}

class _SettlePageState extends ConsumerState<SettlePage> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  SettleMethod _method = SettleMethod.cash;
  bool _prefilled = false;
  bool _busy = false;
  bool _settled = false;

  /// A typed note or a non-default method means the vendor started something;
  /// the amount is pre-filled, so it alone is not treated as unsaved input.
  bool get _dirty =>
      !_settled &&
      !_busy &&
      (_note.text.trim().isNotEmpty || _method != SettleMethod.cash);

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  int get _outstandingPaise =>
      ref.read(ledgerProvider).udhaarBalances[widget.customer] ?? 0;

  int get _enteredPaise {
    final v = double.tryParse(_amount.text.trim());
    if (v == null || v <= 0) return 0;
    return (v * 100).round();
  }

  Future<void> _askUpi() async {
    final l10n = context.l10n;
    final settings = ref.read(settingsProvider);
    if (settings.upiVpa.isEmpty) return;
    final payeeName = settings.stallName.isEmpty
        ? l10n.defaultStallName
        : settings.stallName;
    final uri = ShareLinks.upiPay(
      vpa: settings.upiVpa,
      payeeName: payeeName,
      amountRupees: _enteredPaise / 100,
      note: l10n.creditNote(widget.customer),
    );
    unawaited(HapticFeedback.mediumImpact());
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.cannotOpen(uri.scheme))));
    }
  }

  Future<void> _settle() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final paise = _enteredPaise;
    final outstanding = _outstandingPaise;
    if (paise <= 0 || _busy) return;
    if (paise > outstanding) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.settleTooMuch(
              (outstanding / 100).toStringAsFixed(2)))));
      return;
    }
    final allowed = await ref.guard(context, Permission.settleCredit,
        amountPaise: paise,
        action: 'credit.settle',
        refType: 'customer',
        refId: widget.customer);
    if (!allowed.ok || !mounted) return;
    setState(() => _busy = true);

    final ledger = ref.read(ledgerProvider.notifier);
    final note = _note.text.trim();
    await ledger.addRepayment(
      customer: widget.customer,
      amountPaise: paise,
      method: _method.name,
      note: note,
    );
    if (_method == SettleMethod.cash || _method == SettleMethod.upi) {
      // Money actually came in: book it as today's takings.
      await ledger.addSale(
        amountPaise: paise,
        mode: _method == SettleMethod.cash ? SaleMode.cash : SaleMode.upi,
        item: l10n.settleLedgerItem(widget.customer),
        customer: widget.customer,
      );
    } else {
      // Rolled into a new loan: the old balance closes, a fresh credit opens.
      await ledger.addSale(
        amountPaise: paise,
        mode: SaleMode.credit,
        item: l10n.settleLoanItem(widget.customer),
        customer: widget.customer,
      );
    }
    unawaited(HapticFeedback.mediumImpact());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _settled = true;
    });
    messenger.showSnackBar(SnackBar(content: Text(l10n.settleDone)));
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.udhaar());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final settings = ref.watch(settingsProvider);
    final outstanding = ledger.udhaarBalances[widget.customer] ?? 0;
    if (!_prefilled && outstanding > 0) {
      _prefilled = true;
      _amount.text = (outstanding / 100).toStringAsFixed(2);
    }
    final history = ledger.repayments
        .where((r) => r.customer == widget.customer)
        .take(6)
        .toList();

    return DetailScaffold(
      title: l10n.settleTitle,
      subtitle: widget.customer,
      fallbackLocation: AppPaths.udhaar,
      isDirty: () => _dirty,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Column(children: [
              Text(l10n.totalOutstanding,
                  style: TextStyle(
                      fontSize: 15, color: NeuColors.inkSoft)),
              const SizedBox(height: 4),
              AnimatedMoney(outstanding / 100,
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.warn)),
            ]),
          ),
          SectionTitle(l10n.settleAmountSection),
          LabeledField(
            label: l10n.settleAmount,
            controller: _amount,
            prefixText: '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Row(children: [
            for (final m in SettleMethod.values) ...[
              Expanded(
                child: NeuButton(
                  selected: _method == m,
                  onPressed: () => setState(() => _method = m),
                  child: Text(
                    switch (m) {
                      SettleMethod.cash => l10n.settleCash,
                      SettleMethod.upi => l10n.settleUpi,
                      SettleMethod.loan => l10n.settleLoan,
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _method == m
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft),
                  ),
                ),
              ),
              if (m != SettleMethod.values.last) const SizedBox(width: 10),
            ],
          ]),
          const SizedBox(height: 12),
          LabeledField(label: l10n.settleNote, controller: _note),
          const SizedBox(height: 8),
          Text(
            switch (_method) {
              SettleMethod.cash => l10n.settleCashHint,
              SettleMethod.upi => l10n.settleUpiHint,
              SettleMethod.loan => l10n.settleLoanHint,
            },
            style: TextStyle(fontSize: 13, color: NeuColors.inkSoft),
          ),
          const SizedBox(height: 16),
          Row(children: [
            if (_method == SettleMethod.upi) ...[
              Expanded(
                child: NeuButton(
                  onPressed:
                      settings.upiVpa.isEmpty || _enteredPaise <= 0
                          ? null
                          : _askUpi,
                  child: Text(l10n.askUpi,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.upi)),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: NeuButton(
                onPressed:
                    _enteredPaise <= 0 || outstanding <= 0 || _busy
                        ? null
                        : _settle,
                child: Text(l10n.settleConfirm,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.accentDark)),
              ),
            ),
          ]),
          if (history.isNotEmpty) ...[
            SectionTitle(l10n.settleHistory),
            ...history.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    inset: true,
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                switch (r.method) {
                                  'upi' => l10n.settleUpi,
                                  'loan' => l10n.settleLoan,
                                  _ => l10n.settleCash,
                                },
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            if (r.note.isNotEmpty)
                              Text(r.note,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      Text('₹ ${(r.amountPaise / 100).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: NeuColors.ink)),
                    ]),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
