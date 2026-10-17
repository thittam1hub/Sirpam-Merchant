/// Who is holding the shop phone right now.
///
/// One device is shared by the whole stall, so "signing in" is a shift: a
/// worker picks their name, types a 4-digit PIN, and the device stays theirs
/// until they lock it, switch, or the idle timeout passes.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

class ShiftSession {
  final String workerId;
  final String workerName;
  final String roleId;
  final int startedAt;
  final int lastActiveAt;

  const ShiftSession({
    required this.workerId,
    this.workerName = '',
    this.roleId = '',
    this.startedAt = 0,
    this.lastActiveAt = 0,
  });

  bool isExpired(int nowMs, int idleMinutes) =>
      idleMinutes > 0 && nowMs - lastActiveAt > idleMinutes * 60 * 1000;

  ShiftSession touch(int nowMs) => ShiftSession(
        workerId: workerId,
        workerName: workerName,
        roleId: roleId,
        startedAt: startedAt,
        lastActiveAt: nowMs,
      );

  Map<String, dynamic> toJson() => {
        'workerId': workerId,
        'workerName': workerName,
        'roleId': roleId,
        'startedAt': startedAt,
        'lastActiveAt': lastActiveAt,
      };

  static ShiftSession? tryFromJson(Map<String, dynamic>? j) {
    if (j == null) return null;
    final id = j['workerId'];
    if (id is! String || id.isEmpty) return null;
    return ShiftSession(
      workerId: id,
      workerName: j['workerName'] as String? ?? '',
      roleId: j['roleId'] as String? ?? '',
      startedAt: _int(j['startedAt']),
      lastActiveAt: _int(j['lastActiveAt']),
    );
  }
}

/// Device-level access settings the owner controls.
class AccessSettings {
  /// Off until the owner turns it on, so a single-person stall is untouched.
  final bool enabled;

  /// Minutes of inactivity before the device locks. 0 disables the timeout.
  final int idleMinutes;

  /// Owner PIN, used to unlock the owner shift and to approve blocked actions.
  final String ownerPinHash;
  final String ownerPinSalt;

  const AccessSettings({
    this.enabled = false,
    this.idleMinutes = 10,
    this.ownerPinHash = '',
    this.ownerPinSalt = '',
  });

  bool get hasOwnerPin => ownerPinHash.isNotEmpty && ownerPinSalt.isNotEmpty;

  AccessSettings copyWith({
    bool? enabled,
    int? idleMinutes,
    String? ownerPinHash,
    String? ownerPinSalt,
  }) =>
      AccessSettings(
        enabled: enabled ?? this.enabled,
        idleMinutes: idleMinutes ?? this.idleMinutes,
        ownerPinHash: ownerPinHash ?? this.ownerPinHash,
        ownerPinSalt: ownerPinSalt ?? this.ownerPinSalt,
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'idleMinutes': idleMinutes,
        'ownerPinHash': ownerPinHash,
        'ownerPinSalt': ownerPinSalt,
        'session': null,
      };

  factory AccessSettings.fromJson(Map<String, dynamic> j) => AccessSettings(
        enabled: j['enabled'] == true,
        idleMinutes: _int(j['idleMinutes'], 10),
        ownerPinHash: j['ownerPinHash'] as String? ?? '',
        ownerPinSalt: j['ownerPinSalt'] as String? ?? '',
      );
}
