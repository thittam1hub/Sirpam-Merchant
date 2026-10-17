import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../application/inventory_controller.dart';
import 'product_form_page.dart';

/// URL-addressable entry point for the product form.
///
/// `/products/new?code=…` creates, `/products/<id>/edit` edits. Keeping the
/// lookup here means a cold deep link resolves the product from storage
/// instead of relying on an in-memory object passed by the previous screen.
class ProductFormRoute extends ConsumerWidget {
  final String? productId;
  final String? initialCode;
  const ProductFormRoute({super.key, this.productId, this.initialCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productId == null || productId!.isEmpty) {
      return ProductFormPage(initialCode: initialCode);
    }
    final product = ref.watch(inventoryProvider).byId(productId!);
    if (product == null) {
      final l10n = context.l10n;
      return DetailScaffold(
        title: l10n.productEditTitle,
        fallbackLocation: AppPaths.products,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: NeuBox(
              child: Text(
                l10n.productMissing,
                textAlign: TextAlign.center,
                style: TextStyle(color: NeuColors.inkSoft),
              ),
            ),
          ),
        ),
      );
    }
    return ProductFormPage(product: product);
  }
}
