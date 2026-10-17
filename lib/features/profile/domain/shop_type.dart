/// The Tamil Nadu trades VendorOS ships a ready-made shop page for.
///
/// [VendorCategory] still decides which features exist at all (a service
/// vendor has no stock); the shop type decides how one trade's day is laid
/// out: what it watches, what it sells, and the order it works in.
library;

import 'vendor_profile.dart';

enum ShopType {
  /// Sit-down TN restaurant: tables, KOT queue, meal-time peaks.
  restaurant,

  /// Lodge / hotel counter: tiffin and meals, office credit.
  hotel,

  /// Street stall or cart: cash and UPI, perishables, quick sales.
  streetStall,

  /// DIY / craft stall: made-to-order jobs, advances, materials.
  diyStall,

  /// Fridge magnet stall: designs held as stock, event-driven sales.
  magnetStall,

  /// Tea shop: cups per day, milk and gas cost, street regulars.
  teaShop;

  static ShopType? tryParse(String? raw) {
    for (final t in values) {
      if (t.name == raw) return t;
    }
    return null;
  }

  /// Feature category this trade belongs to, so profile gating stays honest.
  VendorCategory get category => switch (this) {
        ShopType.restaurant || ShopType.hotel => VendorCategory.hotel,
        ShopType.teaShop => VendorCategory.hotel,
        ShopType.streetStall => VendorCategory.cart,
        ShopType.diyStall || ShopType.magnetStall => VendorCategory.stall,
      };

  /// True when the trade cooks or sells food (FSSAI, expiry, wastage).
  bool get isFood => switch (this) {
        ShopType.diyStall || ShopType.magnetStall => false,
        _ => true,
      };

  /// The screens this trade uses, in the order the day actually runs.
  List<ShopStep> get workflow => switch (this) {
        ShopType.restaurant => const [
            ShopStep.orders,
            ShopStep.kot,
            ShopStep.bill,
            ShopStep.dayClose,
          ],
        ShopType.hotel => const [
            ShopStep.orders,
            ShopStep.bill,
            ShopStep.credit,
            ShopStep.dayClose,
          ],
        ShopType.streetStall => const [
            ShopStep.quickSale,
            ShopStep.soundbox,
            ShopStep.stock,
            ShopStep.dayClose,
          ],
        ShopType.diyStall => const [
            ShopStep.jobs,
            ShopStep.customers,
            ShopStep.bill,
            ShopStep.dayClose,
          ],
        ShopType.magnetStall => const [
            ShopStep.quickSale,
            ShopStep.stock,
            ShopStep.events,
            ShopStep.dayClose,
          ],
        ShopType.teaShop => const [
            ShopStep.quickSale,
            ShopStep.credit,
            ShopStep.expenses,
            ShopStep.dayClose,
          ],
      };
}

/// One step of a trade's daily workflow; the page maps it to a route.
enum ShopStep {
  orders,
  kot,
  bill,
  quickSale,
  credit,
  stock,
  jobs,
  events,
  customers,
  expenses,
  soundbox,
  dayClose,
}
