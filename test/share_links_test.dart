import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/core/network/share_links.dart';

void main() {
  test('UPI deep link follows the NPCI format', () {
    final uri = ShareLinks.upiPay(
      vpa: 'vendor@upi',
      payeeName: 'Ravi Stall',
      amountRupees: 250.5,
      note: 'Udhaar',
    );
    expect(uri.scheme, 'upi');
    expect(uri.host, 'pay');
    expect(uri.queryParameters['pa'], 'vendor@upi');
    expect(uri.queryParameters['pn'], 'Ravi Stall');
    expect(uri.queryParameters['am'], '250.50');
    expect(uri.queryParameters['cu'], 'INR');
    expect(uri.queryParameters['tn'], 'Udhaar');
  });

  test('UPI note is omitted when blank', () {
    final uri = ShareLinks.upiPay(
        vpa: 'a@b', payeeName: 'A', amountRupees: 10, note: '');
    expect(uri.queryParameters.containsKey('tn'), isFalse);
  });

  test('WhatsApp link normalises Indian numbers', () {
    expect(ShareLinks.whatsapp(message: 'hi', phone: '9876543210').toString(),
        startsWith('https://wa.me/919876543210?text='));
    expect(ShareLinks.whatsapp(message: 'hi', phone: '+91 98765 43210').toString(),
        startsWith('https://wa.me/919876543210?text='));
  });

  test('WhatsApp link without a number opens the share sheet', () {
    expect(ShareLinks.whatsapp(message: 'hi').toString(),
        startsWith('https://wa.me/?text='));
  });

  test('WhatsApp message is URL encoded', () {
    final uri = ShareLinks.whatsapp(message: 'கடன் ₹100 & நன்றி');
    expect(uri.queryParameters['text'], 'கடன் ₹100 & நன்றி');
  });
}
