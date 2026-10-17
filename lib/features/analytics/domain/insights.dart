/// Pure aggregation used by the day / week / month / year views.
/// No Flutter imports — every function here is unit-testable.
library;

import '../../crm/domain/regular.dart';
import '../../expenses/domain/expense.dart';
import '../../ledger/domain/sale.dart';
import '../../products/domain/inventory_models.dart';
import '../../products/domain/stock_math.dart';

enum InsightWindow { day, week, month, year }

class HourBucket {
  final int hour;
  final int salesPaise;
  final int entries;
  const HourBucket(
      {required this.hour, required this.salesPaise, required this.entries});
}

/// A day's best seller: how much went out, what is left, and when it ends.
class HeroItem {
  final String productId;
  final String name;
  final int soldMilli;
  final int salesPaise;
  final int onHandMilli;

  /// Hour of today the shelf empties at the current pace; null when there is
  /// enough stock to see the day out (or nothing left to judge by).
  final int? runsOutAtHour;

  const HeroItem({
    required this.productId,
    required this.name,
    required this.soldMilli,
    required this.salesPaise,
    required this.onHandMilli,
    this.runsOutAtHour,
  });
}


class DayBucket {
  final DateTime day;
  final int salesPaise;
  final int expensePaise;
  const DayBucket(
      {required this.day, required this.salesPaise, required this.expensePaise});

  int get netPaise => salesPaise - expensePaise;
}

class InsightSummary {
  final InsightWindow window;
  final DateTime from;
  final List<DayBucket> buckets;
  final int salesPaise;
  final int cashPaise;
  final int upiPaise;
  final int creditPaise;
  final int collectedPaise;
  final int expensePaise;
  final int cogsPaise;
  final Map<ExpenseKind, int> expenseSplit;
  final Map<String, int> itemPaise;
  final int entries;

  const InsightSummary({
    required this.window,
    required this.from,
    required this.buckets,
    required this.salesPaise,
    required this.cashPaise,
    required this.upiPaise,
    required this.creditPaise,
    required this.collectedPaise,
    required this.expensePaise,
    required this.cogsPaise,
    required this.expenseSplit,
    required this.itemPaise,
    required this.entries,
  });

  /// Gross margin on goods minus running costs.
  int get netPaise => salesPaise - cogsPaise - expensePaise;

  int get avgPerDayPaise =>
      buckets.isEmpty ? 0 : (salesPaise / buckets.length).round();

  DayBucket? get bestDay {
    if (buckets.isEmpty) return null;
    return buckets.reduce((a, b) => b.salesPaise > a.salesPaise ? b : a);
  }

  /// Best sellers first, capped by [limit].
  List<MapEntry<String, int>> topItems({int limit = 5}) {
    final list = itemPaise.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list.take(limit).toList();
  }
}

class Insights {
  const Insights._();

  /// Inclusive start of the window, normalised to midnight.
  static DateTime startOf(InsightWindow window, DateTime now) {
    final midnight = DateTime(now.year, now.month, now.day);
    return switch (window) {
      InsightWindow.day => midnight,
      InsightWindow.week => midnight.subtract(Duration(days: now.weekday - 1)),
      InsightWindow.month => DateTime(now.year, now.month),
      InsightWindow.year => DateTime(now.year),
    };
  }

