import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/shop_config.dart';

/// A4 sheet of table QR codes the vendor prints once and tapes to the tables.
class TableQrSheet {
  const TableQrSheet._();

  static Future<Uint8List> build({
    required ShopConfig shop,
    required String shopName,
    required String tableLabel,
    required String counterLabel,
    required String scanHint,
  }) async {
    final doc = pw.Document();
    final codes = <int>[0, for (var t = 1; t <= shop.tableCount; t++) t];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) => [
          pw.Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final table in codes)
                pw.Container(
                  width: 170,
                  padding: const pw.EdgeInsets.all(10),
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
                    pw.Text(
                        table == 0 ? counterLabel : '$tableLabel $table',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6),
                    pw.BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: shop.menuUrl(table),
                      width: 120,
                      height: 120,
                      drawText: false,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(scanHint,
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
