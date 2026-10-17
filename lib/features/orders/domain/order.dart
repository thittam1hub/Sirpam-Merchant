/// Counter order domain.
///
/// Invariants shared with the rest of the app: money is integer paise, and
/// quantity is a whole number of pieces (a tea shop never sells 0.3 cups).
library;

enum OrderStatus { placed, preparing, served, paid, cancelled }

OrderStatus orderStatusFrom(String? raw) => switch (raw) {
      'preparing' => OrderStatus.preparing,
      'served' => OrderStatus.served,
      'paid' => OrderStatus.paid,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.placed,
    };

/// Where the order came from: a customer scanning the table QR, or the vendor
/// punching it in at the counter.
enum OrderSource { qr, counter }

OrderSource orderSourceFrom(String? raw) =>
    raw == 'counter' ? OrderSource.counter : OrderSource.qr;

/// The only legal moves on the board. Anything else is a bug, not a UI choice.
const Map<OrderStatus, Set<OrderStatus>> kOrderTransitions = {
  OrderStatus.placed: {
    OrderStatus.preparing,
    OrderStatus.served,
    OrderStatus.cancelled
  },
  OrderStatus.preparing: {OrderStatus.served, OrderStatus.cancelled},
  OrderStatus.served: {OrderStatus.paid, OrderStatus.cancelled},
  OrderStatus.paid: <OrderStatus>{},
  OrderStatus.cancelled: <OrderStatus>{},
};

bool canTransition(OrderStatus from, OrderStatus to) =>
    kOrderTransitions[from]?.contains(to) ?? false;

class OrderLine {
  final String productId;
  final String name;
  final int pricePaise;
  final int qty;
  final String note;

  /// GST rate carried from the product, in permille; 0 falls back to the
  /// shop's default rate at billing time.
  final int taxPermille;

  /// HSN / SAC code carried from the product for the tax invoice.
  final String hsn;

  const OrderLine({
    required this.productId,
    required this.name,
    required this.pricePaise,
    required this.qty,
    this.note = '',
    this.taxPermille = 0,
    this.hsn = '',
  });

  int get totalPaise => pricePaise * qty;

  OrderLine copyWith({int? qty, String? note}) => OrderLine(
        productId: productId,
        name: name,
        pricePaise: pricePaise,
        qty: qty ?? this.qty,
        note: note ?? this.note,
        taxPermille: taxPermille,
        hsn: hsn,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'paise': pricePaise,
        'qty': qty,
        'note': note,
        if (taxPermille > 0) 'taxPermille': taxPermille,
        if (hsn.isNotEmpty) 'hsn': hsn,
      };

  static OrderLine? tryFromJson(Map<String, dynamic> j) {
    final name = j['name'];
    final paise = j['paise'];
    final qty = j['qty'];
    if (name is! String || paise is! num || qty is! num) return null;
    return OrderLine(
      productId: j['productId'] as String? ?? '',
      name: name,
      pricePaise: paise.toInt(),
      qty: qty.toInt(),
      note: j['note'] as String? ?? '',
      taxPermille: (j['taxPermille'] as num?)?.toInt() ?? 0,
      hsn: j['hsn'] as String? ?? '',
    );
  }
}

class ShopOrder {
  final String id;

  /// Short number the customer is called by. Restarts every day.
  final int token;
  final String tableLabel;
  final OrderStatus status;
  final OrderSource source;
  final String customerName;
  final String customerPhone;
  final String cancelReason;
  final List<OrderLine> lines;
  final int createdAt;
  final int updatedAt;

  /// Set once the order has been billed; links the board to the bill.
  final String billId;

  /// True once the order's lines have been taken out of stock (FIFO). Set at
  /// Served, or at settlement for orders that skip the served step, so a
  /// single order can never deduct inventory twice.
  final bool stockDeducted;

  /// Remote row id when the order came from the cloud board / QR menu.
  final String remoteId;

  const ShopOrder({
    required this.id,
    required this.token,
    required this.lines,
    required this.createdAt,
    required this.updatedAt,
    this.tableLabel = '',
    this.status = OrderStatus.placed,
    this.source = OrderSource.counter,
    this.customerName = '',
    this.customerPhone = '',
    this.cancelReason = '',
    this.billId = '',
    this.stockDeducted = false,
    this.remoteId = '',
  });

  int get subtotalPaise => lines.fold(0, (a, l) => a + l.totalPaise);

  int get itemCount => lines.fold(0, (a, l) => a + l.qty);

  bool get isOpen =>
      status != OrderStatus.paid && status != OrderStatus.cancelled;

  ShopOrder copyWith({
    OrderStatus? status,
    String? cancelReason,
    List<OrderLine>? lines,
    String? customerName,
    String? customerPhone,
    String? tableLabel,
    String? billId,
    bool? stockDeducted,
    String? remoteId,
    int? updatedAt,
  }) =>
      ShopOrder(
        id: id,
        token: token,
        lines: lines ?? this.lines,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
        tableLabel: tableLabel ?? this.tableLabel,
        status: status ?? this.status,
        source: source,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        cancelReason: cancelReason ?? this.cancelReason,
        billId: billId ?? this.billId,
        stockDeducted: stockDeducted ?? this.stockDeducted,
        remoteId: remoteId ?? this.remoteId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'table': tableLabel,
        'status': status.name,
        'source': source.name,
        'name': customerName,
        'phone': customerPhone,
        'cancelReason': cancelReason,
        'billId': billId,
        'stockDeducted': stockDeducted,
        'remoteId': remoteId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'lines': [for (final l in lines) l.toJson()],
      };

  /// Tolerant reader — a malformed row is dropped, never fatal at launch.
  static ShopOrder? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final createdAt = j['createdAt'];
    if (id is! String || createdAt is! num) return null;
    final rawLines = j['lines'];
    final lines = <OrderLine>[];
    if (rawLines is List) {
      for (final e in rawLines) {
        if (e is Map) {
          final line = OrderLine.tryFromJson(e.cast<String, dynamic>());
          if (line != null) lines.add(line);
        }
      }
    }
    return ShopOrder(
      id: id,
      token: (j['token'] as num?)?.toInt() ?? 0,
      lines: lines,
      createdAt: createdAt.toInt(),
      updatedAt: (j['updatedAt'] as num?)?.toInt() ?? createdAt.toInt(),
      tableLabel: j['table'] as String? ?? '',
      status: orderStatusFrom(j['status'] as String?),
      source: orderSourceFrom(j['source'] as String?),
      customerName: j['name'] as String? ?? '',
      customerPhone: j['phone'] as String? ?? '',
      cancelReason: j['cancelReason'] as String? ?? '',
      billId: j['billId'] as String? ?? '',
      stockDeducted: j['stockDeducted'] == true,
      remoteId: j['remoteId'] as String? ?? '',
    );
  }
}

/// `yyyy-MM-dd` key used for token series and bill numbering.
String dayKey(DateTime t) =>
    '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';

/// Next token for [day]: tokens restart at 1 each morning so the counter can
/// shout a two-digit number instead of a database id.
int nextToken(Iterable<ShopOrder> orders, String day) {
  var maxToken = 0;
  for (final o in orders) {
    if (dayKey(DateTime.fromMillisecondsSinceEpoch(o.createdAt)) != day) {
      continue;
    }
    if (o.token > maxToken) maxToken = o.token;
  }
  return maxToken + 1;
}
