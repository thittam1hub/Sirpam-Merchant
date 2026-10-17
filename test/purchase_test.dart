import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/purchases/domain/purchase.dart';

PurchaseBill bill({
  required String id,
  String supplierId = 's1',
  String name = 'Kumar',
  int ts = 0,
  int paid = 0,
  List<PurchaseLine> lines = const [],
}) =>
    PurchaseBill(
      id: id,
      supplierId: supplierId,
      supplierName: name,
      ts: ts,
      paidPaise: paid,
      lines: lines,
    );

void main() {
  const line = PurchaseLine(
      name: 'Rice', qtyMilli: 10000, unitCostPaise: 5000, taxPermille: 50);

  test('line totals use integer paise', () {
    expect(line.subtotalPaise, 50000);
    expect(line.taxPaise, 2500);
    expect(line.totalPaise, 52500);
  });

  test('bill due never goes negative', () {
    final b = bill(id: 'a', lines: [line], paid: 60000);
    expect(b.totalPaise, 52500);
    expect(b.duePaise, 0);
    expect(b.settled, isTrue);
  });

  test('dues group by supplier and skip settled bills', () {
    final rows = [
      bill(id: 'a', lines: [line], ts: 100),
      bill(id: 'b', lines: [line], ts: 200, paid: 52500),
      bill(id: 'c', supplierId: 's2', name: 'Devi', lines: [line], ts: 300),
    ];
    final dues = Purchases.dues(rows);
    expect(dues.length, 2);
    expect(Purchases.totalDuePaise(rows), 105000);
    expect(dues.first.duePaise, 52500);
    expect(dues.map((d) => d.supplierId).toSet(), {'s1', 's2'});
  });

  test('deleted bills leave the books', () {
    final rows = [
      bill(id: 'a', lines: [line]).copyWith(deleted: true),
      bill(id: 'b', lines: [line]),
    ];
    expect(Purchases.live(rows).length, 1);
    expect(Purchases.totalDuePaise(rows), 52500);
  });

  test('payment clears oldest bills first and stops when spent', () {
    final rows = [
      bill(id: 'a', lines: [line], ts: 100),
      bill(id: 'b', lines: [line], ts: 200),
    ];
    final updates = Purchases.applyPayment(rows, 's1', 60000);
    expect(updates['a'], 52500);
    expect(updates['b'], 7500);
    expect(Purchases.applyPayment(rows, 's1', 0), isEmpty);
  });

  test('spend window counts bills on or after the cutoff', () {
    final rows = [
      bill(id: 'a', lines: [line], ts: 100),
      bill(id: 'b', lines: [line], ts: 500),
    ];
    expect(Purchases.spendSince(rows, 200), 52500);
  });

  test('json round-trips and drops malformed rows', () {
    final b = bill(id: 'a', lines: [line], paid: 1000, ts: 42);
    final back = PurchaseBill.tryFromJson(b.toJson())!;
    expect(back.id, 'a');
    expect(back.lines.single.name, 'Rice');
    expect(back.paidPaise, 1000);
    expect(back.duePaise, 51500);
    expect(PurchaseBill.tryFromJson({'supplierId': 's1'}), isNull);
    expect(PurchaseLine.tryFromJson({'qtyMilli': 5}), isNull);
  });
}
