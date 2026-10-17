import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/profile_controller.dart';
import '../domain/shop_type.dart';

/// The trade-specific home: pick what kind of shop this is, then work the
/// day in the order that trade actually runs.
class ShopPage extends ConsumerWidget {
  /// Type carried in the URL (`/shop?type=teaShop`); falls back to the saved
  /// profile.
  final ShopType? requested;
  const ShopPage({super.key, this.requested});

  static String label(AppLocalizations l10n, ShopType t) => switch (t) {
        ShopType.restaurant => l10n.shopTypeRestaurant,
        ShopType.hotel => l10n.shopTypeHotel,
        ShopType.streetStall => l10n.shopTypeStreet,
        ShopType.diyStall => l10n.shopTypeDiy,
        ShopType.magnetStall => l10n.shopTypeMagnet,
        ShopType.teaShop => l10n.shopTypeTea,
      };

  static String _stepLabel(AppLocalizations l10n, ShopStep s) => switch (s) {
        ShopStep.orders => l10n.ordersTitle,
        ShopStep.kot => l10n.kotTitle,
        ShopStep.bill => l10n.billTitle,
        ShopStep.quickSale => l10n.quickSaleTitle,
        ShopStep.credit => l10n.udhaarTitle,
        ShopStep.stock => l10n.stockTitle,
        ShopStep.jobs => l10n.jobsTitle,
        ShopStep.events => l10n.eventsTitle,
        ShopStep.customers => l10n.customersTitle,
        ShopStep.expenses => l10n.expensesTitle,
        ShopStep.soundbox => l10n.soundboxTitle,
        ShopStep.dayClose => l10n.dayCloseTitle,
      };

  static String _stepRoute(ShopStep s) => switch (s) {
        ShopStep.orders => AppRoutes.orders(),
        ShopStep.kot => AppRoutes.kot(),
        ShopStep.bill => AppRoutes.orders(),
        ShopStep.quickSale => AppRoutes.quickSale(),
        ShopStep.credit => AppRoutes.udhaar(),
        ShopStep.stock => AppRoutes.stock(),
        ShopStep.jobs => AppRoutes.jobs(),
        ShopStep.events => AppRoutes.events(),
        ShopStep.customers => AppRoutes.customers(),
        ShopStep.expenses => AppRoutes.expenses(),
        ShopStep.soundbox => AppRoutes.soundbox(),
        ShopStep.dayClose => AppRoutes.dayClose(),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider);
    final active = requested ?? ShopType.tryParse(profile.shopType);

    return DetailScaffold(
      title: active == null ? l10n.shopTitle : label(l10n, active),
      subtitle: l10n.shopSubtitle,
      fallbackLocation: AppPaths.home,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            SectionTitle(l10n.shopPickType),
            NeuBox(
              padding: const EdgeInsets.all(14),
              child: Wrap(spacing: 10, runSpacing: 10, children: [
                for (final t in ShopType.values)
                  NeuButton(
                    selected: active == t,
                    minHeight: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onPressed: () async {
                      await ref.read(profileProvider.notifier).save(
                            profile.copyWith(
                              shopType: t.name,
                              category: () => t.category,
                            ),
                          );
                      if (context.mounted) {
                        context.replace(AppRoutes.shop(type: t.name));
                      }
                    },
                    child: Text(label(l10n, t),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: active == t
                                ? NeuColors.accentDark
                                : NeuColors.inkSoft)),
                  ),
              ]),
            ),
            if (active != null) ...[
              const SizedBox(height: 16),
              SectionTitle(l10n.shopWorkflow),
              for (final step in active.workflow)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    onTap: () => context.push(_stepRoute(step)),
                    child: Row(children: [
                      Expanded(
                        child: Text(_stepLabel(l10n, step),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink)),
                      ),
                      Icon(Icons.chevron_right,
                          color: NeuColors.inkSoft),
                    ]),
                  ),
                ),
              const SizedBox(height: 6),
              NeuBox(
                padding: const EdgeInsets.all(18),
                onTap: () => context.push(AppRoutes.dashboard()),
                child: Text(l10n.dashboardTitle,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.accentDark)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
