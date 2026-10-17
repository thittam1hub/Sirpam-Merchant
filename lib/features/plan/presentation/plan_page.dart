import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/application/order_sync_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/plan_controller.dart';
import '../domain/plan.dart';

/// Shows what the shop's subscription covers and refreshes it from the
/// server. Everything that runs on this phone stays free.
class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  bool _busy = false;
  String _error = '';

  Future<void> _refresh() async {
    final shop = ref.read(shopConfigProvider);
    if (shop.slug.isEmpty || shop.shopKey.length < 16) {
      setState(() => _error = context.l10n.planNeedsShop);
      return;
    }
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      final remote = await ref
          .read(orderingApiProvider)
          .fetchPlan(slug: shop.slug, shopKey: shop.shopKey);
      await ref.read(planProvider.notifier).recordServerStatus(
            plan: remote.pro ? ShopPlan.pro : ShopPlan.free,
            status: remote.status,
            periodEndMs: remote.periodEndMs,
          );
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.planCheckFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _featureLabel(AppLocalizations l10n, PlanFeature f) => switch (f) {
        PlanFeature.cloudAccount => l10n.planFeatureAccount,
        PlanFeature.liveSync => l10n.planFeatureLiveSync,
        PlanFeature.qrOrdering => l10n.planFeatureQrOrdering,
        PlanFeature.shareLinks => l10n.planFeatureShareLinks,
        PlanFeature.cloudSoundbox => l10n.planFeatureSoundbox,
        PlanFeature.backup => l10n.planFeatureBackup,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final plan = ref.watch(planProvider);
    final pro = plan.isPro(DateTime.now());

    return DetailScaffold(
      title: l10n.planTitle,
      subtitle: l10n.planSubtitle,
      fallbackLocation: AppPaths.settings,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            NeuBox(
              padding: const EdgeInsets.all(20),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(pro ? l10n.planPro : l10n.planFree,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.ink)),
                const SizedBox(height: 6),
                Text(pro ? l10n.planProNote : l10n.planFreeNote,
                    style: TextStyle(
                        fontSize: 13.5, color: NeuColors.inkSoft)),
                if (plan.status.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(plan.status,
                      style: TextStyle(
                          fontSize: 12.5, color: NeuColors.inkSoft)),
                ],
              ]),
            ),
            const SizedBox(height: 14),
            SectionTitle(l10n.planCloudFeatures),
            NeuBox(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                for (final f in PlanFeature.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [
                      Expanded(
                        child: Text(_featureLabel(l10n, f),
                            style: TextStyle(
                                fontSize: 13.5, color: NeuColors.ink)),
                      ),
                      Text(pro ? l10n.planOn : l10n.planLocked,
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: pro
                                  ? NeuColors.accentDark
                                  : NeuColors.inkSoft)),
                    ]),
                  ),
              ]),
            ),
            const SizedBox(height: 14),
            if (_error.isNotEmpty) ...[
              Text(_error,
                  style: TextStyle(
                      fontSize: 13, color: NeuColors.danger)),
              const SizedBox(height: 10),
            ],
            NeuButton(
              onPressed: _busy ? null : _refresh,
              child: Text(_busy ? l10n.planChecking : l10n.planRefresh,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: NeuColors.accentDark)),
            ),
            const SizedBox(height: 12),
            Text(l10n.planOfflineNote,
                style:
                    TextStyle(fontSize: 12.5, color: NeuColors.inkSoft)),
          ],
        ),
      ),
    );
  }
}
