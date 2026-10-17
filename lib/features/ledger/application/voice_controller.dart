import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../core/l10n/app_languages.dart';
import '../../../core/l10n/app_message.dart';
import '../../../core/settings/settings_controller.dart';

enum VoiceStatus { idle, unavailable, listening, done }

class VoiceState {
  final VoiceStatus status;
  final String transcript;

  /// All recognizer hypotheses for the utterance, best first.
  final List<String> alternates;
  final AppMessage? error;
  final double level;

  /// Recognizer locale actually used (e.g. `ta_IN`, or `en_IN` when the device
  /// has no Tamil speech pack).
  final String? localeId;
  const VoiceState({
    this.status = VoiceStatus.idle,
    this.transcript = '',
    this.alternates = const [],
    this.error,
    this.level = 0,
    this.localeId,
  });

  bool get isTamilRecognizer => (localeId ?? '').startsWith('ta');

  VoiceState copyWith({
    VoiceStatus? status,
    String? transcript,
    List<String>? alternates,
    AppMessage? error,
    double? level,
    String? localeId,
  }) =>
      VoiceState(
        status: status ?? this.status,
        transcript: transcript ?? this.transcript,
        alternates: alternates ?? this.alternates,
        error: error,
        level: level ?? this.level,
        localeId: localeId ?? this.localeId,
      );
}


/// Colloquial Tamil / Tanglish speech intake.
/// Uses on-device recognition in the shop's language, falling back to en-IN.
class VoiceController extends Notifier<VoiceState> {
  final SpeechToText _speech = SpeechToText();
  bool _initialised = false;

  @override
  VoiceState build() {
    ref.onDispose(() => _speech.cancel());
    return const VoiceState();
  }

  Future<bool> _ensureInit() async {
    if (_initialised) return true;
    try {
      _initialised = await _speech.initialize(
        onError: (e) => state = state.copyWith(
            status: VoiceStatus.idle, error: AppMessage.raw(e.errorMsg)),
        onStatus: (s) {
          if (s == 'done' || s == 'notListening') {
            if (state.status == VoiceStatus.listening) {
              state = state.copyWith(status: VoiceStatus.done);
            }
          }
        },
      );
    } catch (e) {
      _initialised = false;
      state = state.copyWith(
          status: VoiceStatus.unavailable, error: AppMessage.raw(e.toString()));
    }
    if (!_initialised) {
      state = state.copyWith(
        status: VoiceStatus.unavailable,
        error: const AppMessage(AppMessageCode.micUnavailable),
      );
    }
    return _initialised;
  }

  /// Picks the best available recognizer locale for the vendor's language.
  /// Preference order: the shop's own language (e.g. `ta_IN`) > any variant of
  /// it > `en_IN` > the system locale.
  Future<String> _resolveLocale() async {
    final code = ref.read(settingsProvider).languageCode;
    final wanted = speechLocaleId(code);
    try {
      final locales = await _speech.locales();
      String? pick(bool Function(String id) test) {
        for (final l in locales) {
          if (test(l.localeId.replaceAll('-', '_'))) return l.localeId;
        }
        return null;
      }

      if (code != 'en') {
        final own = pick((id) => id == wanted) ?? pick((id) => id.startsWith(code));
        if (own != null) return own;
      }
      return pick((id) => id == 'en_IN') ??
          pick((id) => id.startsWith('en')) ??
          (await _speech.systemLocale())?.localeId ??
          'en_IN';
    } catch (_) {
      return wanted;
    }
  }

  Future<void> listen() async {
    if (!await _ensureInit()) return;

    final locale = await _resolveLocale();
    state = VoiceState(
      status: VoiceStatus.listening,
      transcript: '',
      localeId: locale,
    );
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: locale,
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.dictation,
        // Colloquial Tamil sentences carry long pauses between the amount and
        // the item, so keep the mic open longer than the default.
        pauseFor: const Duration(seconds: 4),
        listenFor: const Duration(seconds: 30),
        autoPunctuation: false,
      ),
      onSoundLevelChange: (l) =>
          state = state.copyWith(level: (l.clamp(-2, 10) + 2) / 12),
      onResult: (r) {
        // Keep every hypothesis: the top Tamil transcript often drops the
        // amount while a lower-ranked alternate keeps it.
        final alternates = <String>[
          r.recognizedWords,
          for (final a in r.alternates) a.recognizedWords,
        ].where((t) => t.trim().isNotEmpty).toSet().toList();
        state = state.copyWith(
          transcript: r.recognizedWords,
          alternates: alternates,
          status: r.finalResult ? VoiceStatus.done : VoiceStatus.listening,
        );
      },
    );
  }


  Future<void> stop() async {
    await _speech.stop();
    state = state.copyWith(status: VoiceStatus.done);
  }

  void reset() => state = const VoiceState();
}

final voiceProvider =
    NotifierProvider<VoiceController, VoiceState>(VoiceController.new);
