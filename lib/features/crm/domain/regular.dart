/// Regulars: who keeps coming back, how they found the shop, and when the
/// loyalty card earns them a free one.
library;

enum CustomerSource { walkIn, instagram, maps, referral, other }

CustomerSource customerSourceFrom(String? raw) => switch (raw) {
      'instagram' => CustomerSource.instagram,
      'maps' => CustomerSource.maps,
      'referral' => CustomerSource.referral,
      'other' => CustomerSource.other,
      _ => CustomerSource.walkIn,
    };

String customerSourceKey(CustomerSource s) => switch (s) {
      CustomerSource.instagram => 'instagram',
      CustomerSource.maps => 'maps',
      CustomerSource.referral => 'referral',
      CustomerSource.other => 'other',
      CustomerSource.walkIn => 'walkIn',
    };

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

class Regular {
  final String id;
  final String name;
  final String phone;
  final CustomerSource source;
  final int visits;
  final int spentPaise;
  final int lastVisitAt;

  /// Free items already given on the loyalty card.
  final int rewardsGiven;
  final int updatedAt;

  const Regular({
    required this.id,
    required this.name,
    this.phone = '',
    this.source = CustomerSource.walkIn,
    this.visits = 0,
    this.spentPaise = 0,
    this.lastVisitAt = 0,
    this.rewardsGiven = 0,
    this.updatedAt = 0,
  });

  int get averagePaise => visits <= 0 ? 0 : (spentPaise / visits).round();

  /// Rewards this customer has earned but not yet been given.
  int rewardsDue(int visitsPerReward) {
    if (visitsPerReward <= 0) return 0;
    final earned = visits ~/ visitsPerReward;
    final due = earned - rewardsGiven;
    return due < 0 ? 0 : due;
  }

  /// Visits still to go before the next free one.
  int visitsToReward(int visitsPerReward) {
    if (visitsPerReward <= 0) return 0;
    final into = visits % visitsPerReward;
    return into == 0 ? 0 : visitsPerReward - into;
  }

  Regular copyWith({
    String? name,
    String? phone,
    CustomerSource? source,
    int? visits,
    int? spentPaise,
    int? lastVisitAt,
    int? rewardsGiven,
    int? updatedAt,
  }) =>
      Regular(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        source: source ?? this.source,
        visits: visits ?? this.visits,
        spentPaise: spentPaise ?? this.spentPaise,
        lastVisitAt: lastVisitAt ?? this.lastVisitAt,
        rewardsGiven: rewardsGiven ?? this.rewardsGiven,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'source': customerSourceKey(source),
        'visits': visits,
        'spentPaise': spentPaise,
        'lastVisitAt': lastVisitAt,
        'rewardsGiven': rewardsGiven,
        'updatedAt': updatedAt,
      };

  static Regular? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return Regular(
      id: id,
      name: name,
      phone: j['phone'] as String? ?? '',
      source: customerSourceFrom(j['source'] as String?),
      visits: _int(j['visits']),
      spentPaise: _int(j['spentPaise']),
      lastVisitAt: _int(j['lastVisitAt']),
      rewardsGiven: _int(j['rewardsGiven']),
      updatedAt: _int(j['updatedAt']),
    );
  }
}

/// Money brought in by each channel — the honest answer to "does Instagram
/// actually pay?".
Map<CustomerSource, int> spendBySource(Iterable<Regular> regulars) {
  final map = <CustomerSource, int>{};
  for (final r in regulars) {
    map[r.source] = (map[r.source] ?? 0) + r.spentPaise;
  }
  return map;
}
