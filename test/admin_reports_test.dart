import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/access/domain/role.dart';
import 'package:vendoros/features/admin/domain/admin_reports.dart';
import 'package:vendoros/features/billing/domain/bill.dart';
import 'package:vendoros/features/expenses/domain/expense.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';
import 'package:vendoros/features/orders/domain/order.dart';
import 'package:vendoros/features/products/domain/inventory_models.dart';

void main() {
  final now = DateTime(2026, 9, 11, 20);
  final today = rangeFor(AdminPeriod.day, now);
  final ts = DateTime(2026, 9, 11, 12).millisecondsSinceEpoch;

  AuditEntry entry(String action,
          {int amount = 0, String worker = 'w1', String ref = '', String by = ''}) =>
      AuditEntry(
        id: 'a$action$ref$worker',
        ts: ts,
        workerId: worker,
        workerName: 'Ravi',
        approvedBy: by,
        action: action,
        refId: ref,
        amountPaise: amount,
      );

  Bill bill({
    String id = 'b1',
    int total = 20000,
    int discount = 0,
    bool voided = false,
    List<BillAudit> audit = const [],
  }) =>
      Bill(
        id: id,
        orderId: 'o1',
        number: 'INV-1',
        day: '2026-09-11',
        sequence: 1,
        ts: ts,
        subtotalPaise: total,
        totalPaise: total,
        discountPaise: discount,
        voided: voided,
        payments: [BillPayment(mode: SaleMode.cash, amountPaise: total)],
        audit: audit,
      );

  group('range', () {
    test('day starts at midnight, week covers seven days', () {
      expect(DateTime.fromMillisecondsSinceEpoch(today.startMs).hour, 0);
      final week = rangeFor(AdminPeriod.week, now);
      expect(DateTime.fromMillisecondsSinceEpoch(week.startMs).day, 5);
      expect(rangeFor(AdminPeriod.month, now).startMs,
          DateTime(2026, 9).millisecondsSinceEpoch);
    });
  });

  group('exceptions', () {
    test('keeps only money-sensitive actions', () {
      final rows = buildExceptions(
        audit: [entry('shift.start'), entry('giveDiscount', amount: 500)],
        bills: const [],
        range: today,
      );
      expect(rows, hasLength(1));
      expect(rows.single.action, 'giveDiscount');
    });

    test('a bill void audited by a worker is not counted twice', () {
      final rows = buildExceptions(
        audit: [entry('voidBill', amount: 20000, ref: 'b1', by: 'owner')],
        bills: [bill(voided: true)],
        range: today,
      );
      expect(rows, hasLength(1));
      expect(rows.single.approvedByOwner, isTrue);
    });

    test('an owner-shift void still shows, sourced from the bill', () {
      final rows = buildExceptions(
        audit: const [],
        bills: [
          bill(voided: true, discount: 300, audit: [
            BillAudit(ts: ts, action: 'reprint'),
          ]),
        ],
        range: today,
      );
      expect(rows.map((r) => r.action).toSet(),
          {'voidBill', 'giveDiscount', 'reprintBill'});
      expect(rows.every((r) => r.source == 'bill'), isTrue);
    });

    test('rows outside the window are dropped', () {
      final rows = buildExceptions(
        audit: [entry('giveCredit', amount: 100)],
        bills: const [],
        range: rangeFor(AdminPeriod.day, DateTime(2026, 9, 12, 10)),
      );
      expect(rows, isEmpty);
    });
  });

  test('staff stats total money touched per worker', () {
    final rows = buildStaffStats(
      audit: [
        entry('giveDiscount', amount: 500, worker: 'w1'),
        entry('giveCredit', amount: 9000, worker: 'w1', ref: 'c1'),
        entry('voidBill', amount: 100, worker: 'w2', by: 'owner'),
      ],
      range: today,
    );
    expect(rows.first.workerId, 'w1');
    expect(rows.first.discountPaise, 500);
    expect(rows.first.creditPaise, 9000);
    expect(rows.last.voids, 1);
    expect(rows.last.overrides, 1);
  });

  test('cash book counts short days and nets the difference', () {
    final book = buildCashBook(
      closes: [
        DayClose(
            day: '2026-09-11',
            expectedCashPaise: 100000,
            countedCashPaise: 99000,
            ts: ts),
        DayClose(
            day: '2026-09-10',
            expectedCashPaise: 50000,
            countedCashPaise: 50500,
            ts: DateTime(2026, 9, 10, 21).millisecondsSinceEpoch),
      ],
      range: rangeFor(AdminPeriod.week, now),
    );
    expect(book.days, hasLength(2));
    expect(book.days.first.day, '2026-09-11');
    expect(book.shortDays, 1);
    expect(book.shortPaise, 1000);
    expect(book.surplusPaise, 500);
    expect(book.netPaise, -500);
  });

  test('item flow flags stock leaving without a sale behind it', () {
    final rows = buildItemFlow(
      orders: [
        ShopOrder(
          id: 'o1',
          token: 1,
          createdAt: ts,
          updatedAt: ts,
          status: OrderStatus.served,
          lines: const [
            OrderLine(productId: 'p1', name: 'Tea', pricePaise: 1000, qty: 2),
          ],
        ),
      ],
      movements: [
        StockMovement(
            id: 'm1',
            productId: 'p1',
            kind: MovementKind.sale,
            qtyMilli: 5000,
            ts: ts),
        StockMovement(
            id: 'm2',
            productId: 'p1',
            kind: MovementKind.wastage,
            qtyMilli: 1000,
            ts: ts),
      ],
      products: const [
        Product(id: 'p1', code: 'VOS-1', name: 'Tea', pricePaise: 1000),
      ],
      range: today,
    );
    expect(rows.single.name, 'Tea');
    expect(rows.single.soldMilli, 2000);
    expect(rows.single.gapMilli, 3000);
    expect(rows.single.wastedMilli, 1000);
  });

  test('day summary splits tenders and picks the top items', () {
    final summary = buildDaySummary(
      day: '2026-09-11',
      bills: [
        bill(id: 'b1', total: 20000, discount: 500),
        bill(id: 'b2', voided: true, total: 90000),
      ],
      orders: [
        ShopOrder(
          id: 'o1',
          token: 1,
          createdAt: ts,
          updatedAt: ts,
          status: OrderStatus.served,
          lines: const [
            OrderLine(productId: 'p1', name: 'Tea', pricePaise: 1000, qty: 4),
            OrderLine(productId: 'p2', name: 'Bun', pricePaise: 1500, qty: 1),
          ],
        ),
      ],
      expenses: [
        Expense(id: 'e1', ts: ts, amountPaise: 4000, kind: ExpenseKind.milk),
      ],
      close: DayClose(
          day: '2026-09-11',
          expectedCashPaise: 20000,
          countedCashPaise: 19500,
          ts: ts),
    );
    expect(summary.bills, 1);
    expect(summary.salesPaise, 20000);
    expect(summary.cashPaise, 20000);
    expect(summary.discountPaise, 500);
    expect(summary.expensePaise, 4000);
    expect(summary.cashDiffPaise, -500);
    expect(summary.topItems.first, ('Tea', 4));
  });
}
