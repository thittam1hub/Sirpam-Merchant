import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/app/routes.dart';

void main() {
  group('settings deep links', () {
    test('typed builders produce the documented URLs', () {
      expect(AppRoutes.settings(), '/settings');
      expect(AppRoutes.settingsLanguage(), '/settings/language');
      expect(AppRoutes.settingsProfile(), '/settings/profile');
      expect(AppRoutes.settingsProfile(focus: 'fssai'),
          '/settings/profile?focus=fssai');
      expect(AppRoutes.settingsShop(focus: 'phone'),
          '/settings/shop?focus=phone');
      expect(AppRoutes.settingsPayments(focus: 'vpa', soundbox: true),
          '/settings/payments?focus=vpa&soundbox=on');
      expect(AppRoutes.settingsPayments(soundbox: false),
          '/settings/payments?soundbox=off');
      expect(AppRoutes.settingsMarket(market: 'Koyambedu', focus: 'key'),
          '/settings/market?market=Koyambedu&focus=key');
    });

    test('focus targets outside the allow-list are ignored', () {
      expect(
          AppQueryParsing.focus('niche', AppQueryParsing.profileFocus), 'niche');
      expect(AppQueryParsing.focus('phone', AppQueryParsing.profileFocus),
          isNull);
      expect(AppQueryParsing.focus(null, AppQueryParsing.shopFocus), isNull);
      expect(
          AppQueryParsing.focus('<script>', AppQueryParsing.shopFocus), isNull);
    });

    test('toggle keeps the saved value for unknown input', () {
      expect(AppQueryParsing.toggle('on'), isTrue);
      expect(AppQueryParsing.toggle('1'), isTrue);
      expect(AppQueryParsing.toggle('off'), isFalse);
      expect(AppQueryParsing.toggle('0'), isFalse);
      expect(AppQueryParsing.toggle('maybe'), isNull);
      expect(AppQueryParsing.toggle(null), isNull);
    });
    test('ordering settings link carries only known focus targets', () {
      expect(AppRoutes.settingsOrdering(focus: 'pay'),
          '/settings/ordering?focus=pay');
      expect(AppRoutes.settingsOrdering(), '/settings/ordering');
      expect(AppQueryParsing.focus('buttons', AppQueryParsing.orderingFocus),
          'buttons');
      expect(AppQueryParsing.focus('vpa', AppQueryParsing.orderingFocus),
          isNull);
    });
  });
}
