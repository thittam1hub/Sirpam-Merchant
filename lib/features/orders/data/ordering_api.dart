/// REST client over the ordering RPCs (see docs/sql/ordering_cloud.sql).
///
/// Every call is authenticated inside the database by the shop key, so the
/// publishable anon key alone grants nothing. Failures raise
/// [OrderingApiFailure]; callers fall back to the local-only board.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/supabase_config.dart';

/// Subscription state as reported by the server.
class RemotePlan {
  final bool pro;
  final String status;
  final int periodEndMs;
  const RemotePlan({
    required this.pro,
    required this.status,
    required this.periodEndMs,
  });
}

class OrderingApiFailure implements Exception {
  final String message;
  final int? statusCode;
  const OrderingApiFailure(this.message, {this.statusCode});
  @override
  String toString() => 'OrderingApiFailure($statusCode): $message';
}

/// One order as the cloud board sees it.
class RemoteOrder {
  final String id;
  final int token;
  final String tableLabel;
  final String status;
  final String source;
  final String paymentState;
  final String customerName;
  final String customerPhone;
  final int createdAt;
  final int updatedAt;
  final List<RemoteOrderLine> lines;

  const RemoteOrder({
    required this.id,
    required this.token,
    required this.tableLabel,
    required this.status,
    required this.source,
    required this.paymentState,
    required this.customerName,
    required this.customerPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.lines,
  });

  static int _ts(Object? raw) =>
      DateTime.tryParse(raw?.toString() ?? '')?.millisecondsSinceEpoch ??
      DateTime.now().millisecondsSinceEpoch;

  static RemoteOrder? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final id = m['id']?.toString();
    if (id == null || id.isEmpty) return null;
    final items = m['items'];
    return RemoteOrder(
      id: id,
      token: (m['token'] as num?)?.toInt() ?? 0,
      tableLabel: m['table']?.toString() ?? '',
      status: m['status']?.toString() ?? 'placed',
      source: m['source']?.toString() ?? 'qr',
      paymentState: m['payment_state']?.toString() ?? 'due',
      customerName: m['name']?.toString() ?? '',
      customerPhone: m['phone']?.toString() ?? '',
      createdAt: _ts(m['created_at']),
      updatedAt: _ts(m['updated_at']),
      lines: items is List
          ? [
              for (final i in items)
                if (RemoteOrderLine.tryFromJson(i) case final l?) l,
            ]
          : const [],
    );
  }
}

class RemoteOrderLine {
  final String extId;
  final String name;
  final int pricePaise;
  final int qty;
  final String note;

  const RemoteOrderLine({
    required this.extId,
    required this.name,
    required this.pricePaise,
    required this.qty,
    required this.note,
  });

  static RemoteOrderLine? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final name = m['name']?.toString();
    if (name == null || name.isEmpty) return null;
    return RemoteOrderLine(
      extId: m['ext_id']?.toString() ?? '',
      name: name,
      pricePaise: (m['price_paise'] as num?)?.toInt() ?? 0,
      qty: (m['qty'] as num?)?.toInt() ?? 1,
      note: m['note']?.toString() ?? '',
    );
  }
}

/// A "call staff" / "bill please" tap coming from a table QR.
class ServiceRequest {
  final String id;
  final String tableLabel;
  final String kind;
  final int createdAt;

  const ServiceRequest({
    required this.id,
    required this.tableLabel,
    required this.kind,
    required this.createdAt,
  });

  bool get isBill => kind == 'request_bill';

