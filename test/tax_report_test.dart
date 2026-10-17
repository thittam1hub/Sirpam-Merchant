import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/billing/domain/bill.dart';
import 'package:vendoros/features/billing/domain/tax.dart';
import 'package:vendoros/features/billing/domain/tax_report.dart';

Bill bill(
  String id,
  String day,
  int total, {
  bool voided = false,
  List<TaxSlab> slabs = const [],
}) =>
    Bill(
      id: id,
      orderId: 'o$id',
      number: id,
      day: day,
      sequence: 1,
      ts: 0,
      subtotalPaise: total,
      totalPaise: total,
      voided: voided,
      slabs: slabs,
    );

TaxSlab slab(int rate, int taxable, {int cgst = 0, int sgst = 0, int igst = 0}) =>
    TaxSlab(
      ratePermille: rate,
      taxablePaise: taxable,
      cgstPaise: cgst,
      sgstPaise: sgst,
      igstPaise: igst,
    );

void main() {
  group('monthly GST summary', () {
    test('groups by trading month, newest first', () {
      final months = monthlyGstSummary([
        bill('1', '2026-08-31', 10000),
        bill('2', '2026-09-01', 20000),
        bill('3', '2026-09-30', 30000),
      ]);
      expect(months.map((m) => m.month).toList(), ['2026-09', '2026-08']);
      expect(months.first.billCount, 2);
      expect(months.first.totalPaise, 50000);
      expect(months.first.monthNumber, 9);
      expect(months.first.year, 2026);
    });

    test('voided bills never count', () {
      final months = monthlyGstSummary([
        bill('1', '2026-09-02', 10000),
        bill('2', '2026-09-03', 90000, voided: true),
      ]);
      expect(months.single.billCount, 1);
      expect(months.single.totalPaise, 10000);
    });

    test('adds slabs of the same rate and sorts by rate', () {
      final months = monthlyGstSummary([
        bill('1', '2026-09-02', 11800, slabs: [
          slab(180, 10000, cgst: 900, sgst: 900),
          slab(50, 2000, cgst: 50, sgst: 50),
        ]),
        bill('2', '2026-09-04', 5900, slabs: [
          slab(180, 5000, cgst: 450, sgst: 450),
        ]),
      ]);
      final m = months.single;
      expect(m.slabs.map((s) => s.ratePermille).toList(), [50, 180]);
      expect(m.slabs.last.taxablePaise, 15000);
      expect(m.slabs.last.cgstPaise, 1350);
      expect(m.taxablePaise, 17000);
      expect(m.taxPaise, 2800);
      expect(m.igstPaise, 0);
    });

    test('interstate tax lands in IGST only', () {
      final m = monthlyGstSummary([
        bill('1', '2026-09-02', 11800, slabs: [slab(180, 10000, igst: 1800)]),
      ]).single;
      expect(m.igstPaise, 1800);
      expect(m.cgstPaise, 0);
      expect(m.taxPaise, 1800);
    });

    test('bills with an unusable day are skipped', () {
      expect(monthlyGstSummary([bill('1', '', 500)]), isEmpty);
    });
  });

  test('CSV rows list every slab then a total line', () {
    final m = monthlyGstSummary([
      bill('1', '2026-09-02', 11800, slabs: [
        slab(50, 2000, cgst: 50, sgst: 50),
        slab(180, 10000, cgst: 900, sgst: 900),
      ]),
    ]).single;
    final rows = gstCsvRows(m);
    expect(rows.length, 3);
    expect(rows.first[0], '2026-09');
    expect(rows.last[1], 'TOTAL');
    expect(rows.last[2], '120.00');
    expect(rows.last[6], '19.00');
  });
}
