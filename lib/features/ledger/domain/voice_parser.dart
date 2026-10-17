import '../../../core/l10n/app_message.dart';
import 'sale.dart';

/// Result of parsing a colloquial Tamil/Tanglish voice line like
/// "50 rupees tomato cash", "ravi ku 200 udhaar", "120 gpay".
class ParsedSale {
  final int amountPaise;
  final SaleMode mode;
  final String item;
  final String? customer;
  const ParsedSale({
    required this.amountPaise,
    required this.mode,
    required this.item,
    this.customer,
  });
}

class VoiceParseException implements Exception {
  final AppMessage message;
  const VoiceParseException(this.message);
  @override
  String toString() => 'VoiceParseException($message)';
}

class VoiceParser {
  static const _upiWords = [
    'upi', 'gpay', 'g pay', 'google pay', 'phonepe', 'phone pe', 'paytm',
    'bhim', 'scan', 'qr', 'skanner', 'ஸ்கேன்', 'கியூஆர்',
    'யூபிஐ', 'ஜிபே', 'கூகுள் பே', 'ஃபோன்பே', 'போன்பே', 'பேட்டிஎம்',
    'ஆன்லைன்', 'online'
  ];
  static const _creditWords = [
    'udhaar', 'udhar', 'credit', 'kadan', 'kadhan', 'baaki', 'baki',
    'கடன்', 'உதார்', 'வரவு', 'பாக்கி', 'கிரெடிட்', 'நாளைக்கு தருவேன்'
  ];
  static const _cashWords = [
    'cash', 'kaasu', 'kaasa', 'panam', 'காசு', 'ரொக்கம்', 'கேஷ்', 'பணம்'
  ];

  /// Tamil digits ௦-௯ map onto ASCII digits.
  static const _tamilDigits = '௦௧௨௩௪௫௬௭௮௯';

  /// Spoken numbers, Tamil script and Tanglish, mapped to their value.
  /// Multipliers (100 / 1000) are combined with the preceding unit so that
  /// "ரெண்டு நூறு" and "இருநூறு" both resolve to 200.
  static const Map<String, int> _numberWords = {
    // units
    'ஒன்று': 1, 'ஒரு': 1, 'onnu': 1, 'ondru': 1, 'oru': 1,
    'இரண்டு': 2, 'ரெண்டு': 2, 'rendu': 2, 'irandu': 2,
    'மூன்று': 3, 'மூணு': 3, 'moonu': 3, 'moondru': 3,
    'நான்கு': 4, 'நாலு': 4, 'naalu': 4, 'nangu': 4,
    'ஐந்து': 5, 'அஞ்சு': 5, 'anju': 5, 'ainthu': 5,
    'ஆறு': 6, 'aaru': 6, 'ஏழு': 7, 'ezhu': 7,
    'எட்டு': 8, 'ettu': 8, 'ஒன்பது': 9, 'onbathu': 9,
    'பத்து': 10, 'pathu': 10,
    // teens / tens
    'பதினைந்து': 15, 'இருபது': 20, 'irupathu': 20,
    'இருபத்தைந்து': 25, 'முப்பது': 30, 'muppathu': 30,
    'நாற்பது': 40, 'narpathu': 40, 'ஐம்பது': 50, 'aimbathu': 50,
    'அறுபது': 60, 'arupathu': 60, 'எழுபது': 70, 'ezhupathu': 70,
    'எண்பது': 80, 'enbathu': 80, 'தொண்ணூறு': 90, 'thonnooru': 90,
    // hundreds
    'இருநூறு': 200, 'முந்நூறு': 300, 'நானூறு': 400, 'ஐநூறு': 500,
    'அறுநூறு': 600, 'எழுநூறு': 700, 'எண்ணூறு': 800, 'தொள்ளாயிரம்': 900,
  };

  static const Map<String, int> _multiplierWords = {
    'நூறு': 100, 'நூற்று': 100, 'நூத்தி': 100, 'nooru': 100, 'nuru': 100,
    'nootri': 100, 'hundred': 100,
    'ஆயிரம்': 1000, 'ஆயிரத்து': 1000, 'aayiram': 1000, 'thousand': 1000,
  };

