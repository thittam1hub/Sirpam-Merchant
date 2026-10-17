import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_models.dart';
import '../domain/stock_math.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>(
    (ref) => InventoryRepository(ref.read(localStoreProvider)));

class InventoryState {
  final List<Product> products;
  final List<StockBatch> batches;
  final List<StockMovement> movements;
  final List<Supplier> suppliers;
  final bool loaded;

  /// When the stock book last changed on this phone, in epoch ms.
  final int? updatedAtMs;

  const InventoryState({
    this.products = const [],
    this.batches = const [],
    this.movements = const [],
    this.suppliers = const [],
    this.loaded = false,
    this.updatedAtMs,
  });

  InventoryState copyWith({
    List<Product>? products,
    List<StockBatch>? batches,
    List<StockMovement>? movements,
    List<Supplier>? suppliers,
    int? updatedAtMs,
  }) =>
      InventoryState(
        products: products ?? this.products,
        batches: batches ?? this.batches,
        movements: movements ?? this.movements,
        suppliers: suppliers ?? this.suppliers,
        loaded: true,
        updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      );

  List<Product> get liveProducts =>
      products.where((p) => !p.deleted).toList()
        ..sort((a, b) => a.displayName
            .toLowerCase()
            .compareTo(b.displayName.toLowerCase()));

  List<Product> get activeProducts =>
      liveProducts.where((p) => p.active).toList();

  List<Supplier> get liveSuppliers => suppliers.where((s) => !s.deleted).toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  Product? byId(String id) =>
      products.where((p) => p.id == id && !p.deleted).firstOrNull;

  /// Code lookup used by the scanner; comparison is case-insensitive.
  Product? byCode(String code) {
    final needle = code.trim().toLowerCase();
    if (needle.isEmpty) return null;
    return products
        .where((p) => !p.deleted && p.code.trim().toLowerCase() == needle)
        .firstOrNull;
  }

  int onHand(String productId) => StockMath.onHandMilli(batches, productId);

  List<StockBatch> batchesFor(String productId) =>
      StockMath.liveBatches(batches, productId);

  List<Product> get lowStock => activeProducts
      .where((p) => StockMath.isLow(p, onHand(p.id)))
      .toList()
    ..sort((a, b) => (onHand(a.id) - a.reorderMilli)
        .compareTo(onHand(b.id) - b.reorderMilli));

  int get valuationPaise => StockMath.valuationPaise(batches);

  /// All live batches with an expiry date, soonest first.
  List<StockBatch> get datedBatches => batches
      .where((b) => !b.deleted && b.remainingMilli > 0 && b.expiryAt != null)
      .toList()
    ..sort((a, b) => a.expiryAt!.compareTo(b.expiryAt!));

  List<StockMovement> movementsFor(String productId) =>
      movements.where((m) => m.productId == productId).toList();

  /// Profit for a window: sale revenue minus FIFO cost of goods, in paise.
  int profitPaise({int? sinceMs}) => movements
      .where((m) =>
          m.kind == MovementKind.sale && (sinceMs == null || m.ts >= sinceMs))
      .fold(0, (a, m) => a + m.valuePaise - m.cogsPaise);

  int wastagePaise({int? sinceMs}) => movements
      .where((m) =>
          m.kind == MovementKind.wastage && (sinceMs == null || m.ts >= sinceMs))
      .fold(0, (a, m) => a + m.valuePaise);
}

class InventoryController extends Notifier<InventoryState> {
  InventoryRepository get _repo => ref.read(inventoryRepositoryProvider);

  @override
  InventoryState build() {
    final sync = _repo.syncState();
    return InventoryState(
      products: _repo.products(),
      batches: _repo.batches(),
      movements: _repo.movements(),
      suppliers: _repo.suppliers(),
      loaded: true,
      updatedAtMs: sync?['updated_at'] is int ? sync!['updated_at'] as int : null,
    );
  }

  int get _now => DateTime.now().millisecondsSinceEpoch;
  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  /// Stable, human-readable code for products without a printed barcode.
  static String generateCode() =>
      'VOS-${DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase()}';

