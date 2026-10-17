import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../domain/admin_reports.dart';
import 'admin_widgets.dart';

String _qty(int milli) {
  final v = milli / 1000;
  return v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(2);
}

/// Sold on the board against stock actually taken out. A gap is a question,
/// not an accusation: free tastings, spillage and untyped sales all show here.
class ItemFlowPage extends ConsumerStatefulWidget {
  const ItemFlowPage({super.key});

  @override
  ConsumerState<ItemFlowPage> createState() => _ItemFlowPageState();
}

class _ItemFlowPageState extends ConsumerState<ItemFlowPage> {
  AdminPeriod _period = AdminPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final orders = ref.watch(orderProvider);
    final inv = ref.watch(inventoryProvider);
    final rows = buildItemFlow(
      orders: orders.orders,
      movements: inv.movements,
      products: inv.products,
      range: rangeFor(_period, DateTime.now()),
    );

    return DetailScaffold(
      title: l10n.adminItemsTitle,
      subtitle: l10n.adminItemsSubtitle,
      fallbackLocation: AppPaths.admin,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            AdminPeriodBar(
                period: _period,
                onChanged: (p) => setState(() => _period = p)),
            const SizedBox(height: 16),
            if (rows.isEmpty) const AdminEmpty(),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(r.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: NeuColors.ink)),
                      const SizedBox(height: 4),
                      AdminStatRow(l10n.adminItemSold, _qty(r.soldMilli)),
                      AdminStatRow(
                          l10n.adminItemStockOut, _qty(r.stockOutMilli)),
                      AdminStatRow(
                        l10n.adminItemGap,
                        _qty(r.gapMilli),
                        valueColor: r.gapMilli > 0 ? NeuColors.warn : null,
                      ),
                      if (r.wastedMilli > 0)
                        AdminStatRow(
                            l10n.adminItemWasted, _qty(r.wastedMilli)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
