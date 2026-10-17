/// Morning prep sheet: what has to be ready before the first customer.
///
/// A prep line carries a planned quantity for the day and the quantity that
/// was actually made. Both are plain whole units (40 idli, 12 litre milk) —
/// this is a kitchen sheet, not stock accounting, so nothing here touches
/// batches or money.
library;

import '../../staff/domain/staff.dart' show dayKeyOf;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

class PrepItem {
  final String id;
  final String name;

  /// Target quantity for a normal day.
  final int plannedQty;

  /// Free-text unit shown next to the number: cups, kg, plates, trays.
  final String unitLabel;

  /// Quantity made on [dayKey]; both reset together every morning.
  final int preparedQty;
  final String dayKey;
  final int order;

  const PrepItem({
    required this.id,
    required this.name,
    this.plannedQty = 0,
    this.unitLabel = '',
    this.preparedQty = 0,
    this.dayKey = '',
    this.order = 0,
  });

  bool freshOn(DateTime day) => dayKey == dayKeyOf(day);

  /// Yesterday's number never counts as today's work.
  int preparedOn(DateTime day) => freshOn(day) ? preparedQty : 0;

  int shortOn(DateTime day) {
    final gap = plannedQty - preparedOn(day);
    return gap > 0 ? gap : 0;
  }

  bool doneOn(DateTime day) => plannedQty > 0 && shortOn(day) == 0;

  PrepItem copyWith({
    String? name,
    int? plannedQty,
    String? unitLabel,
    int? preparedQty,
    String? dayKey,
    int? order,
  }) =>
      PrepItem(
        id: id,
        name: name ?? this.name,
        plannedQty: plannedQty ?? this.plannedQty,
        unitLabel: unitLabel ?? this.unitLabel,
        preparedQty: preparedQty ?? this.preparedQty,
        dayKey: dayKey ?? this.dayKey,
        order: order ?? this.order,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'plannedQty': plannedQty,
        'unitLabel': unitLabel,
        'preparedQty': preparedQty,
        'dayKey': dayKey,
        'order': order,
      };

  static PrepItem? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return PrepItem(
      id: id,
      name: name,
      plannedQty: _int(j['plannedQty']),
      unitLabel: j['unitLabel'] as String? ?? '',
      preparedQty: _int(j['preparedQty']),
      dayKey: j['dayKey'] as String? ?? '',
      order: _int(j['order']),
    );
  }
}

/// Share of today's planned prep that is already made, 0..1.
double prepProgress(Iterable<PrepItem> items, DateTime day) {
  final planned = items.fold(0, (a, i) => a + i.plannedQty);
  if (planned <= 0) return 0;
  final made = items.fold(0, (a, i) {
    final m = i.preparedOn(day);
    return a + (m > i.plannedQty ? i.plannedQty : m);
  });
  return made / planned;
}
