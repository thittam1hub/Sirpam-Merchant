import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final List<RecurringSupply> recurring;
  final List<DayClose> closes;
  final bool loaded;

  const ExpenseState({
    this.expenses = const [],
    this.recurring = const [],
    this.closes = const [],
    this.loaded = false,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    List<RecurringSupply>? recurring,
    List<DayClose>? closes,
  }) =>
      ExpenseState(
        expenses: expenses ?? this.expenses,
        recurring: recurring ?? this.recurring,
        closes: closes ?? this.closes,
        loaded: true,
      );

  static bool sameDay(int ts, DateTime d) {
    final t = DateTime.fromMillisecondsSinceEpoch(ts);
    return t.year == d.year && t.month == d.month && t.day == d.day;
  }

  List<Expense> get todayExpenses =>
      expenses.where((e) => sameDay(e.ts, DateTime.now())).toList();

  int get todayPaise => todayExpenses.fold(0, (a, e) => a + e.amountPaise);

  int paiseSince(int sinceMs) => expenses
      .where((e) => e.ts >= sinceMs)
      .fold(0, (a, e) => a + e.amountPaise);

  Map<ExpenseKind, int> splitSince(int sinceMs) {
    final map = <ExpenseKind, int>{};
    for (final e in expenses.where((e) => e.ts >= sinceMs)) {
      map[e.kind] = (map[e.kind] ?? 0) + e.amountPaise;
    }
    return map;
  }

  DayClose? closeFor(String day) =>
      closes.where((c) => c.day == day).firstOrNull;
}

class ExpenseController extends Notifier<ExpenseState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  ExpenseState build() {
    final expenses = _store
        .readExpenses()
        .map(Expense.tryFromJson)
        .whereType<Expense>()
        .toList()
      ..sort((a, b) => b.ts.compareTo(a.ts));
    final recurring = _store
        .readRecurring()
        .map(RecurringSupply.tryFromJson)
        .whereType<RecurringSupply>()
        .toList();
    final closes = _store
        .readDayCloses()
        .map(DayClose.tryFromJson)
        .whereType<DayClose>()
        .toList();
    return ExpenseState(
      expenses: expenses,
      recurring: recurring,
      closes: closes,
      loaded: true,
    );
  }

  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  Future<void> _persistExpenses() => guardWrite(
      ref, () => _store.writeExpenses([for (final e in state.expenses) e.toJson()]));

  Future<void> _persistRecurring() => guardWrite(ref,
      () => _store.writeRecurring([for (final r in state.recurring) r.toJson()]));

  Future<void> _persistCloses() => guardWrite(
      ref, () => _store.writeDayCloses([for (final c in state.closes) c.toJson()]));

  Future<Expense> addExpense({
    required int amountPaise,
    required ExpenseKind kind,
    String note = '',
  }) async {
    final expense = Expense(
      id: _id('e'),
      ts: DateTime.now().millisecondsSinceEpoch,
      amountPaise: amountPaise,
      kind: kind,
      note: note,
    );
    state = state.copyWith(expenses: [expense, ...state.expenses]);
    await _persistExpenses();
    return expense;
  }

  Future<void> deleteExpense(String id) async {
    state = state.copyWith(
        expenses: state.expenses.where((e) => e.id != id).toList());
    await _persistExpenses();
  }

  Future<void> saveRecurring({
    String? id,
    required String name,
    required ExpenseKind kind,
    required int amountPaise,
  }) async {
    final item = RecurringSupply(
      id: id ?? _id('r'),
      name: name,
      kind: kind,
      amountPaise: amountPaise,
    );
    state = state.copyWith(recurring: [
      ...state.recurring.where((r) => r.id != item.id),
      item,
    ]);
    await _persistRecurring();
  }

  Future<void> deleteRecurring(String id) async {
    state = state.copyWith(
        recurring: state.recurring.where((r) => r.id != id).toList());
    await _persistRecurring();
  }

  /// One tap on a saved supply books today's cost.
  Future<void> bookRecurring(RecurringSupply supply) => addExpense(
        amountPaise: supply.amountPaise,
        kind: supply.kind,
        note: supply.name,
      );

  Future<DayClose> saveDayClose({
    required String day,
    required int expectedCashPaise,
    required int countedCashPaise,
    int openingCashPaise = 0,
    int ordersTaken = 0,
    int ordersCancelled = 0,
    int billedPaise = 0,
    int discountPaise = 0,
    int taxPaise = 0,
    int upiPaise = 0,
    int creditPaise = 0,
    int expensePaise = 0,
    int lastToken = 0,
    bool variancePosted = false,
  }) async {
    final record = DayClose(
      day: day,
      expectedCashPaise: expectedCashPaise,
      countedCashPaise: countedCashPaise,
      openingCashPaise: openingCashPaise,
      ts: DateTime.now().millisecondsSinceEpoch,
      ordersTaken: ordersTaken,
      ordersCancelled: ordersCancelled,
      billedPaise: billedPaise,
      discountPaise: discountPaise,
      taxPaise: taxPaise,
      upiPaise: upiPaise,
      creditPaise: creditPaise,
      expensePaise: expensePaise,
      lastToken: lastToken,
      variancePosted: variancePosted,
    );
    state = state.copyWith(closes: [
      ...state.closes.where((c) => c.day != day),
      record,
    ]);
    await _persistCloses();
    return record;
  }
}

final expenseProvider =
    NotifierProvider<ExpenseController, ExpenseState>(ExpenseController.new);
