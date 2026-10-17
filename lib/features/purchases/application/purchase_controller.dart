import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/purchase.dart';

/// Purchase bills and supplier dues, newest bill first.
class PurchaseController extends Notifier<List<PurchaseBill>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<PurchaseBill> build() => _store
      .readPurchases()
      .map(PurchaseBill.tryFromJson)
      .whereType<PurchaseBill>()
      .toList()
    ..sort((a, b) => b.ts.compareTo(a.ts));

  Future<void> _persist() => guardWrite(
      ref, () => _store.writePurchases([for (final b in state) b.toJson()]));

  List<PurchaseBill> get live => Purchases.live(state);

  int get totalDuePaise => Purchases.totalDuePaise(state);

  List<SupplierDue> get dues => Purchases.dues(state);

  int spendSince(int sinceMs) => Purchases.spendSince(state, sinceMs);

  Future<PurchaseBill?> add({
    required String supplierId,
    required String supplierName,
    required List<PurchaseLine> lines,
    String invoiceNo = '',
    int? ts,
    int paidPaise = 0,
    String note = '',
  }) async {
    if (lines.isEmpty) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    final bill = PurchaseBill(
      id: 'pb${DateTime.now().microsecondsSinceEpoch}',
      supplierId: supplierId,
      supplierName: supplierName.trim(),
      invoiceNo: invoiceNo.trim(),
      ts: ts ?? now,
      lines: lines,
      paidPaise: paidPaise < 0 ? 0 : paidPaise,
      note: note.trim(),
      createdAt: now,
    );
    state = [bill, ...state]..sort((a, b) => b.ts.compareTo(a.ts));
    await _persist();
    return bill;
  }

  /// Records money paid against one bill.
  Future<void> payBill(String id, int amountPaise) async {
    if (amountPaise <= 0) return;
    state = [
      for (final b in state)
        b.id == id
            ? b.copyWith(
                paidPaise:
                    (b.paidPaise + amountPaise).clamp(0, b.totalPaise).toInt())
            : b,
    ];
    await _persist();
  }

  /// Settles a supplier oldest bill first, the way a shop actually pays.
  Future<void> paySupplier(String supplierKey, int amountPaise) async {
    final updates = Purchases.applyPayment(state, supplierKey, amountPaise);
    if (updates.isEmpty) return;
    state = [
      for (final b in state)
        updates.containsKey(b.id) ? b.copyWith(paidPaise: updates[b.id]) : b,
    ];
    await _persist();
  }

  /// Soft delete keeps the history readable and the totals reversible.
  Future<void> remove(String id) async {
    state = [
      for (final b in state) b.id == id ? b.copyWith(deleted: true) : b,
    ];
    await _persist();
  }
}

final purchaseProvider =
    NotifierProvider<PurchaseController, List<PurchaseBill>>(
        PurchaseController.new);
