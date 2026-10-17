import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/access/domain/permission.dart';
import 'package:vendoros/features/access/domain/role_templates.dart';
import 'package:vendoros/features/profile/domain/shop_type.dart';
import 'package:vendoros/features/profile/domain/vendor_profile.dart';

void main() {
  group('role templates per shop type', () {
    test('every shop type has at least one template', () {
      for (final t in ShopType.values) {
        expect(roleTemplatesFor(t, t.category), isNotEmpty, reason: t.name);
      }
    });

    test('template ids are unique within a shop type', () {
      for (final t in ShopType.values) {
        final ids = roleTemplatesFor(t, t.category).map((e) => e.id).toList();
        expect(ids.toSet().length, ids.length, reason: t.name);
      }
    });

    test('templates only grant permissions relevant to the trade', () {
      for (final t in ShopType.values) {
        for (final tmpl in roleTemplatesFor(t, t.category)) {
          for (final p in tmpl.permissions) {
            expect(permissionRelevantFor(t, t.category, p), isTrue,
                reason: '${t.name}/${tmpl.id}/${p.name}');
          }
        }
      }
    });

    test('restaurant suggests waiter, kitchen and cashier', () {
      final ids =
          roleTemplatesFor(ShopType.restaurant, VendorCategory.hotel)
              .map((e) => e.id);
      expect(ids, containsAll(['waiter', 'kitchen', 'cashier']));
    });
  });

  group('permission relevance by business type', () {
    test('tea shop has no order/kitchen permissions', () {
      for (final p in [
        Permission.takeOrder,
        Permission.changeOrderStatus,
        Permission.viewKitchen,
        Permission.editMenu,
        Permission.cookRecipe,
      ]) {
        expect(permissionRelevantFor(ShopType.teaShop, VendorCategory.hotel, p),
            isFalse,
            reason: p.name);
      }
      expect(
          permissionRelevantFor(
              ShopType.teaShop, VendorCategory.hotel, Permission.quickSale),
          isTrue);
    });

    test('restaurant keeps the full order and kitchen flow', () {
      for (final p in [
        Permission.takeOrder,
        Permission.changeOrderStatus,
        Permission.viewKitchen,
        Permission.cookRecipe,
      ]) {
        expect(
            permissionRelevantFor(
                ShopType.restaurant, VendorCategory.hotel, p),
            isTrue,
            reason: p.name);
      }
    });

    test('service vendors never see stock permissions', () {
      for (final p in Permission.ofArea(PermissionArea.stock)) {
        expect(permissionRelevantFor(null, VendorCategory.service, p), isFalse,
            reason: p.name);
      }
      // …but still keep credit, which services run on.
      expect(
          permissionRelevantFor(
              null, VendorCategory.service, Permission.giveCredit),
          isTrue);
    });

    test('relevant permission lists skip empty areas', () {
      final teaOrders = relevantPermissions(
          ShopType.teaShop, VendorCategory.hotel, PermissionArea.orders);
      expect(teaOrders, isEmpty);
      final restaurantOrders = relevantPermissions(
          ShopType.restaurant, VendorCategory.hotel, PermissionArea.orders);
      expect(restaurantOrders, isNotEmpty);
    });

    test('unknown shop type falls back to category-level filtering', () {
      // No type chosen: everything stays visible except service stock.
      expect(permissionRelevantFor(null, VendorCategory.stall,
          Permission.takeOrder), isTrue);
      final fallback = roleTemplatesFor(null, VendorCategory.service);
      expect(fallback.single.id, 'assistant');
    });
  });
}
