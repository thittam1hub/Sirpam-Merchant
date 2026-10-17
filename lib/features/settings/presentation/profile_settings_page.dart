import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/vendor_profile.dart';
import 'settings_widgets.dart';

/// Business profile: type, niche, place and compliance ids.
/// `?focus=niche|district|fssai|udyam`.
class ProfileSettingsPage extends ConsumerStatefulWidget {
  final String? focus;
  const ProfileSettingsPage({super.key, this.focus});
  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  late final VendorProfile _initial = ref.read(profileProvider);
  late VendorCategory? _category = _initial.category;
  late final _niche = TextEditingController(text: _initial.niche);
  late final _taluk = TextEditingController(text: _initial.taluk);
  late final _marketArea = TextEditingController(text: _initial.marketArea);
  late final _fssai = TextEditingController(text: _initial.fssaiNumber);
  late final _udyam = TextEditingController(text: _initial.udyamNumber);
  late final _hours = TextEditingController(text: _initial.workingHours);
  late String _district = _initial.district;
  late bool _perishable = _initial.sellsPerishables;

  @override
  void dispose() {
    for (final c in [_niche, _taluk, _marketArea, _fssai, _udyam, _hours]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      _category != _initial.category ||
      _niche.text.trim() != _initial.niche.trim() ||
      _taluk.text.trim() != _initial.taluk.trim() ||
      _marketArea.text.trim() != _initial.marketArea.trim() ||
      _fssai.text.trim() != _initial.fssaiNumber.trim() ||
      _udyam.text.trim() != _initial.udyamNumber.trim() ||
      _hours.text.trim() != _initial.workingHours.trim() ||
      _district != _initial.district ||
      _perishable != _initial.sellsPerishables;

  Future<void> _save() async {
    await ref.read(profileProvider.notifier).save(
          ref.read(profileProvider).copyWith(
                category: () => _category,
                niche: _niche.text.trim(),
                district: _district,
                taluk: _taluk.text.trim(),
                marketArea: _marketArea.text.trim(),
                fssaiNumber: _fssai.text.trim(),
                udyamNumber: _udyam.text.trim(),
                workingHours: _hours.text.trim(),
                sellsPerishables: _perishable,
              ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.profileSaved)));
  }

  String _categoryLabel(AppLocalizations l10n, VendorCategory c) => switch (c) {
        VendorCategory.cart => l10n.categoryCart,
        VendorCategory.stall => l10n.categoryStall,
        VendorCategory.hotel => l10n.categoryHotel,
        VendorCategory.service => l10n.categoryService,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final suggestions =
        _category == null ? const <String>[] : nicheSuggestions[_category]!;
    final showFssai = _category == VendorCategory.hotel ||
        _category == VendorCategory.cart;
    return DetailScaffold(
      title: l10n.profileTitle,
      fallbackLocation: AppPaths.settings,
      isDirty: () => _dirty,
      body: SettingsFormBody(
        saveLabel: l10n.save,
        onSave: _save,
        children: [
          SettingsCard(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.vendorCategory,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.inkSoft)),
                  const SizedBox(height: 10),
                  SettingsSegmented<VendorCategory>(
                    value: _category,
                    options: [
                      for (final c in VendorCategory.values)
                        (c, _categoryLabel(l10n, c)),
                    ],
                    onChanged: (c) => setState(() => _category = c),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsField(
                    label: l10n.nicheLabel,
                    controller: _niche,
                    autofocus: widget.focus == 'niche',
                    onChanged: (_) => setState(() {}),
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final n in suggestions)
                          NeuButton(
                            minHeight: 40,
                            radius: 20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            onPressed: () => setState(() => _niche.text = n),
                            child: Text(n,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: NeuColors.inkSoft)),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SettingsCard(
            children: [
              SettingsPicker(
                label: l10n.districtLabel,
                value: _district,
                options: tamilNaduDistricts,
                onChanged: (v) => setState(() => _district = v),
              ),
              SettingsField(
                label: l10n.talukLabel,
                controller: _taluk,
                onChanged: (_) => setState(() {}),
              ),
              SettingsField(
                label: l10n.marketAreaLabel,
                controller: _marketArea,
                onChanged: (_) => setState(() {}),
              ),
              SettingsField(
                label: l10n.workingHoursLabel,
                controller: _hours,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SettingsCard(
            children: [
              if (showFssai)
                SettingsField(
                  label: l10n.fssaiLabel,
                  controller: _fssai,
                  autofocus: widget.focus == 'fssai',
                  onChanged: (_) => setState(() {}),
                ),
              SettingsField(
                label: l10n.udyamLabel,
                controller: _udyam,
                autofocus: widget.focus == 'udyam',
                onChanged: (_) => setState(() {}),
              ),
              SettingsToggleRow(
                label: l10n.perishableLabel,
                value: _perishable,
                onChanged: (v) => setState(() => _perishable = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
