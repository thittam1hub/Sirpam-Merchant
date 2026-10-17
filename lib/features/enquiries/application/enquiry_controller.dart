import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/enquiry.dart';

/// The enquiry log: who asked for what, what was quoted, and what came of it.
class EnquiryController extends Notifier<List<Enquiry>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<Enquiry> build() => _store
      .readEnquiries()
      .map(Enquiry.tryFromJson)
      .whereType<Enquiry>()
      .toList();

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeEnquiries([for (final e in state) e.toJson()]));

  Future<void> add({
    required String name,
    String phone = '',
    String want = '',
    int quotedPaise = 0,
    String followUpDay = '',
  }) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    state = [
      Enquiry(
        id: 'en${DateTime.now().microsecondsSinceEpoch}',
        name: clean,
        phone: phone.trim(),
        want: want.trim(),
        quotedPaise: quotedPaise < 0 ? 0 : quotedPaise,
        followUpDay: followUpDay,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      ...state,
    ];
    await _persist();
  }

  Future<void> close(String id, EnquiryStatus status, {String note = ''}) async {
    state = [
      for (final e in state)
        e.id == id
            ? e.copyWith(
                status: status,
                note: note.trim(),
                closedAt: DateTime.now().millisecondsSinceEpoch,
              )
            : e,
    ];
    await _persist();
  }

  Future<void> reopen(String id, {String followUpDay = ''}) async {
    state = [
      for (final e in state)
        e.id == id
            ? e.copyWith(
                status: EnquiryStatus.open,
                followUpDay: followUpDay,
                closedAt: 0,
              )
            : e,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _persist();
  }
}

final enquiryProvider =
    NotifierProvider<EnquiryController, List<Enquiry>>(EnquiryController.new);
