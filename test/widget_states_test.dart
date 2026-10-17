import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/core/l10n/l10n_extension.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/ledger/application/ledger_controller.dart';
import 'package:vendoros/features/ledger/presentation/home_page.dart';
import 'package:vendoros/features/mandi/presentation/mandi_page.dart';
import 'package:vendoros/features/soundbox/presentation/soundbox_page.dart';

/// Widget tests for the three "honest state" screens: nothing here may ever
/// render fabricated data.
Future<Widget> _app(Widget child, {Map<String, Object> prefs = const {}}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final store = await LocalStore.init();
  return ProviderScope(
    overrides: [localStoreProvider.overrideWithValue(store)],
    child: MaterialApp(
      locale: const Locale('ta'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  testWidgets('soundbox shows an honest restriction panel on iOS', (t) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await t.pumpWidget(await _app(const SoundboxPage()));
      await t.pump();

      expect(find.text('iOS-ல் கிடைக்காது'), findsOneWidget);
      expect(find.text('அணுகல் கொடு'), findsNothing);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('mandi asks for an API key instead of inventing prices',
      (t) async {
    await t.pumpWidget(await _app(const MandiPage()));
    await t.pumpAndSettle();

    expect(find.text('data.gov.in API சாவி தேவை'), findsOneWidget);
    // No price rows without a real feed.
    expect(find.textContaining('/kg'), findsNothing);
  });

  testWidgets('empty ledger prompts the vendor instead of showing totals',
      (t) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await t.pumpWidget(await _app(const HomePage()));
      await t.pump();

      expect(find.text('இன்றைய வசூல்'), findsOneWidget);
      await t.scrollUntilVisible(
        find.text('இன்னும் பதிவு இல்லை — மைக் அழுத்தி பேசவும்'),
        320,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('இன்னும் பதிவு இல்லை — மைக் அழுத்தி பேசவும்'),
          findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
