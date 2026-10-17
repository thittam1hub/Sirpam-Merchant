import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/label_sheet.dart';
import '../domain/stock_math.dart';
import 'inventory_widgets.dart';

/// The stall's UPI collection QR — static by default, dynamic once an amount
/// is typed. Any UPI app (BHIM, GPay, PhonePe, Paytm) can scan it.
class PaymentQrPage extends ConsumerStatefulWidget {
  final int? amountPaise;
  const PaymentQrPage({super.key, this.amountPaise});

  @override
  ConsumerState<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends ConsumerState<PaymentQrPage> {
  late final TextEditingController _amount = TextEditingController(
      text: widget.amountPaise == null
          ? ''
          : (widget.amountPaise! / 100).toStringAsFixed(2));

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final vpa = settings.upiVpa.trim();

    if (vpa.isEmpty) {
      return DetailScaffold(
        title: l10n.paymentQrTitle,
        subtitle: l10n.paymentQrSubtitle,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: NeuBox(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(l10n.paymentQrNeedVpa,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NeuColors.inkSoft)),
                const SizedBox(height: 16),
                NeuTextButton(
                  label: l10n.paymentQrOpenSettings,
                  color: NeuColors.accentDark,
                  onPressed: () => context.push(AppRoutes.settings()),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    final paise = StockMath.parseMoney(_amount.text);
    final payee = settings.stallName.isEmpty
        ? (settings.ownerName.isEmpty ? 'VendorOS' : settings.ownerName)
        : settings.stallName;
    final uri = ShareLinks.upiCollect(
      vpa: vpa,
      payeeName: payee,
      amountRupees: paise == null ? null : paise / 100,
    );

    return DetailScaffold(
      title: l10n.paymentQrTitle,
      subtitle: l10n.paymentQrSubtitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            child: Column(
              children: [
                BarcodeView.qr(data: uri.toString(), size: 240),
                const SizedBox(height: 14),
                Text(l10n.paymentQrPayingTo(vpa),
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: NeuColors.ink)),
                if (paise != null) ...[
                  const SizedBox(height: 4),
                  Text(money(paise),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: NeuColors.upi)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          NeuField(
            controller: _amount,
            hint: l10n.paymentQrAmountHint,
            prefixText: '₹ ',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          ActionRow(children: [
            NeuTextButton(
              label: l10n.paymentQrCopy,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: uri.toString()));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.paymentQrCopied)));
              },
            ),
            NeuTextButton(
              label: l10n.paymentQrPoster,
              color: NeuColors.accentDark,
              onPressed: () async {
                final bytes = await LabelSheet.paymentPoster(
                  stallName: payee,
                  vpa: vpa,
                  upiUri: uri.toString(),
                  caption: l10n.paymentQrNote,
                );
                await Printing.sharePdf(
                    bytes: bytes, filename: 'vendoros-payment-qr.pdf');
              },
            ),
          ]),
          const SizedBox(height: 16),
          NeuBox(
            inset: true,
            child: Text(l10n.paymentQrNote,
                style: TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
          ),
        ],
      ),
    );
  }
}
