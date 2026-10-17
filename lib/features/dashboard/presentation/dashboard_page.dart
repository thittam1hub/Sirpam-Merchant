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
import '../../analytics/domain/insights.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../domain/dashboard_summary.dart';

/// One screen that answers "how is the shop doing right now?" — orders,
/// money still to collect, credit balances and stock — filtered by day,
/// week or month. Every card is also its own shareable link.
class DashboardPage extends ConsumerStatefulWidget {
  final InsightWindow initialWindow;

  /// When set, only this card is shown (a focused, shareable view).
  final DashboardSection? section;

  const DashboardPage({
    super.key,
    this.initialWindow = InsightWindow.day,
    this.section,
  });

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late InsightWindow _window = widget.initialWindow;

  void _select(InsightWindow w) {
    setState(() => _window = w);
    final section = widget.section;
    context.replace(section == null
        ? AppRoutes.dashboard(window: w.name)
        : AppRoutes.dashboardSection(section.name, window: w.name));
  }

  String _windowLabel(AppLocalizations l10n, InsightWindow w) => switch (w) {
        InsightWindow.day => l10n.windowDay,
        InsightWindow.week => l10n.windowWeek,
        InsightWindow.month => l10n.windowMonth,
        InsightWindow.year => l10n.windowYear,
      };

  String _sectionLabel(AppLocalizations l10n, DashboardSection s) =>
      switch (s) {
        DashboardSection.orders => l10n.dashboardOrders,
        DashboardSection.payments => l10n.dashboardPayments,
        DashboardSection.credit => l10n.dashboardCredit,
        DashboardSection.inventory => l10n.dashboardInventory,
      };

  Future<void> _share(String body) => launchUrl(
        ShareLinks.whatsapp(message: body),
        mode: LaunchMode.externalApplication,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final orders = ref.watch(orderProvider);
    final ledger = ref.watch(ledgerProvider);
    final inv = ref.watch(inventoryProvider);

    final s = Dashboard.build(
      window: _window,
      orders: orders.orders,
      bills: orders.bills,
      sales: ledger.sales,
      repayments: ledger.repayments,
      products: inv.products,
      batches: inv.batches,
      movements: inv.movements,
    );

    final sections = widget.section == null
        ? DashboardSection.values
        : [widget.section!];

    return DetailScaffold(
      title: widget.section == null
          ? l10n.dashboardTitle
          : _sectionLabel(l10n, widget.section!),
      subtitle: l10n.dashboardSubtitle,
      fallbackLocation:
          widget.section == null ? AppPaths.home : AppPaths.dashboard,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            Row(children: [
              for (final w in dashboardWindows) ...[
                Expanded(
                  child: NeuButton(
                    selected: _window == w,
                    minHeight: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    onPressed: () => _select(w),
                    child: Text(_windowLabel(l10n, w),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _window == w
                                ? NeuColors.accentDark
                                : NeuColors.inkSoft)),
                  ),
                ),
                if (w != dashboardWindows.last) const SizedBox(width: 8),
              ],
            ]),
            const SizedBox(height: 16),
            for (final section in sections) ...[
              _Card(
                title: _sectionLabel(l10n, section),
                onOpen: widget.section == null
                    ? () => context.push(AppRoutes.dashboardSection(
                        section.name,
                        window: _window.name))
                    : null,
                onShare: () => _share(_summaryText(l10n, s, section)),
                rows: _rows(l10n, s, section),
                footer: _footer(l10n, s, section),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  List<_Row> _rows(
      AppLocalizations l10n, DashboardSummary s, DashboardSection section) {
    switch (section) {
      case DashboardSection.orders:
        return [
          _Row(l10n.dashboardPlaced, '${s.orders.placed}'),
          _Row(l10n.dashboardServed, '${s.orders.served}'),
          _Row(l10n.dashboardCancelled, '${s.orders.cancelled}'),
          _Row(l10n.dashboardBilled, money(s.orders.billedPaise)),
          _Row(l10n.dashboardAvgBill, money(s.orders.avgBillPaise)),
        ];
      case DashboardSection.payments:
        return [
          _Row(l10n.dashboardOpenOrders,
              '${s.pending.openOrders} · ${money(s.pending.openValuePaise)}'),
          _Row(l10n.dashboardUnbilled,
              '${s.pending.unbilledOrders} · ${money(s.pending.unbilledPaise)}'),
          _Row(l10n.dashboardCreditGiven, money(s.pending.creditGivenPaise)),
          _Row(l10n.dashboardPendingTotal, money(s.pending.totalPaise)),
        ];
      case DashboardSection.credit:
        return [
          _Row(l10n.dashboardOutstanding, money(s.credit.outstandingPaise)),
          _Row(l10n.dashboardCustomers, '${s.credit.customers}'),
          _Row(l10n.dashboardCollected, money(s.credit.collectedPaise)),
          _Row(l10n.dashboardOldest, l10n.dashboardDays(s.credit.oldestDays)),
        ];
      case DashboardSection.inventory:
        return [
          _Row(l10n.dashboardStockValue, money(s.inventory.stockValuePaise)),
          _Row(l10n.dashboardLowStock, '${s.inventory.lowStockCount}'),
          _Row(l10n.dashboardExpiring, '${s.inventory.expiringCount}'),
          _Row(l10n.dashboardWastage, money(s.inventory.wastagePaise)),
          _Row(l10n.dashboardPurchases, money(s.inventory.purchasePaise)),
        ];
    }
  }

  String? _footer(
      AppLocalizations l10n, DashboardSummary s, DashboardSection section) {
    switch (section) {
      case DashboardSection.orders:
        return s.orders.topItems.isEmpty
            ? null
            : '${l10n.dashboardTopItems}: '
                '${s.orders.topItems.map((e) => e.key).join(', ')}';
      case DashboardSection.credit:
        return s.credit.top.isEmpty
            ? null
            : s.credit.top
                .map((e) => '${e.key} ${money(e.value)}')
                .join(' · ');
      case DashboardSection.inventory:
        return s.inventory.lowStockNames.isEmpty
            ? null
            : '${l10n.dashboardLowStock}: '
                '${s.inventory.lowStockNames.join(', ')}';
      case DashboardSection.payments:
        return null;
    }
  }

  String _summaryText(
      AppLocalizations l10n, DashboardSummary s, DashboardSection section) {
    final head = '${_sectionLabel(l10n, section)} · '
        '${_windowLabel(l10n, s.window)}';
    final lines =
        _rows(l10n, s, section).map((r) => '${r.label}: ${r.value}').join('\n');
    return '$head\n$lines';
  }
}

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);
}

class _Card extends StatelessWidget {
  final String title;
  final List<_Row> rows;
  final String? footer;
  final VoidCallback? onOpen;
  final VoidCallback onShare;

  const _Card({
    required this.title,
    required this.rows,
    required this.onShare,
    this.footer,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NeuBox(
      padding: const EdgeInsets.all(18),
      onTap: onOpen,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.ink)),
          ),
          NeuButton(
            minHeight: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            onPressed: onShare,
            child: Text(l10n.dashboardShare,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.accentDark)),
          ),
        ]),
        const SizedBox(height: 12),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              Expanded(
                child: Text(r.label,
                    style: TextStyle(
                        fontSize: 13.5, color: NeuColors.inkSoft)),
              ),
              Text(r.value,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.ink)),
            ]),
          ),
        if (footer != null) ...[
          const SizedBox(height: 10),
          Text(footer!,
              style: TextStyle(fontSize: 12.5, color: NeuColors.inkSoft)),
        ],
      ]),
    );
  }
}
