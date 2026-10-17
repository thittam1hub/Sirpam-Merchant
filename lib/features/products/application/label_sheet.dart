import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/label_template.dart';

/// A4 sheets a vendor can print on any ordinary printer, and a payment-QR
/// poster for the stall. Thermal printers use `LabelRenderer` instead.
class LabelSheet {
  const LabelSheet._();

  static Future<Uint8List> build(List<LabelSpec> specs) async {
    final doc = pw.Document();
    final tiles = <pw.Widget>[
      for (final spec in specs)
        for (var i = 0; i < spec.copies; i++) _tile(spec),
    ];
    if (tiles.isEmpty) tiles.add(pw.SizedBox());

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) => [
          pw.Wrap(spacing: 8, runSpacing: 8, children: tiles),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _tile(LabelSpec spec) => pw.Container(
        width: spec.size.widthMm * PdfPageFormat.mm,
        height: spec.size.heightMm * PdfPageFormat.mm,
        padding: const pw.EdgeInsets.all(4),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(spec.title,
                      maxLines: 2,
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  if (spec.priceLine.isNotEmpty)
                    pw.Text(spec.priceLine,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  if (spec.infoLine.isNotEmpty)
                    pw.Text(spec.infoLine,
                        style: const pw.TextStyle(fontSize: 6)),
                  pw.Text(spec.code, style: const pw.TextStyle(fontSize: 6)),
                ],
              ),
            ),
            pw.SizedBox(width: 4),
            pw.BarcodeWidget(
              barcode: spec.symbology == LabelSymbology.qr
                  ? pw.Barcode.qrCode()
                  : pw.Barcode.code128(),
              data: spec.code,
              width: spec.symbology == LabelSymbology.qr ? 46 : 70,
              height: 46,
              drawText: false,
            ),
          ],
        ),
      );

  /// Stall payment poster: one big UPI QR that every UPI app can scan.
  static Future<Uint8List> paymentPoster({
    required String stallName,
    required String vpa,
    required String upiUri,
    required String caption,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(stallName,
                  style: pw.TextStyle(
                      fontSize: 28, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 18),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: upiUri,
                width: 320,
                height: 320,
                drawText: false,
              ),
              pw.SizedBox(height: 18),
              pw.Text(vpa, style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text(caption,
                  textAlign: pw.TextAlign.center,
                  style:
                      const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            ],
          ),
        ),
      ),
    );
    return doc.save();
  }

  /// Counter card: the payment QR customers scan to pay and the feedback QR
  /// they scan after, on one A4 sheet the vendor tapes to the counter.
  static Future<Uint8List> counterCard({
    required String shopName,
    required String upiUri,
    required String payCaption,
    required String feedbackUrl,
    required String feedbackCaption,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(shopName,
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (upiUri.isNotEmpty)
                  _qrBlock(upiUri, payCaption),
                if (feedbackUrl.isNotEmpty)
                  _qrBlock(feedbackUrl, feedbackCaption),
              ],
            ),
          ],
        ),
      ),
    );
    return doc.save();
  }

  static pw.Widget _qrBlock(String data, String caption) => pw.Column(
        children: [
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: data,
            width: 210,
            height: 210,
            drawText: false,
          ),
          pw.SizedBox(height: 10),
          pw.SizedBox(
            width: 210,
            child: pw.Text(caption,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    fontSize: 13, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      );

  /// Offer / loyalty cards: small QR cards the shop hands out or tapes on the
  /// bill, six to a sheet.
  static Future<Uint8List> offerCards({
    required String shopName,
    required String title,
    required String detail,
    required String url,
    required String caption,
    int copies = 6,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) => [
          pw.Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (var i = 0; i < copies; i++)
                pw.Container(
                  width: 240,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 0.8),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(children: [
                    pw.Text(shopName,
                        maxLines: 1,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text(title,
                        maxLines: 2,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 15, fontWeight: pw.FontWeight.bold)),
                    if (detail.isNotEmpty)
                      pw.Text(detail,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 8),
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: url,
                      width: 110,
                      height: 110,
                      drawText: false,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(caption,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 8)),
                  ]),
                ),
            ],
          ),
        ],
      ),
    );
    return doc.save();
  }
}
