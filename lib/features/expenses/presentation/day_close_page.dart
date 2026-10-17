import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../analytics/domain/insights.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/day_close_report.dart';
import '../application/expense_controller.dart';
import '../domain/expense.dart';

/// End of day: what came in, what went out, what should be in the box.
class DayClosePage extends ConsumerStatefulWidget {
  const DayClosePage({super.key});

  @override
  ConsumerState<DayClosePage> createState() => _DayClosePageState();
}

class _DayClosePageState extends ConsumerState<DayClosePage> {
  final _counted = TextEditingController();
  final _opening = TextEditingController();
  bool _openingPrefilled = false;
  int? _difference;
  bool _busy = false;

  int get _openingPaise {
    final v = double.tryParse(_opening.text.trim());
    return v == null || v < 0 ? 0 : (v * 100).round();
  }

  @override
  void dispose() {
    _counted.dispose();
    _opening.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final costs = ref.watch(expenseProvider);
    final inv = ref.watch(inventoryProvider);
    final now = DateTime.now();
    final midnight =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    final cash = ledger.paiseForMode(SaleMode.cash, todayOnly: true);
    final upi = ledger.paiseForMode(SaleMode.upi, todayOnly: true);
    final credit = ledger.paiseForMode(SaleMode.credit, todayOnly: true);
    final collected = ledger.repayments
        .where((r) => r.ts >= midnight)
        .fold(0, (a, r) => a + r.amountPaise);
    final expenses = costs.todayPaise;
    final day = DateFormat('yyyy-MM-dd').format(now);
    final saved = costs.closeFor(day);
    if (!_openingPrefilled) {
      // Yesterday's counted cash is this morning's float unless told otherwise.
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(now.subtract(const Duration(days: 1)));
      final float = saved?.openingCashPaise ??
          costs.closeFor(yesterday)?.countedCashPaise ??
          0;
      if (float > 0) _opening.text = (float / 100).toStringAsFixed(2);
      _openingPrefilled = true;
    }
    final opening = _openingPaise;
    final expected = Insights.expectedCashPaise(
      cashSalesPaise: cash,
      collectedPaise: collected,
      expensePaise: expenses,
      openingCashPaise: opening,
    );
    final wastage = inv.wastagePaise(sinceMs: midnight);
    final profit = inv.profitPaise(sinceMs: midnight) - expenses;
    final orders = ref.watch(orderProvider.notifier).summaryFor(day);

    Future<void> save() async {
      final v = double.tryParse(_counted.text.trim());
      if (v == null || v < 0) return;
      final counted = (v * 100).round();
      final diff = counted - expected;
      final allowed = await ref.guard(context, Permission.closeDay,
          amountPaise: counted, action: 'day.close', refType: 'day', refId: day);
      if (!allowed.ok || !mounted) return;

      // The variance is only posted once per day: a second close of the same
      // day corrects the snapshot without booking the difference twice.
      final alreadyPosted = saved?.variancePosted ?? false;
      if (diff != 0 && !alreadyPosted) {
        if (diff < 0) {
          // Money missing from the box is a real cost of the day.
          await ref.read(expenseProvider.notifier).addExpense(
                amountPaise: -diff,
                kind: ExpenseKind.other,
                note: l10n.dayCloseShort(money(-diff)),
              );
        } else {
          // Extra cash is unrecorded takings; book it so the ledger balances.
          await ref.read(ledgerProvider.notifier).addSale(
                amountPaise: diff,
                mode: SaleMode.cash,
                item: l10n.dayCloseSurplus(money(diff)),
              );
        }
      }
      await ref.read(expenseProvider.notifier).saveDayClose(
            day: day,
            expectedCashPaise: expected,
            countedCashPaise: counted,
            openingCashPaise: opening,
            ordersTaken: orders.taken,
            ordersCancelled: orders.cancelled,
            billedPaise: orders.billedPaise,
            discountPaise: orders.discountPaise,
            taxPaise: orders.taxPaise,
            upiPaise: upi,
            creditPaise: credit,
            expensePaise: expenses,
            lastToken: orders.lastToken,
            variancePosted: alreadyPosted || diff != 0,
          );
      if (!context.mounted) return;
      setState(() => _difference = diff);
      FocusScope.of(context).unfocus();
      if (diff != 0 && !alreadyPosted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.dayCloseVariancePosted)));
      }
    }

    Future<void> exportPdf() async {
      final record = ref.read(expenseProvider).closeFor(day) ??
          DayClose(
            day: day,
            expectedCashPaise: expected,
            countedCashPaise: expected,
            openingCashPaise: opening,
            ts: DateTime.now().millisecondsSinceEpoch,
            ordersTaken: orders.taken,
            ordersCancelled: orders.cancelled,
            billedPaise: orders.billedPaise,
            discountPaise: orders.discountPaise,
            taxPaise: orders.taxPaise,
            upiPaise: upi,
            creditPaise: credit,
            expensePaise: expenses,
            lastToken: orders.lastToken,
          );
      setState(() => _busy = true);
      try {
        final bytes =
            await buildDayClosePdf(record, ref.read(settingsProvider));
        await Printing.sharePdf(
            bytes: bytes, filename: 'VendorOS-DayClose-$day.pdf');
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.dayCloseExportFailed)));
        }
      } finally {
        if (context.mounted) setState(() => _busy = false);
      }
    }

    return DetailScaffold(
      title: l10n.dayCloseTitle,
      subtitle: DateFormat('EEEE, d MMMM y').format(now),
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(children: [
              Text(l10n.dayCloseExpectedCash,
                  style:
                      TextStyle(fontSize: 15, color: NeuColors.inkSoft)),
              const SizedBox(height: 6),
              AnimatedMoney(expected / 100,
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
            ]),
          ),
          SectionTitle(l10n.dayCloseBreakdown),
          NeuBox(
            child: Column(children: [
              _Line(l10n.dayCloseOpeningCash, opening),
              _Line(l10n.modeCash, cash),
              _Line('UPI', upi, color: NeuColors.upi),
              _Line(l10n.modeCredit, credit, color: NeuColors.warn),
              _Line(l10n.dayCloseCollected, collected),
              _Line(l10n.expensesTitle, -expenses, color: NeuColors.danger),
              _Line(l10n.dayCloseWastage, -wastage, color: NeuColors.danger),
              const Divider(height: 24),
              _Line(l10n.dayCloseProfit, profit,
                  color: profit >= 0 ? NeuColors.accentDark : NeuColors.danger,
                  bold: true),
            ]),
          ),
          SectionTitle(l10n.dayCloseOrders),
          NeuBox(
            child: Column(children: [
              _Count(l10n.dayCloseOrdersTaken, '${orders.taken}'),
              _Count(l10n.dayCloseOrdersCancelled, '${orders.cancelled}',
                  color: NeuColors.danger),
              _Count(l10n.dayCloseOrdersOpen, '${orders.openCount}',
                  color: NeuColors.warn),
              _Line(l10n.dayCloseOrdersBilled, orders.billedPaise),
              _Line(l10n.dayCloseAvgTicket, orders.averageTicketPaise),
              _Line(l10n.dayCloseDiscounts, -orders.discountPaise,
                  color: NeuColors.danger),
              _Line(l10n.dayCloseTax, orders.taxPaise),
              _Count(l10n.dayCloseVoided, '${orders.voidedCount}',
                  color: NeuColors.danger),
              _Count(l10n.dayCloseLastToken, '${orders.lastToken}'),
            ]),
          ),
          SectionTitle(l10n.dayCloseCount),
          LabeledField(
            label: l10n.dayCloseOpeningCash,
            controller: _opening,
            prefixText: '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          LabeledField(
            label: l10n.dayCloseCountedCash,
            controller: _counted,
            prefixText: '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
          ),
          NeuTextButton(
              label: l10n.dayCloseSave,
              color: NeuColors.accentDark,
              onPressed: save),
          const SizedBox(height: 10),
          NeuTextButton(
              label: l10n.dayCloseExport,
              onPressed: () { if (!_busy) exportPdf(); }),
          if (_difference != null || saved != null) ...[
            const SizedBox(height: 14),
            NeuBox(
              inset: true,
              child: Builder(builder: (_) {
                final diff = _difference ?? saved!.differencePaise;
                if (diff == 0) {
                  return Text(l10n.dayCloseMatch,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeuColors.accentDark));
                }
                return Text(
                  diff > 0
                      ? l10n.dayCloseSurplus(money(diff))
                      : l10n.dayCloseShort(money(-diff)),
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: NeuColors.warn),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final int paise;
  final Color? color;
  final bool bold;
  const _Line(this.label, this.paise,
      {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: bold ? 16 : 14,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                    color: NeuColors.inkSoft)),
          ),
          Text(money(paise),
              style: TextStyle(
                  fontSize: bold ? 18 : 15,
                  fontWeight: FontWeight.w800,
                  color: color)),
        ]),
      );
}

class _Count extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Count(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: NeuColors.inkSoft)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        ]),
      );
}
