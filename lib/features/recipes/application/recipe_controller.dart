import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/inventory_models.dart';
import '../domain/recipe.dart';

class RecipeController extends Notifier<List<Recipe>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<Recipe> build() => [
        for (final row in _store.readRecipes())
          ...[Recipe.tryFromJson(row)].whereType<Recipe>(),
      ];

  int get _now => DateTime.now().millisecondsSinceEpoch;

  String _id() => 'r${DateTime.now().microsecondsSinceEpoch}';

  Recipe? byId(String id) => state.where((r) => r.id == id).firstOrNull;

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeRecipes([for (final r in state) r.toJson()]));

  Future<Recipe> save({
    String? id,
    required String name,
    String nameLocal = '',
    int servings = 1,
    String productId = '',
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    String note = '',
  }) async {
    final existing = id == null ? null : byId(id);
    final recipe = (existing ?? Recipe(id: _id(), name: name)).copyWith(
      name: name,
      nameLocal: nameLocal,
      servings: servings,
      productId: productId,
      ingredients: ingredients ?? existing?.ingredients ?? const [],
      steps: steps ?? existing?.steps ?? const [],
      note: note,
      updatedAt: _now,
    );
    state = [...state.where((r) => r.id != recipe.id), recipe];
    await _persist();
    return recipe;
  }

  Future<void> delete(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _persist();
  }

  Future<void> addIngredient(String recipeId, RecipeIngredient line) async {
    final recipe = byId(recipeId);
    if (recipe == null) return;
    state = [
      for (final r in state)
        r.id == recipeId
            ? r.copyWith(
                ingredients: [...r.ingredients, line], updatedAt: _now)
            : r,
    ];
    await _persist();
  }

  Future<void> removeIngredient(String recipeId, int index) async {
    final recipe = byId(recipeId);
    if (recipe == null || index < 0 || index >= recipe.ingredients.length) {
      return;
    }
    final next = [...recipe.ingredients]..removeAt(index);
    state = [
      for (final r in state)
        r.id == recipeId ? r.copyWith(ingredients: next, updatedAt: _now) : r,
    ];
    await _persist();
  }

  Future<void> addStep(String recipeId, String step) async {
    final recipe = byId(recipeId);
    if (recipe == null || step.trim().isEmpty) return;
    state = [
      for (final r in state)
        r.id == recipeId
            ? r.copyWith(steps: [...r.steps, step.trim()], updatedAt: _now)
            : r,
    ];
    await _persist();
  }

  Future<void> removeStep(String recipeId, int index) async {
    final recipe = byId(recipeId);
    if (recipe == null || index < 0 || index >= recipe.steps.length) return;
    final next = [...recipe.steps]..removeAt(index);
    state = [
      for (final r in state)
        r.id == recipeId ? r.copyWith(steps: next, updatedAt: _now) : r,
    ];
    await _persist();
  }

  /// Outcome of a prep run: either every ingredient was drawn, or nothing
  /// was and [shortages] names the raw material that ran out.
  Future<CookResult> cookBatch(String recipeId, int servings) async {
    final recipe = byId(recipeId);
    if (recipe == null) return const CookResult(drawn: 0);
    final inventory = ref.read(inventoryProvider.notifier);
    final stock = ref.read(inventoryProvider);
    final lines = [
      for (final line in recipe.scaledTo(servings))
        if (line.productId.isNotEmpty && line.qtyMilli > 0) line,
    ];
    final short = [
      for (final line in lines)
        if (stock.onHand(line.productId) < line.qtyMilli)
          stock.byId(line.productId)?.displayName ?? line.name,
    ];
    if (short.isNotEmpty) return CookResult(drawn: 0, shortages: short);
    for (final line in lines) {
      await inventory.recordPrep(
        productId: line.productId,
        qtyMilli: line.qtyMilli,
        note: 'recipe:${recipe.id}',
      );
    }
    return CookResult(drawn: lines.length);
  }
}

class CookResult {
  final int drawn;
  final List<String> shortages;
  const CookResult({required this.drawn, this.shortages = const []});
  bool get isShort => shortages.isNotEmpty;
}

final recipeProvider =
    NotifierProvider<RecipeController, List<Recipe>>(RecipeController.new);

/// Material cost of a recipe at [servings], using catalogue costs.
final recipeCostProvider =
    Provider.family<int, ({String recipeId, int servings})>((ref, args) {
  final recipe = ref
      .watch(recipeProvider)
      .where((r) => r.id == args.recipeId)
      .firstOrNull;
  if (recipe == null) return 0;
  final inventory = ref.watch(inventoryProvider);
  return recipeCostPaise(
    recipe,
    args.servings,
    (id) => inventory.byId(id)?.costPaise ?? 0,
  );
});

/// Catalogue items a recipe can be linked to.
List<Product> recipeLinkableProducts(InventoryState inventory) =>
    inventory.products.where((p) => !p.deleted).toList();
