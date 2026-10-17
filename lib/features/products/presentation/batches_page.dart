import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../application/inventory_controller.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// Expiry watch across every dated batch, soonest first.
class BatchesPage extends ConsumerWidget {
  const BatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final df = DateFormat('dd MMM yyyy');
    final now = DateTime.now();
    final rows = inv.datedBatches;

    return DetailScaffold(
      title: l10n.batchesTitle,
      subtitle: l10n.batchesSubtitle,
      fallbackLocation: AppPaths.stock,
      body: rows.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: NeuBox(
                  child: Text(l10n.batchesEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: NeuColors.inkSoft)),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final b = rows[i];
                final product = inv.byId(b.productId);
                final bucket = StockMath.bucket(b, now);
                final expiry = DateTime.fromMillisecondsSinceEpoch(b.expiryAt!);
                final label = switch (bucket) {
                  ExpiryBucket.expired => l10n.expiredTag,
                  ExpiryBucket.today => l10n.expiryTodayTag,
                  _ => l10n.expirySoonTag(
                      expiry.difference(now).inDays.clamp(0, 9999)),
                };
                final color = switch (bucket) {
                  ExpiryBucket.expired => NeuColors.danger,
                  ExpiryBucket.today || ExpiryBucket.soon => NeuColors.warn,
                  _ => NeuColors.inkSoft,
                };
                return NeuBox(
                  onTap: product == null
                      ? null
                      : () => context.push(AppRoutes.product(product.id)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product?.displayName ?? b.productId,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: NeuColors.ink)),
                            const SizedBox(height: 4),
                            Text(
                              '${product == null ? StockMath.formatQty(b.remainingMilli) : qtyWithUnit(context, b.remainingMilli, product.unit)} · ${df.format(expiry)}',
                              style: TextStyle(
                                  fontSize: 13, color: NeuColors.inkSoft),
                            ),
                          ],
                        ),
                      ),
                      StatusPill(label, color: color),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
