/// What a worker is allowed to do on the shop device.
///
/// The list is flat so it survives JSON round-trips as plain strings; the
/// [PermissionArea] grouping only drives how the owner sees it on screen.
library;

enum PermissionArea {
  sales,
  orders,
  billing,
  credit,
  stock,
  purchases,
  money,
  customers,
  staff,
  settings,
}

enum Permission {
  // Sales
  recordSale(PermissionArea.sales),
  quickSale(PermissionArea.sales),
  collectUpi(PermissionArea.sales),

  // Orders & kitchen
  takeOrder(PermissionArea.orders),
  changeOrderStatus(PermissionArea.orders),
  viewKitchen(PermissionArea.orders),
  editMenu(PermissionArea.orders),

  // Billing
  makeBill(PermissionArea.billing),
  giveDiscount(PermissionArea.billing),
  voidBill(PermissionArea.billing),
  reprintBill(PermissionArea.billing),

  // Credit
  giveCredit(PermissionArea.credit),
  settleCredit(PermissionArea.credit),
  viewCredit(PermissionArea.credit),

  // Stock
  viewStock(PermissionArea.stock),
  adjustStock(PermissionArea.stock),
  editProducts(PermissionArea.stock),
  changePrice(PermissionArea.stock),
  cookRecipe(PermissionArea.stock),

  // Purchases & expenses
  recordExpense(PermissionArea.purchases),
  manageSuppliers(PermissionArea.purchases),
  recordPurchase(PermissionArea.purchases),
  paySupplier(PermissionArea.purchases),

  // Money & reports
  viewDayTotals(PermissionArea.money),
  viewProfit(PermissionArea.money),
  closeDay(PermissionArea.money),
  viewReports(PermissionArea.money),
  viewCashBook(PermissionArea.money),
  exportData(PermissionArea.money),

  // Customers
  viewCustomers(PermissionArea.customers),
  editCustomers(PermissionArea.customers),

  // Staff
  manageStaff(PermissionArea.staff),
  markAttendance(PermissionArea.staff),
  payWages(PermissionArea.staff),
  manageRoles(PermissionArea.staff),
  viewAudit(PermissionArea.staff),
  viewStaffReport(PermissionArea.staff),

  // Settings & cloud
  editSettings(PermissionArea.settings),
  editShop(PermissionArea.settings),
  managePrinters(PermissionArea.settings);

  final PermissionArea area;
  const Permission(this.area);

  static Permission? tryParse(String? raw) {
    for (final p in values) {
      if (p.name == raw) return p;
    }
    return null;
  }

  static Set<Permission> parseAll(Object? raw) {
    if (raw is! List) return const {};
    return {
      for (final e in raw)
        ...[Permission.tryParse(e is String ? e : null)].whereType<Permission>(),
    };
  }

  static List<Permission> ofArea(PermissionArea area) =>
      [for (final p in values) if (p.area == area) p];
}
