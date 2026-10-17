import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/app/routes.dart';
import 'package:vendoros/features/analytics/domain/insights.dart';
import 'package:vendoros/features/dashboard/domain/dashboard_summary.dart';
import 'package:vendoros/features/plan/domain/plan.dart';
import 'package:vendoros/features/profile/domain/shop_type.dart';

void main() {
  group('dashboard routing', () {
    test('window query is validated and defaults to day', () {
      expect(AppQueryParsing.dashboardWindow('week'), 'week');
      expect(AppQueryParsing.dashboardWindow('decade'), 'day');
      expect(AppQueryParsing.dashboardWindow(null), 'day');
    });

    test('section links round-trip', () {
      final link = AppRoutes.dashboardSection('credit', window: 'month');
      expect(link, '/dashboard/credit?window=month');
      expect(dashboardSectionFrom('credit'), DashboardSection.credit);
      expect(dashboardSectionFrom('nonsense'), isNull);
    });

    test('window names map back to insight windows', () {
      expect(dashboardWindowFrom('month'), InsightWindow.month);
      expect(dashboardWindowFrom(null), InsightWindow.day);
    });
  });

  group('plan', () {
    final now = DateTime(2026, 3, 1);

    test('free plan blocks every cloud feature', () {
      const state = PlanState(plan: ShopPlan.free);
      expect(state.isPro(now), isFalse);
      for (final f in PlanFeature.values) {
        expect(state.allows(f, now), isFalse);
      }
    });

    test('pro plan inside its period allows cloud features', () {
      final state = PlanState(
        plan: ShopPlan.pro,
        periodEndMs: now.add(const Duration(days: 5)).millisecondsSinceEpoch,
        checkedAtMs: now.millisecondsSinceEpoch,
      );
      expect(state.allows(PlanFeature.liveSync, now), isTrue);
    });

    test('state survives a JSON round-trip', () {
      final state = PlanState(
        plan: ShopPlan.pro,
        status: 'active',
        periodEndMs: now.millisecondsSinceEpoch,
        checkedAtMs: now.millisecondsSinceEpoch,
      );
      final back = PlanState.fromJson(state.toJson());
      expect(back.plan, ShopPlan.pro);
      expect(back.status, 'active');
      expect(back.periodEndMs, state.periodEndMs);
    });
  });

  group('shop types', () {
    test('every type has a workflow and parses from its name', () {
      for (final t in ShopType.values) {
        expect(t.workflow, isNotEmpty);
        expect(ShopType.tryParse(t.name), t);
      }
      expect(ShopType.tryParse('bakery'), isNull);
    });

    test('shop link carries the type', () {
      expect(AppRoutes.shop(type: 'teaShop'), '/shop?type=teaShop');
    });
  });
}
