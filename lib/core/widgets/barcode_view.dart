import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';

import '../theme/neu_theme.dart';

/// Renders a QR or 1-D barcode symbol on screen without any extra plugin:
/// the `barcode` package (already used for PDF labels) produces the geometry
/// and a painter draws it with the app's ink colour.
class BarcodeView extends StatelessWidget {
  final String data;
  final bc.Barcode symbology;
  final double width;
  final double height;
  final bool drawText;
  final Color? color;

  const BarcodeView({
    super.key,
    required this.data,
    required this.symbology,
    required this.width,
    required this.height,
    this.drawText = false,
    this.color,
  });

  BarcodeView.qr(
      {super.key, required this.data, double size = 220, this.color})
      : symbology = bc.Barcode.qrCode(
            errorCorrectLevel: bc.BarcodeQRCorrectionLevel.medium),
        width = size,
        height = size,
        drawText = false;

  BarcodeView.code128(
      {super.key,
      required this.data,
      this.width = 240,
      this.height = 80,
      this.drawText = true,
      this.color})
      : symbology = bc.Barcode.code128();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _BarcodePainter(
          elements: symbology
              .make(data,
                  width: width,
                  height: height,
                  drawText: drawText,
                  fontHeight: drawText ? 12 : 0)
              .toList(),
          color: color ?? NeuColors.ink,
        ),
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  final List<bc.BarcodeElement> elements;
  final Color color;
  const _BarcodePainter({required this.elements, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final element in elements) {
      if (element is bc.BarcodeBar) {
        if (!element.black) continue;
        canvas.drawRect(
          Rect.fromLTWH(
              element.left, element.top, element.width, element.height),
          paint,
        );
      } else if (element is bc.BarcodeText) {
        final painter = TextPainter(
          text: TextSpan(
            text: element.text,
            style: TextStyle(
                color: color,
                fontSize: element.height * 0.9,
                fontWeight: FontWeight.w600),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: element.width);
        painter.paint(
          canvas,
          Offset(element.left + (element.width - painter.width) / 2,
              element.top),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter old) =>
      old.elements != elements || old.color != color;
}
