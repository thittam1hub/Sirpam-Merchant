import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/core/network/share_links.dart';
import 'package:vendoros/features/products/domain/label_template.dart';

void main() {
  group('UPI collect QR payload', () {
    test('static payload carries no amount', () {
      final uri = ShareLinks.upiCollect(vpa: 'stall@upi', payeeName: 'Sirpam');
      expect(uri.scheme, 'upi');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['pa'], 'stall@upi');
      expect(uri.queryParameters['pn'], 'Sirpam');
      expect(uri.queryParameters['cu'], 'INR');
      expect(uri.queryParameters.containsKey('am'), isFalse);
    });

    test('dynamic payload carries a two-decimal amount', () {
      final uri = ShareLinks.upiCollect(
          vpa: 'stall@upi',
          payeeName: 'Sirpam',
          amountRupees: 149.5,
          note: 'Order 12');
      expect(uri.queryParameters['am'], '149.50');
      expect(uri.queryParameters['tn'], 'Order 12');
    });

    test('a zero amount stays static rather than emitting am=0', () {
      final uri = ShareLinks.upiCollect(
          vpa: 'stall@upi', payeeName: 'Sirpam', amountRupees: 0);
      expect(uri.queryParameters.containsKey('am'), isFalse);
    });
  });

  group('label rendering', () {
    const spec = LabelSpec(
      title: 'Tomato',
      priceLine: 'Rs 40 / kg',
      code: 'VOS-0001',
      size: LabelSize.small,
      symbology: LabelSymbology.code128,
      copies: 3,
    );

    test('ZPL declares UTF-8, the payload and the copy count', () {
      final zpl = LabelRenderer.zpl(spec);
      expect(zpl, contains('^CI28'));
      expect(zpl, contains('VOS-0001'));
      expect(zpl, contains('^PQ3'));
      expect(zpl.trim().endsWith('^XZ'), isTrue);
    });

    test('TSPL sizes the label in millimetres and prints the copies', () {
      final tspl = LabelRenderer.tspl(spec);
      expect(tspl, contains('SIZE 50.0 mm,25.0 mm'));
      expect(tspl, contains('PRINT 1,3'));
      expect(tspl, contains('VOS-0001'));
    });

    test('quotes in text cannot break the TSPL command', () {
      final tspl = LabelRenderer.tspl(const LabelSpec(
        title: 'Ravi"s mix',
        code: 'VOS-2',
        size: LabelSize.medium,
        symbology: LabelSymbology.qr,
      ));
      expect(tspl, contains("\"Ravi's mix\""));
      expect(tspl, isNot(contains('Ravi"s')));
    });
  });
}
