import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../ledger/application/ledger_controller.dart';

class UdhaarPage extends ConsumerWidget {
  /// `/udhaar?customer=Ravi` focuses a single customer (shareable deep link).
  final String focusCustomer;
  const UdhaarPage({super.key, this.focusCustomer = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final settings = ref.watch(settingsProvider);
    final focus = focusCustomer.toLowerCase();
    final balances = ledger.udhaarBalances.entries
        .where((e) => focus.isEmpty || e.key.toLowerCase().contains(focus))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(
          title: l10n.udhaarTitle, subtitle: l10n.udhaarSubtitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(l10n.totalOutstanding,
                    style: TextStyle(fontSize: 15, color: NeuColors.inkSoft)),
                const SizedBox(height: 4),
                AnimatedMoney(ledger.totalUdhaarPaise / 100,
                    style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.warn)),
                const SizedBox(height: 4),
                Text(l10n.customerCount(balances.length),
                    style: TextStyle(
                        fontSize: 14, color: NeuColors.inkSoft)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (focusCustomer.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NeuBox(
                inset: true,
                child: Row(children: [
                  Icon(Icons.filter_alt_outlined,
                      color: NeuColors.inkSoft),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l10n.filterBy(focusCustomer),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: NeuColors.ink)),
                  ),
                  NeuIconButton(
                    icon: Icons.close_rounded,
                    label: l10n.clearFilter,
                    size: 46,
                    iconSize: 22,
                    iconColor: NeuColors.inkSoft,
                    onPressed: () => context.replace(AppRoutes.udhaar()),
                  ),
                ]),
              ),
            ),
          if (!settings.isConfigured)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NeuBox(
                inset: true,
                child: Row(children: [
                  Icon(Icons.info_outline, color: NeuColors.warn),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l10n.upiSetupHint,
                        style: TextStyle(
                            fontSize: 14, color: NeuColors.ink)),
                  ),
                ]),
              ),
            ),
          if (balances.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                  child: Text(l10n.noOutstanding,
                      style: TextStyle(
                          color: NeuColors.inkSoft, fontSize: 15))),
            )
          else
            ...balances.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CustomerCard(
                      name: e.key, paise: e.value, settings: settings),
                )),
        ],
      ),
    );
  }
}

class _CustomerCard extends ConsumerWidget {
  final String name;
  final int paise;
  final VendorSettings settings;
  const _CustomerCard(
      {required this.name, required this.paise, required this.settings});

  Future<void> _open(BuildContext context, Uri uri) async {
    final l10n = context.l10n;
    unawaited(HapticFeedback.mediumImpact());
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cannotOpen(uri.scheme))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rupees = paise / 100.0;
    final payeeName =
        settings.stallName.isEmpty ? l10n.defaultStallName : settings.stallName;

    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
              ),
              AnimatedMoney(rupees,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.warn)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: NeuButton(
                  onPressed: settings.upiVpa.isEmpty
                      ? null
                      : () => _open(
                          context,
                          ShareLinks.upiPay(
                            vpa: settings.upiVpa,
                            payeeName: payeeName,
                            amountRupees: rupees,
                            note: l10n.creditNote(name),
                          )),
                  child: Text(l10n.askUpi,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.upi)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NeuButton(
                  onPressed: () {
                    final link = settings.upiVpa.isEmpty
                        ? ''
                        : '\n${ShareLinks.upiPay(vpa: settings.upiVpa, payeeName: payeeName, amountRupees: rupees, note: l10n.creditNote(name))}';
                    _open(
                      context,
                      ShareLinks.whatsapp(
                        message:
                            l10n.udhaarReminderMessage(name, payeeName,
                                rupees.toStringAsFixed(2), link),
                      ),
                    );
                  },
                  child: Text(l10n.whatsapp,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.accentDark)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NeuButton(
                  onPressed: () => context.push(AppRoutes.settle(name)),
                  child: Text(l10n.collect,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.ink)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
