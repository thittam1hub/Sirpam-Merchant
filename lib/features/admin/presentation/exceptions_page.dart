import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../access/application/access_controller.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/roles_page.dart' show permissionLabel;
import '../../orders/application/order_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../staff/application/staff_controller.dart';
import '../domain/admin_reports.dart';
import 'admin_widgets.dart';

/// Every discount, void, reprint and credit line in one place, with the name
/// of whoever did it — the screen an owner opens when a day feels light.
class ExceptionsPage extends ConsumerStatefulWidget {
  final String workerId;
  const ExceptionsPage({super.key, this.workerId = ''});

  @override
  ConsumerState<ExceptionsPage> createState() => _ExceptionsPageState();
}

class _ExceptionsPageState extends ConsumerState<ExceptionsPage> {
  AdminPeriod _period = AdminPeriod.day;
  late String _worker = widget.workerId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final access = ref.watch(accessProvider);
    final orders = ref.watch(orderProvider);
    final workers = ref.watch(staffProvider).workers;
    final range = rangeFor(_period, DateTime.now());
    final rows = buildExceptions(
      audit: access.audit,
      bills: orders.bills,
      range: range,
      workerId: _worker,
    );
    final time = DateFormat('dd MMM, h:mm a',
        Localizations.localeOf(context).toString());

    String actionLabel(String action) {
      final p = Permission.tryParse(action);
      return p == null ? action : permissionLabel(context, p);
    }

    return DetailScaffold(
      title: l10n.adminExceptionsTitle,
      subtitle: l10n.adminExceptionsSubtitle,
      fallbackLocation: AppPaths.admin,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            AdminPeriodBar(
                period: _period,
                onChanged: (p) => setState(() => _period = p)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final entry in [
                ('', l10n.auditEveryone),
                ...workers.map((w) => (w.id, w.name)),
              ])
                NeuButton(
                  selected: entry.$1 == _worker,
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
            if (rows.isEmpty) const AdminEmpty(),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(actionLabel(r.action),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                          Text(
                            '${r.workerName.isEmpty ? l10n.roleOwner : r.workerName}'
                            ' · ${time.format(DateTime.fromMillisecondsSinceEpoch(r.ts))}',
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft),
                          ),
                          if (r.note.isNotEmpty)
                            Text(r.note,
                                style: TextStyle(
                                    fontSize: 12, color: NeuColors.inkSoft)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (r.amountPaise > 0)
                          Text(money(r.amountPaise),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        const SizedBox(height: 4),
                        if (r.approvedByOwner)
                          StatusPill(l10n.adminOwnerApproved,
                              color: NeuColors.accentDark)
                        else if (r.source == 'bill')
                          StatusPill(l10n.adminFromBill),
                      ],
                    ),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
