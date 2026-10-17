import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../domain/job.dart';

class JobController extends Notifier<List<Job>> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  List<Job> build() => [
        for (final row in _store.readJobs())
          ...[Job.tryFromJson(row)].whereType<Job>(),
      ];

  int get _now => DateTime.now().millisecondsSinceEpoch;

  Future<void> _persist() => guardWrite(
      ref, () => _store.writeJobs([for (final j in state) j.toJson()]));

  Job? byId(String id) => state.where((j) => j.id == id).firstOrNull;

  List<Job> get open => [
        for (final j in state)
          if (j.open) j,
      ]..sort((a, b) => a.dueAt.compareTo(b.dueAt));

  List<Job> dueOn(DateTime day) =>
      [for (final j in state) if (j.open && j.dueOn(day)) j];

  Future<Job> save({
    String? id,
    required String title,
    String customer = '',
    String phone = '',
    String note = '',
    int pricePaise = 0,
    int advancePaise = 0,
    required int dueAt,
  }) async {
    final existing = id == null ? null : byId(id);
    final job = (existing ??
            Job(
              id: 'j${DateTime.now().microsecondsSinceEpoch}',
              title: title,
              dueAt: dueAt,
              createdAt: _now,
            ))
        .copyWith(
      title: title,
      customer: customer,
      phone: phone,
      note: note,
      pricePaise: pricePaise,
      advancePaise: advancePaise,
      dueAt: dueAt,
      updatedAt: _now,
    );
    state = [...state.where((j) => j.id != job.id), job];
    await _persist();
    // A fresh advance is money in the drawer today.
    if (existing == null && advancePaise > 0) {
      await ref.read(ledgerProvider.notifier).addSale(
            amountPaise: advancePaise,
            mode: SaleMode.cash,
            item: title,
            billRef: 'job:${job.id}',
          );
    }
    return job;
  }

  Future<void> setStatus(String id, JobStatus status) async {
    final job = byId(id);
    if (job == null) return;
    final postBalance = status == JobStatus.delivered &&
        !job.posted &&
        job.balancePaise > 0;
    state = [
      for (final j in state)
        j.id == id
            ? j.copyWith(
                status: status,
                updatedAt: _now,
                posted: job.posted || postBalance)
            : j,
    ];
    await _persist();
    if (postBalance) {
      await ref.read(ledgerProvider.notifier).addSale(
            amountPaise: job.balancePaise,
            mode: SaleMode.cash,
            item: job.title,
            billRef: 'job:${job.id}',
          );
    }
  }

  Future<void> advance(String id) async {
    final job = byId(id);
    if (job == null) return;
    final next = nextJobStatus(job.status);
    if (next == null) return;
    await setStatus(id, next);
  }

  Future<void> delete(String id) async {
    state = state.where((j) => j.id != id).toList();
    await _persist();
  }
}

final jobProvider = NotifierProvider<JobController, List<Job>>(JobController.new);
