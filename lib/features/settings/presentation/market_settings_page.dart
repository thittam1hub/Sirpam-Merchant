import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../mandi/application/mandi_controller.dart';
import 'settings_widgets.dart';

/// Market source + data.gov.in key. `?market=<name>` presets the market,
/// `?focus=key` focuses the API key field.
class MarketSettingsPage extends ConsumerStatefulWidget {
  final String? market;
  final String? focus;
  const MarketSettingsPage({super.key, this.market, this.focus});
  @override
  ConsumerState<MarketSettingsPage> createState() =>
      _MarketSettingsPageState();
}

class _MarketSettingsPageState extends ConsumerState<MarketSettingsPage> {
  late final VendorSettings _initial = ref.read(settingsProvider);
  late final _key = TextEditingController(text: _initial.mandiApiKey);
  late String _market = MandiController.markets.contains(widget.market)
      ? widget.market!
      : (MandiController.markets.contains(_initial.market)
          ? _initial.market
          : MandiController.markets.first);

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  bool get _dirty =>
      _key.text.trim() != _initial.mandiApiKey.trim() ||
      _market != _initial.market;

  Future<void> _save() async {
    await ref.read(settingsProvider.notifier).save(
          ref.read(settingsProvider).copyWith(
                mandiApiKey: _key.text.trim(),
                market: _market,
              ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.settingsSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: l10n.settingsMarketTitle,
      fallbackLocation: AppPaths.settings,
      isDirty: () => _dirty,
      body: SettingsFormBody(
        saveLabel: l10n.save,
        onSave: _save,
        children: [
          SettingsCard(
            children: [
              SettingsPicker(
                label: l10n.mandiMarket,
                value: _market,
                options: MandiController.markets,
                onChanged: (v) => setState(() => _market = v),
              ),
              SettingsField(
                label: l10n.mandiApiKeyLabel,
                controller: _key,
                helper: l10n.apiKeyHelp,
                autofocus: widget.focus == 'key',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
