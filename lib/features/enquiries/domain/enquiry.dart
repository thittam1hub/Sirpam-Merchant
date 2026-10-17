/// Enquiry log: the calls, walk-ins and messages that ask "how much for this?"
/// A boutique or a cake studio loses money to forgotten follow-ups, so every
/// enquiry carries a quoted price and the day it should be chased.
library;

import '../../staff/domain/staff.dart' show dayKeyOf;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

enum EnquiryStatus { open, won, lost }

EnquiryStatus _status(Object? v) => switch (v) {
      'won' => EnquiryStatus.won,
      'lost' => EnquiryStatus.lost,
      _ => EnquiryStatus.open,
    };

String _statusName(EnquiryStatus s) => switch (s) {
      EnquiryStatus.open => 'open',
      EnquiryStatus.won => 'won',
      EnquiryStatus.lost => 'lost',
    };

class Enquiry {
  final String id;
  final String name;
  final String phone;

  /// What they asked for, in the vendor's own words.
  final String want;
  final int quotedPaise;

  /// Day to chase, as `yyyy-mm-dd`; blank means no reminder.
  final String followUpDay;
  final EnquiryStatus status;

  /// Why it was lost, or a closing note when won.
  final String note;
  final int createdAt;
  final int closedAt;

  const Enquiry({
    required this.id,
    required this.name,
    this.phone = '',
    this.want = '',
    this.quotedPaise = 0,
    this.followUpDay = '',
    this.status = EnquiryStatus.open,
    this.note = '',
    this.createdAt = 0,
    this.closedAt = 0,
  });

  bool get isOpen => status == EnquiryStatus.open;

  /// Due today or overdue, and still open.
  bool dueBy(DateTime day) =>
      isOpen &&
      followUpDay.isNotEmpty &&
      followUpDay.compareTo(dayKeyOf(day)) <= 0;

  Enquiry copyWith({
    String? name,
    String? phone,
    String? want,
    int? quotedPaise,
    String? followUpDay,
    EnquiryStatus? status,
    String? note,
    int? closedAt,
  }) =>
      Enquiry(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        want: want ?? this.want,
        quotedPaise: quotedPaise ?? this.quotedPaise,
        followUpDay: followUpDay ?? this.followUpDay,
        status: status ?? this.status,
        note: note ?? this.note,
        createdAt: createdAt,
        closedAt: closedAt ?? this.closedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'want': want,
        'quotedPaise': quotedPaise,
        'followUpDay': followUpDay,
        'status': _statusName(status),
        'note': note,
        'createdAt': createdAt,
        'closedAt': closedAt,
      };

  static Enquiry? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = j['name'];
    if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
      return null;
    }
    return Enquiry(
      id: id,
      name: name,
      phone: j['phone'] as String? ?? '',
      want: j['want'] as String? ?? '',
      quotedPaise: _int(j['quotedPaise']),
      followUpDay: j['followUpDay'] as String? ?? '',
      status: _status(j['status']),
      note: j['note'] as String? ?? '',
      createdAt: _int(j['createdAt']),
      closedAt: _int(j['closedAt']),
    );
  }
}

enum EnquiryFilter { today, open, won, lost }

/// The enquiries a filter shows, soonest follow-up first.
List<Enquiry> filterEnquiries(
  Iterable<Enquiry> rows,
  EnquiryFilter filter, {
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final list = switch (filter) {
    EnquiryFilter.today => [for (final e in rows) if (e.dueBy(today)) e],
    EnquiryFilter.open => [for (final e in rows) if (e.isOpen) e],
    EnquiryFilter.won =>
      [for (final e in rows) if (e.status == EnquiryStatus.won) e],
    EnquiryFilter.lost =>
      [for (final e in rows) if (e.status == EnquiryStatus.lost) e],
  };
  list.sort((a, b) {
    if (a.isOpen && b.isOpen) {
      final af = a.followUpDay.isEmpty ? '9999-99-99' : a.followUpDay;
      final bf = b.followUpDay.isEmpty ? '9999-99-99' : b.followUpDay;
      final byDay = af.compareTo(bf);
      if (byDay != 0) return byDay;
    }
    return b.createdAt.compareTo(a.createdAt);
  });
  return list;
}

/// Money won out of everything quoted and closed, as a 0..1 share.
double enquiryWinRate(Iterable<Enquiry> rows) {
  final closed =
      [for (final e in rows) if (e.status != EnquiryStatus.open) e];
  if (closed.isEmpty) return 0;
  final won = closed.where((e) => e.status == EnquiryStatus.won).length;
  return won / closed.length;
}

/// Value of the enquiries that turned into sales.
int wonValuePaise(Iterable<Enquiry> rows) => rows
    .where((e) => e.status == EnquiryStatus.won)
    .fold(0, (a, e) => a + e.quotedPaise);
