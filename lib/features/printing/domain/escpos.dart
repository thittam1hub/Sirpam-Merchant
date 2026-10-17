/// Pure receipt renderers: monospaced text and ESC/POS bytes.
///
/// Kept free of hardware so both are unit-testable; a transport (Bluetooth,
/// USB, PDF, share sheet) only has to move the result somewhere.
library;

import 'dart:convert';

import 'receipt.dart';

String _money(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';

/// ASCII-safe money for ESC/POS: most cheap printers have no rupee glyph.
String _moneyAscii(int paise) => 'Rs.${(paise / 100).toStringAsFixed(2)}';

class ReceiptText {
  const ReceiptText._();

  static String center(String text, int cols) {
    if (text.length >= cols) return text.substring(0, cols);
    final pad = (cols - text.length) ~/ 2;
    return ' ' * pad + text;
  }

  /// `left ............ right` on one line, right-aligned, never overflowing.
  static String row(String left, String right, int cols) {
    final r = right.length > cols ? right.substring(0, cols) : right;
    final room = cols - r.length;
    var l = left;
    if (l.length > room - 1 && room > 1) l = l.substring(0, room - 1);
    return l + ' ' * (cols - l.length - r.length) + r;
  }

  static String rule(int cols) => '-' * cols;

  /// Full monospaced receipt — also the WhatsApp / share fallback body.
  static String render(ReceiptData d, PaperWidth width, {bool ascii = false}) {
    final cols = columnsFor(width);
    String m(int p) => ascii ? _moneyAscii(p) : _money(p);
    final b = StringBuffer()..writeln(center(d.shopName, cols));
    if (d.shopLine.isNotEmpty) b.writeln(center(d.shopLine, cols));
    if (d.gstin.isNotEmpty) b.writeln(center('GSTIN: ${d.gstin}', cols));
    if (d.fssai.isNotEmpty) b.writeln(center('FSSAI: ${d.fssai}', cols));
    b
      ..writeln(rule(cols))
      ..writeln(row('${d.labels.bill} ${d.billNumber}', d.dateText, cols));
    if (d.token > 0) {
      b.writeln(row('${d.labels.token} ${d.token}',
          d.tableLabel.isEmpty ? '' : '${d.labels.table} ${d.tableLabel}', cols));
    }
    if (d.customer.isNotEmpty) b.writeln(d.customer);
    if (d.reprint) b.writeln(center('** ${d.labels.reprint} **', cols));
    b.writeln(rule(cols));
    for (final line in d.lines) {
      b
        ..writeln(line.name)
        ..writeln(row('  x${line.qty}', m(line.totalPaise), cols));
    }
    b
      ..writeln(rule(cols))
      ..writeln(row(d.labels.subtotal, m(d.subtotalPaise), cols));
    if (d.discountPaise > 0) {
      b.writeln(row(d.labels.discount, '-${m(d.discountPaise)}', cols));
    }
    if (d.taxPaise > 0) b.writeln(row(d.labels.tax, m(d.taxPaise), cols));
    for (final s in d.slabs) {
      b.writeln(row('  ${d.labels.taxable} ${s.rateLabel}%',
          m(s.taxablePaise), cols));
      if (s.igstPaise > 0) {
        b.writeln(row('  ${d.labels.igst} ${s.rateLabel}%',
            m(s.igstPaise), cols));
      } else {
        final half = s.halfRateLabel.isEmpty ? s.rateLabel : s.halfRateLabel;
        b
          ..writeln(row('  ${d.labels.cgst} $half%', m(s.cgstPaise), cols))
          ..writeln(row('  ${d.labels.sgst} $half%', m(s.sgstPaise), cols));
      }
    }
    if (d.roundingPaise != 0) {
      b.writeln(row(d.labels.rounding, m(d.roundingPaise), cols));
    }
    b.writeln(row(d.labels.total, m(d.totalPaise), cols));
    for (final t in d.tenders) {
      b.writeln(row(t.label, m(t.amountPaise), cols));
    }
    if (d.balancePaise != 0) {
      b.writeln(row(d.labels.balance, m(d.balancePaise), cols));
    }
    b
      ..writeln(rule(cols))
      ..writeln(center(d.labels.thanks, cols));
    if (d.upiUri.isNotEmpty) b.writeln(center(d.upiUri, cols));
    if (d.feedbackUrl.isNotEmpty) {
      if (d.feedbackLabel.isNotEmpty) b.writeln(center(d.feedbackLabel, cols));
      b.writeln(center(d.feedbackUrl, cols));
    }
    return b.toString();
  }
}

/// Minimal ESC/POS command set understood by every 58/80 mm thermal printer.
class EscPos {
  const EscPos._();

  static const _esc = 0x1B;
  static const _gs = 0x1D;

  static List<int> init() => [_esc, 0x40];
  static List<int> alignLeft() => [_esc, 0x61, 0x00];
  static List<int> alignCenter() => [_esc, 0x61, 0x01];
  static List<int> bold(bool on) => [_esc, 0x45, on ? 0x01 : 0x00];
  static List<int> doubleHeight(bool on) => [_gs, 0x21, on ? 0x01 : 0x00];
  static List<int> feed(int lines) => [_esc, 0x64, lines];
  static List<int> cut() => [_gs, 0x56, 0x42, 0x00];
  static List<int> drawerKick() => [_esc, 0x70, 0x00, 0x19, 0xFA];

  /// Model-2 QR symbol, the one command set every 58/80 mm printer shares.
  /// Bigger [module] means a bigger symbol (1-8 dots per module).
  static List<int> qr(String data, {int module = 6}) {
    final bytes = latin1.encode(data.replaceAll(RegExp(r'[^\x20-\x7E]'), ''));
    final len = bytes.length + 3;
    return [
      // model 2
      _gs, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41, 0x32, 0x00,
      // module size
      _gs, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, module.clamp(1, 8),
      // error correction level M
      _gs, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x31,
      // store the payload
      _gs, 0x28, 0x6B, len & 0xFF, (len >> 8) & 0xFF, 0x31, 0x50, 0x30,
      ...bytes,
      // print it
      _gs, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30,
    ];
  }

  static List<int> text(String value) =>
      latin1.encode(_asciiFold(value)).toList();

  /// Printers with no Tamil font print mojibake; fold to a safe subset and let
  /// the PDF/share path carry the Tamil version.
  static String _asciiFold(String value) {
    final out = StringBuffer();
    for (final rune in value.runes) {
      if (rune == 0x20B9) {
        out.write('Rs.');
      } else if (rune < 0x80) {
        out.writeCharCode(rune);
      } else {
        out.write('?');
      }
    }
    return out.toString();
  }

  /// Complete job: init, header in bold, body, feed and cut.
  static List<int> receipt(ReceiptData data, PaperWidth width) {
    final cols = columnsFor(width);
    final bytes = <int>[
      ...init(),
      ...alignCenter(),
      ...bold(true),
      ...doubleHeight(true),
      ...text('${data.shopName}\n'),
      ...doubleHeight(false),
      ...bold(false),
      ...alignLeft(),
    ];
    final body = ReceiptText.render(data, width, ascii: true)
        .split('\n')
        // The shop name is already printed in double height above.
        .skip(1)
        .where((l) => l.trim().isNotEmpty || l.isEmpty)
        .join('\n');
    bytes
      ..addAll(text(body))
      ..addAll(text('\n'))
      ..addAll(alignCenter())
      ..addAll(text('${'=' * (cols ~/ 2)}\n'));
    if (data.upiUri.isNotEmpty) {
      bytes
        ..addAll(qr(data.upiUri))
        ..addAll(text('\n'));
    }
    if (data.feedbackUrl.isNotEmpty) {
      if (data.feedbackLabel.isNotEmpty) {
        bytes.addAll(text('${data.feedbackLabel}\n'));
      }
      bytes
        ..addAll(qr(data.feedbackUrl, module: 4))
        ..addAll(text('\n'));
    }
    bytes
      ..addAll(feed(3))
      ..addAll(cut());
    return bytes;
  }
}
