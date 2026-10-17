/// Owner-only reporting maths: exceptions, staff performance, the cash book,
/// item/wastage gaps and the day summary the owner sends to themselves.
///
/// Pure functions over records the shop already keeps. No widgets, no
/// storage, every amount in integer paise so nothing drifts by a rupee.
library;

import '../../access/domain/role.dart';
import '../../billing/domain/bill.dart';
import '../../expenses/domain/expense.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/domain/order.dart';
import '../../products/domain/inventory_models.dart';

enum AdminPeriod { day, week, month }

class AdminRange {
  final int startMs;
  final int endMs;
  const AdminRange({required this.startMs, required this.endMs});

  bool contains(int ts) => ts >= startMs && ts <= endMs;
}

/// Trading windows the owner thinks in: today, the last 7 days, this month.
AdminRange rangeFor(AdminPeriod period, DateTime now) {
  final endOfDay =
      DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;
  final start = switch (period) {
    AdminPeriod.day => DateTime(now.year, now.month, now.day),
    AdminPeriod.week =>
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6)),
    AdminPeriod.month => DateTime(now.year, now.month),
  };
  return AdminRange(startMs: start.millisecondsSinceEpoch, endMs: endOfDay);
}

/// Actions the owner wants to see even when they were fully allowed: money
/// leaves the shop through exactly these doors.
const exceptionActions = <String>{
  'giveDiscount',
  'voidBill',
  'reprintBill',
  'giveCredit',
  'settleCredit',
  'changePrice',
  'adjustStock',
  'closeDay',
};

class ExceptionRow {
  final int ts;
  final String action;
  final String workerId;
  final String workerName;
  final int amountPaise;
  final String note;
  final bool approvedByOwner;

  /// `audit` when it came from the permission trail, `bill` when the bill
  /// itself carries the record (owner shifts write no audit line).
  final String source;

  const ExceptionRow({
    required this.ts,
    required this.action,
    this.workerId = '',
    this.workerName = '',
    this.amountPaise = 0,
    this.note = '',
    this.approvedByOwner = false,
    this.source = 'audit',
  });
}

/// Everything unusual that happened in the window, newest first.
///
/// Audit lines win over bill lines for the same bill and action so an
/// overridden void is not counted twice.
List<ExceptionRow> buildExceptions({
  required List<AuditEntry> audit,
  required List<Bill> bills,
  required AdminRange range,
  String workerId = '',
}) {
  final rows = <ExceptionRow>[];
  final seen = <String>{};

  for (final e in audit) {
    if (!range.contains(e.ts)) continue;
    if (!exceptionActions.contains(e.action)) continue;
    if (workerId.isNotEmpty && e.workerId != workerId) continue;
    if (e.refId.isNotEmpty) seen.add('${e.action}|${e.refId}');
    rows.add(ExceptionRow(
      ts: e.ts,
      action: e.action,
      workerId: e.workerId,
      workerName: e.workerName,
      amountPaise: e.amountPaise,
      note: e.note,
      approvedByOwner: e.approvedBy.isNotEmpty,
    ));
  }

  // A shift filter is a worker filter: bill records carry no worker.
  if (workerId.isEmpty) {
    for (final b in bills) {
      if (b.voided && range.contains(b.ts) && !seen.contains('voidBill|${b.id}')) {
        rows.add(ExceptionRow(
          ts: b.ts,
          action: 'voidBill',
          amountPaise: b.totalPaise,
          note: b.voidReason.isEmpty ? b.number : '${b.number} · ${b.voidReason}',
          source: 'bill',
        ));
      }
      if (b.discountPaise > 0 &&
          range.contains(b.ts) &&
          !seen.contains('giveDiscount|${b.id}')) {
        rows.add(ExceptionRow(
          ts: b.ts,
          action: 'giveDiscount',
          amountPaise: b.discountPaise,
          note: b.number,
          source: 'bill',
        ));
      }
      for (final a in b.audit) {
        if (a.action != 'reprint' || !range.contains(a.ts)) continue;
        if (seen.contains('reprintBill|${b.id}')) continue;
        rows.add(ExceptionRow(
          ts: a.ts,
          action: 'reprintBill',
          note: b.number,
          source: 'bill',
        ));
      }
    }
  }

  rows.sort((a, b) => b.ts.compareTo(a.ts));
  return rows;
}

