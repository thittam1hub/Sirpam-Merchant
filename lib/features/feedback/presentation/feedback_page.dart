import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/qr/qr_payloads.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../../growth/application/growth_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/label_sheet.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/feedback_controller.dart';
import '../domain/feedback_entry.dart';
import '../domain/feedback_link.dart';

String feedbackRatingLabel(BuildContext context, FeedbackRating r) =>
    switch (r) {
      FeedbackRating.happy => context.l10n.feedbackHappy,
      FeedbackRating.okay => context.l10n.feedbackOkay,
      FeedbackRating.unhappy => context.l10n.feedbackUnhappy,
    };

/// The counter QR customers tap after paying, and what they said.
class FeedbackPage extends ConsumerWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final shop = ref.watch(shopConfigProvider);
    final growth = ref.watch(growthProvider).settings;
    final entries = ref.watch(feedbackProvider);
    final link = feedbackUrl(
      baseUrl: shop.menuBaseUrl,
      shopName: shop.shopName,
      phone: shop.phone,
      reviewUrl: growth.reviewUrl,
    );
    final now = DateTime.now();
    final today = feedbackOn(entries, now);
    final week = recentFeedback(entries, now: now);
    final pending = needsReply(week);

    String avg(double v) => v == 0 ? '—' : v.toStringAsFixed(1);

    return DetailScaffold(
      title: l10n.feedbackTitle,
      subtitle: l10n.feedbackSubtitle,
      fallbackLocation: AppPaths.more,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.feedbackQrTitle),
          NeuBox(
            child: Column(children: [
              BarcodeView.qr(data: link, size: 200),
              const SizedBox(height: 10),
              Text(l10n.feedbackQrHint,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
              if (growth.reviewUrl.isEmpty) ...[
                const SizedBox(height: 6),
                Text(l10n.feedbackReviewMissing,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: NeuColors.accentDark)),
              ],
              const SizedBox(height: 12),
              NeuTextButton(
                label: l10n.qrPrintCounterCard,
                color: NeuColors.accentDark,
                onPressed: () async {
                  final settings = ref.read(settingsProvider);
                  final bytes = await LabelSheet.counterCard(
                    shopName: shop.shopName.isEmpty
                        ? settings.stallName
                        : shop.shopName,
                    upiUri: settings.upiVpa.isEmpty
                        ? ''
                        : QrPayloads.upi(
                            vpa: settings.upiVpa,
                            payeeName: settings.stallName),
                    payCaption: l10n.qrPayCaption,
                    feedbackUrl: link,
                    feedbackCaption: l10n.qrFeedbackCaption,
                  );
                  await Printing.sharePdf(
                      bytes: bytes, filename: 'counter-card.pdf');
                },
              ),
              const SizedBox(height: 10),
              NeuTextButton(
                label: l10n.copy,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: link));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.feedbackLinkCopied)));
                },
              ),
            ]),
          ),
          SectionTitle(l10n.feedbackScores),
          NeuBox(
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Text(l10n.feedbackTodayAvg,
                        style: TextStyle(color: NeuColors.inkSoft))),
                Text('${avg(averageScore(today))} · ${today.length}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: NeuColors.ink)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                    child: Text(l10n.feedbackWeekAvg,
                        style: TextStyle(color: NeuColors.inkSoft))),
                Text('${avg(averageScore(week))} · ${week.length}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: NeuColors.ink)),
              ]),
              if (pending.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                      child: Text(l10n.feedbackNeedsReply,
                          style: TextStyle(color: NeuColors.inkSoft))),
                  Text('${pending.length}',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: NeuColors.accentDark)),
                ]),
              ],
            ]),
          ),
          SectionTitle(l10n.feedbackRecord),
          ActionRow(children: [
            for (final r in FeedbackRating.values.reversed)
              NeuTextButton(
                label: feedbackRatingLabel(context, r),
                color: r == FeedbackRating.happy
                    ? NeuColors.accentDark
                    : NeuColors.ink,
                onPressed: () =>
                    ref.read(feedbackProvider.notifier).record(r),
              ),
          ]),
          SectionTitle(l10n.feedbackRecent),
          if (entries.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.feedbackEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...entries.take(20).map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feedbackRatingLabel(context, e.rating),
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                            Text(
                                e.note.isEmpty ? e.dayKey : '${e.dayKey} · ${e.note}',
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      NeuTextButton(
                        label: l10n.delete,
                        onPressed: () =>
                            ref.read(feedbackProvider.notifier).remove(e.id),
                      ),
                    ]),
                  ),
                )),
        ],
      ),
    );
  }
}