  /// Normalises a raw transcript: Tamil digits to ASCII, spoken Tamil/Tanglish
  /// numbers to digits, and collapsed whitespace. Public for testing.
  static String normalize(String raw) {
    var text = raw.toLowerCase().trim();
    for (var i = 0; i < _tamilDigits.length; i++) {
      text = text.replaceAll(_tamilDigits[i], '$i');
    }
    final tokens = text.split(RegExp(r'\s+'));
    final out = <String>[];
    var pending = 0; // value built from consecutive number words
    var total = 0;
    var active = false;

    void flush() {
      if (active) {
        out.add('${total + pending}');
        total = 0;
        pending = 0;
        active = false;
      }
    }

    for (final t in tokens) {
      final word = t.replaceAll(RegExp(r'[^\w\u0B80-\u0BFF]'), '');
      final value = _numberWords[word];
      final mult = _multiplierWords[word];
      if (value != null) {
        active = true;
        if (value >= 100) {
          total += value;
        } else if (pending == 0) {
          pending = value;
        } else {
          // "ஐம்பது அஞ்சு" -> 55
          pending += value;
        }
      } else if (mult != null) {
        active = true;
        total += (pending == 0 ? 1 : pending) * mult;
        pending = 0;
      } else {
        flush();
        out.add(t);
      }
    }
    flush();
    return out.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Parses the first recognizer hypothesis that yields a usable amount.
  /// Tamil recognition often drops the number from the top result while a
  /// lower-ranked alternate keeps it, so all hypotheses are tried in order.
  static ParsedSale parseBest(List<String> candidates) {
    VoiceParseException? first;
    for (final c in candidates) {
      try {
        return parse(c);
      } on VoiceParseException catch (e) {
        first ??= e;
      }
    }
    throw first ??
        const VoiceParseException(AppMessage(AppMessageCode.voiceNothingHeard));
  }

  /// Parses free-form colloquial speech into a structured sale record.
  /// Throws [VoiceParseException] when no amount is found.
  static ParsedSale parse(String raw) {
    final text = normalize(raw);
    if (text.isEmpty) {
      throw const VoiceParseException(AppMessage(AppMessageCode.voiceNothingHeard));
    }


    // --- amount (first numeric token, supports 1,200 / 99.50) ---
    final amountMatch =
        RegExp(r'(\d{1,3}(?:,\d{2,3})+|\d+)(?:\.\d{1,2})?').firstMatch(text);
    if (amountMatch == null) {
      throw const VoiceParseException(
          AppMessage(AppMessageCode.voiceNoAmount));
    }
    final cleaned = amountMatch.group(0)!.replaceAll(',', '');
    final rupees = double.parse(cleaned);
    if (rupees <= 0) {
      throw const VoiceParseException(AppMessage(AppMessageCode.voiceZeroAmount));
    }
    final paise = (rupees * 100).round();

    // --- mode ---
    SaleMode mode = SaleMode.cash;
    final found = <String>[];
    for (final w in _upiWords) {
      if (text.contains(w)) {
        mode = SaleMode.upi;
        found.add(w);
        break;
      }
    }
    if (mode == SaleMode.cash) {
      for (final w in _creditWords) {
        if (text.contains(w)) {
          mode = SaleMode.credit;
          found.add(w);
          break;
        }
      }
    }
    if (mode == SaleMode.cash) {
      for (final w in _cashWords) {
        if (text.contains(w)) {
          found.add(w);
          break;
        }
      }
    }

    // --- strip amount, mode and filler words to find item/customer ---
    var rest = text.replaceRange(amountMatch.start, amountMatch.end, ' ');
    for (final w in found) {
      rest = rest.replaceAll(w, ' ');
    }
    for (final filler in const [
      'rupees', 'rupee', 'rs', 'rooba', 'ரூபாய்', 'ரூ', 'விற்றேன்',
      'sold', 'sale', 'entry', 'podu', 'போடு', 'எழுது'
    ]) {
      rest = rest.replaceAll(filler, ' ');
    }
    final tokens =
        rest.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    // --- customer for credit: "<name> ku", "ரவிக்கு", "to <name>" ---
    String? customer;
    if (mode == SaleMode.credit) {
      for (var i = 0; i < tokens.length; i++) {
        final t = tokens[i];
        if ((t == 'ku' || t == 'க்கு' || t == 'to' || t == 'for') && i > 0) {
          customer = tokens[i - 1];
          tokens.removeRange(i - 1, i + 1);
          break;
        }
        if ((t == 'to' || t == 'for') && i + 1 < tokens.length) {
          customer = tokens[i + 1];
          tokens.removeRange(i, i + 2);
          break;
        }
        // Tamil dative suffix written joined to the name: "ரவிக்கு".
        if (t.length > 3 && (t.endsWith('க்கு') || t.endsWith('கிட்ட'))) {
          customer = t.endsWith('க்கு')
              ? t.substring(0, t.length - 4)
              : t.substring(0, t.length - 5);
          tokens.removeAt(i);
          break;
        }
      }
      customer ??= 'Walk-in';
    }


    final item = tokens.join(' ').trim();
    return ParsedSale(
      amountPaise: paise,
      mode: mode,
      item: item.isEmpty ? 'Sale' : item,
      customer: customer,
    );
  }
}
