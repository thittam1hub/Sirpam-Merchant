/// Business-type aware roles: which permissions make sense for a trade, and
/// ready-made role templates the owner can apply in one tap.
///
/// The shop type (restaurant, tea shop, ...) decides what the trade actually
/// does all day, so a tea shop owner should never be offered "View kitchen"
/// and a service vendor should never see stock permissions. When no shop
/// type is chosen yet, the broader vendor category drives the filtering.
library;

import '../../profile/domain/shop_type.dart';
import '../../profile/domain/vendor_profile.dart';
import 'permission.dart';

/// True when [p] is meaningful for this trade. Irrelevant permissions are
/// hidden from the role editor so owners tick only what their shop uses.
bool permissionRelevantFor(
  ShopType? type,
  VendorCategory? category,
  Permission p,
) {
  // Service vendors have no inventory at all.
  if (category == VendorCategory.service && p.area == PermissionArea.stock) {
    return false;
  }
  if (type == null) return true;
  switch (p) {
    // Table/order flow with a kitchen exists only where food is served to
    // order — restaurants and hotels.
    case Permission.takeOrder:
    case Permission.changeOrderStatus:
    case Permission.viewKitchen:
    case Permission.editMenu:
    case Permission.cookRecipe:
      return type == ShopType.restaurant || type == ShopType.hotel;
    default:
      return true;
  }
}

/// Permissions of [area] that apply to this trade, for the role editor.
List<Permission> relevantPermissions(
  ShopType? type,
  VendorCategory? category,
  PermissionArea area,
) =>
    [
      for (final p in Permission.ofArea(area))
        if (permissionRelevantFor(type, category, p)) p,
    ];

/// A ready-made role: id (localized in the UI), pre-ticked permissions and
/// sensible money limits in paise (0 = no limit set).
class RoleTemplate {
  final String id;
  final Set<Permission> permissions;
  final int maxDiscountPaise;
  final int maxCreditPaise;

  const RoleTemplate(
    this.id,
    this.permissions, {
    this.maxDiscountPaise = 0,
    this.maxCreditPaise = 0,
  });
}

/// Suggested roles for the vendor's trade. Falls back to the category when
/// no shop type is picked, and to a generic helper otherwise.
List<RoleTemplate> roleTemplatesFor(ShopType? type, VendorCategory? category) {
  switch (type) {
    case ShopType.restaurant:
      return const [
        RoleTemplate('waiter', {
          Permission.takeOrder,
          Permission.viewKitchen,
          Permission.collectUpi,
        }),
        RoleTemplate('kitchen', {
          Permission.viewKitchen,
          Permission.changeOrderStatus,
          Permission.cookRecipe,
          Permission.viewStock,
        }),
        RoleTemplate('cashier', {
          Permission.makeBill,
          Permission.giveDiscount,
          Permission.reprintBill,
          Permission.settleCredit,
          Permission.viewCredit,
          Permission.collectUpi,
          Permission.viewDayTotals,
        }, maxDiscountPaise: 5000),
      ];
    case ShopType.hotel:
      return const [
        RoleTemplate('counter', {
          Permission.takeOrder,
          Permission.makeBill,
          Permission.collectUpi,
          Permission.settleCredit,
          Permission.viewCredit,
        }, maxCreditPaise: 20000),
        RoleTemplate('kitchen', {
          Permission.viewKitchen,
          Permission.changeOrderStatus,
          Permission.cookRecipe,
        }),
      ];
    case ShopType.streetStall:
      return const [
        RoleTemplate('salesHelper', {
          Permission.quickSale,
          Permission.recordSale,
          Permission.collectUpi,
          Permission.viewStock,
        }),
        RoleTemplate('stockKeeper', {
          Permission.viewStock,
          Permission.adjustStock,
          Permission.recordExpense,
          Permission.recordPurchase,
        }),
      ];
    case ShopType.diyStall:
      return const [
        RoleTemplate('jobAssistant', {
          Permission.recordSale,
          Permission.viewCustomers,
          Permission.editCustomers,
          Permission.giveCredit,
          Permission.viewCredit,
        }, maxCreditPaise: 50000),
        RoleTemplate('cashier', {
          Permission.makeBill,
          Permission.giveDiscount,
          Permission.reprintBill,
        }, maxDiscountPaise: 5000),
      ];
    case ShopType.magnetStall:
      return const [
        RoleTemplate('salesHelper', {
          Permission.quickSale,
          Permission.recordSale,
          Permission.collectUpi,
          Permission.viewStock,
          Permission.adjustStock,
        }),
      ];
    case ShopType.teaShop:
      return const [
        RoleTemplate('counterHelper', {
          Permission.quickSale,
          Permission.recordSale,
          Permission.giveCredit,
          Permission.settleCredit,
          Permission.viewCredit,
          Permission.collectUpi,
        }, maxCreditPaise: 20000),
        RoleTemplate('stockKeeper', {
          Permission.recordExpense,
          Permission.recordPurchase,
          Permission.viewStock,
          Permission.adjustStock,
        }),
      ];
    case null:
      if (category == VendorCategory.service) {
        return const [
          RoleTemplate('assistant', {
            Permission.recordSale,
            Permission.giveCredit,
            Permission.settleCredit,
            Permission.viewCredit,
            Permission.viewCustomers,
            Permission.editCustomers,
          }, maxCreditPaise: 50000),
        ];
      }
      return const [
        RoleTemplate('salesHelper', {
          Permission.recordSale,
          Permission.quickSale,
          Permission.collectUpi,
        }),
      ];
  }
}
