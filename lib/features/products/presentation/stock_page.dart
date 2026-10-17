import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../application/inventory_controller.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// Stock dashboard: what it is worth, what is running out, what is expiring.
class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final since = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;

    return DetailScaffold(
      title: l10n.stockTitle,
      subtitle: l10n.stockSubtitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          Row(children: [
            Expanded(
                child: _Metric(
                    label: l10n.stockValuation,
                    value: money(inv.valuationPaise))),
            const SizedBox(width: 12),
            Expanded(
                child: _Metric(
                    label: l10n.stockProfit,
                    value: money(inv.profitPaise(sinceMs: since)),
                    color: NeuColors.accentDark)),
          ]),
          const SizedBox(height: 12),
          _Metric(
              label: l10n.stockWastage,
              value: money(inv.wastagePaise(sinceMs: since)),
              color: NeuColors.danger),
          if (inv.updatedAtMs != null) ...[
            const SizedBox(height: 12),
            NeuBox(
              inset: true,
              child: Text(
                l10n.stockLastUpdated(_ago(l10n, inv.updatedAtMs!)),
                style: TextStyle(fontSize: 13, color: NeuColors.inkSoft),
              ),
            ),
          ],
          SectionTitle(l10n.stockLowTitle),
          if (inv.lowStock.isEmpty)
            NeuBox(
                child: Text(l10n.stockNothingLow,
                    style: TextStyle(color: NeuColors.inkSoft)))
          else
            for (final p in inv.lowStock)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  onTap: () => context.push(AppRoutes.product(p.id)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(p.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink)),
                      ),
                      StatusPill(
                          qtyWithUnit(context, inv.onHand(p.id), p.unit),
                          color: NeuColors.warn),
                    ],
                  ),
                ),
              ),
          if (inv.lowStock.isNotEmpty) ...[
            const SizedBox(height: 6),
            NeuTextButton(
              label: l10n.stockReorderNow,
              color: NeuColors.accentDark,
              onPressed: () => context.push(AppRoutes.suppliers()),
            ),
          ],
          SectionTitle(l10n.stockExpiryTitle),
          NeuBox(
            onTap: () => context.push(AppRoutes.batches()),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    inv.datedBatches.isEmpty
                        ? l10n.stockNoExpiry
                        : l10n.expiryWatchCount(inv.datedBatches
                            .where((b) =>
                                StockMath.bucket(b, DateTime.now()) !=
                                    ExpiryBucket.later)
                            .length),
                    style: TextStyle(color: NeuColors.inkSoft),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: NeuColors.inkSoft),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Human wording for "how long ago", in the vendor's own language.
String _ago(AppLocalizations l10n, int ms) {
  final minutes =
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ms)).inMinutes;
  if (minutes < 1) return l10n.agoJustNow;
  if (minutes < 60) return l10n.agoMinutes(minutes);
  if (minutes < 60 * 24) return l10n.agoHours(minutes ~/ 60);
  return l10n.agoDays(minutes ~/ (60 * 24));
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Metric(
      {required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => NeuBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      );
}