class StaffStat {
  final String workerId;
  final String workerName;
  final int actions;
  final int discountPaise;
  final int creditPaise;
  final int voids;
  final int reprints;
  final int overrides;

  const StaffStat({
    required this.workerId,
    required this.workerName,
    this.actions = 0,
    this.discountPaise = 0,
    this.creditPaise = 0,
    this.voids = 0,
    this.reprints = 0,
    this.overrides = 0,
  });

  StaffStat _plus(AuditEntry e) => StaffStat(
        workerId: workerId,
        workerName: workerName.isEmpty ? e.workerName : workerName,
        actions: actions + 1,
        discountPaise:
            discountPaise + (e.action == 'giveDiscount' ? e.amountPaise : 0),
        creditPaise: creditPaise + (e.action == 'giveCredit' ? e.amountPaise : 0),
        voids: voids + (e.action == 'voidBill' ? 1 : 0),
        reprints: reprints + (e.action == 'reprintBill' ? 1 : 0),
        overrides: overrides + (e.approvedBy.isEmpty ? 0 : 1),
      );
}

/// Who did what in the window, ranked by how much money they touched.
List<StaffStat> buildStaffStats({
  required List<AuditEntry> audit,
  required AdminRange range,
}) {
  final byWorker = <String, StaffStat>{};
  for (final e in audit) {
    if (!range.contains(e.ts)) continue;
    final current = byWorker[e.workerId] ??
        StaffStat(workerId: e.workerId, workerName: e.workerName);
    byWorker[e.workerId] = current._plus(e);
  }
  final rows = byWorker.values.toList()
    ..sort((a, b) {
      final money = (b.discountPaise + b.creditPaise)
          .compareTo(a.discountPaise + a.creditPaise);
      return money != 0 ? money : b.actions.compareTo(a.actions);
    });
  return rows;
}

class CashDayRow {
  final String day;
  final int openingPaise;
  final int expectedPaise;
  final int countedPaise;
  final int ts;

  const CashDayRow({
    required this.day,
    required this.openingPaise,
    required this.expectedPaise,
    required this.countedPaise,
    required this.ts,
  });

  int get differencePaise => countedPaise - expectedPaise;
  bool get isShort => differencePaise < 0;
}

class CashBook {
  final List<CashDayRow> days;
  final int shortDays;
  final int matchedDays;
  final int shortPaise;
  final int surplusPaise;

  const CashBook({
    this.days = const [],
    this.shortDays = 0,
    this.matchedDays = 0,
    this.shortPaise = 0,
    this.surplusPaise = 0,
  });

  int get netPaise => surplusPaise - shortPaise;
}

/// The cash box story for the window: what was expected, what was counted and
/// how often the drawer came up short.
CashBook buildCashBook({
  required List<DayClose> closes,
  required AdminRange range,
}) {
  final rows = <CashDayRow>[];
  var shortDays = 0;
  var matched = 0;
  var short = 0;
  var surplus = 0;
  for (final c in closes) {
    if (!range.contains(c.ts)) continue;
    final row = CashDayRow(
      day: c.day,
      openingPaise: c.openingCashPaise,
      expectedPaise: c.expectedCashPaise,
      countedPaise: c.countedCashPaise,
      ts: c.ts,
    );
    rows.add(row);
    final diff = row.differencePaise;
    if (diff == 0) {
      matched++;
    } else if (diff < 0) {
      shortDays++;
      short += -diff;
    } else {
      surplus += diff;
    }
  }
  rows.sort((a, b) => b.day.compareTo(a.day));
  return CashBook(
    days: rows,
    shortDays: shortDays,
    matchedDays: matched,
    shortPaise: short,
    surplusPaise: surplus,
  );
}

class ItemFlowRow {
  final String productId;
  final String name;

  /// Sold on the order board, in milli-units.
  final int soldMilli;

  /// Taken out of stock as a sale, in milli-units.
  final int stockOutMilli;

  /// Written off as wastage, in milli-units.
  final int wastedMilli;

  const ItemFlowRow({
    required this.productId,
    required this.name,
    this.soldMilli = 0,
    this.stockOutMilli = 0,
    this.wastedMilli = 0,
  });

  /// Positive when more stock left the shelf than the bills account for.
  int get gapMilli => stockOutMilli - soldMilli;
}

