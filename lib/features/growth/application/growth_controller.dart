import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../staff/domain/staff.dart';
import '../domain/checklist.dart';

/// Marketing links and the loyalty rule. Kept apart from billing settings so
/// nothing here can affect a bill.
class GrowthSettings {
  final String mapsUrl;
  final String reviewUrl;
  final String instagramHandle;

  /// Visits that earn one free item; 0 turns the loyalty card off.
  final int visitsPerReward;

  const GrowthSettings({
    this.mapsUrl = '',
    this.reviewUrl = '',
    this.instagramHandle = '',
    this.visitsPerReward = 10,
  });

  GrowthSettings copyWith({
    String? mapsUrl,
    String? reviewUrl,
    String? instagramHandle,
    int? visitsPerReward,
  }) =>
      GrowthSettings(
        mapsUrl: mapsUrl ?? this.mapsUrl,
        reviewUrl: reviewUrl ?? this.reviewUrl,
        instagramHandle: instagramHandle ?? this.instagramHandle,
        visitsPerReward: visitsPerReward ?? this.visitsPerReward,
      );

  Map<String, dynamic> toJson() => {
        'mapsUrl': mapsUrl,
        'reviewUrl': reviewUrl,
        'instagramHandle': instagramHandle,
        'visitsPerReward': visitsPerReward,
      };

  factory GrowthSettings.fromJson(Map<String, dynamic> j) => GrowthSettings(
        mapsUrl: j['mapsUrl'] as String? ?? '',
        reviewUrl: j['reviewUrl'] as String? ?? '',
        instagramHandle: j['instagramHandle'] as String? ?? '',
        visitsPerReward: (j['visitsPerReward'] as num?)?.toInt() ?? 10,
      );
}

class GrowthState {
  final GrowthSettings settings;
  final List<ChecklistItem> checklist;

  const GrowthState({
    this.settings = const GrowthSettings(),
    this.checklist = const [],
  });

  GrowthState copyWith({
    GrowthSettings? settings,
    List<ChecklistItem>? checklist,
  }) =>
      GrowthState(
        settings: settings ?? this.settings,
        checklist: checklist ?? this.checklist,
      );

  List<ChecklistItem> ofKind(ChecklistKind kind) =>
      [for (final i in checklist) if (i.kind == kind) i]
        ..sort((a, b) => a.order.compareTo(b.order));
}

class GrowthController extends Notifier<GrowthState> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  GrowthState build() => GrowthState(
        settings: GrowthSettings.fromJson(_store.readGrowth() ?? {}),
        checklist: [
          for (final row in _store.readChecklist())
            ...[ChecklistItem.tryFromJson(row)].whereType<ChecklistItem>(),
        ],
      );

  Future<void> _persistSettings() =>
      guardWrite(ref, () => _store.writeGrowth(state.settings.toJson()));

  Future<void> _persistChecklist() => guardWrite(ref,
      () => _store.writeChecklist([for (final i in state.checklist) i.toJson()]));

  Future<void> saveSettings(GrowthSettings next) async {
    state = state.copyWith(settings: next);
    await _persistSettings();
  }

  Future<void> addItem(String text, ChecklistKind kind) async {
    final clean = text.trim();
    if (clean.isEmpty) return;
    state = state.copyWith(checklist: [
      ...state.checklist,
      ChecklistItem(
        id: 'k${DateTime.now().microsecondsSinceEpoch}',
        text: clean,
        kind: kind,
        order: state.checklist.length,
      ),
    ]);
    await _persistChecklist();
  }

  Future<void> removeItem(String id) async {
    state =
        state.copyWith(checklist: state.checklist.where((i) => i.id != id).toList());
    await _persistChecklist();
  }

  /// Ticking is per day: yesterday's ticks clear themselves at midnight.
  Future<void> toggle(String id, DateTime day) async {
    final key = dayKeyOf(day);
    state = state.copyWith(checklist: [
      for (final i in state.checklist)
        i.id == id
            ? i.copyWith(doneDayKey: i.doneDayKey == key ? '' : key)
            : i,
    ]);
    await _persistChecklist();
  }

  /// Seeds a starter list once, for a shop that has none.
  Future<void> seed(List<(String, ChecklistKind)> items) async {
    if (state.checklist.isNotEmpty) return;
    var order = 0;
    state = state.copyWith(checklist: [
      for (final (text, kind) in items)
        ChecklistItem(
          id: 'k${DateTime.now().microsecondsSinceEpoch}${order++}',
          text: text,
          kind: kind,
          order: order,
        ),
    ]);
    await _persistChecklist();
  }
}


final growthProvider =
    NotifierProvider<GrowthController, GrowthState>(GrowthController.new);
