import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../expenses/application/expense_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../domain/admin_reports.dart';
import 'admin_widgets.dart';

/// The cash box, day by day: what the books expected, what was counted, and
/// how far apart the two were.
class CashBookPage extends ConsumerStatefulWidget {
  const CashBookPage({super.key});

  @override
  ConsumerState<CashBookPage> createState() => _CashBookPageState();
}

class _CashBookPageState extends ConsumerState<CashBookPage> {
  AdminPeriod _period = AdminPeriod.month;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final closes = ref.watch(expenseProvider).closes;
    final book =
        buildCashBook(closes: closes, range: rangeFor(_period, DateTime.now()));

    return DetailScaffold(
      title: l10n.adminCashTitle,
      subtitle: l10n.adminCashSubtitle,
      fallbackLocation: AppPaths.admin,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            AdminPeriodBar(
                period: _period,
                onChanged: (p) => setState(() => _period = p)),
            const SizedBox(height: 16),
            NeuBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminStatRow(l10n.adminCashMatched, '${book.matchedDays}'),
                  AdminStatRow(l10n.adminCashShortDays, '${book.shortDays}',
                      valueColor: book.shortDays > 0 ? NeuColors.warn : null),
                  AdminStatRow(l10n.adminCashShort, money(book.shortPaise)),
                  AdminStatRow(l10n.adminCashOver, money(book.surplusPaise)),
                  AdminStatRow(
                    l10n.adminCashNet,
                    money(book.netPaise.abs()),
                    valueColor:
                        book.netPaise < 0 ? NeuColors.danger : NeuColors.ink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (book.days.isEmpty) const AdminEmpty(),
            for (final d in book.days)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(d.day,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        StatusPill(
                          d.differencePaise == 0
                              ? l10n.adminCashMatchedOne
                              : '${d.isShort ? l10n.adminCashShort : l10n.adminCashOver} '
                                  '${money(d.differencePaise.abs())}',
                          color: d.differencePaise == 0
                              ? NeuColors.accentDark
                              : (d.isShort ? NeuColors.danger : NeuColors.warn),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      AdminStatRow(
                          l10n.adminCashOpening, money(d.openingPaise)),
                      AdminStatRow(
                          l10n.adminCashExpected, money(d.expectedPaise)),
                      AdminStatRow(
                          l10n.adminCashCounted, money(d.countedPaise)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
