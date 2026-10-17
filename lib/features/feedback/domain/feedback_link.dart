/// Builds the link behind the feedback QR that sits on the counter or gets
/// printed on the bill. The page it opens is static: happy customers are sent
/// to the public review page, everyone else reaches the owner on WhatsApp, so
/// no complaint is ever published by accident.
library;

String feedbackUrl({
  required String baseUrl,
  required String shopName,
  String phone = '',
  String reviewUrl = '',
}) {
  final raw = baseUrl.trim().isEmpty ? 'https://sirpam.app' : baseUrl.trim();
  final base = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
  return Uri.parse('$base/m/feedback.html').replace(queryParameters: {
    'n': shopName,
    if (phone.trim().isNotEmpty) 'p': phone.trim(),
    if (reviewUrl.trim().isNotEmpty) 'r': reviewUrl.trim(),
  }).toString();
}
