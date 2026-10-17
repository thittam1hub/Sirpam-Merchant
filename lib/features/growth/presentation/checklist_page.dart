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
import '../../profile/application/vendor_presets.dart';
import '../application/growth_controller.dart';
import '../domain/checklist.dart';

/// Opening and closing routine, ticked fresh every day.
class ChecklistPage extends ConsumerStatefulWidget {
  const ChecklistPage({super.key});

  @override
  ConsumerState<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends ConsumerState<ChecklistPage> {
  final _text = TextEditingController();
  ChecklistKind _kind = ChecklistKind.opening;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    await ref.read(growthProvider.notifier).addItem(_text.text, _kind);
    if (!mounted) return;
    _text.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _seed() async {
    await ref.read(growthProvider.notifier).seed(
        vendorPreset(context.l10n, ref.read(profileProvider).category)
            .checklist);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(growthProvider);
    final today = DateTime.now();
    final done = state.checklist.where((i) => i.doneOn(today)).length;

    return DetailScaffold(
      title: l10n.checklistTitle,
      subtitle: l10n.checklistSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(children: [
              Text(l10n.checklistProgress('$done', '${state.checklist.length}'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: checklistProgress(state.checklist, today),
                  minHeight: 8,
                  backgroundColor: NeuColors.canvas,
                  color: NeuColors.accentDark,
                ),
              ),
            ]),
          ),
          if (state.checklist.isEmpty) ...[
            const SizedBox(height: 14),
            NeuTextButton(
                label: l10n.checklistUseStarter,
                color: NeuColors.accentDark,
                onPressed: _seed),
          ],
          for (final kind in ChecklistKind.values) ...[
            SectionTitle(kind == ChecklistKind.opening
                ? l10n.checklistOpening
                : l10n.checklistClosing),
            if (state.ofKind(kind).isEmpty)
              NeuBox(
                inset: true,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                    child: Text(l10n.checklistEmpty,
                        style: TextStyle(color: NeuColors.inkSoft))),
              )
            else
              ...state.ofKind(kind).map((item) {
                final ticked = item.doneOn(today);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuButton(
                    onPressed: () => ref
                        .read(growthProvider.notifier)
                        .toggle(item.id, today),
                    child: Row(children: [
                      Icon(
                          ticked
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: ticked
                              ? NeuColors.accentDark
                              : NeuColors.inkSoft),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(item.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: ticked
                                    ? NeuColors.inkSoft
                                    : NeuColors.ink)),
                      ),
                      NeuIconButton(
                        icon: Icons.delete_outline_rounded,
                        label: l10n.delete,
                        onPressed: () => ref
                            .read(growthProvider.notifier)
                            .removeItem(item.id),
                      ),
                    ]),
                  ),
                );
              }),
          ],
          SectionTitle(l10n.checklistAdd),
          LabeledField(label: l10n.checklistItem, controller: _text),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final k in ChecklistKind.values)
              NeuButton(
                selected: k == _kind,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _kind = k),
                child: Text(
                    k == ChecklistKind.opening
                        ? l10n.checklistOpening
                        : l10n.checklistClosing,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: k == _kind
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 12),
          NeuTextButton(
              label: l10n.checklistAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
        ],
      ),
    );
  }
}
