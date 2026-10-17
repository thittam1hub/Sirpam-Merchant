import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/products/domain/inventory_models.dart';
import 'package:vendoros/features/products/domain/stock_math.dart';

StockBatch batch(String id,
        {int remaining = 1000,
        int cost = 1000,
        int receivedAt = 0,
        int? expiryAt}) =>
    StockBatch(
      id: id,
      productId: 'p1',
      receivedMilli: remaining,
      remainingMilli: remaining,
      costPaise: cost,
      receivedAt: receivedAt,
      expiryAt: expiryAt,
    );

void main() {
  group('FIFO', () {
    test('draws from the oldest batch first', () {
      final batches = [
        batch('new', remaining: 5000, cost: 2000, receivedAt: 200),
        batch('old', remaining: 3000, cost: 1000, receivedAt: 100),
      ];
      final r = StockMath.consumeFifo(batches, 'p1', 4000);
      expect(r.draws.first.batchId, 'old');
      expect(r.draws.first.qtyMilli, 3000);
      expect(r.draws.last.batchId, 'new');
      expect(r.draws.last.qtyMilli, 1000);
      // 3 units @ Rs10 + 1 unit @ Rs20 = Rs50
      expect(r.cogsPaise, 5000);
      expect(r.isComplete, isTrue);
    });

    test('reports a shortfall instead of inventing stock', () {
      final r = StockMath.consumeFifo([batch('a', remaining: 1000)], 'p1', 2500);
      expect(r.drawnMilli, 1000);
      expect(r.shortfallMilli, 1500);
      expect(r.isComplete, isFalse);
    });

    test('never mutates the input batches', () {
      final batches = [batch('a', remaining: 4000)];
      StockMath.consumeFifo(batches, 'p1', 1000);
      expect(batches.single.remainingMilli, 4000);
    });

    test('applyDraws subtracts exactly what was drawn', () {
      final batches = [batch('a', remaining: 4000)];
      final r = StockMath.consumeFifo(batches, 'p1', 1500);
      final after = StockMath.applyDraws(batches, r.draws, 99);
      expect(after.single.remainingMilli, 2500);
      expect(after.single.updatedAt, 99);
    });
  });

  test('valuation prices remaining stock at its own cost layer', () {
    final batches = [
      batch('a', remaining: 2000, cost: 1500),
      batch('b', remaining: 1000, cost: 500),
    ];
    expect(StockMath.valuationPaise(batches), 3000 + 500);
  });

  test('on hand ignores empty and deleted batches', () {
    final batches = [
      batch('a', remaining: 0),
      batch('b', remaining: 2000),
    ];
    expect(StockMath.onHandMilli(batches, 'p1'), 2000);
    expect(StockMath.onHandMilli(batches, 'other'), 0);
  });

  group('expiry buckets', () {
    final now = DateTime(2026, 1, 10);
    int at(int day) => DateTime(2026, 1, day).millisecondsSinceEpoch;

    test('classifies by calendar day', () {
      expect(StockMath.bucket(batch('a', expiryAt: at(9)), now),
          ExpiryBucket.expired);
      expect(StockMath.bucket(batch('a', expiryAt: at(10)), now),
          ExpiryBucket.today);
      expect(StockMath.bucket(batch('a', expiryAt: at(15)), now),
          ExpiryBucket.soon);
      expect(StockMath.bucket(batch('a', expiryAt: at(28)), now),
          ExpiryBucket.later);
      expect(StockMath.bucket(batch('a'), now), ExpiryBucket.none);
    });
  });

  test('low stock only triggers when a reorder level is set', () {
    const p = Product(
        id: 'p1',
        code: 'VOS-1',
        name: 'Tomato',
        unit: StockUnit.kg,
        costPaise: 1000,
        pricePaise: 2000,
        reorderMilli: 2000);
    expect(StockMath.isLow(p, 2000), isTrue);
    expect(StockMath.isLow(p, 2500), isFalse);
    const noReorder = Product(
        id: 'p2',
        code: 'VOS-2',
        name: 'Salt',
        unit: StockUnit.piece,
        costPaise: 100,
        pricePaise: 200);
    expect(StockMath.isLow(noReorder, 0), isFalse);
  });

  group('quantity parsing and formatting', () {
    test('round-trips decimals and drops trailing zeros', () {
      expect(StockMath.formatQty(250), '0.25');
      expect(StockMath.formatQty(2000), '2');
      expect(StockMath.parseQty('1.5'), 1500);
    });

    test('rejects junk, zero and negatives', () {
      expect(StockMath.parseQty('abc'), isNull);
      expect(StockMath.parseQty('0'), isNull);
      expect(StockMath.parseQty('-3'), isNull);
    });
  });

  test('batch JSON survives a truncated document', () {
    final full = batch('a', remaining: 1200, expiryAt: 42).toJson();
    expect(StockBatch.tryFromJson(full)!.remainingMilli, 1200);
    expect(StockBatch.tryFromJson({'id': 'a', 'productId': 'p1'})!.costPaise, 0);
    expect(StockBatch.tryFromJson({'id': 5}), isNull);
  });
}
