/// Single source of truth for every navigable location in VendorOS.
///
/// Paths are kept flat and human-readable so they double as deep links:
///   vendoros://app/mandi?market=Koyambedu&q=%E0%AE%A4%E0%AE%95%E0%AF%8D%E0%AE%95%E0%AE%BE%E0%AE%B3%E0%AE%BF (tomato)
///   https://vendoros.app/udhaar?customer=Ravi
library;

class AppPaths {
  static const home = '/home';
  static const udhaar = '/udhaar';
  static const settle = '/settle';
  static const soundbox = '/soundbox';
  static const mandi = '/mandi';
  static const report = '/report';
  static const location = '/location';
  static const settings = '/settings';
  static const settingsLanguage = '/settings/language';
  static const settingsAppearance = '/settings/appearance';
  static const settingsProfile = '/settings/profile';
  static const settingsShop = '/settings/shop';
  static const settingsPayments = '/settings/payments';
  static const settingsMarket = '/settings/market';
  static const settingsOrdering = '/settings/ordering';
  static const settingsBackup = '/settings/backup';
  static const merchant = '/merchant';
  static const help = '/help';
  static const products = '/products';
  static const productNew = '/products/new';
  static const product = '/products/:id';
  static const productEdit = '/products/:id/edit';
  static const scan = '/scan';
  static const stock = '/stock';
  static const batches = '/batches';
  static const suppliers = '/suppliers';
  static const purchases = '/purchases';
  static const labels = '/labels';
  static const paymentQr = '/collect';
  static const quickSale = '/quick';
  static const expenses = '/expenses';
  static const dayClose = '/close';
  static const insights = '/insights';
  static const dashboard = '/dashboard';
  static const dashboardSection = '/dashboard/:section';
  static const shop = '/shop';
  static const plan = '/plan';
  static const orders = '/orders';
  static const kot = '/kot';
  static const bill = '/bill/:orderId';
  static const menu = '/menu';
  static const printers = '/printers';
  static const recipes = '/recipes';
  static const recipe = '/recipes/:id';
  static const jobs = '/jobs';
  static const events = '/events';
  static const customers = '/customers';
  static const staff = '/staff';
  static const growth = '/growth';
  static const checklist = '/checklist';
  static const prep = '/prep';
  static const offers = '/offers';
  static const feedback = '/feedback';
  static const enquiries = '/enquiries';
  static const roles = '/roles';
  static const roleNew = '/roles/new';
  static const role = '/roles/:id';
  static const access = '/access';
  static const audit = '/audit';
  static const devices = '/devices';
  static const sales = '/sales';
  static const more = '/more';
  static const taxReport = '/reports/gst';
  static const admin = '/admin';
  static const adminExceptions = '/admin/exceptions';
  static const adminStaff = '/admin/staff';
  static const adminCash = '/admin/cash';
  static const adminItems = '/admin/items';
  static const adminShops = '/admin/shops';
}

/// Query-parameter keys shared by builders and page readers.
class AppQuery {
  static const market = 'market';
  static const search = 'q';
  static const customer = 'customer';
  static const window = 'window';
  static const share = 'share';
  static const low = 'low';
  static const product = 'product';
  static const amount = 'amount';
  static const code = 'code';
  static const status = 'status';
  static const servings = 'servings';
  static const worker = 'worker';
  static const day = 'day';
  static const focus = 'focus';
  static const soundbox = 'soundbox';
  static const type = 'type';
  static const pair = 'pair';
}

/// Type-safe location builders — never hand-concatenate a URL elsewhere.
class AppRoutes {
  const AppRoutes._();

  static String home() => AppPaths.home;

  static String soundbox() => AppPaths.soundbox;

  static String sales() => AppPaths.sales;

  static String more() => AppPaths.more;

  static String settle(String customer) =>
      _withQuery(AppPaths.settle, {AppQuery.customer: customer});

  static String udhaar({String? customer}) =>
      _withQuery(AppPaths.udhaar, {AppQuery.customer: customer});

