import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/event_controller.dart';

/// Exhibitions and weekend markets, each with its own profit or loss.
class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final _name = TextEditingController();
  final _place = TextEditingController();
  final _rent = TextEditingController();
  final _travel = TextEditingController();
  final _other = TextEditingController();
  final _sales = TextEditingController();
  final _footfall = TextEditingController();
  DateTime _day = DateTime.now();

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _rent.dispose();
    _travel.dispose();
    _other.dispose();
    _sales.dispose();
    _footfall.dispose();
    super.dispose();
  }

  int _paise(TextEditingController c) =>
      ((double.tryParse(c.text.trim()) ?? 0) * 100).round();

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _day = picked);
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    await ref.read(eventProvider.notifier).save(
          name: name,
          place: _place.text.trim(),
          dayAt: _day.millisecondsSinceEpoch,
          rentPaise: _paise(_rent),
          travelPaise: _paise(_travel),
          otherPaise: _paise(_other),
          salesPaise: _paise(_sales),
          footfall: int.tryParse(_footfall.text.trim()) ?? 0,
        );
    if (!mounted) return;
    for (final c in [_name, _place, _rent, _travel, _other, _sales, _footfall]) {
      c.clear();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final events = ref.watch(eventProvider.notifier).sorted;

    return DetailScaffold(
      title: l10n.eventsTitle,
      subtitle: l10n.eventsSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.eventAdd),
          LabeledField(label: l10n.eventName, controller: _name),
          LabeledField(label: l10n.eventPlace, controller: _place),
          NeuTextButton(
              label: '${l10n.eventDay}: ${DateFormat('d MMM y').format(_day)}',
              onPressed: _pickDay),
          const SizedBox(height: 8),
          LabeledField(
              label: l10n.eventRent,
              controller: _rent,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          LabeledField(
              label: l10n.eventTravel,
              controller: _travel,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          LabeledField(
              label: l10n.eventOther,
              controller: _other,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          LabeledField(
              label: l10n.eventSales,
              controller: _sales,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          LabeledField(
              label: l10n.eventFootfall,
              controller: _footfall,
              keyboard: TextInputType.number),
          NeuTextButton(
              label: l10n.eventAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          SectionTitle(l10n.eventsTitle),
          if (events.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.eventsEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...events.map((e) {
              final profit = e.profitPaise;
              final perVisitor = e.perVisitorPaise;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                              e.place.isEmpty ? e.name : '${e.name} · ${e.place}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        Text(money(profit.abs()),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: profit < 0
                                    ? NeuColors.danger
                                    : NeuColors.accentDark)),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                          '${DateFormat('d MMM y').format(DateTime.fromMillisecondsSinceEpoch(e.dayAt))}'
                          ' · ${profit < 0 ? l10n.eventLoss : l10n.eventProfit}'
                          ' · ${l10n.eventSales} ${money(e.salesPaise)}'
                          '${perVisitor == null ? '' : ' · ${l10n.eventPerVisitor} ${money(perVisitor)}'}',
                          style: TextStyle(
                              fontSize: 12, color: NeuColors.inkSoft)),
                      const SizedBox(height: 8),
                      ActionRow(children: [
                        NeuTextButton(
                            label: l10n.delete,
                            onPressed: () =>
                                ref.read(eventProvider.notifier).delete(e.id)),
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
