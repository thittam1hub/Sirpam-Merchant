import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/inventory_models.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/recipe_controller.dart';
import '../domain/recipe.dart';

/// One dish: measurements that scale with the plate count, the material cost
/// behind it, and the method so anyone can cook it.
class RecipeDetailPage extends ConsumerStatefulWidget {
  final String recipeId;
  final int initialServings;

  const RecipeDetailPage({
    super.key,
    required this.recipeId,
    this.initialServings = 0,
  });

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  int? _servings;

  Future<void> _addIngredient(List<Product> products) async {
    final name = TextEditingController();
    final qty = TextEditingController();
    String productId = '';
    StockUnit unit = StockUnit.gram;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: NeuColors.canvas,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SectionTitle(ctx.l10n.recipeAddIngredient),
              LabeledField(label: ctx.l10n.recipeName, controller: name),
              LabeledField(
                  label: ctx.l10n.recipeQty,
                  controller: qty,
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final u in StockUnit.values)
                    NeuButton(
                      selected: u == unit,
                      minHeight: 38,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      onPressed: () => setLocal(() => unit = u),
                      child: Text(u.name,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: NeuColors.inkSoft)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SectionTitle(ctx.l10n.recipeLinkProduct),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  NeuButton(
                    selected: productId.isEmpty,
                    minHeight: 38,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    onPressed: () => setLocal(() => productId = ''),
                    child: Text(ctx.l10n.recipeNoLink,
                        style: TextStyle(
                            fontSize: 12, color: NeuColors.inkSoft)),
                  ),
                  for (final p in products)
                    NeuButton(
                      selected: productId == p.id,
                      minHeight: 38,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      onPressed: () => setLocal(() {
                        productId = p.id;
                        if (name.text.trim().isEmpty) name.text = p.name;
                        unit = p.unit;
                      }),
                      child: Text(p.name,
                          style: TextStyle(
                              fontSize: 12, color: NeuColors.inkSoft)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              ActionRow(children: [
                NeuTextButton(
                    label: ctx.l10n.cancel,
                    onPressed: () => Navigator.of(ctx).pop(false)),
                NeuTextButton(
                    label: ctx.l10n.save,
                    color: NeuColors.accentDark,
                    onPressed: () => Navigator.of(ctx).pop(true)),
              ]),
            ]),
          ),
        ),
      ),
    );
    if (saved == true) {
      final v = double.tryParse(qty.text.trim()) ?? 0;
      final label = name.text.trim();
      if (v > 0 && label.isNotEmpty) {
        await ref.read(recipeProvider.notifier).addIngredient(
              widget.recipeId,
              RecipeIngredient(
                productId: productId,
                name: label,
                qtyMilli: (v * 1000).round(),
                unit: unit,
              ),
            );
      }
    }
    name.dispose();
    qty.dispose();
  }

  Future<void> _addStep() async {
    final text = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.recipeAddStep),
            LabeledField(label: ctx.l10n.recipeSteps, controller: text),
            const SizedBox(height: 12),
            ActionRow(children: [
              NeuTextButton(
                  label: ctx.l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(false)),
              NeuTextButton(
                  label: ctx.l10n.save,
                  color: NeuColors.accentDark,
                  onPressed: () => Navigator.of(ctx).pop(true)),
            ]),
          ]),
        ),
      ),
    );
    if (saved == true) {
      await ref.read(recipeProvider.notifier).addStep(widget.recipeId, text.text);
    }
    text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recipe = ref
        .watch(recipeProvider)
        .where((r) => r.id == widget.recipeId)
        .firstOrNull;
    final inventory = ref.watch(inventoryProvider);

    if (recipe == null) {
      return DetailScaffold(
        title: l10n.recipesTitle,
        fallbackLocation: AppPaths.recipes,
        body: Center(
            child: Text(l10n.recipeEmpty,
                style: TextStyle(color: NeuColors.inkSoft))),
      );
    }

    final servings = _servings ??
        (widget.initialServings > 0 ? widget.initialServings : recipe.servings);
    final lines = recipe.scaledTo(servings);
    final cost = recipeCostPaise(
        recipe, servings, (id) => inventory.byId(id)?.costPaise ?? 0);
    final perServing = servings <= 0 ? 0 : (cost / servings).round();
    final unlinked = recipe.ingredients.any((i) => i.productId.isEmpty);

    return DetailScaffold(
      title: recipe.displayName,
      subtitle: l10n.recipesSubtitle,
      fallbackLocation: AppPaths.recipes,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Column(children: [
              Text(l10n.recipeScale,
                  style:
                      TextStyle(fontSize: 14, color: NeuColors.inkSoft)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                NeuIconButton(
                  icon: Icons.remove_rounded,
                  label: l10n.recipeScale,
                  onPressed: () => setState(
                      () => _servings = servings > 1 ? servings - 1 : 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('$servings',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: NeuColors.ink)),
                ),
                NeuIconButton(
                  icon: Icons.add_rounded,
                  label: l10n.recipeScale,
                  onPressed: () => setState(() => _servings = servings + 1),
                ),
              ]),
              const SizedBox(height: 12),
              Text('${l10n.recipeCost}: ${money(cost)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: NeuColors.ink)),
              Text('${l10n.recipePerServing}: ${money(perServing)}',
                  style:
                      TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
            ]),
          ),
          if (unlinked)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: NeuBox(
                inset: true,
                child: Text(l10n.recipeUnlinkedWarning,
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.inkSoft)),
              ),
            ),
          SectionTitle(l10n.recipeIngredients,
              trailing: NeuIconButton(
                  icon: Icons.add_rounded,
                  label: l10n.recipeAddIngredient,
                  onPressed: () =>
                      _addIngredient(recipeLinkableProducts(inventory)))),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeuBox(
                child: Row(children: [
                  Expanded(
                    child: Text(lines[i].name,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: NeuColors.ink)),
                  ),
                  Text(
                      '${(lines[i].qtyMilli / 1000).toStringAsFixed(3)} ${lines[i].unit.name}',
                      style: TextStyle(color: NeuColors.inkSoft)),
                  const SizedBox(width: 8),
                  NeuIconButton(
                    icon: Icons.delete_outline_rounded,
                    label: l10n.delete,
                    onPressed: () => ref
                        .read(recipeProvider.notifier)
                        .removeIngredient(recipe.id, i),
                  ),
                ]),
              ),
            ),
          SectionTitle(l10n.recipeSteps,
              trailing: NeuIconButton(
                  icon: Icons.add_rounded,
                  label: l10n.recipeAddStep,
                  onPressed: _addStep)),
          if (recipe.steps.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: Text(l10n.recipeStepsEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            for (var i = 0; i < recipe.steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Row(children: [
                    Text('${i + 1}. ',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NeuColors.accentDark)),
                    Expanded(
                        child: Text(recipe.steps[i],
                            style: TextStyle(color: NeuColors.ink))),
                    NeuIconButton(
                      icon: Icons.delete_outline_rounded,
                      label: l10n.delete,
                      onPressed: () => ref
                          .read(recipeProvider.notifier)
                          .removeStep(recipe.id, i),
                    ),
                  ]),
                ),
              ),
          const SizedBox(height: 16),
          NeuTextButton(
            label: l10n.recipeCookBatch,
            color: NeuColors.accentDark,
            onPressed: () async {
              final result = await ref
                  .read(recipeProvider.notifier)
                  .cookBatch(recipe.id, servings);
              if (!context.mounted) return;
              if (result.isShort) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        l10n.recipeShortStock(result.shortages.join(', ')))));
                return;
              }
              if (result.drawn == 0) return;
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.recipeCooked)));
            },
          ),
        ],
      ),
    );
  }
}
