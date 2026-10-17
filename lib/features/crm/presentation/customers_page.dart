import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../analytics/domain/insights.dart';
import '../../growth/application/growth_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/regular_controller.dart';
import '../domain/regular.dart';

String customerSourceLabel(BuildContext context, CustomerSource s) {
  final l10n = context.l10n;
  return switch (s) {
    CustomerSource.walkIn => l10n.sourceWalkIn,
    CustomerSource.instagram => l10n.sourceInstagram,
    CustomerSource.maps => l10n.sourceMaps,
    CustomerSource.referral => l10n.sourceReferral,
    CustomerSource.other => l10n.sourceOther,
  };
}

/// Regulars: visits, spend, how they found the shop, and the loyalty card.
class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  CustomerSource _source = CustomerSource.walkIn;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    await ref.read(regularProvider.notifier).save(
        name: name, phone: _phone.text.trim(), source: _source);
    if (!mounted) return;
    _name.clear();
    _phone.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _recordVisit(Regular r) async {
    final amount = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.customerRecordVisit),
            LabeledField(
                label: ctx.l10n.customerVisitAmount,
                controller: amount,
                prefixText: '₹ ',
                keyboard:
                    const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 12),
            ActionRow(children: [
              NeuTextButton(
                  label: ctx.l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(false)),
              NeuTextButton(
                  label: ctx.l10n.save,
                  color: NeuColors.accentDark,
                  onPressed: () => Navigator.of(ctx).pop(true)),
            ]),
          ]),
        ),
      ),
    );
    if (saved == true) {
      final v = double.tryParse(amount.text.trim()) ?? 0;
      await ref
          .read(regularProvider.notifier)
          .recordVisit(r.id, (v * 100).round());
    }
    amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final regulars = ref.watch(regularProvider.notifier).sorted;
    final perReward = ref.watch(growthProvider).settings.visitsPerReward;
    final split = spendBySource(regulars);
    final lapsed = Insights.lapsedRegulars(regulars);
    final shopName = ref.watch(shopConfigProvider).shopName;

    return DetailScaffold(
      title: l10n.customersTitle,
      subtitle: l10n.customersSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.customerAdd),
          LabeledField(label: l10n.customerName, controller: _name),
          LabeledField(
              label: l10n.customerPhone,
              controller: _phone,
              keyboard: TextInputType.phone),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in CustomerSource.values)
              NeuButton(
                selected: s == _source,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _source = s),
                child: Text(customerSourceLabel(context, s),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: s == _source
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 12),
          NeuTextButton(
              label: l10n.customerAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          if (split.isNotEmpty) ...[
            SectionTitle(l10n.customerSourceSplit),
            NeuBox(
              child: Column(children: [
                for (final e in split.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      Expanded(
                          child: Text(customerSourceLabel(context, e.key),
                              style:
                                  TextStyle(color: NeuColors.inkSoft))),
                      Text(money(e.value),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: NeuColors.ink)),
                    ]),
                  ),
              ]),
            ),
          ],
          if (lapsed.isNotEmpty) ...[
            SectionTitle(l10n.customerLapsedTitle),
            NeuBox(
              child: Column(children: [
                Text(l10n.customerLapsedHint,
                    style: TextStyle(
                        fontSize: 12, color: NeuColors.inkSoft)),
                const SizedBox(height: 8),
                for (final r in lapsed.take(5))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            Text(
                                l10n.customerLapsedDays(
                                    '${Insights.daysSinceVisit(r)}'),
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      NeuTextButton(
                        label: l10n.customerNudge,
                        color: NeuColors.accentDark,
                        onPressed: () => launchUrl(
                            ShareLinks.whatsapp(
                                phone: r.phone,
                                message: l10n.customerNudgeMessage(
                                    r.name, shopName)),
                            mode: LaunchMode.externalApplication),
                      ),
                    ]),
                  ),
              ]),
            ),
          ],
          if (perReward > 0 &&
              regulars.any((r) => r.rewardsDue(perReward) > 0)) ...[
            SectionTitle(l10n.customerRewardsDueTitle),
            NeuBox(
              child: Column(children: [
                for (final r in regulars
                    .where((r) => r.rewardsDue(perReward) > 0)
                    .take(5))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [
                      Expanded(
                        child: Text(r.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink)),
                      ),
                      NeuTextButton(
                        label: l10n.customerGiveReward,
                        color: NeuColors.accentDark,
                        onPressed: () => ref
                            .read(regularProvider.notifier)
                            .giveReward(r.id),
                      ),
                    ]),
                  ),
              ]),
            ),
          ],
          SectionTitle(l10n.customersTitle),

          if (regulars.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.customersEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...regulars.map((r) {
              final due = r.rewardsDue(perReward);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(r.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        Text(money(r.spentPaise),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink)),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                          '${l10n.customerVisits('${r.visits}')} · '
                          '${customerSourceLabel(context, r.source)}'
                          '${due > 0 ? ' · ${l10n.customerRewardDue}' : (perReward > 0 ? ' · ${l10n.customerToReward('${r.visitsToReward(perReward)}')}' : '')}',
                          style: TextStyle(
                              fontSize: 12, color: NeuColors.inkSoft)),
                      const SizedBox(height: 10),
                      ActionRow(children: [
                        NeuTextButton(
                            label: l10n.customerRecordVisit,
                            color: NeuColors.accentDark,
                            onPressed: () => _recordVisit(r)),
                        if (due > 0)
                          NeuTextButton(
                              label: l10n.customerGiveReward,
                              onPressed: () => ref
                                  .read(regularProvider.notifier)
                                  .giveReward(r.id)),
                      ]),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
