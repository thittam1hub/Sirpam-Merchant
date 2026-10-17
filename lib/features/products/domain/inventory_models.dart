/// Inventory domain model.
///
/// Two invariants hold everywhere in this module:
///   * money is an integer number of paise,
///   * quantity is an integer number of milli-units, so 0.25 kg is exactly
///     250 and no float drift can ever creep into stock on hand.
library;

enum StockUnit { kg, gram, piece, litre, bundle }

StockUnit stockUnitFrom(String? raw) => switch (raw) {
      'gram' => StockUnit.gram,
      'piece' => StockUnit.piece,
      'litre' => StockUnit.litre,
      'bundle' => StockUnit.bundle,
      _ => StockUnit.kg,
    };

/// Movement kinds are append-only history; stock on hand is always derived.
enum MovementKind { purchase, sale, wastage, returnIn, correction, prepared }

MovementKind movementKindFrom(String? raw) => switch (raw) {
      'sale' => MovementKind.sale,
      'wastage' => MovementKind.wastage,
      'returnIn' => MovementKind.returnIn,
      'correction' => MovementKind.correction,
      'prepared' => MovementKind.prepared,
      _ => MovementKind.purchase,
    };

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

bool _bool(Object? v, bool fallback) => v is bool ? v : fallback;

String _str(Object? v) => v?.toString() ?? '';

class Product {
  final String id;

  /// Printed barcode (EAN/UPC/Code128) or the generated `VOS-…` code.
  final String code;
  final String name;

  /// Local-language name; optional, falls back to [name].
  final String nameLocal;
  final String category;
  final StockUnit unit;

  /// Default purchase cost per unit, used when a batch does not override it.
  final int costPaise;
  final int pricePaise;

  /// Reorder level in milli-units; 0 disables the low-stock alert.
  final int reorderMilli;

  /// GST rate for this item in permille (5% is 50); 0 means "use the shop's
  /// default rate".
  final int taxPermille;

  /// HSN (goods) or SAC (services) code printed on a tax invoice.
  final String hsn;
  final bool active;
  final int updatedAt;
  final bool deleted;

  const Product({
    required this.id,
    required this.code,
    required this.name,
    this.nameLocal = '',
    this.category = '',
    this.unit = StockUnit.kg,
    this.costPaise = 0,
    this.pricePaise = 0,
    this.reorderMilli = 0,
    this.taxPermille = 0,
    this.hsn = '',
    this.active = true,
    this.updatedAt = 0,
    this.deleted = false,
  });

  String get displayName => name.isNotEmpty ? name : nameLocal;

  /// Margin over the selling price, in percent. Null when either side is unset.
  double? get marginPct {
    if (pricePaise <= 0 || costPaise <= 0) return null;
    return (pricePaise - costPaise) * 100 / pricePaise;
  }

  Product copyWith({
    String? code,
    String? name,
    String? nameLocal,
    String? category,
    StockUnit? unit,
    int? costPaise,
    int? pricePaise,
    int? reorderMilli,
    int? taxPermille,
    String? hsn,
    bool? active,
    int? updatedAt,
    bool? deleted,
  }) =>
      Product(
        id: id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameLocal: nameLocal ?? this.nameLocal,
        category: category ?? this.category,
        unit: unit ?? this.unit,
        costPaise: costPaise ?? this.costPaise,
        pricePaise: pricePaise ?? this.pricePaise,
        reorderMilli: reorderMilli ?? this.reorderMilli,
        taxPermille: taxPermille ?? this.taxPermille,
        hsn: hsn ?? this.hsn,
        active: active ?? this.active,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'nameLocal': nameLocal,
        'category': category,
        'unit': unit.name,
        'costPaise': costPaise,
        'pricePaise': pricePaise,
        'reorderMilli': reorderMilli,
        'taxPermille': taxPermille,
        'hsn': hsn,
        'active': active,
        'updatedAt': updatedAt,
        'deleted': deleted,
      };

  /// Tolerant reader: a legacy or truncated row is dropped, never thrown.
  static Product? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    if (id is! String || id.isEmpty) return null;
    final name = _str(j['name']);
    final local = _str(j['nameLocal']);
    if (name.isEmpty && local.isEmpty) return null;
    return Product(
      id: id,
      code: _str(j['code']),
      name: name,
      nameLocal: local,
      category: _str(j['category']),
      unit: stockUnitFrom(j['unit'] as String?),
      costPaise: _int(j['costPaise']),
      pricePaise: _int(j['pricePaise']),
      reorderMilli: _int(j['reorderMilli']),
      taxPermille: _int(j['taxPermille']),
      hsn: _str(j['hsn']),
      active: _bool(j['active'], true),
      updatedAt: _int(j['updatedAt']),
      deleted: _bool(j['deleted'], false),
    );
  }
}

/// One received lot of a product. FIFO consumption walks these by [receivedAt].
class StockBatch {
  final String id;
  final String productId;
  final int receivedMilli;
  final int remainingMilli;

