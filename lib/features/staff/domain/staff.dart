/// Helpers on the stall: who works, who came today, and what was paid in
/// advance against the wage.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

/// Stable day key `yyyy-mm-dd` so attendance survives timezone drift.
String dayKeyOf(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

enum AttendanceStatus { present, half, absent }

AttendanceStatus attendanceStatusFrom(String? raw) => switch (raw) {
      'half' => AttendanceStatus.half,
      'absent' => AttendanceStatus.absent,
      _ => AttendanceStatus.present,
    };

class Worker {
  final String id;
  final String name;
  final String phone;
  final String role;

  /// Id of the custom role that decides what this worker may do.
  final String roleId;

  /// Salted PIN used to start a shift on the shared shop phone.
  final String pinHash;
  final String pinSalt;

  final int dailyWagePaise;
  final bool active;
  final int updatedAt;

  const Worker({
    required this.id,
    required this.name,
    this.phone = '',
    this.role = '',
    this.roleId = '',
    this.pinHash = '',
    this.pinSalt = '',
    this.dailyWagePaise = 0,
    this.active = true,
    this.updatedAt = 0,
  });

  Worker copyWith({
    String? name,
    String? phone,
    String? role,
    String? roleId,
    String? pinHash,
    String? pinSalt,
    int? dailyWagePaise,
    bool? active,
    int? updatedAt,
  }) =>
      Worker(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        role: role ?? this.role,
        roleId: roleId ?? this.roleId,
        pinHash: pinHash ?? this.pinHash,
        pinSalt: pinSalt ?? this.pinSalt,
        dailyWagePaise: dailyWagePaise ?? this.dailyWagePaise,
        active: active ?? this.active,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'role': role,
        'roleId': roleId,
        'pinHash': pinHash,
        'pinSalt': pinSalt,
        'dailyWagePaise': dailyWagePaise,
        'active': active,
        'updatedAt': updatedAt,
      };

  static Worker? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return Worker(
      id: id,
      name: name,
      phone: j['phone'] as String? ?? '',
      role: j['role'] as String? ?? '',
      roleId: j['roleId'] as String? ?? '',
      pinHash: j['pinHash'] as String? ?? '',
      pinSalt: j['pinSalt'] as String? ?? '',
      dailyWagePaise: _int(j['dailyWagePaise']),
      active: j['active'] != false,
      updatedAt: _int(j['updatedAt']),
    );
  }
}

class AttendanceEntry {
  final String id;
  final String workerId;
  final String dayKey;
  final AttendanceStatus status;
  final int advancePaise;
  final String note;

  const AttendanceEntry({
    required this.id,
    required this.workerId,
    required this.dayKey,
    this.status = AttendanceStatus.present,
    this.advancePaise = 0,
    this.note = '',
  });

  AttendanceEntry copyWith({
    AttendanceStatus? status,
    int? advancePaise,
    String? note,
  }) =>
      AttendanceEntry(
        id: id,
        workerId: workerId,
        dayKey: dayKey,
        status: status ?? this.status,
        advancePaise: advancePaise ?? this.advancePaise,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'workerId': workerId,
        'dayKey': dayKey,
        'status': status.name,
        'advancePaise': advancePaise,
        'note': note,
      };

  static AttendanceEntry? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final workerId = j['workerId'];
    final dayKey = j['dayKey'];
    if (id is! String || id.isEmpty || workerId is! String || dayKey is! String) {
      return null;
    }
    return AttendanceEntry(
      id: id,
      workerId: workerId,
      dayKey: dayKey,
      status: attendanceStatusFrom(j['status'] as String?),
      advancePaise: _int(j['advancePaise']),
      note: j['note'] as String? ?? '',
    );
  }
}

/// Wage earned for a month: full days pay the daily wage, half days pay half,
/// and advances already taken are subtracted.
int wagePayablePaise(Worker worker, Iterable<AttendanceEntry> entries) {
  var earned = 0;
  var advances = 0;
  for (final e in entries) {
    if (e.workerId != worker.id) continue;
    advances += e.advancePaise;
    switch (e.status) {
      case AttendanceStatus.present:
        earned += worker.dailyWagePaise;
      case AttendanceStatus.half:
        earned += (worker.dailyWagePaise / 2).round();
      case AttendanceStatus.absent:
        break;
    }
  }
  final payable = earned - advances;
  return payable < 0 ? 0 : payable;
}
