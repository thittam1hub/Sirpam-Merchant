import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../billing/domain/bill.dart';
import '../../billing/domain/tax.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../../products/application/inventory_controller.dart';
import '../data/ordering_api.dart';
import '../domain/order.dart';
import '../domain/shop_config.dart';

class OrderState {
  final List<ShopOrder> orders;
  final List<Bill> bills;
  final bool loaded;

  const OrderState({
    this.orders = const [],
    this.bills = const [],
    this.loaded = false,
  });

  OrderState copyWith({List<ShopOrder>? orders, List<Bill>? bills}) =>
      OrderState(
        orders: orders ?? this.orders,
        bills: bills ?? this.bills,
        loaded: true,
      );

  List<ShopOrder> byStatus(OrderStatus status) =>
      orders.where((o) => o.status == status).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<ShopOrder> get openOrders => orders.where((o) => o.isOpen).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  /// Orders that still need cooking — the kitchen ticket view.
  List<ShopOrder> get kitchenQueue => orders
      .where((o) =>
          o.status == OrderStatus.placed || o.status == OrderStatus.preparing)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Iterable<ShopOrder> ordersOn(String day) => orders.where((o) =>
      dayKey(DateTime.fromMillisecondsSinceEpoch(o.createdAt)) == day);

  Iterable<Bill> billsOn(String day) =>
      bills.where((b) => b.day == day && !b.voided);

  ShopOrder? orderById(String id) =>
      orders.where((o) => o.id == id).cast<ShopOrder?>().firstWhere(
            (o) => true,
            orElse: () => null,
          );

  Bill? billById(String id) => bills
      .where((b) => b.id == id)
      .cast<Bill?>()
      .firstWhere((b) => true, orElse: () => null);
}

/// Summary of a trading day's orders, used by day close and insights.
class OrderDaySummary {
  final int taken;
  final int cancelled;
  final int openCount;
  final int billedPaise;
  final int averageTicketPaise;
  final int discountPaise;
  final int taxPaise;
  final int voidedCount;
  final int lastToken;

  /// Money collected per tender across the day's bills (split tenders count
  /// once per leg), used by day close to reconcile the cash box.
  final int cashPaise;
  final int upiPaise;
  final int creditPaise;

  const OrderDaySummary({
    required this.taken,
    required this.cancelled,
    required this.openCount,
    required this.billedPaise,
    required this.averageTicketPaise,
    this.discountPaise = 0,
    this.taxPaise = 0,
    this.voidedCount = 0,
    this.lastToken = 0,
    this.cashPaise = 0,
    this.upiPaise = 0,
    this.creditPaise = 0,
  });
}

