/// Printer-native label rendering.
///
/// Two paths ship: an A4 PDF sheet for vendors with a normal printer (built in
/// `application/label_sheet.dart`) and these direct printer dialects for the
/// cheap thermal label printers sold in Indian markets.
library;

enum LabelSize {
  /// 50 x 25 mm — the common shelf-edge label.
  small(50, 25),

  /// 40 x 30 mm — crate / bundle label.
  medium(40, 30),

  /// 100 x 50 mm — large sack label.
  large(100, 50);

  final double widthMm;
  final double heightMm;
  const LabelSize(this.widthMm, this.heightMm);
}

enum LabelSymbology { qr, code128 }

class LabelSpec {
  final String title;
  final String code;

  /// Pre-formatted price line, e.g. "Rs 40 / kg". Empty hides the line.
  final String priceLine;

  /// Optional third line: packed or expiry date, batch id, anything short.
  final String infoLine;
  final LabelSize size;
  final LabelSymbology symbology;
  final int copies;

  const LabelSpec({
    required this.title,
    required this.code,
    this.priceLine = '',
    this.infoLine = '',
    this.size = LabelSize.small,
    this.symbology = LabelSymbology.qr,
    this.copies = 1,
  });
}

/// Dots per millimetre for a 203 dpi thermal head (8 dots/mm) — the default of
/// every printer in this class.
const int kDotsPerMm = 8;

class LabelRenderer {
  const LabelRenderer._();

  /// Zebra ZPL II.
  static String zpl(LabelSpec spec) {
    final w = (spec.size.widthMm * kDotsPerMm).round();
    final h = (spec.size.heightMm * kDotsPerMm).round();
    final b = StringBuffer()
      ..writeln('^XA')
      ..writeln('^PW$w')
      ..writeln('^LL$h')
      ..writeln('^CI28') // UTF-8
      ..writeln('^FO12,10^A0N,24,24^FD${_esc(spec.title)}^FS');
    if (spec.priceLine.isNotEmpty) {
      b.writeln('^FO12,42^A0N,28,28^FD${_esc(spec.priceLine)}^FS');
    }
    if (spec.infoLine.isNotEmpty) {
      b.writeln('^FO12,76^A0N,18,18^FD${_esc(spec.infoLine)}^FS');
    }
    if (spec.symbology == LabelSymbology.qr) {
      b.writeln('^FO${w - 110},14^BQN,2,5^FDLA,${_esc(spec.code)}^FS');
    } else {
      b.writeln('^FO12,${h - 70}^BY2^BCN,50,Y,N,N^FD${_esc(spec.code)}^FS');
    }
    b
      ..writeln('^PQ${spec.copies}')
      ..writeln('^XZ');
    return b.toString();
  }

  /// TSC / TSPL2 (Godex, TSC, most no-name Indian units).
  static String tspl(LabelSpec spec) {
    final b = StringBuffer()
      ..writeln('SIZE ${spec.size.widthMm} mm,${spec.size.heightMm} mm')
      ..writeln('GAP 2 mm,0 mm')
      ..writeln('DIRECTION 1')
      ..writeln('CLS')
      ..writeln('TEXT 12,10,"3",0,1,1,"${_esc(spec.title)}"');
    if (spec.priceLine.isNotEmpty) {
      b.writeln('TEXT 12,44,"4",0,1,1,"${_esc(spec.priceLine)}"');
    }
    if (spec.infoLine.isNotEmpty) {
      b.writeln('TEXT 12,80,"2",0,1,1,"${_esc(spec.infoLine)}"');
    }
    if (spec.symbology == LabelSymbology.qr) {
      b.writeln(
          'QRCODE ${(spec.size.widthMm * kDotsPerMm - 110).round()},14,M,5,A,0,"${_esc(spec.code)}"');
    } else {
      b.writeln(
          'BARCODE 12,${(spec.size.heightMm * kDotsPerMm - 70).round()},"128",50,1,0,2,2,"${_esc(spec.code)}"');
    }
    b.writeln('PRINT 1,${spec.copies}');
    return b.toString();
  }

  static String _esc(String v) =>
      v.replaceAll('"', "'").replaceAll('^', ' ').replaceAll('~', '-');
}
