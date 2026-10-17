/// This phone's multi-device state: pairing, heartbeat, and (owner side) the
/// list of phones currently on the shop.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_failure.dart';
import '../../access/application/access_controller.dart';
import '../../access/domain/permission.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/data/ordering_api.dart';
import '../domain/device_link.dart';

class DeviceState {
  /// This phone's own pairing; empty on the owner's phone.
  final DeviceLink link;

  /// Owner side: phones paired to the shop, last fetched from the server.
  final List<PairedDevice> devices;

  /// Owner side: the most recent pairing code, so it survives a screen rebuild
  /// while the 15-minute window runs.
  final PairingCode? lastCode;

  final String error;

  const DeviceState({
    this.link = const DeviceLink(),
    this.devices = const [],
    this.lastCode,
    this.error = '',
  });

  DeviceState copyWith({
    DeviceLink? link,
    List<PairedDevice>? devices,
    PairingCode? Function()? lastCode,
    String? error,
  }) =>
      DeviceState(
        link: link ?? this.link,
        devices: devices ?? this.devices,
        lastCode: lastCode == null ? this.lastCode : lastCode(),
        error: error ?? this.error,
      );

  bool get paired => link.paired;
}

class DeviceController extends Notifier<DeviceState> {
  final OrderingApi _api = OrderingApi();

  /// Read synchronously by the router redirect: the role home a paired staff
  /// phone should land on, or null on the owner's phone. Updated on every
  /// build/save so it survives hot restarts and unpairing.
  static DeviceLink current = const DeviceLink();

  @override
  DeviceState build() {
    final raw = ref.read(localStoreProvider).readDeviceLink();
    final link = raw == null ? const DeviceLink() : DeviceLink.fromJson(raw);
    current = link;
    return DeviceState(link: link);
  }

  Future<void> _save(DeviceLink link) async {
    current = link;
    state = state.copyWith(link: link);
    await guardWrite(
        ref, () => ref.read(localStoreProvider).writeDeviceLink(link.toJson()));
  }

  /// Owner mints a code. Throws [OrderingApiFailure] with the server reason
  /// (subscription required / device limit reached) for the UI to show.
  Future<PairingCode> createCode({
    required String label,
    required DeviceRole role,
  }) async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) throw const OrderingApiFailure('shop not on cloud');
    final raw = await _api.createPairingCode(
      slug: shop.slug,
      shopKey: shop.shopKey,
      label: label,
      roleHint: deviceRoleWire(role),
    );
    final code = PairingCode.tryFromJson(raw);
    if (code == null) throw const OrderingApiFailure('code failed');
    state = state.copyWith(lastCode: () => code, error: '');
    return code;
  }

  /// Owner refreshes the phone list.
  Future<void> refreshDevices() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return;
    try {
      final rows = await _api.listDevices(slug: shop.slug, shopKey: shop.shopKey);
      state = state.copyWith(
        devices: [
          for (final r in rows)
            if (PairedDevice.tryFromJson(r) case final d?) d,
        ],
        error: '',
      );
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Owner cuts off one phone.
  Future<void> revoke(String deviceId) async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return;
    state = state.copyWith(devices: [
      for (final d in state.devices)
        if (d.id == deviceId) d.copyWith(active: false) else d,
    ]);
    try {
      await _api.revokeDevice(
          slug: shop.slug, shopKey: shop.shopKey, deviceId: deviceId);
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Owner points one paired phone at a custom staff role. The role list is
  /// published first so the server can resolve the id even if the role was
  /// created while offline.
  Future<bool> assignRole({
    required String deviceId,
    required String roleId,
    required String roleName,
  }) async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return false;
    await ref.read(accessProvider.notifier).publishRolesToCloud();
    final before = state.devices;
    state = state.copyWith(devices: [
      for (final d in before)
        if (d.id == deviceId)
          d.copyWith(roleId: roleId, roleName: roleName)
        else
          d,
    ]);
    try {
      await _api.setDeviceRole(
        slug: shop.slug,
        shopKey: shop.shopKey,
        deviceId: deviceId,
        roleId: roleId,
      );
      state = state.copyWith(error: '');
      return true;
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(devices: before, error: e.message);
      return false;
    }
  }

  /// Staff phone pairs itself with the code the owner read out.
  Future<DeviceLink> pair({
    required String slug,
    required String code,
    required String label,
    required DeviceRole role,
  }) async {
    final raw = await _api.pairDevice(
      slug: slug.trim(),
      code: code.trim(),
      label: label.trim().isEmpty ? 'Staff phone' : label.trim(),
      roleHint: deviceRoleWire(role),
    );
    if (raw is! Map) throw const OrderingApiFailure('pairing failed');
    final key = raw['device_key']?.toString() ?? '';
    if (key.length < 16) throw const OrderingApiFailure('pairing failed');
    final shop = raw['shop'];
    final link = DeviceLink(
      slug: slug.trim(),
      deviceKey: key,
      deviceId: raw['device_id']?.toString() ?? '',
      label: label.trim(),
      role: deviceRoleFrom(raw['role_hint']),
      shopName: shop is Map ? shop['name']?.toString() ?? '' : '',
      pairedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _save(link);
    unawaited(syncRoleFromCloud());
    return link;
  }

  /// This phone leaves the shop (it stays revoked server-side only if the
  /// owner revokes it; unpairing locally just forgets the key).
  Future<void> unpair() => _save(const DeviceLink());

  /// Proves the server still honours this phone's key.
  Future<bool> ping() async {
    final link = state.link;
    if (!link.paired) return false;
    try {
      final ok =
          await _api.devicePing(slug: link.slug, deviceKey: link.deviceKey);
      if (ok) unawaited(syncRoleFromCloud());
      return ok;
    } on OrderingApiFailure {
      return false;
    }
  }

  /// Staff phone asks the shop what this device may do, and mirrors that role
  /// locally so the screens show exactly the buttons the server will accept.
  /// The server is the authority; this only keeps the UI honest.
  Future<bool> syncRoleFromCloud() async {
    final link = state.link;
    if (!link.paired) return false;
    Map<String, Object?> profile;
    try {
      profile =
          await _api.deviceProfile(slug: link.slug, deviceKey: link.deviceKey);
    } catch (_) {
      return false;
    }
    final roleId = profile['role_id']?.toString() ?? '';
    if (roleId.isEmpty) return false;
    final names = (profile['permissions'] as List?) ?? const [];
    final permissions = <Permission>{
      for (final n in names)
        if (Permission.tryParse(n.toString()) case final p?) p,
    };
    final access = ref.read(accessProvider.notifier);
    await access.saveRole(
      id: roleId,
      name: profile['role_name']?.toString() ?? link.label,
      permissions: permissions,
      maxDiscountPaise: (profile['max_discount_paise'] as num?)?.toInt() ?? 0,
      maxCreditPaise: (profile['max_credit_paise'] as num?)?.toInt() ?? 0,
      maxRefundPaise: (profile['max_refund_paise'] as num?)?.toInt() ?? 0,
    );
    await access.applyDeviceRole(roleId);
    return true;
  }
}


final deviceProvider =
    NotifierProvider<DeviceController, DeviceState>(DeviceController.new);
