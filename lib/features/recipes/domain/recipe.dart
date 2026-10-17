/// Kitchen recipe book: the master's measurements written down once so the
/// shop can cook the same taste when he is on leave.
///
/// Invariants match the inventory module: quantities are integer milli-units
/// (0.25 kg = 250) and money is integer paise, so scaling a recipe up or down
/// never drifts.
library;

import '../../products/domain/inventory_models.dart';

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? fallback;

String _str(Object? v) => v?.toString() ?? '';

class RecipeIngredient {
  /// Catalogue product this ingredient draws from; empty for a free-text line.
  final String productId;
  final String name;
  final int qtyMilli;
  final StockUnit unit;
  final String note;

  const RecipeIngredient({
    this.productId = '',
    required this.name,
    required this.qtyMilli,
    this.unit = StockUnit.gram,
    this.note = '',
  });

  RecipeIngredient copyWith({
    String? productId,
    String? name,
    int? qtyMilli,
    StockUnit? unit,
    String? note,
  }) =>
      RecipeIngredient(
        productId: productId ?? this.productId,
        name: name ?? this.name,
        qtyMilli: qtyMilli ?? this.qtyMilli,
        unit: unit ?? this.unit,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'qtyMilli': qtyMilli,
        'unit': unit.name,
        'note': note,
      };

  static RecipeIngredient? tryFromJson(Map<String, dynamic> j) {
    final name = _str(j['name']);
    if (name.isEmpty) return null;
    return RecipeIngredient(
      productId: _str(j['productId']),
      name: name,
      qtyMilli: _int(j['qtyMilli']),
      unit: stockUnitFrom(j['unit'] as String?),
      note: _str(j['note']),
    );
  }
}

class Recipe {
  final String id;
  final String name;
  final String nameLocal;

  /// How many plates / pieces the written measurements produce.
  final int servings;

  /// Optional catalogue item this recipe produces (links cost to the menu).
  final String productId;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String note;
  final int updatedAt;

  const Recipe({
    required this.id,
    required this.name,
    this.nameLocal = '',
    this.servings = 1,
    this.productId = '',
    this.ingredients = const [],
    this.steps = const [],
    this.note = '',
    this.updatedAt = 0,
  });

  String get displayName => name.isNotEmpty ? name : nameLocal;

  Recipe copyWith({
    String? name,
    String? nameLocal,
    int? servings,
    String? productId,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    String? note,
    int? updatedAt,
  }) =>
      Recipe(
        id: id,
        name: name ?? this.name,
        nameLocal: nameLocal ?? this.nameLocal,
        servings: servings ?? this.servings,
        productId: productId ?? this.productId,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// The same recipe written for [target] servings. Rounds to the nearest
  /// milli-unit, so half a recipe of 125 g is exactly 62.5 g -> 63.
  List<RecipeIngredient> scaledTo(int target) {
    final from = servings <= 0 ? 1 : servings;
    final to = target <= 0 ? 1 : target;
    return [
      for (final i in ingredients)
        i.copyWith(qtyMilli: (i.qtyMilli * to / from).round()),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameLocal': nameLocal,
        'servings': servings,
        'productId': productId,
        'ingredients': [for (final i in ingredients) i.toJson()],
        'steps': steps,
        'note': note,
        'updatedAt': updatedAt,
      };

  static Recipe? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final name = _str(j['name']);
    if (id is! String || id.isEmpty || name.isEmpty) return null;
    final rawIngredients = j['ingredients'];
    final rawSteps = j['steps'];
    return Recipe(
      id: id,
      name: name,
      nameLocal: _str(j['nameLocal']),
      servings: _int(j['servings'], 1).clamp(1, 100000),
      productId: _str(j['productId']),
      ingredients: rawIngredients is List
          ? [
              for (final e in rawIngredients)
                if (e is Map)
                  ...[RecipeIngredient.tryFromJson(e.cast<String, dynamic>())]
                      .whereType<RecipeIngredient>(),
            ]
          : const [],
      steps: rawSteps is List
          ? [
              for (final s in rawSteps)
                if (s != null && '$s'.trim().isNotEmpty) '$s',
            ]
          : const [],
      note: _str(j['note']),
      updatedAt: _int(j['updatedAt']),
    );
  }
}

/// Material cost of a recipe at the given serving count, in paise. Ingredients
/// without a linked catalogue product contribute nothing — the vendor sees the
/// gap on screen instead of a wrong number.
int recipeCostPaise(
  Recipe recipe,
  int servings,
  int Function(String productId) unitCostPaise,
) {
  var total = 0;
  for (final line in recipe.scaledTo(servings)) {
    if (line.productId.isEmpty) continue;
    total += (line.qtyMilli * unitCostPaise(line.productId) / 1000).round();
  }
  return total;
}
