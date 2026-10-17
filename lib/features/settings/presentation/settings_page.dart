import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/app_languages.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/vendor_profile.dart';
import 'settings_widgets.dart';

/// Settings hub: compact rows that open one focused page each.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  String _categoryLabel(AppLocalizations l10n, VendorCategory c) => switch (c) {
        VendorCategory.cart => l10n.categoryCart,
        VendorCategory.stall => l10n.categoryStall,
        VendorCategory.hotel => l10n.categoryHotel,
        VendorCategory.service => l10n.categoryService,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);

    String orNotSet(String v) => v.trim().isEmpty ? l10n.settingsNotSet : v.trim();

    final profileValue = [
      if (profile.category != null) _categoryLabel(l10n, profile.category!),
      if (profile.niche.trim().isNotEmpty) profile.niche.trim(),
      if (profile.district.trim().isNotEmpty) profile.district.trim(),
    ].join(' · ');

    final shopValue = [
      if (s.stallName.trim().isNotEmpty) s.stallName.trim(),
      if (s.ownerName.trim().isNotEmpty) s.ownerName.trim(),
      if (s.phone.trim().isNotEmpty) s.phone.trim(),
    ].join(' · ');

    final paymentsValue =
        '${orNotSet(s.upiVpa)} · ${s.soundboxEnabled ? l10n.settingsOn : l10n.settingsOff}';


    return DetailScaffold(
      title: l10n.menuSettings,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsGroup(
                  label: l10n.settingsGroupBusiness,
                  children: [
                    NeuTile(
                      icon: Icons.storefront_rounded,
                      title: l10n.settingsShopTitle,
                      value: shopValue.isEmpty ? l10n.settingsNotSet : shopValue,
                      onTap: () => context.push(AppRoutes.settingsShop()),
                    ),
                    NeuTile(
                      icon: Icons.badge_rounded,
                      title: l10n.profileTitle,
                      value: profileValue.isEmpty
                          ? l10n.settingsNotSet
                          : profileValue,
                      onTap: () => context.push(AppRoutes.settingsProfile()),
                    ),
                  ],
                ),
                SizedBox(height: context.sectionGap),
                SettingsGroup(
                  label: l10n.settingsGroupMoney,
                  children: [
                    NeuTile(
                      icon: Icons.qr_code_2_rounded,
                      title: l10n.settingsPaymentsTitle,
                      value: paymentsValue,
                      iconColor: NeuColors.upi,
                      onTap: () => context.push(AppRoutes.settingsPayments()),
                    ),
                    NeuTile(
                      icon: Icons.room_service_rounded,
                      title: l10n.settingsOrderingTitle,
                      value: l10n.settingsOrderingSubtitle,
                      onTap: () => context.push(AppRoutes.settingsOrdering()),
                    ),
                  ],
                ),
                SizedBox(height: context.sectionGap),
                SettingsGroup(
                  label: l10n.settingsGroupApp,
                  children: [
                    NeuTile(
                      icon: Icons.translate_rounded,
                      title: l10n.language,
                      value: appLanguageFor(s.languageCode).name,
                      onTap: () => context.push(AppRoutes.settingsLanguage()),
                    ),
                    NeuTile(
                      icon: Icons.dark_mode_rounded,
                      title: l10n.appearanceTitle,
                      value: l10n.appearanceSubtitle,
                      onTap: () => context.push(AppRoutes.settingsAppearance()),
                    ),
                    NeuTile(
                      icon: Icons.print_rounded,
                      title: l10n.printersTitle,
                      value: l10n.printersSubtitle,
                      onTap: () => context.push(AppRoutes.printers()),
                    ),
                    NeuTile(
                      icon: Icons.account_balance_rounded,
                      title: l10n.merchantOnboardingTitle,
                      value: l10n.merchantOnboardingSubtitle,
                      onTap: () => context.push(AppRoutes.merchant()),
                    ),
                    NeuTile(
                      icon: Icons.phone_android_rounded,
                      title: l10n.devicesTitle,
                      value: l10n.devicesSubtitle,
                      onTap: () => context.push(AppRoutes.devices()),
                    ),
                    NeuTile(
                      icon: Icons.backup_rounded,
                      title: l10n.backupTitle,
                      value: l10n.backupSubtitle,
                      onTap: () => context.push(AppRoutes.settingsBackup()),
                    ),
                    NeuTile(
                      icon: Icons.receipt_long_rounded,
                      title: l10n.gstReportTitle,
                      value: l10n.gstReportSubtitle,
                      onTap: () => context.push(AppRoutes.taxReport()),
                    ),
                    NeuTile(
                      icon: Icons.workspace_premium_rounded,
                      title: l10n.planTitle,
                      value: l10n.planSubtitle,
                      onTap: () => context.push(AppRoutes.plan()),
                    ),
                    NeuTile(

                      icon: Icons.help_outline_rounded,
                      title: l10n.helpTitle,
                      value: l10n.helpSubtitle,
                      onTap: () => context.push(AppRoutes.help()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
