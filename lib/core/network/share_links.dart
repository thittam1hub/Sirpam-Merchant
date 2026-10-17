/// Deterministic UPI / WhatsApp deep-link builders (NPCI + wa.me formats).
class ShareLinks {
  /// upi://pay?pa={vpa}&pn={name}&am={amount}&cu=INR
  static Uri upiPay({
    required String vpa,
    required String payeeName,
    required double amountRupees,
    String? note,
  }) {
    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': vpa,
        'pn': payeeName,
        'am': amountRupees.toStringAsFixed(2),
        'cu': 'INR',
        if (note != null && note.isNotEmpty) 'tn': note,
      },
    );
  }

  /// Collection QR payload. With no [amountRupees] the payer types the amount
  /// (a "static" stall QR); with one it becomes a dynamic request.
  static Uri upiCollect({
    required String vpa,
    required String payeeName,
    double? amountRupees,
    String? note,
  }) {
    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': vpa,
        'pn': payeeName,
        if (amountRupees != null && amountRupees > 0)
          'am': amountRupees.toStringAsFixed(2),
        'cu': 'INR',
        if (note != null && note.isNotEmpty) 'tn': note,
      },
    );
  }


  /// wa.me link; [phone] may be blank to open the WhatsApp share sheet.
  static Uri whatsapp({required String message, String phone = ''}) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final normalized = digits.isEmpty
        ? ''
        : (digits.length == 10 ? '91$digits' : digits);
    return Uri.parse(
        'https://wa.me/$normalized?text=${Uri.encodeComponent(message)}');
  }
}
