/// Billing domain: pure money math, no widgets and no storage.
///
/// Every amount is integer paise. Percentages are the only doubles allowed and
/// they are rounded to paise immediately.
library;

import '../../ledger/domain/sale.dart';
import 'tax.dart';

/// A single tender against a bill. One bill can carry cash + UPI + credit.
class BillPayment {
  final SaleMode mode;
  final int amountPaise;

  const BillPayment({required this.mode, required this.amountPaise});

  Map<String, dynamic> toJson() => {'mode': mode.name, 'paise': amountPaise};

  static BillPayment? tryFromJson(Map<String, dynamic> j) {
    final paise = j['paise'];
    if (paise is! num) return null;
    return BillPayment(
      mode: saleModeFromString(j['mode'] as String? ?? 'cash'),
      amountPaise: paise.toInt(),
    );
  }
}

/// Computed money breakdown of a bill. Never stored on its own — always
/// recomputed from the inputs so a stale total cannot survive an edit.
class BillTotals {
  final int subtotalPaise;
  final int discountPaise;
  final int taxPaise;

  /// Positive when rounding up to the rupee, negative when rounding down.
  final int roundingPaise;
  final int totalPaise;

  const BillTotals({
    required this.subtotalPaise,
    required this.discountPaise,
    required this.taxPaise,
    required this.roundingPaise,
    required this.totalPaise,
  });
}

class BillMath {
  const BillMath._();

  /// Discount is flat paise plus a percentage of the subtotal, clamped so a
  /// bill can never go negative.
  static int discount({
    required int subtotalPaise,
    int flatPaise = 0,
    double percent = 0,
  }) {
    final pct = percent <= 0 ? 0 : (subtotalPaise * percent / 100).round();
    final total = (flatPaise < 0 ? 0 : flatPaise) + pct;
    return total.clamp(0, subtotalPaise);
  }

  static int tax({required int taxablePaise, double percent = 0}) =>
      percent <= 0 ? 0 : (taxablePaise * percent / 100).round();

  /// Rupee rounding delta for [paise] (…49 rounds down, …50 rounds up).
  static int roundingDelta(int paise) {
    final remainder = paise % 100;
    if (remainder == 0) return 0;
    return remainder < 50 ? -remainder : 100 - remainder;
  }

  static BillTotals compute({
    required int subtotalPaise,
    int discountFlatPaise = 0,
    double discountPercent = 0,
    double taxPercent = 0,
    bool roundToRupee = true,
  }) {
    final disc = discount(
      subtotalPaise: subtotalPaise,
      flatPaise: discountFlatPaise,
      percent: discountPercent,
    );
    final taxable = subtotalPaise - disc;
    final taxAmount = tax(taxablePaise: taxable, percent: taxPercent);
    final gross = taxable + taxAmount;
    final rounding = roundToRupee ? roundingDelta(gross) : 0;
    return BillTotals(
      subtotalPaise: subtotalPaise,
      discountPaise: disc,
      taxPaise: taxAmount,
      roundingPaise: rounding,
      totalPaise: gross + rounding,
    );
  }

  /// Same as [compute] but with the tax already worked out per slab.
  /// [taxIncluded] means the prices already contain that tax, so it is shown
  /// on the bill but not added again.
  static BillTotals computeWithTax({
    required int subtotalPaise,
    int discountFlatPaise = 0,
    double discountPercent = 0,
    required int taxPaise,
    bool taxIncluded = true,
    bool roundToRupee = true,
  }) {
    final disc = discount(
      subtotalPaise: subtotalPaise,
      flatPaise: discountFlatPaise,
      percent: discountPercent,
    );
    final gross = subtotalPaise - disc + (taxIncluded ? 0 : taxPaise);
    final rounding = roundToRupee ? roundingDelta(gross) : 0;
    return BillTotals(
      subtotalPaise: subtotalPaise,
      discountPaise: disc,
      taxPaise: taxPaise,
      roundingPaise: rounding,
      totalPaise: gross + rounding,
    );
  }

  static int paid(Iterable<BillPayment> payments) =>
      payments.fold(0, (a, p) => a + p.amountPaise);

  /// What is still owed after the split. Negative means change to return.
  static int balance(int totalPaise, Iterable<BillPayment> payments) =>
      totalPaise - paid(payments);

  /// Human bill number: `yyyyMMdd-0007`, unique and sortable per shop day.
  static String number(String day, int sequence) =>
      '${day.replaceAll('-', '')}-${sequence.toString().padLeft(4, '0')}';
}

/// One auditable event on a bill: printed, reprinted, voided.
class BillAudit {
  final int ts;

  /// `print`, `reprint`, `void`, `settle`.
  final String action;
  final String reason;

  /// Where the paper went: `pdf`, `bluetooth`, `usb`, or empty.
  final String target;

  const BillAudit({
    required this.ts,
    required this.action,
    this.reason = '',
    this.target = '',
  });

  Map<String, dynamic> toJson() =>
      {'ts': ts, 'action': action, 'reason': reason, 'target': target};

  static BillAudit? tryFromJson(Map<String, dynamic> j) {
    final action = j['action'];
    if (action is! String) return null;
    return BillAudit(
      ts: (j['ts'] as num?)?.toInt() ?? 0,
      action: action,
      reason: j['reason'] as String? ?? '',
      target: j['target'] as String? ?? '',
    );
  }
}

