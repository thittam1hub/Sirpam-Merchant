/// Spreadsheet exports the owner can hand to an accountant.
///
/// Pure string building: no Flutter, no storage, no translation. Callers pass
/// already-translated headers so the same code serves English and Tamil.
library;

import '../../billing/domain/bill.dart';
import '../../ledger/domain/sale.dart';
import '../../products/domain/inventory_models.dart';

/// Escapes one cell for RFC-4180 CSV.
String csvCell(Object? value) {
  final text = value?.toString() ?? '';
  final needsQuotes =
      text.contains(',') || text.contains('"') || text.contains('\n');
  final escaped = text.replaceAll('"', '""');
  return needsQuotes ? '"$escaped"' : escaped;
}

String csvLine(List<Object?> cells) => cells.map(csvCell).join(',');

/// A whole sheet. Excel opens UTF-8 correctly only with a byte-order mark, so
/// Tamil item names survive the round trip.
String csvTable(List<String> header, Iterable<List<Object?>> rows) {
  final buffer = StringBuffer('\uFEFF')..writeln(csvLine(header));
  for (final row in rows) {
    buffer.writeln(csvLine(row));
  }
  return buffer.toString();
}

/// `2026-09-10 18:42`, the form Indian spreadsheets sort correctly.
String csvDateTime(int epochMs) {
  final t = DateTime.fromMillisecondsSinceEpoch(epochMs);
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.year}-${two(t.month)}-${two(t.day)} '
      '${two(t.hour)}:${two(t.minute)}';
}

/// Rupees with two decimals — never a paise integer, which reads as 100x.
String csvRupees(int paise) => (paise / 100).toStringAsFixed(2);

class CsvExport {
  const CsvExport._();

  static String sales(List<Sale> rows, List<String> header) => csvTable(
        header,
        rows.map((s) => [
              csvDateTime(s.ts),
              s.item,
              s.mode.name,
              s.customer ?? '',
              csvRupees(s.amountPaise),
            ]),
      );

  static String bills(List<Bill> rows, List<String> header) => csvTable(
        header,
        rows.map((b) => [
              b.number,
              csvDateTime(b.ts),
              b.customer,
              csvRupees(b.subtotalPaise),
              csvRupees(b.discountPaise),
              csvRupees(b.taxPaise),
              csvRupees(b.totalPaise),
              b.payments.map((p) => p.mode.name).join(' + '),
              b.voided ? 'voided' : '',
            ]),
      );

  static String credit(Map<String, int> balances, List<String> header) {
    final names = balances.keys.toList()..sort();
    return csvTable(
      header,
      names.map((n) => [n, csvRupees(balances[n]!)]),
    );
  }

  static String stock(
    List<Product> products,
    Map<String, int> onHandMilli,
    List<String> header,
  ) =>
      csvTable(
        header,
        products.map((p) => [
              p.code,
              p.displayName,
              p.category,
              p.unit.name,
              ((onHandMilli[p.id] ?? 0) / 1000).toStringAsFixed(3),
              csvRupees(p.costPaise),
              csvRupees(p.pricePaise),
            ]),
      );
}
