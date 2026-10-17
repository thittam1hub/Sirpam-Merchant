/// Month-wise GST summary — the sheet an accountant asks for at filing time.
///
/// Pure integer-paise aggregation over already-issued bills: no Flutter, no
/// storage, no translation. Voided bills never count.
library;

import 'bill.dart';
import 'tax.dart';

/// One month of tax, split the way GSTR-3B wants it.
class GstMonthSummary {
  /// `yyyy-MM` of the trading month.
  final String month;
  final int billCount;

  /// Money actually collected across those bills (tax included).
  final int totalPaise;

  /// Value before tax, summed over every slab.
  final int taxablePaise;
  final int cgstPaise;
  final int sgstPaise;
  final int igstPaise;

  /// Per-rate breakdown, ordered by rate ascending.
  final List<TaxSlab> slabs;

  const GstMonthSummary({
    required this.month,
    this.billCount = 0,
    this.totalPaise = 0,
    this.taxablePaise = 0,
    this.cgstPaise = 0,
    this.sgstPaise = 0,
    this.igstPaise = 0,
    this.slabs = const [],
  });

  int get taxPaise => cgstPaise + sgstPaise + igstPaise;

  /// `2026-09` -> `9`, so callers can name the month in the vendor's language.
  int get monthNumber => int.tryParse(month.split('-').last) ?? 0;
  int get year => int.tryParse(month.split('-').first) ?? 0;
}

/// Groups bills by trading month, newest month first.
List<GstMonthSummary> monthlyGstSummary(Iterable<Bill> bills) {
  final byMonth = <String, List<Bill>>{};
  for (final bill in bills) {
    if (bill.voided) continue;
    if (bill.day.length < 7) continue;
    byMonth.putIfAbsent(bill.day.substring(0, 7), () => []).add(bill);
  }

  final months = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final month in months) _summarise(month, byMonth[month]!),
  ];
}

GstMonthSummary _summarise(String month, List<Bill> bills) {
  final byRate = <int, TaxSlab>{};
  var total = 0;
  for (final bill in bills) {
    total += bill.totalPaise;
    for (final slab in bill.slabs) {
      final prev = byRate[slab.ratePermille];
      byRate[slab.ratePermille] = TaxSlab(
        ratePermille: slab.ratePermille,
        taxablePaise: (prev?.taxablePaise ?? 0) + slab.taxablePaise,
        cgstPaise: (prev?.cgstPaise ?? 0) + slab.cgstPaise,
        sgstPaise: (prev?.sgstPaise ?? 0) + slab.sgstPaise,
        igstPaise: (prev?.igstPaise ?? 0) + slab.igstPaise,
      );
    }
  }

  final slabs = byRate.values.toList()
    ..sort((a, b) => a.ratePermille.compareTo(b.ratePermille));
  return GstMonthSummary(
    month: month,
    billCount: bills.length,
    totalPaise: total,
    taxablePaise: slabs.fold(0, (a, s) => a + s.taxablePaise),
    cgstPaise: slabs.fold(0, (a, s) => a + s.cgstPaise),
    sgstPaise: slabs.fold(0, (a, s) => a + s.sgstPaise),
    igstPaise: slabs.fold(0, (a, s) => a + s.igstPaise),
    slabs: slabs,
  );
}

/// Rows for the spreadsheet an accountant opens: one line per rate, then a
/// total line. Headers arrive already translated.
List<List<Object?>> gstCsvRows(GstMonthSummary summary) {
  String rupees(int paise) => (paise / 100).toStringAsFixed(2);
  return [
    for (final slab in summary.slabs)
      [
        summary.month,
        '${slab.rateLabel}%',
        rupees(slab.taxablePaise),
        rupees(slab.cgstPaise),
        rupees(slab.sgstPaise),
        rupees(slab.igstPaise),
        rupees(slab.taxPaise),
      ],
    [
      summary.month,
      'TOTAL',
      rupees(summary.taxablePaise),
      rupees(summary.cgstPaise),
      rupees(summary.sgstPaise),
      rupees(summary.igstPaise),
      rupees(summary.taxPaise),
    ],
  ];
}
