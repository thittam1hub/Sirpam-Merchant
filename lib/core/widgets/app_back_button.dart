import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes.dart';
import '../l10n/l10n_extension.dart';
import '../theme/neu_theme.dart';
import 'neu_chrome.dart';

/// Back affordance that is safe for deep-link entry points.
///
/// When the app was opened straight onto a detail route (cold deep link) there
/// is nothing to pop, so we fall back to the home branch instead of showing a
/// dead arrow or exiting the app.
class AppBackButton extends StatelessWidget {
  final String fallbackLocation;
  const AppBackButton({super.key, this.fallbackLocation = AppPaths.home});

  @override
  Widget build(BuildContext context) {
    return NeuIconButton(
      icon: Icons.arrow_back_rounded,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      iconColor: NeuColors.ink,
      onPressed: () => popOrGo(context, fallbackLocation),
    );
  }

  static void popOrGo(BuildContext context, [String fallback = AppPaths.home]) {
    HapticFeedback.selectionClick();
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(fallback);
    }
  }
}

/// Detail-page scaffold: consistent AppBar, deep-link-safe back, hardware /
/// predictive back handling on Android, and an optional unsaved-changes guard.
class DetailScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final String fallbackLocation;

  /// Return true when the screen holds edits that would be lost on back.
  final bool Function()? isDirty;

  const DetailScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.fallbackLocation = AppPaths.home,
    this.isDirty,
  });

  Future<bool> _confirmLeave(BuildContext context) async {
    if (isDirty == null || !isDirty!()) return true;
    final l10n = context.l10n;
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeuColors.surface,
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.discardKeep)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.discardLeave)),
        ],
      ),
    );
    return leave ?? false;
  }

  Future<void> _leave(BuildContext context) async {
    if (!await _confirmLeave(context)) return;
    if (!context.mounted) return;
    AppBackButton.popOrGo(context, fallbackLocation);
  }

  @override
  Widget build(BuildContext context) {
    final dirty = isDirty?.call() ?? false;
    return PopScope(
      canPop: !dirty && GoRouter.of(context).canPop(),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!await _confirmLeave(context)) return;
        if (!context.mounted) return;
        AppBackButton.popOrGo(context, fallbackLocation);
      },
      child: Scaffold(
        backgroundColor: NeuColors.canvas,
        appBar: NeuAppBar(
          title: title,
          subtitle: subtitle,
          leading: NeuIconButton(
            icon: Icons.arrow_back_rounded,
            label: MaterialLocalizations.of(context).backButtonTooltip,
            iconColor: NeuColors.ink,
            onPressed: () => _leave(context),
          ),
          actions: actions ?? const [],
        ),
        body: body,
      ),
    );
  }

}
