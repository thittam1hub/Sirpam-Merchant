import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/escpos.dart';
import '../domain/printer_settings.dart';
import '../domain/receipt.dart';
import 'bluetooth_printer.dart';

/// Turns a [ReceiptData] into something a vendor can hand over: a roll-width
/// PDF for the system print/share sheet, or ESC/POS bytes for a thermal
/// printer. Rendering is pure; only the delivery step touches the platform.
class ReceiptPrinter {
  const ReceiptPrinter._();

  static pw.Font? _tamilFont;

  /// The bundled Tamil face, so a printed bill is readable in Tamil even
  /// though raw ESC/POS text cannot carry the script.
  static Future<pw.Font> _font() async {
    final cached = _tamilFont;
    if (cached != null) return cached;
    final data = await rootBundle.load('assets/fonts/NotoSansTamil-Regular.ttf');
    final font = pw.Font.ttf(data);
    _tamilFont = font;
    return font;
  }

  static double _rollWidthMm(PaperWidth width) =>
      width == PaperWidth.mm58 ? 58 : 80;

  /// Monospaced receipt laid out on a continuous roll-width page.
  static Future<Uint8List> pdf(ReceiptData data, PaperWidth width) async {
    final font = await _font();
    final body = ReceiptText.render(data, width);
    final mm = _rollWidthMm(width);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          mm * PdfPageFormat.mm,
          double.infinity,
          marginAll: 4 * PdfPageFormat.mm,
        ),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text(body,
                style: pw.TextStyle(
                    font: font,
                    fontFallback: [font],
                    fontSize: width == PaperWidth.mm58 ? 7.5 : 8.5,
                    lineSpacing: 1.2)),
            if (data.upiUri.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: data.upiUri,
                  width: mm * 0.6 * PdfPageFormat.mm,
                  height: mm * 0.6 * PdfPageFormat.mm,
                  drawText: false,
                ),
              ),
            ],
            if (data.feedbackUrl.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              if (data.feedbackLabel.isNotEmpty)
                pw.Center(
                  child: pw.Text(data.feedbackLabel,
                      style: pw.TextStyle(
                          font: font, fontFallback: [font], fontSize: 7)),
                ),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: data.feedbackUrl,
                  width: mm * 0.42 * PdfPageFormat.mm,
                  height: mm * 0.42 * PdfPageFormat.mm,
                  drawText: false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
    return doc.save();
  }

  static List<int> escpos(ReceiptData data, PaperWidth width) =>
      EscPos.receipt(data, width);

  /// Plain-text version for WhatsApp / share-sheet fallback.
  static String plainText(ReceiptData data, PaperWidth width) =>
      ReceiptText.render(data, width);

  /// Sends the receipt through the configured transport. Bluetooth and USB
  /// need a paired device; until one is configured the PDF/share path is used
  /// so a bill can always be produced.
  static Future<PrintOutcome> send(
    ReceiptData data,
    PrinterSettings settings, {
    String jobName = 'receipt',
    BluetoothPrinter? bluetooth,
  }) async {
    switch (settings.transport) {
      case PrintTransport.bluetooth:
        final transport = bluetooth ?? const BluetoothPrinter();
        if (settings.deviceAddress.isNotEmpty &&
            await transport.send(
                settings.deviceAddress, escpos(data, settings.width))) {
          return PrintOutcome.printed;
        }
        await _layout(data, settings, jobName);
        return PrintOutcome.fellBackToPdf;
      case PrintTransport.usb:
        // USB OTG is not wired yet; the bill still has to come out.
        await _layout(data, settings, jobName);
        return PrintOutcome.fellBackToPdf;
      case PrintTransport.pdf:
        await _layout(data, settings, jobName);
        return PrintOutcome.printed;
    }
  }

  static Future<void> _layout(
      ReceiptData data, PrinterSettings settings, String jobName) async {
    final bytes = await pdf(data, settings.width);
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: jobName);
  }

  static Future<void> share(ReceiptData data, PrinterSettings settings,
      {required String filename}) async {
    final bytes = await pdf(data, settings.width);
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}

enum PrintOutcome { printed, fellBackToPdf }
