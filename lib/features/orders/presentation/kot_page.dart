import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/order_controller.dart';
import '../domain/order.dart';

/// Kitchen ticket view: only what has to be cooked, in the order it came in.
class KotPage extends ConsumerWidget {
  const KotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final queue = ref.watch(orderProvider).kitchenQueue;
    final controller = ref.read(orderProvider.notifier);

    return DetailScaffold(
      title: l10n.kotTitle,
      subtitle: l10n.kotSubtitle,
      fallbackLocation: AppPaths.orders,
      body: queue.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: NeuBox(
                  child: Text(l10n.kotEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: NeuColors.inkSoft)),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
              itemCount: queue.length,
              itemBuilder: (_, i) {
                final order = queue[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeuBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(l10n.orderToken(order.token),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                          if (order.tableLabel.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            StatusPill(
                                '${l10n.orderTable} ${order.tableLabel}'),
                          ],
                        ]),
                        const SizedBox(height: 8),
                        for (final line in order.lines) ...[
                          Text('${line.qty} × ${line.name}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.ink)),
                          if (line.note.isNotEmpty)
                            Text(line.note,
                                style: TextStyle(
                                    fontSize: 13, color: NeuColors.warn)),
                        ],
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: NeuTextButton(
                            label: order.status == OrderStatus.placed
                                ? l10n.orderAccept
                                : l10n.kotDone,
                            color: NeuColors.accentDark,
                            onPressed: () => controller.setStatus(
                              order.id,
                              order.status == OrderStatus.placed
                                  ? OrderStatus.preparing
                                  : OrderStatus.served,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
