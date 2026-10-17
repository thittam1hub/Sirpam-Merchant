import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../expenses/application/expense_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/domain/order.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../domain/admin_reports.dart';
import 'admin_widgets.dart';

/// The owner's back office: today in one card, and the four reports that
/// answer "where did the money go?".
class AdminHubPage extends ConsumerWidget {
  const AdminHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final orders = ref.watch(orderProvider);
    final expenses = ref.watch(expenseProvider);
    final today = dayKey(DateTime.now());
    final summary = buildDaySummary(
      day: today,
      bills: orders.bills,
      orders: orders.orders,
      expenses: expenses.expenses,
      close: expenses.closeFor(today),
    );

    final lines = <(String, String)>[
      (l10n.adminSummaryBills, '${summary.bills}'),
      (l10n.adminSummarySales, money(summary.salesPaise)),
      (l10n.adminSummaryCash, money(summary.cashPaise)),
      (l10n.adminSummaryUpi, money(summary.upiPaise)),
      (l10n.adminSummaryCredit, money(summary.creditPaise)),
      (l10n.adminSummaryDiscount, money(summary.discountPaise)),
      (l10n.adminSummarySpend, money(summary.expensePaise)),
      if (summary.cashDiffPaise != 0)
        (l10n.adminSummaryCashDiff, money(summary.cashDiffPaise)),
      if (summary.topItems.isNotEmpty)
        (
          l10n.adminSummaryTop,
          summary.topItems.map((e) => '${e.$1} ×${e.$2}').join(', ')
        ),
    ];

    Future<void> share() => launchUrl(
          ShareLinks.whatsapp(
              message: '${l10n.adminSummaryTitle} · $today\n'
                  '${lines.map((l) => '${l.$1}: ${l.$2}').join('\n')}'),
          mode: LaunchMode.externalApplication,
        );

    final tiles = <(String, String, IconData, String, Permission)>[
      (
        l10n.adminExceptionsTitle,
        l10n.adminExceptionsSubtitle,
        Icons.report_gmailerrorred_rounded,
        AppPaths.adminExceptions,
        Permission.viewAudit,
      ),
      (
        l10n.adminStaffTitle,
        l10n.adminStaffSubtitle,
        Icons.groups_2_rounded,
        AppPaths.adminStaff,
        Permission.viewStaffReport,
      ),
      (
        l10n.adminCashTitle,
        l10n.adminCashSubtitle,
        Icons.savings_rounded,
        AppPaths.adminCash,
        Permission.viewCashBook,
      ),
      (
        l10n.adminItemsTitle,
        l10n.adminItemsSubtitle,
        Icons.inventory_2_rounded,
        AppPaths.adminItems,
        Permission.viewReports,
      ),
      (
        l10n.adminShopsTitle,
        l10n.adminShopsSubtitle,
        Icons.storefront_rounded,
        AppPaths.adminShops,
        Permission.viewDayTotals,
      ),
    ];

    return DetailScaffold(
      title: l10n.adminTitle,
      subtitle: l10n.adminSubtitle,
      fallbackLocation: AppPaths.more,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            NeuBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text('${l10n.adminSummaryTitle} · $today',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: NeuColors.ink)),
                    ),
                    IconButton(
                      tooltip: l10n.adminShare,
                      icon: const Icon(Icons.ios_share_rounded, size: 20),
                      onPressed: share,
                    ),
                  ]),
                  for (final l in lines) AdminStatRow(l.$1, l.$2),
                  const SizedBox(height: 8),
                  NeuTextButton(
                      label: l10n.adminSummarySend,
                      color: NeuColors.accentDark,
                      onPressed: share),
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (final t in tiles)
              if (ref.allows(t.$5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    onTap: () => context.push(t.$4),
                    child: Row(children: [
                      Icon(t.$3, color: NeuColors.accentDark),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.$1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                            Text(t.$2,
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: NeuColors.inkSoft),
                    ]),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
