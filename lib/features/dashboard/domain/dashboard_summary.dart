/// Pure roll-ups behind the vendor dashboard: orders, pending payments,
/// credit balances and inventory for a chosen day / week / month window.
/// No Flutter imports — every function here is unit-testable.
library;

import '../../analytics/domain/insights.dart';
import '../../billing/domain/bill.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/domain/order.dart';
import '../../products/domain/inventory_models.dart';
import '../../products/domain/stock_math.dart';

/// The four dashboard cards; each one is also a focused page.
enum DashboardSection { orders, payments, credit, inventory }

DashboardSection? dashboardSectionFrom(String? raw) {
  for (final s in DashboardSection.values) {
    if (s.name == raw) return s;
  }
  return null;
}

/// Windows the dashboard filters by (the year view stays on Insights).
const dashboardWindows = [
  InsightWindow.day,
  InsightWindow.week,
  InsightWindow.month,
];

InsightWindow dashboardWindowFrom(String? raw) {
  for (final w in dashboardWindows) {
    if (w.name == raw) return w;
  }
  return InsightWindow.day;
}

class OrdersRollup {
  final int placed;
  final int served;
  final int cancelled;
  final int billedPaise;
  final int billCount;
  final List<MapEntry<String, int>> topItems;

  const OrdersRollup({
    required this.placed,
    required this.served,
    required this.cancelled,
    required this.billedPaise,
    required this.billCount,
    required this.topItems,
  });

  int get avgBillPaise =>
      billCount == 0 ? 0 : (billedPaise / billCount).round();
}

class PendingRollup {
  /// Orders still on the board (placed / preparing / served, not billed).
  final int openOrders;
  final int openValuePaise;

  /// Served but never billed — the money most often lost at a busy counter.
  final int unbilledOrders;
  final int unbilledPaise;

  /// Credit given inside the window (sales that brought in no cash yet).
  final int creditGivenPaise;

  const PendingRollup({
    required this.openOrders,
    required this.openValuePaise,
    required this.unbilledOrders,
    required this.unbilledPaise,
    required this.creditGivenPaise,
  });

  int get totalPaise => openValuePaise + creditGivenPaise;
}

class CreditRollup {
  final int outstandingPaise;
  final int customers;
  final int collectedPaise;

  /// Highest balances first.
  final List<MapEntry<String, int>> top;

  /// Age in days of the oldest unsettled credit sale; 0 when nothing is due.
  final int oldestDays;

  const CreditRollup({
    required this.outstandingPaise,
    required this.customers,
    required this.collectedPaise,
    required this.top,
    required this.oldestDays,
  });
}

class InventoryRollup {
  final int stockValuePaise;
  final int lowStockCount;
  final int expiringCount;
  final int wastagePaise;
  final int purchasePaise;
  final List<String> lowStockNames;

  const InventoryRollup({
    required this.stockValuePaise,
    required this.lowStockCount,
    required this.expiringCount,
    required this.wastagePaise,
    required this.purchasePaise,
    required this.lowStockNames,
  });
}

class DashboardSummary {
  final InsightWindow window;
  final DateTime from;
  final OrdersRollup orders;
  final PendingRollup pending;
  final CreditRollup credit;
  final InventoryRollup inventory;

  const DashboardSummary({
    required this.window,
    required this.from,
    required this.orders,
    required this.pending,
    required this.credit,
    required this.inventory,
  });
}

class Dashboard {
  const Dashboard._();

  /// Batches inside this many days of expiry count as "expiring soon".
  static const expiryWarningDays = 7;

