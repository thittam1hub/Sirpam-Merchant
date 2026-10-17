import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_message.dart';

/// Typed failure for every local persistence write.
///
/// Silent write loss is the worst possible bug in a ledger app, so writes throw
/// this instead of swallowing the platform error, and controllers publish it to
/// [storageErrorProvider] for a user-visible message.
class StorageFailure implements Exception {
  final String key;
  final Object cause;
  const StorageFailure(this.key, this.cause);

  /// Locale-independent message resolved by the presentation layer.
  AppMessage get message =>
      AppMessage(AppMessageCode.storageWriteFailedKey, key);

  @override
  String toString() => 'StorageFailure($key): $cause';
}

/// Last unreported storage failure. `null` means everything persisted.
final storageErrorProvider = StateProvider<AppMessage?>((ref) => null);

/// Runs a persistence write and surfaces failures instead of losing them.
Future<bool> guardWrite(Ref ref, Future<void> Function() write) async {
  try {
    await write();
    return true;
  } on StorageFailure catch (f) {
    ref.read(storageErrorProvider.notifier).state = f.message;
    return false;
  } catch (e) {
    ref.read(storageErrorProvider.notifier).state =
        const AppMessage(AppMessageCode.storageWriteFailed);
    return false;
  }
}
