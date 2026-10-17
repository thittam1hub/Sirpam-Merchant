import 'dart:convert';
import 'dart:ui' show Locale;
import 'package:crypto/crypto.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';

class DayRow {
  final DateTime day;
  final int cashPaise;
  final int upiPaise;
  final int creditPaise;
  const DayRow(this.day, this.cashPaise, this.upiPaise, this.creditPaise);
  int get totalPaise => cashPaise + upiPaise + creditPaise;
}

class LoanReportData {
  final List<DayRow> days;
  final int totalPaise;
  final int digitalPaise;
  final int cashPaise;
  final int creditPaise;
  final DateTime from;
  final DateTime to;

  const LoanReportData({
    required this.days,
    required this.totalPaise,
    required this.digitalPaise,
    required this.cashPaise,
    required this.creditPaise,
    required this.from,
    required this.to,
  });

  double get digitalRatio => totalPaise == 0 ? 0 : digitalPaise / totalPaise;
  double get avgDailyPaise => days.isEmpty ? 0 : totalPaise / days.length;
}

LoanReportData buildReportData(LedgerState ledger, {int windowDays = 90}) {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: windowDays - 1));
  final buckets = <String, List<int>>{};

  for (final s in ledger.sales) {
    final d = DateTime.fromMillisecondsSinceEpoch(s.ts);
    final day = DateTime(d.year, d.month, d.day);
    if (day.isBefore(from)) continue;
    final k = DateFormat('yyyy-MM-dd').format(day);
    final b = buckets.putIfAbsent(k, () => [0, 0, 0]);
    switch (s.mode) {
      case SaleMode.cash:
        b[0] += s.amountPaise;
      case SaleMode.upi:
        b[1] += s.amountPaise;
      case SaleMode.credit:
        b[2] += s.amountPaise;
    }
  }

  final days = buckets.entries
      .map((e) => DayRow(
          DateFormat('yyyy-MM-dd').parse(e.key), e.value[0], e.value[1], e.value[2]))
      .toList()
    ..sort((a, b) => a.day.compareTo(b.day));

  final cash = days.fold(0, (a, d) => a + d.cashPaise);
  final upi = days.fold(0, (a, d) => a + d.upiPaise);
  final credit = days.fold(0, (a, d) => a + d.creditPaise);

  return LoanReportData(
    days: days,
    totalPaise: cash + upi + credit,
    digitalPaise: upi,
    cashPaise: cash,
    creditPaise: credit,
    from: from,
    to: now,
  );
}

String _money(int paise) =>
    NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ', decimalDigits: 2)
        .format(paise / 100.0);

/// Tamper-evident checksum over the exact figures printed in the PDF.
String reportChecksum(LoanReportData d, VendorSettings s) {
  final payload = jsonEncode({
    'stall': s.stallName,
    'owner': s.ownerName,
    'vpa': s.upiVpa,
    'from': d.from.toIso8601String(),
    'to': d.to.toIso8601String(),
    'total': d.totalPaise,
    'cash': d.cashPaise,
    'upi': d.digitalPaise,
    'credit': d.creditPaise,
    'days': d.days
        .map((r) => [
              DateFormat('yyyy-MM-dd').format(r.day),
              r.cashPaise,
              r.upiPaise,
              r.creditPaise
            ])
        .toList(),
  });
  return sha256.convert(utf8.encode(payload)).toString();
}

/// Builds the A4 localized business-loan sales proof.
Future<Uint8List> buildLoanReportPdf(
    LoanReportData d, VendorSettings s) async {
  final l10n = lookupAppLocalizations(Locale(s.languageCode));
  final doc = pw.Document(
    title: 'VendorOS Business Sales Report',
    author: s.stallName.isEmpty ? 'VendorOS' : s.stallName,
  );

  // Tamil-capable font for the vernacular headings.
  pw.Font? tamil;
  try {
    final data =
        await rootBundle.load('assets/fonts/NotoSansTamil-Regular.ttf');
    tamil = pw.Font.ttf(data);
  } catch (_) {
    tamil = null; // fall back to Latin-only rendering
  }

  final checksum = reportChecksum(d, s);
  final df = DateFormat('dd MMM yyyy');
  const ink = PdfColor.fromInt(0xFF1A2233);
  const rule = PdfColor.fromInt(0xFFBAC5D5);

  pw.Widget kv(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Row(children: [
          pw.SizedBox(
              width: 150,
              child: pw.Text(k,
                  style: const pw.TextStyle(fontSize: 10, color: ink))),
          pw.Text(v,
              style: pw.TextStyle(
                  fontSize: 10, fontWeight: pw.FontWeight.bold, color: ink)),
        ]),
      );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 44),
      footer: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Divider(color: rule, thickness: 0.5),
          pw.Text('SHA-256 verification: $checksum',
              style: const pw.TextStyle(fontSize: 6.5)),
          pw.SizedBox(height: 2),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Self-declared record generated by VendorOS from the vendor\'s own daily entries.',
                  style: const pw.TextStyle(fontSize: 6.5)),
              pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                  style: const pw.TextStyle(fontSize: 6.5)),
            ],
          ),
        ],
      ),
      build: (ctx) => [
        if (tamil != null)
          pw.Text(l10n.loanReportHeading,
              style: pw.TextStyle(
                  font: tamil, fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('BUSINESS SALES PROOF',
            style: pw.TextStyle(
                fontSize: 15, fontWeight: pw.FontWeight.bold, color: ink)),
        pw.SizedBox(height: 10),
        kv('Stall / Business', s.stallName.isEmpty ? '—' : s.stallName),
        kv('Proprietor', s.ownerName.isEmpty ? '—' : s.ownerName),
        kv('UPI VPA', s.upiVpa.isEmpty ? '—' : s.upiVpa),
        kv('Mobile', s.phone.isEmpty ? '—' : s.phone),
        kv('Period', '${df.format(d.from)}  to  ${df.format(d.to)}'),
        kv('Generated', DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())),
        pw.SizedBox(height: 14),
        pw.Text('SUMMARY',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: rule, width: 0.5),
          children: [
            _row(['Metric', 'Value'], header: true),
            _row(['Total turnover', _money(d.totalPaise)]),
            _row(['Cash collection', _money(d.cashPaise)]),
            _row(['Digital (UPI) collection', _money(d.digitalPaise)]),
            _row(['Credit issued', _money(d.creditPaise)]),
            _row([
              'Digital share of turnover',
              '${(d.digitalRatio * 100).toStringAsFixed(1)} %'
            ]),
            _row(['Days with recorded sales', d.days.length.toString()]),
            _row([
              'Average daily turnover',
              _money(d.avgDailyPaise.round())
            ]),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text('DAILY TURNOVER',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: rule, width: 0.5),
          children: [
            _row(['Date', 'Cash', 'UPI', 'Credit', 'Total'], header: true),
            ...d.days.map((r) => _row([
                  df.format(r.day),
                  _money(r.cashPaise),
                  _money(r.upiPaise),
                  _money(r.creditPaise),
                  _money(r.totalPaise),
                ])),
          ],
        ),
      ],
    ),
  );

  return doc.save();
}

pw.TableRow _row(List<String> cells, {bool header = false}) => pw.TableRow(
      decoration: header
          ? const pw.BoxDecoration(color: PdfColor(0.93, 0.945, 0.968))
          : null,
      children: cells
          .map((c) => pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(c,
                    style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight:
                            header ? pw.FontWeight.bold : pw.FontWeight.normal)),
              ))
          .toList(),
    );
