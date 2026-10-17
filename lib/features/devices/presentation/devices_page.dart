import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/qr/qr_payloads.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/qr_scan_sheet.dart';
import '../../access/application/access_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../plan/application/plan_controller.dart';
import '../../plan/domain/plan.dart';
import '../../settings/presentation/settings_widgets.dart';
import '../application/device_controller.dart';
import '../domain/device_link.dart';

/// Multi-device hub.
///
/// Owner view (this phone holds the shop key): mint a pairing code, see the
/// phones on the shop, revoke one. Staff view: pair this phone with the code
/// the owner read out. `/devices?pair=1` opens the pairing form directly.
class DevicesPage extends ConsumerStatefulWidget {
  final bool startPairing;
  const DevicesPage({super.key, this.startPairing = false});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  final _slug = TextEditingController();
  final _code = TextEditingController();
  final _label = TextEditingController();
  DeviceRole _role = DeviceRole.counter;
  bool _busy = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    final shop = ref.read(shopConfigProvider);
    _slug.text = shop.slug;
    Future.microtask(() => ref.read(deviceProvider.notifier).refreshDevices());
  }

  @override
  void dispose() {
    _slug.dispose();
    _code.dispose();
    _label.dispose();
    super.dispose();
  }

  Future<void> _mintCode() async {
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      await ref.read(deviceProvider.notifier).createCode(
            label: _label.text.trim().isEmpty ? 'Staff phone' : _label.text.trim(),
            role: _role,
          );
    } on Exception catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Proves the shop still accepts this phone's key — the one check a waiter
  /// can run before the rush instead of discovering a revoked phone mid-order.
  Future<void> _testConnection() async {
    setState(() {
      _busy = true;
      _error = '';
    });
    final ok = await ref.read(deviceProvider.notifier).ping();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            ok ? context.l10n.devicesTestOk : context.l10n.devicesTestFailed)));
  }

  /// Reads the owner's pairing QR so a new phone types nothing.
  Future<void> _scanPairing() async {
    final l10n = context.l10n;
    final raw = await scanCode(context, title: l10n.devicesScanQr);
    if (raw == null || !mounted) return;
    final scan = QrPayloads.parsePairing(raw);
    if (scan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.devicesScanInvalid)));
      return;
    }
    setState(() {
      _slug.text = scan.slug;
      _code.text = scan.code;
      _role = deviceRoleFrom(scan.role);
    });
    await _pair();
  }

  Future<void> _pair() async {
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      final link = await ref.read(deviceProvider.notifier).pair(
            slug: _slug.text,
            code: _code.text,
            label: _label.text,
            role: _role,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.devicesPairSuccess)));
      context.go(link.homePath);
    } on Exception catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _roleLabel(AppLocalizations l10n, DeviceRole r) => switch (r) {
        DeviceRole.waiter => l10n.devicesRoleWaiter,
        DeviceRole.kitchen => l10n.devicesRoleKitchen,
        DeviceRole.counter => l10n.devicesRoleCounter,
      };

  /// Owner points one paired phone at a staff role, so the shop — not the
  /// phone — decides what that waiter or counter may do.
  Future<void> _pickRole(PairedDevice device) async {
    final l10n = context.l10n;
    final roles = [
      for (final r in ref.read(accessProvider).roles)
        if (r.active && !r.isOwner) r,
    ];
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: NeuColors.canvas,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          children: [
            Text(l10n.devicesRolePick,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ListTile(
              title: Text(l10n.devicesRoleDefault),
              trailing: device.roleId.isEmpty
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.of(sheet).pop(''),
            ),
            for (final r in roles)
              ListTile(
                title: Text(r.name),
                subtitle: r.note.isEmpty ? null : Text(r.note),
                trailing: device.roleId == r.id
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(sheet).pop(r.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    final role = roles.where((r) => r.id == picked).firstOrNull;
    setState(() => _busy = true);
    final ok = await ref.read(deviceProvider.notifier).assignRole(
          deviceId: device.id,
          roleId: role?.id ?? '',
          roleName: role?.name ?? '',
        );
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(ok ? l10n.devicesRoleSaved : l10n.devicesRoleFailed)));
  }


  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shop = ref.watch(shopConfigProvider);
    final devices = ref.watch(deviceProvider);
    final isPro = ref.watch(planAllowsProvider(PlanFeature.liveSync));
    final isOwner = shop.cloudReady && !devices.paired;

    return DetailScaffold(
      title: l10n.devicesTitle,
      fallbackLocation: AppPaths.settings,
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
        children: [
          ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (devices.paired) _pairedCard(l10n, devices.link),
                if (devices.paired) const SizedBox(height: 14),
                if (isOwner) ..._ownerCards(l10n, devices, isPro, shop.slug),
                if (!devices.paired) ...[
                  const SizedBox(height: 14),
                  _pairCard(l10n),
                ],
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error,
                        style: TextStyle(
                            fontSize: 13, color: NeuColors.danger)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pairedCard(AppLocalizations l10n, DeviceLink link) {
    return SettingsCard(
      children: [
        Text(l10n.devicesPairedAs(_roleLabel(l10n, link.role), link.shopName),
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        NeuButton(
          onPressed: _busy ? () {} : _testConnection,
          minHeight: 46,
          radius: NeuTheme.radiusWell,
          child: Text(l10n.devicesTest,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.accentDark)),
        ),
        NeuButton(
          onPressed: () async {
            await ref.read(deviceProvider.notifier).unpair();
            if (mounted) setState(() {});
          },
          minHeight: 46,
          radius: NeuTheme.radiusWell,
          child: Text(l10n.devicesUnpair,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: NeuColors.danger)),
        ),
      ],
    );
  }

  List<Widget> _ownerCards(AppLocalizations l10n, DeviceState devices,
      bool isPro, String shopSlug) {
    if (!isPro) {
      return [
        SettingsCard(
          children: [
            Text(l10n.devicesProRequired,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
            NeuButton(
              onPressed: () => context.push(AppRoutes.plan()),
              minHeight: 46,
              radius: NeuTheme.radiusWell,
              child: Text(l10n.planTitle,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.accentDark)),
            ),
          ],
        ),
      ];
    }
    final code = devices.lastCode;
    final codeLive = code != null && !code.expired(DateTime.now());
    return [
      SettingsCard(
        children: [
          Text(l10n.devicesNewCode,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          SettingsField(
            label: l10n.devicesLabel,
            controller: _label,
          ),
          SettingsSegmented<DeviceRole>(
            options: [
              (DeviceRole.waiter, l10n.devicesRoleWaiter),
              (DeviceRole.kitchen, l10n.devicesRoleKitchen),
              (DeviceRole.counter, l10n.devicesRoleCounter),
            ],
            value: _role,
            onChanged: (v) => setState(() => _role = v),
          ),
          if (codeLive)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code.code));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.copied)));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: NeuColors.inset,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: NeuTheme.recessed(blur: 8, dist: 3),
                ),
                child: Column(
                  children: [
                    BarcodeView.qr(
                      data: QrPayloads.pairing(
                        slug: shopSlug,
                        code: code.code,
                        role: code.role.name,
                      ),
                      size: 160,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.devicesPairQrHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.5, color: NeuColors.inkSoft)),
                    const SizedBox(height: 8),
                    Text(code.code,
                        style: TextStyle(
                            fontSize: 34,
                            letterSpacing: 8,
                            fontWeight: FontWeight.w900,
                            color: NeuColors.accentDark)),
                    const SizedBox(height: 4),
                    Text(l10n.devicesCodeExpires,
                        style: TextStyle(
                            fontSize: 12.5, color: NeuColors.inkSoft)),
                  ],
                ),
              ),
            ),
          NeuButton(
            onPressed: _busy ? () {} : _mintCode,
            minHeight: 50,
            radius: NeuTheme.radiusWell,
            child: Text(l10n.devicesNewCode,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.accentDark)),
          ),
        ],
      ),
      const SizedBox(height: 14),
      SettingsCard(
        children: [
          Text(l10n.devicesList,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          if (devices.devices.isEmpty)
            Text(l10n.devicesEmpty,
                style:
                    TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
          for (final d in devices.devices)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.label.isEmpty ? '—' : d.label,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700)),
                            Text(
                              '${_roleLabel(l10n, d.role)} · '
                              '${!d.active ? l10n.devicesRevoked : d.online(DateTime.now()) ? l10n.devicesOnline : l10n.devicesOffline}',
                              style: TextStyle(
                                  fontSize: 12.5, color: NeuColors.inkSoft),
                            ),
                          ],
                        ),
                      ),
                      if (d.active)
                        NeuButton(
                          onPressed: () =>
                              ref.read(deviceProvider.notifier).revoke(d.id),
                          minHeight: 40,
                          radius: 20,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          child: Text(l10n.devicesRevoke,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: NeuColors.danger)),
                        ),
                    ],
                  ),
                  if (d.active) ...[
                    const SizedBox(height: 8),
                    NeuButton(
                      onPressed: _busy ? () {} : () => _pickRole(d),
                      minHeight: 42,
                      radius: NeuTheme.radiusWell,
                      child: Text(
                        '${l10n.devicesStaffRole}: '
                        '${d.roleName.isEmpty ? l10n.devicesRoleDefault : d.roleName}',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark),
                      ),
                    ),
                  ],
                ],
              ),
            ),

        ],
      ),
    ];
  }

  Widget _pairCard(AppLocalizations l10n) {
    return SettingsCard(
      children: [
        Text(l10n.devicesPairThis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        NeuButton(
          onPressed: _busy ? () {} : _scanPairing,
          minHeight: 46,
          radius: NeuTheme.radiusWell,
          child: Text(l10n.devicesScanQr,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.accentDark)),
        ),
        SettingsField(label: l10n.devicesShopSlug, controller: _slug),
        SettingsField(
          label: l10n.devicesEnterCode,
          controller: _code,
          keyboard: TextInputType.number,
        ),
        SettingsField(label: l10n.devicesLabel, controller: _label),
        SettingsSegmented<DeviceRole>(
          options: [
            (DeviceRole.waiter, l10n.devicesRoleWaiter),
            (DeviceRole.kitchen, l10n.devicesRoleKitchen),
            (DeviceRole.counter, l10n.devicesRoleCounter),
          ],
          value: _role,
          onChanged: (v) => setState(() => _role = v),
        ),
        NeuButton(
          onPressed: _busy ? () {} : _pair,
          minHeight: 50,
          radius: NeuTheme.radiusWell,
          child: Text(l10n.devicesPairButton,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: NeuColors.accentDark)),
        ),
      ],
    );
  }
}
