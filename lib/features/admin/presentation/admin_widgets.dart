import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../domain/admin_reports.dart';

/// Day / week / month switch shared by every owner report.
class AdminPeriodBar extends StatelessWidget {
  final AdminPeriod period;
  final ValueChanged<AdminPeriod> onChanged;

  const AdminPeriodBar({
    super.key,
    required this.period,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(AdminPeriod p) => switch (p) {
          AdminPeriod.day => l10n.windowDay,
          AdminPeriod.week => l10n.windowWeek,
          AdminPeriod.month => l10n.windowMonth,
        };
    return Row(children: [
      for (final p in AdminPeriod.values) ...[
        Expanded(
          child: NeuButton(
            selected: period == p,
            minHeight: 44,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            onPressed: () => onChanged(p),
            child: Text(
              label(p),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: period == p ? NeuColors.accentDark : NeuColors.inkSoft,
              ),
            ),
          ),
        ),
        if (p != AdminPeriod.values.last) const SizedBox(width: 8),
      ],
    ]);
  }
}

/// Label on the left, number on the right — the whole owner reporting UI.
class AdminStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const AdminStatRow(this.label, this.value, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(label,
                  style: TextStyle(color: NeuColors.inkSoft, fontSize: 13)),
            ),
            const SizedBox(width: 10),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? NeuColors.ink)),
          ],
        ),
      );
}

class AdminEmpty extends StatelessWidget {
  const AdminEmpty({super.key});

  @override
  Widget build(BuildContext context) => NeuBox(
        inset: true,
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Center(
          child: Text(context.l10n.adminNoRows,
              style: TextStyle(color: NeuColors.inkSoft)),
        ),
      );
}
