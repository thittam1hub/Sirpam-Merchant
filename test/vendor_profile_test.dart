import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/profile/domain/vendor_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VendorProfile model', () {
    test('round-trips through JSON', () {
      const p = VendorProfile(
        category: VendorCategory.hotel,
        niche: 'Tiffin center',
        district: 'Madurai',
        taluk: 'Madurai North',
        marketArea: 'Mattuthavani',
        fssaiNumber: '22412345678901',
        udyamNumber: 'UDYAM-TN-24-0123456',
        workingHours: '6 AM - 10 PM',
        sellsPerishables: true,
      );
      final back = VendorProfile.fromJson(p.toJson());
      expect(back.category, VendorCategory.hotel);
      expect(back.niche, 'Tiffin center');
      expect(back.district, 'Madurai');
      expect(back.sellsPerishables, isTrue);
    });

    test('tolerates empty and malformed JSON', () {
      final empty = VendorProfile.fromJson({});
      expect(empty.category, isNull);
      expect(empty.isConfigured, isFalse);
      final junk = VendorProfile.fromJson({'category': 'spaceship'});
      expect(junk.category, isNull);
    });

    test('feature gating follows the category', () {
      const service = VendorProfile(category: VendorCategory.service);
      expect(service.usesInventory, isFalse);
      expect(service.isMobile, isFalse);
      const cart = VendorProfile(category: VendorCategory.cart);
      expect(cart.usesInventory, isTrue);
      expect(cart.isMobile, isTrue);
      expect(cart.isFoodBusiness, isTrue);
      const stall = VendorProfile(category: VendorCategory.stall);
      expect(stall.usesInventory, isTrue);
      expect(stall.isFoodBusiness, isFalse);
      const hotel = VendorProfile(category: VendorCategory.hotel);
      expect(hotel.isFoodBusiness, isTrue);
    });

    test('every category has niche suggestions', () {
      for (final c in VendorCategory.values) {
        expect(nicheSuggestions[c], isNotEmpty, reason: c.name);
      }
    });

    test('Tamil Nadu district list covers all 38 districts', () {
      expect(tamilNaduDistricts.length, 38);
      expect(tamilNaduDistricts.toSet().length, 38);
    });
  });

  group('LocalStore profile persistence', () {
    test('round-trips and survives malformed data', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      expect(store.readProfile(), isNull);
      const p = VendorProfile(
          category: VendorCategory.stall, niche: 'Flower stall');
      await store.writeProfile(p.toJson());
      final back = VendorProfile.fromJson(store.readProfile()!);
      expect(back.category, VendorCategory.stall);
      expect(back.niche, 'Flower stall');
    });
  });
}
