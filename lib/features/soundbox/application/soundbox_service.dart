import 'dart:async';
import 'dart:ui' show Locale;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/l10n/app_languages.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';

/// A UPI credit detected from an Android payment-app notification.
class UpiCredit {
  final int amountPaise;
  final String app;
  final String rawText;
  final int ts;
  const UpiCredit({
    required this.amountPaise,
    required this.app,
    required this.rawText,
    required this.ts,
  });

  double get rupees => amountPaise / 100.0;
}

/// Platform availability of the notification-listener soundbox.
enum SoundboxAvailability { available, iosRestricted, webRestricted }

class SoundboxState {
  final SoundboxAvailability availability;
  final bool permissionGranted;
  final List<UpiCredit> credits;
  final String? lastError;
  const SoundboxState({
    required this.availability,
    this.permissionGranted = false,
    this.credits = const [],
    this.lastError,
  });

  bool get isNative => availability == SoundboxAvailability.available;

  SoundboxState copyWith({
    bool? permissionGranted,
    List<UpiCredit>? credits,
    String? lastError,
  }) =>
      SoundboxState(
        availability: availability,
        permissionGranted: permissionGranted ?? this.permissionGranted,
        credits: credits ?? this.credits,
        lastError: lastError,
      );
}

/// Parses UPI credit notifications from PhonePe / Paytm / GPay / BHIM.
class UpiNotificationParser {
  static const supportedPackages = <String, String>{
    'com.phonepe.app': 'PhonePe',
    'net.one97.paytm': 'Paytm',
    'com.google.android.apps.nbu.paisa.user': 'Google Pay',
    'in.org.npci.upiapp': 'BHIM',
  };

  /// Only credits ("received"/"paid you") are announced; debits are ignored.
  static final _creditHints = RegExp(
    r'(received|credited|paid you|you got|has paid|money received)',
    caseSensitive: false,
  );
  static final _debitHints = RegExp(
    r'(debited|you paid|sent to|payment of .* to|withdrawn)',
    caseSensitive: false,
  );
  static final _amount = RegExp(r'(?:₹|rs\.?|inr)\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false);

  static UpiCredit? parse({
    required String package,
    required String title,
    required String text,
  }) {
    final app = supportedPackages[package];
    if (app == null) return null;
    final blob = '$title $text';
    if (_debitHints.hasMatch(blob)) return null;
    if (!_creditHints.hasMatch(blob)) return null;
    final m = _amount.firstMatch(blob);
    if (m == null) return null;
    final rupees = double.tryParse(m.group(1)!.replaceAll(',', ''));
    if (rupees == null || rupees <= 0) return null;
    return UpiCredit(
      amountPaise: (rupees * 100).round(),
      app: app,
      rawText: blob.trim(),
      ts: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class SoundboxController extends Notifier<SoundboxState> {
  static const _method = MethodChannel('vendoros/soundbox');
  static const _events = EventChannel('vendoros/soundbox/events');

  final FlutterTts _tts = FlutterTts();
  StreamSubscription<dynamic>? _sub;
  void Function(UpiCredit credit)? onCredit;

  @override
  SoundboxState build() {
    ref.onDispose(() => _sub?.cancel());
    if (kIsWeb) {
      return const SoundboxState(
          availability: SoundboxAvailability.webRestricted);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const SoundboxState(
          availability: SoundboxAvailability.iosRestricted);
    }
    ref.listen<String>(
      settingsProvider.select((s) => s.languageCode),
      (_, __) => _configureTts(),
    );
    scheduleMicrotask(_start);
    return const SoundboxState(availability: SoundboxAvailability.available);
  }

  Future<void> _start() async {
    await _configureTts();
    await refreshPermission();
    _sub ??= _events.receiveBroadcastStream().listen(
      (event) {
        final map = (event as Map).cast<Object?, Object?>();
        final credit = UpiNotificationParser.parse(
          package: map['package']?.toString() ?? '',
          title: map['title']?.toString() ?? '',
          text: map['text']?.toString() ?? '',
        );
        if (credit == null) return;
        state = state.copyWith(credits: [credit, ...state.credits].take(50).toList());
        announce(credit.rupees);
        onCredit?.call(credit);
      },
      onError: (Object e) => state = state.copyWith(lastError: e.toString()),
    );
  }

  String get _languageCode => ref.read(settingsProvider).languageCode;

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage(appLanguageFor(_languageCode).speechTag);
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
    } catch (_) {
      // TTS voice packs vary by device; announcement falls back to default voice.
    }
  }

  /// Speaks the localized `soundboxSpeech` message in the vendor's language.
  Future<void> announce(double rupees) async {
    final amount = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    try {
      await _tts.stop();
      await _configureTts();
      final l10n = lookupAppLocalizations(Locale(_languageCode));
      await _tts.speak(l10n.soundboxSpeech(amount));
    } catch (e) {
      state = state.copyWith(lastError: 'TTS: $e');
    }
  }

  Future<void> refreshPermission() async {
    if (!state.isNative) return;
    try {
      final granted =
          await _method.invokeMethod<bool>('isPermissionGranted') ?? false;
      state = state.copyWith(permissionGranted: granted);
    } on PlatformException catch (e) {
      state = state.copyWith(lastError: e.message);
    }
  }

  Future<void> openPermissionSettings() async {
    if (!state.isNative) return;
    try {
      await _method.invokeMethod<void>('openSettings');
    } on PlatformException catch (e) {
      state = state.copyWith(lastError: e.message);
    }
  }
}

final soundboxProvider =
    NotifierProvider<SoundboxController, SoundboxState>(
        SoundboxController.new);
