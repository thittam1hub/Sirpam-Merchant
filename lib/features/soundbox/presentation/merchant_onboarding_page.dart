import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/supabase_config.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/merchant_soundbox_controller.dart';

/// Self-service business onboarding: the vendor types the details from their
/// PhonePe / Paytm for Business dashboard, the server creates the merchant
/// record and returns a pairing code, and this phone is linked immediately.
class MerchantOnboardingPage extends ConsumerStatefulWidget {
  const MerchantOnboardingPage({super.key});
  @override
  ConsumerState<MerchantOnboardingPage> createState() =>
      _MerchantOnboardingPageState();
}

class _MerchantOnboardingPageState
    extends ConsumerState<MerchantOnboardingPage> {
  final _name = TextEditingController();
  final _vpa = TextEditingController();
  final _ref = TextEditingController();
  final _secret = TextEditingController();
  final _saltIndex = TextEditingController(text: '1');
  String _provider = 'phonepe';
  String? _pairingCode;

  /// Typed credentials that were never registered are worth a confirmation
  /// before the screen closes.
  bool get _dirty =>
      _pairingCode == null &&
      [_name, _vpa, _ref, _secret]
          .any((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    _name.dispose();
    _vpa.dispose();
    _ref.dispose();
    _secret.dispose();
    _saltIndex.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_name.text.trim().isEmpty ||
        _ref.text.trim().isEmpty ||
        _secret.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.merchantFormIncomplete)));
      return;
    }
    final isPhonePe = _provider == 'phonepe';
    final code =
        await ref.read(merchantSoundboxProvider.notifier).registerAndPair(
              businessName: _name.text.trim(),
              provider: _provider,
              merchantRef: _ref.text.trim(),
              vpa: _vpa.text.trim().isEmpty ? null : _vpa.text.trim(),
              phonepeSaltKey: isPhonePe ? _secret.text.trim() : null,
              phonepeSaltIndex: isPhonePe ? _saltIndex.text.trim() : null,
              paytmWebhookToken: isPhonePe ? null : _secret.text.trim(),
            );
    if (!mounted) return;
    if (code != null) {
      setState(() {
        _pairingCode = code;
        _secret.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(merchantSoundboxProvider);
    final isPhonePe = _provider == 'phonepe';
    final callback = SupabaseConfig
        .rpc(isPhonePe ? 'phonepe_webhook' : 'paytm_webhook')
        .toString();

    return DetailScaffold(
      title: l10n.merchantOnboardingTitle,
      subtitle: l10n.merchantOnboardingSubtitle,
      fallbackLocation: AppPaths.soundbox,
      isDirty: () => _dirty,
      actions: [
        NeuIconButton(
          icon: Icons.help_outline_rounded,
          label: l10n.helpTitle,
          iconColor: NeuColors.ink,
          onPressed: () => context.push(AppRoutes.help()),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.merchantStepsHint,
                    style: TextStyle(
                        fontSize: 14, color: NeuColors.inkSoft)),
                const SizedBox(height: 12),
                NeuButton(
                  onPressed: () => context.push(AppRoutes.help()),
                  child: Text(l10n.howToGetBusinessUpi,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.accentDark)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_pairingCode != null) ...[
            NeuBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.merchantRegistered,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: NeuColors.ink)),
                  const SizedBox(height: 8),
                  Text(l10n.pairingCodeSaveHint,
                      style: TextStyle(
                          fontSize: 14, color: NeuColors.inkSoft)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_pairingCode!,
                            style: TextStyle(
                                fontSize: 26,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w800,
                                color: NeuColors.accentDark)),
                      ),
                      NeuIconButton(
                        icon: Icons.copy_rounded,
                        label: l10n.copy,
                        iconColor: NeuColors.ink,
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _pairingCode!));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.copied)));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.callbackUrlLabel,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.ink)),
                  const SizedBox(height: 4),
                  SelectableText(callback,
                      style: TextStyle(
                          fontSize: 12, color: NeuColors.inkSoft)),
                  const SizedBox(height: 12),
                  NeuButton(
                    onPressed: () => context.go(AppRoutes.soundbox()),
                    child: Text(l10n.backToSoundbox,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.provider,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final p in const ['phonepe', 'paytm']) ...[
                      Expanded(
                        child: NeuButton(
                          color: _provider == p ? NeuColors.inset : null,
                          onPressed: () => setState(() => _provider = p),
                          child: Text(
                            p == 'phonepe'
                                ? l10n.providerPhonePe
                                : l10n.providerPaytm,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: _provider == p
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: _provider == p
                                    ? NeuColors.accentDark
                                    : NeuColors.inkSoft),
                          ),
                        ),
                      ),
                      if (p == 'phonepe') const SizedBox(width: 10),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                _Label(text: l10n.businessName),
                NeuField(controller: _name, hint: l10n.businessNameHint),
                const SizedBox(height: 14),
                _Label(text: l10n.businessVpa),
                NeuField(
                    controller: _vpa,
                    hint: l10n.businessVpaHint,
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 14),
                _Label(text: l10n.merchantIdLabel),
                NeuField(controller: _ref, hint: l10n.merchantIdHint),
                const SizedBox(height: 14),
                _Label(
                    text: isPhonePe ? l10n.saltKeyLabel : l10n.webhookTokenLabel),
                NeuField(
                    controller: _secret,
                    hint: isPhonePe
                        ? l10n.saltKeyHint
                        : l10n.webhookTokenHint),
                if (isPhonePe) ...[
                  const SizedBox(height: 14),
                  _Label(text: l10n.saltIndexLabel),
                  NeuField(
                      controller: _saltIndex,
                      keyboard: TextInputType.number),
                ],
                const SizedBox(height: 10),
                Text(l10n.secretStorageNote,
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.inkSoft)),
                const SizedBox(height: 16),
                if (state.pairing)
                  const NeuLoader()
                else
                  NeuButton(
                    onPressed: _submit,
                    child: Text(l10n.registerBusiness,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: NeuColors.accentDark)),
                  ),
                if (state.lastError != null) ...[
                  const SizedBox(height: 10),
                  Text(state.lastError!,
                      style: TextStyle(
                          fontSize: 13, color: NeuColors.danger)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: NeuColors.ink)),
      );
}
