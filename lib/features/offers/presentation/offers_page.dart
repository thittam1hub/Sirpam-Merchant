import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/qr/qr_payloads.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/label_sheet.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/offer_controller.dart';
import '../domain/offer.dart';

String offerKindLabel(BuildContext context, OfferKind k) => switch (k) {
      OfferKind.flat => context.l10n.offerKindFlat,
      OfferKind.percent => context.l10n.offerKindPercent,
      OfferKind.combo => context.l10n.offerKindCombo,
    };

/// Named discounts the shop runs, with what each one has given away.
class OffersPage extends ConsumerStatefulWidget {
  const OffersPage({super.key});

  @override
  ConsumerState<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends ConsumerState<OffersPage> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _value = TextEditingController();
  OfferKind _kind = OfferKind.flat;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final raw = double.tryParse(_value.text.trim()) ?? 0;
    await ref.read(offerProvider.notifier).save(
          name: name,
          code: _code.text.trim(),
          kind: _kind,
          valuePaise: _kind == OfferKind.percent ? 0 : (raw * 100).round(),
          percent: _kind == OfferKind.percent ? raw.round() : 0,
        );
    if (!mounted) return;
    _name.clear();
    _code.clear();
    _value.clear();
    FocusScope.of(context).unfocus();
  }

  String _offerUrl(Offer o) {
    final shop = ref.read(shopConfigProvider);
    return QrPayloads.offer(
      baseUrl: shop.menuBaseUrl,
      shopName: shop.shopName,
      title: o.name,
      code: o.code,
      detail: o.kind == OfferKind.percent
          ? '${o.percent}%'
          : money(o.valuePaise),
    );
  }

  Future<void> _printCards(Offer o) async {
    final l10n = context.l10n;
    final shop = ref.read(shopConfigProvider);
    final bytes = await LabelSheet.offerCards(
      shopName: shop.shopName,
      title: o.name,
      detail: o.kind == OfferKind.percent
          ? '${o.percent}%'
          : money(o.valuePaise),
      url: _offerUrl(o),
      caption: l10n.offerCardCaption,
    );
    await Printing.sharePdf(bytes: bytes, filename: 'offer-cards.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final offers = ref.watch(offerProvider);
    final given = totalDiscounted(offers);

    return DetailScaffold(
      title: l10n.offersTitle,
      subtitle: l10n.offersSubtitle,
      fallbackLocation: AppPaths.more,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.offerAdd),
          LabeledField(label: l10n.offerName, controller: _name),
          LabeledField(label: l10n.offerCode, controller: _code),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final k in OfferKind.values)
              NeuButton(
                selected: k == _kind,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _kind = k),
                child: Text(offerKindLabel(context, k),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: k == _kind
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          LabeledField(
            label: switch (_kind) {
              OfferKind.flat => l10n.offerAmount,
              OfferKind.percent => l10n.offerPercent,
              OfferKind.combo => l10n.offerComboPrice,
            },
            controller: _value,
            prefixText: _kind == OfferKind.percent ? null : '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          NeuTextButton(
              label: l10n.save, color: NeuColors.accentDark, onPressed: _save),
          if (given > 0) ...[
            SectionTitle(l10n.offersGivenTotal),
            NeuBox(
              child: Row(children: [
                Expanded(
                    child: Text(l10n.offersGivenTotal,
                        style: TextStyle(color: NeuColors.inkSoft))),
                Text(money(given),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: NeuColors.ink)),
              ]),
            ),
          ],
          SectionTitle(l10n.offersTitle),
          if (offers.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.offersEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...offers.map((o) {
              final live = o.liveOn(DateTime.now());
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(o.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        StatusPill(live ? l10n.offerLive : l10n.offerPaused,
                            color: live
                                ? NeuColors.accentDark
                                : NeuColors.inkSoft),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                        '${offerKindLabel(context, o.kind)} · '
                        '${o.kind == OfferKind.percent ? '${o.percent}%' : money(o.valuePaise)}'
                        '${o.code.isEmpty ? '' : ' · ${o.code}'}',
                        style: TextStyle(
                            fontSize: 12, color: NeuColors.inkSoft),
                      ),
                      Text(
                        '${l10n.offerUsed('${o.redemptions}')} · '
                        '${l10n.offerGivenAway(money(o.discountedPaise))}',
                        style: TextStyle(
                            fontSize: 12, color: NeuColors.inkSoft),
                      ),
                      const SizedBox(height: 10),
                      ActionRow(children: [
                        NeuTextButton(
                          label: live ? l10n.offerPause : l10n.offerResume,
                          color: NeuColors.accentDark,
                          onPressed: () => ref
                              .read(offerProvider.notifier)
                              .setActive(o.id, !o.active),
                        ),
                        NeuTextButton(
                          label: l10n.offerPrintCards,
                          onPressed: () => _printCards(o),
                        ),
                        NeuTextButton(
                          label: l10n.copy,
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await Clipboard.setData(
                                ClipboardData(text: _offerUrl(o)));
                            messenger.showSnackBar(
                                SnackBar(content: Text(l10n.copied)));
                          },
                        ),
                        NeuTextButton(
                          label: l10n.delete,
                          onPressed: () =>
                              ref.read(offerProvider.notifier).remove(o.id),
                        ),
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
