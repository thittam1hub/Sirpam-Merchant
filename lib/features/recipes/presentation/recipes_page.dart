import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/recipe_controller.dart';

/// The shop's own recipe book: measurements written down once so anyone can
/// cook the same taste.
class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final _name = TextEditingController();
  final _servings = TextEditingController(text: '10');

  @override
  void dispose() {
    _name.dispose();
    _servings.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final recipe = await ref.read(recipeProvider.notifier).save(
          name: name,
          servings: int.tryParse(_servings.text.trim()) ?? 1,
        );
    if (!mounted) return;
    _name.clear();
    FocusScope.of(context).unfocus();
    await context.push(AppRoutes.recipe(recipe.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recipes = [...ref.watch(recipeProvider)]
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return DetailScaffold(
      title: l10n.recipesTitle,
      subtitle: l10n.recipesSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.recipeAdd),
          LabeledField(label: l10n.recipeName, controller: _name),
          LabeledField(
              label: l10n.recipeServings,
              controller: _servings,
              keyboard: TextInputType.number),
          NeuTextButton(
              label: l10n.recipeAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          SectionTitle(l10n.recipesTitle),
          if (recipes.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.recipeEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...recipes.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuButton(
                    onPressed: () => context.push(AppRoutes.recipe(r.id)),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.displayName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            Text(
                                '${r.servings} · ${r.ingredients.length}',
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: NeuColors.inkSoft),
                    ]),
                  ),
                )),
        ],
      ),
    );
  }
}
