/// Cloud order board sync.
///
/// Polling, not sockets: a tea shop's phone drops connectivity constantly, so
/// the local board stays authoritative and the cloud is merged in on a timer.
/// Every failure is surfaced as [OrderSyncState.error] and retried; nothing is
/// lost because local orders are already persisted before we ever push.
///
/// Multi-device: the owner's phone syncs with the shop key; a paired staff
/// phone (waiter / kitchen / counter) syncs with its own device key, which
/// the owner can revoke without touching the shop key.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_controller.dart';
import '../../devices/application/device_controller.dart';
import '../../profile/application/profile_controller.dart';
import '../data/ordering_api.dart';
import '../domain/order.dart';
import '../domain/shop_config.dart';
import 'order_controller.dart';

class OrderSyncState {
  final bool enabled;
  final bool busy;
  final DateTime? lastSyncAt;
  final String error;
  final int pulled;

  /// Open "call staff" / "bill please" taps from the tables.
  final List<ServiceRequest> requests;

  /// Cloud payment state per remote order id: awaiting / due / paid.
  final Map<String, String> paymentStates;

  const OrderSyncState({
    this.enabled = false,
    this.busy = false,
    this.lastSyncAt,
    this.error = '',
    this.pulled = 0,
    this.requests = const [],
    this.paymentStates = const {},
  });

  OrderSyncState copyWith({
    bool? enabled,
    bool? busy,
    DateTime? lastSyncAt,
    String? error,
    int? pulled,
    List<ServiceRequest>? requests,
    Map<String, String>? paymentStates,
  }) =>
      OrderSyncState(
        enabled: enabled ?? this.enabled,
        busy: busy ?? this.busy,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        error: error ?? this.error,
        pulled: pulled ?? this.pulled,
        requests: requests ?? this.requests,
        paymentStates: paymentStates ?? this.paymentStates,
      );

  /// Warn the vendor when the board has gone quiet for too long.
  bool get stale =>
      enabled &&
      (lastSyncAt == null ||
          DateTime.now().difference(lastSyncAt!) > const Duration(minutes: 2));
}

final orderingApiProvider = Provider<OrderingApi>((ref) => OrderingApi());

String orderStatusWire(OrderStatus s) => switch (s) {
      OrderStatus.placed => 'placed',
      OrderStatus.preparing => 'preparing',
      OrderStatus.served => 'served',
      OrderStatus.paid => 'paid',
      OrderStatus.cancelled => 'cancelled',
    };

/// Which credential this phone syncs with.
typedef SyncCreds = ({String slug, String ownerKey, String deviceKey});

class OrderSyncController extends Notifier<OrderSyncState> {
  Timer? _timer;
  DateTime? _since;
  Map<String, OrderStatus> _pushed = {};

  /// Owner phone → shop key; paired staff phone → its own device key.
  SyncCreds? get _creds {
    final link = ref.read(deviceProvider).link;
    if (link.paired) {
      return (slug: link.slug, ownerKey: '', deviceKey: link.deviceKey);
    }
    final shop = ref.read(shopConfigProvider);
    if (shop.cloudReady) {
      return (slug: shop.slug, ownerKey: shop.shopKey, deviceKey: '');
    }
    return null;
  }

  bool get _byDevice => ref.read(deviceProvider).link.paired;

  bool get _ready =>
      ref.read(shopConfigProvider).cloudReady ||
      ref.read(deviceProvider).paired;

