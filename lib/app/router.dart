import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n_extension.dart';
import '../core/theme/neu_theme.dart';
import '../core/widgets/neu.dart';
import '../core/widgets/neu_chrome.dart';
import '../features/access/presentation/access_page.dart';
import '../features/access/presentation/audit_page.dart';
import '../features/access/presentation/roles_page.dart';
import '../features/admin/presentation/admin_hub_page.dart';
import '../features/admin/presentation/cash_book_page.dart';
import '../features/admin/presentation/exceptions_page.dart';
import '../features/admin/presentation/item_flow_page.dart';
import '../features/admin/presentation/shops_page.dart';
import '../features/admin/presentation/staff_report_page.dart';
import '../features/analytics/domain/insights.dart';
import '../features/analytics/presentation/insights_page.dart';
import '../features/backup/presentation/backup_page.dart';
import '../features/billing/presentation/bill_page.dart';
import '../features/billing/presentation/tax_report_page.dart';
import '../features/crm/presentation/customers_page.dart';
import '../features/dashboard/domain/dashboard_summary.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/devices/application/device_controller.dart';
import '../features/devices/presentation/devices_page.dart';
import '../features/enquiries/presentation/enquiries_page.dart';
import '../features/events/presentation/events_page.dart';
import '../features/expenses/presentation/day_close_page.dart';
import '../features/expenses/presentation/expenses_page.dart';
import '../features/feedback/presentation/feedback_page.dart';
import '../features/growth/presentation/checklist_page.dart';
import '../features/growth/presentation/growth_page.dart';
import '../features/help/presentation/help_page.dart';
import '../features/jobs/presentation/jobs_page.dart';
import '../features/ledger/presentation/home_page.dart';
import '../features/location/presentation/location_page.dart';
import '../features/mandi/presentation/mandi_page.dart';
import '../features/navigation/presentation/more_hub_page.dart';
import '../features/navigation/presentation/sales_hub_page.dart';
import '../features/offers/presentation/offers_page.dart';
import '../features/orders/presentation/kot_page.dart';
import '../features/orders/presentation/menu_page.dart';
import '../features/orders/presentation/orders_board_page.dart';
import '../features/plan/presentation/plan_page.dart';
import '../features/prep/presentation/prep_page.dart';
import '../features/printing/presentation/printers_page.dart';
import '../features/products/presentation/batches_page.dart';
import '../features/products/presentation/labels_page.dart';
import '../features/products/presentation/payment_qr_page.dart';
import '../features/products/presentation/product_detail_page.dart';
import '../features/products/presentation/product_form_route.dart';
import '../features/products/presentation/products_page.dart';
import '../features/products/presentation/scan_page.dart';
import '../features/products/presentation/stock_page.dart';
import '../features/products/presentation/suppliers_page.dart';
import '../features/profile/domain/shop_type.dart';
import '../features/profile/presentation/shop_page.dart';
import '../features/purchases/presentation/purchases_page.dart';
import '../features/quicksale/presentation/quick_sale_page.dart';
import '../features/recipes/presentation/recipe_detail_page.dart';
import '../features/recipes/presentation/recipes_page.dart';
import '../features/report/presentation/report_page.dart';
import '../features/settings/presentation/appearance_page.dart';
import '../features/settings/presentation/language_page.dart';
import '../features/settings/presentation/market_settings_page.dart';
import '../features/settings/presentation/ordering_settings_page.dart';
import '../features/settings/presentation/payments_settings_page.dart';
import '../features/settings/presentation/profile_settings_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/settings/presentation/shop_settings_page.dart';
import '../features/soundbox/presentation/merchant_onboarding_page.dart';
import '../features/soundbox/presentation/soundbox_page.dart';
import '../features/staff/presentation/staff_page.dart';
import '../features/udhaar/presentation/settle_page.dart';
import '../features/udhaar/presentation/udhaar_page.dart';
import 'routes.dart';
import 'shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Deep links (`vendoros://app/mandi?market=…`, `https://…/udhaar?customer=…`)
/// resolve through the same table as in-app navigation.
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppPaths.home,
  debugLogDiagnostics: false,
  redirect: (context, state) {
    final path = state.uri.path;
    // A paired staff phone (waiter / kitchen / counter) starts on its own
    // working screen instead of the owner's home.
    final staffHome = DeviceController.current;
    if (staffHome.paired &&
        (path == '/' || path.isEmpty || path == AppPaths.home)) {
      return staffHome.homePath;
    }
    if (path == '/' || path.isEmpty) return AppPaths.home;
    return null;
  },
  errorBuilder: (context, state) => _RouteNotFound(uri: state.uri),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppPaths.home,
              name: 'home',
              builder: (_, __) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.orders,
              name: 'orders',
              builder: (_, state) => OrdersBoardPage(
                initialHistory:
                    state.uri.queryParameters[AppQuery.status] == 'history',
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.sales,
              name: 'sales',
              builder: (_, __) => const SalesHubPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.stock,
              name: 'stock',
              builder: (_, __) => const StockPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.more,
              name: 'more',
              builder: (_, __) => const MoreHubPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.menu,
              name: 'menu',
              builder: (_, __) => const MenuPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.kot,
              name: 'kot',
              builder: (_, __) => const KotPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPaths.udhaar,
              name: 'udhaar',
              builder: (_, state) => UdhaarPage(
                focusCustomer: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.customer],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.soundbox,
              name: 'soundbox',
              builder: (_, __) => const SoundboxPage(),
            ),
            GoRoute(
              path: AppPaths.mandi,
              name: 'mandi',
              builder: (_, state) => MandiPage(
                marketParam: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.market],
                ),
                searchParam: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.search],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.report,
              name: 'report',
              builder: (_, state) => ReportPage(
                windowDays: AppQueryParsing.reportWindow(
                  state.uri.queryParameters[AppQuery.window],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.location,
              name: 'location',
              builder: (_, state) => LocationPage(
                autoShare: AppQueryParsing.flag(
                  state.uri.queryParameters[AppQuery.share],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.merchant,
              name: 'merchant',
              builder: (_, __) => const MerchantOnboardingPage(),
            ),
            GoRoute(
              path: AppPaths.help,
              name: 'help',
              builder: (_, __) => const HelpPage(),
            ),
            GoRoute(
              path: AppPaths.products,
              name: 'products',
              builder: (_, state) => ProductsPage(
                searchParam: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.search],
                ),
                lowOnly: AppQueryParsing.flag(
                    state.uri.queryParameters[AppQuery.low]),
              ),
              routes: [
                // `new` must precede `:id` so it is not swallowed by the param route.
                GoRoute(
                  path: 'new',
                  name: 'productNew',
                  builder: (_, state) => ProductFormRoute(
                    initialCode: AppQueryParsing.text(
                      state.uri.queryParameters[AppQuery.code],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  name: 'product',
                  builder: (_, state) => ProductDetailPage(
                      productId: state.pathParameters['id'] ?? ''),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'productEdit',
                      builder: (_, state) => ProductFormRoute(
                          productId: state.pathParameters['id'] ?? ''),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.quickSale,
              name: 'quick',
              builder: (_, __) => const QuickSalePage(),
            ),
            GoRoute(
              path: AppPaths.expenses,
              name: 'expenses',
              builder: (_, __) => const ExpensesPage(),
            ),
            GoRoute(
              path: AppPaths.dayClose,
              name: 'close',
              builder: (_, __) => const DayClosePage(),
            ),
            GoRoute(
              path: AppPaths.insights,
              name: 'insights',
              builder: (_, state) => InsightsPage(
                initialWindow: switch (AppQueryParsing.insightWindow(
                  state.uri.queryParameters[AppQuery.window],
                )) {
                  'day' => InsightWindow.day,
                  'month' => InsightWindow.month,
                  'year' => InsightWindow.year,
                  _ => InsightWindow.week,
                },
              ),
            ),
            GoRoute(
              path: AppPaths.dashboard,
              name: 'dashboard',
              builder: (_, state) => DashboardPage(
                initialWindow: dashboardWindowFrom(
                  AppQueryParsing.dashboardWindow(
                    state.uri.queryParameters[AppQuery.window],
                  ),
                ),
              ),
              routes: [
                GoRoute(
                  path: ':section',
                  name: 'dashboardSection',
                  builder: (_, state) => DashboardPage(
                    section:
                        dashboardSectionFrom(state.pathParameters['section']),
                    initialWindow: dashboardWindowFrom(
                      AppQueryParsing.dashboardWindow(
                        state.uri.queryParameters[AppQuery.window],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.shop,
              name: 'shop',
              builder: (_, state) => ShopPage(
                requested:
                    ShopType.tryParse(state.uri.queryParameters[AppQuery.type]),
              ),
            ),
            GoRoute(
              path: AppPaths.plan,
              name: 'plan',
              builder: (_, __) => const PlanPage(),
            ),
            GoRoute(
              path: AppPaths.recipes,
              name: 'recipes',
              builder: (_, __) => const RecipesPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'recipe',
                  builder: (_, state) => RecipeDetailPage(
                    recipeId: state.pathParameters['id'] ?? '',
                    initialServings: AppQueryParsing.servings(
                      state.uri.queryParameters[AppQuery.servings],
                      fallback: 0,
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.jobs,
              name: 'jobs',
              builder: (_, state) => JobsPage(
                filter: AppQueryParsing.jobFilter(
                  state.uri.queryParameters[AppQuery.status],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.events,
              name: 'events',
              builder: (_, __) => const EventsPage(),
            ),
            GoRoute(
              path: AppPaths.customers,
              name: 'customers',
              builder: (_, __) => const CustomersPage(),
            ),
            GoRoute(
              path: AppPaths.staff,
              name: 'staff',
              builder: (_, __) => const StaffPage(),
            ),
            GoRoute(
              path: AppPaths.growth,
              name: 'growth',
              builder: (_, __) => const GrowthPage(),
            ),
            GoRoute(
              path: AppPaths.checklist,
              name: 'checklist',
              builder: (_, __) => const ChecklistPage(),
            ),
            GoRoute(
              path: AppPaths.prep,
              name: 'prep',
              builder: (_, __) => const PrepPage(),
            ),
            GoRoute(
              path: AppPaths.offers,
              name: 'offers',
              builder: (_, __) => const OffersPage(),
            ),
            GoRoute(
              path: AppPaths.taxReport,
              name: 'taxReport',
              builder: (_, __) => const TaxReportPage(),
            ),
            GoRoute(
              path: AppPaths.feedback,
              name: 'feedback',
              builder: (_, __) => const FeedbackPage(),
            ),
            GoRoute(
              path: AppPaths.enquiries,
              name: 'enquiries',
              builder: (_, __) => const EnquiriesPage(),
            ),
            GoRoute(
              path: AppPaths.bill,
              name: 'bill',
              builder: (_, state) =>
                  BillPage(orderId: state.pathParameters['orderId'] ?? ''),
            ),
            GoRoute(
              path: AppPaths.settle,
              name: 'settle',
              builder: (_, state) => SettlePage(
                customer: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.customer],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.printers,
              name: 'printers',
              builder: (_, __) => const PrintersPage(),
            ),
            GoRoute(
              path: AppPaths.scan,
              name: 'scan',
              builder: (_, __) => const ScanPage(),
            ),
            GoRoute(
              path: AppPaths.batches,
              name: 'batches',
              builder: (_, __) => const BatchesPage(),
            ),
            GoRoute(
              path: AppPaths.suppliers,
              name: 'suppliers',
              builder: (_, __) => const SuppliersPage(),
            ),
            GoRoute(
              path: AppPaths.purchases,
              name: 'purchases',
              builder: (_, __) => const PurchasesPage(),
            ),
            GoRoute(
              path: AppPaths.labels,
              name: 'labels',
              builder: (_, state) => LabelsPage(
                  productId: state.uri.queryParameters[AppQuery.product]),
            ),
            GoRoute(
              path: AppPaths.paymentQr,
              name: 'collect',
              builder: (_, state) => PaymentQrPage(
                amountPaise: AppQueryParsing.amountPaise(
                  state.uri.queryParameters[AppQuery.amount],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.roles,
              name: 'roles',
              builder: (_, __) => const RolesPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'roleNew',
                  builder: (_, __) => const RoleEditPage(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'role',
                  builder: (_, state) =>
                      RoleEditPage(roleId: state.pathParameters['id'] ?? ''),
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.admin,
              name: 'admin',
              builder: (_, __) => const AdminHubPage(),
              routes: [
                GoRoute(
                  path: 'exceptions',
                  name: 'adminExceptions',
                  builder: (_, state) => ExceptionsPage(
                    workerId: AppQueryParsing.text(
                      state.uri.queryParameters[AppQuery.worker],
                    ),
                  ),
                ),
                GoRoute(
                  path: 'staff',
                  name: 'adminStaff',
                  builder: (_, __) => const StaffReportPage(),
                ),
                GoRoute(
                  path: 'cash',
                  name: 'adminCash',
                  builder: (_, __) => const CashBookPage(),
                ),
                GoRoute(
                  path: 'items',
                  name: 'adminItems',
                  builder: (_, __) => const ItemFlowPage(),
                ),
                GoRoute(
                  path: 'shops',
                  name: 'adminShops',
                  builder: (_, __) => const ShopsPage(),
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.access,
              name: 'access',
              builder: (_, __) => const AccessPage(),
            ),
            GoRoute(
              path: AppPaths.audit,
              name: 'audit',
              builder: (_, state) => AuditPage(
                workerId: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.worker],
                ),
                dayKey: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.day],
                  maxLength: 10,
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.devices,
              name: 'devices',
              builder: (_, state) => DevicesPage(
                startPairing: AppQueryParsing.flag(
                  state.uri.queryParameters[AppQuery.pair],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settings,
              name: 'settings',
              builder: (_, __) => const SettingsPage(),
            ),
            GoRoute(
              path: AppPaths.settingsAppearance,
              name: 'settingsAppearance',
              builder: (_, __) => const AppearanceSettingsPage(),
            ),
            GoRoute(
              path: AppPaths.settingsLanguage,
              name: 'settingsLanguage',
              builder: (_, __) => const LanguageSettingsPage(),
            ),
            GoRoute(
              path: AppPaths.settingsProfile,
              name: 'settingsProfile',
              builder: (_, state) => ProfileSettingsPage(
                focus: AppQueryParsing.focus(
                  state.uri.queryParameters[AppQuery.focus],
                  AppQueryParsing.profileFocus,
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settingsShop,
              name: 'settingsShop',
              builder: (_, state) => ShopSettingsPage(
                focus: AppQueryParsing.focus(
                  state.uri.queryParameters[AppQuery.focus],
                  AppQueryParsing.shopFocus,
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settingsPayments,
              name: 'settingsPayments',
              builder: (_, state) => PaymentsSettingsPage(
                focus: AppQueryParsing.focus(
                  state.uri.queryParameters[AppQuery.focus],
                  AppQueryParsing.paymentsFocus,
                ),
                soundbox: AppQueryParsing.toggle(
                  state.uri.queryParameters[AppQuery.soundbox],
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settingsMarket,
              name: 'settingsMarket',
              builder: (_, state) => MarketSettingsPage(
                market: AppQueryParsing.text(
                  state.uri.queryParameters[AppQuery.market],
                ),
                focus: AppQueryParsing.focus(
                  state.uri.queryParameters[AppQuery.focus],
                  AppQueryParsing.marketFocus,
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settingsOrdering,
              name: 'settingsOrdering',
              builder: (_, state) => OrderingSettingsPage(
                focus: AppQueryParsing.focus(
                  state.uri.queryParameters[AppQuery.focus],
                  AppQueryParsing.orderingFocus,
                ),
              ),
            ),
            GoRoute(
              path: AppPaths.settingsBackup,
              name: 'settingsBackup',
              builder: (_, __) => const BackupPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _RouteNotFound extends StatelessWidget {
  final Uri uri;
  const _RouteNotFound({required this.uri});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(title: l10n.notFoundTitle),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: NeuBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.link_off_rounded,
                  size: 40,
                  color: NeuColors.warn,
                ),
                const SizedBox(height: 12),
                Text(
                  uri.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: NeuColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 16),
                NeuButton(
                  onPressed: () => context.go(AppRoutes.home()),
                  child: Text(
                    l10n.goHome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
