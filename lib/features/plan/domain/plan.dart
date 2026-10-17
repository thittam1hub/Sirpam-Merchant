/// Subscription state for cloud features.
///
/// Everything that runs on the phone stays free forever. Only features that
/// use Sirpam's servers are gated, and the server enforces the same rule —
/// this cache exists so the app can decide what to show while offline.
library;

enum ShopPlan { free, pro }

/// Cloud-only capabilities. Local equivalents are never gated.
enum PlanFeature {
  /// Cloud shop account + per-shop database row.
  cloudAccount,

  /// Live order board sync across devices.
  liveSync,

  /// Public QR menu ordering.
  qrOrdering,

  /// Shareable dashboard snapshot links.
  shareLinks,

  /// Server-confirmed UPI soundbox.
  cloudSoundbox,

  /// Multi-device backup / restore.
  backup,
}

class PlanState {
  final ShopPlan plan;

  /// Epoch ms the paid period runs to; 0 when never subscribed.
  final int periodEndMs;

  /// Epoch ms of the last successful server check.
  final int checkedAtMs;

  /// Server-reported status, e.g. `active`, `past_due`, `cancelled`.
  final String status;

  const PlanState({
    this.plan = ShopPlan.free,
    this.periodEndMs = 0,
    this.checkedAtMs = 0,
    this.status = '',
  });

  /// How long a Pro shop keeps working after the phone last reached the
  /// server, so a week without signal never locks a vendor out.
  static const graceDays = 7;

  bool isPro(DateTime now) {
    if (plan != ShopPlan.pro) return false;
    final ms = now.millisecondsSinceEpoch;
    if (periodEndMs > 0 && ms <= periodEndMs) return true;
    if (checkedAtMs == 0) return false;
    return ms - checkedAtMs <= graceDays * 86400000;
  }

  bool allows(PlanFeature feature, DateTime now) => isPro(now);

  PlanState copyWith({
    ShopPlan? plan,
    int? periodEndMs,
    int? checkedAtMs,
    String? status,
  }) =>
      PlanState(
        plan: plan ?? this.plan,
        periodEndMs: periodEndMs ?? this.periodEndMs,
        checkedAtMs: checkedAtMs ?? this.checkedAtMs,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'plan': plan.name,
        'periodEndMs': periodEndMs,
        'checkedAtMs': checkedAtMs,
        'status': status,
      };

  factory PlanState.fromJson(Map<String, dynamic> j) => PlanState(
        plan: j['plan'] == ShopPlan.pro.name ? ShopPlan.pro : ShopPlan.free,
        periodEndMs: _int(j['periodEndMs']),
        checkedAtMs: _int(j['checkedAtMs']),
        status: j['status'] as String? ?? '',
      );

  static int _int(Object? v) =>
      v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
}