  static String mandi({String? market, String? search}) => _withQuery(
    AppPaths.mandi,
    {AppQuery.market: market, AppQuery.search: search},
  );

  static String report({int? windowDays}) =>
      _withQuery(AppPaths.report, {AppQuery.window: windowDays?.toString()});

  static String location({bool share = false}) =>
      _withQuery(AppPaths.location, {AppQuery.share: share ? '1' : null});

  static String settings() => AppPaths.settings;

  static String settingsLanguage() => AppPaths.settingsLanguage;

  static String settingsAppearance() => AppPaths.settingsAppearance;

  static String settingsProfile({String? focus}) =>
      _withQuery(AppPaths.settingsProfile, {AppQuery.focus: focus});

  static String settingsShop({String? focus}) =>
      _withQuery(AppPaths.settingsShop, {AppQuery.focus: focus});

  static String settingsPayments({String? focus, bool? soundbox}) =>
      _withQuery(AppPaths.settingsPayments, {
        AppQuery.focus: focus,
        AppQuery.soundbox: soundbox == null ? null : (soundbox ? 'on' : 'off'),
      });

  static String settingsMarket({String? market, String? focus}) => _withQuery(
    AppPaths.settingsMarket,
    {AppQuery.market: market, AppQuery.focus: focus},
  );

  static String settingsOrdering({String? focus}) =>
      _withQuery(AppPaths.settingsOrdering, {AppQuery.focus: focus});

  static String merchant() => AppPaths.merchant;

  static String help() => AppPaths.help;

  static String products({String? search, bool lowOnly = false}) => _withQuery(
    AppPaths.products,
    {AppQuery.search: search, AppQuery.low: lowOnly ? '1' : null},
  );

  static String product(String id) => '${AppPaths.products}/$id';

  static String productNew({String? code}) =>
      _withQuery(AppPaths.productNew, {AppQuery.code: code});

  static String productEdit(String id) => '${AppPaths.products}/$id/edit';

  static String scan() => AppPaths.scan;

  static String stock() => AppPaths.stock;

  static String batches() => AppPaths.batches;

  static String suppliers() => AppPaths.suppliers;

  static String purchases() => AppPaths.purchases;

  static String labels({String? productId}) =>
      _withQuery(AppPaths.labels, {AppQuery.product: productId});

  static String quickSale() => AppPaths.quickSale;

  static String expenses() => AppPaths.expenses;

  static String dayClose() => AppPaths.dayClose;

  static String insights({String? window}) =>
      _withQuery(AppPaths.insights, {AppQuery.window: window});

  static String dashboard({String? window}) =>
      _withQuery(AppPaths.dashboard, {AppQuery.window: window});

  static String dashboardSection(String section, {String? window}) =>
      _withQuery('${AppPaths.dashboard}/$section', {AppQuery.window: window});

  static String shop({String? type}) =>
      _withQuery(AppPaths.shop, {AppQuery.type: type});

  static String plan() => AppPaths.plan;

  static String orders({String? status}) =>
      _withQuery(AppPaths.orders, {AppQuery.status: status});

  static String kot() => AppPaths.kot;

  static String bill(String orderId) => '/bill/$orderId';

  static String menu() => AppPaths.menu;

  static String settingsBackup() => AppPaths.settingsBackup;

  static String printers() => AppPaths.printers;

  static String recipes({String? search}) =>
      _withQuery(AppPaths.recipes, {AppQuery.search: search});

  static String recipe(String id, {int? servings}) => _withQuery(
    '${AppPaths.recipes}/$id',
    {AppQuery.servings: servings?.toString()},
  );

  static String jobs({String? status}) =>
      _withQuery(AppPaths.jobs, {AppQuery.status: status});

  static String events() => AppPaths.events;

  static String customers({String? search}) =>
      _withQuery(AppPaths.customers, {AppQuery.search: search});

  static String staff() => AppPaths.staff;

  static String growth() => AppPaths.growth;

  static String checklist() => AppPaths.checklist;

