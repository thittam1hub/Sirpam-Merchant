import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/core/qr/qr_payloads.dart';
import 'package:vendoros/features/printing/domain/escpos.dart';
import 'package:vendoros/features/printing/domain/receipt.dart';

void main() {
  group('QR payloads', () {
    test('menu link matches the hosted shop path', () {
      expect(QrPayloads.menu(baseUrl: 'https://shop.app/', slug: 'ravi'),
          'https://shop.app/m/ravi');
      expect(QrPayloads.menu(baseUrl: '', slug: 'ravi', table: 4),
          'https://sirpam.app/m/ravi?t=4');
    });

    test('offer card carries everything the claim page shows', () {
      final url = QrPayloads.offer(
        baseUrl: 'https://shop.app',
        shopName: 'Ravi Tea',
        title: 'Evening 10% off',
        code: 'tea10',
        detail: '10%',
      );
      final uri = Uri.parse(url);
      expect(uri.path, '/m/offer.html');
      expect(uri.queryParameters['n'], 'Ravi Tea');
      expect(uri.queryParameters['o'], 'Evening 10% off');
      expect(uri.queryParameters['c'], 'TEA10');
      expect(uri.queryParameters['d'], '10%');
    });

    test('pairing QR round-trips shop, code and role', () {
      final raw =
          QrPayloads.pairing(slug: 'ravi', code: '123456', role: 'waiter');
      final scan = QrPayloads.parsePairing(raw);
      expect(scan, isNotNull);
      expect(scan!.slug, 'ravi');
      expect(scan.code, '123456');
      expect(scan.role, 'waiter');
    });

    test('anything else is not a pairing QR', () {
      expect(QrPayloads.parsePairing('https://sirpam.app/m/ravi'), isNull);
      expect(QrPayloads.parsePairing('vendoros://pair?s=ravi&c=12'), isNull);
    });

    test('static counter QR has no amount', () {
      final uri = QrPayloads.upi(vpa: 'ravi@upi', payeeName: 'Ravi Tea');
      expect(Uri.parse(uri).queryParameters.containsKey('am'), isFalse);
    });
  });

  group('thermal QR', () {
    const labels = ReceiptLabels(
      bill: 'Bill',
      token: 'Token',
      table: 'Table',
      subtotal: 'Subtotal',
      discount: 'Discount',
      tax: 'Tax',
      rounding: 'Round',
      total: 'Total',
      paid: 'Paid',
      balance: 'Balance',
      reprint: 'Reprint',
      thanks: 'Thanks',
    );

    ReceiptData data() => const ReceiptData(
          shopName: 'Ravi Tea',
          billNumber: 'B1',
          dateText: '01/01/26 09:00',
          lines: [ReceiptLine(name: 'Tea', qty: 2, totalPaise: 2000)],
          subtotalPaise: 2000,
          totalPaise: 2000,
          upiUri: 'upi://pay?pa=ravi@upi',
          feedbackUrl: 'https://sirpam.app/m/feedback.html?n=Ravi',
          feedbackLabel: 'Scan to rate us',
          labels: labels,
        );

    test('QR command stores the payload and prints it', () {
      final bytes = EscPos.qr('HELLO');
      expect(bytes.take(9),
          [0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41, 0x32, 0x00]);
      expect(bytes.sublist(bytes.length - 8),
          [0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]);
      // 'HELLO' plus the three-byte function header.
      expect(bytes.contains(0x50), isTrue);
    });

    test('a bill prints both the payment and the feedback QR', () {
      final bytes = EscPos.receipt(data(), PaperWidth.mm58);
      final printCommands = <int>[];
      for (var i = 0; i + 7 < bytes.length; i++) {
        if (bytes[i] == 0x1D &&
            bytes[i + 1] == 0x28 &&
            bytes[i + 5] == 0x31 &&
            bytes[i + 6] == 0x51) {
          printCommands.add(i);
        }
      }
      expect(printCommands.length, 2);
    });

    test('the printed text still carries the links as a fallback', () {
      final text = ReceiptText.render(data(), PaperWidth.mm58, ascii: true);
      expect(text, contains('upi://pay'));
      // The link is centred and clipped to the 32-column roll.
      expect(text, contains('https://sirpam.app/m/feedback.ht'));
      expect(text, contains('Scan to rate us'));
    });
  });
}
