import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/ledger/application/ledger_controller.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';
import 'package:vendoros/features/report/application/loan_report.dart';

Sale _sale(int paise, SaleMode mode, {int daysAgo = 0}) {
  final t = DateTime.now().subtract(Duration(days: daysAgo));
  return Sale(
    id: '$paise-$mode-$daysAgo',
    ts: t.millisecondsSinceEpoch,
    amountPaise: paise,
    mode: mode,
    item: 'item',
    customer: mode == SaleMode.credit ? 'Ravi' : null,
  );
}

void main() {
  test('aggregates cash / upi / credit inside the window', () {
    final state = LedgerState(sales: [
      _sale(10000, SaleMode.cash),
      _sale(5000, SaleMode.upi),
      _sale(2500, SaleMode.credit),
      _sale(9900, SaleMode.cash, daysAgo: 5),
    ], loaded: true);

    final d = buildReportData(state, windowDays: 30);
    expect(d.cashPaise, 19900);
    expect(d.digitalPaise, 5000);
    expect(d.creditPaise, 2500);
    expect(d.totalPaise, 27400);
    expect(d.days.length, 2);
    expect(d.digitalRatio, closeTo(5000 / 27400, 1e-9));
  });

  test('excludes sales older than the window', () {
    final state = LedgerState(sales: [
      _sale(10000, SaleMode.cash, daysAgo: 45),
      _sale(1000, SaleMode.cash),
    ], loaded: true);

    final d = buildReportData(state, windowDays: 30);
    expect(d.totalPaise, 1000);
    expect(d.days.length, 1);
  });

  test('empty ledger yields a zeroed, safe report', () {
    final d = buildReportData(const LedgerState(loaded: true));
    expect(d.totalPaise, 0);
    expect(d.days, isEmpty);
    expect(d.digitalRatio, 0);
    expect(d.avgDailyPaise, 0);
  });
}