  static String prep() => AppPaths.prep;

  static String offers() => AppPaths.offers;

  static String feedback() => AppPaths.feedback;

  static String taxReport() => AppPaths.taxReport;

  static String enquiries({String? status}) =>
      _withQuery(AppPaths.enquiries, {AppQuery.status: status});

  static String roles() => AppPaths.roles;

  static String roleNew() => AppPaths.roleNew;

  static String role(String id) => '${AppPaths.roles}/$id';

  static String access() => AppPaths.access;

  static String admin() => AppPaths.admin;

  static String adminExceptions({String? worker}) =>
      _withQuery(AppPaths.adminExceptions, {AppQuery.worker: worker});

  static String devices({bool pair = false}) =>
      _withQuery(AppPaths.devices, {AppQuery.pair: pair ? '1' : null});

  static String audit({String? workerId, String? dayKey}) => _withQuery(
    AppPaths.audit,
    {AppQuery.worker: workerId, AppQuery.day: dayKey},
  );

  static String paymentQr({int? amountPaise}) =>
      _withQuery(AppPaths.paymentQr, {
        AppQuery.amount: amountPaise == null
            ? null
            : (amountPaise / 100).toStringAsFixed(2),
      });

  static String _withQuery(String path, Map<String, String?> params) {
    final entries = params.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value!)}',
        );
    return entries.isEmpty ? path : '$path?${entries.join('&')}';
  }
}

/// Parsing helpers so pages never trust raw URL input.
class AppQueryParsing {
  static const reportWindows = [30, 60, 90];

  static int reportWindow(String? raw, {int fallback = 90}) {
    final v = int.tryParse(raw ?? '');
    return reportWindows.contains(v) ? v! : fallback;
  }

  static String text(String? raw, {int maxLength = 64}) {
    final v = (raw ?? '').trim();
    return v.length <= maxLength ? v : v.substring(0, maxLength);
  }

  static const insightWindows = ['day', 'week', 'month', 'year'];

  /// Insight window from the URL; anything unknown falls back to the week.
  static String insightWindow(String? raw) =>
      insightWindows.contains(raw) ? raw! : 'week';

  static bool flag(String? raw) => raw == '1' || raw == 'true';

  /// Dashboard filters only offer day / week / month; the year lives on
  /// Insights, so anything else in the URL falls back to the day.
  static const dashboardWindows = ['day', 'week', 'month'];

  static String dashboardWindow(String? raw) =>
      dashboardWindows.contains(raw) ? raw! : 'day';

  /// Serving count carried in a recipe link; clamped to something a kitchen
  /// could plausibly cook.
  static int servings(String? raw, {int fallback = 1}) {
    final v = int.tryParse((raw ?? '').trim());
    if (v == null || v <= 0) return fallback;
    return v > 1000 ? 1000 : v;
  }

  static const jobFilters = ['open', 'today', 'done'];

  static String jobFilter(String? raw) =>
      jobFilters.contains(raw) ? raw! : 'open';

  static const profileFocus = ['niche', 'district', 'fssai', 'udyam'];
  static const shopFocus = ['stall', 'owner', 'phone'];
  static const paymentsFocus = ['vpa'];
  static const marketFocus = ['key'];
  static const orderingFocus = ['service', 'pay', 'buttons'];

  /// Focus target from a URL; anything unknown focuses nothing.
  static String? focus(String? raw, List<String> allowed) =>
      allowed.contains(raw) ? raw : null;

  /// Tri-state switch hint: on/off toggles, anything else keeps the saved value.
  static bool? toggle(String? raw) => switch (raw) {
    'on' || '1' || 'true' => true,
    'off' || '0' || 'false' => false,
    _ => null,
  };

  /// Rupee amount from a query string -> paise; null when absent or invalid.
  static int? amountPaise(String? raw) {
    final v = double.tryParse((raw ?? '').trim());
    if (v == null || v <= 0 || v > 10000000) return null;
    return (v * 100).round();
  }
}
