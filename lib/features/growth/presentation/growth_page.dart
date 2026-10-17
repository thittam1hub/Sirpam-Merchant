import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../orders/application/order_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/growth_controller.dart';

/// Growth kit: the shop's own links, a loyalty rule, and simple post ideas
/// the vendor can use this week.
class GrowthPage extends ConsumerStatefulWidget {
  const GrowthPage({super.key});

  @override
  ConsumerState<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends ConsumerState<GrowthPage> {
  late final TextEditingController _maps;
  late final TextEditingController _review;
  late final TextEditingController _instagram;
  late final TextEditingController _reward;

  @override
  void initState() {
    super.initState();
    final s = ref.read(growthProvider).settings;
    _maps = TextEditingController(text: s.mapsUrl);
    _review = TextEditingController(text: s.reviewUrl);
    _instagram = TextEditingController(text: s.instagramHandle);
    _reward = TextEditingController(text: '${s.visitsPerReward}');
  }

  @override
  void dispose() {
    _maps.dispose();
    _review.dispose();
    _instagram.dispose();
    _reward.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final current = ref.read(growthProvider).settings;
    await ref.read(growthProvider.notifier).saveSettings(current.copyWith(
          mapsUrl: _maps.text.trim(),
          reviewUrl: _review.text.trim(),
          instagramHandle: _instagram.text.trim(),
          visitsPerReward: int.tryParse(_reward.text.trim()) ?? 0,
        ));
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.growthSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(growthProvider).settings;
    final shop = ref.watch(shopConfigProvider);
    final menuLink = shop.menuUrl(0);
    final ideas = [
      l10n.growthIdea1,
      l10n.growthIdea2,
      l10n.growthIdea3,
      l10n.growthIdea4,
      l10n.growthIdea5,
    ];

    return DetailScaffold(
      title: l10n.growthTitle,
      subtitle: l10n.growthSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.growthMenuLink),
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(menuLink,
                    style: TextStyle(color: NeuColors.ink)),
                const SizedBox(height: 10),
                ActionRow(children: [
                  NeuTextButton(
                    label: l10n.growthShareMenu,
                    color: NeuColors.accentDark,
                    onPressed: () => launchUrl(
                        ShareLinks.whatsapp(
                            message: '${shop.shopName} $menuLink'),
                        mode: LaunchMode.externalApplication),
                  ),
                  if (settings.reviewUrl.isNotEmpty)
                    NeuTextButton(
                      label: l10n.growthAskReview,
                      onPressed: () => launchUrl(
                          ShareLinks.whatsapp(
                              message: l10n.growthReviewMessage(
                                  shop.shopName, settings.reviewUrl)),
                          mode: LaunchMode.externalApplication),
                    ),
                  if (settings.mapsUrl.isNotEmpty)
                    NeuTextButton(
                      label: l10n.growthOpenMaps,
                      onPressed: () => launchUrl(Uri.parse(settings.mapsUrl),
                          mode: LaunchMode.externalApplication),
                    ),
                  NeuTextButton(
                    label: l10n.growthWhatsappBroadcast,
                    onPressed: () => launchUrl(
                        ShareLinks.whatsapp(
                            message: l10n.growthBroadcastMessage(
                                shop.shopName, menuLink)),
                        mode: LaunchMode.externalApplication),
                  ),
                ]),
              ],
            ),
          ),
          SectionTitle(l10n.growthLinksSection),
          LabeledField(label: l10n.growthMapsUrl, controller: _maps),
          LabeledField(label: l10n.growthReviewUrl, controller: _review),
          LabeledField(label: l10n.growthInstagram, controller: _instagram),
          LabeledField(
              label: l10n.growthLoyalty,
              controller: _reward,
              keyboard: TextInputType.number),
          NeuTextButton(
              label: l10n.save, color: NeuColors.accentDark, onPressed: _save),
          SectionTitle(l10n.growthIdeas),
          ...ideas.map((idea) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Row(children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        color: NeuColors.accentDark),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(idea,
                            style: TextStyle(color: NeuColors.ink))),
                    NeuIconButton(
                      icon: Icons.share_rounded,
                      label: l10n.growthShareIdea,
                      onPressed: () => launchUrl(
                          ShareLinks.whatsapp(message: idea),
                          mode: LaunchMode.externalApplication),
                    ),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}
