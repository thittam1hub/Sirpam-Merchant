import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/core/l10n/l10n_extension.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/core/theme/neu_theme.dart';
import 'package:vendoros/features/crm/presentation/customers_page.dart';
import 'package:vendoros/features/expenses/presentation/day_close_page.dart';
import 'package:vendoros/features/ledger/application/ledger_controller.dart';
import 'package:vendoros/features/ledger/presentation/home_page.dart';
import 'package:vendoros/features/navigation/presentation/more_hub_page.dart';
import 'package:vendoros/features/orders/presentation/orders_board_page.dart';
import 'package:vendoros/features/products/presentation/stock_page.dart';
import 'package:vendoros/features/purchases/presentation/purchases_page.dart';
import 'package:vendoros/features/quicksale/presentation/quick_sale_page.dart';
import 'package:vendoros/features/settings/presentation/settings_page.dart';

/// Smallest phone VendorOS supports (320 dp wide) combined with the biggest
/// system text setting a vendor with weak eyesight will pick. flutter_test
/// fails the test automatically on any RenderFlex overflow raised while
/// laying out these pages, so pumping them is the assertion.
void main() {
  final pages = <String, Widget Function()>{
    'home': HomePage.new,
    'quick sale': QuickSalePage.new,
    'orders board': OrdersBoardPage.new,
    'stock': StockPage.new,
    'purchases': PurchasesPage.new,
    'customers': CustomersPage.new,
    'day close': DayClosePage.new,
    'more hub': MoreHubPage.new,
    'settings': SettingsPage.new,
  };

  for (final entry in pages.entries) {
    testWidgets('${entry.key} fits 320 dp at 2.0 text scale', (t) async {
      t.view.physicalSize = const Size(320, 640);
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);

      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      await t.pumpWidget(
        ProviderScope(
          overrides: [localStoreProvider.overrideWithValue(store)],
          child: MaterialApp.router(
            theme: NeuTheme.build(dark: false),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery.withClampedTextScaling(
              minScaleFactor: 2.0,
              maxScaleFactor: 2.0,
              child: child!,
            ),
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/', builder: (_, __) => entry.value()),
              ],
            ),
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 400));
    });
  }
}
