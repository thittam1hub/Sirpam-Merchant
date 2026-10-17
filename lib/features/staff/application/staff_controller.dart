import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/staff.dart';

class StaffState {
  final List<Worker> workers;
  final List<AttendanceEntry> attendance;

  const StaffState({this.workers = const [], this.attendance = const []});

  StaffState copyWith({
    List<Worker>? workers,
    List<AttendanceEntry>? attendance,
  }) =>
      StaffState(
        workers: workers ?? this.workers,
        attendance: attendance ?? this.attendance,
      );

  List<Worker> get active => [
        for (final w in workers)
          if (w.active) w,
      ];

  AttendanceEntry? entryFor(String workerId, String dayKey) => attendance
      .where((e) => e.workerId == workerId && e.dayKey == dayKey)
      .firstOrNull;

  /// Attendance rows in a given `yyyy-mm` month.
  List<AttendanceEntry> month(String monthKey) =>
      [for (final e in attendance) if (e.dayKey.startsWith(monthKey)) e];
}

class StaffController extends Notifier<StaffState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  StaffState build() => StaffState(
        workers: [
          for (final row in _store.readStaff())
            ...[Worker.tryFromJson(row)].whereType<Worker>(),
        ],
        attendance: [
          for (final row in _store.readAttendance())
            ...[AttendanceEntry.tryFromJson(row)].whereType<AttendanceEntry>(),
        ],
      );

  int get _now => DateTime.now().millisecondsSinceEpoch;

  Future<void> _persistWorkers() => guardWrite(ref,
      () => _store.writeStaff([for (final w in state.workers) w.toJson()]));

  Future<void> _persistAttendance() => guardWrite(
      ref,
      () => _store
          .writeAttendance([for (final e in state.attendance) e.toJson()]));

  Future<Worker> saveWorker({
    String? id,
    required String name,
    String phone = '',
    String role = '',
    String roleId = '',
    int dailyWagePaise = 0,
    bool active = true,
  }) async {
    final existing = id == null
        ? null
        : state.workers.where((w) => w.id == id).firstOrNull;
    final worker =
        (existing ?? Worker(id: 'w${DateTime.now().microsecondsSinceEpoch}', name: name))
            .copyWith(
      name: name,
      phone: phone,
      role: role,
      roleId: roleId,
      dailyWagePaise: dailyWagePaise,
      active: active,
      updatedAt: _now,
    );
    state = state.copyWith(
        workers: [...state.workers.where((w) => w.id != worker.id), worker]);
    await _persistWorkers();
    return worker;
  }

  /// Store the salted PIN that lets this worker start a shift.
  Future<void> setCredentials(String workerId,
      {required String pinHash, required String pinSalt}) async {
    state = state.copyWith(
      workers: [
        for (final w in state.workers)
          w.id == workerId
              ? w.copyWith(pinHash: pinHash, pinSalt: pinSalt, updatedAt: _now)
              : w,
      ],
    );
    await _persistWorkers();
  }

  Future<void> removeWorker(String id) async {
    state = state.copyWith(
      workers: [
        for (final w in state.workers)
          w.id == id ? w.copyWith(active: false, updatedAt: _now) : w,
      ],
    );
    await _persistWorkers();
  }

  /// One tap per worker per day: present -> half -> absent -> present.
  Future<void> cycleAttendance(String workerId, DateTime day) async {
    final key = dayKeyOf(day);
    final existing = state.entryFor(workerId, key);
    if (existing == null) {
      state = state.copyWith(attendance: [
        ...state.attendance,
        AttendanceEntry(
          id: 'a${DateTime.now().microsecondsSinceEpoch}',
          workerId: workerId,
          dayKey: key,
        ),
      ]);
    } else {
      final next = switch (existing.status) {
        AttendanceStatus.present => AttendanceStatus.half,
        AttendanceStatus.half => AttendanceStatus.absent,
        AttendanceStatus.absent => AttendanceStatus.present,
      };
      state = state.copyWith(attendance: [
        for (final e in state.attendance)
          e.id == existing.id ? e.copyWith(status: next) : e,
      ]);
    }
    await _persistAttendance();
  }

  /// Money handed over mid-month against the wage.
  Future<void> addAdvance(
      String workerId, DateTime day, int amountPaise, String note) async {
    if (amountPaise <= 0) return;
    final key = dayKeyOf(day);
    final existing = state.entryFor(workerId, key);
    if (existing == null) {
      state = state.copyWith(attendance: [
        ...state.attendance,
        AttendanceEntry(
          id: 'a${DateTime.now().microsecondsSinceEpoch}',
          workerId: workerId,
          dayKey: key,
          advancePaise: amountPaise,
          note: note,
        ),
      ]);
    } else {
      state = state.copyWith(attendance: [
        for (final e in state.attendance)
          e.id == existing.id
              ? e.copyWith(
                  advancePaise: e.advancePaise + amountPaise, note: note)
              : e,
      ]);
    }
    await _persistAttendance();
  }
}

final staffProvider =
    NotifierProvider<StaffController, StaffState>(StaffController.new);
