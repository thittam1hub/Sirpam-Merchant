import '../../l10n/generated/app_localizations.dart';

/// Locale-independent message codes produced by the domain/application layers.
///
/// Controllers must never build user-facing sentences: they emit an
/// [AppMessage], and the presentation layer resolves it against the active
/// [AppLocalizations]. This keeps every string in the ARB files and lets the
/// vendor switch languages without restarting a flow.
enum AppMessageCode {
  storageWriteFailed,
  storageWriteFailedKey,
  micUnavailable,
  voiceNothingHeard,
  voiceNoAmount,
  voiceZeroAmount,
  locationServiceOff,
  locationPermissionDenied,
  mandiKeyRejected,
  connectionFailed,
  raw,
}

class AppMessage {
  final AppMessageCode code;

  /// Placeholder value for codes that take one (key, status, error text).
  final String? detail;

  const AppMessage(this.code, [this.detail]);

  /// Escape hatch for platform-supplied text (already localised by the OS).
  const AppMessage.raw(String text) : this(AppMessageCode.raw, text);

  String resolve(AppLocalizations l10n) => switch (code) {
        AppMessageCode.storageWriteFailed => l10n.storageWriteFailed,
        AppMessageCode.storageWriteFailedKey =>
          l10n.storageWriteFailedKey(detail ?? ''),
        AppMessageCode.micUnavailable => l10n.micUnavailable,
        AppMessageCode.voiceNothingHeard => l10n.voiceNothingHeard,
        AppMessageCode.voiceNoAmount => l10n.voiceNoAmount,
        AppMessageCode.voiceZeroAmount => l10n.voiceZeroAmount,
        AppMessageCode.locationServiceOff => l10n.locationServiceOff,
        AppMessageCode.locationPermissionDenied =>
          l10n.locationPermissionDenied,
        AppMessageCode.mandiKeyRejected => l10n.mandiKeyRejected(detail ?? ''),
        AppMessageCode.connectionFailed => l10n.connectionFailed(detail ?? ''),
        AppMessageCode.raw => detail ?? '',
      };

  @override
  bool operator ==(Object other) =>
      other is AppMessage && other.code == code && other.detail == detail;

  @override
  int get hashCode => Object.hash(code, detail);

  @override
  String toString() => 'AppMessage(${code.name}${detail == null ? '' : ': $detail'})';
}
