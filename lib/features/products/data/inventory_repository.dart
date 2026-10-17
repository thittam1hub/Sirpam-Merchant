import '../../../core/storage/local_store.dart';
import '../domain/inventory_models.dart';

/// The only place that knows how inventory documents are persisted.
/// Reads are tolerant (bad rows are dropped), writes are strict.
class InventoryRepository {
  final LocalStore _store;
  const InventoryRepository(this._store);

  List<Product> products() => _store
      .readProducts()
      .map(Product.tryFromJson)
      .whereType<Product>()
      .toList();

  List<StockBatch> batches() => _store
      .readBatches()
      .map(StockBatch.tryFromJson)
      .whereType<StockBatch>()
      .toList();

  List<StockMovement> movements() => _store
      .readMovements()
      .map(StockMovement.tryFromJson)
      .whereType<StockMovement>()
      .toList()
    ..sort((a, b) => b.ts.compareTo(a.ts));

  List<Supplier> suppliers() => _store
      .readSuppliers()
      .map(Supplier.tryFromJson)
      .whereType<Supplier>()
      .toList();

  Future<void> saveProducts(List<Product> rows) =>
      _store.writeProducts(rows.map((e) => e.toJson()).toList());

  Future<void> saveBatches(List<StockBatch> rows) =>
      _store.writeBatches(rows.map((e) => e.toJson()).toList());

  Future<void> saveMovements(List<StockMovement> rows) =>
      _store.writeMovements(rows.map((e) => e.toJson()).toList());

  Future<void> saveSuppliers(List<Supplier> rows) =>
      _store.writeSuppliers(rows.map((e) => e.toJson()).toList());

  Map<String, dynamic>? syncState() => _store.readInventorySync();

  Future<void> saveSyncState(Map<String, dynamic> payload) =>
      _store.writeInventorySync(payload);
}
