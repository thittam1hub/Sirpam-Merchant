import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_failure.dart';

/// Offline-first local persistence (SharedPreferences-backed JSON store).
/// Swap point for Isar/Drift if larger datasets are ever needed.
///
/// Reads are tolerant: a truncated, legacy or otherwise malformed document
/// degrades to the empty default instead of crashing the app on launch.
/// Writes are strict: a failed write throws [StorageFailure] so the UI can tell
/// the vendor that the entry was not saved.
class LocalStore {
  final SharedPreferences _prefs;
  LocalStore(this._prefs);

  static Future<LocalStore> init() async =>
      LocalStore(await SharedPreferences.getInstance());

  static const _kSales = 'vendoros.sales.v1';
  static const _kRepayments = 'vendoros.repayments.v1';
  static const _kSettings = 'vendoros.settings.v1';
  static const _kMandiCache = 'vendoros.mandi.cache.v1';
  static const _kSoundboxSync = 'vendoros.soundbox.sync.v1';
  static const _kProducts = 'vendoros.products.v1';
  static const _kBatches = 'vendoros.batches.v1';
  static const _kMovements = 'vendoros.movements.v1';
  static const _kSuppliers = 'vendoros.suppliers.v1';
  static const _kInventorySync = 'vendoros.inventory.sync.v1';
  static const _kProfile = 'vendoros.profile.v1';
  static const _kExpenses = 'vendoros.expenses.v1';
  static const _kRecurring = 'vendoros.recurring.v1';
  static const _kDayClose = 'vendoros.dayclose.v1';
  static const _kOrders = 'vendoros.orders.v1';
  static const _kBills = 'vendoros.bills.v1';
  static const _kPurchases = 'vendoros.purchases.v1';
  static const _kPrinter = 'vendoros.printer.v1';
  static const _kShop = 'vendoros.shop.v1';
  static const _kRecipes = 'vendoros.recipes.v1';
  static const _kJobs = 'vendoros.jobs.v1';
  static const _kEvents = 'vendoros.events.v1';
  static const _kCustomers = 'vendoros.customers.v1';
  static const _kStaff = 'vendoros.staff.v1';
  static const _kAttendance = 'vendoros.attendance.v1';
  static const _kChecklist = 'vendoros.checklist.v1';
  static const _kPrep = 'vendoros.prep.v1';
  static const _kOffers = 'vendoros.offers.v1';
  static const _kFeedback = 'vendoros.feedback.v1';
  static const _kEnquiries = 'vendoros.enquiries.v1';
  static const _kGrowth = 'vendoros.growth.v1';
  static const _kRoles = 'vendoros.roles.v1';
  static const _kAccess = 'vendoros.access.v1';
  static const _kAudit = 'vendoros.audit.v1';
  static const _kPlan = 'vendoros.plan.v1';
  static const _kDeviceLink = 'vendoros.devicelink.v1';
  static const _kBackup = 'vendoros.backup.v1';

  /// Every document that belongs to the shop's books. The backup bundle is
  /// built from exactly this list, so a new feature is one line away from
  /// being backed up too.
  static const backupKeys = <String>[
    _kSales,
    _kRepayments,
    _kSettings,
    _kProducts,
    _kBatches,
    _kMovements,
    _kSuppliers,
    _kProfile,
    _kExpenses,
    _kRecurring,
    _kDayClose,
    _kOrders,
    _kBills,
    _kPurchases,
    _kShop,
    _kRecipes,
    _kJobs,
    _kEvents,
    _kCustomers,
    _kStaff,
    _kAttendance,
    _kChecklist,
    _kPrep,
    _kOffers,
    _kFeedback,
    _kEnquiries,
    _kGrowth,
    _kRoles,
    _kAudit,
  ];

