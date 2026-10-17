import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../staff/application/staff_controller.dart';
import '../application/access_controller.dart';

/// Append-only trail: who did what, when, and whether the owner approved it.
class AuditPage extends ConsumerStatefulWidget {
  final String workerId;
  final String dayKey;
  const AuditPage({super.key, this.workerId = '', this.dayKey = ''});

  @override
  ConsumerState<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends ConsumerState<AuditPage> {
  late String _worker = widget.workerId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(accessProvider);
    final workers = ref.watch(staffProvider).workers;
    final rows = state.auditFor(workerId: _worker, dayKey: widget.dayKey);

    return DetailScaffold(
      title: l10n.auditTitle,
      subtitle: l10n.auditSubtitle,
      fallbackLocation: AppPaths.access,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final entry in [('', l10n.auditEveryone), ...workers.map((w) => (w.id, w.name))])
              NeuButton(
                onPressed: () => setState(() => _worker = entry.$1),
                child: Text(entry.$2,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: entry.$1 == _worker
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 16),
          if (rows.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Center(
                  child: Text(l10n.auditEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            ),
          for (final e in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeuBox(
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.action,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.ink)),
                        Text(
                            '${e.workerName.isEmpty ? l10n.roleOwner : e.workerName} · ${e.dayKey}',
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft)),
                        if (e.note.isNotEmpty)
                          Text(e.note,
                              style: TextStyle(
                                  fontSize: 12, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
                  if (e.approvedBy.isNotEmpty)
                    StatusPill(l10n.auditApproved,
                        color: NeuColors.accentDark),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
