import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../application/location_controller.dart';

class LocationPage extends ConsumerStatefulWidget {
  /// `/location?share=1` starts broadcasting immediately (deep link/shortcut).
  final bool autoShare;
  const LocationPage({super.key, this.autoShare = false});

  @override
  ConsumerState<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  @override
  void initState() {
    super.initState();
    if (widget.autoShare) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationProvider.notifier).start();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(locationProvider);
    final settings = ref.watch(settingsProvider);
    final live = s.status == BroadcastStatus.live;

    return DetailScaffold(
      title: l10n.menuCartLocation,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          NeuBox(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    if (live) const BreathingDot() else
                      Icon(Icons.location_off_outlined,
                          size: 14, color: NeuColors.inkSoft),
                    const SizedBox(width: 10),
                    Text(
                      switch (s.status) {
                        BroadcastStatus.live => l10n.broadcastLive,
                        BroadcastStatus.requesting => l10n.locationSearching,
                        BroadcastStatus.denied => l10n.permissionDenied,
                        BroadcastStatus.unavailable => l10n.unavailable,
                        BroadcastStatus.off => l10n.broadcastStopped,
                      },
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.ink),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (s.position != null) ...[
                  Text(
                    '${s.position!.lat.toStringAsFixed(5)}, ${s.position!.lng.toStringAsFixed(5)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.ink),
                  ),
                  Text(
                    '±${s.position!.accuracy.round()} m · ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(s.position!.ts))}',
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.inkSoft),
                  ),
                ] else
                  Text(l10n.locationNotFetched,
                      style: TextStyle(
                          fontSize: 14, color: NeuColors.inkSoft)),
                if (s.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(s.error!.resolve(l10n),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, color: NeuColors.danger)),
                  ),
                const SizedBox(height: 18),
                NeuButton(
                  onPressed: () => live
                      ? ref.read(locationProvider.notifier).stop()
                      : ref.read(locationProvider.notifier).start(),
                  child: Text(live ? l10n.stopBroadcast : l10n.startBroadcast,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color:
                              live ? NeuColors.danger : NeuColors.accentDark)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          NeuBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sendToCustomer,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.ink)),
                const SizedBox(height: 6),
                Text(
                    l10n.shareLocationHint,
                    style: TextStyle(fontSize: 14, color: NeuColors.inkSoft)),
                const SizedBox(height: 14),
                NeuButton(
                  onPressed: s.position == null
                      ? null
                      : () {
                          final stall = settings.stallName.isEmpty
                              ? l10n.ourCart
                              : settings.stallName;
                          launchUrl(
                            ShareLinks.whatsapp(
                              message:
                                  l10n.cartLocationMessage(
                                      stall, s.position!.mapsUrl),
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                  child: Text(l10n.shareOnWhatsapp,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.accentDark)),
                ),
                const SizedBox(height: 10),
                NeuButton(
                  onPressed: s.position == null
                      ? null
                      : () => launchUrl(Uri.parse(s.position!.mapsUrl),
                          mode: LaunchMode.externalApplication),
                  child: Text(l10n.openInMaps,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: NeuColors.ink)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