  @override
  OrderSyncState build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen<ShopConfig>(shopConfigProvider, (_, next) {
      _apply(next.cloudReady || ref.read(deviceProvider).paired);
    });
    // Pairing or unpairing a staff phone starts/stops sync too.
    ref.listen<DeviceState>(deviceProvider, (_, next) {
      _apply(next.paired || ref.read(shopConfigProvider).cloudReady);
    });
    // Push local status moves for orders that exist in the cloud.
    ref.listen<OrderState>(orderProvider, (prev, next) {
      if (!state.enabled) return;
      unawaited(_pushStatuses(next));
    });
    final ready = _ready;
    Future.microtask(() => _apply(ready));
    return OrderSyncState(enabled: ready);
  }

  void _apply(bool ready) {
    _timer?.cancel();
    if (!ready) {
      state = state.copyWith(enabled: false);
      return;
    }
    state = state.copyWith(enabled: true);
    _timer = Timer.periodic(const Duration(seconds: 8), (_) => unawaited(pull()));
    unawaited(pull());
  }

  /// Pulls the board feed and merges it into the local orders.
  Future<void> pull() async {
    final creds = _creds;
    if (creds == null || state.busy) return;
    state = state.copyWith(busy: true);
    try {
      final api = ref.read(orderingApiProvider);
      final rows = _byDevice
          ? await api.deviceBoardFeed(
              slug: creds.slug, deviceKey: creds.deviceKey, since: _since)
          : await api.boardFeed(
              slug: creds.slug, shopKey: creds.ownerKey, since: _since);
      final pulled = await ref.read(orderProvider.notifier).ingestRemote(rows);
      final states = {...state.paymentStates};
      for (final r in rows) {
        states[r.id] = r.paymentState;
      }
      final requests = _byDevice
          ? await api.deviceServiceFeed(
              slug: creds.slug, deviceKey: creds.deviceKey)
          : await api.serviceFeed(slug: creds.slug, shopKey: creds.ownerKey);
      state = state.copyWith(paymentStates: states, requests: requests);
      _since = DateTime.now().toUtc().subtract(const Duration(seconds: 20));
      state = state.copyWith(
          busy: false, lastSyncAt: DateTime.now(), error: '', pulled: pulled);
      // Offline replay: anything that failed to reach the cloud earlier
      // (counter orders, status moves) is retried on every successful tick.
      await _replayCounterOrders();
      await _pushStatuses(ref.read(orderProvider));
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      // The owner cut this phone off: stop hammering the server and surface
      // it on the board until the device is unpaired locally.
      if (_byDevice && e.message.contains('device revoked')) {
        _timer?.cancel();
        state = state.copyWith(enabled: false);
      }
    } catch (e) {
      state = state.copyWith(busy: false, error: '$e');
    }
  }

  Future<void> _pushStatuses(OrderState orders) async {
    final creds = _creds;
    if (creds == null) return;
    final api = ref.read(orderingApiProvider);
    final next = <String, OrderStatus>{};
    for (final o in orders.orders) {
      if (o.remoteId.isEmpty) continue;
      next[o.remoteId] = o.status;
      if (_pushed[o.remoteId] == o.status) continue;
      try {
        if (_byDevice) {
          await api.deviceSetStatus(
            slug: creds.slug,
            deviceKey: creds.deviceKey,
            remoteId: o.remoteId,
            status: orderStatusWire(o.status),
            reason: o.cancelReason,
          );
        } else {
          await api.setStatus(
            slug: creds.slug,
            shopKey: creds.ownerKey,
            remoteId: o.remoteId,
            status: orderStatusWire(o.status),
            reason: o.cancelReason,
          );
        }
      } on OrderingApiFailure catch (e) {
        state = state.copyWith(error: e.message);
        return; // retry on the next change / poll
      }
    }
    _pushed = next;
  }

  /// Counter orders taken while the phone was offline still have no cloud row;
  /// push the open ones so the board and the QR menu agree again.
  Future<void> _replayCounterOrders() async {
    final open = [
      for (final o in ref.read(orderProvider).orders)
        if (o.remoteId.isEmpty &&
            o.source == OrderSource.counter &&
            o.status != OrderStatus.cancelled &&
            o.status != OrderStatus.paid)
          o,
    ];
    for (final o in open) {
      await pushCounterOrder(o);
    }
  }

  /// Mirrors a counter order into the cloud board so both views agree.
  Future<void> pushCounterOrder(ShopOrder order) async {
    final creds = _creds;
    if (creds == null || order.remoteId.isNotEmpty) return;
    final items = [
      for (final l in order.lines)
        {
          'ext_id': l.productId,
          'name': l.name,
          'price_paise': l.pricePaise,
          'qty': l.qty,
          'note': l.note,
        },
    ];
    try {
      final id = _byDevice
          ? await ref.read(orderingApiProvider).devicePushCounterOrder(
                slug: creds.slug,
                deviceKey: creds.deviceKey,
                token: order.token,
                tableLabel: order.tableLabel,
                items: items,
              )
          : await ref.read(orderingApiProvider).pushCounterOrder(
                slug: creds.slug,
                shopKey: creds.ownerKey,
                token: order.token,
                tableLabel: order.tableLabel,
                items: items,
              );
      if (id != null) {
        await ref.read(orderProvider.notifier).attachRemoteId(order.id, id);
      }
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Owner one-tap cloud setup: claims the shop name on the server with a
  /// private key and turns live sync on. Re-running with the same key simply
  /// re-claims the same shop.
  Future<void> createCloudShop({
    required String slug,
    required String shopKey,
  }) async {
    final shopCtl = ref.read(shopConfigProvider.notifier);
    await shopCtl.save(ref.read(shopConfigProvider).copyWith(
          slug: slug,
          shopKey: shopKey,
          cloudSync: true,
        ));
    final shop = ref.read(shopConfigProvider);
    final settings = ref.read(settingsProvider);
    final profile = ref.read(profileProvider);
    final id = await ref.read(orderingApiProvider).registerShop(
          slug: shop.slug,
          shopKey: shop.shopKey,
          name: shop.shopName.isNotEmpty
              ? shop.shopName
              : (settings.stallName.isEmpty ? shop.slug : settings.stallName),
          taxPercent: shop.taxPercent,
          address: shop.address.isEmpty
              ? [profile.marketArea, profile.taluk, profile.district]
                  .where((v) => v.isNotEmpty)
                  .join(', ')
              : shop.address,
          phone: shop.phone,
          gstin: shop.gstin,
          fssai: shop.fssai.isEmpty ? profile.fssaiNumber : shop.fssai,
          vpa: settings.upiVpa,
          serviceMode: shop.serviceMode,
          payMode: shop.payMode,
          allowCallStaff: shop.allowCallStaff,
          allowRequestBill: shop.allowRequestBill,
        );
    await shopCtl.save(ref.read(shopConfigProvider).copyWith(remoteShopId: id));
    state = state.copyWith(error: '', lastSyncAt: DateTime.now());
  }

  /// Registers (or re-claims) the shop and publishes the menu in one step.
  /// Owner phone only — a paired staff phone has no shop key.
  Future<int> publish(List<Map<String, Object?>> items) async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) {
      throw const OrderingApiFailure('shop slug and key required');
    }
    final api = ref.read(orderingApiProvider);
    final profile = ref.read(profileProvider);
    final settings = ref.read(settingsProvider);
    final id = await api.registerShop(
      slug: shop.slug,
      shopKey: shop.shopKey,
      name: shop.shopName.isNotEmpty
          ? shop.shopName
          : (settings.stallName.isEmpty ? shop.slug : settings.stallName),
      taxPercent: shop.taxPercent,
      address: shop.address.isEmpty
          ? [profile.marketArea, profile.taluk, profile.district]
              .where((v) => v.isNotEmpty)
              .join(', ')
          : shop.address,
      phone: shop.phone,
      gstin: shop.gstin,
      fssai: shop.fssai.isEmpty ? profile.fssaiNumber : shop.fssai,
      vpa: settings.upiVpa,
      serviceMode: shop.serviceMode,
      payMode: shop.payMode,
      allowCallStaff: shop.allowCallStaff,
      allowRequestBill: shop.allowRequestBill,
    );
    await ref.read(shopConfigProvider.notifier).save(
          shop.copyWith(remoteShopId: id),
        );
    final count =
        await api.publishMenu(slug: shop.slug, shopKey: shop.shopKey, items: items);
    state = state.copyWith(error: '', lastSyncAt: DateTime.now());
    return count;
  }

  /// Pushes the merchant's ordering rules so every table QR obeys them.
  Future<void> pushShopRules() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return;
    final settings = ref.read(settingsProvider);
    try {
      await ref.read(orderingApiProvider).registerShop(
            slug: shop.slug,
            shopKey: shop.shopKey,
            name: shop.shopName.isNotEmpty ? shop.shopName : settings.stallName,
            taxPercent: shop.taxPercent,
            address: shop.address,
            phone: shop.phone,
            gstin: shop.gstin,
            fssai: shop.fssai,
            vpa: settings.upiVpa,
            serviceMode: shop.serviceMode,
            payMode: shop.payMode,
            allowCallStaff: shop.allowCallStaff,
            allowRequestBill: shop.allowRequestBill,
          );
      state = state.copyWith(error: '');
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Counter has seen a table's request; clear it from the board.
  Future<void> clearRequest(String requestId) async {
    final creds = _creds;
    if (creds == null) return;
    state = state.copyWith(requests: [
      for (final r in state.requests)
        if (r.id != requestId) r,
    ]);
    try {
      if (_byDevice) {
        await ref.read(orderingApiProvider).deviceServiceRequestSeen(
              slug: creds.slug,
              deviceKey: creds.deviceKey,
              requestId: requestId,
            );
      } else {
        await ref.read(orderingApiProvider).serviceRequestSeen(
              slug: creds.slug,
              shopKey: creds.ownerKey,
              requestId: requestId,
            );
      }
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Marks a QR order as paid at the counter.
  Future<void> markPaid(String remoteId, {bool paid = true}) async {
    final creds = _creds;
    if (creds == null || remoteId.isEmpty) return;
    state = state.copyWith(paymentStates: {
      ...state.paymentStates,
      remoteId: paid ? 'paid' : 'due',
    });
    try {
      if (_byDevice) {
        await ref.read(orderingApiProvider).deviceSetPaid(
              slug: creds.slug,
              deviceKey: creds.deviceKey,
              remoteId: remoteId,
              paid: paid,
            );
      } else {
        await ref.read(orderingApiProvider).setPaid(
              slug: creds.slug,
              shopKey: creds.ownerKey,
              remoteId: remoteId,
              paid: paid,
            );
      }
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Sold-out toggle pushed to the customer menu. Owner phone only.
  Future<void> pushAvailability(String productId, bool available) async {
    final shop = ref.read(shopConfigProvider);
    if (_byDevice || !shop.cloudReady || productId.isEmpty) return;
    try {
      await ref.read(orderingApiProvider).setAvailable(
            slug: shop.slug,
            shopKey: shop.shopKey,
            extId: productId,
            available: available,
          );
    } on OrderingApiFailure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }
}

final orderSyncProvider =
    NotifierProvider<OrderSyncController, OrderSyncState>(
        OrderSyncController.new);
