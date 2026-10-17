import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../expenses/domain/expense.dart';
import '../../growth/application/growth_controller.dart';
import '../../growth/domain/checklist.dart';
import '../../products/domain/inventory_models.dart';
import '../../recipes/application/recipe_controller.dart';
import '../../recipes/domain/recipe.dart';
import '../domain/vendor_profile.dart';
import 'starter_pack.dart';

/// A whole starting kit for one kind of vendor: the menu they sell, the
/// supplies they buy every day, the routine they must not forget, and — for
/// eateries — a first recipe written the way the master would.
class VendorPreset {
  final StarterPack pack;
  final List<(String, ChecklistKind)> checklist;
  final List<Recipe> recipes;

  const VendorPreset({
    required this.pack,
    this.checklist = const [],
    this.recipes = const [],
  });
}

/// Preset for a vendor category; falls back to the tea-shop kit, which is the
/// most common shop on a Tamil Nadu street.
VendorPreset vendorPreset(AppLocalizations l10n, VendorCategory? category) {
  final common = <(String, ChecklistKind)>[
    (l10n.checklistSeed1, ChecklistKind.opening),
    (l10n.checklistSeed2, ChecklistKind.opening),
    (l10n.checklistSeed3, ChecklistKind.opening),
    (l10n.checklistSeed4, ChecklistKind.closing),
    (l10n.checklistSeed5, ChecklistKind.closing),
  ];

  switch (category) {
    case VendorCategory.hotel:
      return VendorPreset(
        pack: StarterPack(
          menu: [
            StarterMenuItem(l10n.starterIdli, 1000, 400),
            StarterMenuItem(l10n.starterDosa, 2000, 900),
            StarterMenuItem(l10n.starterMeals, 8000, 4500),
            StarterMenuItem(l10n.starterTea, 1000, 400),
            StarterMenuItem(l10n.starterCoffee, 1500, 600),
          ],
          supplies: [
            StarterSupply(l10n.starterVegSupply, ExpenseKind.provisions, 90000),
            StarterSupply(l10n.starterMilkSupply, ExpenseKind.milk, 60000),
            StarterSupply(l10n.starterGasSupply, ExpenseKind.gas, 110000),
          ],
        ),
        checklist: [
          (l10n.checklistSeedHotel, ChecklistKind.opening),
          ...common,
        ],
        recipes: [_teaRecipe(l10n)],
      );
    case VendorCategory.stall:
      return VendorPreset(
        pack: StarterPack(
          menu: [
            StarterMenuItem(l10n.starterTea, 1000, 400),
            StarterMenuItem(l10n.starterBiscuit, 500, 350),
            StarterMenuItem(l10n.starterSnackPacket, 1000, 800),
            StarterMenuItem(l10n.starterWaterBottle, 2000, 1400),
          ],
          supplies: [
            StarterSupply(l10n.starterMilkSupply, ExpenseKind.milk, 40000),
            StarterSupply(l10n.starterSnackSupply, ExpenseKind.snacks, 30000),
          ],
        ),
        checklist: common,
        recipes: [_teaRecipe(l10n)],
      );
    case VendorCategory.service:
      return VendorPreset(
        pack: const StarterPack(menu: [], supplies: []),
        checklist: [
          (l10n.checklistSeedService, ChecklistKind.opening),
          (l10n.checklistSeed1, ChecklistKind.opening),
          (l10n.checklistSeed4, ChecklistKind.closing),
        ],
      );
    case VendorCategory.cart:
    case null:
      return VendorPreset(
        pack: StarterPack(
          menu: [
            StarterMenuItem(l10n.starterTea, 1000, 400),
            StarterMenuItem(l10n.starterCoffee, 1500, 600),
            StarterMenuItem(l10n.starterBun, 1000, 700),
            StarterMenuItem(l10n.starterBiscuit, 500, 350),
            StarterMenuItem(l10n.starterBajji, 1000, 500),
          ],
          supplies: [
            StarterSupply(l10n.starterMilkSupply, ExpenseKind.milk, 60000),
            StarterSupply(l10n.starterSnackSupply, ExpenseKind.snacks, 30000),
          ],
        ),
        checklist: [
          (l10n.checklistSeedCart, ChecklistKind.opening),
          ...common,
        ],
        recipes: [_teaRecipe(l10n)],
      );
  }
}

Recipe _teaRecipe(AppLocalizations l10n) => Recipe(
      id: 'preset-tea',
      name: l10n.presetRecipeTea,
      servings: 10,
      ingredients: [
        RecipeIngredient(
            name: l10n.presetIngredientMilk,
            qtyMilli: 1500,
            unit: StockUnit.litre),
        RecipeIngredient(
            name: l10n.presetIngredientWater,
            qtyMilli: 1000,
            unit: StockUnit.litre),
        RecipeIngredient(
            name: l10n.presetIngredientTeaPowder,
            qtyMilli: 60,
            unit: StockUnit.gram),
        RecipeIngredient(
            name: l10n.presetIngredientSugar,
            qtyMilli: 150,
            unit: StockUnit.gram),
      ],
    );

/// Seeds menu, supplies, routine and recipes for this vendor type. Everything
/// is skipped when it already exists, so the action is safe to repeat.
Future<void> applyVendorPreset(WidgetRef ref, VendorPreset preset) async {
  await applyStarterPack(ref, preset.pack);
  if (preset.checklist.isNotEmpty) {
    await ref.read(growthProvider.notifier).seed(preset.checklist);
  }
  final recipes = ref.read(recipeProvider.notifier);
  final existing = {
    for (final r in ref.read(recipeProvider)) r.displayName.toLowerCase()
  };
  for (final recipe in preset.recipes) {
    if (existing.contains(recipe.displayName.toLowerCase())) continue;
    await recipes.save(
      name: recipe.name,
      servings: recipe.servings,
      ingredients: recipe.ingredients,
    );
  }
}
