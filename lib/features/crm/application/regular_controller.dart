import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/regular.dart';

class RegularController extends Notifier<List<Regular>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<Regular> build() => [
        for (final row in _store.readCustomers())
          ...[Regular.tryFromJson(row)].whereType<Regular>(),
      ];

  int get _now => DateTime.now().millisecondsSinceEpoch;

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeCustomers([for (final r in state) r.toJson()]));

  Regular? byId(String id) => state.where((r) => r.id == id).firstOrNull;

  List<Regular> get sorted =>
      [...state]..sort((a, b) => b.lastVisitAt.compareTo(a.lastVisitAt));

  Future<Regular> save({
    String? id,
    required String name,
    String phone = '',
    CustomerSource source = CustomerSource.walkIn,
  }) async {
    final existing = id == null ? null : byId(id);
    final regular =
        (existing ?? Regular(id: 'c${DateTime.now().microsecondsSinceEpoch}', name: name))
            .copyWith(
      name: name,
      phone: phone,
      source: source,
      updatedAt: _now,
    );
    state = [...state.where((r) => r.id != regular.id), regular];
    await _persist();
    return regular;
  }

  /// Records a visit and the money spent. The sale itself is entered where it
  /// always was — this only keeps the customer's own history.
  Future<void> recordVisit(String id, int amountPaise) async {
    final regular = byId(id);
    if (regular == null) return;
    state = [
      for (final r in state)
        r.id == id
            ? r.copyWith(
                visits: r.visits + 1,
                spentPaise: r.spentPaise + amountPaise,
                lastVisitAt: _now,
                updatedAt: _now)
            : r,
    ];
    await _persist();
  }

  /// Marks one earned free item as handed over.
  Future<void> giveReward(String id) async {
    final regular = byId(id);
    if (regular == null) return;
    state = [
      for (final r in state)
        r.id == id
            ? r.copyWith(rewardsGiven: r.rewardsGiven + 1, updatedAt: _now)
            : r,
    ];
    await _persist();
  }

  Future<void> delete(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _persist();
  }
}

final regularProvider =
    NotifierProvider<RegularController, List<Regular>>(RegularController.new);