  /// Stamps when the stock book last changed, with the row counts behind it.
  /// The stock screen shows this so a vendor can tell fresh figures from a
  /// book nobody has touched since last week.
  Future<void> _stampSync() {
    final at = _now;
    state = state.copyWith(updatedAtMs: at);
    return guardWrite(
        ref,
        () => _repo.saveSyncState({
          'updated_at': at,
          'products': state.products.where((p) => !p.deleted).length,
          'batches': state.batches.where((b) => !b.deleted).length,
          'movements': state.movements.length,
        }));
  }

  Future<void> _persistProducts() async {
    await guardWrite(ref, () => _repo.saveProducts(state.products));
    await _stampSync();
  }

  Future<void> _persistBatches() async {
    await guardWrite(ref, () => _repo.saveBatches(state.batches));
    await _stampSync();
  }

  Future<void> _persistMovements() async {
    await guardWrite(ref, () => _repo.saveMovements(state.movements));
    await _stampSync();
  }

  Future<void> _persistSuppliers() async {
    await guardWrite(ref, () => _repo.saveSuppliers(state.suppliers));
    await _stampSync();
  }

  // --- Catalogue -----------------------------------------------------------

  Future<Product> saveProduct({
    String? id,
    required String name,
    String nameLocal = '',
    String code = '',
    String category = '',
    StockUnit unit = StockUnit.kg,
    int costPaise = 0,
    int pricePaise = 0,
    int reorderMilli = 0,
    int taxPermille = 0,
    String hsn = '',
    bool active = true,
  }) async {
    final existing = id == null ? null : state.byId(id);
    final product = (existing ??
            Product(
              id: _id('p'),
              code: code.isEmpty ? generateCode() : code,
              name: name,
            ))
        .copyWith(
      code: code.isEmpty ? (existing?.code.isEmpty ?? true ? generateCode() : existing!.code) : code,
      name: name,
      nameLocal: nameLocal,
      category: category,
      unit: unit,
      costPaise: costPaise,
      pricePaise: pricePaise,
      reorderMilli: reorderMilli,
      taxPermille: taxPermille,
      hsn: hsn,
      active: active,
      updatedAt: _now,
    );
    final rest = state.products.where((p) => p.id != product.id).toList();
    state = state.copyWith(products: [...rest, product]);
    await _persistProducts();
    return product;
  }

  /// Soft delete keeps history readable and lets the sync propagate the removal.
  Future<void> archiveProduct(String id, {bool deleted = true}) async {
    state = state.copyWith(
      products: [
        for (final p in state.products)
          p.id == id ? p.copyWith(deleted: deleted, updatedAt: _now) : p,
      ],
    );
    await _persistProducts();
  }

  // --- Stock ---------------------------------------------------------------

  /// Receive a lot: creates a batch and an append-only purchase movement.
  Future<StockBatch> receiveStock({
    required String productId,
    required int qtyMilli,
    required int unitCostPaise,
    int? expiryAt,
    String supplierId = '',
    String note = '',
  }) async {
    final batch = StockBatch(
      id: _id('b'),
      productId: productId,
      receivedMilli: qtyMilli,
      remainingMilli: qtyMilli,
      costPaise: unitCostPaise,
      receivedAt: _now,
      expiryAt: expiryAt,
      supplierId: supplierId,
      updatedAt: _now,
    );
    final movement = StockMovement(
      id: _id('m'),
      productId: productId,
      kind: MovementKind.purchase,
      qtyMilli: qtyMilli,
      valuePaise: (qtyMilli * unitCostPaise / 1000).round(),
      ts: _now,
      batchId: batch.id,
      note: note,
    );
    state = state.copyWith(
      batches: [...state.batches, batch],
      movements: [movement, ...state.movements],
    );
    await _persistBatches();
    await _persistMovements();
    return batch;
  }

  /// Consume stock for a sale. Returns the FIFO result so the caller can warn
  /// about a shortfall; the movement is still recorded for what was drawn.
  Future<FifoResult> sellStock({
    required String productId,
    required int qtyMilli,
    required int revenuePaise,
    String saleId = '',
  }) async {
    final fifo = StockMath.consumeFifo(state.batches, productId, qtyMilli);
    final movement = StockMovement(
      id: _id('m'),
      productId: productId,
      kind: MovementKind.sale,
      qtyMilli: qtyMilli,
      valuePaise: revenuePaise,
      cogsPaise: fifo.cogsPaise,
      ts: _now,
      batchId: fifo.draws.isEmpty ? '' : fifo.draws.first.batchId,
      refId: saleId,
    );
    state = state.copyWith(
      batches: StockMath.applyDraws(state.batches, fifo.draws, _now),
      movements: [movement, ...state.movements],
    );
    await _persistBatches();
    await _persistMovements();
    return fifo;
  }

