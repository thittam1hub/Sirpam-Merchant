import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/navigation_registry.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../access/application/access_controller.dart';
import '../../devices/application/device_controller.dart';
import '../../profile/application/profile_controller.dart';

class MoreHubPage extends ConsumerWidget {
  const MoreHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(accessProvider);
    final device = ref.watch(deviceProvider).link;
    final profile = ref.watch(profileProvider);
    final items =
        AppNavigationRegistry.visible(
              owner: !device.paired,
              usesInventory: profile.usesInventory,
              role: device.paired ? device.role : null,
              can: access.can,
            )
            .where(
              (item) => !{
                AppNavId.home,
                AppNavId.orders,
                AppNavId.sales,
                AppNavId.stock,
              }.contains(item.id),
            )
            .toList();

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(title: context.l10n.moreLabel),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          for (final group in AppNavGroup.values)
            if (items.any((item) => item.group == group)) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
                child: Text(
                  _groupLabel(context, group),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.inkSoft,
                  ),
                ),
              ),
              for (final item in items.where((item) => item.group == group))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    onTap: () => context.push(item.path),
                    child: Row(
                      children: [
                        Icon(item.icon, color: NeuColors.ink, size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item.label(context),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: NeuColors.ink,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: NeuColors.inkSoft,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
        ],
      ),
    );
  }

  String _groupLabel(BuildContext context, AppNavGroup group) =>
      switch (group) {
        AppNavGroup.overview => context.l10n.navGroupOverview,
        AppNavGroup.sell => context.l10n.navGroupSell,
        AppNavGroup.inventory => context.l10n.menuInventory,
        AppNavGroup.operations => context.l10n.navGroupOperations,
        AppNavGroup.business => context.l10n.navGroupBusiness,
        AppNavGroup.team => context.l10n.navGroupTeam,
        AppNavGroup.grow => context.l10n.menuGrowSection,
        AppNavGroup.system => context.l10n.navGroupSystem,
      };
}
