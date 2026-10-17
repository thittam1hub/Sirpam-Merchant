/// Daily shop costs. Turnover alone is not profit: a tea shop pays for milk,
/// gas, snacks, wages, rent and current every single day.
library;

enum ExpenseKind {
  milk,
  gas,
  snacks,
  provisions,
  wages,
  rent,
  electricity,
  transport,
  other,
}

ExpenseKind expenseKindFrom(String? raw) => switch (raw) {
      'milk' => ExpenseKind.milk,
      'gas' => ExpenseKind.gas,
      'snacks' => ExpenseKind.snacks,
      'provisions' => ExpenseKind.provisions,
      'wages' => ExpenseKind.wages,
      'rent' => ExpenseKind.rent,
      'electricity' => ExpenseKind.electricity,
      'transport' => ExpenseKind.transport,
      _ => ExpenseKind.other,
    };

/// Costs that repeat monthly rather than daily — used by the month view.
const monthlyExpenseKinds = {
  ExpenseKind.rent,
  ExpenseKind.electricity,
  ExpenseKind.wages,
};

class Expense {
  final String id;
  final int ts;
  final int amountPaise;
  final ExpenseKind kind;
  final String note;

  const Expense({
    required this.id,
    required this.ts,
    required this.amountPaise,
    required this.kind,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'paise': amountPaise,
        'kind': kind.name,
        'note': note,
      };

  /// Tolerant reader: a malformed row is dropped instead of breaking launch.
  static Expense? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final ts = j['ts'];
    final paise = j['paise'];
    if (id is! String || ts is! num || paise is! num) return null;
    return Expense(
      id: id,
      ts: ts.toInt(),
      amountPaise: paise.toInt(),
      kind: expenseKindFrom(j['kind'] as String?),
      note: j['note'] as String? ?? '',
    );
  }
}

/// A cost the vendor pays again every day (milk cans, snack tray). Stored once
/// so the morning entry is two taps instead of typing.
class RecurringSupply {
  final String id;
  final String name;
  final ExpenseKind kind;
  final int amountPaise;

  const RecurringSupply({
    required this.id,
    required this.name,
    required this.kind,
    required this.amountPaise,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'paise': amountPaise,
      };

  static RecurringSupply? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    final paise = j['paise'];
    if (id is! String || name is! String || paise is! num) return null;
    return RecurringSupply(
      id: id,
      name: name,
      kind: expenseKindFrom(j['kind'] as String?),
      amountPaise: paise.toInt(),
    );
  }
}

/// One saved end-of-day reconciliation.
class DayClose {
  /// `yyyy-MM-dd` of the closed day.
  final String day;
  final int expectedCashPaise;
  final int countedCashPaise;

  /// Float the drawer opened with in the morning.
  final int openingCashPaise;
  final int ts;

  /// Reconciliation snapshot: what the orders/bills said at close time, kept
  /// with the close so a later menu edit cannot rewrite yesterday's accounts.
  final int ordersTaken;
  final int ordersCancelled;
  final int billedPaise;
  final int discountPaise;
  final int taxPaise;
  final int upiPaise;
  final int creditPaise;
  final int expensePaise;
  final int lastToken;

  /// Set once the cash variance has been posted to the ledger, so re-saving
  /// the same day never double-posts.
  final bool variancePosted;

  const DayClose({
    required this.day,
    required this.expectedCashPaise,
    required this.countedCashPaise,
    required this.ts,
    this.openingCashPaise = 0,
    this.ordersTaken = 0,
    this.ordersCancelled = 0,
    this.billedPaise = 0,
    this.discountPaise = 0,
    this.taxPaise = 0,
    this.upiPaise = 0,
    this.creditPaise = 0,
    this.expensePaise = 0,
    this.lastToken = 0,
    this.variancePosted = false,
  });

  int get differencePaise => countedCashPaise - expectedCashPaise;

  Map<String, dynamic> toJson() => {
        'day': day,
        'expected': expectedCashPaise,
        'counted': countedCashPaise,
        'opening': openingCashPaise,
        'ts': ts,
        'ordersTaken': ordersTaken,
        'ordersCancelled': ordersCancelled,
        'billed': billedPaise,
        'discount': discountPaise,
        'tax': taxPaise,
        'upi': upiPaise,
        'credit': creditPaise,
        'expense': expensePaise,
        'lastToken': lastToken,
        'variancePosted': variancePosted,
      };

  static DayClose? tryFromJson(Map<String, dynamic> j) {
    final day = j['day'];
    if (day is! String) return null;
    return DayClose(
      day: day,
      expectedCashPaise: (j['expected'] as num?)?.toInt() ?? 0,
      countedCashPaise: (j['counted'] as num?)?.toInt() ?? 0,
      openingCashPaise: (j['opening'] as num?)?.toInt() ?? 0,
      ts: (j['ts'] as num?)?.toInt() ?? 0,
      ordersTaken: (j['ordersTaken'] as num?)?.toInt() ?? 0,
      ordersCancelled: (j['ordersCancelled'] as num?)?.toInt() ?? 0,
      billedPaise: (j['billed'] as num?)?.toInt() ?? 0,
      discountPaise: (j['discount'] as num?)?.toInt() ?? 0,
      taxPaise: (j['tax'] as num?)?.toInt() ?? 0,
      upiPaise: (j['upi'] as num?)?.toInt() ?? 0,
      creditPaise: (j['credit'] as num?)?.toInt() ?? 0,
      expensePaise: (j['expense'] as num?)?.toInt() ?? 0,
      lastToken: (j['lastToken'] as num?)?.toInt() ?? 0,
      variancePosted: j['variancePosted'] == true,
    );
  }
}