  static InsightSummary summarize({
    required InsightWindow window,
    required List<Sale> sales,
    required List<Repayment> repayments,
    required List<Expense> expenses,
    required List<StockMovement> movements,
    required List<Product> products,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final from = startOf(window, today);
    final fromMs = from.millisecondsSinceEpoch;

    final windowSales = sales.where((s) => s.ts >= fromMs).toList();
    final windowExpenses = expenses.where((e) => e.ts >= fromMs).toList();

    int forMode(SaleMode m) => windowSales
        .where((s) => s.mode == m)
        .fold(0, (a, s) => a + s.amountPaise);

    final byDay = <DateTime, List<int>>{};
    for (final s in windowSales) {
      final d = _midnight(s.ts);
      byDay.putIfAbsent(d, () => [0, 0])[0] += s.amountPaise;
    }
    for (final e in windowExpenses) {
      final d = _midnight(e.ts);
      byDay.putIfAbsent(d, () => [0, 0])[1] += e.amountPaise;
    }
    final buckets = byDay.entries
        .map((e) => DayBucket(
            day: e.key, salesPaise: e.value[0], expensePaise: e.value[1]))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    final split = <ExpenseKind, int>{};
    for (final e in windowExpenses) {
      split[e.kind] = (split[e.kind] ?? 0) + e.amountPaise;
    }

    final nameById = {for (final p in products) p.id: p.displayName};
    final itemPaise = <String, int>{};
    for (final m in movements
        .where((m) => m.kind == MovementKind.sale && m.ts >= fromMs)) {
      final name = nameById[m.productId] ?? m.productId;
      itemPaise[name] = (itemPaise[name] ?? 0) + m.valuePaise;
    }
    for (final s in windowSales.where((s) => s.item.trim().isNotEmpty)) {
      // Voice / quick entries carry a free-text item instead of a product id.
      if (itemPaise.containsKey(s.item)) continue;
      itemPaise[s.item] = (itemPaise[s.item] ?? 0) + s.amountPaise;
    }

    return InsightSummary(
      window: window,
      from: from,
      buckets: buckets,
      salesPaise: windowSales.fold(0, (a, s) => a + s.amountPaise),
      cashPaise: forMode(SaleMode.cash),
      upiPaise: forMode(SaleMode.upi),
      creditPaise: forMode(SaleMode.credit),
      collectedPaise: repayments
          .where((r) => r.ts >= fromMs)
          .fold(0, (a, r) => a + r.amountPaise),
      expensePaise: windowExpenses.fold(0, (a, e) => a + e.amountPaise),
      cogsPaise: movements
          .where((m) => m.kind == MovementKind.sale && m.ts >= fromMs)
          .fold(0, (a, m) => a + m.cogsPaise),
      expenseSplit: split,
      itemPaise: itemPaise,
      entries: windowSales.length,
    );
  }

  /// Cash the drawer should hold at close: the float it opened with + cash
  /// sales + credit collected in cash − cash paid out for supplies. UPI never
  /// touches the drawer.
  static int expectedCashPaise({
    required int cashSalesPaise,
    required int collectedPaise,
    required int expensePaise,
    int openingCashPaise = 0,
  }) =>
      openingCashPaise + cashSalesPaise + collectedPaise - expensePaise;

  /// Turnover by hour of the day, so the rush is visible instead of guessed.
  static List<HourBucket> hourly(List<Sale> sales, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final from = DateTime(today.year, today.month, today.day)
        .millisecondsSinceEpoch;
    final paise = List<int>.filled(24, 0);
    final counts = List<int>.filled(24, 0);
    for (final s in sales.where((s) => s.ts >= from)) {
      final h = DateTime.fromMillisecondsSinceEpoch(s.ts).hour;
      paise[h] += s.amountPaise;
      counts[h] += 1;
    }
    return [
      for (var h = 0; h < 24; h++)
        if (counts[h] > 0)
          HourBucket(hour: h, salesPaise: paise[h], entries: counts[h]),
    ];
  }

  /// The busiest hour of the day so far, or null before the first sale.
  static HourBucket? peakHour(List<HourBucket> hours) => hours.isEmpty
      ? null
      : hours.reduce((a, b) => b.salesPaise > a.salesPaise ? b : a);

  /// A rough second-pair-of-hands hint: how many people the peak hour needs,
  /// at [billsPerPersonPerHour] bills one person can serve comfortably.
  static int staffNeeded(HourBucket? peak,
      {int billsPerPersonPerHour = 30}) {
    if (peak == null || billsPerPersonPerHour <= 0) return 1;
    final needed = (peak.entries / billsPerPersonPerHour).ceil();
    return needed < 1 ? 1 : needed;
  }

  /// The day's best sellers by quantity, with what is still on the shelf and
  /// the hour they will run out at the pace they are going.
  static List<HeroItem> heroItems({
    required List<StockMovement> movements,
    required List<Product> products,
    required List<StockBatch> batches,
    DateTime? now,
    int limit = 3,
  }) {
    final today = now ?? DateTime.now();
    final open = DateTime(today.year, today.month, today.day);
    final fromMs = open.millisecondsSinceEpoch;
    final sold = <String, int>{};
    final revenue = <String, int>{};
    var firstSaleMs = 0;
    for (final m in movements
        .where((m) => m.kind == MovementKind.sale && m.ts >= fromMs)) {
      sold[m.productId] = (sold[m.productId] ?? 0) + m.qtyMilli;
      revenue[m.productId] = (revenue[m.productId] ?? 0) + m.valuePaise;
      if (firstSaleMs == 0 || m.ts < firstSaleMs) firstSaleMs = m.ts;
    }
    if (sold.isEmpty) return const [];
    final byId = {for (final p in products) p.id: p};
    final elapsedHours =
        (today.millisecondsSinceEpoch - firstSaleMs) / 3600000;
    final rows = sold.entries.map((e) {
      final left = StockMath.onHandMilli(batches, e.key);
      final perHour = elapsedHours <= 0 ? 0.0 : e.value / elapsedHours;
      int? runOut;
      if (left > 0 && perHour > 0) {
        final hoursLeft = left / perHour;
        final at = today.add(Duration(minutes: (hoursLeft * 60).round()));
        if (at.day == today.day) runOut = at.hour;
      }
      return HeroItem(
        productId: e.key,
        name: byId[e.key]?.displayName ?? e.key,
        soldMilli: e.value,
        salesPaise: revenue[e.key] ?? 0,
        onHandMilli: left,
        runsOutAtHour: runOut,
      );
    }).toList()
      ..sort((a, b) => b.soldMilli.compareTo(a.soldMilli));
    return rows.take(limit).toList();
  }

  /// Regulars who have not come back within [days]; the closest to slipping
  /// away first, so one WhatsApp message a day is enough.
  static List<Regular> lapsedRegulars(List<Regular> regulars,
      {int days = 30, DateTime? now}) {
    final today = now ?? DateTime.now();
    final cutoff =
        today.subtract(Duration(days: days)).millisecondsSinceEpoch;
    final rows = regulars
        .where((r) => r.visits > 0 && r.lastVisitAt > 0 && r.lastVisitAt < cutoff)
        .toList()
      ..sort((a, b) => b.lastVisitAt.compareTo(a.lastVisitAt));
    return rows;
  }

  /// Days since the customer last walked in.
  static int daysSinceVisit(Regular regular, {DateTime? now}) {
    if (regular.lastVisitAt <= 0) return 0;
    final today = now ?? DateTime.now();
    return today
        .difference(DateTime.fromMillisecondsSinceEpoch(regular.lastVisitAt))
        .inDays;
  }


  /// Items priced too close to cost — a milk or gas price rise silently eats
  /// the margin unless the vendor is told.
  static List<Product> thinMargin(List<Product> products,
      {double minMargin = 0.15}) {
    final flagged = products
        .where((p) => !p.deleted && p.active && p.costPaise > 0 && p.pricePaise > 0)
        .where((p) => (p.pricePaise - p.costPaise) / p.pricePaise < minMargin)
        .toList()
      ..sort((a, b) => ((a.pricePaise - a.costPaise) / a.pricePaise)
          .compareTo((b.pricePaise - b.costPaise) / b.pricePaise));
    return flagged;
  }

  static DateTime _midnight(int ts) {
    final t = DateTime.fromMillisecondsSinceEpoch(ts);
    return DateTime(t.year, t.month, t.day);
  }
}
