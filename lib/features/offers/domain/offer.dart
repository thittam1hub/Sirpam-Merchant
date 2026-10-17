/// Shop offers: a named discount the vendor can apply on a bill or a quick
/// sale, with the redemption count and the money given away kept alongside so
/// "was it worth it" is answerable at the end of the week.
///
/// Money is integer paise everywhere, like the rest of the app.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

enum OfferKind { flat, percent, combo }

OfferKind _kind(Object? v) => switch (v) {
      'percent' => OfferKind.percent,
      'combo' => OfferKind.combo,
      _ => OfferKind.flat,
    };

String _kindName(OfferKind k) => switch (k) {
      OfferKind.flat => 'flat',
      OfferKind.percent => 'percent',
      OfferKind.combo => 'combo',
    };

class Offer {
  final String id;
  final String name;

  /// Short code the customer says at the counter; optional.
  final String code;
  final OfferKind kind;

  /// Flat: rupees off in paise. Combo: the fixed price of the combo in paise.
  final int valuePaise;

  /// Percent off, 1..100; only read for [OfferKind.percent].
  final int percent;
  final bool active;

  /// Last day the offer runs, as epoch ms; 0 means it never expires.
  final int endsAt;

  /// How many bills used it, and how much was given away in total.
  final int redemptions;
  final int discountedPaise;
  final int createdAt;

  const Offer({
    required this.id,
    required this.name,
    this.code = '',
    this.kind = OfferKind.flat,
    this.valuePaise = 0,
    this.percent = 0,
    this.active = true,
    this.endsAt = 0,
    this.redemptions = 0,
    this.discountedPaise = 0,
    this.createdAt = 0,
  });

  /// Live means switched on and not past its last day.
  bool liveOn(DateTime now) =>
      active && (endsAt == 0 || endsAt >= now.millisecondsSinceEpoch);

  /// What this offer takes off a bill of [subtotalPaise]. Never more than the
  /// bill itself, never negative.
  int discountOn(int subtotalPaise) {
    if (subtotalPaise <= 0) return 0;
    final raw = switch (kind) {
      OfferKind.flat => valuePaise,
      OfferKind.percent => (subtotalPaise * percent / 100).round(),
      OfferKind.combo => subtotalPaise - valuePaise,
    };
    if (raw <= 0) return 0;
    return raw > subtotalPaise ? subtotalPaise : raw;
  }

  /// Average money given away per redemption.
  int get avgDiscountPaise =>
      redemptions <= 0 ? 0 : (discountedPaise / redemptions).round();

  Offer copyWith({
    String? name,
    String? code,
    OfferKind? kind,
    int? valuePaise,
    int? percent,
    bool? active,
    int? endsAt,
    int? redemptions,
    int? discountedPaise,
  }) =>
      Offer(
        id: id,
        name: name ?? this.name,
        code: code ?? this.code,
        kind: kind ?? this.kind,
        valuePaise: valuePaise ?? this.valuePaise,
        percent: percent ?? this.percent,
        active: active ?? this.active,
        endsAt: endsAt ?? this.endsAt,
        redemptions: redemptions ?? this.redemptions,
        discountedPaise: discountedPaise ?? this.discountedPaise,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'kind': _kindName(kind),
        'valuePaise': valuePaise,
        'percent': percent,
        'active': active,
        'endsAt': endsAt,
        'redemptions': redemptions,
        'discountedPaise': discountedPaise,
        'createdAt': createdAt,
      };

  static Offer? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return Offer(
      id: id,
      name: name,
      code: j['code'] as String? ?? '',
      kind: _kind(j['kind']),
      valuePaise: _int(j['valuePaise']),
      percent: _int(j['percent']).clamp(0, 100),
      active: j['active'] as bool? ?? true,
      endsAt: _int(j['endsAt']),
      redemptions: _int(j['redemptions']),
      discountedPaise: _int(j['discountedPaise']),
      createdAt: _int(j['createdAt']),
    );
  }
}

/// What is left after an offer: sale value minus the discount minus the cost
/// of the goods. Negative means the offer sold below cost.
int profitAfterOffer({
  required int subtotalPaise,
  required int costPaise,
  required int discountPaise,
}) =>
    subtotalPaise - discountPaise - costPaise;

/// Total given away across every offer, for the summary line.
int totalDiscounted(Iterable<Offer> offers) =>
    offers.fold(0, (a, o) => a + o.discountedPaise);
