import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/application/expense_controller.dart';
import '../../expenses/domain/expense.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/inventory_models.dart';

/// A ready-made menu so a tea shop can start selling in one tap instead of
/// typing every item. Names are passed in already localized.
class StarterMenuItem {
  final String name;
  final int pricePaise;
  final int costPaise;
  const StarterMenuItem(this.name, this.pricePaise, this.costPaise);
}

class StarterSupply {
  final String name;
  final ExpenseKind kind;
  final int amountPaise;
  const StarterSupply(this.name, this.kind, this.amountPaise);
}

class StarterPack {
  final List<StarterMenuItem> menu;
  final List<StarterSupply> supplies;
  const StarterPack({required this.menu, required this.supplies});
}

/// Seeds the catalogue and the recurring daily supplies. Existing products
/// with the same name are left untouched, so the action is safe to repeat.
Future<void> applyStarterPack(WidgetRef ref, StarterPack pack) async {
  final inventory = ref.read(inventoryProvider.notifier);
  final existing = {
    for (final p in ref.read(inventoryProvider).liveProducts)
      p.displayName.toLowerCase()
  };
  for (final item in pack.menu) {
    if (existing.contains(item.name.toLowerCase())) continue;
    await inventory.saveProduct(
      name: item.name,
      unit: StockUnit.piece,
      pricePaise: item.pricePaise,
      costPaise: item.costPaise,
    );
  }

  final costs = ref.read(expenseProvider.notifier);
  final savedSupplies = {
    for (final r in ref.read(expenseProvider).recurring) r.name.toLowerCase()
  };
  for (final supply in pack.supplies) {
    if (savedSupplies.contains(supply.name.toLowerCase())) continue;
    await costs.saveRecurring(
      name: supply.name,
      kind: supply.kind,
      amountPaise: supply.amountPaise,
    );
  }
}
