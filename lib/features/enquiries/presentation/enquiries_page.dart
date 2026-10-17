import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../staff/domain/staff.dart' show dayKeyOf;
import '../application/enquiry_controller.dart';
import '../domain/enquiry.dart';

/// Price enquiries, what was quoted, and whether they turned into a sale.
class EnquiriesPage extends ConsumerStatefulWidget {
  const EnquiriesPage({super.key});

  @override
  ConsumerState<EnquiriesPage> createState() => _EnquiriesPageState();
}

class _EnquiriesPageState extends ConsumerState<EnquiriesPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _want = TextEditingController();
  final _quote = TextEditingController();
  int _followUpDays = 1;
  EnquiryFilter _filter = EnquiryFilter.open;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _want.dispose();
    _quote.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final quote = double.tryParse(_quote.text.trim()) ?? 0;
    await ref.read(enquiryProvider.notifier).add(
          name: name,
          phone: _phone.text.trim(),
          want: _want.text.trim(),
          quotedPaise: (quote * 100).round(),
          followUpDay: _followUpDays < 0
              ? ''
              : dayKeyOf(DateTime.now().add(Duration(days: _followUpDays))),
        );
    if (!mounted) return;
    _name.clear();
    _phone.clear();
    _want.clear();
    _quote.clear();
    FocusScope.of(context).unfocus();
  }

  String _filterLabel(EnquiryFilter f) => switch (f) {
        EnquiryFilter.today => context.l10n.enquiryFilterToday,
        EnquiryFilter.open => context.l10n.enquiryFilterOpen,
        EnquiryFilter.won => context.l10n.enquiryFilterWon,
        EnquiryFilter.lost => context.l10n.enquiryFilterLost,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = ref.watch(enquiryProvider);
    final rows = filterEnquiries(all, _filter);
    final rate = (enquiryWinRate(all) * 100).round();
    final shopName = ref.watch(shopConfigProvider).shopName;

    return DetailScaffold(
      title: l10n.enquiriesTitle,
      subtitle: l10n.enquiriesSubtitle,
      fallbackLocation: AppPaths.more,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.enquiryAdd),
          LabeledField(label: l10n.enquiryName, controller: _name),
          LabeledField(
              label: l10n.enquiryPhone,
              controller: _phone,
              keyboard: TextInputType.phone),
          LabeledField(label: l10n.enquiryWant, controller: _want),
          LabeledField(
              label: l10n.enquiryQuote,
              controller: _quote,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final days in const [0, 1, 3, 7, -1])
              NeuButton(
                selected: days == _followUpDays,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _followUpDays = days),
                child: Text(
                    days < 0
                        ? l10n.enquiryNoFollowUp
                        : l10n.enquiryFollowUpDays('$days'),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: days == _followUpDays
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 12),
          NeuTextButton(
              label: l10n.enquiryAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          if (all.isNotEmpty) ...[
            SectionTitle(l10n.enquiryWinRate('$rate')),
            NeuBox(
              child: Row(children: [
                Expanded(
                    child: Text(l10n.enquiryWonValue,
                        style: TextStyle(color: NeuColors.inkSoft))),
                Text(money(wonValuePaise(all)),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: NeuColors.ink)),
              ]),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final f in EnquiryFilter.values)
              NeuButton(
                selected: f == _filter,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _filter = f),
                child: Text(_filterLabel(f),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: f == _filter
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.enquiryEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...rows.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(e.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                          ),
                          if (e.quotedPaise > 0)
                            Text(money(e.quotedPaise),
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                        ]),
                        if (e.want.isNotEmpty)
                          Text(e.want,
                              style: TextStyle(
                                  fontSize: 12, color: NeuColors.inkSoft)),
                        if (e.isOpen && e.followUpDay.isNotEmpty)
                          Text(l10n.enquiryFollowUpOn(e.followUpDay),
                              style: TextStyle(
                                  fontSize: 12, color: NeuColors.inkSoft)),
                        const SizedBox(height: 10),
                        ActionRow(children: [
                          if (e.phone.isNotEmpty)
                            NeuTextButton(
                              label: l10n.enquiryMessage,
                              onPressed: () => launchUrl(
                                  ShareLinks.whatsapp(
                                      phone: e.phone,
                                      message: l10n.enquiryMessageText(
                                          e.name,
                                          e.want.isEmpty
                                              ? shopName
                                              : e.want)),
                                  mode: LaunchMode.externalApplication),
                            ),
                          if (e.isOpen) ...[
                            NeuTextButton(
                              label: l10n.enquiryWon,
                              color: NeuColors.accentDark,
                              onPressed: () => ref
                                  .read(enquiryProvider.notifier)
                                  .close(e.id, EnquiryStatus.won),
                            ),
                            NeuTextButton(
                              label: l10n.enquiryLost,
                              onPressed: () => ref
                                  .read(enquiryProvider.notifier)
                                  .close(e.id, EnquiryStatus.lost),
                            ),
                          ] else
                            NeuTextButton(
                              label: l10n.enquiryReopen,
                              onPressed: () => ref
                                  .read(enquiryProvider.notifier)
                                  .reopen(e.id,
                                      followUpDay: dayKeyOf(DateTime.now())),
                            ),
                        ]),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
