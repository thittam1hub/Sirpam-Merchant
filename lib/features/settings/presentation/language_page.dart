import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/app_languages.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu_chrome.dart';
import 'settings_widgets.dart';

/// Language picker — applies instantly, no save button, no restart.
class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  Future<void> _set(BuildContext context, WidgetRef ref, String code) async {
    final current = ref.read(settingsProvider);
    if (current.languageCode == code) return;
    await ref
        .read(settingsProvider.notifier)
        .save(current.copyWith(languageCode: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.languageChanged)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final code = ref.watch(settingsProvider).languageCode;
    return DetailScaffold(
      title: l10n.language,
      fallbackLocation: AppPaths.settings,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: SettingsCard(
              children: [
                for (final option in appLanguages)
                  NeuTile(
                    icon: option.code == 'en'
                        ? Icons.abc_rounded
                        : Icons.translate_rounded,
                    title: option.name,
                    value: code == option.code ? l10n.settingsOn : null,
                    onTap: () => _set(context, ref, option.code),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
