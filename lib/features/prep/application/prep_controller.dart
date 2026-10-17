import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../staff/domain/staff.dart' show dayKeyOf;
import '../domain/prep_item.dart';

/// The morning prep sheet. Plans persist; made-quantities expire at midnight.
class PrepController extends Notifier<List<PrepItem>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<PrepItem> build() => _store
      .readPrep()
      .map(PrepItem.tryFromJson)
      .whereType<PrepItem>()
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  Future<void> _persist() => guardWrite(
      ref, () => _store.writePrep([for (final i in state) i.toJson()]));

  Future<void> add({
    required String name,
    int plannedQty = 0,
    String unitLabel = '',
  }) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    state = [
      ...state,
      PrepItem(
        id: 'pr${DateTime.now().microsecondsSinceEpoch}',
        name: clean,
        plannedQty: plannedQty < 0 ? 0 : plannedQty,
        unitLabel: unitLabel.trim(),
        order: state.length,
      ),
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((i) => i.id != id).toList();
    await _persist();
  }

  Future<void> setPlanned(String id, int qty) async {
    state = [
      for (final i in state)
        i.id == id ? i.copyWith(plannedQty: qty < 0 ? 0 : qty) : i,
    ];
    await _persist();
  }

  /// Records what was actually made today; the day key stamps it so
  /// tomorrow's sheet starts empty on its own.
  Future<void> setPrepared(String id, int qty, DateTime day) async {
    state = [
      for (final i in state)
        i.id == id
            ? i.copyWith(
                preparedQty: qty < 0 ? 0 : qty, dayKey: dayKeyOf(day))
            : i,
    ];
    await _persist();
  }

  /// One tap: today's plan is fully made.
  Future<void> markDone(String id, DateTime day) async {
    final item = state.where((i) => i.id == id).firstOrNull;
    if (item == null) return;
    final full = item.doneOn(day);
    await setPrepared(id, full ? 0 : item.plannedQty, day);
  }

  /// Seeds a starter sheet once, for a shop that has none.
  Future<void> seed(List<(String, int, String)> items) async {
    if (state.isNotEmpty) return;
    var order = 0;
    state = [
      for (final (name, qty, unit) in items)
        PrepItem(
          id: 'pr${DateTime.now().microsecondsSinceEpoch}${order++}',
          name: name,
          plannedQty: qty,
          unitLabel: unit,
          order: order,
        ),
    ];
    await _persist();
  }
}

final prepProvider =
    NotifierProvider<PrepController, List<PrepItem>>(PrepController.new);
