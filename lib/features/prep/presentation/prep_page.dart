import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/vendor_profile.dart';
import '../application/prep_controller.dart';
import '../domain/prep_item.dart';

/// Morning prep sheet: how much of each thing has to be ready before opening,
/// and how much is actually made so far today.
class PrepPage extends ConsumerStatefulWidget {
  const PrepPage({super.key});

  @override
  ConsumerState<PrepPage> createState() => _PrepPageState();
}

class _PrepPageState extends ConsumerState<PrepPage> {
  final _name = TextEditingController();
  final _qty = TextEditingController();
  final _unit = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _unit.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    await ref.read(prepProvider.notifier).add(
          name: _name.text,
          plannedQty: int.tryParse(_qty.text.trim()) ?? 0,
          unitLabel: _unit.text,
        );
    if (!mounted) return;
    _name.clear();
    _qty.clear();
    _unit.clear();
    FocusScope.of(context).unfocus();
  }

  /// Starter sheets follow the trade: a kitchen preps food, a stall preps
  /// display stock and change money.
  List<(String, int, String)> _starter() {
    final l10n = context.l10n;
    return switch (ref.read(profileProvider).category) {
      VendorCategory.hotel || VendorCategory.cart => [
          (l10n.prepSeedMilk, 10, l10n.prepUnitLitre),
          (l10n.prepSeedBatter, 20, l10n.prepUnitPlate),
          (l10n.prepSeedSnacks, 50, l10n.prepUnitPiece),
          (l10n.prepSeedChange, 1000, l10n.prepUnitRupee),
        ],
      _ => [
          (l10n.prepSeedDisplay, 1, l10n.prepUnitPiece),
          (l10n.prepSeedStock, 20, l10n.prepUnitPiece),
          (l10n.prepSeedChange, 1000, l10n.prepUnitRupee),
        ],
    };
  }

  Future<void> _edit(PrepItem item) async {
    final planned = TextEditingController(text: '${item.plannedQty}');
    final made = TextEditingController(
        text: '${item.preparedOn(DateTime.now())}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(item.name),
            LabeledField(
                label: ctx.l10n.prepPlanned,
                controller: planned,
                keyboard: TextInputType.number),
            LabeledField(
                label: ctx.l10n.prepMade,
                controller: made,
                keyboard: TextInputType.number),
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
    final plan = int.tryParse(planned.text.trim());
    final done = int.tryParse(made.text.trim());
    planned.dispose();
    made.dispose();
    if (ok != true) return;
    final ctl = ref.read(prepProvider.notifier);
    if (plan != null) await ctl.setPlanned(item.id, plan);
    if (done != null) await ctl.setPrepared(item.id, done, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = ref.watch(prepProvider);
    final today = DateTime.now();
    final pending = items.where((i) => !i.doneOn(today)).length;

    return DetailScaffold(
      title: l10n.prepTitle,
      subtitle: l10n.prepSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(children: [
              Text(l10n.prepPending('$pending'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: prepProgress(items, today),
                  minHeight: 8,
                  backgroundColor: NeuColors.canvas,
                  color: NeuColors.accentDark,
                ),
              ),
            ]),
          ),
          if (items.isEmpty) ...[
            const SizedBox(height: 14),
            NeuTextButton(
              label: l10n.prepUseStarter,
              color: NeuColors.accentDark,
              onPressed: () => ref.read(prepProvider.notifier).seed(_starter()),
            ),
          ],
          if (items.isNotEmpty) SectionTitle(l10n.prepTodaySheet),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeuBox(
                child: Row(children: [
                  NeuIconButton(
                    icon: item.doneOn(today)
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    label: l10n.prepMade,
                    onPressed: () =>
                        ref.read(prepProvider.notifier).markDone(item.id, today),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink)),
                        Text(
                            l10n.prepProgressLine('${item.preparedOn(today)}',
                                '${item.plannedQty}', item.unitLabel),
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
                  if (item.shortOn(today) > 0)
                    StatusPill(l10n.prepShort('${item.shortOn(today)}'),
                        color: NeuColors.warn),
                  const SizedBox(width: 4),
                  NeuIconButton(
                    icon: Icons.edit_outlined,
                    label: l10n.prepPlanned,
                    onPressed: () => _edit(item),
                  ),
                  NeuIconButton(
                    icon: Icons.delete_outline_rounded,
                    label: l10n.delete,
                    onPressed: () =>
                        ref.read(prepProvider.notifier).remove(item.id),
                  ),
                ]),
              ),
            ),
          SectionTitle(l10n.prepAddTitle),
          LabeledField(label: l10n.prepItemName, controller: _name),
          Row(children: [
            Expanded(
              child: LabeledField(
                  label: l10n.prepPlanned,
                  controller: _qty,
                  keyboard: TextInputType.number),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledField(label: l10n.prepUnit, controller: _unit),
            ),
          ]),
          NeuTextButton(
              label: l10n.prepAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
        ],
      ),
    );
  }
}
