import 'dart:async';
import 'dart:convert';
import 'dart:math';


import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/data/ordering_api.dart';

import '../../staff/application/staff_controller.dart';
import '../../staff/domain/staff.dart';
import '../domain/permission.dart';
import '../domain/role.dart';
import '../domain/shift_session.dart';

/// Salted SHA-256 of a PIN. Not a password vault — it stops a curious helper
/// reading another worker's PIN out of device storage, which is the threat
/// that actually exists on a shared counter phone.
String hashPin(String pin, String salt) =>
    sha256.convert(utf8.encode('$salt|${pin.trim()}')).toString();

String newSalt([Random? rng]) {
  final r = rng ?? Random.secure();
  return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'))
      .join();
}

bool isValidPin(String pin) =>
    RegExp(r'^\d{4,6}$').hasMatch(pin.trim());

class AccessState {
  final List<ShopRole> roles;
  final AccessSettings settings;
  final ShiftSession? session;
  final List<AuditEntry> audit;

  const AccessState({
    this.roles = const [],
    this.settings = const AccessSettings(),
    this.session,
    this.audit = const [],
  });

  AccessState copyWith({
    List<ShopRole>? roles,
    AccessSettings? settings,
    ShiftSession? session,
    bool clearSession = false,
    List<AuditEntry>? audit,
  }) =>
      AccessState(
        roles: roles ?? this.roles,
        settings: settings ?? this.settings,
        session: clearSession ? null : (session ?? this.session),
        audit: audit ?? this.audit,
      );

  static const ownerRole = ShopRole(
      id: ShopRole.ownerId, name: 'Owner', permissions: {}, active: true);

  List<ShopRole> get activeRoles => [
        for (final r in roles)
          if (r.active) r,
      ];

  ShopRole? roleById(String id) {
    if (id == ShopRole.ownerId) return ownerRole;
    return roles.where((r) => r.id == id).firstOrNull;
  }

  /// The role in force right now. With access control off, or when nobody has
  /// started a shift, the device behaves as the owner.
  ShopRole get currentRole {
    if (!settings.enabled || session == null) return ownerRole;
    return roleById(session!.roleId) ??
        const ShopRole(id: 'none', name: '', permissions: {});
  }

  bool get isOwnerShift => currentRole.isOwner;

  bool can(Permission p) => currentRole.allows(p);

  /// True when the action is allowed AND the amount is inside the role limit.
  bool canAmount(Permission p, int amountPaise) =>
      can(p) && currentRole.withinLimit(p, amountPaise);

  List<AuditEntry> auditFor({String? workerId, String? dayKey}) => [
        for (final e in audit)
          if ((workerId == null || workerId.isEmpty || e.workerId == workerId) &&
              (dayKey == null || dayKey.isEmpty || e.dayKey == dayKey))
            e,
      ]..sort((a, b) => b.ts.compareTo(a.ts));
}

