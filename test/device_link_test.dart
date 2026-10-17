import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/app/routes.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/devices/domain/device_link.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('device roles', () {
    test('wire values round-trip and tolerate junk', () {
      for (final r in DeviceRole.values) {
        expect(deviceRoleFrom(deviceRoleWire(r)), r);
      }
      expect(deviceRoleFrom('chef'), DeviceRole.counter);
      expect(deviceRoleFrom(''), DeviceRole.counter);
    });

    test('each role lands on its own working screen', () {
      const key = '0123456789abcdef';
      expect(
          const DeviceLink(slug: 's', deviceKey: key, role: DeviceRole.waiter)
              .homePath,
          '/menu');
      expect(
          const DeviceLink(slug: 's', deviceKey: key, role: DeviceRole.kitchen)
              .homePath,
          '/kot');
      expect(
          const DeviceLink(slug: 's', deviceKey: key, role: DeviceRole.counter)
              .homePath,
          '/orders');
    });
  });

  group('device link', () {
    test('unpaired link is inert', () {
      const link = DeviceLink();
      expect(link.paired, isFalse);
      expect(link.deviceId, isEmpty);
    });

    test('paired link round-trips through JSON', () {
      const link = DeviceLink(
        deviceId: 'd1',
        deviceKey: '0123456789abcdef',
        slug: 'sirpam-tea',
        role: DeviceRole.kitchen,
        label: 'Kitchen phone',
      );
      final back = DeviceLink.fromJson(link.toJson());
      expect(back.paired, isTrue);
      expect(back.role, DeviceRole.kitchen);
      expect(back.homePath, '/kot');
      expect(back.slug, 'sirpam-tea');
    });

    test('malformed JSON degrades to unpaired', () {
      expect(DeviceLink.fromJson(const {'deviceId': 'x'}).paired, isFalse);
      expect(DeviceLink.fromJson(const {'role': 'x', 'slug': 's'}).paired,
          isFalse);
    });

    test('persists through the local store', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      expect(store.readDeviceLink(), isNull);
      await store.writeDeviceLink(const DeviceLink(
        deviceId: 'd',
        deviceKey: '0123456789abcdef',
        slug: 's',
        role: DeviceRole.counter,
      ).toJson());
      final back = DeviceLink.fromJson(store.readDeviceLink()!);
      expect(back.paired, isTrue);
      expect(back.role, DeviceRole.counter);
    });
  });

  group('server rows', () {
    test('paired device parses and reports online by last-seen clock', () {
      final now = DateTime.now().toUtc();
      final d = PairedDevice.tryFromJson({
        'id': 'x',
        'label': 'Waiter 1',
        'role_hint': 'waiter',
        'last_seen_at':
            now.subtract(const Duration(seconds: 30)).toIso8601String(),
      })!;
      expect(d.role, DeviceRole.waiter);
      expect(d.online(now), isTrue);
      final stale = PairedDevice.tryFromJson({
        'id': 'y',
        'last_seen_at':
            now.subtract(const Duration(minutes: 10)).toIso8601String(),
      })!;
      expect(stale.online(now), isFalse);
      expect(PairedDevice.tryFromJson({'label': 'no id'}), isNull);
    });

    test('pairing code parses and expiry is honoured', () {
      final now = DateTime.now().toUtc();
      final future = PairingCode.tryFromJson({
        'code': '123456',
        'expires_at': now.add(const Duration(minutes: 5)).toIso8601String(),
      })!;
      expect(future.code, '123456');
      expect(future.expired(now), isFalse);
      final past = PairingCode.tryFromJson({
        'code': '654321',
        'expires_at':
            now.subtract(const Duration(minutes: 1)).toIso8601String(),
      })!;
      expect(past.expired(now), isTrue);
      expect(PairingCode.tryFromJson({'code': '12345'}), isNull);
    });
  });

  group('routes', () {
    test('typed devices route builds deep links with the pair flag', () {
      expect(AppRoutes.devices(), '/devices');
      expect(AppRoutes.devices(pair: true), '/devices?pair=1');
    });
  });
}
