/// Money going out of the shop: what was bought, from whom, and what is
/// still owed to the supplier.
///
/// Mirrors the credit book on the other side of the counter — customers owe
/// the shop, the shop owes its suppliers. All money is integer paise.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('$v') ?? fallback;

String _str(Object? v) => v is String ? v : '';

class PurchaseLine {
  /// Empty when the owner typed a free-text item that is not in the catalog.
  final String productId;
  final String name;
  final int qtyMilli;
  final int unitCostPaise;
  final int taxPermille;

  const PurchaseLine({
    this.productId = '',
    required this.name,
    required this.qtyMilli,
    required this.unitCostPaise,
    this.taxPermille = 0,
  });

  int get subtotalPaise => (qtyMilli * unitCostPaise / 1000).round();

  int get taxPaise => (subtotalPaise * taxPermille / 1000).round();

  int get totalPaise => subtotalPaise + taxPaise;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'qtyMilli': qtyMilli,
        'unitCostPaise': unitCostPaise,
        'taxPermille': taxPermille,
      };

  static PurchaseLine? tryFromJson(Map<String, dynamic> j) {
    final name = _str(j['name']);
    if (name.isEmpty) return null;
    return PurchaseLine(
      productId: _str(j['productId']),
      name: name,
      qtyMilli: _int(j['qtyMilli']),
      unitCostPaise: _int(j['unitCostPaise']),
      taxPermille: _int(j['taxPermille']),
    );
  }
}

class PurchaseBill {
  final String id;
  final String supplierId;
  final String supplierName;
  final String invoiceNo;

  /// Bill date (supplier's invoice date), epoch ms.
  final int ts;
  final List<PurchaseLine> lines;
  final int paidPaise;
  final String note;
  final int createdAt;
  final bool deleted;

  const PurchaseBill({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    this.invoiceNo = '',
    required this.ts,
    this.lines = const [],
    this.paidPaise = 0,
    this.note = '',
    this.createdAt = 0,
    this.deleted = false,
  });

  int get subtotalPaise => lines.fold(0, (a, l) => a + l.subtotalPaise);

  int get taxPaise => lines.fold(0, (a, l) => a + l.taxPaise);

  int get totalPaise => subtotalPaise + taxPaise;

  int get duePaise {
    final due = totalPaise - paidPaise;
    return due < 0 ? 0 : due;
  }

  bool get settled => duePaise == 0;

  PurchaseBill copyWith({
    String? supplierId,
    String? supplierName,
    String? invoiceNo,
    int? ts,
    List<PurchaseLine>? lines,
    int? paidPaise,
    String? note,
    bool? deleted,
  }) =>
      PurchaseBill(
        id: id,
        supplierId: supplierId ?? this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        invoiceNo: invoiceNo ?? this.invoiceNo,
        ts: ts ?? this.ts,
        lines: lines ?? this.lines,
        paidPaise: paidPaise ?? this.paidPaise,
        note: note ?? this.note,
        createdAt: createdAt,
        deleted: deleted ?? this.deleted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'supplierId': supplierId,
        'supplierName': supplierName,
        'invoiceNo': invoiceNo,
        'ts': ts,
        'lines': [for (final l in lines) l.toJson()],
        'paidPaise': paidPaise,
        'note': note,
        'createdAt': createdAt,
        'deleted': deleted,
      };

  /// Tolerant reader: a malformed row is dropped instead of breaking launch.
  static PurchaseBill? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    if (id is! String || id.isEmpty) return null;
    final rawLines = j['lines'];
    final lines = <PurchaseLine>[];
    if (rawLines is List) {
      for (final row in rawLines) {
        if (row is Map) {
          final line = PurchaseLine.tryFromJson(Map<String, dynamic>.from(row));
          if (line != null) lines.add(line);
        }
      }
    }
    return PurchaseBill(
      id: id,
      supplierId: _str(j['supplierId']),
      supplierName: _str(j['supplierName']),
      invoiceNo: _str(j['invoiceNo']),
      ts: _int(j['ts']),
      lines: lines,
      paidPaise: _int(j['paidPaise']),
      note: _str(j['note']),
      createdAt: _int(j['createdAt']),
      deleted: j['deleted'] == true,
    );
  }
}

/// What is still owed to one supplier, oldest unpaid bill first.
class SupplierDue {
  final String supplierId;
  final String supplierName;
  final int duePaise;
  final int bills;
  final int oldestTs;

  const SupplierDue({
    required this.supplierId,
    required this.supplierName,
    required this.duePaise,
    required this.bills,
    required this.oldestTs,
  });

  int daysOld(DateTime now) {
    if (oldestTs <= 0) return 0;
    final then = DateTime.fromMillisecondsSinceEpoch(oldestTs);
    return now.difference(then).inDays;
  }
}

class Purchases {
  const Purchases._();

  static List<PurchaseBill> live(List<PurchaseBill> bills) =>
      [for (final b in bills) if (!b.deleted) b];

  static int totalDuePaise(List<PurchaseBill> bills) =>
      live(bills).fold(0, (a, b) => a + b.duePaise);

  static int spendSince(List<PurchaseBill> bills, int sinceMs) => live(bills)
      .where((b) => b.ts >= sinceMs)
      .fold(0, (a, b) => a + b.totalPaise);

  /// Groups unpaid bills by supplier, biggest due first.
  static List<SupplierDue> dues(List<PurchaseBill> bills) {
    final byId = <String, List<PurchaseBill>>{};
    for (final b in live(bills)) {
      if (b.duePaise <= 0) continue;
      final key = b.supplierId.isEmpty ? 'name:${b.supplierName}' : b.supplierId;
      byId.putIfAbsent(key, () => []).add(b);
    }
    final out = <SupplierDue>[];
    for (final entry in byId.entries) {
      final rows = entry.value..sort((a, b) => a.ts.compareTo(b.ts));
      out.add(SupplierDue(
        supplierId: rows.first.supplierId,
        supplierName: rows.first.supplierName,
        duePaise: rows.fold(0, (a, b) => a + b.duePaise),
        bills: rows.length,
        oldestTs: rows.first.ts,
      ));
    }
    out.sort((a, b) => b.duePaise.compareTo(a.duePaise));
    return out;
  }

  /// Spreads a supplier payment across their unpaid bills, oldest first.
  /// Returns the new paid amount for each bill it touched.
  static Map<String, int> applyPayment(
      List<PurchaseBill> bills, String supplierKey, int amountPaise) {
    if (amountPaise <= 0) return const {};
    final rows = live(bills)
        .where((b) =>
            b.duePaise > 0 &&
            (b.supplierId.isEmpty
                    ? 'name:${b.supplierName}'
                    : b.supplierId) ==
                supplierKey)
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));
    var left = amountPaise;
    final out = <String, int>{};
    for (final b in rows) {
      if (left <= 0) break;
      final take = left < b.duePaise ? left : b.duePaise;
      out[b.id] = b.paidPaise + take;
      left -= take;
    }
    return out;
  }
}
