import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/staff_controller.dart';
import '../domain/staff.dart';

String attendanceLabel(BuildContext context, AttendanceStatus? s) {
  final l10n = context.l10n;
  return switch (s) {
    AttendanceStatus.present => l10n.staffPresent,
    AttendanceStatus.half => l10n.staffHalf,
    AttendanceStatus.absent => l10n.staffAbsent,
    null => l10n.staffAbsent,
  };
}

/// Helpers on the stall: who came today, advances taken, wage payable.
class StaffPage extends ConsumerStatefulWidget {
  const StaffPage({super.key});

  @override
  ConsumerState<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends ConsumerState<StaffPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _role = TextEditingController();
  final _wage = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _role.dispose();
    _wage.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    await ref.read(staffProvider.notifier).saveWorker(
          name: name,
          phone: _phone.text.trim(),
          role: _role.text.trim(),
          dailyWagePaise:
              ((double.tryParse(_wage.text.trim()) ?? 0) * 100).round(),
        );
    if (!mounted) return;
    for (final c in [_name, _phone, _role, _wage]) {
      c.clear();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _advance(Worker worker) async {
    final amount = TextEditingController();
    final note = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.staffAdvanceAdd),
            LabeledField(
                label: ctx.l10n.staffAdvance,
                controller: amount,
                prefixText: '₹ ',
                keyboard:
                    const TextInputType.numberWithOptions(decimal: true)),
            LabeledField(label: ctx.l10n.expenseNote, controller: note),
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
      await ref.read(staffProvider.notifier).addAdvance(
          worker.id, DateTime.now(), (v * 100).round(), note.text.trim());
    }
    amount.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(staffProvider);
    final today = DateTime.now();
    final todayKey = dayKeyOf(today);
    final monthKey = todayKey.substring(0, 7);
    final monthRows = state.month(monthKey);

    return DetailScaffold(
      title: l10n.staffTitle,
      subtitle: l10n.staffSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.staffAdd),
          LabeledField(label: l10n.staffName, controller: _name),
          LabeledField(
              label: l10n.staffPhone,
              controller: _phone,
              keyboard: TextInputType.phone),
          LabeledField(label: l10n.staffRole, controller: _role),
          LabeledField(
              label: l10n.staffWage,
              controller: _wage,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          NeuTextButton(
              label: l10n.staffAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          SectionTitle(l10n.staffTitle),
          if (state.active.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.staffEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...state.active.map((w) {
              final entry = state.entryFor(w.id, todayKey);
              final payable = wagePayablePaise(w, monthRows);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                              w.role.isEmpty ? w.name : '${w.name} · ${w.role}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        Text(money(payable),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink)),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                          '${l10n.staffPayable} · ${attendanceLabel(context, entry?.status)}',
                          style: TextStyle(
                              fontSize: 12, color: NeuColors.inkSoft)),
                      const SizedBox(height: 10),
                      ActionRow(children: [
                        NeuTextButton(
                            label: attendanceLabel(context, entry?.status),
                            color: NeuColors.accentDark,
                            onPressed: () => ref
                                .read(staffProvider.notifier)
                                .cycleAttendance(w.id, today)),
                        NeuTextButton(
                            label: l10n.staffAdvanceAdd,
                            onPressed: () => _advance(w)),
                        NeuTextButton(
                            label: l10n.staffRemove,
                            onPressed: () => ref
                                .read(staffProvider.notifier)
                                .removeWorker(w.id)),
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
