import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/supabase_config.dart';
import '../domain/server_payment.dart';

/// Raised when the backend rejects or cannot serve a request.
class MerchantApiFailure implements Exception {
  final String message;
  final int? statusCode;
  const MerchantApiFailure(this.message, {this.statusCode});
  bool get isDeviceUnknown =>
      message.toLowerCase().contains('unknown device');
  @override
  String toString() => 'MerchantApiFailure($statusCode): $message';
}

class PairedMerchant {
  final String deviceKey;
  final String deviceId;
  final String merchantId;
  final String merchantName;
  final String provider;
  final String? vpa;

  const PairedMerchant({
    required this.deviceKey,
    required this.deviceId,
    required this.merchantId,
    required this.merchantName,
    required this.provider,
    this.vpa,
  });

  Map<String, dynamic> toJson() => {
        'device_key': deviceKey,
        'device_id': deviceId,
        'merchant_id': merchantId,
        'merchant_name': merchantName,
        'provider': provider,
        'vpa': vpa,
      };

  static PairedMerchant? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw.cast<Object?, Object?>();
    final key = m['device_key']?.toString();
    if (key == null || key.isEmpty) return null;
    return PairedMerchant(
      deviceKey: key,
      deviceId: m['device_id']?.toString() ?? '',
      merchantId: m['merchant_id']?.toString() ?? '',
      merchantName: m['merchant_name']?.toString() ?? '',
      provider: m['provider']?.toString() ?? 'other',
      vpa: m['vpa']?.toString(),
    );
  }
}

/// Thin client over the database RPC endpoints that back the soundbox.
class MerchantApi {
  final http.Client _client;
  MerchantApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'apikey': SupabaseConfig.anonKey,
        'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
        'Content-Type': 'application/json',
      };

  Future<Object?> _post(String fn, Map<String, dynamic> body) async {
    late final http.Response res;
    try {
      res = await _client
          .post(SupabaseConfig.rpc(fn),
              headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw MerchantApiFailure(e.toString());
    }
    if (res.statusCode >= 400) {
      String msg = res.body;
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map && decoded['message'] != null) {
          msg = decoded['message'].toString();
        }
      } on FormatException {
        // keep raw body
      }
      throw MerchantApiFailure(msg, statusCode: res.statusCode);
    }
    if (res.body.isEmpty) return null;
    try {
      return jsonDecode(res.body);
    } on FormatException {
      return null;
    }
  }

  /// Self-service merchant onboarding. The provider secret is written to a
  /// private table the app can never read back; only the pairing code returns.
  Future<String> register({
    required String businessName,
    required String provider,
    required String merchantRef,
    String? vpa,
    String? phonepeSaltKey,
    String? phonepeSaltIndex,
    String? paytmWebhookToken,
  }) async {
    final json = await _post('merchant_register', {
      'business_name': businessName,
      'provider': provider,
      'merchant_ref': merchantRef,
      'vpa': vpa,
      'phonepe_salt_key': phonepeSaltKey,
      'phonepe_salt_index': phonepeSaltIndex,
      'paytm_webhook_token': paytmWebhookToken,
    });
    final code = json is Map ? json['pairing_code']?.toString() : null;
    if (code == null || code.isEmpty) {
      throw const MerchantApiFailure('registration response was empty');
    }
    return code;
  }

  Future<PairedMerchant> pair({
    required String pairingCode,
    String label = 'Vendor phone',
    String? platform,
    String? fcmToken,
  }) async {
    final json = await _post('device_pair', {
      'pairing_code': pairingCode,
      'label': label,
      'platform': platform,
      'fcm_token': fcmToken,
    });
    final map = json is Map ? json.cast<Object?, Object?>() : null;
    final merchant = map?['merchant'];
    final merged = <String, Object?>{
      'device_key': map?['device_key'],
      'device_id': map?['device_id'],
      if (merchant is Map) ...{
        'merchant_id': merchant['id'],
        'merchant_name': merchant['name'],
        'provider': merchant['provider'],
        'vpa': merchant['vpa'],
      },
    };
    final paired = PairedMerchant.tryFromJson(merged);
    if (paired == null) {
      throw const MerchantApiFailure('pairing response was empty');
    }
    return paired;
  }

  /// Every payment this device has not yet announced, oldest first.
  Future<List<ServerPayment>> feed(String deviceKey) async {
    final json = await _post('payment_feed', {'device_key': deviceKey});
    final map = json is Map ? json.cast<Object?, Object?>() : null;
    final rows = map?['payments'];
    if (rows is! List) return const [];
    return rows
        .map(ServerPayment.tryFromJson)
        .whereType<ServerPayment>()
        .toList();
  }

  Future<void> ack(String deviceKey, List<String> paymentIds) async {
    if (paymentIds.isEmpty) return;
    await _post('payment_ack', {
      'device_key': deviceKey,
      'payment_ids': paymentIds,
    });
  }

  Future<void> heartbeat(String deviceKey, {String? fcmToken}) =>
      _post('device_heartbeat', {
        'device_key': deviceKey,
        'fcm_token': fcmToken,
      });
}
