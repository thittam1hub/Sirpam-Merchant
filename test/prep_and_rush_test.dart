import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/analytics/domain/insights.dart';
import 'package:vendoros/features/crm/domain/regular.dart';
import 'package:vendoros/features/expenses/domain/expense.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';
import 'package:vendoros/features/prep/domain/prep_item.dart';
import 'package:vendoros/features/products/domain/inventory_models.dart';
import 'package:vendoros/features/staff/domain/staff.dart' show dayKeyOf;

void main() {
  final today = DateTime(2026, 3, 4, 11);

  group('prep sheet', () {
    test('made quantity only counts on the day it was stamped', () {
      final item = PrepItem(
        id: 'p1',
        name: 'Milk',
        plannedQty: 10,
        preparedQty: 10,
        dayKey: dayKeyOf(today.subtract(const Duration(days: 1))),
      );
      expect(item.preparedOn(today), 0);
      expect(item.shortOn(today), 10);
      expect(item.doneOn(today), isFalse);
    });

    test('a fully made plan is done and never short', () {
      final item = PrepItem(
        id: 'p1',
        name: 'Milk',
        plannedQty: 10,
        preparedQty: 12,
        dayKey: dayKeyOf(today),
      );
      expect(item.doneOn(today), isTrue);
      expect(item.shortOn(today), 0);
    });

    test('progress caps overproduction at the plan', () {
      final items = [
        PrepItem(
            id: 'a',
            name: 'A',
            plannedQty: 10,
            preparedQty: 100,
            dayKey: dayKeyOf(today)),
        PrepItem(
            id: 'b',
            name: 'B',
            plannedQty: 10,
            preparedQty: 0,
            dayKey: dayKeyOf(today)),
      ];
      expect(prepProgress(items, today), 0.5);
    });
  });

  group('rush hours', () {
    List<Sale> sales() => [
          Sale(
              id: 's1',
              ts: DateTime(2026, 3, 4, 8, 10).millisecondsSinceEpoch,
              amountPaise: 1000,
              mode: SaleMode.cash),
          Sale(
              id: 's2',
              ts: DateTime(2026, 3, 4, 8, 40).millisecondsSinceEpoch,
              amountPaise: 2000,
              mode: SaleMode.cash),
          Sale(
              id: 's3',
              ts: DateTime(2026, 3, 4, 17, 5).millisecondsSinceEpoch,
              amountPaise: 500,
              mode: SaleMode.upi),
          Sale(
              id: 'old',
              ts: DateTime(2026, 3, 3, 8, 5).millisecondsSinceEpoch,
              amountPaise: 9999,
              mode: SaleMode.cash),
      ];

    test('only today is bucketed, by hour', () {
      final hours = Insights.hourly(sales(), now: today);
      expect(hours.map((h) => h.hour), [8, 17]);
      expect(hours.first.salesPaise, 3000);
      expect(hours.first.entries, 2);
    });

    test('peak hour drives the staffing hint', () {
      final hours = Insights.hourly(sales(), now: today);
      final peak = Insights.peakHour(hours);
      expect(peak!.hour, 8);
      expect(Insights.staffNeeded(peak, billsPerPersonPerHour: 1), 2);
      expect(Insights.staffNeeded(null), 1);
    });
  });

  group('day close opening cash', () {
    test('the morning float is part of the expected drawer', () {
      expect(
        Insights.expectedCashPaise(
          cashSalesPaise: 5000,
          collectedPaise: 1000,
          expensePaise: 2000,
          openingCashPaise: 3000,
        ),
        7000,
      );
    });

    test('opening cash survives a save and reload', () {
      const close = DayClose(
        day: '2026-03-04',
        expectedCashPaise: 7000,
        countedCashPaise: 6900,
        openingCashPaise: 3000,
        ts: 1,
      );
      final back = DayClose.tryFromJson(close.toJson())!;
      expect(back.openingCashPaise, 3000);
      expect(back.differencePaise, -100);
    });
  });

  group('hero items', () {
    Product product(String id, String name) => Product(
        id: id, code: id, name: name, unit: StockUnit.piece);
    StockMovement sale(String id, String pid, int qty, int hour, int paise) =>
        StockMovement(
            id: id,
            productId: pid,
            kind: MovementKind.sale,
            qtyMilli: qty,
            valuePaise: paise,
            ts: DateTime(2026, 3, 4, hour).millisecondsSinceEpoch);

    test('ranks by quantity sold and estimates the run-out hour', () {
      final heroes = Insights.heroItems(
        movements: [
          sale('m1', 'p1', 40000, 8, 40000),
          sale('m2', 'p1', 40000, 10, 40000),
          sale('m3', 'p2', 10000, 9, 30000),
        ],
        products: [product('p1', 'Idli'), product('p2', 'Vada')],
        batches: [
          const StockBatch(
              id: 'b1',
              productId: 'p1',
              receivedMilli: 120000,
              remainingMilli: 40000,
              costPaise: 500,
              receivedAt: 0),
        ],
        now: today,
      );
      expect(heroes.first.name, 'Idli');
      expect(heroes.first.soldMilli, 80000);
      // 80 sold over 3 hours -> ~27/hour, 40 left runs out early afternoon.
      expect(heroes.first.runsOutAtHour, 12);
      expect(heroes.last.runsOutAtHour, isNull);
    });

    test('no sales today means no heroes', () {
      expect(
          Insights.heroItems(
              movements: const [],
              products: const [],
              batches: const [],
              now: today),
          isEmpty);
    });
  });

  group('lapsed regulars', () {
    Regular seen(String id, int daysAgo) => Regular(
          id: id,
          name: id,
          visits: 3,
          lastVisitAt:
              today.subtract(Duration(days: daysAgo)).millisecondsSinceEpoch,
        );

    test('only customers past the window are listed, freshest first', () {
      final rows = Insights.lapsedRegulars(
          [seen('a', 45), seen('b', 10), seen('c', 31)],
          now: today);
      expect(rows.map((r) => r.id), ['c', 'a']);
      expect(Insights.daysSinceVisit(rows.first, now: today), 31);
    });

    test('a customer who never visited is not nudged', () {
      expect(
          Insights.lapsedRegulars(
              [const Regular(id: 'z', name: 'Z')], now: today),
          isEmpty);
    });
  });
}
