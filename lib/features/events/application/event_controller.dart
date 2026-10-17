import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/stall_event.dart';

class EventController extends Notifier<List<StallEvent>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<StallEvent> build() => [
        for (final row in _store.readEvents())
          ...[StallEvent.tryFromJson(row)].whereType<StallEvent>(),
      ];

  int get _now => DateTime.now().millisecondsSinceEpoch;

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeEvents([for (final e in state) e.toJson()]));

  StallEvent? byId(String id) => state.where((e) => e.id == id).firstOrNull;

  List<StallEvent> get sorted =>
      [...state]..sort((a, b) => b.dayAt.compareTo(a.dayAt));

  Future<StallEvent> save({
    String? id,
    required String name,
    String place = '',
    required int dayAt,
    int rentPaise = 0,
    int travelPaise = 0,
    int otherPaise = 0,
    int salesPaise = 0,
    int footfall = 0,
    String note = '',
  }) async {
    final existing = id == null ? null : byId(id);
    final event =
        (existing ?? StallEvent(id: 'e${DateTime.now().microsecondsSinceEpoch}', name: name, dayAt: dayAt))
            .copyWith(
      name: name,
      place: place,
      dayAt: dayAt,
      rentPaise: rentPaise,
      travelPaise: travelPaise,
      otherPaise: otherPaise,
      salesPaise: salesPaise,
      footfall: footfall,
      note: note,
      updatedAt: _now,
    );
    state = [...state.where((e) => e.id != event.id), event];
    await _persist();
    return event;
  }

  Future<void> delete(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _persist();
  }
}

final eventProvider =
    NotifierProvider<EventController, List<StallEvent>>(EventController.new);
