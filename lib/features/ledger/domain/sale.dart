enum SaleMode { cash, upi, credit }

SaleMode saleModeFromString(String s) => switch (s) {
      'upi' => SaleMode.upi,
      'credit' => SaleMode.credit,
      _ => SaleMode.cash,
    };

class Sale {
  final String id;
  final int ts; // epoch ms
  final int amountPaise;
  final SaleMode mode;
  final String item;
  final String? customer;

  /// Bill id this entry came from, when the sale was booked by the order
  /// board. Lets a void reverse exactly the rows the bill created.
  final String billRef;

  const Sale({
    required this.id,
    required this.ts,
    required this.amountPaise,
    required this.mode,
    this.item = '',
    this.customer,
    this.billRef = '',
  });

  double get rupees => amountPaise / 100.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'paise': amountPaise,
        'mode': mode.name,
        'item': item,
        'customer': customer,
        'billRef': billRef,
      };

  factory Sale.fromJson(Map<String, dynamic> j) => Sale(
        id: j['id'] as String,
        ts: j['ts'] as int,
        amountPaise: j['paise'] as int,
        mode: saleModeFromString(j['mode'] as String? ?? 'cash'),
        item: j['item'] as String? ?? '',
        customer: j['customer'] as String?,
        billRef: j['billRef'] as String? ?? '',
      );

  /// Tolerant reader for stored documents: a legacy or truncated row yields
  /// `null` instead of taking down the whole ledger on launch.
  static Sale? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final ts = j['ts'];
    final paise = j['paise'];
    if (id is! String || ts is! num || paise is! num) return null;
    return Sale(
      id: id,
      ts: ts.toInt(),
      amountPaise: paise.toInt(),
      mode: saleModeFromString(j['mode'] as String? ?? 'cash'),
      item: j['item'] as String? ?? '',
      customer: j['customer'] as String?,
      billRef: j['billRef'] as String? ?? '',
    );
  }
}


class Repayment {
  final String id;
  final int ts;
  final String customer;
  final int amountPaise;

  /// How the balance was cleared: `cash`, `upi` or `loan` (rolled into a new
  /// credit line). Older rows default to cash.
  final String method;

  /// Free-text note kept with the settlement for the audit trail.
  final String note;

  const Repayment({
    required this.id,
    required this.ts,
    required this.customer,
    required this.amountPaise,
    this.method = 'cash',
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'customer': customer,
        'paise': amountPaise,
        'method': method,
        'note': note,
      };

  factory Repayment.fromJson(Map<String, dynamic> j) => Repayment(
        id: j['id'] as String,
        ts: j['ts'] as int,
        customer: j['customer'] as String,
        amountPaise: j['paise'] as int,
        method: j['method'] as String? ?? 'cash',
        note: j['note'] as String? ?? '',
      );

  /// Tolerant reader — see [Sale.tryFromJson].
  static Repayment? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final ts = j['ts'];
    final customer = j['customer'];
    final paise = j['paise'];
    if (id is! String || ts is! num || customer is! String || paise is! num) {
      return null;
    }
    return Repayment(
      id: id,
      ts: ts.toInt(),
      customer: customer,
      amountPaise: paise.toInt(),
      method: j['method'] as String? ?? 'cash',
      note: j['note'] as String? ?? '',
    );
  }
}
