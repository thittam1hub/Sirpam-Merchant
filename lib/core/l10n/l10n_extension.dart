import 'package:flutter/widgets.dart';
import '../../l10n/generated/app_localizations.dart';

export '../../l10n/generated/app_localizations.dart';

/// `context.l10n.someKey` — the single accessor used by every widget.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
