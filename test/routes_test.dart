import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/app/routes.dart';

void main() {
  group('AppRoutes builders', () {
    test('omit empty query params', () {
      expect(AppRoutes.udhaar(), '/udhaar');
      expect(AppRoutes.mandi(), '/mandi');
      expect(AppRoutes.report(), '/report');
      expect(AppRoutes.location(), '/location');
    });

    test('encode values safely', () {
      final uri = Uri.parse(AppRoutes.mandi(market: 'Koyambedu', search: 'தக்காளி'));
      expect(uri.path, '/mandi');
      expect(uri.queryParameters['market'], 'Koyambedu');
      expect(uri.queryParameters['q'], 'தக்காளி');
    });

    test('customer and window and share flags', () {
      expect(Uri.parse(AppRoutes.udhaar(customer: 'Ravi K')).queryParameters['customer'],
          'Ravi K');
      expect(AppRoutes.report(windowDays: 30), '/report?window=30');
      expect(AppRoutes.location(share: true), '/location?share=1');
    });
  });

  group('AppQueryParsing', () {
    test('report window whitelist', () {
      expect(AppQueryParsing.reportWindow('30'), 30);
      expect(AppQueryParsing.reportWindow('60'), 60);
      expect(AppQueryParsing.reportWindow('7'), 90);
      expect(AppQueryParsing.reportWindow(null), 90);
      expect(AppQueryParsing.reportWindow('drop table'), 90);
    });

    test('text is trimmed and length-capped', () {
      expect(AppQueryParsing.text('  ok  '), 'ok');
      expect(AppQueryParsing.text('a' * 200).length, 64);
      expect(AppQueryParsing.text(null), '');
    });

    test('flag parsing', () {
      expect(AppQueryParsing.flag('1'), isTrue);
      expect(AppQueryParsing.flag('true'), isTrue);
      expect(AppQueryParsing.flag('0'), isFalse);
      expect(AppQueryParsing.flag(null), isFalse);
    });
  });

  group('product form routes', () {
    test('new and edit are addressable', () {
      expect(AppRoutes.productNew(), '/products/new');
      expect(Uri.parse(AppRoutes.productNew(code: '8901234'))
          .queryParameters['code'], '8901234');
      expect(AppRoutes.productEdit('p1'), '/products/p1/edit');
      expect(AppRoutes.product('p1'), '/products/p1');
    });

    test('new never collides with the id route', () {
      expect(AppPaths.productNew.startsWith(AppPaths.products), isTrue);
      expect(AppRoutes.productNew(), isNot(AppRoutes.product('new-item')));
    });
  });

  group('view state in the URL', () {
    test('order board history is a query param', () {
      expect(AppRoutes.orders(), '/orders');
      expect(AppRoutes.orders(status: 'history'), '/orders?status=history');
    });

    test('insight window round-trips', () {
      for (final w in AppQueryParsing.insightWindows) {
        final uri = Uri.parse(AppRoutes.insights(window: w));
        expect(AppQueryParsing.insightWindow(uri.queryParameters['window']), w);
      }
      expect(AppQueryParsing.insightWindow('century'), 'week');
    });

    test('product filters round-trip', () {
      final uri = Uri.parse(AppRoutes.products(search: 'tea', lowOnly: true));
      expect(AppQueryParsing.text(uri.queryParameters['q']), 'tea');
      expect(AppQueryParsing.flag(uri.queryParameters['low']), isTrue);
    });
  });
}