  static ServiceRequest? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final id = m['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return ServiceRequest(
      id: id,
      tableLabel: m['table']?.toString() ?? '',
      kind: m['kind']?.toString() ?? 'call_staff',
      createdAt: DateTime.tryParse(m['created_at']?.toString() ?? '')
              ?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class OrderingApi {
  final http.Client _client;
  final Duration timeout;

  OrderingApi({http.Client? client, this.timeout = const Duration(seconds: 12)})
      : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'apikey': SupabaseConfig.anonKey,
        'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
        'Content-Type': 'application/json',
      };

  Future<Object?> _rpc(String name, Map<String, Object?> body) async {
    if (!SupabaseConfig.isConfigured) {
      throw const OrderingApiFailure('cloud not configured');
    }
    late final http.Response res;
    try {
      res = await _client
          .post(SupabaseConfig.rpc(name),
              headers: _headers, body: jsonEncode(body))
          .timeout(timeout);
    } catch (e) {
      throw OrderingApiFailure('network: $e');
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw OrderingApiFailure(res.body, statusCode: res.statusCode);
    }
    if (res.body.isEmpty) return null;
    try {
      return jsonDecode(res.body);
    } catch (_) {
      return null;
    }
  }

  /// Creates (or re-claims with the same key) the cloud shop.
  Future<String> registerShop({
    required String slug,
    required String shopKey,
    String name = '',
    double taxPercent = 0,
    String address = '',
    String phone = '',
    String gstin = '',
    String fssai = '',
    String vpa = '',
    String serviceMode = 'table',
    String payMode = 'after',
    bool allowCallStaff = true,
    bool allowRequestBill = true,
  }) async {
    final out = await _rpc('shop_register', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_name': name,
      'p_tax': taxPercent,
      'p_address': address,
      'p_phone': phone,
      'p_gstin': gstin,
      'p_fssai': fssai,
      'p_vpa': vpa,
      'p_service_mode': serviceMode,
      'p_pay_mode': payMode,
      'p_call_staff': allowCallStaff,
      'p_request_bill': allowRequestBill,
    });
    if (out is Map && out['shop_id'] != null) return out['shop_id'].toString();
    throw const OrderingApiFailure('registration failed');
  }

  /// Reads this shop's subscription state from the server. The server is the
  /// only authority; the app just caches what it says.
  Future<RemotePlan> fetchPlan({
    required String slug,
    required String shopKey,
  }) async {
    final out = await _rpc('shop_plan', {'p_slug': slug, 'p_key': shopKey});
    if (out is! Map) throw const OrderingApiFailure('plan lookup failed');
    return RemotePlan(
      pro: out['active'] == true,
      status: out['status']?.toString() ?? '',
      periodEndMs:
          DateTime.tryParse(out['period_end']?.toString() ?? '')?.millisecondsSinceEpoch ??
              0,
    );
  }

