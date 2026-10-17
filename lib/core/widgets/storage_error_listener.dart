import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_message.dart';
import '../l10n/l10n_extension.dart';
import '../storage/storage_failure.dart';

/// Surfaces persistence failures to the vendor instead of losing entries
/// silently. Wraps the router so every route inherits the behaviour.
class StorageErrorListener extends ConsumerWidget {
  final Widget child;
  const StorageErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.listen<AppMessage?>(storageErrorProvider, (_, next) {
      if (next == null) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) return;
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content:
                Text(next.resolve(l10n), style: const TextStyle(fontSize: 16)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: l10n.ok,
              onPressed: () =>
                  ref.read(storageErrorProvider.notifier).state = null,
            ),
          ),
        );
      ref.read(storageErrorProvider.notifier).state = null;
    });
    return child;
  }
}
