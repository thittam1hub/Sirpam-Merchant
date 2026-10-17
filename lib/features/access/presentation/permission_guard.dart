import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';

import '../../products/presentation/inventory_widgets.dart';
import '../application/access_controller.dart';
import '../domain/permission.dart';
import 'roles_page.dart' show permissionLabel;

/// Result of asking for permission before a sensitive action runs.
enum GuardOutcome { allowed, approvedByOwner, denied }

extension GuardOutcomeX on GuardOutcome {
  bool get ok => this != GuardOutcome.denied;
}

/// The single place the app asks "is this worker allowed to do that?".
///
/// It keeps three industry-standard behaviours together so no screen has to
/// re-invent them: least privilege (blocked by default), an owner override
/// that needs the owner's own PIN, and an append-only audit line for every
/// sensitive action — allowed or overridden.
extension PermissionGuardRef on WidgetRef {
  Future<GuardOutcome> guard(
    BuildContext context,
    Permission permission, {
    int amountPaise = 0,
    String? action,
    String refType = '',
    String refId = '',
    String note = '',
    bool audit = true,
  }) async {
    final controller = read(accessProvider.notifier);
    await controller.touch();
    final state = read(accessProvider);
    final label = action ?? permission.name;

    if (!state.settings.enabled) return GuardOutcome.allowed;

    if (state.canAmount(permission, amountPaise)) {
      if (audit && !state.isOwnerShift) {
        await controller.record(
            action: label,
            amountPaise: amountPaise,
            refType: refType,
            refId: refId,
            note: note);
      }
      return GuardOutcome.allowed;
    }

    if (!context.mounted) return GuardOutcome.denied;
    final overLimit = state.can(permission);
    final pin = await showOwnerApprovalSheet(
      context,
      permission: permission,
      overLimit: overLimit,
      amountPaise: amountPaise,
    );
    if (pin == null || !context.mounted) return GuardOutcome.denied;

    final approved = await controller.approveWithOwnerPin(
      pin: pin,
      action: label,
      amountPaise: amountPaise,
      refType: refType,
      refId: refId,
      note: note,
    );
    if (!context.mounted) return approved ? GuardOutcome.approvedByOwner : GuardOutcome.denied;
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(approved ? l10n.approvalGranted : l10n.approvalWrongPin)));
    return approved ? GuardOutcome.approvedByOwner : GuardOutcome.denied;
  }

  /// Read-only check for hiding controls the current role cannot use.
  bool allows(Permission permission) => watch(canProvider(permission));
}

/// Owner override: the owner types their own PIN so one blocked action can go
/// through, and the approval is written into the trail.
Future<String?> showOwnerApprovalSheet(
  BuildContext context, {
  required Permission permission,
  bool overLimit = false,
  int amountPaise = 0,
}) {
  final pin = TextEditingController();
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final l10n = ctx.l10n;
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16),
        child: NeuBox(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(l10n.approvalTitle),
            Text(
              overLimit
                  ? l10n.approvalOverLimit(permissionLabel(ctx, permission))
                  : l10n.approvalNeeded(permissionLabel(ctx, permission)),
              style: TextStyle(color: NeuColors.inkSoft),
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: l10n.approvalOwnerPin,
              controller: pin,
              keyboard: TextInputType.number,
              obscure: true,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            ActionRow(children: [
              NeuTextButton(
                  label: l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop()),
              NeuTextButton(
                  label: l10n.approvalApprove,
                  color: NeuColors.accentDark,
                  onPressed: () => Navigator.of(ctx).pop(pin.text.trim())),
            ]),
          ]),
        ),
      );
    },
  ).whenComplete(pin.dispose);
}

/// Hides a control the current role has no business seeing. Least privilege
/// beats a dead button: workers never tap something that only fails.
class PermissionGate extends ConsumerWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(canProvider(permission))
          ? child
          : (fallback ?? const SizedBox.shrink());
}

/// Full-screen stop for a route the current role cannot open.
class PermissionDeniedView extends StatelessWidget {
  final Permission permission;
  const PermissionDeniedView({super.key, required this.permission});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: l10n.approvalBlockedTitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        children: [
          NeuBox(
            inset: true,
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
            child: Column(children: [
              Icon(Icons.lock_outline_rounded,
                  size: 34, color: NeuColors.inkSoft),
              const SizedBox(height: 10),
              Text(
                  l10n.approvalBlockedBody(
                      permissionLabel(context, permission)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NeuColors.inkSoft)),
            ]),
          ),
        ],
      ),
    );

  }
}
