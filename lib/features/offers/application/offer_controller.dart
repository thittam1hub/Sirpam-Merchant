import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/offer.dart';

/// Shop offers and what each one has cost so far.
class OfferController extends Notifier<List<Offer>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<Offer> build() =>
      _store.readOffers().map(Offer.tryFromJson).whereType<Offer>().toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeOffers([for (final o in state) o.toJson()]));

  /// Offers that can be applied right now.
  List<Offer> live({DateTime? now}) {
    final at = now ?? DateTime.now();
    return [for (final o in state) if (o.liveOn(at)) o];
  }

  Future<void> save({
    String? id,
    required String name,
    String code = '',
    OfferKind kind = OfferKind.flat,
    int valuePaise = 0,
    int percent = 0,
    int endsAt = 0,
  }) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    final existing = id == null
        ? null
        : state.where((o) => o.id == id).firstOrNull;
    if (existing != null) {
      state = [
        for (final o in state)
          o.id == id
              ? o.copyWith(
                  name: clean,
                  code: code.trim(),
                  kind: kind,
                  valuePaise: valuePaise < 0 ? 0 : valuePaise,
                  percent: percent.clamp(0, 100),
                  endsAt: endsAt,
                )
              : o,
      ];
    } else {
      state = [
        Offer(
          id: 'of${DateTime.now().microsecondsSinceEpoch}',
          name: clean,
          code: code.trim(),
          kind: kind,
          valuePaise: valuePaise < 0 ? 0 : valuePaise,
          percent: percent.clamp(0, 100),
          endsAt: endsAt,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
        ...state,
      ];
    }
    await _persist();
  }

  Future<void> setActive(String id, bool active) async {
    state = [
      for (final o in state) o.id == id ? o.copyWith(active: active) : o,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((o) => o.id != id).toList();
    await _persist();
  }

  /// Books one use of the offer and the money it gave away.
  Future<void> redeem(String id, int discountPaise) async {
    if (discountPaise <= 0) return;
    state = [
      for (final o in state)
        o.id == id
            ? o.copyWith(
                redemptions: o.redemptions + 1,
                discountedPaise: o.discountedPaise + discountPaise,
              )
            : o,
    ];
    await _persist();
  }
}

final offerProvider =
    NotifierProvider<OfferController, List<Offer>>(OfferController.new);
