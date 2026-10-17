import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../backup/domain/csv_export.dart';
import '../../orders/application/order_controller.dart';
import '../domain/tax_report.dart';

/// Month-wise GST summary: taxable value and CGST/SGST/IGST per rate, with a
/// one-tap spreadsheet the vendor can send to their accountant.
class TaxReportPage extends ConsumerStatefulWidget {
  const TaxReportPage({super.key});

  @override
  ConsumerState<TaxReportPage> createState() => _TaxReportPageState();
}

class _TaxReportPageState extends ConsumerState<TaxReportPage> {
  String? _month;

  String _monthLabel(BuildContext context, String month) {
    final parts = month.split('-');
    final year = int.tryParse(parts.first) ?? 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
    return DateFormat.yMMMM(Localizations.localeOf(context).toString())
        .format(DateTime(year, m));
  }

  Future<void> _share(GstMonthSummary summary) async {
    final l10n = context.l10n;
    final csv = csvTable(
      [
        l10n.gstColMonth,
        l10n.gstColRate,
        l10n.gstColTaxable,
        l10n.billCgst,
        l10n.billSgst,
        l10n.billIgst,
        l10n.gstColTax,
      ],
      gstCsvRows(summary),
    );
    final name = 'gst-${summary.month}.csv';
    await Share.shareXFiles(
      [
        XFile.fromData(
          utf8.encode(csv),
          name: name,
          mimeType: 'text/csv',
        ),
      ],
      subject: l10n.gstShareSubject(summary.month),
      fileNameOverrides: [name],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final months =
        monthlyGstSummary(ref.watch(orderProvider.select((s) => s.bills)));
    final selected = months.isEmpty
        ? null
        : months.firstWhere((m) => m.month == _month,
            orElse: () => months.first);

    return DetailScaffold(
      title: l10n.gstReportTitle,
      subtitle: l10n.gstReportSubtitle,
      fallbackLocation: AppPaths.settings,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 8, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: selected == null
                ? NeuBox(
                    child: Text(
                      l10n.gstReportEmpty,
                      style: TextStyle(fontSize: 15, color: NeuColors.inkSoft),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 52,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: months.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            final m = months[i];
                            return NeuButton(
                              selected: m.month == selected.month,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minHeight: 44,
                              onPressed: () =>
                                  setState(() => _month = m.month),
                              child: Text(
                                _monthLabel(context, m.month),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.ink,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      NeuBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _row(l10n.gstBills, '${selected.billCount}'),
                            _row(l10n.gstSales,
                                _money(selected.totalPaise)),
                            _row(l10n.gstColTaxable,
                                _money(selected.taxablePaise)),
                            const Divider(height: 22),
                            if (selected.cgstPaise > 0)
                              _row(l10n.billCgst, _money(selected.cgstPaise)),
                            if (selected.sgstPaise > 0)
                              _row(l10n.billSgst, _money(selected.sgstPaise)),
                            if (selected.igstPaise > 0)
                              _row(l10n.billIgst, _money(selected.igstPaise)),
                            _row(l10n.gstColTax, _money(selected.taxPaise),
                                bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      NeuBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.gstByRate,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final slab in selected.slabs)
                              _row(
                                '${slab.rateLabel}%',
                                '${_money(slab.taxablePaise)}  ·  '
                                    '${_money(slab.taxPaise)}',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      NeuButton(
                        onPressed: () => _share(selected),
                        child: Text(
                          l10n.gstShareAction,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: NeuColors.accentDark,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static String _money(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: NeuColors.inkSoft),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: bold ? 17 : 15,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                color: NeuColors.ink,
              ),
            ),
          ],
        ),
      );
}
