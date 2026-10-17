import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/app/routes.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/access/application/access_controller.dart';
import 'package:vendoros/features/access/domain/permission.dart';
import 'package:vendoros/features/access/domain/role.dart';
import 'package:vendoros/features/access/domain/shift_session.dart';
import 'package:vendoros/features/staff/domain/staff.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('roles', () {
    test('round-trips through JSON and tolerates junk permissions', () {
      const role = ShopRole(
        id: 'r1',
        name: 'Counter',
        note: 'Takes money',
        permissions: {Permission.recordSale, Permission.makeBill},
        maxDiscountPaise: 5000,
      );
      final back = ShopRole.tryFromJson(role.toJson())!;
      expect(back.name, 'Counter');
      expect(back.permissions, contains(Permission.makeBill));
      expect(back.maxDiscountPaise, 5000);

      final junk = ShopRole.tryFromJson({
        'id': 'r2',
        'name': 'Helper',
        'permissions': ['flyToTheMoon', 'voidBill'],
      })!;
      expect(junk.permissions, {Permission.voidBill});
      expect(ShopRole.tryFromJson({'name': 'no id'}), isNull);
    });

    test('the owner role always allows everything', () {
      const owner = ShopRole(id: ShopRole.ownerId, name: 'Owner');
      for (final p in Permission.values) {
        expect(owner.allows(p), isTrue, reason: p.name);
      }
      expect(owner.withinLimit(Permission.giveDiscount, 999999), isTrue);
    });

    test('limits gate the amount, zero means no limit', () {
      const role = ShopRole(
        id: 'r1',
        name: 'Counter',
        permissions: {Permission.giveDiscount, Permission.giveCredit},
        maxDiscountPaise: 5000,
      );
      expect(role.withinLimit(Permission.giveDiscount, 4000), isTrue);
      expect(role.withinLimit(Permission.giveDiscount, 6000), isFalse);
      expect(role.withinLimit(Permission.giveCredit, 999999), isTrue);
    });

    test('toggling a permission adds then removes it', () {
      const role = ShopRole(id: 'r1', name: 'Counter');
      final on = role.toggle(Permission.voidBill);
      expect(on.permissions, {Permission.voidBill});
      expect(on.toggle(Permission.voidBill).permissions, isEmpty);
    });

    test('every permission belongs to a listed area', () {
      final grouped = [
        for (final a in PermissionArea.values) ...Permission.ofArea(a),
      ];
      expect(grouped.toSet(), Permission.values.toSet());
    });
  });

  group('PINs and shifts', () {
    test('the same PIN and salt hash alike, different salts do not', () {
      final saltA = newSalt();
      final saltB = newSalt();
      expect(hashPin('1234', saltA), hashPin('1234', saltA));
      expect(hashPin('1234', saltA), isNot(hashPin('1234', saltB)));
      expect(hashPin('1234', saltA), isNot(hashPin('4321', saltA)));
      expect(hashPin('1234', saltA), isNot(contains('1234')));
    });

    test('only 4 to 6 digit PINs are accepted', () {
      expect(isValidPin('1234'), isTrue);
      expect(isValidPin('123456'), isTrue);
      expect(isValidPin('123'), isFalse);
      expect(isValidPin('1234567'), isFalse);
      expect(isValidPin('abcd'), isFalse);
    });

    test('a shift expires only after the idle window', () {
      const session = ShiftSession(workerId: 'w1', lastActiveAt: 0);
      expect(session.isExpired(5 * 60 * 1000, 10), isFalse);
      expect(session.isExpired(11 * 60 * 1000, 10), isTrue);
      expect(session.isExpired(999 * 60 * 1000, 0), isFalse);
    });
  });

  group('access state', () {
    const counter = ShopRole(
      id: 'r1',
      name: 'Counter',
      permissions: {Permission.recordSale, Permission.giveDiscount},
      maxDiscountPaise: 5000,
    );

    test('behaves as the owner while access control is off', () {
      const state = AccessState(roles: [counter]);
      expect(state.can(Permission.voidBill), isTrue);
      expect(state.isOwnerShift, isTrue);
    });

    test('a worker shift is limited to their role', () {
      const state = AccessState(
        roles: [counter],
        settings: AccessSettings(enabled: true, ownerPinHash: 'h', ownerPinSalt: 's'),
        session: ShiftSession(workerId: 'w1', roleId: 'r1'),
      );
      expect(state.can(Permission.recordSale), isTrue);
      expect(state.can(Permission.voidBill), isFalse);
      expect(state.canAmount(Permission.giveDiscount, 4000), isTrue);
      expect(state.canAmount(Permission.giveDiscount, 6000), isFalse);
      expect(state.isOwnerShift, isFalse);
    });

    test('a deleted role leaves the shift with nothing allowed', () {
      const state = AccessState(
        settings: AccessSettings(enabled: true),
        session: ShiftSession(workerId: 'w1', roleId: 'gone'),
      );
      expect(state.can(Permission.recordSale), isFalse);
    });

    test('audit filters by worker and day, newest first', () {
      final day = DateTime(2026, 5, 4, 10).millisecondsSinceEpoch;
      final entries = [
        AuditEntry(id: 'a', ts: day, workerId: 'w1', action: 'sale'),
        AuditEntry(id: 'b', ts: day + 1000, workerId: 'w2', action: 'bill'),
      ];
      final state = AccessState(audit: entries);
      expect(state.auditFor(workerId: 'w1').single.id, 'a');
      expect(state.auditFor().first.id, 'b');
      expect(state.auditFor(dayKey: '2026-05-04'), hasLength(2));
      expect(state.auditFor(dayKey: '2026-05-05'), isEmpty);
    });
  });

  group('persistence and routes', () {
    test('roles, access settings and audit survive a round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      expect(store.readRoles(), isEmpty);
      expect(store.readAccess(), isNull);

      await store.writeRoles([
        const ShopRole(id: 'r1', name: 'Counter').toJson(),
      ]);
      await store.writeAccess({
        ...const AccessSettings(enabled: true, idleMinutes: 5).toJson(),
        'session': const ShiftSession(workerId: 'w1').toJson(),
      });
      await store.writeAudit([
        const AuditEntry(id: 'a', ts: 1, workerId: 'w1', action: 'sale')
            .toJson(),
      ]);

      expect(ShopRole.tryFromJson(store.readRoles().single)!.name, 'Counter');
      final access = AccessSettings.fromJson(store.readAccess()!);
      expect(access.enabled, isTrue);
      expect(access.idleMinutes, 5);
      expect(AuditEntry.tryFromJson(store.readAudit().single)!.action, 'sale');
    });

    test('workers keep their role and PIN through JSON', () {
      const w = Worker(
          id: 'w1', name: 'Ravi', roleId: 'r1', pinHash: 'h', pinSalt: 's');
      final back = Worker.tryFromJson(w.toJson())!;
      expect(back.roleId, 'r1');
      expect(back.pinHash, 'h');
      final legacy = Worker.tryFromJson({'id': 'w2', 'name': 'Old'})!;
      expect(legacy.roleId, isEmpty);
    });

    test('typed access routes build the expected links', () {
      expect(AppRoutes.roles(), '/roles');
      expect(AppRoutes.role('r1'), '/roles/r1');
      expect(AppRoutes.access(), '/access');
      expect(AppRoutes.audit(), '/audit');
      expect(AppRoutes.audit(workerId: 'w1', dayKey: '2026-05-04'),
          '/audit?worker=w1&day=2026-05-04');
    });
  });
}
