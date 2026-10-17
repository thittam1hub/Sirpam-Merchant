import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/app/routes.dart';
import 'package:vendoros/features/crm/domain/regular.dart';
import 'package:vendoros/features/events/domain/stall_event.dart';
import 'package:vendoros/features/growth/domain/checklist.dart';
import 'package:vendoros/features/jobs/domain/job.dart';
import 'package:vendoros/features/products/domain/inventory_models.dart';
import 'package:vendoros/features/recipes/domain/recipe.dart';
import 'package:vendoros/features/staff/domain/staff.dart';

void main() {
  group('Recipe', () {
    const recipe = Recipe(
      id: 'r1',
      name: 'Sambar',
      servings: 10,
      ingredients: [
        RecipeIngredient(
          productId: 'p1',
          name: 'Dal',
          qtyMilli: 500,
          unit: StockUnit.gram,
        ),
      ],
      steps: ['Boil'],
    );

    test('scales ingredient quantities to the requested servings', () {
      expect(recipe.scaledTo(20).first.qtyMilli, 1000);
      expect(recipe.scaledTo(5).first.qtyMilli, 250);
      expect(recipe.scaledTo(0).first.qtyMilli, 50);
    });

    test('cost only counts ingredients linked to stock', () {
      expect(recipeCostPaise(recipe, 10, (_) => 200), 100);
      const unlinked = Recipe(
        id: 'r2',
        name: 'Tea',
        servings: 1,
        ingredients: [
          RecipeIngredient(name: 'Water', qtyMilli: 100, unit: StockUnit.litre),
        ],
      );
      expect(recipeCostPaise(unlinked, 1, (_) => 500), 0);
    });

    test('round-trips through JSON', () {
      final back = Recipe.tryFromJson(recipe.toJson());
      expect(back, isNotNull);
      expect(back!.name, 'Sambar');
      expect(back.ingredients.single.qtyMilli, 500);
      expect(back.steps.single, 'Boil');
    });
  });

  group('Job', () {
    const job = Job(
      id: 'j1',
      title: 'Cake',
      customer: 'Ravi',
      pricePaise: 50000,
      advancePaise: 20000,
      dueAt: 1767225600000,
    );

    test('balance is price minus advance', () {
      expect(job.balancePaise, 30000);
    });

    test('status advances through the workflow and stops at delivered', () {
      expect(nextJobStatus(JobStatus.taken), JobStatus.making);
      expect(nextJobStatus(JobStatus.making), JobStatus.ready);
      expect(nextJobStatus(JobStatus.ready), JobStatus.delivered);
      expect(nextJobStatus(JobStatus.delivered), isNull);
      expect(jobStatusFrom('nonsense'), JobStatus.taken);
    });

    test('round-trips through JSON', () {
      final back = Job.tryFromJson(job.toJson());
      expect(back!.balancePaise, 30000);
      expect(back.customer, 'Ravi');
    });
  });

  group('StallEvent', () {
    test('profit subtracts every cost and divides by footfall', () {
      const e = StallEvent(
        id: 'e1',
        name: 'Pongal fair',
        dayAt: 1767225600000,
        rentPaise: 100000,
        travelPaise: 20000,
        otherPaise: 10000,
        salesPaise: 250000,
        footfall: 100,
      );
      expect(e.costPaise, 130000);
      expect(e.profitPaise, 120000);
      expect(e.perVisitorPaise, 2500);
      expect(StallEvent.tryFromJson(e.toJson())!.profitPaise, 120000);
    });
  });

  group('Regular', () {
    test('rewards accrue every N visits and never go negative', () {
      const c = Regular(id: 'c1', name: 'Kumar', visits: 21, rewardsGiven: 1);
      expect(c.rewardsDue(10), 1);
      expect(c.visitsToReward(10), 9);
      const fresh = Regular(id: 'c2', name: 'Devi');
      expect(fresh.rewardsDue(10), 0);
      expect(fresh.visitsToReward(10), 0);
    });

    test('spend is grouped by how the customer found the shop', () {
      const rows = [
        Regular(
            id: 'a',
            name: 'A',
            source: CustomerSource.instagram,
            spentPaise: 1000),
        Regular(
            id: 'b',
            name: 'B',
            source: CustomerSource.instagram,
            spentPaise: 500),
        Regular(
            id: 'c', name: 'C', source: CustomerSource.maps, spentPaise: 700),
      ];
      final split = spendBySource(rows);
      expect(split[CustomerSource.instagram], 1500);
      expect(split[CustomerSource.maps], 700);
    });
  });

  group('Staff', () {
    test('wage payable counts half days as half and deducts advances', () {
      const w = Worker(id: 'w1', name: 'Selvi', dailyWagePaise: 40000);
      const entries = [
        AttendanceEntry(
            id: '1',
            workerId: 'w1',
            dayKey: '2026-01-01',
            status: AttendanceStatus.present),
        AttendanceEntry(
            id: '2',
            workerId: 'w1',
            dayKey: '2026-01-02',
            status: AttendanceStatus.half),
        AttendanceEntry(
            id: '3',
            workerId: 'w1',
            dayKey: '2026-01-03',
            status: AttendanceStatus.absent,
            advancePaise: 10000),
        AttendanceEntry(
            id: '4',
            workerId: 'other',
            dayKey: '2026-01-03',
            status: AttendanceStatus.present),
      ];
      expect(wagePayablePaise(w, entries), 50000);
    });

    test('day keys are stable and zero padded', () {
      expect(dayKeyOf(DateTime(2026, 2, 3)), '2026-02-03');
    });
  });

  group('Checklist', () {
    test('progress counts only items ticked for that day', () {
      final today = DateTime(2026, 3, 4);
      final items = [
        ChecklistItem(
            id: 'a',
            text: 'Change money',
            doneDayKey: dayKeyOf(today)),
        const ChecklistItem(id: 'b', text: 'Gas checked'),
      ];
      expect(checklistProgress(items, today), 0.5);
      expect(checklistProgress(const <ChecklistItem>[], today), 0);
    });
  });

  group('Routes', () {
    test('playbook paths build with query parameters', () {
      expect(AppRoutes.recipes(), '/recipes');
      expect(AppRoutes.recipe('r1', servings: 20), '/recipes/r1?servings=20');
      expect(AppRoutes.jobs(status: 'done'), '/jobs?status=done');
      expect(AppRoutes.staff(), '/staff');
      expect(AppRoutes.checklist(), '/checklist');
    });

    test('bad query values fall back safely', () {
      expect(AppQueryParsing.servings('zero', fallback: 4), 4);
      expect(AppQueryParsing.jobFilter('nonsense'), 'open');
    });
  });
}
