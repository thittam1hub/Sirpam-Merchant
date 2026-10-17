import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'core/settings/settings_controller.dart';
import 'core/storage/local_store.dart';
import 'core/theme/neu_theme.dart';
import 'core/widgets/storage_error_listener.dart';
import 'features/access/application/access_controller.dart';
import 'features/access/presentation/access_page.dart';
import 'features/ledger/application/ledger_controller.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.init();
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const VendorOsApp(),
    ),
  );
}

class VendorOsApp extends ConsumerWidget {
  const VendorOsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final mode = ref.watch(themeModeProvider);
    final dark = switch (mode) {
      'dark' => true,
      'light' => false,
      _ => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: NeuTheme.build(dark: dark),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
      builder: (context, child) => StorageErrorListener(
        child: _ShiftGate(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}

/// Shows the lock screen instead of the app whenever the owner has turned on
/// worker access control and nobody has started a shift on this device.
class _ShiftGate extends ConsumerWidget {
  final Widget child;
  const _ShiftGate({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(accessProvider);
    if (access.settings.enabled && access.session == null) {
      return const ShiftLockView();
    }
    return child;
  }
}
