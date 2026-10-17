import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';
import 'package:vendoros/features/ledger/domain/voice_parser.dart';

void main() {
  group('VoiceParser', () {
    test('parses plain cash sale', () {
      final r = VoiceParser.parse('50 rupees tomato cash');
      expect(r.amountPaise, 5000);
      expect(r.mode, SaleMode.cash);
      expect(r.item, contains('tomato'));
    });

    test('defaults to cash when no mode word is present', () {
      expect(VoiceParser.parse('120 onion').mode, SaleMode.cash);
    });

    test('detects UPI apps', () {
      for (final phrase in ['120 gpay', '90 phonepe', '75 paytm', '40 upi']) {
        expect(VoiceParser.parse(phrase).mode, SaleMode.upi, reason: phrase);
      }
    });

    test('detects credit and extracts the customer name', () {
      final r = VoiceParser.parse('ravi ku 200 udhaar');
      expect(r.mode, SaleMode.credit);
      expect(r.amountPaise, 20000);
      expect(r.customer, 'ravi');
    });

    test('credit without a name falls back to Walk-in', () {
      expect(VoiceParser.parse('300 udhaar').customer, 'Walk-in');
    });

    test('handles grouped thousands and decimals', () {
      expect(VoiceParser.parse('1,250 cash').amountPaise, 125000);
      expect(VoiceParser.parse('99.50 rupees cash').amountPaise, 9950);
    });

    test('throws on empty or amount-less speech', () {
      expect(() => VoiceParser.parse('   '), throwsA(isA<VoiceParseException>()));
      expect(
          () => VoiceParser.parse('tomato cash'), throwsA(isA<VoiceParseException>()));
      expect(() => VoiceParser.parse('0 cash'), throwsA(isA<VoiceParseException>()));
    });

    test('never returns an empty item', () {
      expect(VoiceParser.parse('60 cash').item, isNotEmpty);
    });
  
    test('parses Tamil spoken numbers', () {
      expect(VoiceParser.parse('ஐம்பது ரூபாய் தக்காளி காசு').amountPaise, 5000);
      expect(VoiceParser.parse('ரெண்டு நூறு காசு').amountPaise, 20000);
      expect(VoiceParser.parse('இருநூறு காசு').amountPaise, 20000);
      expect(VoiceParser.parse('நூத்தி ஐம்பது காசு').amountPaise, 15000);
      expect(VoiceParser.parse('ஆயிரம் காசு').amountPaise, 100000);
    });

    test('parses Tamil digits', () {
      expect(VoiceParser.parse('௧௨௦ காசு').amountPaise, 12000);
    });

    test('extracts a name with the joined Tamil dative suffix', () {
      final r = VoiceParser.parse('ரவிக்கு 200 கடன்');
      expect(r.mode, SaleMode.credit);
      expect(r.customer, 'ரவி');
    });

    test('parseBest falls back to a later hypothesis', () {
      final r = VoiceParser.parseBest(['தக்காளி கடன்', 'தக்காளி 40 காசு']);
      expect(r.amountPaise, 4000);
    });
  });
}
