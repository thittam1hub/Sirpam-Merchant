import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LocalStore> store(Map<String, Object> seed) async {
    SharedPreferences.setMockInitialValues(seed);
    return LocalStore.init();
  }

  test('truncated JSON degrades to an empty ledger instead of crashing',
      () async {
    final s = await store({'vendoros.sales.v1': '[{"id":"a","ts":1,'});
    expect(s.readSales(), isEmpty);
  });

  test('malformed settings document falls back to defaults', () async {
    final s = await store({'vendoros.settings.v1': 'not-json'});
    expect(s.readSettings(), isEmpty);
  });

  test('legacy rows are skipped, valid rows survive', () async {
    final s = await store({
      'vendoros.sales.v1':
          '[{"legacy":true},{"id":"a","ts":10,"paise":2500,"mode":"cash"}]',
    });
    final rows = s.readSales().map(Sale.tryFromJson).whereType<Sale>().toList();
    expect(rows, hasLength(1));
    expect(rows.single.amountPaise, 2500);
  });

  test('mandi cache returns null for a corrupt document', () async {
    final s = await store({'vendoros.mandi.cache.v1': '{"rows":'});
    expect(s.readMandiCache(), isNull);
  });

  test('round-trips written sales', () async {
    final s = await store({});
    await s.writeSales([
      const Sale(id: 'x', ts: 5, amountPaise: 100, mode: SaleMode.upi).toJson()
    ]);
    expect(s.readSales().single['paise'], 100);
  });
}
