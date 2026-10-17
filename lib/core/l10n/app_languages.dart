/// The languages the shop can run in.
///
/// Names are written in the language itself, so a vendor can find their own
/// language without reading English. `speechTag` is the BCP-47 tag handed to
/// the voice ledger and the soundbox announcement voice; devices that lack a
/// pack fall back to English inside those services.
class AppLanguage {
  final String code;
  final String name;
  final String speechTag;

  const AppLanguage(this.code, this.name, this.speechTag);
}

const appLanguages = <AppLanguage>[
  AppLanguage('en', 'English', 'en-IN'),
  AppLanguage('ta', 'தமிழ்', 'ta-IN'),
  AppLanguage('hi', 'हिन्दी', 'hi-IN'),
  AppLanguage('te', 'తెలుగు', 'te-IN'),
  AppLanguage('kn', 'ಕನ್ನಡ', 'kn-IN'),
  AppLanguage('ml', 'മലയാളം', 'ml-IN'),
];

AppLanguage appLanguageFor(String code) => appLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => appLanguages.first,
    );

/// Underscore form used by the speech recognizer, e.g. `hi_IN`.
String speechLocaleId(String code) =>
    appLanguageFor(code).speechTag.replaceAll('-', '_');
