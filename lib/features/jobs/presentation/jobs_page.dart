import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/job_controller.dart';
import '../domain/job.dart';

String jobStatusLabel(BuildContext context, JobStatus s) {
  final l10n = context.l10n;
  return switch (s) {
    JobStatus.taken => l10n.jobStatusTaken,
    JobStatus.making => l10n.jobStatusMaking,
    JobStatus.ready => l10n.jobStatusReady,
    JobStatus.delivered => l10n.jobStatusDelivered,
    JobStatus.cancelled => l10n.jobStatusCancelled,
  };
}

/// Made-to-order work and advance bookings: what is promised, to whom, and
/// for when.
class JobsPage extends ConsumerStatefulWidget {
  final String filter;
  const JobsPage({super.key, this.filter = 'open'});

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends ConsumerState<JobsPage> {
  final _title = TextEditingController();
  final _customer = TextEditingController();
  final _phone = TextEditingController();
  final _price = TextEditingController();
  final _advance = TextEditingController();
  DateTime _due = DateTime.now().add(const Duration(days: 1));
  late String _filter = widget.filter;

  @override
  void dispose() {
    _title.dispose();
    _customer.dispose();
    _phone.dispose();
    _price.dispose();
    _advance.dispose();
    super.dispose();
  }

  int _paise(TextEditingController c) =>
      ((double.tryParse(c.text.trim()) ?? 0) * 100).round();

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _add() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    await ref.read(jobProvider.notifier).save(
          title: title,
          customer: _customer.text.trim(),
          phone: _phone.text.trim(),
          pricePaise: _paise(_price),
          advancePaise: _paise(_advance),
          dueAt: _due.millisecondsSinceEpoch,
        );
    if (!mounted) return;
    _title.clear();
    _customer.clear();
    _phone.clear();
    _price.clear();
    _advance.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _remind(Job job) async {
    final message = context.l10n.jobRemindMessage(
        job.customer.isEmpty ? '' : job.customer, job.title);
    final uri = ShareLinks.whatsapp(message: message, phone: job.phone);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = ref.watch(jobProvider);
    final today = DateTime.now();
    final list = switch (_filter) {
      'today' => [for (final j in all) if (j.open && j.dueOn(today)) j],
      'done' => [for (final j in all) if (!j.open) j],
      _ => [for (final j in all) if (j.open) j],
    }
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    return DetailScaffold(
      title: l10n.jobsTitle,
      subtitle: l10n.jobsSubtitle,
      fallbackLocation: AppPaths.home,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SectionTitle(l10n.jobAdd),
          LabeledField(label: l10n.jobTitleField, controller: _title),
          LabeledField(label: l10n.jobCustomer, controller: _customer),
          LabeledField(
              label: l10n.jobPhone,
              controller: _phone,
              keyboard: TextInputType.phone),
          LabeledField(
              label: l10n.jobPrice,
              controller: _price,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          LabeledField(
              label: l10n.jobAdvance,
              controller: _advance,
              prefixText: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true)),
          const SizedBox(height: 8),
          NeuTextButton(
              label: '${l10n.jobDue}: ${DateFormat('d MMM').format(_due)}',
              onPressed: _pickDue),
          const SizedBox(height: 8),
          NeuTextButton(
              label: l10n.jobAdd,
              color: NeuColors.accentDark,
              onPressed: _add),
          SectionTitle(l10n.jobsTitle),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final f in AppQueryParsing.jobFilters)
              NeuButton(
                selected: f == _filter,
                minHeight: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                onPressed: () => setState(() => _filter = f),
                child: Text(
                    switch (f) {
                      'today' => l10n.jobFilterToday,
                      'done' => l10n.jobFilterDone,
                      _ => l10n.jobFilterOpen,
                    },
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: f == _filter
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft)),
              ),
          ]),
          const SizedBox(height: 12),
          if (list.isEmpty)
            NeuBox(
              inset: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text(l10n.jobEmpty,
                      style: TextStyle(color: NeuColors.inkSoft))),
            )
          else
            ...list.map((j) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(j.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: NeuColors.ink)),
                          ),
                          Text(money(j.balancePaise),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ]),
                        const SizedBox(height: 4),
                        Text(
                            '${j.customer.isEmpty ? '' : '${j.customer} · '}'
                            '${DateFormat('d MMM').format(DateTime.fromMillisecondsSinceEpoch(j.dueAt))}'
                            ' · ${jobStatusLabel(context, j.status)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: j.overdue
                                    ? NeuColors.danger
                                    : NeuColors.inkSoft)),
                        const SizedBox(height: 10),
                        ActionRow(children: [
                          if (nextJobStatus(j.status) != null)
                            NeuTextButton(
                                label: l10n.jobAdvanceStatus,
                                color: NeuColors.accentDark,
                                onPressed: () => ref
                                    .read(jobProvider.notifier)
                                    .advance(j.id)),
                          if (j.phone.isNotEmpty && j.open)
                            NeuTextButton(
                                label: l10n.jobRemind,
                                onPressed: () => _remind(j)),
                          if (j.open)
                            NeuTextButton(
                                label: l10n.jobCancel,
                                onPressed: () => ref
                                    .read(jobProvider.notifier)
                                    .setStatus(j.id, JobStatus.cancelled)),
                        ]),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