  Future<FifoResult> recordWastage({
    required String productId,
    required int qtyMilli,
    String note = '',
  }) async {
    final fifo = StockMath.consumeFifo(state.batches, productId, qtyMilli);
    final movement = StockMovement(
      id: _id('m'),
      productId: productId,
      kind: MovementKind.wastage,
      qtyMilli: qtyMilli,
      valuePaise: fifo.cogsPaise,
      ts: _now,
      note: note,
    );
    state = state.copyWith(
      batches: StockMath.applyDraws(state.batches, fifo.draws, _now),
      movements: [movement, ...state.movements],
    );
    await _persistBatches();
    await _persistMovements();
    return fifo;
  }

  /// Draw raw material for a kitchen prep run. Recorded under its own
  /// movement kind so prep never looks like wastage or a sale in reports.
  Future<FifoResult> recordPrep({
    required String productId,
    required int qtyMilli,
    String note = '',
  }) async {
    final fifo = StockMath.consumeFifo(state.batches, productId, qtyMilli);
    final movement = StockMovement(
      id: _id('m'),
      productId: productId,
      kind: MovementKind.prepared,
      qtyMilli: qtyMilli,
      valuePaise: fifo.cogsPaise,
      ts: _now,
      note: note,
    );
    state = state.copyWith(
      batches: StockMath.applyDraws(state.batches, fifo.draws, _now),
      movements: [movement, ...state.movements],
    );
    await _persistBatches();
    await _persistMovements();
    return fifo;
  }

  /// Manual stock count. A surplus opens a batch at the product's cost, a
  /// deficit consumes FIFO — either way the correction is recorded.
  Future<void> correctStock({
    required String productId,
    required int newOnHandMilli,
    String note = '',
  }) async {
    final current = state.onHand(productId);
    final delta = newOnHandMilli - current;
    if (delta == 0) return;
    if (delta > 0) {
      final product = state.byId(productId);
      await receiveStock(
        productId: productId,
        qtyMilli: delta,
        unitCostPaise: product?.costPaise ?? 0,
        note: note,
      );
      return;
    }
    final fifo = StockMath.consumeFifo(state.batches, productId, -delta);
    final movement = StockMovement(
      id: _id('m'),
      productId: productId,
      kind: MovementKind.correction,
      qtyMilli: -delta,
      valuePaise: fifo.cogsPaise,
      ts: _now,
      note: note,
    );
    state = state.copyWith(
      batches: StockMath.applyDraws(state.batches, fifo.draws, _now),
      movements: [movement, ...state.movements],
    );
    await _persistBatches();
    await _persistMovements();
  }

  // --- Suppliers -----------------------------------------------------------

  Future<Supplier> saveSupplier({
    String? id,
    required String name,
    String phone = '',
    String note = '',
  }) async {
    final existing =
        id == null ? null : state.suppliers.where((s) => s.id == id).firstOrNull;
    final supplier = (existing ?? Supplier(id: _id('s'), name: name)).copyWith(
      name: name,
      phone: phone,
      note: note,
      updatedAt: _now,
    );
    state = state.copyWith(suppliers: [
      ...state.suppliers.where((s) => s.id != supplier.id),
      supplier,
    ]);
    await _persistSuppliers();
    return supplier;
  }

  Future<void> deleteSupplier(String id) async {
    state = state.copyWith(suppliers: [
      for (final s in state.suppliers)
        s.id == id ? s.copyWith(deleted: true, updatedAt: _now) : s,
    ]);
    await _persistSuppliers();
  }

  /// Replaces local rows with the merged result of a cloud sync.
  Future<void> replaceAll({
    required List<Product> products,
    required List<StockBatch> batches,
    required List<StockMovement> movements,
    required List<Supplier> suppliers,
  }) async {
    state = state.copyWith(
      products: products,
      batches: batches,
      movements: movements,
      suppliers: suppliers,
    );
    await _persistProducts();
    await _persistBatches();
    await _persistMovements();
    await _persistSuppliers();
  }
}

final inventoryProvider =
    NotifierProvider<InventoryController, InventoryState>(
        InventoryController.new);
