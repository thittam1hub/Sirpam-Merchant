import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../staff/application/staff_controller.dart';
import '../application/access_controller.dart';
import '../domain/role.dart';

/// Owner controls for the shared shop phone: turn access control on, set the
/// owner PIN, choose the auto-lock time, and give each worker a role and PIN.
class AccessPage extends ConsumerStatefulWidget {
  const AccessPage({super.key});

  @override
  ConsumerState<AccessPage> createState() => _AccessPageState();
}

class _AccessPageState extends ConsumerState<AccessPage> {
  final _ownerPin = TextEditingController();
  final _idle = TextEditingController();

  @override
  void dispose() {
    _ownerPin.dispose();
    _idle.dispose();
    super.dispose();
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _saveOwnerPin() async {
    final ok =
        await ref.read(accessProvider.notifier).setOwnerPin(_ownerPin.text);
    if (!mounted) return;
    _ownerPin.clear();
    _toast(ok ? context.l10n.accessPinSaved : context.l10n.accessPinInvalid);
  }

  Future<void> _assign(String workerId) async {
    final state = ref.read(accessProvider);
    final roles = state.activeRoles;
    final pin = TextEditingController();
    var roleId = ref
            .read(staffProvider)
            .workers
            .where((w) => w.id == workerId)
            .firstOrNull
            ?.roleId ??
        '';
    final l10n = context.l10n;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) => AlertDialog(
          backgroundColor: NeuColors.surface,
          title: Text(l10n.accessAssignTitle),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            for (final r in roles)
              ListTile(
                leading: Icon(
                    r.id == roleId
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: r.id == roleId
                        ? NeuColors.accentDark
                        : NeuColors.inkSoft),
                title: Text(r.name),
                onTap: () => setInner(() => roleId = r.id),
              ),

            if (roles.isEmpty)
              Text(l10n.rolesEmpty,
                  style: TextStyle(color: NeuColors.inkSoft)),
            const SizedBox(height: 8),
            NeuField(
                controller: pin,
                keyboard: TextInputType.number,
                obscure: true,
                hint: l10n.accessWorkerPin),

          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.discardKeep)),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.save)),
          ],
        ),
      ),
    );
    if (saved != true) return;
    final worker =
        ref.read(staffProvider).workers.where((w) => w.id == workerId).first;
    await ref.read(staffProvider.notifier).saveWorker(
          id: worker.id,
          name: worker.name,
          phone: worker.phone,
          role: worker.role,
          roleId: roleId,
          dailyWagePaise: worker.dailyWagePaise,
          active: worker.active,
        );
    var pinOk = true;
    if (pin.text.trim().isNotEmpty) {
      pinOk = await ref
          .read(accessProvider.notifier)
          .setWorkerPin(worker.id, pin.text);
    }
    if (!mounted) return;
    _toast(pinOk ? context.l10n.accessSaved : context.l10n.accessPinInvalid);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(accessProvider);
    final staff = ref.watch(staffProvider);
    if (_idle.text.isEmpty) _idle.text = '${state.settings.idleMinutes}';

    return DetailScaffold(
      title: l10n.accessTitle,
      subtitle: l10n.accessSubtitle,
      fallbackLocation: AppPaths.staff,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.accessEnable,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NeuColors.ink)),
                    Text(l10n.accessEnableHint,
                        style: TextStyle(
                            fontSize: 12, color: NeuColors.inkSoft)),
                  ],
                ),
              ),
              Switch(
                value: state.settings.enabled,
                activeThumbColor: NeuColors.accentDark,
                onChanged: state.settings.hasOwnerPin
                    ? (v) => ref.read(accessProvider.notifier).setEnabled(v)
                    : (_) => _toast(l10n.accessNeedsOwnerPin),
              ),
            ]),
          ),
          SectionTitle(l10n.accessOwnerPin),
          LabeledField(
              label: state.settings.hasOwnerPin
                  ? l10n.accessOwnerPinChange
                  : l10n.accessOwnerPinSet,
              controller: _ownerPin,
              obscure: true,
              keyboard: TextInputType.number),

          NeuTextButton(
              label: l10n.save,
              color: NeuColors.accentDark,
              onPressed: _saveOwnerPin),
          SectionTitle(l10n.accessAutoLock),
          LabeledField(
              label: l10n.accessIdleMinutes,
              controller: _idle,
              keyboard: TextInputType.number,
              onChanged: (v) => ref
                  .read(accessProvider.notifier)
                  .setIdleMinutes(int.tryParse(v.trim()) ?? 10)),
          SectionTitle(l10n.rolesTitle),
          NeuTextButton(
              label: l10n.rolesOpen,
              onPressed: () => context.push(AppRoutes.roles())),
          SectionTitle(l10n.accessWorkers),
          if (staff.active.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: Text(l10n.accessNoWorkers,
                      style: TextStyle(color: NeuColors.inkSoft))),
            ),
          for (final w in staff.active)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeuButton(
                onPressed: () => _assign(w.id),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink)),
                        Text(
                            state.roleById(w.roleId)?.name ??
                                l10n.accessNoRole,
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
                  StatusPill(w.pinHash.isEmpty
                      ? l10n.accessPinMissing
                      : l10n.accessPinSet),
                ]),
              ),
            ),
          SectionTitle(l10n.auditTitle),
          NeuTextButton(
              label: l10n.auditOpen,
              onPressed: () => context.push(AppRoutes.audit())),
          if (state.session != null) ...[
            const SizedBox(height: 18),
            NeuTextButton(
              label: l10n.accessEndShift,
              color: NeuColors.warn,
              onPressed: () => ref.read(accessProvider.notifier).endShift(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Lock screen: pick your name, type your PIN, and the shift is yours.
class ShiftLockView extends ConsumerStatefulWidget {
  const ShiftLockView({super.key});

  @override
  ConsumerState<ShiftLockView> createState() => _ShiftLockViewState();
}

class _ShiftLockViewState extends ConsumerState<ShiftLockView> {
  final _pin = TextEditingController();
  String _workerId = ShopRole.ownerId;
  String _error = '';

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final notifier = ref.read(accessProvider.notifier);
    final ok = _workerId == ShopRole.ownerId
        ? await notifier.startOwnerShift(_pin.text)
        : await notifier.startShift(_workerId, _pin.text);
    if (!mounted) return;
    setState(() => _error = ok ? '' : context.l10n.accessWrongPin);
    if (ok) _pin.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final workers = ref.watch(staffProvider).active;

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: NeuBox(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(l10n.lockTitle,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: NeuColors.ink)),
                  const SizedBox(height: 4),
                  Text(l10n.lockSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: NeuColors.inkSoft)),
                  const SizedBox(height: 16),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final w in [null, ...workers])
                      NeuButton(
                        onPressed: () => setState(
                            () => _workerId = w?.id ?? ShopRole.ownerId),
                        child: Text(w?.name ?? l10n.roleOwner,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: (w?.id ?? ShopRole.ownerId) == _workerId
                                    ? NeuColors.accentDark
                                    : NeuColors.inkSoft)),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  NeuField(
                      controller: _pin,
                      keyboard: TextInputType.number,
                      obscure: true,
                      hint: l10n.lockPin),
                  if (_error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(_error,
                        style: TextStyle(color: NeuColors.warn)),
                  ],
                  const SizedBox(height: 16),
                  NeuTextButton(
                      label: l10n.lockUnlock,
                      color: NeuColors.accentDark,
                      onPressed: _unlock),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
