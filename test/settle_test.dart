import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';

void main() {
  test('repayment keeps the settlement method and note', () {
    const r = Repayment(
      id: '1',
      ts: 100,
      customer: 'Ravi',
      amountPaise: 5000,
      method: 'upi',
      note: 'part payment',
    );
    final back = Repayment.fromJson(r.toJson());
    expect(back.method, 'upi');
    expect(back.note, 'part payment');
  });

  test('legacy repayment rows default to cash', () {
    final r = Repayment.tryFromJson(
        {'id': '2', 'ts': 1, 'customer': 'Mani', 'paise': 100});
    expect(r, isNotNull);
    expect(r!.method, 'cash');
  });
}
