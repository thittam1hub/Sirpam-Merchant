import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/routes.dart';
import '../../../core/hardware/barcode_scanner.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu_chrome.dart';
import 'settings_widgets.dart';

/// The UPI id hidden inside a payment-app QR (`upi://pay?pa=...`), or null
/// when the scanned code is something else entirely.
String? upiIdFromQr(String raw) {
  final text = raw.trim();
  final uri = Uri.tryParse(text);
  final pa = uri?.queryParameters['pa']?.trim();
  if (pa != null && pa.contains('@')) return pa;
  // Some stickers hold the bare id.
  if (RegExp(r'^[\w.\-]{2,}@[\w.\-]{2,}$').hasMatch(text)) return text;
  return null;
}

/// UPI VPA + soundbox announcements.
/// `?focus=vpa` focuses the field, `?soundbox=on|off` presets the switch.
class PaymentsSettingsPage extends ConsumerStatefulWidget {
  final String? focus;
  final bool? soundbox;
  const PaymentsSettingsPage({super.key, this.focus, this.soundbox});
  @override
  ConsumerState<PaymentsSettingsPage> createState() =>
      _PaymentsSettingsPageState();
}

class _PaymentsSettingsPageState extends ConsumerState<PaymentsSettingsPage> {
  late final VendorSettings _initial = ref.read(settingsProvider);
  late final _vpa = TextEditingController(text: _initial.upiVpa);
  late bool _soundbox = widget.soundbox ?? _initial.soundboxEnabled;

  @override
  void dispose() {
    _vpa.dispose();
    super.dispose();
  }

  bool get _dirty =>
      _vpa.text.trim() != _initial.upiVpa.trim() ||
      _soundbox != _initial.soundboxEnabled;

  Future<void> _save() async {
    await ref.read(settingsProvider.notifier).save(
          ref.read(settingsProvider).copyWith(
                upiVpa: _vpa.text.trim(),
                soundboxEnabled: _soundbox,
              ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.settingsSaved)));
  }

  /// Reads the vendor's existing payment-app QR with the camera and keeps the
  /// UPI id from it, so the app's QR pays into the very same account.
  Future<void> _scanOwnQr() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (!cameraScanningSupported) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.scanUnsupported)));
      return;
    }
    final controller = buildScannerController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.paymentQrScanTitle),
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
    if (code == null) return;
    final vpa = upiIdFromQr(code);
    if (vpa == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.paymentQrScanNoUpi)));
      return;
    }
    setState(() => _vpa.text = vpa);
    messenger
        .showSnackBar(SnackBar(content: Text(l10n.paymentQrScanFound(vpa))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: l10n.settingsPaymentsTitle,
      fallbackLocation: AppPaths.settings,
      isDirty: () => _dirty,
      body: SettingsFormBody(
        saveLabel: l10n.save,
        onSave: _save,
        children: [
          SettingsCard(
            children: [
              SettingsField(
                label: l10n.upiVpaLabel,
                controller: _vpa,
                keyboard: TextInputType.emailAddress,
                autofocus: widget.focus == 'vpa',
                onChanged: (_) => setState(() {}),
              ),
              OutlinedButton.icon(
                onPressed: _scanOwnQr,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(l10n.paymentQrScanAction),
              ),
              Text(l10n.paymentQrScanHelp,
                  style: const TextStyle(fontSize: 12.5)),
              SettingsToggleRow(
                label: l10n.soundboxAnnounce,
                value: _soundbox,
                onChanged: (v) => setState(() => _soundbox = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          NeuTile(
            icon: Icons.account_balance_rounded,
            title: l10n.merchantOnboardingTitle,
            value: l10n.merchantOnboardingSubtitle,
            onTap: () => context.push(AppRoutes.merchant()),
          ),
        ],
      ),
    );
  }
}
