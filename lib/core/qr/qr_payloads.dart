/// Every QR the shop prints or shows, built in one pure place so the payload
/// that goes on paper is the same one the app can read back with the camera.
///
/// Deliberately static: no tracking parameters, no rotating tokens, nothing
/// that stops working when the stall has no signal.
library;

import '../network/share_links.dart';

const String kDefaultQrBase = 'https://sirpam.app';

/// Trims a trailing slash and falls back to the hosted build.
String qrBase(String raw) {
  final v = raw.trim().isEmpty ? kDefaultQrBase : raw.trim();
  return v.endsWith('/') ? v.substring(0, v.length - 1) : v;
}

class QrPayloads {
  const QrPayloads._();

  /// Counter / bill payment QR — any UPI app can scan it.
  /// A null [amountRupees] keeps it a static stall QR.
  static String upi({
    required String vpa,
    required String payeeName,
    double? amountRupees,
    String note = '',
  }) =>
      ShareLinks.upiCollect(
        vpa: vpa,
        payeeName: payeeName,
        amountRupees: amountRupees,
        note: note,
      ).toString();

  /// Table / counter menu. Table 0 is the counter code.
  static String menu({
    required String baseUrl,
    required String slug,
    int table = 0,
  }) {
    final shop = slug.trim().isEmpty ? 'shop' : slug.trim();
    final base = '${qrBase(baseUrl)}/m/$shop';
    return table <= 0 ? base : '$base?t=$table';
  }

  /// Offer / loyalty card the customer keeps. Everything the claim page shows
  /// travels in the link, so it opens even when the shop is offline.
  static String offer({
    required String baseUrl,
    required String shopName,
    required String title,
    String code = '',
    String detail = '',
  }) =>
      Uri.parse('${qrBase(baseUrl)}/m/offer.html').replace(queryParameters: {
        'n': shopName,
        'o': title,
        if (code.trim().isNotEmpty) 'c': code.trim().toUpperCase(),
        if (detail.trim().isNotEmpty) 'd': detail.trim(),
      }).toString();

  /// Printed product label: the shop's own code, scanned back at the counter.
  static String product(String code) => code.trim();

  /// Staff pairing. The QR carries the shop and the six-digit code so the new
  /// phone types nothing.
  static String pairing({
    required String slug,
    required String code,
    String role = '',
  }) =>
      Uri.parse('vendoros://pair').replace(queryParameters: {
        's': slug.trim(),
        'c': code.trim(),
        if (role.trim().isNotEmpty) 'r': role.trim(),
      }).toString();

  /// Reads a pairing QR back. Returns null for anything that is not one.
  static PairingScan? parsePairing(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return null;
    final isPair = uri.scheme == 'vendoros' && uri.host == 'pair';
    if (!isPair) return null;
    final slug = uri.queryParameters['s']?.trim() ?? '';
    final code = uri.queryParameters['c']?.trim() ?? '';
    if (slug.isEmpty || code.length != 6) return null;
    return PairingScan(
        slug: slug, code: code, role: uri.queryParameters['r']?.trim() ?? '');
  }
}

class PairingScan {
  final String slug;
  final String code;
  final String role;
  const PairingScan(
      {required this.slug, required this.code, this.role = ''});
}