  /// Purchase cost per unit for this lot, in paise.
  final int costPaise;
  final int receivedAt;

  /// Epoch ms; null for products that do not expire.
  final int? expiryAt;
  final String supplierId;
  final int updatedAt;
  final bool deleted;

  const StockBatch({
    required this.id,
    required this.productId,
    required this.receivedMilli,
    required this.remainingMilli,
    required this.costPaise,
    required this.receivedAt,
    this.expiryAt,
    this.supplierId = '',
    this.updatedAt = 0,
    this.deleted = false,
  });

  StockBatch copyWith({
    int? remainingMilli,
    int? costPaise,
    int? expiryAt,
    bool clearExpiry = false,
    String? supplierId,
    int? updatedAt,
    bool? deleted,
  }) =>
      StockBatch(
        id: id,
        productId: productId,
        receivedMilli: receivedMilli,
        remainingMilli: remainingMilli ?? this.remainingMilli,
        costPaise: costPaise ?? this.costPaise,
        receivedAt: receivedAt,
        expiryAt: clearExpiry ? null : (expiryAt ?? this.expiryAt),
        supplierId: supplierId ?? this.supplierId,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'receivedMilli': receivedMilli,
        'remainingMilli': remainingMilli,
        'costPaise': costPaise,
        'receivedAt': receivedAt,
        'expiryAt': expiryAt,
        'supplierId': supplierId,
        'updatedAt': updatedAt,
        'deleted': deleted,
      };

  static StockBatch? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final productId = j['productId'];
    if (id is! String || productId is! String) return null;
    final expiry = j['expiryAt'];
    return StockBatch(
      id: id,
      productId: productId,
      receivedMilli: _int(j['receivedMilli']),
      remainingMilli: _int(j['remainingMilli']),
      costPaise: _int(j['costPaise']),
      receivedAt: _int(j['receivedAt']),
      expiryAt: expiry == null ? null : _int(expiry),
      supplierId: _str(j['supplierId']),
      updatedAt: _int(j['updatedAt']),
      deleted: _bool(j['deleted'], false),
    );
  }
}

/// Append-only stock history. Never edited, only added to.
class StockMovement {
  final String id;
  final String productId;
  final MovementKind kind;

  /// Always positive; the [kind] carries the direction.
  final int qtyMilli;

  /// Money moved by this record: purchase cost, sale revenue, wasted value.
  final int valuePaise;

  /// FIFO cost of goods for a sale (0 for other kinds), in paise.
  final int cogsPaise;
  final int ts;
  final String batchId;

  /// Ledger sale id when this movement was created by a sale.
  final String refId;
  final String note;

  const StockMovement({
    required this.id,
    required this.productId,
    required this.kind,
    required this.qtyMilli,
    required this.ts,
    this.valuePaise = 0,
    this.cogsPaise = 0,
    this.batchId = '',
    this.refId = '',
    this.note = '',
  });

  /// Signed effect on stock on hand, in milli-units.
  int get signedMilli => switch (kind) {
        MovementKind.purchase || MovementKind.returnIn => qtyMilli,
        MovementKind.sale ||
        MovementKind.wastage ||
        MovementKind.prepared =>
          -qtyMilli,
        MovementKind.correction => qtyMilli,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'kind': kind.name,
        'qtyMilli': qtyMilli,
        'valuePaise': valuePaise,
        'cogsPaise': cogsPaise,
        'ts': ts,
        'batchId': batchId,
        'refId': refId,
        'note': note,
      };

  static StockMovement? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final productId = j['productId'];
    if (id is! String || productId is! String) return null;
    return StockMovement(
      id: id,
      productId: productId,
      kind: movementKindFrom(j['kind'] as String?),
      qtyMilli: _int(j['qtyMilli']),
      valuePaise: _int(j['valuePaise']),
      cogsPaise: _int(j['cogsPaise']),
      ts: _int(j['ts']),
      batchId: _str(j['batchId']),
      refId: _str(j['refId']),
      note: _str(j['note']),
    );
  }
}

class Supplier {
  final String id;
  final String name;
  final String phone;
  final String note;
  final int updatedAt;
  final bool deleted;

  const Supplier({
    required this.id,
    required this.name,
    this.phone = '',
    this.note = '',
    this.updatedAt = 0,
    this.deleted = false,
  });

  Supplier copyWith({
    String? name,
    String? phone,
    String? note,
    int? updatedAt,
    bool? deleted,
  }) =>
      Supplier(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'note': note,
        'updatedAt': updatedAt,
        'deleted': deleted,
      };

  static Supplier? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = _str(j['name']);
    if (id is! String || name.isEmpty) return null;
    return Supplier(
      id: id,
      name: name,
      phone: _str(j['phone']),
      note: _str(j['note']),
      updatedAt: _int(j['updatedAt']),
      deleted: _bool(j['deleted'], false),
    );
  }
}
