import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/ledger/application/ledger_controller.dart';
import '../storage/storage_failure.dart';

class VendorSettings {
  final String stallName;
  final String ownerName;
  final String upiVpa;
  final String phone;
  final String mandiApiKey;
  final String market;
  final bool soundboxEnabled;

  /// BCP-47 language subtag of the vendor's chosen UI language ('ta' | 'en').
  final String languageCode;

  /// 'system' | 'light' | 'dark' — how the soft-UI palette is chosen.
  final String themeMode;

  const VendorSettings({
    this.stallName = '',
    this.ownerName = '',
    this.upiVpa = '',
    this.phone = '',
    this.mandiApiKey = '',
    this.market = 'Koyambedu',
    this.soundboxEnabled = true,
    this.languageCode = 'en',
    this.themeMode = 'system',
  });

  bool get isConfigured => stallName.isNotEmpty && upiVpa.isNotEmpty;

  VendorSettings copyWith({
    String? stallName,
    String? ownerName,
    String? upiVpa,
    String? phone,
    String? mandiApiKey,
    String? market,
    bool? soundboxEnabled,
    String? languageCode,
    String? themeMode,
  }) =>
      VendorSettings(
        stallName: stallName ?? this.stallName,
        ownerName: ownerName ?? this.ownerName,
        upiVpa: upiVpa ?? this.upiVpa,
        phone: phone ?? this.phone,
        mandiApiKey: mandiApiKey ?? this.mandiApiKey,
        market: market ?? this.market,
        soundboxEnabled: soundboxEnabled ?? this.soundboxEnabled,
        languageCode: languageCode ?? this.languageCode,
        themeMode: themeMode ?? this.themeMode,
      );

  Map<String, dynamic> toJson() => {
        'stallName': stallName,
        'ownerName': ownerName,
        'upiVpa': upiVpa,
        'phone': phone,
        'mandiApiKey': mandiApiKey,
        'market': market,
        'soundboxEnabled': soundboxEnabled,
        'languageCode': languageCode,
        'themeMode': themeMode,
      };

  factory VendorSettings.fromJson(Map<String, dynamic> j) => VendorSettings(
        stallName: j['stallName'] as String? ?? '',
        ownerName: j['ownerName'] as String? ?? '',
        upiVpa: j['upiVpa'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        mandiApiKey: j['mandiApiKey'] as String? ?? '',
        market: j['market'] as String? ?? 'Koyambedu',
        soundboxEnabled: j['soundboxEnabled'] as bool? ?? true,
        languageCode: j['languageCode'] as String? ?? 'en',
        themeMode: j['themeMode'] as String? ?? 'system',
      );
}

class SettingsController extends Notifier<VendorSettings> {
  @override
  VendorSettings build() =>
      VendorSettings.fromJson(ref.read(localStoreProvider).readSettings());

  Future<void> save(VendorSettings next) async {
    state = next;
    await guardWrite(
        ref, () => ref.read(localStoreProvider).writeSettings(next.toJson()));
  }
}

/// Active UI locale, derived from persisted settings.
final localeProvider = Provider<Locale>((ref) =>
    Locale(ref.watch(settingsProvider.select((s) => s.languageCode))));

/// Chosen appearance, read by the root before the theme is built.
final themeModeProvider = Provider<String>(
    (ref) => ref.watch(settingsProvider.select((s) => s.themeMode)));

final settingsProvider =
    NotifierProvider<SettingsController, VendorSettings>(
        SettingsController.new);
