/// Bill feedback: a three-tap rating a customer leaves after paying, plus an
/// optional note. Happy customers are pointed at the public review page;
/// unhappy ones reach the owner privately, so nothing here is ever published.
library;

import '../../staff/domain/staff.dart' show dayKeyOf;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

enum FeedbackRating { unhappy, okay, happy }

FeedbackRating ratingFromScore(int score) => switch (score) {
      >= 3 => FeedbackRating.happy,
      2 => FeedbackRating.okay,
      _ => FeedbackRating.unhappy,
    };

int scoreOf(FeedbackRating r) => switch (r) {
      FeedbackRating.happy => 3,
      FeedbackRating.okay => 2,
      FeedbackRating.unhappy => 1,
    };

class FeedbackEntry {
  final String id;
  final int ts;
  final FeedbackRating rating;
  final String note;

  /// Bill number when the rating came from a bill; blank otherwise.
  final String billNo;

  const FeedbackEntry({
    required this.id,
    required this.ts,
    required this.rating,
    this.note = '',
    this.billNo = '',
  });

  String get dayKey => dayKeyOf(DateTime.fromMillisecondsSinceEpoch(ts));

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'score': scoreOf(rating),
        'note': note,
        'billNo': billNo,
      };

  static FeedbackEntry? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    if (id is! String || id.isEmpty) return null;
    return FeedbackEntry(
      id: id,
      ts: _int(j['ts']),
      rating: ratingFromScore(_int(j['score'], 3)),
      note: j['note'] as String? ?? '',
      billNo: j['billNo'] as String? ?? '',
    );
  }
}

/// Average score (1..3) over [entries]; 0 when there is nothing to average.
double averageScore(Iterable<FeedbackEntry> entries) {
  final rows = entries.toList();
  if (rows.isEmpty) return 0;
  return rows.fold(0, (a, e) => a + scoreOf(e.rating)) / rows.length;
}

/// Ratings left on the given day.
List<FeedbackEntry> feedbackOn(Iterable<FeedbackEntry> entries, DateTime day) {
  final key = dayKeyOf(day);
  return [for (final e in entries) if (e.dayKey == key) e];
}

/// Ratings left within the last [days] days, newest first.
List<FeedbackEntry> recentFeedback(Iterable<FeedbackEntry> entries,
    {int days = 7, DateTime? now}) {
  final today = now ?? DateTime.now();
  final from = today.subtract(Duration(days: days)).millisecondsSinceEpoch;
  return [for (final e in entries) if (e.ts >= from) e]
    ..sort((a, b) => b.ts.compareTo(a.ts));
}

/// Unhappy or okay ratings the owner should answer.
List<FeedbackEntry> needsReply(Iterable<FeedbackEntry> entries) =>
    [for (final e in entries) if (e.rating != FeedbackRating.happy) e]
      ..sort((a, b) => b.ts.compareTo(a.ts));
