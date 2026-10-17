import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../application/merchant_soundbox_controller.dart';
import '../application/soundbox_service.dart';

class SoundboxPage extends ConsumerStatefulWidget {
  const SoundboxPage({super.key});
  @override
  ConsumerState<SoundboxPage> createState() => _SoundboxPageState();
}

class _SoundboxPageState extends ConsumerState<SoundboxPage> {
  @override
  void initState() {
    super.initState();
    // Auto-log every announced credit into the ledger.
    ref.read(soundboxProvider.notifier).onCredit = (credit) {
      ref.read(ledgerProvider.notifier).addSale(
            amountPaise: credit.amountPaise,
            mode: SaleMode.upi,
            item: credit.app,
          );
    };
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(soundboxProvider.notifier).refreshPermission());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(soundboxProvider);

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(
          title: l10n.soundboxTitle, subtitle: l10n.soundboxSubtitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          const _ServerSoundboxCard(),
          const SizedBox(height: 18),
          Text(l10n.notificationSoundbox,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.ink)),
          const SizedBox(height: 10),
          if (!s.isNative) _RestrictionBanner(availability: s.availability),
          if (s.isNative) _PermissionCard(granted: s.permissionGranted),
          const SizedBox(height: 18),

          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.watchedApps,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
                const SizedBox(height: 12),
                ...UpiNotificationParser.supportedPackages.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 20, color: NeuColors.upi),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(e.value,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: NeuColors.ink)),
                        ),
                        Text(e.key,
                            style: TextStyle(
                                fontSize: 11, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          NeuBox(
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.soundboxTestHint,
                      style: TextStyle(
                          fontSize: 14, color: NeuColors.ink)),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: NeuButton(
                    onPressed: () =>
                        ref.read(soundboxProvider.notifier).announce(250),
                    child: Text(l10n.speak,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ),
              ],
            ),
          ),
          if (s.lastError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(s.lastError!,
                  style: TextStyle(fontSize: 13, color: NeuColors.danger)),
            ),
          const SizedBox(height: 22),
          Text(l10n.announcedPayments,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.ink)),
          const SizedBox(height: 10),
          if (s.credits.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Center(
                child: Text(l10n.noUpiYet,
                    style: TextStyle(
                        color: NeuColors.inkSoft, fontSize: 15)),
              ),
            )
          else
            ...s.credits.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const BreathingDot(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.app,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: NeuColors.ink)),
                              Text(
                                  DateFormat('h:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(c.ts)),
                                  style: TextStyle(
                                      fontSize: 13, color: NeuColors.inkSoft)),
                            ],
                          ),
                        ),
                        Text('₹${c.rupees.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: NeuColors.upi)),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class _PermissionCard extends ConsumerWidget {
  final bool granted;
  const _PermissionCard({required this.granted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(granted ? Icons.check_circle : Icons.notifications_off,
                  color: granted ? NeuColors.accentDark : NeuColors.warn),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  granted
                      ? l10n.soundboxRunning
                      : l10n.notificationAccessNeeded,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            granted
                ? l10n.soundboxAndroidHint
                : l10n.soundboxGrantHint,
            style: TextStyle(fontSize: 14, color: NeuColors.inkSoft),
          ),
          if (!granted) ...[
            const SizedBox(height: 14),
            NeuButton(
              onPressed: () async {
                await ref
                    .read(soundboxProvider.notifier)
                    .openPermissionSettings();
              },
              child: Text(l10n.grantAccess,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.accentDark)),
            ),
          ],
        ],
      ),
    );
  }
}

class _RestrictionBanner extends StatelessWidget {
  final SoundboxAvailability availability;
  const _RestrictionBanner({required this.availability});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isIos = availability == SoundboxAvailability.iosRestricted;
    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lock_outline, color: NeuColors.warn),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isIos
                    ? l10n.iosUnavailable
                    : l10n.webUnavailable,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.ink),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            isIos
                ? l10n.iosSoundboxNote
                : l10n.webSoundboxNote,
            style: TextStyle(fontSize: 14, color: NeuColors.inkSoft),
          ),
        ],
      ),
    );
  }
}

/// Server-confirmed soundbox: pairing, health and the payment queue.
class _ServerSoundboxCard extends ConsumerStatefulWidget {
  const _ServerSoundboxCard();
  @override
  ConsumerState<_ServerSoundboxCard> createState() =>
      _ServerSoundboxCardState();
}

class _ServerSoundboxCardState extends ConsumerState<_ServerSoundboxCard> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _pair() async {
    final code = _code.text.trim();
    if (code.isEmpty) return;
    final ok =
        await ref.read(merchantSoundboxProvider.notifier).pair(code);
    if (ok) _code.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(merchantSoundboxProvider);
    final notifier = ref.read(merchantSoundboxProvider.notifier);

    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(s.isPaired ? Icons.verified : Icons.cloud_off,
                  color: s.isPaired ? NeuColors.accentDark : NeuColors.warn),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n.serverSoundbox,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.ink)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.serverSoundboxNote,
              style: TextStyle(fontSize: 14, color: NeuColors.inkSoft)),
          const SizedBox(height: 14),
          if (!s.isPaired) ...[
            Text(l10n.notPaired,
                style: TextStyle(fontSize: 14, color: NeuColors.ink)),
            const SizedBox(height: 12),
            NeuField(controller: _code, hint: l10n.pairingCode),
            const SizedBox(height: 12),
            if (s.pairing)
              const NeuLoader()
            else
              NeuButton(
                onPressed: _pair,
                child: Text(l10n.pair,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.accentDark)),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NeuButton(
                    onPressed: () => context.push(AppRoutes.merchant()),
                    child: Text(l10n.registerBusiness,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeuButton(
                    onPressed: () => context.push(AppRoutes.help()),
                    child: Text(l10n.helpTitle,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.inkSoft)),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(l10n.pairedWith(s.merchant!.merchantName),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.ink)),
            const SizedBox(height: 6),
            Text(
              s.lastSyncMs == null
                  ? l10n.neverChecked
                  : l10n.lastChecked(DateFormat('h:mm:ss a').format(
                      DateTime.fromMillisecondsSinceEpoch(s.lastSyncMs!))),
              style: TextStyle(fontSize: 13, color: NeuColors.inkSoft),
            ),
            const SizedBox(height: 6),
            Text(l10n.queuedPayments(s.pending.length),
                style: TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
            if (s.isStale) ...[
              const SizedBox(height: 8),
              Text(l10n.soundboxStale,
                  style:
                      TextStyle(fontSize: 13, color: NeuColors.danger)),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NeuButton(
                    onPressed: notifier.sync,
                    child: Text(l10n.syncNow,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeuButton(
                    onPressed: notifier.unpair,
                    child: Text(l10n.unpair,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.inkSoft)),
                  ),
                ),
              ],
            ),
          ],
          if (s.lastError != null) ...[
            const SizedBox(height: 10),
            Text(s.lastError!,
                style: TextStyle(fontSize: 13, color: NeuColors.danger)),
          ],
        ],
      ),
    );
  }
}
