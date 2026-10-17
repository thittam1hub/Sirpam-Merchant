import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../expenses/application/expense_controller.dart';
import '../../expenses/presentation/expenses_page.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/stock_math.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../domain/insights.dart';

/// Day / week / month / year view of turnover, costs and profit.
class InsightsPage extends ConsumerStatefulWidget {
  final InsightWindow initialWindow;
  const InsightsPage({super.key, this.initialWindow = InsightWindow.week});

  @override
  ConsumerState<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends ConsumerState<InsightsPage> {
  late InsightWindow _window = widget.initialWindow;

  void _select(InsightWindow w) {
    setState(() => _window = w);
    context.replace(AppRoutes.insights(window: w.name));
  }

  String _windowLabel(AppLocalizations l10n, InsightWindow w) => switch (w) {
        InsightWindow.day => l10n.windowDay,
        InsightWindow.week => l10n.windowWeek,
        InsightWindow.month => l10n.windowMonth,
        InsightWindow.year => l10n.windowYear,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final costs = ref.watch(expenseProvider);
    final inv = ref.watch(inventoryProvider);

    final s = Insights.summarize(
      window: _window,
      sales: ledger.sales,
      repayments: ledger.repayments,
      expenses: costs.expenses,
      movements: inv.movements,
      products: inv.products,
    );
    final thin = Insights.thinMargin(inv.products);
    final hours = Insights.hourly(ledger.sales);
    final peak = Insights.peakHour(hours);
    final staff = Insights.staffNeeded(peak);
    final heroes = Insights.heroItems(
        movements: inv.movements,
        products: inv.products,
        batches: inv.batches);

    final maxHour = hours.isEmpty
        ? 1
        : hours
            .map((h) => h.salesPaise)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1, 1 << 40);
    final maxBucket = s.buckets.isEmpty
        ? 1
        : s.buckets
            .map((b) => b.salesPaise)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1, 1 << 40);

    return DetailScaffold(
      title: l10n.insightsTitle,
      subtitle: l10n.insightsSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          Row(children: [
            for (final w in InsightWindow.values) ...[
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
              if (w != InsightWindow.year) const SizedBox(width: 8),
            ],
          ]),
          const SizedBox(height: 16),
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(children: [
              Text(l10n.insightsTurnover,
                  style:
                      TextStyle(fontSize: 15, color: NeuColors.inkSoft)),
              const SizedBox(height: 6),
              AnimatedMoney(s.salesPaise / 100,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
              const SizedBox(height: 16),
              Row(children: [
                _Metric(label: l10n.insightsCosts, paise: s.expensePaise,
                    color: NeuColors.danger),
                _Metric(
                    label: l10n.insightsProfit,
                    paise: s.netPaise,
                    color: s.netPaise >= 0
                        ? NeuColors.accentDark
                        : NeuColors.danger),
                _Metric(label: l10n.insightsAvgDay, paise: s.avgPerDayPaise),
              ]),
            ]),
          ),
          SectionTitle(l10n.insightsByDay),
          NeuBox(
            child: s.buckets.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(l10n.insightsEmpty,
                          style: TextStyle(color: NeuColors.inkSoft)),
                    ),
                  )
                : Column(
                    children: [
                      for (final b in s.buckets)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            SizedBox(
                              width: 54,
                              child: Text(DateFormat('d MMM').format(b.day),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: NeuColors.inkSoft)),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  value: b.salesPaise / maxBucket,
                                  backgroundColor: NeuColors.inset,
                                  valueColor: AlwaysStoppedAnimation(
                                      NeuColors.accent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(money(b.salesPaise),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                          ]),
                        ),
                      if (s.bestDay != null) ...[
                        const Divider(height: 22),
                        Row(children: [
                          Expanded(
                            child: Text(l10n.insightsBestDay,
                                style: TextStyle(
                                    fontSize: 13, color: NeuColors.inkSoft)),
                          ),
                          Text(
                              '${DateFormat('d MMM').format(s.bestDay!.day)} · ${money(s.bestDay!.salesPaise)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.ink)),
                        ]),
                      ],
                    ],
                  ),
          ),
          if (_window == InsightWindow.day) ...[
            SectionTitle(l10n.insightsRush),
            NeuBox(
              child: hours.isEmpty
                  ? Text(l10n.insightsEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))
                  : Column(children: [
                      for (final h in hours)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            SizedBox(
                              width: 54,
                              child: Text(l10n.insightsHour('${h.hour}'),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: NeuColors.inkSoft)),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  value: h.salesPaise / maxHour,
                                  backgroundColor: NeuColors.inset,
                                  valueColor: AlwaysStoppedAnimation(
                                      NeuColors.accent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(money(h.salesPaise),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                          ]),
                        ),
                      if (peak != null) ...[
                        const Divider(height: 22),
                        Text(
                            l10n.insightsPeakHint('${peak.hour}',
                                '${peak.entries}', '$staff'),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: NeuColors.ink)),
                      ],
                    ]),
            ),
          ],
          if (_window == InsightWindow.day && heroes.isNotEmpty) ...[
            SectionTitle(l10n.insightsHeroes),
            NeuBox(
              child: Column(children: [
                for (final h in heroes)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(h.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: NeuColors.ink))),
                          Text(money(h.salesPaise),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.ink)),
                        ]),
                        const SizedBox(height: 2),
                        Text(
                            h.runsOutAtHour == null
                                ? l10n.insightsHeroLine(
                                    StockMath.formatQty(h.soldMilli),
                                    StockMath.formatQty(h.onHandMilli))
                                : '${l10n.insightsHeroLine(StockMath.formatQty(h.soldMilli), StockMath.formatQty(h.onHandMilli))} · '
                                    '${l10n.insightsHeroRunsOut('${h.runsOutAtHour}')}',
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
              ]),
            ),
          ],

          SectionTitle(l10n.insightsTopItems),
          NeuBox(
            child: s.topItems().isEmpty
                ? Text(l10n.insightsEmpty,
                    style: TextStyle(color: NeuColors.inkSoft))
                : Column(children: [
                    for (final e in s.topItems())
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(children: [
                          Expanded(
                              child: Text(e.key,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: NeuColors.ink))),
                          Text(money(e.value),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.inkSoft)),
                        ]),
                      ),
                  ]),
          ),
          SectionTitle(l10n.insightsCostSplit),
          NeuBox(
            child: s.expenseSplit.isEmpty
                ? Text(l10n.insightsEmpty,
                    style: TextStyle(color: NeuColors.inkSoft))
                : Column(children: [
                    for (final e in s.expenseSplit.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(children: [
                          Expanded(
                              child: Text(expenseKindLabel(context, e.key),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: NeuColors.ink))),
                          Text(money(e.value),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.danger)),
                        ]),
                      ),
                  ]),
          ),
          if (thin.isNotEmpty) ...[
            SectionTitle(l10n.insightsMarginAlert),
            NeuBox(
              inset: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.insightsMarginBody,
                      style: TextStyle(
                          fontSize: 13, color: NeuColors.inkSoft)),
                  const SizedBox(height: 10),
                  for (final p in thin.take(5))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        Expanded(
                            child: Text(p.displayName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: NeuColors.ink))),
                        Text(
                            l10n.insightsMarginRow(
                                money(p.costPaise), money(p.pricePaise)),
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.warn)),
                      ]),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final int paise;
  final Color? color;
  const _Metric(
      {required this.label, required this.paise, this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
          const SizedBox(height: 2),
          AnimatedMoney(paise / 100,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: color ?? NeuColors.ink)),
        ]),
      );
}