  static DashboardSummary build({
    required InsightWindow window,
    required List<ShopOrder> orders,
    required List<Bill> bills,
    required List<Sale> sales,
    required List<Repayment> repayments,
    required List<Product> products,
    required List<StockBatch> batches,
    required List<StockMovement> movements,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final from = Insights.startOf(window, today);
    final fromMs = from.millisecondsSinceEpoch;

    final windowOrders =
        orders.where((o) => o.createdAt >= fromMs).toList(growable: false);
    final windowBills = bills
        .where((b) => !b.voided && b.ts >= fromMs)
        .toList(growable: false);

    final items = <String, int>{};
    for (final o in windowOrders) {
      if (o.status == OrderStatus.cancelled) continue;
      for (final l in o.lines) {
        items[l.name] = (items[l.name] ?? 0) + l.totalPaise;
      }
    }
    final topItems = items.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final ordersRollup = OrdersRollup(
      placed: windowOrders.length,
      served: windowOrders
          .where((o) =>
              o.status == OrderStatus.served || o.status == OrderStatus.paid)
          .length,
      cancelled: windowOrders
          .where((o) => o.status == OrderStatus.cancelled)
          .length,
      billedPaise: windowBills.fold(0, (a, b) => a + b.totalPaise),
      billCount: windowBills.length,
      topItems: topItems.take(5).toList(),
    );

    final open = orders.where((o) => o.isOpen).toList(growable: false);
    final unbilled = open
        .where((o) => o.status == OrderStatus.served && o.billId.isEmpty)
        .toList(growable: false);
    int value(Iterable<ShopOrder> list) =>
        list.fold(0, (a, o) => a + o.lines.fold(0, (x, l) => x + l.totalPaise));

    final pending = PendingRollup(
      openOrders: open.length,
      openValuePaise: value(open),
      unbilledOrders: unbilled.length,
      unbilledPaise: value(unbilled),
      creditGivenPaise: sales
          .where((s) => s.mode == SaleMode.credit && s.ts >= fromMs)
          .fold(0, (a, s) => a + s.amountPaise),
    );

    final balances = _balances(sales, repayments);
    final ranked = balances.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final oldestTs = sales
        .where((s) =>
            s.mode == SaleMode.credit &&
            balances.containsKey(s.customer ?? _walkIn))
        .fold<int?>(null, (a, s) => a == null || s.ts < a ? s.ts : a);

    final creditRollup = CreditRollup(
      outstandingPaise: balances.values.fold(0, (a, b) => a + b),
      customers: balances.length,
      collectedPaise: repayments
          .where((r) => r.ts >= fromMs)
          .fold(0, (a, r) => a + r.amountPaise),
      top: ranked.take(5).toList(),
      oldestDays: oldestTs == null
          ? 0
          : today
              .difference(DateTime.fromMillisecondsSinceEpoch(oldestTs))
              .inDays,
    );

    final live = products.where((p) => !p.deleted && p.active).toList();
    final lowNames = <String>[];
    for (final p in live) {
      if (StockMath.isLow(p, StockMath.onHandMilli(batches, p.id))) {
        lowNames.add(p.displayName);
      }
    }
    final horizon = today.add(const Duration(days: expiryWarningDays));
    final expiring = batches.where((b) {
      if (b.deleted || b.remainingMilli <= 0 || b.expiryAt == null) return false;
      final exp = DateTime.fromMillisecondsSinceEpoch(b.expiryAt!);
      return exp.isBefore(horizon);
    }).length;

    int moved(MovementKind kind) => movements
        .where((m) => m.kind == kind && m.ts >= fromMs)
        .fold(0, (a, m) => a + m.valuePaise);

    final inventoryRollup = InventoryRollup(
      stockValuePaise: StockMath.valuationPaise(
          batches.where((b) => !b.deleted).toList()),
      lowStockCount: lowNames.length,
      expiringCount: expiring,
      wastagePaise: moved(MovementKind.wastage),
      purchasePaise: moved(MovementKind.purchase),
      lowStockNames: lowNames.take(5).toList(),
    );

    return DashboardSummary(
      window: window,
      from: from,
      orders: ordersRollup,
      pending: pending,
      credit: creditRollup,
      inventory: inventoryRollup,
    );
  }

  static const _walkIn = 'Walk-in';

  static Map<String, int> _balances(
      List<Sale> sales, List<Repayment> repayments) {
    final map = <String, int>{};
    for (final s in sales.where((s) => s.mode == SaleMode.credit)) {
      final c = s.customer ?? _walkIn;
      map[c] = (map[c] ?? 0) + s.amountPaise;
    }
    for (final r in repayments) {
      map[r.customer] = (map[r.customer] ?? 0) - r.amountPaise;
    }
    map.removeWhere((_, v) => v <= 0);
    return map;
  }
}