class AccessController extends Notifier<AccessState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  AccessState build() {
    final access = _store.readAccess() ?? {};
    return AccessState(
      roles: [
        for (final row in _store.readRoles())
          ...[ShopRole.tryFromJson(row)].whereType<ShopRole>(),
      ],
      settings: AccessSettings.fromJson(access),
      session: ShiftSession.tryFromJson(
          (access['session'] as Map?)?.cast<String, dynamic>()),
      audit: [
        for (final row in _store.readAudit())
          ...[AuditEntry.tryFromJson(row)].whereType<AuditEntry>(),
      ],
    );
  }

  int get _now => DateTime.now().millisecondsSinceEpoch;

  Future<void> _persistRoles() async {
    await guardWrite(
        ref, () => _store.writeRoles([for (final r in state.roles) r.toJson()]));
    unawaited(publishRolesToCloud());
  }

  /// Pushes the role list to the shop's cloud row so paired waiter, kitchen
  /// and counter phones are held to the same limits server-side, not only by
  /// the buttons hidden on this phone. Silent on failure: the shop keeps
  /// working offline and the next role edit republishes.
  Future<bool> publishRolesToCloud() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return false;
    try {
      await OrderingApi().publishRoles(
        slug: shop.slug,
        shopKey: shop.shopKey,
        roles: [for (final r in state.roles) r.toJson()],
      );
      return true;
    } catch (_) {
      return false;
    }
  }


  Future<void> _persistAccess() => guardWrite(
      ref,
      () => _store.writeAccess({
            ...state.settings.toJson(),
            'session': state.session?.toJson(),
          }));

  Future<void> _persistAudit() => guardWrite(
      ref,
      () => _store.writeAudit(
          [for (final e in state.audit.take(500)) e.toJson()]));

  // --- Roles --------------------------------------------------------------

  Future<ShopRole> saveRole({
    String? id,
    required String name,
    String note = '',
    int colorIndex = 0,
    Set<Permission> permissions = const {},
    int maxDiscountPaise = 0,
    int maxCreditPaise = 0,
    int maxRefundPaise = 0,
    bool active = true,
  }) async {
    final trimmed = name.trim();
    final role = ShopRole(
      id: id != null && id.isNotEmpty && id != ShopRole.ownerId
          ? id
          : 'r${DateTime.now().microsecondsSinceEpoch}',
      name: trimmed.isEmpty ? 'Role' : trimmed,
      note: note.trim(),
      colorIndex: colorIndex,
      permissions: permissions,
      maxDiscountPaise: maxDiscountPaise,
      maxCreditPaise: maxCreditPaise,
      maxRefundPaise: maxRefundPaise,
      active: active,
      updatedAt: _now,
    );
    state = state.copyWith(
        roles: [...state.roles.where((r) => r.id != role.id), role]);
    await _persistRoles();
    return role;
  }

  /// Copy an existing role as a starting point — faster than ticking 30 boxes.
  Future<ShopRole?> duplicateRole(String id, String newName) async {
    final source = state.roles.where((r) => r.id == id).firstOrNull;
    if (source == null) return null;
    return saveRole(
      name: newName,
      note: source.note,
      colorIndex: source.colorIndex,
      permissions: {...source.permissions},
      maxDiscountPaise: source.maxDiscountPaise,
      maxCreditPaise: source.maxCreditPaise,
      maxRefundPaise: source.maxRefundPaise,
    );
  }

  /// Roles are deactivated, never deleted, so past audit lines still resolve.
  Future<void> deactivateRole(String id) async {
    state = state.copyWith(roles: [
      for (final r in state.roles)
        r.id == id ? r.copyWith(active: false, updatedAt: _now) : r,
    ]);
    await _persistRoles();
  }

  // --- Settings and PINs --------------------------------------------------

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(settings: state.settings.copyWith(enabled: enabled));
    if (!enabled) state = state.copyWith(clearSession: true);
    await _persistAccess();
  }

  Future<void> setIdleMinutes(int minutes) async {
    final safe = minutes < 0 ? 0 : (minutes > 240 ? 240 : minutes);
    state =
        state.copyWith(settings: state.settings.copyWith(idleMinutes: safe));
    await _persistAccess();
  }

  Future<bool> setOwnerPin(String pin) async {
    if (!isValidPin(pin)) return false;
    final salt = newSalt();
    state = state.copyWith(
        settings: state.settings
            .copyWith(ownerPinHash: hashPin(pin, salt), ownerPinSalt: salt));
    await _persistAccess();
    return true;
  }

  bool verifyOwnerPin(String pin) {
    final s = state.settings;
    if (!s.hasOwnerPin) return false;
    return hashPin(pin, s.ownerPinSalt) == s.ownerPinHash;
  }

  Future<bool> setWorkerPin(String workerId, String pin) async {
    if (!isValidPin(pin)) return false;
    final salt = newSalt();
    await ref
        .read(staffProvider.notifier)
        .setCredentials(workerId, pinHash: hashPin(pin, salt), pinSalt: salt);
    return true;
  }

  bool verifyWorkerPin(Worker worker, String pin) {
    if (worker.pinHash.isEmpty || worker.pinSalt.isEmpty) return false;
    return hashPin(pin, worker.pinSalt) == worker.pinHash;
  }

  // --- Shift sessions -----------------------------------------------------

  /// Start a shift for a worker after their PIN checks out.
  Future<bool> startShift(String workerId, String pin) async {
    final worker =
        ref.read(staffProvider).workers.where((w) => w.id == workerId).firstOrNull;
    if (worker == null || !worker.active) return false;
    if (!verifyWorkerPin(worker, pin)) return false;
    final now = _now;
    state = state.copyWith(
      session: ShiftSession(
        workerId: worker.id,
        workerName: worker.name,
        roleId: worker.roleId,
        startedAt: now,
        lastActiveAt: now,
      ),
    );
    await _persistAccess();
    await record(action: 'shift.start');
    return true;
  }

  /// Owner takes the device back with the owner PIN.
  Future<bool> startOwnerShift(String pin) async {
    if (!verifyOwnerPin(pin)) return false;
    final now = _now;
    state = state.copyWith(
      session: ShiftSession(
        workerId: ShopRole.ownerId,
        workerName: '',
        roleId: ShopRole.ownerId,
        startedAt: now,
        lastActiveAt: now,
      ),
    );
    await _persistAccess();
    await record(action: 'shift.owner');
    return true;
  }

  /// A paired staff phone runs under the role the shop assigned to it. Access
  /// control is switched on so the role's limits actually bite, and the shift
  /// needs no PIN: the device key already proved which phone this is.
  Future<void> applyDeviceRole(String roleId) async {
    final role = state.roleById(roleId);
    if (role == null) return;
    final now = _now;
    state = state.copyWith(
      settings: state.settings.copyWith(enabled: true),
      session: ShiftSession(
        workerId: 'device',
        workerName: role.name,
        roleId: roleId,
        startedAt: state.session?.startedAt ?? now,
        lastActiveAt: now,
      ),
    );
    await _persistAccess();
  }


  Future<void> endShift() async {
    if (state.session != null) await record(action: 'shift.end');
    state = state.copyWith(clearSession: true);
    await _persistAccess();
  }

  /// Called on meaningful interactions; drops the shift once it goes stale.
  Future<void> touch() async {
    final session = state.session;
    if (session == null) return;
    final now = _now;
    if (session.isExpired(now, state.settings.idleMinutes)) {
      state = state.copyWith(clearSession: true);
      await _persistAccess();
      return;
    }
    state = state.copyWith(session: session.touch(now));
  }

  // --- Approvals and audit ------------------------------------------------

  /// Owner override: the owner types their PIN so a blocked action can go
  /// through once, and the approval is written into the trail.
  Future<bool> approveWithOwnerPin({
    required String pin,
    required String action,
    int amountPaise = 0,
    String refType = '',
    String refId = '',
    String note = '',
  }) async {
    if (!verifyOwnerPin(pin)) return false;
    await record(
      action: action,
      amountPaise: amountPaise,
      refType: refType,
      refId: refId,
      note: note,
      approvedByOwner: true,
    );
    return true;
  }

  Future<AuditEntry> record({
    required String action,
    int amountPaise = 0,
    String refType = '',
    String refId = '',
    String note = '',
    bool approvedByOwner = false,
  }) async {
    final session = state.session;
    final entry = AuditEntry(
      id: 'e${DateTime.now().microsecondsSinceEpoch}',
      ts: _now,
      workerId: session?.workerId ?? ShopRole.ownerId,
      workerName: session?.workerName ?? '',
      approvedBy: approvedByOwner ? ShopRole.ownerId : '',
      action: action,
      refType: refType,
      refId: refId,
      amountPaise: amountPaise,
      note: note,
    );
    state = state.copyWith(audit: [entry, ...state.audit].take(500).toList());
    await _persistAudit();
    return entry;
  }
}

final accessProvider =
    NotifierProvider<AccessController, AccessState>(AccessController.new);

/// Convenience for widgets: `ref.watch(canProvider(Permission.voidBill))`.
final canProvider = Provider.family<bool, Permission>(
    (ref, p) => ref.watch(accessProvider).can(p));
