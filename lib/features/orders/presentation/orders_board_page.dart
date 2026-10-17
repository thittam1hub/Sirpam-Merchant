import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../products/application/inventory_controller.dart';

import '../../products/presentation/inventory_widgets.dart';
import '../application/order_controller.dart';
import '../application/order_sync_controller.dart';
import '../domain/order.dart';

/// The counter board: every live order, its state, and the one action that
/// moves it forward. Designed to be usable with one thumb and wet hands.
class OrdersBoardPage extends ConsumerStatefulWidget {
  /// `/orders?status=history` opens straight on the settled list.
  final bool initialHistory;
  const OrdersBoardPage({super.key, this.initialHistory = false});

  @override
  ConsumerState<OrdersBoardPage> createState() => _OrdersBoardPageState();
}

class _OrdersBoardPageState extends ConsumerState<OrdersBoardPage> {
  late bool _showHistory = widget.initialHistory;

  void _selectView(bool history) {
    setState(() => _showHistory = history);
    context.replace(AppRoutes.orders(status: history ? 'history' : null));
  }

  Future<void> _newCounterOrder() async {
    final allowed =
        await ref.guard(context, Permission.takeOrder, action: 'order.new');
    if (!allowed.ok || !mounted) return;
    final products = ref

        .read(inventoryProvider)
        .activeProducts
        .where((p) => p.pricePaise > 0)
        .toList();
    if (products.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.quickSaleEmpty)));
      return;
    }
    final qty = <String, int>{};
    final table = TextEditingController();
    final name = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: NeuColors.canvas,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SectionTitle(ctx.l10n.orderCounterNew),
              Row(children: [
                Expanded(
                  child: LabeledField(
                      label: ctx.l10n.orderTable, controller: table),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LabeledField(
                      label: ctx.l10n.billCustomer, controller: name),
                ),
              ]),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    final count = qty[p.id] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NeuBox(
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.displayName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: NeuColors.ink)),
                                Text(money(p.pricePaise),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: NeuColors.inkSoft)),
                              ],
                            ),
                          ),
                          NeuIconButton(
                            icon: Icons.remove_rounded,
                            label: ctx.l10n.orderRemoveItem,
                            onPressed: count == 0
                                ? null
                                : () => setSheet(() => qty[p.id] = count - 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('$count',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                          ),
                          NeuIconButton(
                            icon: Icons.add_rounded,
                            label: ctx.l10n.orderAddItem,
                            onPressed: () => setSheet(() => qty[p.id] = count + 1),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
    final lines = <OrderLine>[
      for (final p in products)
        if ((qty[p.id] ?? 0) > 0)
          OrderLine(
              productId: p.id,
              name: p.displayName,
              pricePaise: p.pricePaise,
              qty: qty[p.id]!,
              taxPermille: p.taxPermille,
              hsn: p.hsn),
    ];
    final tableLabel = table.text.trim();
    final customer = name.text.trim();
    table.dispose();
    name.dispose();
    if (result != true || lines.isEmpty) return;
    await ref.read(orderProvider.notifier).placeOrder(
          lines: lines,
          tableLabel: tableLabel,
          customerName: customer,
          source: OrderSource.counter,
        );
  }

  Future<void> _cancel(ShopOrder order) async {
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.orderCancelReason),
            LabeledField(
                label: ctx.l10n.orderCancelReason,
                controller: reason,
                autofocus: true),
            ActionRow(children: [
              NeuTextButton(
                  label: ctx.l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(false)),
              NeuTextButton(
                  label: ctx.l10n.orderCancel,
                  color: NeuColors.danger,
                  onPressed: () => Navigator.of(ctx).pop(true)),
            ]),
          ]),
        ),
      ),
    );
    final text = reason.text.trim();
    reason.dispose();
    if (ok != true || !mounted) return;
    final allowed = await ref.guard(context, Permission.changeOrderStatus,

        action: 'order.cancel', refType: 'order', refId: order.id, note: text);
    if (!allowed.ok) return;
    await ref
        .read(orderProvider.notifier)
        .setStatus(order.id, OrderStatus.cancelled, reason: text);
  }

  /// Edit the items on an order that has not been billed yet — a customer
  /// adding one more tea, or a sold-out item coming off the ticket.
  Future<void> _editItems(ShopOrder order) async {
    final l10n = context.l10n;
    final allowed = await ref.guard(context, Permission.takeOrder,
        action: 'order.edit', refType: 'order', refId: order.id);
    if (!allowed.ok || !mounted) return;
    final qty = {for (final l in order.lines) l.productId: l.qty};
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: NeuColors.canvas,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(l10n.orderEditItems),
            for (final line in order.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(
                      child: Text(line.name,
                          style: TextStyle(color: NeuColors.ink))),
                  NeuIconButton(
                    icon: Icons.remove_rounded,
                    label: '-',
                    onPressed: () => setSheet(() => qty[line.productId] =
                        (qty[line.productId] ?? 0) > 0
                            ? qty[line.productId]! - 1
                            : 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('${qty[line.productId] ?? 0}',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NeuColors.ink)),
                  ),
                  NeuIconButton(
                    icon: Icons.add_rounded,
                    label: '+',
                    onPressed: () => setSheet(
                        () => qty[line.productId] = (qty[line.productId] ?? 0) + 1),
                  ),
                ]),
              ),
            ActionRow(children: [
              NeuTextButton(
                  label: l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(false)),
              NeuTextButton(
                  label: l10n.save,
                  color: NeuColors.accentDark,
                  onPressed: () => Navigator.of(ctx).pop(true)),
            ]),
          ]),
        ),
      ),
    );
    if (saved != true) return;
    final lines = [
      for (final line in order.lines)
        if ((qty[line.productId] ?? 0) > 0)
          line.copyWith(qty: qty[line.productId]!),
    ];
    if (!mounted) return;
    if (lines.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.orderEditEmpty)));
      return;
    }
    await ref.read(orderProvider.notifier).updateLines(order.id, lines);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.orderEditItemsSaved)));
  }

  /// Rush-hour shortcut: move every order in one state forward at once,
  /// instead of tapping each card during a tea-time queue.
  Future<void> _bulkMove(
      List<ShopOrder> orders, OrderStatus from, OrderStatus to) async {
    final allowed = await ref.guard(context, Permission.changeOrderStatus,
        action: 'order.bulk');
    if (!allowed.ok) return;
    final controller = ref.read(orderProvider.notifier);
    for (final o in orders.where((o) => o.status == from).toList()) {
      await controller.setStatus(o.id, to);
    }

  }

  /// Tables asking for staff or the bill: loudest row on the board.
  Widget _requestBar(AppLocalizations l10n) {
    final requests = ref.watch(orderSyncProvider).requests;
    if (requests.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Column(
        children: [
          for (final r in requests)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NeuBox(
                child: Row(children: [
                  Icon(
                    r.isBill
                        ? Icons.receipt_long_rounded
                        : Icons.notifications_active_rounded,
                    color: r.isBill ? NeuColors.upi : NeuColors.warn,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${r.tableLabel.isEmpty ? l10n.requestCounter : l10n.requestTable(r.tableLabel)} · '
                      '${r.isBill ? l10n.requestBill : l10n.requestCallStaff}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: NeuColors.ink),
                    ),
                  ),
                  NeuTextButton(
                    label: l10n.requestSeen,
                    onPressed: () =>
                        ref.read(orderSyncProvider.notifier).clearRequest(r.id),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bulkBar(AppLocalizations l10n, List<ShopOrder> orders) {
    final newCount =
        orders.where((o) => o.status == OrderStatus.placed).length;
    final prepCount =
        orders.where((o) => o.status == OrderStatus.preparing).length;
    if (newCount == 0 && prepCount == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Row(children: [
        if (newCount > 0)
          Expanded(
            child: NeuTextButton(
              label: '${l10n.orderBulkAccept} ($newCount)',
              onPressed: () => _bulkMove(
                  orders, OrderStatus.placed, OrderStatus.preparing),
            ),
          ),
        if (newCount > 0 && prepCount > 0) const SizedBox(width: 10),
        if (prepCount > 0)
          Expanded(
            child: NeuTextButton(
              label: '${l10n.orderBulkServe} ($prepCount)',
              color: NeuColors.accentDark,
              onPressed: () => _bulkMove(
                  orders, OrderStatus.preparing, OrderStatus.served),
            ),
          ),
      ]),
    );
  }

  @override

  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(orderProvider);
    final orders = _showHistory
        ? (state.orders.where((o) => !o.isOpen).toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)))
        : state.openOrders;

    return DetailScaffold(
      title: l10n.ordersTitle,
      subtitle: l10n.ordersSubtitle,
      fallbackLocation: AppPaths.home,
      actions: [
        NeuIconButton(
          icon: Icons.soup_kitchen_rounded,
          label: l10n.kotTitle,
          onPressed: () => context.push(AppRoutes.kot()),
        ),
        NeuIconButton(
          icon: Icons.add_rounded,
          label: l10n.orderCounterNew,
          onPressed: _newCounterOrder,
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Row(children: [
              Expanded(
                child: NeuButton(
                  selected: !_showHistory,
                  minHeight: 44,
                  onPressed: () => _selectView(false),
                  child: Text(l10n.orderLive,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _showHistory
                              ? NeuColors.inkSoft
                              : NeuColors.accentDark)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NeuButton(
                  selected: _showHistory,
                  minHeight: 44,
                  onPressed: () => _selectView(true),
                  child: Text(l10n.orderHistory,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _showHistory
                              ? NeuColors.accentDark
                              : NeuColors.inkSoft)),
                ),
              ),
            ]),
          ),
          if (!_showHistory) _requestBar(l10n),
          if (!_showHistory) _bulkBar(l10n, orders),
          Expanded(
            child: orders.isEmpty

                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: NeuBox(
                        child: Text(l10n.orderEmpty,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: NeuColors.inkSoft)),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
                    itemCount: orders.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OrderCard(
                        order: orders[i],
                        onCancel: () => _cancel(orders[i]),
                        onEdit: () => _editItems(orders[i]),

                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final ShopOrder order;
  final VoidCallback onCancel;
  final VoidCallback onEdit;

  const _OrderCard(
      {required this.order, required this.onCancel, required this.onEdit});


  static (String, Color) _statusChip(BuildContext context, OrderStatus s) =>
      switch (s) {
        OrderStatus.placed => (context.l10n.orderNew, NeuColors.upi),
        OrderStatus.preparing => (context.l10n.orderPreparing, NeuColors.warn),
        OrderStatus.served => (context.l10n.orderServed, NeuColors.accentDark),
        OrderStatus.paid => (context.l10n.orderPaid, NeuColors.accentDark),
        OrderStatus.cancelled => (context.l10n.orderCancelled, NeuColors.danger),
      };

  /// Cloud payment state for a QR order, when the shop asks for money first.
  static (String, Color)? _payChip(
      BuildContext context, WidgetRef ref, ShopOrder order) {
    if (order.remoteId.isEmpty) return null;
    final state = ref.watch(orderSyncProvider).paymentStates[order.remoteId];
    return switch (state) {
      'awaiting' => (context.l10n.payStateAwaiting, NeuColors.danger),
      'paid' => (context.l10n.payStatePaid, NeuColors.accentDark),
      'due' => (context.l10n.payStateDue, NeuColors.inkSoft),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (chip, chipColor) = _statusChip(context, order.status);
    final minutes = (DateTime.now().millisecondsSinceEpoch - order.createdAt) ~/
        Duration.millisecondsPerMinute;
    final controller = ref.read(orderProvider.notifier);

    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(l10n.orderToken(order.token),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.ink)),
            const SizedBox(width: 10),
            StatusPill(chip, color: chipColor),
            if (_payChip(context, ref, order) case final pay?) ...[
              const SizedBox(width: 8),
              StatusPill(pay.$1, color: pay.$2),
            ],
            const Spacer(),
            if (order.isOpen)
              Text(l10n.orderElapsed(minutes),
                  style:
                      TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
          ]),
          const SizedBox(height: 6),
          Text(
            [
              if (order.tableLabel.isNotEmpty)
                '${l10n.orderTable} ${order.tableLabel}',
              if (order.customerName.isNotEmpty) order.customerName,
              l10n.orderItems(order.itemCount),
            ].join(' · '),
            style: TextStyle(fontSize: 13, color: NeuColors.inkSoft),
          ),
          const SizedBox(height: 8),
          for (final line in order.lines)
            Text('${line.qty} × ${line.name}',
                style: TextStyle(fontSize: 14, color: NeuColors.ink)),
          if (order.cancelReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(order.cancelReason,
                  style:
                      TextStyle(fontSize: 12, color: NeuColors.danger)),
            ),
          const SizedBox(height: 10),
          if (order.remoteId.isNotEmpty &&
              ref.watch(orderSyncProvider).paymentStates[order.remoteId] ==
                  'awaiting')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: NeuTextButton(
                  label: l10n.orderMarkPaid,
                  color: NeuColors.accentDark,
                  onPressed: () => ref
                      .read(orderSyncProvider.notifier)
                      .markPaid(order.remoteId),
                ),
              ),
            ),
          Row(children: [
            Text(money(order.subtotalPaise),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.accentDark)),
            const Spacer(),
            if (order.isOpen &&
                order.status != OrderStatus.cancelled &&
                ref.allows(Permission.takeOrder)) ...[
              NeuTextButton(label: l10n.orderEditItems, onPressed: onEdit),
              const SizedBox(width: 10),
            ],
            if (order.status == OrderStatus.placed) ...[
              PermissionGate(
                permission: Permission.changeOrderStatus,
                child: NeuTextButton(
                    label: l10n.orderCancel,
                    color: NeuColors.danger,
                    onPressed: onCancel),
              ),
              const SizedBox(width: 10),
              PermissionGate(
                permission: Permission.changeOrderStatus,
                child: NeuTextButton(
                  label: l10n.orderAccept,
                  color: NeuColors.accentDark,
                  onPressed: () =>
                      controller.setStatus(order.id, OrderStatus.preparing),
                ),
              ),
            ] else if (order.status == OrderStatus.preparing)
              PermissionGate(
                permission: Permission.changeOrderStatus,
                child: NeuTextButton(
                  label: l10n.orderServe,
                  color: NeuColors.accentDark,
                  onPressed: () =>
                      controller.setStatus(order.id, OrderStatus.served),
                ),
              )
            else if (order.status == OrderStatus.served)
              PermissionGate(
                permission: Permission.makeBill,
                child: NeuTextButton(
                  label: l10n.orderBill,
                  color: NeuColors.accentDark,
                  onPressed: () => context.push(AppRoutes.bill(order.id)),
                ),
              ),

          ]),
        ],
      ),
    );
  }
}
