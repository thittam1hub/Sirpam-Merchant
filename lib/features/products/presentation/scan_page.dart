import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/routes.dart';
import '../../../core/hardware/barcode_scanner.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/inventory_controller.dart';
import 'inventory_widgets.dart';

/// Camera / laser-wedge / manual scanning. A known code opens the product,
/// an unknown one offers to create it — never a silent dead end.
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  late final BarcodeScannerEngine _engine =
      BarcodeScannerEngine(onScan: _handleScan);
  final _manual = TextEditingController();
  final _focus = FocusNode();
  MobileScannerController? _camera;
  String _lastUnknown = '';

  @override
  void initState() {
    super.initState();
    if (cameraScanningSupported) _camera = buildScannerController();
  }

  @override
  void dispose() {
    _camera?.dispose();
    _engine.dispose();
    _manual.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _handleScan(ScanEvent event) {
    final product = ref.read(inventoryProvider).byCode(event.code);
    HapticFeedback.selectionClick();
    if (product != null) {
      context.push(AppRoutes.product(product.id));
      return;
    }
    setState(() => _lastUnknown = event.code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: l10n.scanTitle,
      subtitle: l10n.scanSubtitle,
      fallbackLocation: AppPaths.products,
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: (_, event) => _engine.handleKey(event),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
          children: [
            NeuBox(
              inset: true,
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _camera == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(l10n.scanUnsupported,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: NeuColors.inkSoft, fontSize: 14)),
                          ),
                        )
                      : MobileScanner(
                          controller: _camera,
                          onDetect: _engine.submitCapture,
                          errorBuilder: (_, __) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(l10n.scanPermission,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: NeuColors.inkSoft, fontSize: 14)),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            NeuField(
              controller: _manual,
              hint: l10n.scanManualHint,
              action: TextInputAction.search,
              leading: Icon(Icons.keyboard_alt_outlined,
                  size: 20, color: NeuColors.inkSoft),
              onSubmitted: (v) {
                _engine.submitManual(v);
                _manual.clear();
              },
            ),
            if (_lastUnknown.isNotEmpty) ...[
              const SizedBox(height: 16),
              NeuBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.scanUnknownCode(_lastUnknown),
                        style: TextStyle(color: NeuColors.inkSoft)),
                    const SizedBox(height: 14),
                    NeuTextButton(
                      label: l10n.scanCreateFromCode,
                      color: NeuColors.accentDark,
                      onPressed: () {
                        final code = _lastUnknown;
                        setState(() => _lastUnknown = '');
                        context.push(AppRoutes.productNew(code: code));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