/// Sold versus stock moved, per item. A gap is not proof of anything — it is
/// the line the owner should ask about.
List<ItemFlowRow> buildItemFlow({
  required List<ShopOrder> orders,
  required List<StockMovement> movements,
  required List<Product> products,
  required AdminRange range,
}) {
  final names = {for (final p in products) p.id: p.name};
  final sold = <String, int>{};
  final out = <String, int>{};
  final wasted = <String, int>{};

  for (final o in orders) {
    if (!range.contains(o.createdAt)) continue;
    if (o.status == OrderStatus.cancelled) continue;
    for (final line in o.lines) {
      if (line.productId.isEmpty) continue;
      sold[line.productId] = (sold[line.productId] ?? 0) + line.qty * 1000;
    }
  }
  for (final m in movements) {
    if (!range.contains(m.ts)) continue;
    if (m.kind == MovementKind.sale) {
      out[m.productId] = (out[m.productId] ?? 0) + m.qtyMilli;
    } else if (m.kind == MovementKind.wastage) {
      wasted[m.productId] = (wasted[m.productId] ?? 0) + m.qtyMilli;
    }
  }

  final ids = {...sold.keys, ...out.keys, ...wasted.keys};
  final rows = [
    for (final id in ids)
      ItemFlowRow(
        productId: id,
        name: names[id] ?? id,
        soldMilli: sold[id] ?? 0,
        stockOutMilli: out[id] ?? 0,
        wastedMilli: wasted[id] ?? 0,
      ),
  ];
  rows.sort((a, b) {
    final gap = (b.gapMilli.abs() + b.wastedMilli)
        .compareTo(a.gapMilli.abs() + a.wastedMilli);
    return gap != 0 ? gap : b.soldMilli.compareTo(a.soldMilli);
  });
  return rows;
}

class DaySummary {
  final String day;
  final int bills;
  final int salesPaise;
  final int cashPaise;
  final int upiPaise;
  final int creditPaise;
  final int discountPaise;
  final int expensePaise;
  final int cashDiffPaise;
  final List<(String, int)> topItems;

  const DaySummary({
    required this.day,
    this.bills = 0,
    this.salesPaise = 0,
    this.cashPaise = 0,
    this.upiPaise = 0,
    this.creditPaise = 0,
    this.discountPaise = 0,
    this.expensePaise = 0,
    this.cashDiffPaise = 0,
    this.topItems = const [],
  });
}

/// One trading day boiled down to the numbers an owner reads on the way home.
DaySummary buildDaySummary({
  required String day,
  required List<Bill> bills,
  required List<ShopOrder> orders,
  required List<Expense> expenses,
  DayClose? close,
}) {
  var count = 0;
  var sales = 0;
  var cash = 0;
  var upi = 0;
  var credit = 0;
  var discount = 0;
  for (final b in bills) {
    if (b.day != day || b.voided) continue;
    count++;
    sales += b.totalPaise;
    discount += b.discountPaise;
    for (final p in b.payments) {
      switch (p.mode) {
        case SaleMode.cash:
          cash += p.amountPaise;
        case SaleMode.upi:
          upi += p.amountPaise;
        case SaleMode.credit:
          credit += p.amountPaise;
      }
    }
  }

  final qty = <String, int>{};
  for (final o in orders) {
    if (dayKey(DateTime.fromMillisecondsSinceEpoch(o.createdAt)) != day) continue;
    if (o.status == OrderStatus.cancelled) continue;
    for (final line in o.lines) {
      qty[line.name] = (qty[line.name] ?? 0) + line.qty;
    }
  }
  final top = qty.entries.map((e) => (e.key, e.value)).toList()
    ..sort((a, b) => b.$2.compareTo(a.$2));

  var spend = 0;
  for (final e in expenses) {
    if (dayKey(DateTime.fromMillisecondsSinceEpoch(e.ts)) == day) {
      spend += e.amountPaise;
    }
  }

  return DaySummary(
    day: day,
    bills: count,
    salesPaise: sales,
    cashPaise: cash,
    upiPaise: upi,
    creditPaise: credit,
    discountPaise: discount,
    expensePaise: spend,
    cashDiffPaise: close?.differencePaise ?? 0,
    topItems: top.take(3).toList(),
  );
}
