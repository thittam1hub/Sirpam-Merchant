import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import 'settings_widgets.dart';

/// Shop identity: stall name, owner, phone. `?focus=stall|owner|phone`.
class ShopSettingsPage extends ConsumerStatefulWidget {
  final String? focus;
  const ShopSettingsPage({super.key, this.focus});
  @override
  ConsumerState<ShopSettingsPage> createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends ConsumerState<ShopSettingsPage> {
  late final VendorSettings _initial = ref.read(settingsProvider);
  late final _stall = TextEditingController(text: _initial.stallName);
  late final _owner = TextEditingController(text: _initial.ownerName);
  late final _phone = TextEditingController(text: _initial.phone);

  @override
  void dispose() {
    for (final c in [_stall, _owner, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      _stall.text.trim() != _initial.stallName.trim() ||
      _owner.text.trim() != _initial.ownerName.trim() ||
      _phone.text.trim() != _initial.phone.trim();

  Future<void> _save() async {
    await ref.read(settingsProvider.notifier).save(
          ref.read(settingsProvider).copyWith(
                stallName: _stall.text.trim(),
                ownerName: _owner.text.trim(),
                phone: _phone.text.trim(),
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
      title: l10n.settingsShopTitle,
      fallbackLocation: AppPaths.settings,
      isDirty: () => _dirty,
      body: SettingsFormBody(
        saveLabel: l10n.save,
        onSave: _save,
        children: [
          SettingsCard(
            children: [
              SettingsField(
                label: l10n.stallName,
                controller: _stall,
                autofocus: widget.focus == 'stall',
                onChanged: (_) => setState(() {}),
              ),
              SettingsField(
                label: l10n.ownerName,
                controller: _owner,
                autofocus: widget.focus == 'owner',
                onChanged: (_) => setState(() {}),
              ),
              SettingsField(
                label: l10n.mobileNumber,
                controller: _phone,
                keyboard: TextInputType.phone,
                autofocus: widget.focus == 'phone',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