  /// Replaces the published menu with [items].
  Future<int> publishMenu({
    required String slug,
    required String shopKey,
    required List<Map<String, Object?>> items,
  }) async {
    final out = await _rpc('menu_publish', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_items': items,
    });
    return (out as num?)?.toInt() ?? 0;
  }

  /// Sold-out toggle; customers see it on their next menu poll.
  Future<bool> setAvailable({
    required String slug,
    required String shopKey,
    required String extId,
    required bool available,
  }) async {
    final out = await _rpc('menu_set_available', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_ext_id': extId,
      'p_available': available,
    });
    return out == true;
  }

  /// Orders changed since [since] (null pulls the last two days).
  Future<List<RemoteOrder>> boardFeed({
    required String slug,
    required String shopKey,
    DateTime? since,
  }) async {
    final out = await _rpc('board_feed', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_since': since?.toUtc().toIso8601String(),
    });
    if (out is! List) return const [];
    return [
      for (final row in out)
        if (RemoteOrder.tryFromJson(row) case final o?) o,
    ];
  }

  Future<bool> setStatus({
    required String slug,
    required String shopKey,
    required String remoteId,
    required String status,
    String reason = '',
  }) async {
    final out = await _rpc('order_set_status', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_order': remoteId,
      'p_status': status,
      'p_reason': reason,
    });
    return out == true;
  }

  /// Mirrors a counter order into the cloud so the board stays one truth.
  Future<String?> pushCounterOrder({
    required String slug,
    required String shopKey,
    required int token,
    required String tableLabel,
    required List<Map<String, Object?>> items,
  }) async {
    final out = await _rpc('counter_order_push', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_token': token,
      'p_table': tableLabel,
      'p_items': items,
    });
    final id = out?.toString();
    return (id == null || id.isEmpty) ? null : id;
  }

  /// Open "call staff" / "bill please" requests for this shop.
  Future<List<ServiceRequest>> serviceFeed({
    required String slug,
    required String shopKey,
  }) async {
    final out = await _rpc('service_feed', {'p_slug': slug, 'p_key': shopKey});
    if (out is! List) return const [];
    return [
      for (final row in out)
        if (ServiceRequest.tryFromJson(row) case final r?) r,
    ];
  }

  /// Clears one request once the counter has seen it.
  Future<bool> serviceRequestSeen({
    required String slug,
    required String shopKey,
    required String requestId,
  }) async {
    final out = await _rpc('service_request_seen', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_request': requestId,
    });
    return out == true;
  }

  /// Marks a cloud order paid (or back to unpaid) from the counter.
  Future<bool> setPaid({
    required String slug,
    required String shopKey,
    required String remoteId,
    bool paid = true,
  }) async {
    final out = await _rpc('order_set_paid', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_order': remoteId,
      'p_paid': paid,
    });
    return out == true;
  }

  // --- Multi-device: owner side ------------------------------------------

  /// Owner mints a single-use 6-digit code for one extra phone.
  Future<Object?> createPairingCode({
    required String slug,
    required String shopKey,
    required String label,
    required String roleHint,
  }) =>
      _rpc('shop_device_code_create', {
        'p_slug': slug,
        'p_key': shopKey,
        'p_label': label,
        'p_role_hint': roleHint,
      });

  /// Phones currently paired to this shop.
  Future<List<Object?>> listDevices({
    required String slug,
    required String shopKey,
  }) async {
    final out = await _rpc('shop_devices_list', {
      'p_slug': slug,
      'p_key': shopKey,
    });
    return out is List ? out : const [];
  }

  /// Cuts a phone off immediately; its device key stops working.
  Future<bool> revokeDevice({
    required String slug,
    required String shopKey,
    required String deviceId,
  }) async {
    final out = await _rpc('shop_device_revoke', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_device': deviceId,
    });
    return out == true;
  }

  // --- Multi-device: paired phone side ------------------------------------

  /// Exchanges a pairing code for this phone's own device key.
  Future<Object?> pairDevice({
    required String slug,
    required String code,
    required String label,
    required String roleHint,
  }) =>
      _rpc('shop_device_pair', {
        'p_slug': slug,
        'p_code': code,
        'p_label': label,
        'p_role_hint': roleHint,
      });

  /// Heartbeat that also proves the device has not been revoked.
  Future<bool> devicePing({
    required String slug,
    required String deviceKey,
  }) async {
    final out =
        await _rpc('shop_device_ping', {'p_slug': slug, 'p_device_key': deviceKey});
    return out is Map && out['ok'] == true;
  }

  Future<List<RemoteOrder>> deviceBoardFeed({
    required String slug,
    required String deviceKey,
    DateTime? since,
  }) async {
    final out = await _rpc('device_board_feed', {
      'p_slug': slug,
      'p_device_key': deviceKey,
      'p_since': since?.toUtc().toIso8601String(),
    });
    if (out is! List) return const [];
    return [
      for (final row in out)
        if (RemoteOrder.tryFromJson(row) case final o?) o,
    ];
  }

  Future<bool> deviceSetStatus({
    required String slug,
    required String deviceKey,
    required String remoteId,
    required String status,
    String reason = '',
  }) async {
    final out = await _rpc('device_order_set_status', {
      'p_slug': slug,
      'p_device_key': deviceKey,
      'p_order': remoteId,
      'p_status': status,
      'p_reason': reason,
    });
    return out == true;
  }

  Future<bool> deviceSetPaid({
    required String slug,
    required String deviceKey,
    required String remoteId,
    bool paid = true,
  }) async {
    final out = await _rpc('device_order_set_paid', {
      'p_slug': slug,
      'p_device_key': deviceKey,
      'p_order': remoteId,
      'p_paid': paid,
    });
    return out == true;
  }

  Future<List<ServiceRequest>> deviceServiceFeed({
    required String slug,
    required String deviceKey,
  }) async {
    final out = await _rpc(
        'device_service_feed', {'p_slug': slug, 'p_device_key': deviceKey});
    if (out is! List) return const [];
    return [
      for (final row in out)
        if (ServiceRequest.tryFromJson(row) case final r?) r,
    ];
  }

  Future<bool> deviceServiceRequestSeen({
    required String slug,
    required String deviceKey,
    required String requestId,
  }) async {
    final out = await _rpc('device_service_request_seen', {
      'p_slug': slug,
      'p_device_key': deviceKey,
      'p_request': requestId,
    });
    return out == true;
  }

  Future<String?> devicePushCounterOrder({
    required String slug,
    required String deviceKey,
    required int token,
    required String tableLabel,
    required List<Map<String, Object?>> items,
  }) async {
    final out = await _rpc('device_counter_order_push', {
      'p_slug': slug,
      'p_device_key': deviceKey,
      'p_token': token,
      'p_table': tableLabel,
      'p_items': items,
    });
    final id = out?.toString();
    return (id == null || id.isEmpty) ? null : id;
  }

  // --- Online backup ---------------------------------------------------------

  /// Uploads one checksummed backup bundle. The server keeps the newest seven.
  Future<int> uploadBackup({
    required String slug,
    required String shopKey,
    required String payload,
    String checksum = '',
    String label = '',
  }) async {
    final out = await _rpc('shop_backup_put', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_payload': payload,
      'p_checksum': checksum,
      'p_label': label,
    });
    if (out is! Map) throw const OrderingApiFailure('backup failed');
    return DateTime.tryParse(out['created_at']?.toString() ?? '')
            ?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
  }

  /// The newest bundle on the server. [withPayload] false is a cheap check.
  Future<CloudBackupInfo> latestBackup({
    required String slug,
    required String shopKey,
    bool withPayload = false,
  }) async {
    final out = await _rpc('shop_backup_latest', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_with_payload': withPayload,
    });
    if (out is! Map || out['found'] != true) return const CloudBackupInfo();
    return CloudBackupInfo(
      found: true,
      createdAtMs:
          DateTime.tryParse(out['created_at']?.toString() ?? '')?.millisecondsSinceEpoch ??
              0,
      sizeBytes: (out['size_bytes'] as num?)?.toInt() ?? 0,
      payload: out['payload']?.toString() ?? '',
    );
  }

  // --- Staff roles -----------------------------------------------------------

  /// Owner publishes the role list so paired phones are limited server-side.
  Future<int> publishRoles({
    required String slug,
    required String shopKey,
    required List<Map<String, Object?>> roles,
  }) async {
    final out = await _rpc('shop_roles_publish', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_roles': roles,
    });
    return (out as num?)?.toInt() ?? 0;
  }

  /// Owner points one paired phone at a published role.
  Future<bool> setDeviceRole({
    required String slug,
    required String shopKey,
    required String deviceId,
    required String roleId,
  }) async {
    final out = await _rpc('shop_device_set_role', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_device': deviceId,
      'p_role_id': roleId,
    });
    return out == true;
  }

  /// Totals for one cloud shop over the last [days] days. Owner key only —
  /// this is how an owner running two shops sees both on one screen.
  Future<Map<String, Object?>> salesRollup({
    required String slug,
    required String shopKey,
    int days = 7,
  }) async {
    final out = await _rpc('shop_sales_rollup', {
      'p_slug': slug,
      'p_key': shopKey,
      'p_days': days,
    });
    if (out is! Map) throw const OrderingApiFailure('rollup failed');
    return out.cast<String, Object?>();
  }

  /// A paired phone asks the server what it may do.
  Future<Map<String, Object?>> deviceProfile({
    required String slug,
    required String deviceKey,
  }) async {
    final out =
        await _rpc('device_profile', {'p_slug': slug, 'p_device_key': deviceKey});
    if (out is! Map) throw const OrderingApiFailure('profile failed');
    return out.cast<String, Object?>();
  }
}

/// What the server holds as the newest online backup.
class CloudBackupInfo {
  final bool found;
  final int createdAtMs;
  final int sizeBytes;
  final String payload;

  const CloudBackupInfo({
    this.found = false,
    this.createdAtMs = 0,
    this.sizeBytes = 0,
    this.payload = '',
  });
}


