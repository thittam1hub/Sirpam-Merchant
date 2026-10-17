import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/feedback_entry.dart';

/// Bill feedback the shop has collected, newest first.
class FeedbackController extends Notifier<List<FeedbackEntry>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<FeedbackEntry> build() => _store
      .readFeedback()
      .map(FeedbackEntry.tryFromJson)
      .whereType<FeedbackEntry>()
      .toList()
    ..sort((a, b) => b.ts.compareTo(a.ts));

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeFeedback([for (final e in state) e.toJson()]));

  Future<void> record(
    FeedbackRating rating, {
    String note = '',
    String billNo = '',
  }) async {
    state = [
      FeedbackEntry(
        id: 'fb${DateTime.now().microsecondsSinceEpoch}',
        ts: DateTime.now().millisecondsSinceEpoch,
        rating: rating,
        note: note.trim(),
        billNo: billNo,
      ),
      ...state,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _persist();
  }
}

final feedbackProvider =
    NotifierProvider<FeedbackController, List<FeedbackEntry>>(
        FeedbackController.new);
