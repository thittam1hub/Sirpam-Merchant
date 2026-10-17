import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/app/router.dart';
import 'package:vendoros/app/routes.dart';
import 'package:vendoros/core/l10n/l10n_extension.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/core/theme/neu_theme.dart';
import 'package:vendoros/core/widgets/neu_chrome.dart';
import 'package:vendoros/features/ledger/application/ledger_controller.dart';

/// The bottom bar (phone) or side rail (desktop) must stay on every page a
/// vendor can reach, not only on the five tab roots. Losing it mid-task is
/// what made people back out to home just to move on.
void main() {
  Future<void> pumpAt(WidgetTester t, String location, Size size) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.init();
    appRouter.go(location);
    await t.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: MaterialApp.router(
          theme: NeuTheme.build(dark: false),
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: appRouter,
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 400));
  }

  final places = <String>[
    AppPaths.udhaar,
    AppPaths.purchases,
    AppPaths.settings,
  ];

  for (final place in places) {
    testWidgets('$place keeps the bottom bar on a phone', (t) async {
      await pumpAt(t, place, const Size(390, 844));
      expect(find.byType(NeuBottomNav), findsOneWidget);
    });
  }

  tearDown(() => appRouter.go(AppPaths.home));
}
