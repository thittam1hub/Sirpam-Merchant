import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu_chrome.dart';
import 'settings_widgets.dart';

/// Light / dark / follow-the-phone picker. Applies instantly.
class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  Future<void> _set(BuildContext context, WidgetRef ref, String mode) async {
    final current = ref.read(settingsProvider);
    if (current.themeMode == mode) return;
    await ref
        .read(settingsProvider.notifier)
        .save(current.copyWith(themeMode: mode));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.appearanceChanged)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(settingsProvider).themeMode;
    final options = <(String, String, IconData)>[
      ('system', l10n.appearanceSystem, Icons.brightness_auto_rounded),
      ('light', l10n.appearanceLight, Icons.light_mode_rounded),
      ('dark', l10n.appearanceDark, Icons.dark_mode_rounded),
    ];
    return DetailScaffold(
      title: l10n.appearanceTitle,
      fallbackLocation: AppPaths.settings,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: SettingsCard(
              children: [
                for (final option in options)
                  NeuTile(
                    icon: option.$3,
                    title: option.$2,
                    value: mode == option.$1 ? l10n.settingsOn : null,
                    onTap: () => _set(context, ref, option.$1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