  /// Raw JSON of every book, ready to be wrapped in a backup bundle.
  /// Keys with nothing stored are left out rather than written as null.
  Map<String, Object> exportBooks() {
    final out = <String, Object>{};
    for (final key in backupKeys) {
      final raw = _prefs.getString(key);
      if (raw == null) continue;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map || decoded is List) out[key] = decoded as Object;
      } on FormatException {
        continue;
      }
    }
    return out;
  }

  /// Replaces the books with the ones in a backup bundle. Documents the
  /// bundle does not mention are cleared, so a restore leaves the phone
  /// exactly as the backup found it.
  Future<void> importBooks(Map<String, Object?> books) async {
    for (final key in backupKeys) {
      final value = books[key];
      if (value is Map || value is List) {
        await _write(key, jsonEncode(value));
      } else {
        await _prefs.remove(key);
      }
    }
  }

  /// When the books were last backed up, and where to.
  Map<String, dynamic>? readBackup() => _readMap(_kBackup);
  Future<void> writeBackup(Map<String, dynamic> payload) =>
      _write(_kBackup, jsonEncode(payload));

  Map<String, dynamic>? readPlan() => _readMap(_kPlan);
  Future<void> writePlan(Map<String, dynamic> payload) =>
      _write(_kPlan, jsonEncode(payload));

  /// This phone's pairing to a shop when it is not the owner's device.
  Map<String, dynamic>? readDeviceLink() => _readMap(_kDeviceLink);
  Future<void> writeDeviceLink(Map<String, dynamic> payload) =>
      _write(_kDeviceLink, jsonEncode(payload));




  // --- Roles, device access settings and the audit trail -------------------
  List<Map<String, dynamic>> readRoles() => _readList(_kRoles);
  Future<void> writeRoles(List<Map<String, dynamic>> rows) =>
      _writeList(_kRoles, rows);

  /// Device access settings plus the shift currently holding the phone.
  Map<String, dynamic>? readAccess() => _readMap(_kAccess);
  Future<void> writeAccess(Map<String, dynamic> payload) =>
      _write(_kAccess, jsonEncode(payload));

  List<Map<String, dynamic>> readAudit() => _readList(_kAudit);
  Future<void> writeAudit(List<Map<String, dynamic>> rows) =>
      _writeList(_kAudit, rows);

  // --- Recipes, custom jobs, events, regulars, staff, opening checklist ----

  List<Map<String, dynamic>> readRecipes() => _readList(_kRecipes);
  Future<void> writeRecipes(List<Map<String, dynamic>> rows) =>
      _writeList(_kRecipes, rows);

  List<Map<String, dynamic>> readJobs() => _readList(_kJobs);
  Future<void> writeJobs(List<Map<String, dynamic>> rows) =>
      _writeList(_kJobs, rows);

  List<Map<String, dynamic>> readEvents() => _readList(_kEvents);
  Future<void> writeEvents(List<Map<String, dynamic>> rows) =>
      _writeList(_kEvents, rows);

  List<Map<String, dynamic>> readCustomers() => _readList(_kCustomers);
  Future<void> writeCustomers(List<Map<String, dynamic>> rows) =>
      _writeList(_kCustomers, rows);

  List<Map<String, dynamic>> readStaff() => _readList(_kStaff);
  Future<void> writeStaff(List<Map<String, dynamic>> rows) =>
      _writeList(_kStaff, rows);

  List<Map<String, dynamic>> readAttendance() => _readList(_kAttendance);
  Future<void> writeAttendance(List<Map<String, dynamic>> rows) =>
      _writeList(_kAttendance, rows);

  List<Map<String, dynamic>> readChecklist() => _readList(_kChecklist);
  Future<void> writeChecklist(List<Map<String, dynamic>> rows) =>
      _writeList(_kChecklist, rows);

  /// Morning prep sheet: planned and made quantities for the day.
  List<Map<String, dynamic>> readPrep() => _readList(_kPrep);
  Future<void> writePrep(List<Map<String, dynamic>> rows) =>
      _writeList(_kPrep, rows);

  /// Named discounts and how often each has been used.
  List<Map<String, dynamic>> readOffers() => _readList(_kOffers);
  Future<void> writeOffers(List<Map<String, dynamic>> rows) =>
      _writeList(_kOffers, rows);

  /// Bill feedback ratings left by customers.
  List<Map<String, dynamic>> readFeedback() => _readList(_kFeedback);
  Future<void> writeFeedback(List<Map<String, dynamic>> rows) =>
      _writeList(_kFeedback, rows);

  /// Price enquiries and their follow-ups.
  List<Map<String, dynamic>> readEnquiries() => _readList(_kEnquiries);
  Future<void> writeEnquiries(List<Map<String, dynamic>> rows) =>
      _writeList(_kEnquiries, rows);

  /// Growth kit links (Google Maps / review page) kept outside the shop config
  /// because they are marketing, not billing, data.
  Map<String, dynamic>? readGrowth() => _readMap(_kGrowth);
  Future<void> writeGrowth(Map<String, dynamic> payload) =>
      _write(_kGrowth, jsonEncode(payload));

  /// Vendor business profile: category, niche, TN district, compliance IDs.
  Map<String, dynamic>? readProfile() => _readMap(_kProfile);
  Future<void> writeProfile(Map<String, dynamic> payload) =>
      _write(_kProfile, jsonEncode(payload));

  // --- Costs (daily expenses, recurring supplies, day close) ---------------
  List<Map<String, dynamic>> readExpenses() => _readList(_kExpenses);
  Future<void> writeExpenses(List<Map<String, dynamic>> rows) =>
      _writeList(_kExpenses, rows);

  List<Map<String, dynamic>> readRecurring() => _readList(_kRecurring);
  Future<void> writeRecurring(List<Map<String, dynamic>> rows) =>
      _writeList(_kRecurring, rows);

  List<Map<String, dynamic>> readDayCloses() => _readList(_kDayClose);
  Future<void> writeDayCloses(List<Map<String, dynamic>> rows) =>
      _writeList(_kDayClose, rows);


  // --- Orders, bills, printer and the customer-facing shop config ---------
  List<Map<String, dynamic>> readOrders() => _readList(_kOrders);
  Future<void> writeOrders(List<Map<String, dynamic>> rows) =>
      _writeList(_kOrders, rows);

  List<Map<String, dynamic>> readBills() => _readList(_kBills);
  Future<void> writeBills(List<Map<String, dynamic>> rows) =>
      _writeList(_kBills, rows);

  /// Stock bought from suppliers: what was paid and what is still owed.
  List<Map<String, dynamic>> readPurchases() => _readList(_kPurchases);
  Future<void> writePurchases(List<Map<String, dynamic>> rows) =>
      _writeList(_kPurchases, rows);

  Map<String, dynamic>? readPrinter() => _readMap(_kPrinter);
  Future<void> writePrinter(Map<String, dynamic> payload) =>
      _write(_kPrinter, jsonEncode(payload));

  /// Shop slug, table count and which products are on the public QR menu.
  Map<String, dynamic>? readShop() => _readMap(_kShop);
  Future<void> writeShop(Map<String, dynamic> payload) =>
      _write(_kShop, jsonEncode(payload));

  // --- Inventory (products, batches, stock movements, suppliers) -----------
  List<Map<String, dynamic>> readProducts() => _readList(_kProducts);
  Future<void> writeProducts(List<Map<String, dynamic>> rows) =>
      _writeList(_kProducts, rows);

  List<Map<String, dynamic>> readBatches() => _readList(_kBatches);
  Future<void> writeBatches(List<Map<String, dynamic>> rows) =>
      _writeList(_kBatches, rows);

  List<Map<String, dynamic>> readMovements() => _readList(_kMovements);
  Future<void> writeMovements(List<Map<String, dynamic>> rows) =>
      _writeList(_kMovements, rows);

  List<Map<String, dynamic>> readSuppliers() => _readList(_kSuppliers);
  Future<void> writeSuppliers(List<Map<String, dynamic>> rows) =>
      _writeList(_kSuppliers, rows);

  /// Last successful inventory sync: cursor plus outcome for the UI.
  Map<String, dynamic>? readInventorySync() => _readMap(_kInventorySync);
  Future<void> writeInventorySync(Map<String, dynamic> payload) =>
      _write(_kInventorySync, jsonEncode(payload));

  /// Durable state of the server-confirmed soundbox: paired device key, the
  /// queue of payments still to be announced, and the ones not yet
  /// acknowledged to the server.
  Map<String, dynamic>? readSoundboxSync() => _readMap(_kSoundboxSync);

  Future<void> writeSoundboxSync(Map<String, dynamic> payload) =>
      _write(_kSoundboxSync, jsonEncode(payload));


  List<Map<String, dynamic>> readSales() => _readList(_kSales);
  Future<void> writeSales(List<Map<String, dynamic>> rows) =>
      _writeList(_kSales, rows);

  List<Map<String, dynamic>> readRepayments() => _readList(_kRepayments);
  Future<void> writeRepayments(List<Map<String, dynamic>> rows) =>
      _writeList(_kRepayments, rows);

  Map<String, dynamic> readSettings() => _readMap(_kSettings) ?? {};

  Future<void> writeSettings(Map<String, dynamic> settings) =>
      _write(_kSettings, jsonEncode(settings));

  Map<String, dynamic>? readMandiCache() => _readMap(_kMandiCache);

  Future<void> writeMandiCache(Map<String, dynamic> payload) =>
      _write(_kMandiCache, jsonEncode(payload));

  Map<String, dynamic>? _readMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return decoded.cast<String, dynamic>();
    } on FormatException {
      return null;
    }
  }

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return [];
    }
    if (decoded is! List) return [];
    final rows = <Map<String, dynamic>>[];
    for (final e in decoded) {
      if (e is Map) rows.add(e.cast<String, dynamic>());
    }
    return rows;
  }

  Future<void> _writeList(String key, List<Map<String, dynamic>> rows) =>
      _write(key, jsonEncode(rows));

  Future<void> _write(String key, String value) async {
    try {
      final ok = await _prefs.setString(key, value);
      if (!ok) throw StorageFailure(key, 'setString returned false');
    } on StorageFailure {
      rethrow;
    } catch (e) {
      throw StorageFailure(key, e);
    }
  }
}
