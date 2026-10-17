/// Exhibition / pop-up book. A weekend market is its own little business:
/// stall rent and travel go out, sales come in, and only the difference tells
/// the vendor whether that event is worth doing again.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

class StallEvent {
  final String id;
  final String name;
  final String place;

  /// Epoch ms of the event day (start).
  final int dayAt;
  final int rentPaise;
  final int travelPaise;
  final int otherPaise;
  final int salesPaise;
  final int footfall;
  final String note;
  final int updatedAt;

  const StallEvent({
    required this.id,
    required this.name,
    this.place = '',
    required this.dayAt,
    this.rentPaise = 0,
    this.travelPaise = 0,
    this.otherPaise = 0,
    this.salesPaise = 0,
    this.footfall = 0,
    this.note = '',
    this.updatedAt = 0,
  });

  int get costPaise => rentPaise + travelPaise + otherPaise;

  int get profitPaise => salesPaise - costPaise;

  /// Average money per visitor; null when footfall was not counted.
  int? get perVisitorPaise =>
      footfall <= 0 ? null : (salesPaise / footfall).round();

  StallEvent copyWith({
    String? name,
    String? place,
    int? dayAt,
    int? rentPaise,
    int? travelPaise,
    int? otherPaise,
    int? salesPaise,
    int? footfall,
    String? note,
    int? updatedAt,
  }) =>
      StallEvent(
        id: id,
        name: name ?? this.name,
        place: place ?? this.place,
        dayAt: dayAt ?? this.dayAt,
        rentPaise: rentPaise ?? this.rentPaise,
        travelPaise: travelPaise ?? this.travelPaise,
        otherPaise: otherPaise ?? this.otherPaise,
        salesPaise: salesPaise ?? this.salesPaise,
        footfall: footfall ?? this.footfall,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': place,
        'dayAt': dayAt,
        'rentPaise': rentPaise,
        'travelPaise': travelPaise,
        'otherPaise': otherPaise,
        'salesPaise': salesPaise,
        'footfall': footfall,
        'note': note,
        'updatedAt': updatedAt,
      };

  static StallEvent? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return StallEvent(
      id: id,
      name: name,
      place: j['place'] as String? ?? '',
      dayAt: _int(j['dayAt']),
      rentPaise: _int(j['rentPaise']),
      travelPaise: _int(j['travelPaise']),
      otherPaise: _int(j['otherPaise']),
      salesPaise: _int(j['salesPaise']),
      footfall: _int(j['footfall']),
      note: j['note'] as String? ?? '',
      updatedAt: _int(j['updatedAt']),
    );
  }
}
