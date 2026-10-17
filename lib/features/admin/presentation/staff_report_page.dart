import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../access/application/access_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../domain/admin_reports.dart';
import 'admin_widgets.dart';

/// Per-person scoreboard for the period: how much they billed around, what
/// they discounted, and how often the owner had to approve for them.
class StaffReportPage extends ConsumerStatefulWidget {
  const StaffReportPage({super.key});

  @override
  ConsumerState<StaffReportPage> createState() => _StaffReportPageState();
}

class _StaffReportPageState extends ConsumerState<StaffReportPage> {
  AdminPeriod _period = AdminPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final access = ref.watch(accessProvider);
    final range = rangeFor(_period, DateTime.now());
    final rows = buildStaffStats(audit: access.audit, range: range);

    String card(StaffStat s) => [
          s.workerName.isEmpty ? l10n.roleOwner : s.workerName,
          '${l10n.adminColActions}: ${s.actions}',
          '${l10n.adminColDiscount}: ${money(s.discountPaise)}',
          '${l10n.adminColCredit}: ${money(s.creditPaise)}',
          '${l10n.adminColVoids}: ${s.voids}',
          '${l10n.adminColOverrides}: ${s.overrides}',
        ].join('\n');

    return DetailScaffold(
      title: l10n.adminStaffTitle,
      subtitle: l10n.adminStaffSubtitle,
      fallbackLocation: AppPaths.admin,
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            AdminPeriodBar(
                period: _period,
                onChanged: (p) => setState(() => _period = p)),
            const SizedBox(height: 16),
            if (rows.isEmpty) const AdminEmpty(),
            for (final s in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                              s.workerName.isEmpty
                                  ? l10n.roleOwner
                                  : s.workerName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: NeuColors.ink)),
                        ),
                        IconButton(
                          tooltip: l10n.adminShare,
                          icon: const Icon(Icons.ios_share_rounded, size: 20),
                          onPressed: () => launchUrl(
                              ShareLinks.whatsapp(message: card(s)),
                              mode: LaunchMode.externalApplication),
                        ),
                      ]),
                      AdminStatRow(l10n.adminColActions, '${s.actions}'),
                      AdminStatRow(
                          l10n.adminColDiscount, money(s.discountPaise)),
                      AdminStatRow(l10n.adminColCredit, money(s.creditPaise)),
                      AdminStatRow(l10n.adminColVoids, '${s.voids}'),
                      AdminStatRow(l10n.adminColReprints, '${s.reprints}'),
                      AdminStatRow(l10n.adminColOverrides, '${s.overrides}',
                          valueColor:
                              s.overrides > 0 ? NeuColors.warn : null),
                      const SizedBox(height: 8),
                      NeuTextButton(
                        label: l10n.adminSeeExceptions,
                        onPressed: () => context
                            .push(AppRoutes.adminExceptions(worker: s.workerId)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
