import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../ledger/application/ledger_controller.dart';
import '../application/loan_report.dart';

class ReportPage extends ConsumerStatefulWidget {
  /// Deep-link driven window: `/report?window=30|60|90`.
  final int windowDays;
  const ReportPage({super.key, this.windowDays = 90});
  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  late int _window = widget.windowDays;
  bool _busy = false;

  @override
  void didUpdateWidget(covariant ReportPage old) {
    super.didUpdateWidget(old);
    if (old.windowDays != widget.windowDays) _window = widget.windowDays;
  }

  void _setWindow(int w) {
    if (w == _window) return;
    setState(() => _window = w);
    // Keep the URL shareable/restorable without growing the back stack.
    context.replace(AppRoutes.report(windowDays: w));
  }


  Future<void> _export({required bool share}) async {
    setState(() => _busy = true);
    try {
      final data = buildReportData(ref.read(ledgerProvider), windowDays: _window);
      final settings = ref.read(settingsProvider);
      final bytes = await buildLoanReportPdf(data, settings);
      final name =
          'VendorOS-Sales-Proof-${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
      if (share) {
        await Printing.sharePdf(bytes: bytes, filename: name);
      } else {
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.reportFailed('$e'))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final settings = ref.watch(settingsProvider);
    final data = buildReportData(ledger, windowDays: _window);
    final money = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return DetailScaffold(
      title: l10n.menuLoanReport,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            child: Row(
              children: [
                for (final w in [30, 60, 90]) ...[
                  Expanded(
                    child: NeuButton(
                      color: _window == w ? NeuColors.inset : null,
                      onPressed: () => _setWindow(w),
                      child: Text(l10n.daysWindow(w),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: _window == w
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: _window == w
                                  ? NeuColors.accentDark
                                  : NeuColors.inkSoft)),
                    ),
                  ),
                  if (w != 90) const SizedBox(width: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              children: [
                Text(l10n.totalBusiness,
                    style: TextStyle(fontSize: 15, color: NeuColors.inkSoft)),
                AnimatedMoney(data.totalPaise / 100,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.ink)),
                const SizedBox(height: 16),
                _Line(l10n.modeCash, money.format(data.cashPaise / 100)),
                _Line('UPI', money.format(data.digitalPaise / 100)),
                _Line(l10n.modeCredit, money.format(data.creditPaise / 100)),
                _Line(l10n.digitalShare,
                    '${(data.digitalRatio * 100).toStringAsFixed(1)} %'),
                _Line(l10n.avgDailyIncome,
                    money.format(data.avgDailyPaise / 100)),
                _Line(l10n.recordedDays, l10n.daysWindow(data.days.length)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          NeuBox(
            inset: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sha256Checksum,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
                const SizedBox(height: 6),
                SelectableText(
                  reportChecksum(data, settings),
                  style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: NeuColors.inkSoft,
                      fontFeatures: const [FontFeature.tabularFigures()]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (data.days.isEmpty)
            Text(
              l10n.noSalesYet,
              style: TextStyle(fontSize: 14, color: NeuColors.warn),
            )
          else
            Row(
              children: [
                Expanded(
                  child: NeuButton(
                    onPressed: _busy ? null : () => _export(share: false),
                    child: Text(_busy ? '…' : l10n.viewPdf,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.ink)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeuButton(
                    onPressed: _busy ? null : () => _export(share: true),
                    child: Text(_busy ? '…' : l10n.sendToBank,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String k;
  final String v;
  const _Line(this.k, this.v);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k,
                style:
                    TextStyle(fontSize: 15, color: NeuColors.inkSoft)),
            Text(v,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.ink)),
          ],
        ),
      );
}