class OrderController extends Notifier<OrderState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  OrderState build() {
    final orders = _store
        .readOrders()
        .map(ShopOrder.tryFromJson)
        .whereType<ShopOrder>()
        .toList();
    final bills =
        _store.readBills().map(Bill.tryFromJson).whereType<Bill>().toList();
    return OrderState(orders: orders, bills: bills, loaded: true);
  }

  int get _now => DateTime.now().millisecondsSinceEpoch;

  String _id(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  Future<void> _persistOrders() => guardWrite(
      ref, () => _store.writeOrders([for (final o in state.orders) o.toJson()]));

  Future<void> _persistBills() => guardWrite(
      ref, () => _store.writeBills([for (final b in state.bills) b.toJson()]));

  Future<ShopOrder> placeOrder({
    required List<OrderLine> lines,
    String tableLabel = '',
    String customerName = '',
    String customerPhone = '',
    OrderSource source = OrderSource.counter,
  }) async {
    final now = DateTime.now();
    final order = ShopOrder(
      id: _id('o'),
      token: nextToken(state.orders, dayKey(now)),
      lines: lines,
      createdAt: now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
      tableLabel: tableLabel,
      customerName: customerName,
      customerPhone: customerPhone,
      source: source,
    );
    state = state.copyWith(orders: [order, ...state.orders]);
    await _persistOrders();
    return order;
  }

  /// Board move. Illegal transitions are refused rather than silently applied.
  ///
  /// Moving to Served is the fulfilment point: that is when the food actually
  /// leaves the counter, so that is when FIFO stock is taken out.
  Future<bool> setStatus(String orderId, OrderStatus next,
      {String reason = ''}) async {
    final order = state.orderById(orderId);
    if (order == null || !canTransition(order.status, next)) return false;
    var updated = order.copyWith(status: next, cancelReason: reason);
    if (next == OrderStatus.served && !order.stockDeducted) {
      await _deductStock(order, reference: order.id);
      updated = updated.copyWith(stockDeducted: true);
    }
    _replace(updated);
    await _persistOrders();
    return true;
  }

  /// FIFO batch consumption for every line that maps to a catalogue product.
  Future<void> _deductStock(ShopOrder order, {required String reference}) async {
    final inventory = ref.read(inventoryProvider.notifier);
    for (final line in order.lines) {
      if (line.productId.isEmpty || line.qty <= 0) continue;
      await inventory.sellStock(
        productId: line.productId,
        qtyMilli: line.qty * 1000,
        revenuePaise: line.totalPaise,
        saleId: reference,
      );
    }
  }

  /// Merges cloud board rows into the local board.
  ///
  /// Remote rows are the source of truth for QR orders that the vendor has not
  /// finished locally; an order already paid or cancelled here is never pulled
  /// backwards, so a slow feed can't resurrect settled work.
  Future<int> ingestRemote(List<RemoteOrder> remotes) async {
    if (remotes.isEmpty) return 0;
    final byRemote = {
      for (final o in state.orders)
        if (o.remoteId.isNotEmpty) o.remoteId: o,
    };
    final added = <ShopOrder>[];
    var changed = 0;
    for (final r in remotes) {
      final lines = [
        for (final l in r.lines)
          OrderLine(
            productId: l.extId,
            name: l.name,
            pricePaise: l.pricePaise,
            qty: l.qty,
            note: l.note,
          ),
      ];
      if (lines.isEmpty) continue;
      final status = orderStatusFrom(r.status);
      final existing = byRemote[r.id];
      if (existing == null) {
        added.add(ShopOrder(
          id: 'r-${r.id}',
          token: r.token,
          lines: lines,
          createdAt: r.createdAt,
          updatedAt: r.updatedAt,
          tableLabel: r.tableLabel,
          status: status,
          source: orderSourceFrom(r.source),
          customerName: r.customerName,
          customerPhone: r.customerPhone,
          remoteId: r.id,
        ));
        changed++;
        continue;
      }
      if (!existing.isOpen) continue;
      if (existing.status == status && existing.lines.length == lines.length) {
        continue;
      }
      _replace(existing.copyWith(
        status: canTransition(existing.status, status) ? status : null,
        lines: existing.status == OrderStatus.placed ? lines : null,
      ));
      changed++;
    }
    if (added.isNotEmpty) {
      state = state.copyWith(orders: [...added.reversed, ...state.orders]);
    }
    if (changed > 0) await _persistOrders();
    return changed;
  }

  /// Records the cloud row id for an order mirrored to the board.
  Future<void> attachRemoteId(String orderId, String remoteId) async {
    final order = state.orderById(orderId);
    if (order == null || remoteId.isEmpty || order.remoteId == remoteId) return;
    _replace(order.copyWith(remoteId: remoteId));
    await _persistOrders();
  }

  Future<void> updateLines(String orderId, List<OrderLine> lines) async {
    final order = state.orderById(orderId);
    if (order == null || !order.isOpen) return;
    _replace(order.copyWith(lines: lines));
    await _persistOrders();
  }

  /// Merges [fromId] into [intoId] — two customers on the same table paying
  /// together. The source order is cancelled with a merge note.
  Future<void> mergeOrders(String fromId, String intoId) async {
    final from = state.orderById(fromId);
    final into = state.orderById(intoId);
    if (from == null || into == null || from.id == into.id) return;
    if (!from.isOpen || !into.isOpen) return;
    _replace(into.copyWith(lines: [...into.lines, ...from.lines]));
    _replace(from.copyWith(
        status: OrderStatus.cancelled, cancelReason: 'merged:${into.token}'));
    await _persistOrders();
  }

  void _replace(ShopOrder order) {
    state = state.copyWith(orders: [
      for (final o in state.orders) if (o.id == order.id) order else o,
    ]);
  }

  /// Settles an order: writes the bill, one ledger sale per tender, one FIFO
  /// stock movement per line, and marks the order paid. This is the single
  /// place money enters the books from the order board.
  Future<Bill> settle({
    required String orderId,
    int discountFlatPaise = 0,
    double discountPercent = 0,
    double taxPercent = 0,
    bool roundToRupee = true,
    required List<BillPayment> payments,
    String customer = '',
    TaxBreakdown? breakdown,
    bool taxIncluded = true,
  }) async {
    final order = state.orderById(orderId);
    if (order == null) throw StateError('unknown order $orderId');
    final slabs = breakdown?.slabs ?? const <TaxSlab>[];
    final totals = slabs.isEmpty
        ? BillMath.compute(
            subtotalPaise: order.subtotalPaise,
            discountFlatPaise: discountFlatPaise,
            discountPercent: discountPercent,
            taxPercent: taxPercent,
            roundToRupee: roundToRupee,
          )
        : BillMath.computeWithTax(
            subtotalPaise: order.subtotalPaise,
            discountFlatPaise: discountFlatPaise,
            discountPercent: discountPercent,
            taxPaise: breakdown!.taxPaise,
            taxIncluded: taxIncluded,
            roundToRupee: roundToRupee,
          );
    final now = DateTime.now();
    final day = dayKey(now);
    final sequence = nextBillSequence(state.bills, day);
    final bill = Bill(
      id: _id('b'),
      orderId: order.id,
      number: BillMath.number(day, sequence),
      day: day,
      sequence: sequence,
      ts: now.millisecondsSinceEpoch,
      customer: customer.isEmpty ? order.customerName : customer,
      subtotalPaise: totals.subtotalPaise,
      discountPaise: totals.discountPaise,
      taxPaise: totals.taxPaise,
      taxPercent: taxPercent,
      roundingPaise: totals.roundingPaise,
      totalPaise: totals.totalPaise,
      payments: payments,
      slabs: slabs,
      taxIncluded: taxIncluded,
      audit: [BillAudit(ts: now.millisecondsSinceEpoch, action: 'settle')],
    );

    final ledger = ref.read(ledgerProvider.notifier);
    final itemLabel = order.lines.isEmpty
        ? bill.number
        : '${order.lines.first.name}${order.lines.length > 1 ? ' +${order.lines.length - 1}' : ''}';
    for (final p in payments) {
      if (p.amountPaise <= 0) continue;
      await ledger.addSale(
        amountPaise: p.amountPaise,
        mode: p.mode,
        item: itemLabel,
        customer: p.mode == SaleMode.credit
            ? (bill.customer.isEmpty ? 'Walk-in' : bill.customer)
            : null,
        billRef: bill.id,
      );
    }

    // Orders billed straight from Placed never passed through Served, so the
    // stock still has to come out — exactly once.
    if (!order.stockDeducted) await _deductStock(order, reference: bill.id);

    state = state.copyWith(bills: [bill, ...state.bills], orders: [
      for (final o in state.orders)
        if (o.id == order.id)
          o.copyWith(
              status: OrderStatus.paid,
              billId: bill.id,
              stockDeducted: true,
              updatedAt: _now)
        else
          o,
    ]);
    await _persistBills();
    await _persistOrders();
    return bill;
  }

  /// Open orders whose rounded total matches a confirmed UPI amount.
  List<ShopOrder> matchingOpenOrders(int amountPaise) => [
        for (final o in state.openOrders)
          if (o.lines.isNotEmpty &&
              BillMath.compute(
                    subtotalPaise: o.subtotalPaise,
                    roundToRupee: true,
                  ).totalPaise ==
                  amountPaise)
            o,
      ];

  /// A server-confirmed UPI payment landed. If exactly one open order matches
  /// the amount, close it as a UPI bill so the board, the ledger and the stock
  /// all agree. Ambiguous or unmatched amounts are left to the vendor.
  Future<Bill?> settleFromUpiPayment(int amountPaise) async {
    if (amountPaise <= 0) return null;
    final matches = matchingOpenOrders(amountPaise);
    if (matches.length != 1) return null;
    return settle(
      orderId: matches.first.id,
      payments: [BillPayment(mode: SaleMode.upi, amountPaise: amountPaise)],
    );
  }



  /// Voids a bill with a mandatory reason. The bill row survives (numbers are
  /// never reused) and the ledger rows it created are reversed so the day's
  /// takings, credit balances and cash reconciliation stay truthful.
  Future<bool> voidBill(String billId, String reason) async {
    final bill = state.billById(billId);
    if (bill == null || bill.voided || reason.trim().isEmpty) return false;
    await ref.read(ledgerProvider.notifier).reverseBill(bill.id);
    _updateBill(
      billId,
      (b) => b.copyWith(
        voided: true,
        voidReason: reason.trim(),
        audit: [
          ...b.audit,
          BillAudit(ts: _now, action: 'void', reason: reason.trim()),
        ],
      ),
    );
    await _persistBills();
    return true;
  }

  /// Records a print of the bill. [reprint] bumps the counter and writes the
  /// reason into the trail; [target] is the transport the paper went to.
  Future<void> recordPrint(
    String billId, {
    bool reprint = false,
    String reason = '',
    String target = '',
  }) async {
    final bill = state.billById(billId);
    if (bill == null) return;
    _updateBill(
      billId,
      (b) => b.copyWith(
        reprintCount: reprint ? b.reprintCount + 1 : b.reprintCount,
        audit: [
          ...b.audit,
          BillAudit(
            ts: _now,
            action: reprint ? 'reprint' : 'print',
            reason: reason,
            target: target,
          ),
        ],
      ),
    );
    await _persistBills();
  }

  void _updateBill(String billId, Bill Function(Bill) update) {
    state = state.copyWith(bills: [
      for (final b in state.bills)
        if (b.id == billId) update(b) else b,
    ]);
  }

  OrderDaySummary summaryFor(String day) {
    final dayOrders = state.ordersOn(day).toList();
    final bills = state.billsOn(day).toList();
    final billed = bills.fold(0, (a, b) => a + b.totalPaise);
    var cash = 0, upi = 0, credit = 0;
    for (final b in bills) {
      for (final p in b.payments) {
        switch (p.mode) {
          case SaleMode.cash:
            cash += p.amountPaise;
          case SaleMode.upi:
            upi += p.amountPaise;
          case SaleMode.credit:
            credit += p.amountPaise;
        }
      }
    }
    final paidCount =
        dayOrders.where((o) => o.status == OrderStatus.paid).length;
    return OrderDaySummary(
      taken: dayOrders.length,
      cancelled:
          dayOrders.where((o) => o.status == OrderStatus.cancelled).length,
      openCount: dayOrders.where((o) => o.isOpen).length,
      billedPaise: billed,
      averageTicketPaise: paidCount == 0 ? 0 : billed ~/ paidCount,
      discountPaise: bills.fold(0, (a, b) => a + b.discountPaise),
      taxPaise: bills.fold(0, (a, b) => a + b.taxPaise),
      voidedCount: state.bills.where((b) => b.day == day && b.voided).length,
      lastToken: dayOrders.fold(0, (a, o) => o.token > a ? o.token : a),
      cashPaise: cash,
      upiPaise: upi,
      creditPaise: credit,
    );
  }
}

final orderProvider =
    NotifierProvider<OrderController, OrderState>(OrderController.new);

class ShopConfigController extends Notifier<ShopConfig> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  ShopConfig build() {
    final raw = _store.readShop();
    return raw == null ? const ShopConfig() : ShopConfig.fromJson(raw);
  }

  Future<void> save(ShopConfig config) async {
    state = config;
    await guardWrite(ref, () => _store.writeShop(config.toJson()));
  }

  Future<void> togglePublished(String productId, bool published) async {
    final ids = {...state.publishedIds};
    if (published) {
      ids.add(productId);
    } else {
      ids.remove(productId);
    }
    await save(state.copyWith(publishedIds: ids.toList()));
  }

  Future<void> toggleSoldOut(String productId, bool soldOut) async {
    final ids = {...state.soldOutIds};
    if (soldOut) {
      ids.add(productId);
    } else {
      ids.remove(productId);
    }
    await save(state.copyWith(soldOutIds: ids.toList()));
  }
}

final shopConfigProvider =
    NotifierProvider<ShopConfigController, ShopConfig>(ShopConfigController.new);
