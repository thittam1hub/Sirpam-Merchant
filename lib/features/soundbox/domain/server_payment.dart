/// A payment confirmed by the payment provider's server (not by reading a
/// notification). This is the authoritative record the soundbox announces.
class ServerPayment {
  final String id;
  final String provider;
  final String providerTxnId;
  final String? utr;
  final int amountPaise;
  final String? payerVpa;
  final String? payerName;
  final String? orderTag;
  final int occurredAtMs;

  const ServerPayment({
    required this.id,
    required this.provider,
    required this.providerTxnId,
    required this.amountPaise,
    required this.occurredAtMs,
    this.utr,
    this.payerVpa,
    this.payerName,
    this.orderTag,
  });

  double get rupees => amountPaise / 100.0;

  String get providerLabel {
    switch (provider) {
      case 'phonepe':
        return 'PhonePe';
      case 'paytm':
        return 'Paytm';
      default:
        return provider;
    }
  }

  /// Tolerant parser: a malformed or partial row is skipped, never crashes.
  static ServerPayment? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final map = raw.cast<Object?, Object?>();
    final id = map['id']?.toString();
    final amount = map['amount_paise'];
    final amountPaise =
        amount is int ? amount : int.tryParse(amount?.toString() ?? '');
    if (id == null || id.isEmpty || amountPaise == null || amountPaise <= 0) {
      return null;
    }
    final occurred = map['occurred_at']?.toString();
    final parsed = occurred == null ? null : DateTime.tryParse(occurred);
    return ServerPayment(
      id: id,
      provider: map['provider']?.toString() ?? 'other',
      providerTxnId: map['provider_txn_id']?.toString() ?? id,
      utr: map['utr']?.toString(),
      amountPaise: amountPaise,
      payerVpa: map['payer_vpa']?.toString(),
      payerName: map['payer_name']?.toString(),
      orderTag: map['order_tag']?.toString(),
      occurredAtMs:
          (parsed ?? DateTime.now()).toLocal().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider': provider,
        'provider_txn_id': providerTxnId,
        'utr': utr,
        'amount_paise': amountPaise,
        'payer_vpa': payerVpa,
        'payer_name': payerName,
        'order_tag': orderTag,
        'occurred_at':
            DateTime.fromMillisecondsSinceEpoch(occurredAtMs).toIso8601String(),
      };
}
