import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// One decoded symbol.
class ScanEvent {
  final String code;
  final String format;
  final DateTime at;
  const ScanEvent({required this.code, required this.format, required this.at});
}

/// Symbologies a stall actually meets: retail EAN/UPC, printed Code128/39,
/// and the QR / DataMatrix codes VendorOS prints on its own labels.
const kSupportedFormats = <BarcodeFormat>[
  BarcodeFormat.ean13,
  BarcodeFormat.ean8,
  BarcodeFormat.upcA,
  BarcodeFormat.upcE,
  BarcodeFormat.code128,
  BarcodeFormat.code39,
  BarcodeFormat.qrCode,
  BarcodeFormat.dataMatrix,
];

/// Debounces the scanner: a camera reports the same symbol many times per
/// second, and a laser wedge types it as keystrokes. Both funnel through here
/// so a single physical scan yields exactly one [ScanEvent].
class BarcodeScannerEngine {
  final Duration dedupeWindow;
  final Duration wedgeFlush;
  final void Function(ScanEvent) onScan;

  String? _lastCode;
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);
  final StringBuffer _wedge = StringBuffer();
  Timer? _wedgeTimer;

  BarcodeScannerEngine({
    required this.onScan,
    this.dedupeWindow = const Duration(milliseconds: 900),
    this.wedgeFlush = const Duration(milliseconds: 120),
  });

  /// Camera path.
  void submitCapture(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value == null || value.isEmpty) continue;
      _emit(value, barcode.format.name);
    }
  }

  /// Hardware "laser wedge" path: the scanner behaves like a keyboard and ends
  /// the code with Enter (or simply stops typing).
  KeyEventResult handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _flushWedge();
      return KeyEventResult.handled;
    }
    final ch = event.character;
    if (ch == null || ch.isEmpty || ch.codeUnitAt(0) < 0x20) {
      return KeyEventResult.ignored;
    }
    _wedge.write(ch);
    _wedgeTimer?.cancel();
    _wedgeTimer = Timer(wedgeFlush, _flushWedge);
    return KeyEventResult.handled;
  }

  void _flushWedge() {
    _wedgeTimer?.cancel();
    final code = _wedge.toString().trim();
    _wedge.clear();
    if (code.isNotEmpty) _emit(code, 'wedge');
  }

  void _emit(String code, String format) {
    final now = DateTime.now();
    if (code == _lastCode && now.difference(_lastAt) < dedupeWindow) return;
    _lastCode = code;
    _lastAt = now;
    onScan(ScanEvent(code: code, format: format, at: now));
  }

  /// Lets a manual entry field share the same de-duplication path.
  void submitManual(String code) => _emit(code.trim(), 'manual');

  void dispose() => _wedgeTimer?.cancel();
}

/// Camera scanning is unavailable on desktop targets and in browsers without
/// the BarcodeDetector API; the UI shows an honest fallback instead of a black
/// rectangle that never decodes.
bool get cameraScanningSupported =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

MobileScannerController buildScannerController() => MobileScannerController(
      formats: kSupportedFormats,
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
