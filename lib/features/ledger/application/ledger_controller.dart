import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../domain/sale.dart';

final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('overridden in main()'),
);

class LedgerState {
  final List<Sale> sales;
  final List<Repayment> repayments;
  final bool loaded;
  const LedgerState(
      {this.sales = const [], this.repayments = const [], this.loaded = false});

  bool _sameDay(int ts, DateTime d) {
    final t = DateTime.fromMillisecondsSinceEpoch(ts);
    return t.year == d.year && t.month == d.month && t.day == d.day;
  }

  List<Sale> get todaySales =>
      sales.where((s) => _sameDay(s.ts, DateTime.now())).toList();

  int get todayPaise => todaySales.fold(0, (a, s) => a + s.amountPaise);

  int paiseForMode(SaleMode m, {bool todayOnly = false}) {
    final list = todayOnly ? todaySales : sales;
    return list.where((s) => s.mode == m).fold(0, (a, s) => a + s.amountPaise);
  }

  /// Outstanding udhaar per customer = credit sales − repayments.
  Map<String, int> get udhaarBalances {
    final map = <String, int>{};
    for (final s in sales.where((s) => s.mode == SaleMode.credit)) {
      final c = s.customer ?? 'Walk-in';
      map[c] = (map[c] ?? 0) + s.amountPaise;
    }
    for (final r in repayments) {
      map[r.customer] = (map[r.customer] ?? 0) - r.amountPaise;
    }
    map.removeWhere((_, v) => v <= 0);
    return map;
  }

  int get totalUdhaarPaise =>
      udhaarBalances.values.fold(0, (a, b) => a + b);
}

class LedgerController extends Notifier<LedgerState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  LedgerState build() {
    final sales = _store
        .readSales()
        .map(Sale.tryFromJson)
        .whereType<Sale>()
        .toList()
      ..sort((a, b) => b.ts.compareTo(a.ts));
    final repayments = _store
        .readRepayments()
        .map(Repayment.tryFromJson)
        .whereType<Repayment>()
        .toList()
      ..sort((a, b) => b.ts.compareTo(a.ts));
    return LedgerState(sales: sales, repayments: repayments, loaded: true);
  }

  List<Map<String, dynamic>> _salesJson() =>
      state.sales.map((s) => s.toJson()).toList();

  List<Map<String, dynamic>> _repaymentsJson() =>
      state.repayments.map((e) => e.toJson()).toList();

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<Sale> addSale({
    required int amountPaise,
    required SaleMode mode,
    String item = '',
    String? customer,
    String billRef = '',
  }) async {
    final sale = Sale(
      id: _id(),
      ts: DateTime.now().millisecondsSinceEpoch,
      amountPaise: amountPaise,
      mode: mode,
      item: item,
      customer: customer,
      billRef: billRef,
    );
    state = LedgerState(
        sales: [sale, ...state.sales],
        repayments: state.repayments,
        loaded: true);
    await guardWrite(ref, () => _store.writeSales(_salesJson()));
    return sale;
  }

  /// Removes every ledger row a bill created — used when that bill is voided
  /// so the day's takings stay truthful without editing history by hand.
  Future<int> reverseBill(String billId) async {
    if (billId.isEmpty) return 0;
    final keep = state.sales.where((s) => s.billRef != billId).toList();
    final removed = state.sales.length - keep.length;
    if (removed == 0) return 0;
    state = LedgerState(
        sales: keep, repayments: state.repayments, loaded: true);
    await guardWrite(ref, () => _store.writeSales(_salesJson()));
    return removed;
  }

  Future<void> deleteSale(String id) async {
    state = LedgerState(
        sales: state.sales.where((s) => s.id != id).toList(),
        repayments: state.repayments,
        loaded: true);
    await guardWrite(ref, () => _store.writeSales(_salesJson()));
  }

  Future<void> addRepayment({
    required String customer,
    required int amountPaise,
    String method = 'cash',
    String note = '',
  }) async {
    final r = Repayment(
      id: _id(),
      ts: DateTime.now().millisecondsSinceEpoch,
      customer: customer,
      amountPaise: amountPaise,
      method: method,
      note: note,
    );
    state = LedgerState(
        sales: state.sales, repayments: [r, ...state.repayments], loaded: true);
    await guardWrite(ref, () => _store.writeRepayments(_repaymentsJson()));
  }
}

final ledgerProvider =
    NotifierProvider<LedgerController, LedgerState>(LedgerController.new);
