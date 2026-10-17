import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/inventory_controller.dart';
import '../domain/inventory_models.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// The catalogue: search, low-stock filter, and one tap into a product.
class ProductsPage extends ConsumerStatefulWidget {
  final String searchParam;
  final bool lowOnly;
  const ProductsPage({super.key, this.searchParam = '', this.lowOnly = false});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  late final TextEditingController _search =
      TextEditingController(text: widget.searchParam);
  late bool _lowOnly = widget.lowOnly;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _syncUrl() {
    context.replace(AppRoutes.products(
        search: _search.text.trim(), lowOnly: _lowOnly));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final needle = _search.text.trim().toLowerCase();
    final lowIds = inv.lowStock.map((p) => p.id).toSet();

    final items = inv.liveProducts.where((p) {
      if (_lowOnly && !lowIds.contains(p.id)) return false;
      if (needle.isEmpty) return true;
      return p.name.toLowerCase().contains(needle) ||
          p.nameLocal.toLowerCase().contains(needle) ||
          p.code.toLowerCase().contains(needle) ||
          p.category.toLowerCase().contains(needle);
    }).toList();

    return DetailScaffold(
      title: l10n.productsTitle,
      subtitle: l10n.productsSubtitle,
      actions: [
        NeuIconButton(
          icon: Icons.qr_code_scanner_rounded,
          label: l10n.scanTitle,
          onPressed: () => context.push(AppRoutes.scan()),
        ),
        NeuIconButton(
          icon: Icons.add_rounded,
          label: l10n.productsAdd,
          onPressed: () => context.push(AppRoutes.productNew()),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
            child: NeuField(
              controller: _search,
              hint: l10n.productsSearchHint,
              leading: Icon(Icons.search_rounded,
                  size: 20, color: NeuColors.inkSoft),
              onChanged: (_) {
                setState(() {});
                _syncUrl();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ActionRow(children: [
              NeuTextButton(
                label: l10n.productsAllChip,
                color: _lowOnly ? NeuColors.inkSoft : NeuColors.accentDark,
                onPressed: () {
                  setState(() => _lowOnly = false);
                  _syncUrl();
                },
              ),
              NeuTextButton(
                label: '${l10n.productsLowStockChip} (${inv.lowStock.length})',
                color: _lowOnly ? NeuColors.warn : NeuColors.inkSoft,
                onPressed: () {
                  setState(() => _lowOnly = true);
                  _syncUrl();
                },
              ),
            ]),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: NeuBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 40, color: NeuColors.inkSoft),
                            const SizedBox(height: 12),
                            Text(l10n.productsEmpty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: NeuColors.inkSoft)),
                            const SizedBox(height: 16),
                            NeuTextButton(
                              label: l10n.productsAdd,
                              onPressed: () =>
                                  context.push(AppRoutes.productNew()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = items[i];
                      final onHand = inv.onHand(p.id);
                      return _ProductTile(
                        product: p,
                        onHandMilli: onHand,
                        low: StockMath.isLow(p, onHand),
                        onTap: () => context.push(AppRoutes.product(p.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final int onHandMilli;
  final bool low;
  final VoidCallback onTap;

  const _ProductTile({
    required this.product,
    required this.onHandMilli,
    required this.low,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final margin = product.marginPct;
    return NeuBox(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.displayName,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
                if (product.nameLocal.isNotEmpty && product.name.isNotEmpty)
                  Text(product.nameLocal,
                      style: TextStyle(
                          fontSize: 13, color: NeuColors.inkSoft)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  StatusPill(
                    l10n.stockOnHand(
                        qtyWithUnit(context, onHandMilli, product.unit)),
                    color: low ? NeuColors.warn : NeuColors.inkSoft,
                  ),
                  if (product.pricePaise > 0)
                    StatusPill(money(product.pricePaise),
                        color: NeuColors.ink),
                  if (margin != null)
                    StatusPill(l10n.marginLabel(margin.toStringAsFixed(0)),
                        color: NeuColors.accentDark),
                ]),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: NeuColors.inkSoft),
        ],
      ),
    );
  }
}