class Bill {
  final String id;
  final String orderId;
  final String number;

  /// `yyyy-MM-dd` of the trading day this bill belongs to.
  final String day;
  final int sequence;
  final int ts;
  final String customer;
  final int subtotalPaise;
  final int discountPaise;
  final int taxPaise;
  final double taxPercent;
  final int roundingPaise;
  final int totalPaise;
  final List<BillPayment> payments;
  final bool voided;
  final String voidReason;
  final int reprintCount;

  /// GST slab table for a registered shop; empty for an unregistered one.
  final List<TaxSlab> slabs;

  /// True when the item prices already contained the tax above.
  final bool taxIncluded;

  /// Append-only trail: who printed / reprinted / voided this bill and why.
  final List<BillAudit> audit;

  const Bill({
    required this.id,
    required this.orderId,
    required this.number,
    required this.day,
    required this.sequence,
    required this.ts,
    required this.subtotalPaise,
    required this.totalPaise,
    this.customer = '',
    this.discountPaise = 0,
    this.taxPaise = 0,
    this.taxPercent = 0,
    this.roundingPaise = 0,
    this.payments = const [],
    this.voided = false,
    this.voidReason = '',
    this.reprintCount = 0,
    this.slabs = const [],
    this.taxIncluded = true,
    this.audit = const [],
  });

  int get creditPaise => payments
      .where((p) => p.mode == SaleMode.credit)
      .fold(0, (a, p) => a + p.amountPaise);

  Bill copyWith({
    bool? voided,
    String? voidReason,
    int? reprintCount,
    List<BillAudit>? audit,
  }) =>
      Bill(
        id: id,
        orderId: orderId,
        number: number,
        day: day,
        sequence: sequence,
        ts: ts,
        customer: customer,
        subtotalPaise: subtotalPaise,
        discountPaise: discountPaise,
        taxPaise: taxPaise,
        taxPercent: taxPercent,
        roundingPaise: roundingPaise,
        totalPaise: totalPaise,
        payments: payments,
        voided: voided ?? this.voided,
        voidReason: voidReason ?? this.voidReason,
        reprintCount: reprintCount ?? this.reprintCount,
        slabs: slabs,
        taxIncluded: taxIncluded,
        audit: audit ?? this.audit,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'number': number,
        'day': day,
        'sequence': sequence,
        'ts': ts,
        'customer': customer,
        'subtotal': subtotalPaise,
        'discount': discountPaise,
        'tax': taxPaise,
        'taxPct': taxPercent,
        'rounding': roundingPaise,
        'total': totalPaise,
        'voided': voided,
        'voidReason': voidReason,
        'reprints': reprintCount,
        'taxIncluded': taxIncluded,
        if (slabs.isNotEmpty) 'slabs': [for (final s in slabs) s.toJson()],
        'payments': [for (final p in payments) p.toJson()],
        'audit': [for (final a in audit) a.toJson()],
      };

  static Bill? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final number = j['number'];
    if (id is! String || number is! String) return null;
    final rawAudit = j['audit'];
    final audit = <BillAudit>[];
    if (rawAudit is List) {
      for (final e in rawAudit) {
        if (e is Map) {
          final a = BillAudit.tryFromJson(e.cast<String, dynamic>());
          if (a != null) audit.add(a);
        }
      }
    }
    final rawSlabs = j['slabs'];
    final slabs = <TaxSlab>[];
    if (rawSlabs is List) {
      for (final e in rawSlabs) {
        if (e is Map) {
          final s = TaxSlab.tryFromJson(e.cast<String, dynamic>());
          if (s != null) slabs.add(s);
        }
      }
    }
    final rawPayments = j['payments'];
    final payments = <BillPayment>[];
    if (rawPayments is List) {
      for (final e in rawPayments) {
        if (e is Map) {
          final p = BillPayment.tryFromJson(e.cast<String, dynamic>());
          if (p != null) payments.add(p);
        }
      }
    }
    return Bill(
      id: id,
      orderId: j['orderId'] as String? ?? '',
      number: number,
      day: j['day'] as String? ?? '',
      sequence: (j['sequence'] as num?)?.toInt() ?? 0,
      ts: (j['ts'] as num?)?.toInt() ?? 0,
      customer: j['customer'] as String? ?? '',
      subtotalPaise: (j['subtotal'] as num?)?.toInt() ?? 0,
      discountPaise: (j['discount'] as num?)?.toInt() ?? 0,
      taxPaise: (j['tax'] as num?)?.toInt() ?? 0,
      taxPercent: (j['taxPct'] as num?)?.toDouble() ?? 0,
      roundingPaise: (j['rounding'] as num?)?.toInt() ?? 0,
      totalPaise: (j['total'] as num?)?.toInt() ?? 0,
      payments: payments,
      voided: j['voided'] == true,
      voidReason: j['voidReason'] as String? ?? '',
      reprintCount: (j['reprints'] as num?)?.toInt() ?? 0,
      slabs: slabs,
      taxIncluded: j['taxIncluded'] != false,
      audit: audit,
    );
  }
}

/// Next per-day bill sequence; restarts at 1 every trading day.
int nextBillSequence(Iterable<Bill> bills, String day) {
  var max = 0;
  for (final b in bills) {
    if (b.day == day && b.sequence > max) max = b.sequence;
  }
  return max + 1;
}
