import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../hardware/barcode_scanner.dart';
import '../l10n/l10n_extension.dart';

/// One shared camera dialog for every "point at a code" moment in the app —
/// a payment sticker, a printed product label, a staff pairing card.
/// Returns the raw text of the first symbol read, or null if cancelled.
Future<String?> scanCode(BuildContext context, {required String title}) async {
  final l10n = context.l10n;
  if (!cameraScanningSupported) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.scanUnsupported)));
    return null;
  }
  final controller = buildScannerController();
  final code = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 320,
        height: 320,
        child: MobileScanner(
          controller: controller,
          onDetect: (capture) {
            for (final b in capture.barcodes) {
              final value = b.rawValue?.trim();
              if (value != null && value.isNotEmpty) {
                Navigator.of(ctx).pop(value);
                return;
              }
            }
          },
          errorBuilder: (_, __) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l10n.scanPermission, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );
  await controller.dispose();
  return code;
}
