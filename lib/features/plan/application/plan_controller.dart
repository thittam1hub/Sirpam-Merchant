import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/plan.dart';

/// Caches the shop's subscription state. The value only ever changes from a
/// server response (or the vendor clearing it); the app never grants itself
/// Pro, and every cloud RPC re-checks entitlement server-side.
class PlanController extends Notifier<PlanState> {
  @override
  PlanState build() =>
      PlanState.fromJson(ref.read(localStoreProvider).readPlan() ?? {});

  Future<void> apply(PlanState next) async {
    state = next;
    await guardWrite(
        ref, () => ref.read(localStoreProvider).writePlan(next.toJson()));
  }

  /// Store what the server said about this shop's subscription.
  Future<void> recordServerStatus({
    required ShopPlan plan,
    required String status,
    required int periodEndMs,
    DateTime? now,
  }) =>
      apply(PlanState(
        plan: plan,
        status: status,
        periodEndMs: periodEndMs,
        checkedAtMs: (now ?? DateTime.now()).millisecondsSinceEpoch,
      ));

  Future<void> reset() => apply(const PlanState());
}

final planProvider =
    NotifierProvider<PlanController, PlanState>(PlanController.new);

/// True when the shop may use a cloud feature right now.
final planAllowsProvider = Provider.family<bool, PlanFeature>(
    (ref, feature) => ref.watch(planProvider).allows(feature, DateTime.now()));
