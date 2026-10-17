import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/expense_controller.dart';
import '../domain/expense.dart';


String expenseKindLabel(BuildContext context, ExpenseKind kind) {
  final l10n = context.l10n;
  return switch (kind) {
    ExpenseKind.milk => l10n.expenseMilk,
    ExpenseKind.gas => l10n.expenseGas,
    ExpenseKind.snacks => l10n.expenseSnacks,
    ExpenseKind.provisions => l10n.expenseProvisions,
    ExpenseKind.wages => l10n.expenseWages,
    ExpenseKind.rent => l10n.expenseRent,
    ExpenseKind.electricity => l10n.expenseElectricity,
    ExpenseKind.transport => l10n.expenseTransport,
    ExpenseKind.other => l10n.expenseOther,
  };
}

/// Daily costs: without these, turnover is not profit.
class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  ExpenseKind _kind = ExpenseKind.milk;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final v = double.tryParse(_amount.text.trim());
    if (v == null || v <= 0) return;
    final paise = (v * 100).round();
    final ok = await ref.guard(context, Permission.recordExpense,
        amountPaise: paise, action: 'expense.add', note: _note.text.trim());
    if (!ok.ok || !mounted) return;
    await ref.read(expenseProvider.notifier).addExpense(
          amountPaise: paise,
          kind: _kind,
          note: _note.text.trim(),
        );
    if (!mounted) return;
    _amount.clear();
    _note.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _bookRecurring(RecurringSupply supply) async {
    final ok = await ref.guard(context, Permission.recordExpense,
        amountPaise: supply.amountPaise,
        action: 'expense.recurring',
        note: supply.name);
    if (!ok.ok) return;
    await ref.read(expenseProvider.notifier).bookRecurring(supply);
  }

  /// Long press on a saved cost removes it — kept behind a confirmation so a
  /// stray press on a busy counter cannot wipe the shop's fixed costs.
  Future<void> _removeRecurring(RecurringSupply supply) async {
    final l10n = context.l10n;
    final ok = await ref.guard(context, Permission.recordExpense,
        action: 'expense.recurring.remove', note: supply.name);
    if (!ok.ok || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeuColors.canvas,
        content: Text(l10n.recurringRemoveConfirm(supply.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.recurringRemove)),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(expenseProvider.notifier).deleteRecurring(supply.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.recurringRemoved)));
  }


  Future<void> _addRecurring() async {
    final name = TextEditingController();
    final amount = TextEditingController();
    var kind = ExpenseKind.milk;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: NeuColors.canvas,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SectionTitle(ctx.l10n.recurringAdd),
              LabeledField(label: ctx.l10n.recurringName, controller: name),
              LabeledField(
                  label: ctx.l10n.expenseAmount,
                  controller: amount,
                  prefixText: '₹ ',
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true)),
              _KindPicker(
                  value: kind, onChanged: (k) => setLocal(() => kind = k)),
              const SizedBox(height: 14),
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
      ),
    );
    if (saved == true) {
      final v = double.tryParse(amount.text.trim()) ?? 0;
      if (v > 0 && name.text.trim().isNotEmpty) {
        await ref.read(expenseProvider.notifier).saveRecurring(
              name: name.text.trim(),
              kind: kind,
              amountPaise: (v * 100).round(),
            );
      }
    }
    name.dispose();
    amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(expenseProvider);
    final today = state.todayExpenses;

    return DetailScaffold(
      title: l10n.expensesTitle,
      subtitle: l10n.expensesSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(children: [
              Text(l10n.expenseToday,
                  style: TextStyle(
                      fontSize: 15, color: NeuColors.inkSoft)),
              const SizedBox(height: 6),
              AnimatedMoney(state.todayPaise / 100,
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
            ]),
          ),
          SectionTitle(l10n.recurringTitle,
              trailing: NeuIconButton(
                  icon: Icons.add_rounded,
                  label: l10n.recurringAdd,
                  onPressed: _addRecurring)),
          if (state.recurring.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(l10n.recurringEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NeuColors.inkSoft)),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final r in state.recurring)
                  NeuButton(
                    onPressed: () => _bookRecurring(r),
                    onLongPress: () => _removeRecurring(r),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(r.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: NeuColors.ink)),
                      Text(money(r.amountPaise),
                          style: TextStyle(
                              fontSize: 13, color: NeuColors.inkSoft)),
                      Text(l10n.recurringRemove,
                          style: TextStyle(
                              fontSize: 11, color: NeuColors.inkSoft)),
                    ]),
                  ),

              ],
            ),
          SectionTitle(l10n.expenseAdd),
          LabeledField(
            label: l10n.expenseAmount,
            controller: _amount,
            prefixText: '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
          ),
          _KindPicker(value: _kind, onChanged: (k) => setState(() => _kind = k)),
          const SizedBox(height: 14),
          LabeledField(label: l10n.expenseNote, controller: _note),
          NeuTextButton(
              label: l10n.expenseAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          SectionTitle(l10n.expenseTodayList),
          if (today.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.expenseEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...today.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                e.note.isEmpty
                                    ? expenseKindLabel(context, e.kind)
                                    : '${expenseKindLabel(context, e.kind)} · ${e.note}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            Text(
                                DateFormat('h:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(e.ts)),
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      Text(money(e.amountPaise),
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: NeuColors.danger)),
                      const SizedBox(width: 8),
                      NeuIconButton(
                        icon: Icons.delete_outline_rounded,
                        label: l10n.delete,
                        onPressed: () => ref
                            .read(expenseProvider.notifier)
                            .deleteExpense(e.id),
                      ),
                    ]),
                  ),
                )),
        ],
      ),
    );
  }
}

class _KindPicker extends StatelessWidget {
  final ExpenseKind value;
  final ValueChanged<ExpenseKind> onChanged;
  const _KindPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final k in ExpenseKind.values)
            NeuButton(
              selected: k == value,
              minHeight: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              onPressed: () => onChanged(k),
              child: Text(expenseKindLabel(context, k),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color:
                          k == value ? NeuColors.accentDark : NeuColors.inkSoft)),
            ),
        ],
      );
}
