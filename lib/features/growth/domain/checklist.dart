/// Opening and closing checklist: the small things that ruin a day when
/// forgotten — gas booked, change kept, QR stand out, fridge switched off.
library;

import '../../staff/domain/staff.dart' show dayKeyOf;

enum ChecklistKind { opening, closing }

ChecklistKind checklistKindFrom(String? raw) =>
    raw == 'closing' ? ChecklistKind.closing : ChecklistKind.opening;

class ChecklistItem {
  final String id;
  final String text;
  final ChecklistKind kind;

  /// Day key on which this item was last ticked; empty when never done.
  final String doneDayKey;
  final int order;

  const ChecklistItem({
    required this.id,
    required this.text,
    this.kind = ChecklistKind.opening,
    this.doneDayKey = '',
    this.order = 0,
  });

  bool doneOn(DateTime day) => doneDayKey == dayKeyOf(day);

  ChecklistItem copyWith({
    String? text,
    ChecklistKind? kind,
    String? doneDayKey,
    int? order,
  }) =>
      ChecklistItem(
        id: id,
        text: text ?? this.text,
        kind: kind ?? this.kind,
        doneDayKey: doneDayKey ?? this.doneDayKey,
        order: order ?? this.order,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'kind': kind.name,
        'doneDayKey': doneDayKey,
        'order': order,
      };

  static ChecklistItem? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final text = j['text'];
    if (id is! String || id.isEmpty || text is! String || text.isEmpty) {
      return null;
    }
    return ChecklistItem(
      id: id,
      text: text,
      kind: checklistKindFrom(j['kind'] as String?),
      doneDayKey: j['doneDayKey'] as String? ?? '',
      order: (j['order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// How much of today's list is finished, 0..1.
double checklistProgress(Iterable<ChecklistItem> items, DateTime day) {
  final all = items.toList();
  if (all.isEmpty) return 0;
  final done = all.where((i) => i.doneOn(day)).length;
  return done / all.length;
}
