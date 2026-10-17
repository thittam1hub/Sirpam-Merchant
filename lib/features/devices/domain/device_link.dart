/// Multi-device sync: what this phone knows about its place in the shop.
///
/// The owner's phone holds the shop key and needs no link. Every extra phone
/// (waiter, kitchen, counter) pairs once with a 6-digit code and then holds its
/// own device key, which the server can revoke at any time.
library;

/// Which job a phone is set up for; decides the screen it opens on.
enum DeviceRole { waiter, kitchen, counter }

String deviceRoleWire(DeviceRole r) => switch (r) {
      DeviceRole.waiter => 'waiter',
      DeviceRole.kitchen => 'kitchen',
      DeviceRole.counter => 'counter',
    };

DeviceRole deviceRoleFrom(Object? raw) => switch (raw?.toString()) {
      'waiter' => DeviceRole.waiter,
      'kitchen' => DeviceRole.kitchen,
      _ => DeviceRole.counter,
    };

/// This phone's pairing to a shop. Empty [deviceKey] means "not paired" — the
/// phone is either the owner's device or still standalone.
class DeviceLink {
  final String slug;
  final String deviceKey;
  final String deviceId;
  final String label;
  final DeviceRole role;
  final String shopName;
  final int pairedAtMs;

  const DeviceLink({
    this.slug = '',
    this.deviceKey = '',
    this.deviceId = '',
    this.label = '',
    this.role = DeviceRole.counter,
    this.shopName = '',
    this.pairedAtMs = 0,
  });

  bool get paired => slug.isNotEmpty && deviceKey.length >= 16;

  /// Where this phone should land after launch.
  String get homePath => switch (role) {
        DeviceRole.waiter => '/menu',
        DeviceRole.kitchen => '/kot',
        DeviceRole.counter => '/orders',
      };

  DeviceLink copyWith({
    String? slug,
    String? deviceKey,
    String? deviceId,
    String? label,
    DeviceRole? role,
    String? shopName,
    int? pairedAtMs,
  }) =>
      DeviceLink(
        slug: slug ?? this.slug,
        deviceKey: deviceKey ?? this.deviceKey,
        deviceId: deviceId ?? this.deviceId,
        label: label ?? this.label,
        role: role ?? this.role,
        shopName: shopName ?? this.shopName,
        pairedAtMs: pairedAtMs ?? this.pairedAtMs,
      );

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'deviceKey': deviceKey,
        'deviceId': deviceId,
        'label': label,
        'role': deviceRoleWire(role),
        'shopName': shopName,
        'pairedAtMs': pairedAtMs,
      };

  factory DeviceLink.fromJson(Map<String, dynamic> j) => DeviceLink(
        slug: j['slug'] as String? ?? '',
        deviceKey: j['deviceKey'] as String? ?? '',
        deviceId: j['deviceId'] as String? ?? '',
        label: j['label'] as String? ?? '',
        role: deviceRoleFrom(j['role']),
        shopName: j['shopName'] as String? ?? '',
        pairedAtMs: (j['pairedAtMs'] as num?)?.toInt() ?? 0,
      );
}

/// One phone as the owner's device list sees it.
class PairedDevice {
  final String id;
  final String label;
  final DeviceRole role;

  /// The custom staff role the owner pointed this phone at, if any.
  final String roleId;
  final String roleName;
  final bool active;
  final int lastSeenMs;

  const PairedDevice({
    required this.id,
    required this.label,
    required this.role,
    this.roleId = '',
    this.roleName = '',
    required this.active,
    required this.lastSeenMs,
  });

  /// A phone that has not checked in for five minutes is treated as away.
  bool online(DateTime now) =>
      active &&
      lastSeenMs > 0 &&
      now.millisecondsSinceEpoch - lastSeenMs < 5 * 60 * 1000;

  PairedDevice copyWith({
    String? roleId,
    String? roleName,
    bool? active,
  }) =>
      PairedDevice(
        id: id,
        label: label,
        role: role,
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        active: active ?? this.active,
        lastSeenMs: lastSeenMs,
      );

  static PairedDevice? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final id = m['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return PairedDevice(
      id: id,
      label: m['label']?.toString() ?? '',
      role: deviceRoleFrom(m['role_hint']),
      roleId: m['role_id']?.toString() ?? '',
      roleName: m['role_name']?.toString() ?? '',
      active: m['active'] != false,
      lastSeenMs:
          DateTime.tryParse(m['last_seen_at']?.toString() ?? '')?.millisecondsSinceEpoch ??
              0,
    );
  }
}

/// A freshly minted pairing code the owner reads out to the other phone.
class PairingCode {
  final String code;
  final DeviceRole role;
  final int expiresAtMs;

  const PairingCode({
    required this.code,
    required this.role,
    required this.expiresAtMs,
  });

  bool expired(DateTime now) => now.millisecondsSinceEpoch >= expiresAtMs;

  static PairingCode? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final code = m['code']?.toString();
    if (code == null || code.length != 6) return null;
    return PairingCode(
      code: code,
      role: deviceRoleFrom(m['role_hint']),
      expiresAtMs:
          DateTime.tryParse(m['expires_at']?.toString() ?? '')?.millisecondsSinceEpoch ??
              DateTime.now().add(const Duration(minutes: 15)).millisecondsSinceEpoch,
    );
  }
}
