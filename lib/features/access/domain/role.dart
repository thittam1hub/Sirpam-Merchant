import 'permission.dart';

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

/// A role the owner created: a name, a responsibility line, the exact set of
/// permissions granted, and the money limits above which the owner must
/// approve the action.
class ShopRole {
  /// Reserved id of the built-in owner role: every permission, not editable.
  static const ownerId = 'owner';

  final String id;
  final String name;
  final String note;

  /// Palette index (0..5) so the role reads at a glance on the counter.
  final int colorIndex;
  final Set<Permission> permissions;

  /// 0 means "no limit"; anything above needs the owner PIN.
  final int maxDiscountPaise;
  final int maxCreditPaise;
  final int maxRefundPaise;
  final bool active;
  final int updatedAt;

  const ShopRole({
    required this.id,
    required this.name,
    this.note = '',
    this.colorIndex = 0,
    this.permissions = const {},
    this.maxDiscountPaise = 0,
    this.maxCreditPaise = 0,
    this.maxRefundPaise = 0,
    this.active = true,
    this.updatedAt = 0,
  });

  bool get isOwner => id == ownerId;

  /// The owner role always holds everything, whatever is stored on disk.
  bool allows(Permission p) => isOwner || permissions.contains(p);

  /// Limit for an action, in paise. 0 = unlimited.
  int limitFor(Permission p) => switch (p) {
        Permission.giveDiscount => maxDiscountPaise,
        Permission.giveCredit => maxCreditPaise,
        _ => maxRefundPaise,
      };

  /// True when the amount is within this role's limit for that action.
  bool withinLimit(Permission p, int amountPaise) {
    if (isOwner) return true;
    final limit = limitFor(p);
    return limit <= 0 || amountPaise <= limit;
  }

  ShopRole copyWith({
    String? name,
    String? note,
    int? colorIndex,
    Set<Permission>? permissions,
    int? maxDiscountPaise,
    int? maxCreditPaise,
    int? maxRefundPaise,
    bool? active,
    int? updatedAt,
  }) =>
      ShopRole(
        id: id,
        name: name ?? this.name,
        note: note ?? this.note,
        colorIndex: colorIndex ?? this.colorIndex,
        permissions: permissions ?? this.permissions,
        maxDiscountPaise: maxDiscountPaise ?? this.maxDiscountPaise,
        maxCreditPaise: maxCreditPaise ?? this.maxCreditPaise,
        maxRefundPaise: maxRefundPaise ?? this.maxRefundPaise,
        active: active ?? this.active,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  ShopRole toggle(Permission p) => copyWith(
        permissions: {
          for (final e in permissions)
            if (e != p) e,
          if (!permissions.contains(p)) p,
        },
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'note': note,
        'colorIndex': colorIndex,
        'permissions': [for (final p in permissions) p.name],
        'maxDiscountPaise': maxDiscountPaise,
        'maxCreditPaise': maxCreditPaise,
        'maxRefundPaise': maxRefundPaise,
        'active': active,
        'updatedAt': updatedAt,
      };

  static ShopRole? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    final colour = _int(j['colorIndex']);
    return ShopRole(
      id: id,
      name: name,
      note: j['note'] as String? ?? '',
      colorIndex: colour < 0 || colour > 5 ? 0 : colour,
      permissions: Permission.parseAll(j['permissions']),
      maxDiscountPaise: _int(j['maxDiscountPaise']),
      maxCreditPaise: _int(j['maxCreditPaise']),
      maxRefundPaise: _int(j['maxRefundPaise']),
      active: j['active'] != false,
      updatedAt: _int(j['updatedAt']),
    );
  }
}

/// Append-only record of who did what, so a cash gap has a name against it.
class AuditEntry {
  final String id;
  final int ts;
  final String workerId;
  final String workerName;

  /// Set when the owner approved an action the worker could not do alone.
  final String approvedBy;
  final String action;
  final String refType;
  final String refId;
  final int amountPaise;
  final String note;

  const AuditEntry({
    required this.id,
    required this.ts,
    required this.workerId,
    this.workerName = '',
    this.approvedBy = '',
    required this.action,
    this.refType = '',
    this.refId = '',
    this.amountPaise = 0,
    this.note = '',
  });

  String get dayKey {
    final d = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'workerId': workerId,
        'workerName': workerName,
        'approvedBy': approvedBy,
        'action': action,
        'refType': refType,
        'refId': refId,
        'amountPaise': amountPaise,
        'note': note,
      };

  static AuditEntry? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final action = j['action'];
    if (id is! String || id.isEmpty || action is! String || action.isEmpty) {
      return null;
    }
    return AuditEntry(
      id: id,
      ts: _int(j['ts']),
      workerId: j['workerId'] as String? ?? '',
      workerName: j['workerName'] as String? ?? '',
      approvedBy: j['approvedBy'] as String? ?? '',
      action: action,
      refType: j['refType'] as String? ?? '',
      refId: j['refId'] as String? ?? '',
      amountPaise: _int(j['amountPaise']),
      note: j['note'] as String? ?? '',
    );
  }
}
