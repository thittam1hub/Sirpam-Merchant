import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/data/ordering_api.dart';
import '../domain/backup_bundle.dart';

/// When the books were last written out, so the vendor can see how exposed
/// they are if the phone is lost today.
class BackupState {
  final int lastBackupMs;

  /// When the shop's own cloud space last received a copy.
  final int lastCloudMs;
  final bool busy;
  const BackupState({
    this.lastBackupMs = 0,
    this.lastCloudMs = 0,
    this.busy = false,
  });

  bool get everBackedUp => lastBackupMs > 0;
  bool get everCloudBackedUp => lastCloudMs > 0;

  BackupState copyWith({int? lastBackupMs, int? lastCloudMs, bool? busy}) =>
      BackupState(
        lastBackupMs: lastBackupMs ?? this.lastBackupMs,
        lastCloudMs: lastCloudMs ?? this.lastCloudMs,
        busy: busy ?? this.busy,
      );
}

class BackupController extends Notifier<BackupState> {
  LocalStore get _store => ref.read(localStoreProvider);
  final OrderingApi _api = OrderingApi();

  @override
  BackupState build() {
    final saved = _store.readBackup();
    return BackupState(
      lastBackupMs: (saved?['lastBackupMs'] as num?)?.toInt() ?? 0,
      lastCloudMs: (saved?['lastCloudMs'] as num?)?.toInt() ?? 0,
    );
  }

  /// Everything the shop owns, wrapped and checksummed.
  BackupBundle bundle({String shopName = ''}) => BackupBundle(
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
        shopName: shopName,
        books: _store.exportBooks(),
      );

  /// Marks a bundle as safely handed off (shared, saved or uploaded).
  Future<void> markSaved(int atMs) async {
    await _store
        .writeBackup({'lastBackupMs': atMs, 'lastCloudMs': state.lastCloudMs});
    state = state.copyWith(lastBackupMs: atMs);
  }


  /// Replaces every book on this phone with the ones in [raw].
  /// Returns the parse result so the UI can explain a refusal.
  Future<BackupReadResult> restore(String raw) async {
    final result = readBackup(raw);
    if (!result.isOk) return result;
    state = state.copyWith(busy: true);
    try {
      await _store.importBooks(result.bundle!.books);
    } finally {
      state = state.copyWith(busy: false);
    }
    return result;
  }

  /// Rough size of the backup in kilobytes, for the "what will be saved" line.
  int estimatedKb() =>
      (utf8.encode(jsonEncode(_store.exportBooks())).length / 1024).ceil();

  /// Sends the books to the shop's own cloud space. Returns the server time
  /// the copy was stored, or throws [OrderingApiFailure] when it could not.
  Future<int> backupToCloud({String label = ''}) async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) {
      throw const OrderingApiFailure('shop not on cloud');
    }
    final b = bundle(shopName: shop.shopName);
    state = state.copyWith(busy: true);
    try {
      final at = await _api.uploadBackup(
        slug: shop.slug,
        shopKey: shop.shopKey,
        payload: b.encode(),
        checksum: BackupBundle.checksumOf(b.books),
        label: label,
      );
      await _store.writeBackup({
        'lastBackupMs': state.lastBackupMs,
        'lastCloudMs': at,
      });
      state = state.copyWith(lastCloudMs: at, busy: false);
      return at;
    } catch (_) {
      state = state.copyWith(busy: false);
      rethrow;
    }
  }

  /// Once a day, quietly. Never blocks the screen and never shows an error:
  /// the manual button is there when the vendor wants certainty.
  Future<void> backupToCloudIfDue() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - state.lastCloudMs < const Duration(hours: 20).inMilliseconds) {
      return;
    }
    try {
      await backupToCloud(label: 'auto');
    } catch (_) {
      // Offline is normal on a stall phone; try again on the next open.
    }
  }

  /// Pulls the newest online copy back onto this phone.
  Future<BackupReadResult> restoreFromCloud() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) {
      throw const OrderingApiFailure('shop not on cloud');
    }
    final info = await _api.latestBackup(
      slug: shop.slug,
      shopKey: shop.shopKey,
      withPayload: true,
    );
    if (!info.found || info.payload.isEmpty) {
      return const BackupReadResult.failed(BackupError.empty);
    }
    return restore(info.payload);
  }

  /// When the server last received a copy (cheap check, no payload).
  Future<CloudBackupInfo?> cloudStatus() async {
    final shop = ref.read(shopConfigProvider);
    if (!shop.cloudReady) return null;
    try {
      return await _api.latestBackup(slug: shop.slug, shopKey: shop.shopKey);
    } catch (_) {
      return null;
    }
  }
}

final backupProvider =
    NotifierProvider<BackupController, BackupState>(BackupController.new);

