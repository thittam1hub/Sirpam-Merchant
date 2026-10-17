// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'ನಮಸ್ಕಾರ $name, $stall ನಲ್ಲಿ ನಿಮ್ಮ ಬಾಕಿ ಮೊತ್ತ Rs $amount. ದಯವಿಟ್ಟು ಪಾವತಿಸಿ. ಧನ್ಯವಾದಗಳು.$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'ಹೋಮ್';

  @override
  String get navUdhaar => 'ಉದ್ಧಾರ';

  @override
  String get navSoundbox => 'ಧ್ವನಿ';

  @override
  String get navMandi => 'ಮಂಡಿ';

  @override
  String get navSales => 'ಮಾರಾಟ';

  @override
  String get navGroupOverview => 'ಅವಲೋಕನ';

  @override
  String get navGroupSell => 'ಮಾರಾಟ';

  @override
  String get navGroupOperations => 'ಗ್ರಾಹಕರು & ನಿರ್ವಹಣೆ';

  @override
  String get navGroupBusiness => 'ವ್ಯಾಪಾರ';

  @override
  String get navGroupTeam => 'ತಂಡ';

  @override
  String get navGroupSystem => 'ಸಿಸ್ಟಮ್';

  @override
  String get moreLabel => 'ಇನ್ನಷ್ಟು';

  @override
  String get menuLoanReport => 'ಸಾಲದ ವರದಿ';

  @override
  String get menuCartLocation => 'ಗಾಡಿಯ ಸ್ಥಳ';

  @override
  String get menuSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String get notFoundTitle => 'ಪುಟ ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get goHome => 'ಹೋಮ್‌ಗೆ ಹೋಗಿ';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get loading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ…';

  @override
  String storageWriteFailedKey(String key) {
    return 'ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ ($key) — ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';
  }

  @override
  String get storageWriteFailed =>
      'ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ — ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get micUnavailable =>
      'ಮೈಕ್ರೊಫೋನ್ ಲಭ್ಯವಿಲ್ಲ — ದಯವಿಟ್ಟು ನೇರವಾಗಿ ನಮೂದಿಸಿ';

  @override
  String get voiceNothingHeard => 'ಏನೂ ಕೇಳಿಸಲಿಲ್ಲ — ದಯವಿಟ್ಟು ಮತ್ತೆ ಮಾತನಾಡಿ';

  @override
  String get voiceNoAmount =>
      'ಮೊತ್ತ ಕೇಳಿಸಲಿಲ್ಲ — \"50 ರೂಪಾಯಿ ಟೊಮೇಟೊ\" ಎಂದು ಹೇಳಿ';

  @override
  String get voiceZeroAmount => 'ಮೊತ್ತ ಸೊನ್ನೆ ಆಗಿರಬಾರದು';

  @override
  String get modeCash => 'ನಗದು';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'ಉದ್ಧಾರ';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount ದಾಖಲಾಗಿದೆ';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'ಇಂದಿನ ಒಟ್ಟು ವ್ಯಾಪಾರ $amount ರೂಪಾಯಿ';
  }

  @override
  String get todayCollection => 'ಇಂದಿನ ಕಲೆಕ್ಷನ್';

  @override
  String get quickEntry => 'ಕ್ವಿಕ್ ಎಂಟ್ರಿ';

  @override
  String get todayEntries => 'ಇಂದಿನ ಎಂಟ್ರಿಗಳು';

  @override
  String get noEntriesYet => 'ಇನ್ನೂ ಯಾವುದೇ ಎಂಟ್ರಿ ಇಲ್ಲ — ಮೈಕ್ ಒತ್ತಿ ಮಾತನಾಡಿ';

  @override
  String get listeningTapToStop => 'ಕೇಳಿಸಿಕೊಳ್ಳುತ್ತಿದೆ, ನಿಲ್ಲಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get tapToSpeak => 'ದಾಖಲಿಸಲು ಮಾತನಾಡಿ';

  @override
  String get listening => 'ಕೇಳಿಸಿಕೊಳ್ಳುತ್ತಿದೆ…';

  @override
  String get speakToRecord => '🎙️ ದಾಖಲಿಸಲು ಮಾತನಾಡಿ';

  @override
  String get voiceHint => '\"50 ರೂಪಾಯಿ ಟೊಮೆಟೊ ಕ್ಯಾಶ್\" / \"ರವಿಗೆ 200 ಉದ್ರಿ\"';

  @override
  String get addSale => 'ಮಾರಾಟ ಸೇರಿಸಿ';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount ರೂಪಾಯಿ, $item';
  }

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get locationServiceOff => 'ಲೊಕೇಶನ್ ಸರ್ವಿಸ್ ಆಫ್ ಆಗಿದೆ';

  @override
  String get locationPermissionDenied => 'ಲೊಕೇಶನ್ ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get broadcastLive => 'ಲೈವ್ ಪ್ರಸಾರದಲ್ಲಿದೆ';

  @override
  String get locationSearching => 'ಲೊಕೇಶನ್ ಹುಡುಕಲಾಗುತ್ತಿದೆ…';

  @override
  String get permissionDenied => 'ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get unavailable => 'ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get broadcastStopped => 'ಪ್ರಸಾರ ನಿಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get locationNotFetched => 'ಲೊಕೇಶನ್ ಇನ್ನೂ ಸಿಕ್ಕಿಲ್ಲ';

  @override
  String get stopBroadcast => 'ಪ್ರಸಾರ ನಿಲ್ಲಿಸಿ';

  @override
  String get startBroadcast => 'ಪ್ರಸಾರ ಶುರುಮಾಡಿ';

  @override
  String get sendToCustomer => 'ಗ್ರಾಹಕರಿಗೆ ಕಳುಹಿಸಿ';

  @override
  String get shareLocationHint =>
      'ಇವತ್ತಿನ ಗಾಡಿಯ ಜಾಗವನ್ನು WhatsApp ನಲ್ಲಿ ಶೇರ್ ಮಾಡಿ.';

  @override
  String get ourCart => 'ನಮ್ಮ ಗಾಡಿ';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall ಇವತ್ತು ಇಲ್ಲಿದೆ 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'WhatsApp ನಲ್ಲಿ ಶೇರ್ ಮಾಡಿ';

  @override
  String get openInMaps => 'Maps ನಲ್ಲಿ ತೆರೆಯಿರಿ';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in ರಿಕ್ವೆಸ್ಟ್ ತಿರಸ್ಕರಿಸಿದೆ — API key ಪರಿಶೀಲಿಸಿ ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'ಕನೆಕ್ಷನ್ ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get mandiTitle => 'ಮಾರುಕಟ್ಟೆ ದರಗಳು';

  @override
  String get refresh => 'ರಿಫ್ರೆಶ್';

  @override
  String get mandiLoading => 'ಮಾರುಕಟ್ಟೆ ದರಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ';

  @override
  String get fetchFailed => 'ಮಾಹಿತಿ ಪಡೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get apiKeyNeeded => 'data.gov.in API key ಅಗತ್ಯವಿದೆ';

  @override
  String get apiKeyNeededBody =>
      'ಲೈವ್ APMC ದರಗಳಿಗಾಗಿ ಉಚಿತ data.gov.in API key ಪಡೆದು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಸೇರಿಸಿ. ಯಾವುದೇ ಅಂದಾಜು ದರಗಳನ್ನು ತೋರಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get refreshFailed => 'ರಿಫ್ರೆಶ್ ಮಾಡುವುದು ವಿಫಲವಾಗಿದೆ';

  @override
  String lastUpdated(String time) {
    return 'ಕೊನೆಯ ಅಪ್ಡೇಟ್: $time';
  }

  @override
  String get searchVegetable => 'ತರಕಾರಿ ಹುಡುಕಿ';

  @override
  String get loanReportHeading => 'ಬಿಸಿನೆಸ್ ಲೋನ್ ರಿಪೋರ್ಟ್';

  @override
  String reportFailed(String error) {
    return 'ವರದಿ ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String daysWindow(num days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString ದಿನಗಳು',
      one: '1 ದಿನ',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'ಒಟ್ಟು ವ್ಯಾಪಾರ';

  @override
  String get digitalShare => 'ಡಿಜಿಟಲ್ ಪಾಲು';

  @override
  String get avgDailyIncome => 'ಸರಾಸರಿ ದಿನದ ಆದಾಯ';

  @override
  String get recordedDays => 'ದಾಖಲಾದ ದಿನಗಳು';

  @override
  String get sha256Checksum => 'SHA-256 ಚೆಕ್‌ಸಮ್';

  @override
  String get noSalesYet =>
      'ಇನ್ನೂ ಯಾವುದೇ ಮಾರಾಟ ದಾಖಲಾಗಿಲ್ಲ — ರಿಪೋರ್ಟ್ ಪಡೆಯಲು ಮೊದಲು ಮಾರಾಟವನ್ನು ದಾಖಲಿಸಿ.';

  @override
  String get viewPdf => 'PDF ನೋಡಿ';

  @override
  String get sendToBank => 'ಬ್ಯಾಂಕ್‌ಗೆ ಕಳುಹಿಸಿ';

  @override
  String get stallName => 'ಸ್ಟಾಲ್ ಹೆಸರು';

  @override
  String get ownerName => 'ಮಾಲೀಕರ ಹೆಸರು';

  @override
  String get upiVpaLabel => 'UPI VPA (ಉದಾ: name@okaxis)';

  @override
  String get mobileNumber => 'ಮೊಬೈಲ್ ನಂಬರ್';

  @override
  String get mandiMarket => 'ಮಾರುಕಟ್ಟೆ (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API ಕೀ';

  @override
  String get apiKeyHelp =>
      'ಕೀ ಪಡೆಯಲು data.gov.in ನಲ್ಲಿ ಉಚಿತವಾಗಿ ನೋಂದಾಯಿಸಿ. ಕೀ ಇಲ್ಲದೆ ಲೈವ್ ಬೆಲೆಗಳು ಕಾಣಿಸುವುದಿಲ್ಲ.';

  @override
  String get soundboxAnnounce => 'ಸೌಂಡ್‌ಬಾಕ್ಸ್ ಅನೌನ್ಸ್‌ಮೆಂಟ್';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String soundboxSpeech(String amount) {
    return '$amount ರೂಪಾಯಿ ಬಂದಿದೆ';
  }

  @override
  String get soundboxTitle => 'ಸೌಂಡ್‌ಬಾಕ್ಸ್';

  @override
  String get soundboxSubtitle =>
      'UPI ಪಾವತಿಗಳ ಮಾಹಿತಿ ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲೇ ಧ್ವನಿ ಮೂಲಕ ಕೇಳಿ';

  @override
  String get watchedApps => 'ಗಮನಿಸುವ ಆಪ್‌ಗಳು';

  @override
  String get soundboxTestHint =>
      'ಪರೀಕ್ಷೆ: \"250 ರೂಪಾಯಿ ಬಂದಿದೆ\" ಎಂದು ಧ್ವನಿ ಬರುತ್ತದೆ';

  @override
  String get speak => 'ಹೇಳಿ';

  @override
  String get announcedPayments => 'ಅನೌನ್ಸ್ ಆದ ಪಾವತಿಗಳು';

  @override
  String get noUpiYet => 'ಇನ್ನೂ ಯಾವುದೇ UPI ಪಾವತಿ ಬಂದಿಲ್ಲ';

  @override
  String get soundboxRunning => 'ಸೌಂಡ್‌ಬಾಕ್ಸ್ ಚಾಲನೆಯಲ್ಲಿದೆ';

  @override
  String get notificationAccessNeeded => 'ನೋಟಿಫಿಕೇಶನ್ ಅನುಮತಿ ಬೇಕು';

  @override
  String get soundboxAndroidHint =>
      'PhonePe, Paytm, Google Pay ಮತ್ತು BHIM ಪಾವತಿಗಳು ಆಟೋಮ್ಯಾಟಿಕ್ ಆಗಿ ಧ್ವನಿ ಮೂಲಕ ತಿಳಿಯುತ್ತವೆ.';

  @override
  String get soundboxGrantHint =>
      'Android ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ VendorOS ಗೆ ನೋಟಿಫಿಕೇಶನ್ ಅನುಮತಿ ನೀಡಿ.';

  @override
  String get grantAccess => 'ಅನುಮತಿ ನೀಡಿ';

  @override
  String get iosUnavailable => 'iOS ನಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get webUnavailable => 'ಬ್ರೌಸರ್‌ನಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get iosSoundboxNote =>
      'Apple ನ ನಿರ್ಬಂಧಗಳಿಂದಾಗಿ ಇತರ ಆಪ್‌ಗಳ ನೋಟಿಫಿಕೇಶನ್ ಓದಲು ಸಾಧ್ಯವಿಲ್ಲ. ಮ್ಯಾನುವಲ್ ಅಥವಾ ಧ್ವನಿ ಎಂಟ್ರಿ ಮಾತ್ರ ಲಭ್ಯ.';

  @override
  String get webSoundboxNote =>
      'ಬ್ರೌಸರ್ ಇತರ ಆಪ್‌ಗಳ UPI ನೋಟಿಫಿಕೇಶನ್‌ಗಳನ್ನು ಓದಲು ಸಾಧ್ಯವಿಲ್ಲ. ಸೌಂಡ್‌ಬಾಕ್ಸ್‌ಗಾಗಿ Android APK ಇನ್‌ಸ್ಟಾಲ್ ಮಾಡಿ.';

  @override
  String get serverSoundbox => 'ಬಿಸಿನೆಸ್ UPI ಸೌಂಡ್‌ಬಾಕ್ಸ್';

  @override
  String get serverSoundboxNote =>
      'ನಿಮ್ಮ ಪಾವತಿ ಪ್ರೊವೈಡರ್ ದೃಢಪಡಿಸಿದ ಪಾವತಿಗಳು ಇಲ್ಲಿ ಅನೌನ್ಸ್ ಆಗುತ್ತವೆ. ಈ ಫೋನ್‌ನಲ್ಲಿ ಧ್ವನಿ ಬರುವವರೆಗೆ ಪಾವತಿ ಸರ್ವರ್‌ನಲ್ಲಿ ಕಾಯ್ದಿರುತ್ತದೆ, ಯಾವುದೂ ಮಿಸ್ ಆಗಲ್ಲ.';

  @override
  String get notPaired =>
      'ಈ ಫೋನ್ ಇನ್ನೂ ಯಾವುದೇ ಬಿಸಿನೆಸ್ UPI ಖಾತೆಗೆ ಲಿಂಕ್ ಆಗಿಲ್ಲ.';

  @override
  String get pairingCode => 'ಪೇರಿಂಗ್ ಕೋಡ್';

  @override
  String get pair => 'ಫೋನ್ ಲಿಂಕ್ ಮಾಡಿ';

  @override
  String get unpair => 'ಅನ್‌ಲಿಂಕ್ ಮಾಡಿ';

  @override
  String pairedWith(String name) {
    return '$name ಗೆ ಲಿಂಕ್ ಆಗಿದೆ';
  }

  @override
  String get syncNow => 'ಈಗ ಚೆಕ್ ಮಾಡಿ';

  @override
  String lastChecked(String time) {
    return 'ಕೊನೆಯ ಬಾರಿ ಚೆಕ್ ಮಾಡಿದ್ದು: $time';
  }

  @override
  String get neverChecked => 'ಇನ್ನೂ ಚೆಕ್ ಮಾಡಿಲ್ಲ';

  @override
  String get soundboxStale =>
      'ಇತ್ತೀಚೆಗೆ ಸರ್ವರ್ ಸಂಪರ್ಕ ಸಿಕ್ಕಿಲ್ಲ. ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಅನೌನ್ಸ್ ಮಾಡಲು $countString ಪಾವತಿಗಳು ಬಾಕಿ ಇವೆ',
      one: 'ಅನೌನ್ಸ್ ಮಾಡಲು 1 ಪಾವತಿ ಬಾಕಿ ಇದೆ',
      zero: 'ಯಾವುದೂ ಬಾಕಿ ಇಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'ನೋಟಿಫಿಕೇಶನ್ ಸೌಂಡ್‌ಬಾಕ್ಸ್ (ಬದಲಿ)';

  @override
  String get udhaarTitle => 'ಉದ್ದರಿ ಪುಸ್ತಕ';

  @override
  String get udhaarSubtitle => 'ಗ್ರಾಹಕರ ಬಾಕಿ';

  @override
  String get totalOutstanding => 'ಒಟ್ಟು ಬಾಕಿ';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ಗ್ರಾಹಕರು',
      one: '1 ಗ್ರಾಹಕ',
      zero: 'ಗ್ರಾಹಕರಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'ಫಿಲ್ಟರ್: $name';
  }

  @override
  String get clearFilter => 'ಫಿಲ್ಟರ್ ತೆಗೆಯಿರಿ';

  @override
  String get upiSetupHint =>
      'UPI ಕೇಳಲು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ನಿಮ್ಮ VPA ಮತ್ತು ಅಂಗಡಿ ಹೆಸರು ಸೇರಿಸಿ.';

  @override
  String get noOutstanding => 'ಯಾವ ಬಾಕಿಯೂ ಇಲ್ಲ';

  @override
  String cannotOpen(String scheme) {
    return 'ತೆರೆಯಲು ಆಗುತ್ತಿಲ್ಲ: $scheme';
  }

  @override
  String get askUpi => 'UPI ಕೇಳಿ';

  @override
  String get collect => 'ವಸೂಲಿ ಮಾಡಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get languageChanged => 'ಭಾಷೆ ಬದಲಾಗಿದೆ';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return 'ಉದ್ದರಿ $name';
  }

  @override
  String get defaultStallName => 'VendorOS ಸ್ಟಾಲ್';

  @override
  String get merchantOnboardingTitle => 'ಬಿಸಿನೆಸ್ UPI ರಿಜಿಸ್ಟರ್ ಮಾಡಿ';

  @override
  String get merchantOnboardingSubtitle =>
      'ನಿಮ್ಮ ಬಿಸಿನೆಸ್ ಖಾತೆಯನ್ನು ಸೌಂಡ್‌ಬಾಕ್ಸ್‌ಗೆ ಲಿಂಕ್ ಮಾಡಿ';

  @override
  String get merchantStepsHint =>
      'ನಿಮ್ಮ PhonePe for Business ಅಥವಾ Paytm for Business ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಿಂದ ವಿವರಗಳನ್ನು ನಮೂದಿಸಿ. ನಿಮಗೆ ಪೇರಿಂಗ್ ಕೋಡ್ ಸಿಗುತ್ತದೆ ಮತ್ತು ಈ ಫೋನ್ ತಕ್ಷಣ ಲಿಂಕ್ ಆಗುತ್ತದೆ.';

  @override
  String get howToGetBusinessUpi => 'ಬಿಸಿನೆಸ್ UPI ಖಾತೆ ಪಡೆಯುವುದು ಹೇಗೆ?';

  @override
  String get merchantFormIncomplete =>
      'ಬಿಸಿನೆಸ್ ಹೆಸರು, ಮರ್ಚೆಂಟ್ ID ಮತ್ತು ಸೀಕ್ರೆಟ್ ಕೀ ಭರ್ತಿ ಮಾಡಿ.';

  @override
  String get merchantRegistered => 'ಬಿಸಿನೆಸ್ ರಿಜಿಸ್ಟರ್ ಆಗಿದೆ';

  @override
  String get pairingCodeSaveHint =>
      'ಈ ಪೇರಿಂಗ್ ಕೋಡ್ ಉಳಿಸಿಕೊಳ್ಳಿ. ಎರಡನೇ ಫೋನ್ ಲಿಂಕ್ ಮಾಡಲು ಇದನ್ನು ಬಳಸಿ.';

  @override
  String get callbackUrlLabel => 'ಪ್ರೊವೈಡರ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗಾಗಿ Callback URL';

  @override
  String get backToSoundbox => 'ಸೌಂಡ್‌ಬಾಕ್ಸ್‌ಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get copy => 'ಕಾಪಿ ಮಾಡಿ';

  @override
  String get copied => 'ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';

  @override
  String get provider => 'ಪೇಮೆಂಟ್ ಪ್ರೊವೈಡರ್';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'ಬಿಸಿನೆಸ್ ಹೆಸರು';

  @override
  String get businessNameHint => 'ವರದಿಗಳಲ್ಲಿ ಬರುವ ಮತ್ತು ಅನೌನ್ಸ್ ಆಗುವ ಹೆಸರು';

  @override
  String get businessVpa => 'ಬಿಸಿನೆಸ್ UPI ವಿಳಾಸ';

  @override
  String get businessVpaHint => 'stallname@ybl';

  @override
  String get merchantIdLabel => 'ಮರ್ಚೆಂಟ್ ID (MID)';

  @override
  String get merchantIdHint => 'ಪ್ರೊವೈಡರ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಿಂದ';

  @override
  String get saltKeyLabel => 'Salt key';

  @override
  String get saltKeyHint => 'PhonePe salt key';

  @override
  String get saltIndexLabel => 'Salt index';

  @override
  String get webhookTokenLabel => 'Webhook token';

  @override
  String get webhookTokenHint =>
      'Paytm ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಲ್ಲಿ ಹಾಕುವ ಬಲವಾದ ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get secretStorageNote =>
      'ಸೀಕ್ರೆಟ್ ಕೀಯನ್ನು ಸರ್ವರ್‌ನಲ್ಲಿ ಮಾತ್ರ ಸೇವ್ ಮಾಡಲಾಗುತ್ತದೆ, ಆ್ಯಪ್‌ನಲ್ಲಿ ಇದು ಮತ್ತೆ ಕಾಣಿಸುವುದಿಲ್ಲ.';

  @override
  String get registerBusiness => 'ಬಿಸಿನೆಸ್ UPI ನೋಂದಾಯಿಸಿ';

  @override
  String get helpTitle => 'ಸಹಾಯ';

  @override
  String get helpSubtitle => 'ಬಿಸಿನೆಸ್ UPI ಮತ್ತು ಸೌಂಡ್‌ಬಾಕ್ಸ್ ಮಾಹಿತಿ';

  @override
  String get helpWhyTitle => 'ಬಿಸಿನೆಸ್ UPI ಖಾತೆ ಏಕೆ ಬೇಕು?';

  @override
  String get helpWhyBody =>
      'ವೈಯಕ್ತಿಕ UPI ಐಡಿಯಿಂದ ಸರ್ವರ್‌ಗೆ ಪಾವತಿ ದೃಢೀಕರಣ ಸಿಗುವುದಿಲ್ಲ, ಇದರಿಂದ ಸೌಂಡ್‌ಬಾಕ್ಸ್ ಅನೌನ್ಸ್‌ಮೆಂಟ್ ತಪ್ಪಿಹೋಗಬಹುದು. ಬಿಸಿನೆಸ್ ಖಾತೆಯು ಪ್ರತಿಯೊಂದು ಪಾವತಿಯನ್ನು VendorOSಗೆ ಕಳುಹಿಸುತ್ತದೆ, ಹಾಗಾಗಿ ಸೌಂಡ್‌ಬಾಕ್ಸ್‌ನಲ್ಲಿ ಮಿಸ್ ಆಗುವುದಿಲ್ಲ.';

  @override
  String get helpDocsTitle => 'ಬೇಕಾಗುವ ದಾಖಲೆಗಳು';

  @override
  String get helpDocsAadhaar =>
      'ಆಧಾರ್ ನಂಬರ್ ಮತ್ತು ಅದಕ್ಕೆ ಲಿಂಕ್ ಆಗಿರುವ ಮೊಬೈಲ್ ನಂಬರ್';

  @override
  String get helpDocsPan => 'PAN ಕಾರ್ಡ್ (ಸಣ್ಣ ಅಂಗಡಿಗೆ ಪರ್ಸನಲ್ PAN ಸಾಕು)';

  @override
  String get helpDocsBank => 'ಹಣ ಜಮೆಯಾಗಲು ಬ್ಯಾಂಕ್ ಖಾತೆ ನಂಬರ್ ಮತ್ತು IFSC';

  @override
  String get helpDocsShop => 'ಅಂಗಡಿ ಹೆಸರು, ವಿಳಾಸ ಮತ್ತು ಅಂಗಡಿಯ ಫೋಟೋ';

  @override
  String get helpRegisterTitle => 'ಪ್ರೊವೈಡರ್ ಜೊತೆ ನೋಂದಾಯಿಸಿ';

  @override
  String get helpRegisterStep1 =>
      'Play Storeನಿಂದ PhonePe for Business ಅಥವಾ Paytm for Business ಇನ್‌ಸ್ಟಾಲ್ ಮಾಡಿ.';

  @override
  String get helpRegisterStep2 =>
      'ಮೊಬೈಲ್ ನಂಬರ್‌ನಿಂದ ಸೈನ್ ಅಪ್ ಮಾಡಿ ಆಧಾರ್ ಮತ್ತು PAN ಮೂಲಕ KYC ಮುಗಿಸಿ.';

  @override
  String get helpRegisterStep3 =>
      'ಹಣ ಜಮೆಯಾಗಲು ಬ್ಯಾಂಕ್ ಖಾತೆ ಸೇರಿಸಿ, ಉಚಿತ QR ಸ್ಟಿಕ್ಕರ್ ಪಡೆಯಿರಿ.';

  @override
  String get helpRegisterStep4 =>
      'ಆ್ಯಪ್‌ನಲ್ಲಿ ಕಾಣಿಸುವ ಬಿಸಿನೆಸ್ UPI ಐಡಿಯನ್ನು ಬರೆದಿಟ್ಟುಕೊಳ್ಳಿ (ಉದಾ: stallname@ybl).';

  @override
  String get helpKeysTitle => 'Merchant ID ಮತ್ತು ಸೀಕ್ರೆಟ್ ಕೀ';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: ಬಿಸಿನೆಸ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್ ತೆರೆದು Developer settingsಗೆ ಹೋಗಿ merchant id, salt key ಮತ್ತು salt index ಕಾಪಿ ಮಾಡಿ.';

  @override
  String get helpKeysPaytm =>
      'Paytm: ಬಿಸಿನೆಸ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್ ತೆರೆದು Developer settingsಗೆ ಹೋಗಿ MID ಕಾಪಿ ಮಾಡಿ ಮತ್ತು ಬಲವಾದ webhook token ಕ್ರಿಯೇಟ್ ಮಾಡಿ ಇಲ್ಲಿ ನಮೂದಿಸಿ.';

  @override
  String get helpKeysCallback =>
      'ಪಾವತಿಗಳು VendorOSಗೆ ತಲುಪಲು ರಿಜಿಸ್ಟ್ರೇಶನ್ ನಂತರ ಕಾಣಿಸುವ ಕಾಲ್‌ಬ್ಯಾಕ್ URL ಅನ್ನು ಪ್ರೊವೈಡರ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಲ್ಲಿ ಪೇಸ್ಟ್ ಮಾಡಿ.';

  @override
  String get helpLinkTitle => 'ಈ ಫೋನ್ ಲಿಂಕ್ ಮಾಡಿ';

  @override
  String get helpLinkStep1 =>
      'Soundbox ತೆರೆದು \'ಬಿಸಿನೆಸ್ UPI ನೋಂದಾಯಿಸಿ\' ಟ್ಯಾಪ್ ಮಾಡಿ.';

  @override
  String get helpLinkStep2 =>
      'ಫಾರ್ಮ್ ಭರ್ತಿ ಮಾಡಿ; ಫೋನ್ ತಾನಾಗಿಯೇ ಲಿಂಕ್ ಆಗಿ ಪೇರಿಂಗ್ ಕೋಡ್ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get helpLinkStep3 =>
      'ಇನ್ನೊಂದು ಫೋನ್ ಲಿಂಕ್ ಮಾಡಲು, ಅದರಲ್ಲಿ Soundbox ತೆರೆದು ಈ ಪೇರಿಂಗ್ ಕೋಡ್ ಹಾಕಿ.';

  @override
  String get helpSafetyTitle => 'ಸುರಕ್ಷಿತವಾಗಿಡಿ';

  @override
  String get helpSafetyBody =>
      'Salt key ಅಥವಾ webhook token ಅನ್ನು ಯಾರೊಂದಿಗೂ ಹಂಚಿಕೊಳ್ಳಬೇಡಿ. VendorOS ಇದನ್ನು ಸರ್ವರ್‌ನಲ್ಲಿ ಮಾತ್ರ ಇಡುತ್ತದೆ ಮತ್ತು ಮತ್ತೆಂದೂ ತೋರಿಸುವುದಿಲ್ಲ.';

  @override
  String get menuInventory => 'ದಾಸ್ತಾನು';

  @override
  String get productsTitle => 'ಪ್ರಾಡಕ್ಟ್‌ಗಳು';

  @override
  String get productsSubtitle => 'ಕ್ಯಾಟಲಾಗ್ ಮತ್ತು ಸ್ಟಾಕ್';

  @override
  String get productsSearchHint => 'ಹೆಸರು ಅಥವಾ ಕೋಡ್ ಹುಡುಕಿ';

  @override
  String get productsEmpty => 'ಯಾವುದೇ ಪ್ರಾಡಕ್ಟ್ ಇಲ್ಲ. ನಿಮ್ಮ ಮೊದಲ ಐಟಂ ಸೇರಿಸಿ.';

  @override
  String get productsAdd => 'ಪ್ರಾಡಕ್ಟ್ ಸೇರಿಸಿ';

  @override
  String get productsAllChip => 'ಎಲ್ಲಾ';

  @override
  String get productsLowStockChip => 'ಕಡಿಮೆ ಸ್ಟಾಕ್';

  @override
  String get productEditTitle => 'ಪ್ರಾಡಕ್ಟ್ ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get productMissing => 'ಈ ಪ್ರಾಡಕ್ಟ್ ಪಟ್ಟಿಯಲ್ಲಿಲ್ಲ.';

  @override
  String get productSaved => 'ಸೇವ್ ಆಗಿದೆ';

  @override
  String get productArchived => 'ಪ್ರಾಡಕ್ಟ್ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get formInvalid => 'ಪ್ರಾಡಕ್ಟ್ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get fieldName => 'ಹೆಸರು';

  @override
  String get fieldLocalName => 'ತಮಿಳಿನಲ್ಲಿ ಹೆಸರು';

  @override
  String get fieldCode => 'ಕೋಡ್';

  @override
  String get fieldCodeHint => 'ಬಾರ್‌ಕೋಡ್, ಹೊಸದಕ್ಕಾಗಿ ಖಾಲಿ ಬಿಡಿ';

  @override
  String get fieldCategory => 'ಕ್ಯಾಟಗರಿ';

  @override
  String get fieldUnit => 'ಯೂನಿಟ್';

  @override
  String get fieldCost => 'ಖರೀದಿ ಬೆಲೆ';

  @override
  String get fieldPrice => 'ಮಾರಾಟ ಬೆಲೆ';

  @override
  String get fieldReorder => 'ರೀ-ಆರ್ಡರ್ ಲೆವೆಲ್';

  @override
  String get saveLabel => 'ಸೇವ್';

  @override
  String get discardTitle => 'ಬದಲಾವಣೆ ರದ್ದುಮಾಡಬೇಕೆ?';

  @override
  String get discardBody => 'ಸೇವ್ ಮಾಡದ ಬದಲಾವಣೆಗಳಿವೆ.';

  @override
  String get discardKeep => 'ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get discardLeave => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get cancelLabel => 'ರದ್ದು';

  @override
  String get deleteLabel => 'ಡಿಲೀಟ್';

  @override
  String get confirmLabel => 'ಖಚಿತಪಡಿಸಿ';

  @override
  String get qtyLabel => 'ಪ್ರಮಾಣ';

  @override
  String get unitCostLabel => 'ಯೂನಿಟ್ ಬೆಲೆ';

  @override
  String get expiryLabel => 'ಎಕ್ಸ್‌ಪೈರಿ (ದಿನಗಳಲ್ಲಿ)';

  @override
  String get unitKg => 'ಕೆಜಿ';

  @override
  String get unitGram => 'ಗ್ರಾಂ';

  @override
  String get unitPiece => 'ಪೀಸ್';

  @override
  String get unitLitre => 'ಲೀಟರ್';

  @override
  String get unitBundle => 'ಕಟ್ಟು';

  @override
  String get detailSell => 'ಮಾರಾಟ';

  @override
  String get detailRestock => 'ಸ್ಟಾಕ್ ಸೇರಿಸಿ';

  @override
  String get detailWastage => 'ವೇಸ್ಟೇಜ್';

  @override
  String get detailCorrect => 'ಸ್ಟಾಕ್ ಎಣಿಕೆ';

  @override
  String get detailBatches => 'ಬ್ಯಾಚ್‌ಗಳು';

  @override
  String get detailHistory => 'ಹಿಸ್ಟರಿ';

  @override
  String get detailLabel => 'ಲೇಬಲ್ ಪ್ರಿಂಟ್';

  @override
  String get historyEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಸ್ಟಾಕ್ ವಹಿವಾಟು ಇಲ್ಲ';

  @override
  String get soldRecorded => 'ಮಾರಾಟ ದಾಖಲಾಗಿದೆ';

  @override
  String get restocked => 'ಸ್ಟಾಕ್ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get wastageRecorded => 'ವೇಸ್ಟೇಜ್ ದಾಖಲಾಗಿದೆ';

  @override
  String get stockCorrected => 'ಸ್ಟಾಕ್ ಅಪ್ಡೇಟ್ ಆಗಿದೆ';

  @override
  String get movementPurchase => 'ಖರೀದಿ';

  @override
  String get movementSale => 'ಮಾರಾಟ';

  @override
  String get movementWastage => 'ವೇಸ್ಟೇಜ್';

  @override
  String get movementReturn => 'ರಿಟರ್ನ್';

  @override
  String get movementCorrection => 'ತಿದ್ದುಪಡಿ';

  @override
  String get expiredTag => 'ಎಕ್ಸ್‌ಪೈರ್ ಆಗಿದೆ';

  @override
  String get expiryTodayTag => 'ಇಂದೇ ಎಕ್ಸ್‌ಪೈರಿ';

  @override
  String get noExpiry => 'ಎಕ್ಸ್‌ಪೈರಿ ಇಲ್ಲ';

  @override
  String get batchesTitle => 'ಬ್ಯಾಚ್‌ಗಳು';

  @override
  String get batchesSubtitle => 'ಎಕ್ಸ್‌ಪೈರಿ ಪರಿಶೀಲನೆ';

  @override
  String get batchesEmpty => 'ಯಾವುದೇ ಬ್ಯಾಚ್‌ಗಳಿಲ್ಲ';

  @override
  String get stockTitle => 'ಸ್ಟಾಕ್';

  @override
  String get stockSubtitle => 'ಮೌಲ್ಯ, ಅಲರ್ಟ್‌ಗಳು ಮತ್ತು ಎಕ್ಸ್‌ಪೈರಿ';

  @override
  String get stockValuation => 'ಸ್ಟಾಕ್ ಮೌಲ್ಯ';

  @override
  String get stockProfit => 'ಲಾಭ (30 ದಿನ)';

  @override
  String get stockWastage => 'ವೇಸ್ಟೇಜ್ (30 ದಿನ)';

  @override
  String get stockLowTitle => 'ಕಡಿಮೆಯಾಗುತ್ತಿದೆ';

  @override
  String get stockExpiryTitle => 'ಎಕ್ಸ್‌ಪೈರಿ';

  @override
  String get stockNothingLow => 'ಯಾವ ಸ್ಟಾಕ್ ಕೂಡ ಕಡಿಮೆಯಾಗಿಲ್ಲ';

  @override
  String get stockNoExpiry => 'ಎಕ್ಸ್‌ಪೈರಿ ದಿನಾಂಕವಿರುವ ಬ್ಯಾಚ್‌ಗಳಿಲ್ಲ';

  @override
  String get stockReorderNow => 'ರೀ-ಆರ್ಡರ್ ಲಿಸ್ಟ್ ಕಳಿಸಿ';

  @override
  String get suppliersTitle => 'ಸಪ್ಲೈಯರ್‌ಗಳು';

  @override
  String get suppliersSubtitle => 'ರೀ-ಆರ್ಡರ್ ಕಾಂಟ್ಯಾಕ್ಟ್‌ಗಳು';

  @override
  String get suppliersEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಸಪ್ಲೈಯರ್‌ಗಳಿಲ್ಲ';

  @override
  String get supplierAdd => 'ಸಪ್ಲೈಯರ್ ಸೇರಿಸಿ';

  @override
  String get supplierName => 'ಹೆಸರು';

  @override
  String get supplierPhone => 'ಫೋನ್';

  @override
  String get supplierNote => 'ನೋಟ್';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'ಸ್ಕ್ಯಾನ್';

  @override
  String get scanSubtitle => 'ಬಾರ್‌ಕೋಡ್ ಅಥವಾ QR';

  @override
  String get scanUnsupported =>
      'ಕ್ಯಾಮೆರಾ ಸ್ಕ್ಯಾನಿಂಗ್ ಇಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ. ಕೆಳಗೆ ಕೋಡ್ ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get scanPermission => 'ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಕ್ಯಾಮೆರಾ ಅನುಮತಿ ನೀಡಿ';

  @override
  String get scanManualHint => 'ಕೋಡ್ ಟೈಪ್ ಮಾಡಿ ಅಥವಾ ಪೇಸ್ಟ್ ಮಾಡಿ';

  @override
  String get scanCreateFromCode => 'ಈ ಕೋಡ್‌ನೊಂದಿಗೆ ಪ್ರಾಡಕ್ಟ್ ಸೇರಿಸಿ';

  @override
  String get labelsTitle => 'ಲೇಬಲ್‌ಗಳು';

  @override
  String get labelsSubtitle => 'QR ಮತ್ತು ಬಾರ್‌ಕೋಡ್ ಲೇಬಲ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get labelsSelect => 'ಪ್ರಾಡಕ್ಟ್‌ಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get labelsSize => 'ಲೇಬಲ್ ಸೈಜ್';

  @override
  String get labelsSymbology => 'ಕೋಡ್ ಮಾದರಿ';

  @override
  String get labelsCopies => 'ಪ್ರತಿಗಳು';

  @override
  String get labelsPrint => 'ಶೀಟ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get labelsThermal => 'ಪ್ರಿಂಟರ್ ಕೋಡ್ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get labelsCopied => 'ಪ್ರಿಂಟರ್ ಕೋಡ್ ಕಾಪಿ ಆಗಿದೆ';

  @override
  String get labelsNone => 'ಕನಿಷ್ಠ ಒಂದು ಐಟಂ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'ಬಾರ್‌ಕೋಡ್';

  @override
  String get paymentQrTitle => 'ಪಾವತಿ QR';

  @override
  String get paymentQrSubtitle => 'ಗ್ರಾಹಕರು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಹಣ ನೀಡಬಹುದು';

  @override
  String get paymentQrAmountHint => 'ಮೊತ್ತ (ಬೇಕಿದ್ದರೆ)';

  @override
  String get paymentQrNeedVpa => 'ಮೊದಲು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ನಿಮ್ಮ UPI ID ಹಾಕಿ.';

  @override
  String get paymentQrOpenSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್ ತೆರೆಯಿರಿ';

  @override
  String get paymentQrPoster => 'ಪೋಸ್ಟರ್ ಸೇವ್ ಮಾಡಿ';

  @override
  String get paymentQrCopy => 'ಲಿಂಕ್ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get paymentQrCopied => 'ಲಿಂಕ್ ಕಾಪಿ ಆಗಿದೆ';

  @override
  String get paymentQrNote =>
      'ಸ್ಕ್ಯಾನ್ ಮಾಡಿದಾಗ ಗ್ರಾಹಕರ UPI ಆ್ಯಪ್ ತೆರೆಯುತ್ತದೆ. ಸೌಂಡ್‌ಬಾಕ್ಸ್ ಹೇಳಿದ ಮೇಲೆಯೇ ಪಾವತಿ ಆಗಿದೆ ಎಂದು ತಿಳಿಯಿರಿ.';

  @override
  String stockOnHand(String qty) {
    return 'ಸ್ಟಾಕ್‌ನಲ್ಲಿದೆ: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'ಮಾರ್ಜಿನ್ $pct%';
  }

  @override
  String expirySoonTag(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String expiryWatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಬ್ಯಾಚ್ ಗಮನಿಸಬೇಕು',
      one: '1 ಬ್ಯಾಚ್ ಗಮನಿಸಬೇಕು',
      zero: 'ಯಾವುದೂ ಬೇಗ ಎಕ್ಸ್‌ಪೈರ್ ಆಗಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty ಉಳಿದಿದೆ · ಒಂದಕ್ಕೆ $cost';
  }

  @override
  String sellShortfall(String qty) {
    return 'ಸ್ಟಾಕ್‌ನಲ್ಲಿ $qty ಮಾತ್ರ ಇತ್ತು — ಅಷ್ಟನ್ನೇ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String productArchiveConfirm(String name) {
    return 'ಕ್ಯಾಟಲಾಗ್‌ನಿಂದ $name ತೆಗೆದುಹಾಕಬೇಕೆ?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: ದಯವಿಟ್ಟು $items ಕಳುಹಿಸಿ';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return '$vpa ಗೆ ಪಾವತಿ';
  }

  @override
  String scanUnknownCode(String code) {
    return '$code ಕೋಡ್‌ನಲ್ಲಿ ಯಾವುದೇ ಐಟಂ ಇಲ್ಲ';
  }

  @override
  String get profileTitle => 'ವ್ಯಾಪಾರದ ವಿವರ';

  @override
  String get vendorCategory => 'ವ್ಯಾಪಾರದ ಬಗೆ';

  @override
  String get categoryCart => 'ತಳ್ಳುಗಾಡಿ';

  @override
  String get categoryStall => 'ಗಾಡಿ / ಅಂಗಡಿ';

  @override
  String get categoryHotel => 'ಹೋಟೆಲ್ / ತಿಂಡಿ ಅಂಗಡಿ';

  @override
  String get categoryService => 'ಸರ್ವೀಸ್ ಕೆಲಸ';

  @override
  String get nicheLabel => 'ನೀವು ಏನು ಮಾರುತ್ತೀರಿ ಅಥವಾ ಮಾಡುತ್ತೀರಿ?';

  @override
  String get districtLabel => 'ಜಿಲ್ಲೆ';

  @override
  String get talukLabel => 'ತಾಲೂಕು / ಊರು';

  @override
  String get marketAreaLabel => 'ಮಾರ್ಕೆಟ್ / ಏರಿಯಾ';

  @override
  String get fssaiLabel => 'FSSAI ನಂಬರ್ (ಆಹಾರ ವ್ಯಾಪಾರ)';

  @override
  String get udyamLabel => 'UDYAM ನೋಂದಣಿ (ಬೇಕಿದ್ದರೆ)';

  @override
  String get workingHoursLabel => 'ವ್ಯಾಪಾರದ ಸಮಯ';

  @override
  String get perishableLabel => 'ಬೇಗ ಹಾಳಾಗುವ ವಸ್ತುಗಳು';

  @override
  String get profilePromptTitle => 'ನಿಮ್ಮ ವ್ಯಾಪಾರದ ಪ್ರೊಫೈಲ್ ಸೆಟ್ ಮಾಡಿ';

  @override
  String get profilePromptBody =>
      'ನೀವು ಏನನ್ನು ಮಾರಾಟ ಮಾಡುತ್ತೀರಿ ಎಂದು ತಿಳಿಸಿ, ಆ್ಯಪ್ ನಿಮಗೆ ಬೇಕಾದುದನ್ನಷ್ಟೇ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get profilePromptAction => 'ಸೆಟ್ ಮಾಡಿ';

  @override
  String get profileSaved => 'ಪ್ರೊಫೈಲ್ ಸೇವ್ ಆಗಿದೆ';

  @override
  String get expensesTitle => 'ಖರ್ಚುಗಳು';

  @override
  String get expensesSubtitle =>
      'ಹಾಲು, ಗ್ಯಾಸ್, ತಿಂಡಿ, ಬಾಡಿಗೆ — ನೀವು ನೀಡಿದ ಖರ್ಚುಗಳು';

  @override
  String get expenseToday => 'ಇಂದಿನ ಖರ್ಚು';

  @override
  String get expenseAdd => 'ಖರ್ಚು ಸೇರಿಸಿ';

  @override
  String get expenseAmount => 'ಮೊತ್ತ';

  @override
  String get expenseNote => 'ವಿವರ (ಬೇಕಿದ್ದರೆ)';

  @override
  String get expenseTodayList => 'ಇಂದಿನ ಖರ್ಚುಗಳು';

  @override
  String get expenseEmpty => 'ಇಂದು ಯಾವುದೇ ಖರ್ಚು ದಾಖಲಾಗಿಲ್ಲ';

  @override
  String get expenseMilk => 'ಹಾಲು';

  @override
  String get expenseGas => 'ಗ್ಯಾಸ್';

  @override
  String get expenseSnacks => 'ತಿಂಡಿ';

  @override
  String get expenseProvisions => 'ದಿನಸಿ';

  @override
  String get expenseWages => 'ಕೂಲಿ';

  @override
  String get expenseRent => 'ಬಾಡಿಗೆ';

  @override
  String get expenseElectricity => 'ಕರೆಂಟ್ ಬಿಲ್';

  @override
  String get expenseTransport => 'ಸಾರಿಗೆ';

  @override
  String get expenseOther => 'ಇತರೆ';

  @override
  String get recurringTitle => 'ದೈನಂದಿನ ಸಾಮಾನುಗಳು';

  @override
  String get recurringAdd => 'ಸಾಮಾನು ಸೇರಿಸಿ';

  @override
  String get recurringName => 'ಸಾಮಾನಿನ ಹೆಸರು';

  @override
  String get recurringEmpty =>
      'ಹಾಲಿನ ಕ್ಯಾನ್ ಅಥವಾ ತಿಂಡಿಗಳನ್ನು ಇಲ್ಲಿ ಸೇವ್ ಮಾಡಿ, ಒಂದೇ ಕ್ಲಿಕ್‌ನಲ್ಲಿ ಲೆಕ್ಕಕ್ಕೆ ಹಾಕಿ.';

  @override
  String get dayCloseTitle => 'ದಿನ ಮುಕ್ತಾಯ';

  @override
  String get dayCloseExpectedCash => 'ಗಲ್ಲಾದಲ್ಲಿ ಇರಬೇಕಾದ ಹಣ';

  @override
  String get dayCloseBreakdown => 'ಇಂದಿನ ವಹಿವಾಟು';

  @override
  String get dayCloseCollected => 'ವಸೂಲಾದ ಸಾಲ';

  @override
  String get dayCloseWastage => 'ವೇಸ್ಟೇಜ್';

  @override
  String get dayCloseProfit => 'ಇಂದಿನ ಲಾಭ';

  @override
  String get dayCloseCount => 'ಗಲ್ಲಾ ಎಣಿಸಿ';

  @override
  String get dayCloseCountedCash => 'ಎಣಿಸಿದ ಹಣ';

  @override
  String get dayCloseSave => 'ದಿನ ಮುಕ್ತಾಯಗೊಳಿಸಿ';

  @override
  String get dayCloseDiscounts => 'ನೀಡಿದ ಡಿಸ್ಕೌಂಟ್';

  @override
  String get dayCloseTax => 'ಸಂಗ್ರಹಿಸಿದ ತೆರಿಗೆ';

  @override
  String get dayCloseLastToken => 'ಕೊನೆಯ ಟೋಕನ್';

  @override
  String get dayCloseVoided => 'ರದ್ದುಮಾಡಿದ ಬಿಲ್‌ಗಳು';

  @override
  String get dayCloseExport => 'ದಿನದ PDF ಎಕ್ಸ್‌ಪೋರ್ಟ್ ಮಾಡಿ';

  @override
  String get dayCloseVariancePosted =>
      'ಕ್ಯಾಶ್ ವ್ಯತ್ಯಾಸ ಲೆಡ್ಜರ್‌ಗೆ ಸೇರಿಸಲಾಗಿದೆ.';

  @override
  String get dayCloseExportFailed => 'ದಿನದ ಸಾರಾಂಶ ಎಕ್ಸ್‌ಪೋರ್ಟ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get dayCloseMatch => 'ಕ್ಯಾಶ್ ಸರಿಯಾಗಿ ಹೊಂದಿಕೆಯಾಗಿದೆ.';

  @override
  String dayCloseSurplus(String amount) {
    return '$amount ಹೆಚ್ಚಾಗಿದೆ';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount ಕಡಿಮೆಯಾಗಿದೆ';
  }

  @override
  String get insightsTitle => 'ವರದಿಗಳು';

  @override
  String get insightsSubtitle => 'ದಿನ, ವಾರ, ತಿಂಗಳು ಮತ್ತು ವರ್ಷ';

  @override
  String get windowDay => 'ದಿನ';

  @override
  String get windowWeek => 'ವಾರ';

  @override
  String get windowMonth => 'ತಿಂಗಳು';

  @override
  String get windowYear => 'ವರ್ಷ';

  @override
  String get insightsTurnover => 'ವಹಿವಾಟು';

  @override
  String get insightsCosts => 'ಖರ್ಚು';

  @override
  String get insightsProfit => 'ಲಾಭ';

  @override
  String get insightsAvgDay => 'ದಿನಕ್ಕೆ ಸರಾಸರಿ';

  @override
  String get insightsByDay => 'ದಿನದಿಂದ ದಿನಕ್ಕೆ';

  @override
  String get insightsBestDay => 'ಅತ್ಯುತ್ತಮ ದಿನ';

  @override
  String get insightsTopItems => 'ಹೆಚ್ಚು ಮಾರಾಟವಾದವು';

  @override
  String get insightsCostSplit => 'ಹಣ ಎಲ್ಲಿ ಖರ್ಚಾಗಿದೆ';

  @override
  String get insightsEmpty => 'ಈ ಅವಧಿಯಲ್ಲಿ ಯಾವುದೇ ದಾಖಲೆಯಿಲ್ಲ';

  @override
  String get insightsMarginAlert => 'ಮಾರ್ಜಿನ್ ಎಚ್ಚರಿಕೆ';

  @override
  String get insightsMarginBody =>
      'ಈ ಐಟಂಗಳು ಅಸಲು ಬೆಲೆಯ ಹತ್ತಿರವೇ ಮಾರಾಟವಾಗುತ್ತಿವೆ. ಬೆಲೆ ಏರಿಸಿ ಅಥವಾ ಖರ್ಚು ಕಡಿಮೆ ಮಾಡಿ.';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'ಅಸಲು $cost · ಬೆಲೆ $price';
  }

  @override
  String get quickSaleTitle => 'ತ್ವರಿತ ಮಾರಾಟ';

  @override
  String get quickSaleSubtitle =>
      'ಒಂದು ಕಪ್‌ಗೆ ಒಂದು ಟ್ಯಾಪ್ — ದೊಡ್ಡ ಆರ್ಡರ್‌ಗೆ ಲಾಂಗ್ ಪ್ರೆಸ್ ಮಾಡಿ';

  @override
  String get quickSaleQty => 'ಪ್ರಮಾಣ';

  @override
  String quickSaleQtyTitle(String item) {
    return 'ಎಷ್ಟು $item?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount ದಾಖಲಾಗಿದೆ';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return '$amount ಗೆ ಒಂದು $item ಮಾರಿ';
  }

  @override
  String get quickSaleEmpty =>
      'ತ್ವರಿತ ಮೆನು ಬಳಸಲು ಬೆಲೆಯೊಂದಿಗೆ ಐಟಂಗಳನ್ನು ಸೇರಿಸಿ.';

  @override
  String get starterPackAction => 'ನನ್ನ ಅಂಗಡಿಗೆ ಸ್ಟಾರ್ಟರ್ ಕಿಟ್ ಲೋಡ್ ಮಾಡಿ';

  @override
  String get starterTea => 'ಟೀ';

  @override
  String get starterCoffee => 'ಕಾಫಿ';

  @override
  String get starterBun => 'ಬನ್';

  @override
  String get starterBiscuit => 'ಬಿಸ್ಕೆಟ್';

  @override
  String get starterBajji => 'ಬಜ್ಜಿ';

  @override
  String get starterMilkSupply => 'ಹಾಲು ಕ್ಯಾನ್‌ಗಳು';

  @override
  String get starterSnackSupply => 'ಸ್ನ್ಯಾಕ್ಸ್ ಟ್ರೇ';

  @override
  String get menuDailyWork => 'ದಿನನಿತ್ಯದ ಕೆಲಸ';

  @override
  String get stockOut => 'ಸ್ಟಾಕ್ ಖಾಲಿಯಾಗಿದೆ';

  @override
  String get ordersTitle => 'ಆರ್ಡರ್‌ಗಳು';

  @override
  String get ordersSubtitle => 'ಕೌಂಟರ್ ಮತ್ತು QR ಆರ್ಡರ್‌ಗಳು, ಲೈವ್';

  @override
  String get orderCounterNew => 'ಹೊಸ ಕೌಂಟರ್ ಆರ್ಡರ್';

  @override
  String get orderTable => 'ಟೇಬಲ್';

  @override
  String get orderRemoveItem => 'ಒಂದು ತೆಗೆಯಿರಿ';

  @override
  String get orderAddItem => 'ಒಂದು ಸೇರಿಸಿ';

  @override
  String get orderCancelReason => 'ಕ್ಯಾನ್ಸಲ್ ಮಾಡಲು ಕಾರಣ';

  @override
  String get orderCancel => 'ಆರ್ಡರ್ ಕ್ಯಾನ್ಸಲ್ ಮಾಡಿ';

  @override
  String get orderLive => 'ಲೈವ್';

  @override
  String get orderHistory => 'ಹಿಸ್ಟರಿ';

  @override
  String get orderEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಆರ್ಡರ್‌ಗಳಿಲ್ಲ.';

  @override
  String get orderNew => 'ಹೊಸದು';

  @override
  String get orderPreparing => 'ರೆಡಿಯಾಗುತ್ತಿದೆ';

  @override
  String get orderServed => 'ಸರ್ವ್ ಆಗಿದೆ';

  @override
  String get orderPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get orderCancelled => 'ಕ್ಯಾನ್ಸಲ್ ಆಗಿದೆ';

  @override
  String get orderAccept => 'ಸ್ವೀಕರಿಸಿ';

  @override
  String get orderServe => 'ಸರ್ವ್ ಮಾಡಿ';

  @override
  String get orderBulkAccept => 'ಎಲ್ಲ ಹೊಸದನ್ನು ಸ್ವೀಕರಿಸಿ';

  @override
  String get orderBulkServe => 'ರೆಡಿ ಇರುವುದನ್ನು ಸರ್ವ್ ಮಾಡಿ';

  @override
  String get orderBill => 'ಬಿಲ್';

  @override
  String get orderTokenShort => 'ಟೋಕನ್';

  @override
  String get kotTitle => 'ಕಿಚನ್';

  @override
  String get kotSubtitle => 'ಮುಂದೆ ಏನು ತಯಾರಿಸಬೇಕು';

  @override
  String get kotEmpty => 'ಕಿಚನ್ ಕ್ಯೂ ಖಾಲಿಯಾಗಿದೆ.';

  @override
  String get kotDone => 'ರೆಡಿಯಾಗಿದೆ';

  @override
  String get billTitle => 'ಬಿಲ್';

  @override
  String get billNumberLabel => 'ಬಿಲ್';

  @override
  String get billSubtotal => 'ಸಬ್‌ಟೋಟಲ್';

  @override
  String get billDiscount => 'ಡಿಸ್ಕೌಂಟ್';

  @override
  String get billDiscountFlat => 'ಡಿಸ್ಕೌಂಟ್ ಮೊತ್ತ';

  @override
  String get billDiscountPct => 'ಡಿಸ್ಕೌಂಟ್ %';

  @override
  String get billTax => 'GST';

  @override
  String get billTaxable => 'ಟ್ಯಾಕ್ಸಬಲ್ ಮೊತ್ತ';

  @override
  String get billCgst => 'CGST';

  @override
  String get billSgst => 'SGST';

  @override
  String get billIgst => 'IGST';

  @override
  String get shopGstRegistered => 'GST ನೋಂದಾಯಿತ ಅಂಗಡಿ';

  @override
  String get shopGstRegisteredHint =>
      'ಬಿಲ್‌ಗಳಲ್ಲಿ CGST/SGST ವಿವರ ಮತ್ತು ಐಟಂ HSN ಕೋಡ್‌ಗಳು ಕಾಣಿಸುತ್ತವೆ';

  @override
  String get shopPriceIncludesTax => 'ಬೆಲೆಗಳಲ್ಲಿ ಈಗಾಗಲೇ ತೆರಿಗೆ ಸೇರಿದೆ';

  @override
  String get productTaxRate => 'GST ದರ %';

  @override
  String get productHsn => 'HSN / SAC ಕೋಡ್';

  @override
  String get productTaxHint => 'ಅಂಗಡಿ ದರ ಬಳಸಲು ಖಾಲಿ ಬಿಡಿ';

  @override
  String get billRounding => 'ರೌಂಡಿಂಗ್';

  @override
  String get billTotal => 'ಒಟ್ಟು';

  @override
  String get billPaid => 'ಪಾವತಿಸಿದ್ದು';

  @override
  String get billBalance => 'ಬಾಕಿ';

  @override
  String get billReprint => 'ರೀಪ್ರಿಂಟ್';

  @override
  String get billShare => 'ಶೇರ್';

  @override
  String get billThanks => 'ಧನ್ಯವಾದ, ಮತ್ತೆ ಬನ್ನಿ';

  @override
  String get billCustomer => 'ಗ್ರಾಹಕರು';

  @override
  String get billSplit => 'ಪಾವತಿ';

  @override
  String get billRoundToRupee => 'ರೂಪಾಯಿಗೆ ರೌಂಡ್ ಮಾಡಿ';

  @override
  String get billFillCash => 'ಬಾಕಿ ಮೊತ್ತವನ್ನು ನಗದಾಗಿ ಹಾಕಿ';

  @override
  String get billFullyPaid => 'ಪೂರ್ತಿ ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get billSettle => 'ಬಿಲ್ ಸೆಟಲ್ ಮಾಡಿ';

  @override
  String get close => 'ಮುಚ್ಚಿ';

  @override
  String get billPreview => 'ಪೇಪರ್ ಪ್ರಿವ್ಯೂ';

  @override
  String get billVoid => 'ಬಿಲ್ ರದ್ದು ಮಾಡಿ';

  @override
  String get billVoidTitle => 'ಈ ಬಿಲ್ ರದ್ದು ಮಾಡಿ';

  @override
  String get billVoidHint =>
      'ಬಿಲ್ ಸಂಖ್ಯೆ ಹಾಗೇ ಇರುತ್ತದೆ ಮತ್ತು ಲೆಡ್ಜರ್ ನಮೂದುಗಳನ್ನು ವಾಪಸ್ ಮಾಡಲಾಗುತ್ತದೆ.';

  @override
  String get billVoidReason => 'ಕಾರಣ';

  @override
  String get billVoidReasonRequired => 'ಬಿಲ್ ರದ್ದು ಮಾಡಲು ಕಾರಣ ಬೇಕು';

  @override
  String get billVoided => 'ಬಿಲ್ ರದ್ದು ಮಾಡಲಾಗಿದೆ';

  @override
  String get billVoidFailed => 'ಈ ಬಿಲ್ ರದ್ದು ಮಾಡಲು ಸಾಧ್ಯವಾಗಿಲ್ಲ';

  @override
  String get billAudit => 'ಬಿಲ್ ಹಿಸ್ಟರಿ';

  @override
  String get menuTitle => 'QR ಮೆನು';

  @override
  String get menuSubtitle => 'ಗ್ರಾಹಕರು ಸ್ಕ್ಯಾನ್ ಮಾಡಿದಾಗ ಕಾಣಿಸುವುದು';

  @override
  String get menuShopSection => 'ಅಂಗಡಿ';

  @override
  String get menuSlug => 'ಲಿಂಕ್‌ನಲ್ಲಿರುವ ಮೆನು ಹೆಸರು';

  @override
  String get menuBaseUrl => 'ಮೆನು ವೆಬ್ ವಿಳಾಸ';

  @override
  String get menuTableCount => 'ಟೇಬಲ್‌ಗಳು';

  @override
  String get menuTaxPercent => 'GST %';

  @override
  String get menuGstin => 'GSTIN';

  @override
  String get menuAcceptOrders => 'QR ಆರ್ಡರ್‌ಗಳನ್ನು ಸ್ವೀಕರಿಸಿ';

  @override
  String get menuSaved => 'ಮೆನು ಸೆಟ್ಟಿಂಗ್ಸ್ ಸೇವ್ ಆಗಿದೆ';

  @override
  String get menuQrSheet => 'QR ಶೀಟ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get menuLinkSection => 'ಅಂಗಡಿ QR';

  @override
  String get menuItemsSection => 'ಮೆನುವಿನಲ್ಲಿರುವ ಐಟಂಗಳು';

  @override
  String get menuSoldOut => 'ಖಾಲಿಯಾಗಿದೆ';

  @override
  String get menuPublished => 'ಮೆನುವಿನಲ್ಲಿದೆ';

  @override
  String get menuCounterQr => 'ಕೌಂಟರ್';

  @override
  String get menuScanHint => 'ಮೆನು ನೋಡಿ ಆರ್ಡರ್ ಮಾಡಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get printersTitle => 'ರಸೀದಿ ಪ್ರಿಂಟರ್';

  @override
  String get printersSubtitle => 'ಪೇಪರ್ ಸೈಜ್, ಕನೆಕ್ಷನ್ ಮತ್ತು ಟೆಸ್ಟ್ ಪ್ರಿಂಟ್';

  @override
  String get printerWidth => 'ಪೇಪರ್ ಅಗಲ';

  @override
  String get printerTransport => 'ಕನೆಕ್ಷನ್';

  @override
  String get printerPdf => 'PDF / ಶೇರ್';

  @override
  String get printerBluetooth => 'Bluetooth';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'ಪ್ರಿಂಟರ್ ಹೆಸರು';

  @override
  String get printerDeviceAddress => 'ಪ್ರಿಂಟರ್ ವಿಳಾಸ';

  @override
  String get printerFallbackNote =>
      'ಈ ಡಿವೈಸ್‌ಗೆ ನೇರವಾಗಿ ಪ್ರಿಂಟ್ ಮಾಡಲು ಸಿದ್ಧವಾಗಿಲ್ಲ, ಆದ್ದರಿಂದ ಬಿಲ್ PDF ಆಗಿ ತೆರೆಯುತ್ತದೆ. ನೀವು ಪ್ರಿಂಟ್ ಅಥವಾ ಶೇರ್ ಮಾಡಬಹುದು.';

  @override
  String get printerAutoPrint => 'ಆಟೋಮ್ಯಾಟಿಕ್ ಆಗಿ ಬಿಲ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get printerKot => 'ಕಿಚನ್ ಟಿಕೆಟ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get printerTest => 'ಟೆಸ್ಟ್ ಪ್ರಿಂಟ್';

  @override
  String get printerTestSent => 'ಟೆಸ್ಟ್ ರಸೀದಿ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get printerPaired => 'ಪೇರ್ ಆಗಿರುವ ಪ್ರಿಂಟರ್‌ಗಳು';

  @override
  String get printerScan => 'ಪೇರ್ಡ್ ಪ್ರಿಂಟರ್ ಹುಡುಕಿ';

  @override
  String get printerScanning => 'ಹುಡುಕಲಾಗುತ್ತಿದೆ…';

  @override
  String get printerNoDevices =>
      'ಯಾವುದೇ ಪೇರ್ಡ್ ಪ್ರಿಂಟರ್ ಸಿಗಲಿಲ್ಲ. ಮೊದಲು Android Bluetooth ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಪೇರ್ ಮಾಡಿ.';

  @override
  String get printerConnect => 'ಕನೆಕ್ಟ್ ಮಾಡಿ';

  @override
  String get printerConnected => 'ಪ್ರಿಂಟರ್ ಕನೆಕ್ಟ್ ಆಗಿದೆ';

  @override
  String get printerConnectFailed =>
      'ಕನೆಕ್ಟ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ. ಪ್ರಿಂಟರ್ ಆನ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get printerBluetoothNote =>
      'ಬಿಲ್‌ಗಳು ನೇರವಾಗಿ ಈ Bluetooth ಪ್ರಿಂಟರ್‌ನಲ್ಲಿ ಪ್ರಿಂಟ್ ಆಗುತ್ತವೆ. ಅದು ಆಫ್ ಆಗಿದ್ದರೆ ಅಥವಾ ರೇಂಜ್‌ನಲ್ಲಿ ಇಲ್ಲದಿದ್ದರೆ ಬಿಲ್ PDF ಆಗಿ ತೆರೆಯುತ್ತದೆ, ಯಾವುದೂ ಮಿಸ್ ಆಗಲ್ಲ.';

  @override
  String orderToken(int token) {
    return 'ಟೋಕನ್ $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಐಟಂಗಳು',
      one: '1 ಐಟಂ',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'ಬಿಲ್ $number ಸೆಟ್ಲ್ ಆಗಿದೆ';
  }

  @override
  String get dayCloseOrders => 'ಇಂದಿನ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get dayCloseOrdersTaken => 'ಸ್ವೀಕರಿಸಿದ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get dayCloseOrdersCancelled => 'ಕ್ಯಾನ್ಸಲ್ ಆದವು';

  @override
  String get dayCloseOrdersOpen => 'ಇನ್ನೂ ಬಾಕಿ ಇವೆ';

  @override
  String get dayCloseOrdersBilled => 'ಬಿಲ್ ಆದವು';

  @override
  String get dayCloseAvgTicket => 'ಸರಾಸರಿ ಬಿಲ್ ಮೊತ್ತ';

  @override
  String get menuCloudSection => 'ಕ್ಲೌಡ್ ಬೋರ್ಡ್';

  @override
  String get menuShopKey => 'ಶಾಪ್ ಕೀ (16+ ಅಕ್ಷರಗಳು)';

  @override
  String get menuCloudSync => 'ಆರ್ಡರ್‌ಗಳನ್ನು ಕ್ಲೌಡ್ ಜೊತೆ ಸಿಂಕ್ ಮಾಡಿ';

  @override
  String get menuCloudPublish => 'ಮೆನುವನ್ನು ಕ್ಲೌಡ್‌ಗೆ ಪಬ್ಲಿಷ್ ಮಾಡಿ';

  @override
  String menuCloudPublished(int count) {
    return 'ಕ್ಲೌಡ್ ಮೆನುವಿಗೆ $count ಐಟಂಗಳನ್ನು ಪಬ್ಲಿಷ್ ಮಾಡಲಾಗಿದೆ';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'ಕ್ಲೌಡ್ ದೋಷ: $reason';
  }

  @override
  String get menuCloudLive => 'ಲೈವ್: QR ಆರ್ಡರ್‌ಗಳು ನೇರವಾಗಿ ಬೋರ್ಡ್‌ಗೆ ಬರುತ್ತವೆ.';

  @override
  String get menuCloudOffline =>
      'ಲೋಕಲ್ ಮಾತ್ರ. QR ಆರ್ಡರ್‌ಗಳನ್ನು ಪಡೆಯಲು ಶಾಪ್ ಕೀ ಸೇರಿಸಿ ಸಿಂಕ್ ಆನ್ ಮಾಡಿ.';

  @override
  String get settleTitle => 'ಉದ್ದರಿ ಚುಕ್ತಾ ಮಾಡಿ';

  @override
  String get settleAmountSection => 'ಚುಕ್ತಾ';

  @override
  String get settleAmount => 'ಮೊತ್ತ';

  @override
  String get settleCash => 'ಕ್ಯಾಶ್';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'ಹೊಸ ಸಾಲ';

  @override
  String get settleNote => 'ಟಿಪ್ಪಣಿ';

  @override
  String get settleCashHint =>
      'ಬಂದ ನಗದು ಬಾಕಿಯನ್ನು ಮುಗಿಸುತ್ತದೆ ಮತ್ತು ಇಂದಿನ ಕ್ಯಾಶ್ ಲೆಕ್ಕಕ್ಕೆ ಸೇರುತ್ತದೆ.';

  @override
  String get settleUpiHint =>
      'UPI ಮೂಲಕ ಪಡೆದು ಕನ್ಫರ್ಮ್ ಮಾಡಿ. ಬಾಕಿ ಮುಕ್ತಾಯವಾಗಿ ಇಂದಿನ UPI ಲೆಕ್ಕ ಹೆಚ್ಚಾಗುತ್ತದೆ.';

  @override
  String get settleLoanHint =>
      'ಹಳೆಯ ಬಾಕಿ ಮುಕ್ತಾಯವಾಗಿ ಅದೇ ಮೊತ್ತ ಹೊಸ ಸಾಲವಾಗಿ ಮುಂದುವರಿಯುತ್ತದೆ.';

  @override
  String get settleConfirm => 'ಚುಕ್ತಾ ಮಾಡಿ';

  @override
  String get settleDone => 'ಚುಕ್ತಾ ದಾಖಲಾಗಿದೆ';

  @override
  String get settleHistory => 'ಇತ್ತೀಚಿನ ಚುಕ್ತಾಗಳು';

  @override
  String settleTooMuch(String amount) {
    return 'ಬಾಕಿ ಇರುವ ₹$amount ಗಿಂತ ಹೆಚ್ಚು';
  }

  @override
  String settleLedgerItem(String name) {
    return 'ಉದ್ದರಿ ಚುಕ್ತಾ ಆಗಿದೆ — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'ಉದ್ದರಿ ಹೊಸ ಸಾಲಕ್ಕೆ ಬದಲಾಗಿದೆ — $name';
  }

  @override
  String get menuAddress => 'ಅಂಗಡಿ ವಿಳಾಸ';

  @override
  String get menuPhone => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get menuFssai => 'FSSAI ಲೈಸೆನ್ಸ್';

  @override
  String get menuGrowSection => 'ಬೆಳವಣಿಗೆ ಮತ್ತು ನಿರ್ವಹಣೆ';

  @override
  String get recipesTitle => 'ರೆಸಿಪಿ ಬುಕ್';

  @override
  String get recipesSubtitle => 'ನಿಮ್ಮ ಅಳತೆಗಳು, ಒಮ್ಮೆ ಬರೆದಿಡಿ';

  @override
  String get recipeAdd => 'ಡಿಶ್ ಸೇರಿಸಿ';

  @override
  String get recipeName => 'ಡಿಶ್ ಹೆಸರು';

  @override
  String get recipeServings => 'ಎಷ್ಟು ಪ್ಲೇಟ್ ಆಗುತ್ತದೆ';

  @override
  String get recipeEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಡಿಶ್ ಸೇರಿಸಿಲ್ಲ.';

  @override
  String get recipeIngredients => 'ಬೇಕಾಗುವ ಪದಾರ್ಥಗಳು';

  @override
  String get recipeSteps => 'ಮಾಡುವ ವಿಧಾನ';

  @override
  String get recipeAddIngredient => 'ಪದಾರ್ಥ ಸೇರಿಸಿ';

  @override
  String get recipeAddStep => 'ಹಂತ ಸೇರಿಸಿ';

  @override
  String get recipeQty => 'ಪ್ರಮಾಣ';

  @override
  String get recipeLinkProduct => 'ಸ್ಟಾಕ್‌ನಿಂದ ತೆಗೆದುಕೊಳ್ಳಿ';

  @override
  String get recipeNoLink => 'ಸ್ಟಾಕ್‌ನಿಂದಲ್ಲ';

  @override
  String get recipeCost => 'ಸಾಮಗ್ರಿ ವೆಚ್ಚ';

  @override
  String get recipePerServing => 'ಪ್ಲೇಟ್ ವೆಚ್ಚ';

  @override
  String get recipeScale => 'ಇಷ್ಟು ಪ್ಲೇಟ್‌ಗೆ ಮಾಡಿ';

  @override
  String get recipeCookBatch => 'ಸ್ಟಾಕ್‌ನಿಂದ ಸಾಮಗ್ರಿಗಳನ್ನು ಕಳೆಯಿರಿ';

  @override
  String get recipeCooked => 'ಸ್ಟಾಕ್‌ನಿಂದ ಸಾಮಗ್ರಿ ತೆಗೆಯಲಾಗಿದೆ';

  @override
  String get recipeStepsEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಹಂತಗಳನ್ನು ಬರೆದಿಲ್ಲ.';

  @override
  String get recipeUnlinkedWarning =>
      'ಸ್ಟಾಕ್‌ಗೆ ಲಿಂಕ್ ಮಾಡದ ಐಟಂಗಳನ್ನು ವೆಚ್ಚದಲ್ಲಿ ಸೇರಿಸಿಲ್ಲ.';

  @override
  String get jobsTitle => 'ಕಸ್ಟಮ್ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get jobsSubtitle =>
      'ಅಡ್ವಾನ್ಸ್ ಬುಕಿಂಗ್ ಮತ್ತು ಆರ್ಡರ್ ಮೇಲೆ ಮಾಡುವ ಕೆಲಸಗಳು';

  @override
  String get jobAdd => 'ಆರ್ಡರ್ ತೆಗೆದುಕೊಳ್ಳಿ';

  @override
  String get jobTitleField => 'ಏನು ತಯಾರು ಮಾಡಬೇಕು';

  @override
  String get jobCustomer => 'ಗ್ರಾಹಕರು';

  @override
  String get jobPhone => 'ಫೋನ್';

  @override
  String get jobPrice => 'ಬೆಲೆ';

  @override
  String get jobAdvance => 'ಪಡೆದ ಅಡ್ವಾನ್ಸ್';

  @override
  String get jobDue => 'ಕೊಡುವ ದಿನ';

  @override
  String get jobEmpty => 'ಇಲ್ಲಿ ಯಾವುದೇ ಆರ್ಡರ್‌ಗಳಿಲ್ಲ.';

  @override
  String get jobStatusTaken => 'ತೆಗೆದುಕೊಂಡಿದ್ದು';

  @override
  String get jobStatusMaking => 'ತಯಾರಾಗುತ್ತಿದೆ';

  @override
  String get jobStatusReady => 'ರೆಡಿಯಾಗಿದೆ';

  @override
  String get jobStatusDelivered => 'ಕೊಡಲಾಗಿದೆ';

  @override
  String get jobStatusCancelled => 'ರದ್ದುಮಾಡಲಾಗಿದೆ';

  @override
  String get jobAdvanceStatus => 'ಮುಂದೆ ಸರಿಸಿ';

  @override
  String get jobCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get jobRemind => 'WhatsApp ನಲ್ಲಿ ಮೆಸೇಜ್ ಮಾಡಿ';

  @override
  String get jobFilterOpen => 'ಓಪನ್';

  @override
  String get jobFilterToday => 'ಇಂದು ಕೊಡಬೇಕು';

  @override
  String get jobFilterDone => 'ಮುಗಿದಿದೆ';

  @override
  String get customersTitle => 'ರೆಗ್ಯುಲರ್ ಗ್ರಾಹಕರು';

  @override
  String get customersSubtitle =>
      'ಯಾರು ಮತ್ತೆ ಬರುತ್ತಾರೆ, ಅವರು ನಿಮ್ಮನ್ನು ಹೇಗೆ ಕಂಡುಕೊಂಡರು';

  @override
  String get customerAdd => 'ಗ್ರಾಹಕರನ್ನು ಸೇರಿಸಿ';

  @override
  String get customerName => 'ಹೆಸರು';

  @override
  String get customerPhone => 'ಫೋನ್';

  @override
  String get sourceWalkIn => 'ನೇರವಾಗಿ ಬಂದವರು';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'ಸ್ನೇಹಿತರು ಹೇಳಿದ್ದು';

  @override
  String get sourceOther => 'ಇತರೆ';

  @override
  String get customerRecordVisit => 'ಭೇಟಿ ಸೇರಿಸಿ';

  @override
  String get customerVisitAmount => 'ಮೊತ್ತ';

  @override
  String get customerRewardDue => 'ಫ್ರೀ ಐಟಂ ಬಾಕಿ ಇದೆ';

  @override
  String get customerGiveReward => 'ಫ್ರೀ ಐಟಂ ಕೊಡಿ';

  @override
  String get customersEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ರೆಗ್ಯುಲರ್ ಗ್ರಾಹಕರಿಲ್ಲ.';

  @override
  String get customerSourceSplit => 'ಹಣ ಎಲ್ಲಿಂದ ಬರುತ್ತದೆ';

  @override
  String get eventsTitle => 'ಈವೆಂಟ್‌ಗಳು ಮತ್ತು ಪ್ರದರ್ಶನಗಳು';

  @override
  String get eventsSubtitle => 'ಸ್ಟಾಲ್‌ನಿಂದ ಲಾಭ ಆಯ್ತಾ?';

  @override
  String get eventAdd => 'ಈವೆಂಟ್ ಸೇರಿಸಿ';

  @override
  String get eventName => 'ಈವೆಂಟ್ ಹೆಸರು';

  @override
  String get eventPlace => 'ಸ್ಥಳ';

  @override
  String get eventDay => 'ದಿನಾಂಕ';

  @override
  String get eventRent => 'ಸ್ಟಾಲ್ ಬಾಡಿಗೆ';

  @override
  String get eventTravel => 'ಪ್ರಯಾಣ ವೆಚ್ಚ';

  @override
  String get eventOther => 'ಇತರ ಖರ್ಚು';

  @override
  String get eventSales => 'ಮಾರಾಟ';

  @override
  String get eventFootfall => 'ಭೇಟಿ ನೀಡಿದವರು';

  @override
  String get eventProfit => 'ಲಾಭ';

  @override
  String get eventLoss => 'ನಷ್ಟ';

  @override
  String get eventPerVisitor => 'ಪ್ರತಿ ಗ್ರಾಹಕರಿಗೆ';

  @override
  String get eventsEmpty => 'ಯಾವುದೇ ಈವೆಂಟ್ ದಾಖಲಿಸಿಲ್ಲ.';

  @override
  String get staffTitle => 'ಕೆಲಸಗಾರರು';

  @override
  String get staffSubtitle => 'ಹಾಜರಾತಿ, ಅಡ್ವಾನ್ಸ್ ಮತ್ತು ಸಂಬಳ';

  @override
  String get staffAdd => 'ಕೆಲಸಗಾರರನ್ನು ಸೇರಿಸಿ';

  @override
  String get staffName => 'ಹೆಸರು';

  @override
  String get staffPhone => 'ಫೋನ್';

  @override
  String get staffRole => 'ಕೆಲಸ';

  @override
  String get staffWage => 'ದಿನಗೂಲಿ';

  @override
  String get staffPresent => 'ಹಾಜರು';

  @override
  String get staffHalf => 'ಅರ್ಧ ದಿನ';

  @override
  String get staffAbsent => 'ಗೈರುಹಾಜರು';

  @override
  String get staffAdvance => 'ಅಡ್ವಾನ್ಸ್';

  @override
  String get staffAdvanceAdd => 'ಅಡ್ವಾನ್ಸ್ ಕೊಡಿ';

  @override
  String get staffPayable => 'ಈ ತಿಂಗಳ ಬಾಕಿ ಸಂಬಳ';

  @override
  String get staffEmpty => 'ಯಾವ ಕೆಲಸಗಾರರನ್ನೂ ಸೇರಿಸಿಲ್ಲ.';

  @override
  String get staffRemove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get growthTitle => 'ಗ್ರೋತ್ ಕಿಟ್';

  @override
  String get growthSubtitle => 'ಹೆಚ್ಚು ಗ್ರಾಹಕರನ್ನು ಸೆಳೆಯಿರಿ';

  @override
  String get growthMenuLink => 'ನಿಮ್ಮ ಮೆನು ಲಿಂಕ್';

  @override
  String get growthShareMenu => 'ಮೆನು ಕಳುಹಿಸಿ';

  @override
  String get growthAskReview => 'ರಿವ್ಯೂ ಕೇಳಿ';

  @override
  String get growthOpenMaps => 'Maps ಪೇಜ್ ತೆರೆಯಿರಿ';

  @override
  String get growthWhatsappBroadcast => 'WhatsApp ನಲ್ಲಿ ಗ್ರಾಹಕರಿಗೆ ತಿಳಿಸಿ';

  @override
  String get growthLinksSection => 'ನಿಮ್ಮ ಲಿಂಕ್‌ಗಳು';

  @override
  String get growthMapsUrl => 'Google Maps ಲಿಂಕ್';

  @override
  String get growthReviewUrl => 'ರಿವ್ಯೂ ಲಿಂಕ್';

  @override
  String get growthInstagram => 'Instagram ಹೆಸರು';

  @override
  String get growthLoyalty => 'ಎಷ್ಟು ಬಾರಿ ಬಂದರೆ ಒಂದು ಉಚಿತ';

  @override
  String get growthIdeas => 'ಈ ವಾರದ ಪೋಸ್ಟ್ ಐಡಿಯಾಗಳು';

  @override
  String get growthShareIdea => 'ಕಳುಹಿಸಿ';

  @override
  String get growthIdea1 => 'ಬೆಳಗ್ಗೆ ಮೊದಲ ಬ್ಯಾಚ್ ರೆಡಿ ಮಾಡುವ ಸಣ್ಣ ವಿಡಿಯೋ.';

  @override
  String get growthIdea2 =>
      'ಇವತ್ತಿನ ಸ್ಪೆಷಲ್ ಜೊತೆಗೆ ಬೆಲೆಯನ್ನು ಸ್ಪಷ್ಟವಾಗಿ ಬರೆಯಿರಿ.';

  @override
  String get growthIdea3 =>
      'ಯಾವಾಗಲೂ ಬರುವ ಗ್ರಾಹಕರು ತಮ್ಮ ಇಷ್ಟದ ಆರ್ಡರ್ ಹಿಡಿದಿರುವ ಫೋಟೋ.';

  @override
  String get growthIdea4 => 'ಕೌಂಟರ್ ಹಿಂದೆ: ಪ್ರತಿದಿನ ಅಂಗಡಿ ಹೇಗೆ ತೆರೆಯಲಾಗುತ್ತದೆ.';

  @override
  String get growthIdea5 => 'ವಾರಾಂತ್ಯದ ಆಫರ್, ಎರಡು ದಿನ ಮಾತ್ರ ಇರುತ್ತದೆ.';

  @override
  String get growthSaved => 'ಸೇವ್ ಆಗಿದೆ';

  @override
  String get checklistTitle => 'ತೆರೆಯುವ ಮತ್ತು ಮುಚ್ಚುವ ಪಟ್ಟಿ';

  @override
  String get checklistSubtitle => 'ಮರೆತರೆ ದಿನವೇ ಹಾಳಾಗುವ ಸಣ್ಣ ಪುಟ್ಟ ವಿಷಯಗಳು';

  @override
  String get checklistOpening => 'ತೆರೆಯುವ ಮೊದಲು';

  @override
  String get checklistClosing => 'ಮುಚ್ಚುವ ಮೊದಲು';

  @override
  String get checklistAdd => 'ಪಟ್ಟಿಗೆ ಸೇರಿಸಿ';

  @override
  String get checklistItem => 'ಏನು ಚೆಕ್ ಮಾಡಬೇಕು';

  @override
  String get checklistEmpty => 'ಪಟ್ಟಿಯಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ.';

  @override
  String get checklistUseStarter => 'ಮಾದರಿ ಪಟ್ಟಿ ಬಳಸಿ';

  @override
  String get checklistSeed1 => 'ಚಿಲ್ಲರೆ ಹಣ ರೆಡಿ ಇಟ್ಟುಕೊಂಡಿದೆ';

  @override
  String get checklistSeed2 => 'ಗ್ಯಾಸ್ ಮತ್ತು ಹಾಲು ಚೆಕ್ ಮಾಡಿದೆ';

  @override
  String get checklistSeed3 => 'QR ಸ್ಟ್ಯಾಂಡ್ ಮತ್ತು ರೇಟ್ ಬೋರ್ಡ್ ಹೊರಗಿಟ್ಟಿದೆ';

  @override
  String get checklistSeed4 => 'ನಗದು ಎಣಿಸಿ ಬರೆದಿಟ್ಟಿದೆ';

  @override
  String get checklistSeed5 => 'ಫ್ರಿಡ್ಜ್, ಗ್ಯಾಸ್ ಮತ್ತು ಲೈಟ್‌ಗಳನ್ನು ಆಫ್ ಮಾಡಿದೆ';

  @override
  String jobRemindMessage(String name, String title) {
    return 'ನಮಸ್ಕಾರ $name, ನಿಮ್ಮ ಆರ್ಡರ್ \"$title\" ರೆಡಿಯಾಗಿದೆ.';
  }

  @override
  String customerVisits(String count) {
    return '$count ಭೇಟಿಗಳು';
  }

  @override
  String customerToReward(String count) {
    return 'ಇನ್ನೂ $count ಭೇಟಿಗಳು';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return '$name ಇಷ್ಟವಾಯಿತೇ? ದಯವಿಟ್ಟು ರಿವ್ಯೂ ನೀಡಿ: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — ಇಂದಿನ ಮೆನು: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$total ರಲ್ಲಿ $done ಮುಗಿದಿದೆ';
  }

  @override
  String get movementPrepared => 'ಸಿದ್ಧತೆ';

  @override
  String recipeShortStock(String item) {
    return 'ಸ್ಟಾಕ್‌ನಲ್ಲಿ ಸಾಕಷ್ಟು $item ಇಲ್ಲ';
  }

  @override
  String get starterIdli => 'ಇಡ್ಲಿ';

  @override
  String get starterDosa => 'ದೋಸೆ';

  @override
  String get starterMeals => 'ಊಟ';

  @override
  String get starterSnackPacket => 'ಸ್ನ್ಯಾಕ್ಸ್ ಪ್ಯಾಕೆಟ್';

  @override
  String get starterWaterBottle => 'ನೀರಿನ ಬಾಟಲ್';

  @override
  String get starterVegSupply => 'ತರಕಾರಿಗಳು';

  @override
  String get starterGasSupply => 'ಗ್ಯಾಸ್ ಸಿಲಿಂಡರ್';

  @override
  String get checklistSeedHotel => 'ಹಿಟ್ಟು, ತರಕಾರಿ ಮತ್ತು ಗ್ಯಾಸ್ ರೆಡಿಯಾಗಿದೆ';

  @override
  String get checklistSeedCart => 'ಗಾಡಿ ಕ್ಲೀನ್ ಮಾಡಿ ಸ್ಟಾಕ್ ತುಂಬಿದೆ';

  @override
  String get checklistSeedService => 'ಸಾಮಾನು ಮತ್ತು ಚಿಲ್ಲರೆ ರೆಡಿ ಇದೆ';

  @override
  String get presetRecipeTea => 'ಅಂಗಡಿ ಟೀ (10 ಕಪ್‌)';

  @override
  String get presetIngredientMilk => 'ಹಾಲು';

  @override
  String get presetIngredientWater => 'ನೀರು';

  @override
  String get presetIngredientTeaPowder => 'ಟೀ ಪುಡಿ';

  @override
  String get presetIngredientSugar => 'ಸಕ್ಕರೆ';

  @override
  String get rolesTitle => 'ರೋಲ್‌ಗಳು';

  @override
  String get rolesSubtitle => 'ಯಾರು ಏನು ಮಾಡಬಹುದು';

  @override
  String get rolesHint =>
      'ಪ್ರತಿಯೊಬ್ಬ ಕೆಲಸದವರಿಗೂ ರೋಲ್ ರಚಿಸಿ, ಅವರಿಗೆ ಅನುಮತಿ ಇರುವ ಕೆಲಸವನ್ನು ಮಾತ್ರ ಟಿಕ್ ಮಾಡಿ.';

  @override
  String get rolesEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ರೋಲ್‌ಗಳಿಲ್ಲ';

  @override
  String get rolesOpen => 'ಚಾಲ್ತಿಯಲ್ಲಿರುವ ರೋಲ್‌ಗಳು';

  @override
  String get roleNew => 'ಹೊಸ ರೋಲ್';

  @override
  String get roleSuggestionsTitle => 'ನಿಮ್ಮ ಅಂಗಡಿಗೆ ಸಲಹೆಗಳು';

  @override
  String get roleSuggestionsHint =>
      'ನಿಮ್ಮ ಬಿಸಿನೆಸ್‌ಗೆ ತಕ್ಕ ರೆಡಿಮೇಡ್ ರೋಲ್‌ಗಳು. ರಚಿಸಲು ಒಂದನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ, ನಂತರ ಬದಲಾಯಿಸಿ.';

  @override
  String get tmplWaiter => 'ವೇಟರ್';

  @override
  String get tmplKitchen => 'ಕಿಚನ್ / ಅಡುಗೆಯವರು';

  @override
  String get tmplCashier => 'ಕ್ಯಾಷಿಯರ್';

  @override
  String get tmplCounter => 'ಕೌಂಟರ್';

  @override
  String get tmplSalesHelper => 'ಸೇಲ್ಸ್ ಹೆಲ್ಪರ್';

  @override
  String get tmplStockKeeper => 'ಸ್ಟಾಕ್ ಕೀಪರ್';

  @override
  String get tmplJobAssistant => 'ಕೆಲಸದ ಸಹಾಯಕ';

  @override
  String get tmplCounterHelper => 'ಕೌಂಟರ್ ಹೆಲ್ಪರ್';

  @override
  String get tmplAssistant => 'ಸಹಾಯಕ';

  @override
  String get roleOwner => 'ಮಾಲೀಕರು';

  @override
  String get roleOwnerNote => 'ಯಾವಾಗಲೂ ಪೂರ್ಣ ಆಕ್ಸೆಸ್';

  @override
  String get roleInactive => 'ಬಳಕೆಯಲ್ಲಿಲ್ಲ';

  @override
  String rolePermissionCount(String count) {
    return '$count ಅನುಮತಿಸಲಾಗಿದೆ';
  }

  @override
  String get roleEditSubtitle => 'ಹೆಸರು, ಜವಾಬ್ದಾರಿಗಳು ಮತ್ತು ಮಿತಿಗಳು';

  @override
  String get roleName => 'ರೋಲ್ ಹೆಸರು';

  @override
  String get roleNote => 'ಜವಾಬ್ದಾರಿ';

  @override
  String get roleLimits => 'ಹಣದ ಮಿತಿಗಳು (Rs, 0 = ಮಿತಿ ಇಲ್ಲ)';

  @override
  String get roleMaxDiscount => 'ಕೊಡಬಹುದಾದ ಗರಿಷ್ಠ ಡಿಸ್ಕೌಂಟ್';

  @override
  String get roleMaxCredit => 'ಕೊಡಬಹುದಾದ ಗರಿಷ್ಠ ಉದ್ರಿ';

  @override
  String get roleMaxRefund => 'ಕೊಡಬಹುದಾದ ಗರಿಷ್ಠ ರಿಫಂಡ್';

  @override
  String get roleLimitHint =>
      'ಈ ಮೊತ್ತಕ್ಕಿಂತ ಹೆಚ್ಚಿನದಕ್ಕೆ ಮಾಲೀಕರ PIN ಬೇಕಾಗುತ್ತದೆ.';

  @override
  String get roleDuplicate => 'ರೋಲ್ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get roleDeactivate => 'ಬಳಕೆ ನಿಲ್ಲಿಸಿ';

  @override
  String get areaSales => 'ಸೇಲ್ಸ್';

  @override
  String get areaOrders => 'ಆರ್ಡರ್‌ಗಳು ಮತ್ತು ಕಿಚನ್';

  @override
  String get areaBilling => 'ಬಿಲ್‌ಗಳು';

  @override
  String get areaCredit => 'ಉದ್ರಿ';

  @override
  String get areaStock => 'ಸ್ಟಾಕ್';

  @override
  String get areaPurchases => 'ಖರೀದಿ ಮತ್ತು ಖರ್ಚು';

  @override
  String get areaMoney => 'ಹಣ ಮತ್ತು ರಿಪೋರ್ಟ್';

  @override
  String get areaCustomers => 'ಗ್ರಾಹಕರು';

  @override
  String get areaStaff => 'ಕೆಲಸದವರು';

  @override
  String get areaSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String get permRecordSale => 'ಮಾರಾಟ ದಾಖಲಿಸಿ';

  @override
  String get permQuickSale => 'ಕ್ವಿಕ್ ಸೇಲ್ ಬಳಸಿ';

  @override
  String get permCollectUpi => 'ಪೇಮೆಂಟ್ QR ತೋರಿಸಿ';

  @override
  String get permTakeOrder => 'ಆರ್ಡರ್ ತೆಗೆದುಕೊಳ್ಳಿ';

  @override
  String get permChangeOrderStatus => 'ಆರ್ಡರ್ ಸ್ಟೇಟಸ್ ಬದಲಿಸಿ';

  @override
  String get permViewKitchen => 'ಕಿಚನ್ ಲಿಸ್ಟ್ ನೋಡಿ';

  @override
  String get permEditMenu => 'ಮೆನು ಬದಲಿಸಿ';

  @override
  String get permMakeBill => 'ಬಿಲ್ ಮಾಡಿ';

  @override
  String get permGiveDiscount => 'ಡಿಸ್ಕೌಂಟ್ ಕೊಡಿ';

  @override
  String get permVoidBill => 'ಬಿಲ್ ಕ್ಯಾನ್ಸಲ್ ಮಾಡಿ';

  @override
  String get permReprintBill => 'ಬಿಲ್ ಮತ್ತೆ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get permGiveCredit => 'ಉದ್ರಿ ಕೊಡಿ';

  @override
  String get permSettleCredit => 'ಉದ್ರಿ ಚುಕ್ತಾ ಮಾಡಿ';

  @override
  String get permViewCredit => 'ಉದ್ರಿ ಬಾಕಿ ನೋಡಿ';

  @override
  String get permViewStock => 'ಸ್ಟಾಕ್ ನೋಡಿ';

  @override
  String get permAdjustStock => 'ಸ್ಟಾಕ್ ಬದಲಿಸಿ';

  @override
  String get permEditProducts => 'ಐಟಂ ಸೇರಿಸಿ ಅಥವಾ ಬದಲಿಸಿ';

  @override
  String get permChangePrice => 'ಬೆಲೆ ಬದಲಿಸಿ';

  @override
  String get permCookRecipe => 'ರೆಸಿಪಿ ತಯಾರಿಸಿ';

  @override
  String get permRecordExpense => 'ಖರ್ಚು ಸೇರಿಸಿ';

  @override
  String get permManageSuppliers => 'ಸಪ್ಲೈಯರ್‌ಗಳನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get permViewDayTotals => 'ದಿನದ ಒಟ್ಟು ಮೊತ್ತ ನೋಡಿ';

  @override
  String get permViewProfit => 'ಲಾಭ ನೋಡಿ';

  @override
  String get permCloseDay => 'ದಿನ ಮುಕ್ತಾಯ ಮಾಡಿ';

  @override
  String get permViewReports => 'ರಿಪೋರ್ಟ್ ನೋಡಿ';

  @override
  String get permViewCustomers => 'ಗ್ರಾಹಕರನ್ನು ನೋಡಿ';

  @override
  String get permEditCustomers => 'ಗ್ರಾಹಕರ ವಿವರ ಬದಲಿಸಿ';

  @override
  String get permManageStaff => 'ಕೆಲಸದವರನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get permMarkAttendance => 'ಹಾಜರಾತಿ ಹಾಕಿ';

  @override
  String get permPayWages => 'ಸಂಬಳ ಕೊಡಿ';

  @override
  String get permManageRoles => 'ರೋಲ್ ರಚಿಸಿ';

  @override
  String get permViewAudit => 'ಆಕ್ಟಿವಿಟಿ ಹಿಸ್ಟರಿ ನೋಡಿ';

  @override
  String get permEditSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್ ಬದಲಿಸಿ';

  @override
  String get permEditShop => 'ಅಂಗಡಿ ವಿವರ ಬದಲಿಸಿ';

  @override
  String get permManagePrinters => 'ಪ್ರಿಂಟರ್‌ಗಳನ್ನು ಸೆಟ್ ಮಾಡಿ';

  @override
  String get accessTitle => 'ಆಕ್ಸೆಸ್ ಕಂಟ್ರೋಲ್';

  @override
  String get accessSubtitle => 'ಒಂದೇ ಫೋನ್, ಬೇರೆ ಬೇರೆ ಬಳಕೆ';

  @override
  String get accessEnable => 'PIN ಕೇಳಿ';

  @override
  String get accessEnableHint =>
      'ಫೋನ್ ಬಳಸುವ ಮುನ್ನ ಪ್ರತಿಯೊಬ್ಬ ಹೆಲ್ಪರ್ ಸೈನ್ ಇನ್ ಆಗಬೇಕು.';

  @override
  String get accessNeedsOwnerPin => 'ಮೊದಲು ಮಾಲೀಕರ PIN ಸೆಟ್ ಮಾಡಿ';

  @override
  String get accessOwnerPin => 'ಮಾಲೀಕರ PIN';

  @override
  String get accessOwnerPinSet => 'ಮಾಲೀಕರ PIN ಸೆಟ್ ಮಾಡಿ (4-6 ಅಂಕಿ)';

  @override
  String get accessOwnerPinChange => 'ಮಾಲೀಕರ PIN ಬದಲಿಸಿ (4-6 ಅಂಕಿ)';

  @override
  String get accessPinSaved => 'PIN ಸೇವ್ ಆಗಿದೆ';

  @override
  String get accessPinInvalid => '4 ರಿಂದ 6 ಅಂಕಿಗಳನ್ನು ಬಳಸಿ';

  @override
  String get accessAutoLock => 'ಆಟೋ ಲಾಕ್';

  @override
  String get accessIdleMinutes =>
      'ಇಷ್ಟು ಸಮಯದ ನಂತರ ಲಾಕ್ ಮಾಡಿ (ನಿಮಿಷ, 0 = ಎಂದಿಗೂ ಬೇಡ)';

  @override
  String get accessWorkers => 'ಹೆಲ್ಪರ್‌ಗಳು';

  @override
  String get accessNoWorkers => 'ಮೊದಲು ಹೆಲ್ಪರ್‌ಗಳನ್ನು ಸೇರಿಸಿ';

  @override
  String get accessNoRole => 'ಇನ್ನೂ ರೋಲ್ ನೀಡಿಲ್ಲ';

  @override
  String get accessPinSet => 'PIN ಸೆಟ್ ಆಗಿದೆ';

  @override
  String get accessPinMissing => 'PIN ಇಲ್ಲ';

  @override
  String get accessAssignTitle => 'ರೋಲ್ ಮತ್ತು PIN';

  @override
  String get accessWorkerPin => 'ಹೊಸ PIN (4-6 ಅಂಕಿ)';

  @override
  String get accessSaved => 'ಸೇವ್ ಆಗಿದೆ';

  @override
  String get accessEndShift => 'ಶಿಫ್ಟ್ ಮುಗಿಸಿ';

  @override
  String get accessWrongPin => 'ತಪ್ಪು PIN';

  @override
  String get lockTitle => 'ಕೌಂಟರ್‌ನಲ್ಲಿ ಯಾರು ಇದ್ದಾರೆ?';

  @override
  String get lockSubtitle => 'ನಿಮ್ಮ ಹೆಸರು ಆರಿಸಿ, PIN ಹಾಕಿ';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'ಶಿಫ್ಟ್ ಶುರು ಮಾಡಿ';

  @override
  String get auditTitle => 'ಆಕ್ಟಿವಿಟಿ ಹಿಸ್ಟರಿ';

  @override
  String get auditSubtitle => 'ಯಾರು ಏನು ಮಾಡಿದರು';

  @override
  String get auditOpen => 'ಆಕ್ಟಿವಿಟಿ ಹಿಸ್ಟರಿ ನೋಡಿ';

  @override
  String get auditEveryone => 'ಎಲ್ಲರೂ';

  @override
  String get auditEmpty => 'ಇನ್ನೂ ಏನೂ ದಾಖಲಾಗಿಲ್ಲ';

  @override
  String get auditApproved => 'ಮಾಲೀಕರು ಅನುಮೋದಿಸಿದ್ದಾರೆ';

  @override
  String get settingsGroupBusiness => 'ವ್ಯಾಪಾರ';

  @override
  String get settingsGroupMoney => 'ಹಣಕಾಸು';

  @override
  String get settingsGroupApp => 'ಆ್ಯಪ್ ಮತ್ತು ಡಿವೈಸ್‌ಗಳು';

  @override
  String get settingsShopTitle => 'ಅಂಗಡಿ ವಿವರ';

  @override
  String get settingsPaymentsTitle => 'ಪಾವತಿಗಳು ಮತ್ತು UPI';

  @override
  String get settingsMarketTitle => 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆಗಳು';

  @override
  String get settingsNotSet => 'ಸೆಟ್ ಮಾಡಿಲ್ಲ';

  @override
  String get settingsOn => 'ಆನ್';

  @override
  String get settingsOff => 'ಆಫ್';

  @override
  String get settingsSaved => 'ಸೆಟ್ಟಿಂಗ್ಸ್ ಸೇವ್ ಆಗಿದೆ';

  @override
  String get dashboardTitle => 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get dashboardSubtitle =>
      'ಆರ್ಡರ್, ಹಣ, ಉದ್ಧರಿ ಮತ್ತು ಸ್ಟಾಕ್ ವಿವರಗಳು ಒಂದೇ ಕಡೆ';

  @override
  String get dashboardOrders => 'ಆರ್ಡರ್‌ಗಳು';

  @override
  String get dashboardPayments => 'ಬಾಕಿ ಪಾವತಿಗಳು';

  @override
  String get dashboardCredit => 'ಉದ್ಧರಿ ಬಾಕಿ';

  @override
  String get dashboardInventory => 'ಸ್ಟಾಕ್';

  @override
  String get dashboardShare => 'ಶೇರ್';

  @override
  String get dashboardPlaced => 'ಆರ್ಡರ್ ಆಗಿದೆ';

  @override
  String get dashboardServed => 'ಸರ್ವ್ ಆಗಿದೆ';

  @override
  String get dashboardCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get dashboardOpenOrders => 'ಚಾಲ್ತಿ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get dashboardBilled => 'ಬಿಲ್ ಆಗಿದೆ';

  @override
  String get dashboardAvgBill => 'ಸರಾಸರಿ ಬಿಲ್';

  @override
  String get dashboardCollected => 'ಬಂದ ಹಣ';

  @override
  String get dashboardUnbilled => 'ಇನ್ನೂ ಬಿಲ್ ಮಾಡಿಲ್ಲ';

  @override
  String get dashboardPendingTotal => 'ಇನ್ನೂ ಬರಬೇಕಾದ ಹಣ';

  @override
  String get dashboardOutstanding => 'ಒಟ್ಟು ಬಾಕಿ';

  @override
  String get dashboardCreditGiven => 'ಕೊಟ್ಟ ಉದ್ಧರಿ';

  @override
  String get dashboardCustomers => 'ಗ್ರಾಹಕರು';

  @override
  String get dashboardOldest => 'ಹಳೆಯ ಬಾಕಿ';

  @override
  String dashboardDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString days',
      one: '1 day',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get dashboardStockValue => 'ಸ್ಟಾಕ್ ಮೌಲ್ಯ';

  @override
  String get dashboardLowStock => 'ಕಡಿಮೆ ಸ್ಟಾಕ್';

  @override
  String get dashboardExpiring => 'ಬೇಗ ಎಕ್ಸ್‌ಪೈರ್ ಆಗುವಂತದ್ದು';

  @override
  String get dashboardWastage => 'ವೇಸ್ಟೇಜ್';

  @override
  String get dashboardPurchases => 'ಖರೀದಿಗಳು';

  @override
  String get dashboardTopItems => 'ಟಾಪ್ ಐಟಂಗಳು';

  @override
  String get planTitle => 'ಸಬ್‌ಸ್ಕ್ರಿಪ್ಷನ್';

  @override
  String get planSubtitle => 'ಈ ಅಂಗಡಿಗೆ ಕ್ಲೌಡ್ ಫೀಚರ್‌ಗಳು';

  @override
  String get planFree => 'ಉಚಿತ';

  @override
  String get planPro => 'ಪ್ರೊ';

  @override
  String get planFreeNote => 'ಈ ಫೋನ್‌ನಲ್ಲಿ ಎಲ್ಲವೂ ಉಚಿತವಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ.';

  @override
  String get planProNote => 'ಈ ಅಂಗಡಿಗೆ ಕ್ಲೌಡ್ ಫೀಚರ್‌ಗಳು ಆಕ್ಟಿವ್ ಆಗಿದೆ.';

  @override
  String get planCloudFeatures => 'ಕ್ಲೌಡ್ ಫೀಚರ್‌ಗಳು';

  @override
  String get planFeatureAccount => 'ಕ್ಲೌಡ್ ಶಾಪ್ ಖಾತೆ';

  @override
  String get planFeatureLiveSync => 'ಲೈವ್ ಆರ್ಡರ್ ಬೋರ್ಡ್ ಸಿಂಕ್';

  @override
  String get planFeatureQrOrdering => 'QR ಮೆನು ಆರ್ಡರ್';

  @override
  String get planFeatureShareLinks => 'ಶೇರ್ ಮಾಡಬಹುದಾದ ಲಿಂಕ್‌ಗಳು';

  @override
  String get planFeatureSoundbox => 'ಕ್ಲೌಡ್ ಸೌಂಡ್‌ಬಾಕ್ಸ್';

  @override
  String get planFeatureBackup => 'ಹಲವು ಡಿವೈಸ್‌ಗಳ ಬ್ಯಾಕಪ್';

  @override
  String get planOn => 'ಆನ್';

  @override
  String get planLocked => 'ಲಾಕ್ ಆಗಿದೆ';

  @override
  String get planRefresh => 'ಚಂದಾದಾರಿಕೆ ಪರಿಶೀಲಿಸಿ';

  @override
  String get planChecking => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get planCheckFailed =>
      'ಈಗ ಪರಿಶೀಲಿಸಲು ಆಗುತ್ತಿಲ್ಲ. ಹಿಂದಿನ ಸ್ಥಿತಿಯನ್ನು ಬಳಸಲಾಗಿದೆ.';

  @override
  String get planNeedsShop => 'ಮೊದಲು ಕ್ಲೌಡ್ ಅಂಗಡಿ ಸೆಟಪ್ ಮಾಡಿ.';

  @override
  String get planOfflineNote =>
      'ಕೆಲವು ದಿನ ಆಫ್‌ಲೈನ್ ಇದ್ದರೂ ಪರವಾಗಿಲ್ಲ — ಗ್ರೇಸ್ ಪೀರಿಯಡ್‌ನಲ್ಲಿ ಕ್ಲೌಡ್ ಫೀಚರ್‌ಗಳು ಕೆಲಸ ಮಾಡುತ್ತವೆ.';

  @override
  String get shopTitle => 'ನನ್ನ ಅಂಗಡಿ';

  @override
  String get shopSubtitle => 'ನಿಮ್ಮ ವ್ಯಾಪಾರಕ್ಕೆ ತಕ್ಕಂತೆ ವರ್ಕ್‌ಫ್ಲೋ';

  @override
  String get shopPickType => 'ಅಂಗಡಿ ವಿಧ';

  @override
  String get shopWorkflow => 'ದೈನಂದಿನ ಕೆಲಸದ ಶೈಲಿ';

  @override
  String get shopTypeRestaurant => 'ರೆಸ್ಟೋರೆಂಟ್';

  @override
  String get shopTypeHotel => 'ಹೋಟೆಲ್';

  @override
  String get shopTypeStreet => 'ರಸ್ತೆಬದಿಯ ಅಂಗಡಿ';

  @override
  String get shopTypeDiy => 'DIY / ಕರಕುಶಲ ಅಂಗಡಿ';

  @override
  String get shopTypeMagnet => 'ಫ್ರಿಡ್ಜ್ ಮ್ಯಾಗ್ನೆಟ್ ಅಂಗಡಿ';

  @override
  String get shopTypeTea => 'ಟೀ ಅಂಗಡಿ';

  @override
  String get settingsOrderingTitle => 'ಆರ್ಡರ್ ನಿಯಮಗಳು';

  @override
  String get settingsOrderingSubtitle =>
      'ಸರ್ವಿಸ್ ಶೈಲಿ, ಪಾವತಿ ಸಮಯ, ಟೇಬಲ್ ಬಟನ್‌ಗಳು';

  @override
  String get serviceStyle => 'ಸರ್ವಿಸ್ ಶೈಲಿ';

  @override
  String get serviceTable => 'ಟೇಬಲ್ ಸರ್ವಿಸ್';

  @override
  String get serviceSelf => 'ಸೆಲ್ಫ್ ಸರ್ವಿಸ್';

  @override
  String get serviceTakeaway => 'ಪಾರ್ಸಲ್ ಮಾತ್ರ';

  @override
  String get paymentTiming => 'ಪಾವತಿ ಸಮಯ';

  @override
  String get payBefore => 'ಮೊದಲು ಪಾವತಿ';

  @override
  String get payAfter => 'ನಂತರ ಪಾವತಿ';

  @override
  String get payTimingHelp =>
      'ಮೊದಲು ಪಾವತಿ: ಆರ್ಡರ್ ಕನ್ಫರ್ಮ್ ಆಗುವ ಮುನ್ನ ಹಣ ಕೇಳುತ್ತದೆ. ನಂತರ ಪಾವತಿ: ನೇರವಾಗಿ ಕಿಚನ್‌ಗೆ ಕಳುಹಿಸುತ್ತದೆ.';

  @override
  String get customerButtons => 'ಗ್ರಾಹಕರ ಸ್ಕ್ರೀನ್ ಮೇಲಿನ ಬಟನ್‌ಗಳು';

  @override
  String get allowCallStaff => 'ಸಿಬ್ಬಂದಿಯನ್ನು ಕರೆಯಿರಿ';

  @override
  String get allowRequestBill => 'ಬಿಲ್ ಕೇಳಿ';

  @override
  String get customerButtonsHelp =>
      'ಇವು ಟೇಬಲ್ ಸರ್ವಿಸ್‌ನಲ್ಲಿ ಮಾತ್ರ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get requestCallStaff => 'ಸಿಬ್ಬಂದಿ ಬೇಕಾಗಿದ್ದಾರೆ';

  @override
  String get requestBill => 'ಬಿಲ್ ಕೊಡಿ';

  @override
  String requestTable(String table) {
    return 'ಟೇಬಲ್ $table';
  }

  @override
  String get requestCounter => 'ಕೌಂಟರ್';

  @override
  String get requestSeen => 'ನೋಡಲಾಗಿದೆ';

  @override
  String get payStateAwaiting => 'ಪಾವತಿಗಾಗಿ ಕಾಯಲಾಗುತ್ತಿದೆ';

  @override
  String get payStateDue => 'ಕೌಂಟರ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ';

  @override
  String get payStatePaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get orderMarkPaid => 'ಪಾವತಿಯಾಗಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get devicesTitle => 'ಫೋನ್‌ಗಳು ಮತ್ತು ಡಿವೈಸ್‌ಗಳು';

  @override
  String get devicesSubtitle =>
      'ವೇಟರ್, ಕಿಚನ್ ಮತ್ತು ಕೌಂಟರ್ ಫೋನ್‌ಗಳು ಒಂದೇ ಬೋರ್ಡ್‌ನಲ್ಲಿ';

  @override
  String get devicesPairThis => 'ಈ ಫೋನ್ ಜೋಡಿಸಿ';

  @override
  String get devicesShopSlug => 'ಅಂಗಡಿ ಹೆಸರು (ಮೆನು ಲಿಂಕ್ ಪದ)';

  @override
  String get devicesEnterCode => 'ಮಾಲೀಕರಿಂದ 6 ಅಂಕಿಯ ಕೋಡ್';

  @override
  String get devicesLabel => 'ಫೋನ್ ಹೆಸರು';

  @override
  String get devicesPairButton => 'ಫೋನ್ ಜೋಡಿಸಿ';

  @override
  String get devicesPairSuccess => 'ಫೋನ್ ಅಂಗಡಿಗೆ ಜೋಡಿಸಲಾಗಿದೆ';

  @override
  String get devicesUnpair => 'ಈ ಫೋನ್ ಸಂಪರ್ಕ ತೆಗೆಯಿರಿ';

  @override
  String devicesPairedAs(String role, String shop) {
    return '$role ಆಗಿ ಜೋಡಿಸಲಾಗಿದೆ · $shop';
  }

  @override
  String get devicesNewCode => 'ಹೊಸ ಪೇರಿಂಗ್ ಕೋಡ್';

  @override
  String get devicesCodeExpires =>
      '15 ನಿಮಿಷಗಳವರೆಗೆ ಮಾತ್ರ ಮಾನ್ಯ · ಕಾಪಿ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get devicesList => 'ಜೋಡಿಸಲಾದ ಫೋನ್‌ಗಳು';

  @override
  String get devicesEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಫೋನ್ ಜೋಡಿಸಿಲ್ಲ';

  @override
  String get devicesRevoke => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get devicesRevoked => 'ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get devicesOnline => 'ಆನ್‌ಲೈನ್';

  @override
  String get devicesOffline => 'ಆಫ್‌ಲೈನ್';

  @override
  String get devicesRoleWaiter => 'ವೇಟರ್';

  @override
  String get devicesRoleKitchen => 'ಕಿಚನ್';

  @override
  String get devicesRoleCounter => 'ಕೌಂಟರ್';

  @override
  String get devicesProRequired =>
      'ಮಲ್ಟಿ-ಡಿವೈಸ್ ಸಿಂಕ್ Pro ಫೀಚರ್ ಆಗಿದೆ. ವೇಟರ್, ಕಿಚನ್ ಮತ್ತು ಕೌಂಟರ್ ಫೋನ್‌ಗಳನ್ನು ಕನೆಕ್ಟ್ ಮಾಡಲು ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ.';

  @override
  String get cloudShopSection => 'ಕ್ಲೌಡ್ ಶಾಪ್';

  @override
  String get cloudShopHint =>
      'ಸರ್ವರ್‌ನಲ್ಲಿ ನಿಮ್ಮ ಅಂಗಡಿ ರಚಿಸಿ, ಇದರಿಂದ QR ಮೆನು ಆರ್ಡರ್‌ಗಳು ಮತ್ತು ಸಿಬ್ಬಂದಿ ಫೋನ್‌ಗಳು ಒಂದೇ ಲೈವ್ ಆರ್ಡರ್ ಲಿಸ್ಟ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get cloudShopSlug => 'ಲಿಂಕ್‌ಗಾಗಿ ಅಂಗಡಿ ಹೆಸರು (ಉದಾ. sirpam-tea)';

  @override
  String get cloudShopKey => 'ಶಾಪ್ ಕೀ (ಖಾಸಗಿ, 16+ ಅಕ್ಷರಗಳು)';

  @override
  String get cloudShopGenerate => 'ಕೀ ರಚಿಸಿ';

  @override
  String get cloudShopCreate => 'ಕ್ಲೌಡ್ ಶಾಪ್ ರಚಿಸಿ';

  @override
  String get cloudShopUpdate => 'ಕ್ಲೌಡ್ ಶಾಪ್ ಅಪ್‌ಡೇಟ್ ಮಾಡಿ';

  @override
  String cloudShopLive(String slug) {
    return 'ಕ್ಲೌಡ್ ಶಾಪ್ ಸಿದ್ಧವಾಗಿದೆ: $slug';
  }

  @override
  String get cloudShopNone =>
      'ಇನ್ನೂ ಕ್ಲೌಡ್ ಶಾಪ್ ಇಲ್ಲ. QR ಆರ್ಡರಿಂಗ್ ಮತ್ತು ಸಿಬ್ಬಂದಿ ಫೋನ್‌ಗಳನ್ನು ಬಳಸಲು ಒಂದನ್ನು ರಚಿಸಿ.';

  @override
  String get cloudShopCreated => 'ಕ್ಲೌಡ್ ಶಾಪ್ ರಚಿಸಲಾಗಿದೆ';

  @override
  String get cloudShopKeyShort =>
      'ಅಂಗಡಿ ಹೆಸರು ಮತ್ತು ಕನಿಷ್ಠ 16 ಅಕ್ಷರಗಳ ಕೀ ನಮೂದಿಸಿ.';

  @override
  String get cloudShopCopyKey => 'ಕೀ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get cloudShopKeyCopied => 'ಶಾಪ್ ಕೀ ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';

  @override
  String get approvalTitle => 'ಮಾಲೀಕರ ಅನುಮೋದನೆ';

  @override
  String approvalNeeded(String action) {
    return 'ಈ ಶಿಫ್ಟ್‌ನಲ್ಲಿ ಇದನ್ನು ಮಾಡಲು ಆಗಲ್ಲ: $action. ಮಾಲೀಕರು ಒಮ್ಮೆ ಅನುಮತಿಸಬಹುದು.';
  }

  @override
  String approvalOverLimit(String action) {
    return 'ಇದು ಈ ಶಿಫ್ಟ್‌ನ ಮಿತಿಗಿಂತ ಹೆಚ್ಚಾಗಿದೆ: $action. ಮಾಲೀಕರು ಒಮ್ಮೆ ಅನುಮತಿಸಬಹುದು.';
  }

  @override
  String get approvalOwnerPin => 'ಮಾಲೀಕರ PIN';

  @override
  String get approvalApprove => 'ಒಮ್ಮೆ ಅನುಮತಿಸಿ';

  @override
  String get approvalGranted => 'ಮಾಲೀಕರು ಅನುಮತಿಸಿದ್ದಾರೆ';

  @override
  String get approvalWrongPin => 'ತಪ್ಪಾದ ಮಾಲೀಕರ PIN';

  @override
  String get approvalBlockedTitle => 'ಅನುಮತಿಯಿಲ್ಲ';

  @override
  String approvalBlockedBody(String action) {
    return 'ಈ ಶಿಫ್ಟ್‌ಗೆ $action ಮಾಡುವ ಅನುಮತಿಯಿಲ್ಲ. ರೋಲ್ ಬದಲಾಯಿಸಲು ಮಾಲೀಕರನ್ನು ಕೇಳಿ.';
  }

  @override
  String get recurringRemove => 'ತೆಗೆಯಿರಿ';

  @override
  String get recurringRemoved => 'ಮರುಕಳಿಸುವ ಖರ್ಚು ತೆಗೆಯಲಾಗಿದೆ';

  @override
  String recurringRemoveConfirm(String name) {
    return 'ಮರುಕಳಿಸುವ ಖರ್ಚುಗಳಿಂದ $name ತೆಗೆದುಹಾಕಬೇಕೆ?';
  }

  @override
  String get orderEditItems => 'ಐಟಂಗಳನ್ನು ಬದಲಿಸಿ';

  @override
  String get orderEditItemsSaved => 'ಆರ್ಡರ್ ಐಟಂಗಳು ಅಪ್‌ಡೇಟ್ ಆಗಿವೆ';

  @override
  String get orderEditEmpty => 'ಆರ್ಡರ್‌ನಲ್ಲಿ ಕನಿಷ್ಠ ಒಂದು ಐಟಂ ಇರಬೇಕು.';

  @override
  String get printerStatus => 'ಪ್ರಿಂಟರ್ ಸ್ಥಿತಿ';

  @override
  String get printerNotConnected => 'ಯಾವ ಪ್ರಿಂಟರ್‌ ಕನೆಕ್ಟ್ ಆಗಿಲ್ಲ';

  @override
  String printerConnectedTo(String name) {
    return '$name ಗೆ ಕನೆಕ್ಟ್ ಆಗಿದೆ';
  }

  @override
  String get printerDisconnect => 'ಡಿಸ್‌ಕನೆಕ್ಟ್ ಮಾಡಿ';

  @override
  String get printerDisconnected => 'ಪ್ರಿಂಟರ್ ಡಿಸ್‌ಕನೆಕ್ಟ್ ಆಗಿದೆ';

  @override
  String get printerForget => 'ಪ್ರಿಂಟರ್ ಮರೆತುಬಿಡಿ';

  @override
  String get printerForgotten =>
      'ಪ್ರಿಂಟರ್ ತೆಗೆಯಲಾಗಿದೆ. ಬಿಲ್‌ಗಳನ್ನು PDF ರೂಪದಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳಲಾಗುತ್ತದೆ.';

  @override
  String get printerUnsupported =>
      'ಈ ಫೋನ್‌ನಲ್ಲಿ Bluetooth ಮೂಲಕ ಪ್ರಿಂಟ್ ಮಾಡಲು ಆಗಲ್ಲ.';

  @override
  String get printerPermissionNeeded =>
      'ಆ್ಯಪ್ ನಿಮ್ಮ ಪ್ರಿಂಟರ್ ಹುಡುಕಲು Bluetooth ಅನುಮತಿ ನೀಡಿ.';

  @override
  String get printerPermissionDenied => 'Bluetooth ಅನುಮತಿ ನೀಡಿಲ್ಲ.';

  @override
  String get printerAllowBluetooth => 'Bluetooth ಅನುಮತಿಸಿ';

  @override
  String get devicesTest => 'ಕನೆಕ್ಷನ್ ಚೆಕ್ ಮಾಡಿ';

  @override
  String get devicesTestOk => 'ಅಂಗಡಿಗೆ ಕನೆಕ್ಟ್ ಆಗಿದೆ';

  @override
  String get devicesTestFailed =>
      'ಈ ಫೋನ್ ಕನೆಕ್ಟ್ ಆಗಿಲ್ಲ. ಹೊಸ ಕೋಡ್‌ಗಾಗಿ ಮಾಲೀಕರನ್ನು ಕೇಳಿ.';

  @override
  String stockLastUpdated(String when) {
    return 'ಸ್ಟಾಕ್ ಕೊನೆಯದಾಗಿ ಅಪ್‌ಡೇಟ್ ಆಗಿದ್ದು $when';
  }

  @override
  String get agoJustNow => 'ಈಗಷ್ಟೇ';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ನಿಮಿಷಗಳ ಹಿಂದೆ',
      one: '1 ನಿಮಿಷದ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಗಂಟೆಗಳ ಹಿಂದೆ',
      one: '1 ಗಂಟೆಯ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನಗಳ ಹಿಂದೆ',
      one: '1 ದಿನದ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'ಬೆಳಗಿನ ಸಿದ್ಧತೆ';

  @override
  String get prepSubtitle => 'ಮೊದಲ ಗ್ರಾಹಕ ಬರುವ ಮುನ್ನ ಏನೆಲ್ಲ ರೆಡಿ ಇರಬೇಕು';

  @override
  String prepPending(String count) {
    return 'ಇನ್ನೂ $count ರೆಡಿ ಮಾಡಬೇಕು';
  }

  @override
  String get prepUseStarter => 'ಆರಂಭಿಕ ಶೀಟ್ ಬಳಸಿ';

  @override
  String get prepTodaySheet => 'ಇಂದಿನ ಶೀಟ್';

  @override
  String get prepAddTitle => 'ಸಿದ್ಧತೆಯ ಐಟಂ ಸೇರಿಸಿ';

  @override
  String get prepItemName => 'ಐಟಂ';

  @override
  String get prepPlanned => 'ಪ್ಲಾನ್ ಮಾಡಿದ್ದು';

  @override
  String get prepMade => 'ಮಾಡಿದ್ದು';

  @override
  String get prepUnit => 'ಯೂನಿಟ್';

  @override
  String get prepAdd => 'ಶೀಟ್‌ಗೆ ಸೇರಿಸಿ';

  @override
  String prepShort(String qty) {
    return '$qty ಕಡಿಮೆ';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$planned $unit ನಲ್ಲಿ $made';
  }

  @override
  String get prepSeedMilk => 'ಹಾಲು';

  @override
  String get prepSeedBatter => 'ಹಿಟ್ಟು';

  @override
  String get prepSeedSnacks => 'ಸ್ನ್ಯಾಕ್ಸ್';

  @override
  String get prepSeedChange => 'ಚಿಲ್ಲರೆ ಹಣ';

  @override
  String get prepSeedDisplay => 'ಡಿಸ್‌ಪ್ಲೇ ಜೋಡಿಸಿ';

  @override
  String get prepSeedStock => 'ಸಾಮಾನು ಜೋಡಿಸಿ';

  @override
  String get prepUnitLitre => 'ಲೀಟರ್';

  @override
  String get prepUnitPlate => 'ಪ್ಲೇಟ್';

  @override
  String get prepUnitPiece => 'ಪೀಸ್';

  @override
  String get prepUnitRupee => 'ರೂಪಾಯಿ';

  @override
  String get insightsRush => 'ರಶ್ ಸಮಯ';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return '$hour:00 ಗೆ ಅತಿ ಹೆಚ್ಚು ರಶ್ ($bills ಬಿಲ್‌ಗಳು) — ಕೌಂಟರ್‌ನಲ್ಲಿ $staff ಇರಲಿ';
  }

  @override
  String get dayCloseOpeningCash => 'ಆರಂಭಿಕ ನಗದು';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item ಖಾಲಿಯಾಗಿದೆ ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಲಭ್ಯವಿದೆ';
  }

  @override
  String get insightsHeroes => 'ಇಂದಿನ ಟಾಪ್ ಐಟಂಗಳು';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold ಮಾರಾಟವಾಗಿದೆ · $left ಉಳಿದಿದೆ';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return 'ಸುಮಾರು $hour:00 ಗೆ ಖಾಲಿಯಾಗುತ್ತದೆ';
  }

  @override
  String get customerLapsedTitle => 'ಇತ್ತೀಚೆಗೆ ಬಂದಿಲ್ಲದವರು';

  @override
  String get customerLapsedHint =>
      'ಒಂದು ಸಣ್ಣ ಮೆಸೇಜ್ ಕಳುಹಿಸಿದರೆ ಅವರು ಮತ್ತೆ ಬರಬಹುದು.';

  @override
  String customerLapsedDays(String days) {
    return 'ಬಂದು $days ದಿನಗಳಾಗಿವೆ';
  }

  @override
  String get customerNudge => 'ಮೆಸೇಜ್ ಕಳುಹಿಸಿ';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'ನಮಸ್ಕಾರ $name, $shop ನಲ್ಲಿ ನಿಮ್ಮ ನೆನಪಾಗುತ್ತಿದೆ! ಈ ವಾರ ನಿಮಗಾಗಿ ಹೊಸ ರುಚಿಗಳು ಕಾದಿವೆ.';
  }

  @override
  String get offersTitle => 'ಆಫರ್‌ಗಳು';

  @override
  String get offersSubtitle => 'ನೀವು ನೀಡುವ ರಿಯಾಯಿತಿಗಳು ಮತ್ತು ಅವುಗಳ ವೆಚ್ಚ.';

  @override
  String get offerAdd => 'ಆಫರ್ ಸೇರಿಸಿ';

  @override
  String get offerName => 'ಆಫರ್ ಹೆಸರು';

  @override
  String get offerCode => 'ಗ್ರಾಹಕರು ಹೇಳುವ ಕೋಡ್ (ಐಚ್ಛಿಕ)';

  @override
  String get offerKindFlat => 'ರೂಪಾಯಿ ರಿಯಾಯಿತಿ';

  @override
  String get offerKindPercent => 'ಶೇಕಡಾ ರಿಯಾಯಿತಿ';

  @override
  String get offerKindCombo => 'ಕಾಂಬೊ ಬೆಲೆ';

  @override
  String get offerAmount => 'ರಿಯಾಯಿತಿ ಮೊತ್ತ';

  @override
  String get offerPercent => '% ರಿಯಾಯಿತಿ';

  @override
  String get offerComboPrice => 'ಕಾಂಬೊ ಬೆಲೆ';

  @override
  String get offersGivenTotal => 'ಇಲ್ಲಿಯವರೆಗೆ ನೀಡಿದ್ದು';

  @override
  String get offersEmpty =>
      'ಇನ್ನೂ ಯಾವುದೇ ಆಫರ್ ಇಲ್ಲ. ಆಫರ್ ಸೇರಿಸಿ, ಅದು ಬಿಲ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get offerLive => 'ಲೈವ್';

  @override
  String get offerPaused => 'ಪಾಸ್ ಆಗಿದೆ';

  @override
  String get offerPause => 'ಪಾಸ್ ಮಾಡಿ';

  @override
  String get offerResume => 'ಮುಂದುವರಿಸಿ';

  @override
  String offerUsed(String count) {
    return '$count ಬಾರಿ ಬಳಸಲಾಗಿದೆ';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount ನೀಡಲಾಗಿದೆ';
  }

  @override
  String get feedbackTitle => 'ಬಿಲ್ ಫೀಡ್‌ಬ್ಯಾಕ್';

  @override
  String get feedbackSubtitle =>
      'ಪೇಮೆಂಟ್ ನಂತರ ಮೂರೇ ಟ್ಯಾಪ್‌ನಲ್ಲಿ ರೇಟಿಂಗ್, ನೇರವಾಗಿ ನಿಮಗೆ.';

  @override
  String get feedbackQrTitle => 'ಕೌಂಟರ್ QR';

  @override
  String get feedbackQrHint =>
      'ಇದನ್ನು ಪ್ರಿಂಟ್ ಮಾಡಿ ಕೌಂಟರ್‌ನಲ್ಲಿ ಇಡಿ, ಅಥವಾ ಪೇಮೆಂಟ್ ನಂತರ ತೋರಿಸಿ.';

  @override
  String get feedbackReviewMissing =>
      'Growth ನಲ್ಲಿ ನಿಮ್ಮ ರಿವ್ಯೂ ಪೇಜ್ ಲಿಂಕ್ ಸೇರಿಸಿ, ಗ್ರಾಹಕರು ಪಬ್ಲಿಕ್ ಆಗಿ ಪೋಸ್ಟ್ ಮಾಡಬಹುದು.';

  @override
  String get feedbackLinkCopied => 'ಲಿಂಕ್ ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';

  @override
  String get feedbackScores => 'ಸ್ಕೋರ್‌ಗಳು';

  @override
  String get feedbackTodayAvg => 'ಇಂದು (ಸರಾಸರಿ · ಒಟ್ಟು)';

  @override
  String get feedbackWeekAvg => 'ಕಳೆದ 7 ದಿನಗಳು (ಸರಾಸರಿ · ಒಟ್ಟು)';

  @override
  String get feedbackNeedsReply => 'ರಿಪ್ಲೈ ಬೇಕಾಗಿದೆ';

  @override
  String get feedbackRecord => 'ನೀವೇ ರೇಟಿಂಗ್ ಸೇರಿಸಿ';

  @override
  String get feedbackHappy => 'ಚೆನ್ನಾಗಿದೆ';

  @override
  String get feedbackOkay => 'ಪರವಾಗಿಲ್ಲ';

  @override
  String get feedbackUnhappy => 'ಸರಿಯಿಲ್ಲ';

  @override
  String get feedbackRecent => 'ಇತ್ತೀಚಿನ ರೇಟಿಂಗ್‌ಗಳು';

  @override
  String get feedbackEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ರೇಟಿಂಗ್ ಬಂದಿಲ್ಲ.';

  @override
  String get enquiriesTitle => 'ವಿಚಾರಣೆಗಳು';

  @override
  String get enquiriesSubtitle =>
      'ಯಾರು ಕೇಳಿದರು, ನೀವು ಹೇಳಿದ ಬೆಲೆ, ಏನಾಯಿತು ಎಂಬ ವಿವರ.';

  @override
  String get enquiryAdd => 'ವಿಚಾರಣೆ ಸೇರಿಸಿ';

  @override
  String get enquiryName => 'ಗ್ರಾಹಕರ ಹೆಸರು';

  @override
  String get enquiryPhone => 'ಫೋನ್';

  @override
  String get enquiryWant => 'ಅವರು ಏನು ಕೇಳಿದರು';

  @override
  String get enquiryQuote => 'ನೀವು ಹೇಳಿದ ಬೆಲೆ';

  @override
  String get enquiryNoFollowUp => 'ಯಾವುದೇ ರಿಮೈಂಡರ್ ಇಲ್ಲ';

  @override
  String enquiryFollowUpDays(String days) {
    return '$days ದಿನಗಳಲ್ಲಿ ಫಾಲೋ ಅಪ್ ಮಾಡಿ';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% ಮಾರಾಟವಾಗಿ ಬದಲಾಗಿದೆ';
  }

  @override
  String get enquiryWonValue => 'ಮಾರಾಟವಾದ ಮೊತ್ತ';

  @override
  String get enquiryFilterToday => 'ಇಂದು';

  @override
  String get enquiryFilterOpen => 'ಓಪನ್';

  @override
  String get enquiryFilterWon => 'ಮಾರಾಟವಾದವು';

  @override
  String get enquiryFilterLost => 'ಕೈತಪ್ಪಿದ್ದು';

  @override
  String get enquiryEmpty => 'ಇಲ್ಲಿ ಏನೂ ಇಲ್ಲ.';

  @override
  String enquiryFollowUpOn(String day) {
    return '$day ರಂದು ಫಾಲೋ ಅಪ್ ಮಾಡಿ';
  }

  @override
  String get enquiryMessage => 'ಮೆಸೇಜ್';

  @override
  String enquiryMessageText(String name, String item) {
    return 'ನಮಸ್ಕಾರ $name, $item ಬಗ್ಗೆ ವಿಚಾರಿಸಲು ಮೆಸೇಜ್ ಮಾಡಿದೆ. ನಿಮಗಾಗಿ ರೆಡಿ ಮಾಡಿ ಇಡಲಾ?';
  }

  @override
  String get enquiryWon => 'ಸಿಕ್ಕಿದ್ದು';

  @override
  String get enquiryLost => 'ಕೈತಪ್ಪಿದ್ದು';

  @override
  String get enquiryReopen => 'ಮತ್ತೆ ತೆರೆಯಿರಿ';

  @override
  String get customerRewardsDueTitle => 'ಬಾಕಿ ರಿವಾರ್ಡ್‌ಗಳು';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'ಆ ಲಿಂಕ್ ಹೆಸರು ಈಗಾಗಲೇ ಬಳಕೆಯಲ್ಲಿದೆ. $slug ಥರ ಬೇರೆ ಪ್ರಯತ್ನಿಸಿ.';
  }

  @override
  String get cloudShopSlugInvalid =>
      'ಕನಿಷ್ಠ 3 ಅಕ್ಷರ ಇರಬೇಕು; ಸಣ್ಣ ಅಕ್ಷರಗಳು, ಸಂಖ್ಯೆಗಳು ಮತ್ತು ಡ್ಯಾಶ್ (-) ಮಾತ್ರ ಬಳಸಿ.';

  @override
  String get cloudShopOffline =>
      'ಇಂಟರ್ನೆಟ್ ಸಿಗುತ್ತಿಲ್ಲ. ಕನೆಕ್ಷನ್ ಚೆಕ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get cloudShopTryAgain =>
      'ಇದು ಆಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get cloudShopLinkTitle => 'ಗ್ರಾಹಕರ ಲಿಂಕ್';

  @override
  String get cloudShopCopyLink => 'ಲಿಂಕ್ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get cloudShopLinkCopied => 'ಲಿಂಕ್ ಕಾಪಿ ಆಗಿದೆ';

  @override
  String get cloudShopShowQr => 'QR ತೋರಿಸಿ';

  @override
  String get paymentQrScanTitle => 'ನಿಮ್ಮ ಪೇಮೆಂಟ್ ಆ್ಯಪ್‌ನ QR ಬಳಸಿ';

  @override
  String get paymentQrScanAction => 'ನನ್ನ QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get paymentQrScanHelp =>
      'GPay, PhonePe ಅಥವಾ Paytm ನ QR ಸ್ಟಿಕ್ಕರ್ ಮೇಲೆ ಕ್ಯಾಮೆರಾ ತೋರಿಸಿ. ಅದರಲ್ಲಿನ UPI ID ಬಳಸಿ, ಬಿಲ್ ಹಾಗೂ ಕೌಂಟರ್ QR ಹಣ ಒಂದೇ ಖಾತೆಗೆ ಜಮೆ ಆಗುವಂತೆ ಮಾಡುತ್ತೇವೆ.';

  @override
  String paymentQrScanFound(String vpa) {
    return 'ನಿಮ್ಮ QR ನಿಂದ UPI ID ಸಿಕ್ಕಿದೆ: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'ಇದು ಪೇಮೆಂಟ್ QR ಅಲ್ಲ. ನಿಮ್ಮ ಪೇಮೆಂಟ್ ಆ್ಯಪ್‌ನಲ್ಲಿರುವ QR ಅನ್ನು ಬಳಸಿ ನೋಡಿ.';

  @override
  String get receiptFeedbackLine => 'ಹೇಗಿತ್ತು ಅಂತ ತಿಳಿಸಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get qrPrintCounterCard => 'ಕೌಂಟರ್ ಕಾರ್ಡ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get qrPayCaption => 'ಪೇ ಮಾಡಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get qrFeedbackCaption => 'ರೇಟಿಂಗ್ ನೀಡಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get offerPrintCards => 'ಆಫರ್ ಕಾರ್ಡ್ ಪ್ರಿಂಟ್ ಮಾಡಿ';

  @override
  String get offerCardCaption => 'ಈ ಆಫರ್ ನೋಡಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get devicesPairQrHint => 'ಹೊಸ ಫೋನ್‌ನಿಂದ ಇದನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿಸಿ';

  @override
  String get devicesScanQr => 'ಪೇರಿಂಗ್ QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get devicesScanInvalid =>
      'ಇದು ಪೇರಿಂಗ್ QR ಅಲ್ಲ. ಮಾಲೀಕರಿಗೆ ಅದನ್ನು ಮತ್ತೆ ತೋರಿಸಲು ಹೇಳಿ.';

  @override
  String get quickSaleScan => 'ಐಟಂ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get quickSaleScanTitle => 'ಐಟಂ ಲೇಬಲ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String quickSaleScanUnknown(String code) {
    return '$code ಕೋಡ್‌ಗೆ ಯಾವುದೇ ಐಟಂ ಸಿಕ್ಕಿಲ್ಲ. \'ಪ್ರಾಡಕ್ಟ್‌ಗಳು\'ನಲ್ಲಿ ಇದನ್ನು ಸೇರಿಸಿ.';
  }

  @override
  String get backupTitle => 'ಬ್ಯಾಕಪ್ ಮತ್ತು ಎಕ್ಸ್‌ಪೋರ್ಟ್';

  @override
  String get backupSubtitle => 'ನಿಮ್ಮ ಲೆಕ್ಕದ ಪ್ರತಿಯನ್ನು ಸುರಕ್ಷಿತವಾಗಿರಿಸಿ';

  @override
  String get backupNowAction => 'ಈಗಲೇ ಬ್ಯಾಕಪ್ ಮಾಡಿ';

  @override
  String get backupRestoreAction => 'ಫೈಲ್‌ನಿಂದ ರಿಸ್ಟೋರ್ ಮಾಡಿ';

  @override
  String get backupShareSubject => 'VendorOS ಬ್ಯಾಕಪ್';

  @override
  String get backupSavedToast => 'ಬ್ಯಾಕಪ್ ಫೈಲ್ ಸೇವ್ ಆಗಿದೆ';

  @override
  String get backupFailedToast =>
      'ಬ್ಯಾಕಪ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get backupRestoredToast => 'ನಿಮ್ಮ ಲೆಕ್ಕಪತ್ರವನ್ನು ರಿಸ್ಟೋರ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get backupNeverSaved => 'ನೀವಿನ್ನೂ ಬ್ಯಾಕಪ್ ಮಾಡಿಲ್ಲ';

  @override
  String backupLastSaved(String when) {
    return 'ಕೊನೆಯ ಬ್ಯಾಕಪ್: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'ಸುಮಾರು $kb KB ಸೇವ್ ಆಗುತ್ತದೆ';
  }

  @override
  String get backupRestoreWarning =>
      'ರಿಸ್ಟೋರ್ ಮಾಡಿದರೆ ಈ ಫೋನ್‌ನಲ್ಲಿರುವ ಎಲ್ಲ ಡೇಟಾ ಅಳಿಸಿ ಫೈಲ್‌ನಲ್ಲಿರುವ ಡೇಟಾ ಬರುತ್ತದೆ.';

  @override
  String get backupRestoreConfirmTitle => 'ಈ ಬ್ಯಾಕಪ್ ರಿಸ್ಟೋರ್ ಮಾಡಬೇಕೇ?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$when ರ $rows ಎಂಟ್ರಿಗಳು ಈ ಫೋನ್‌ನಲ್ಲಿರುವ ಡೇಟಾವನ್ನು ಬದಲಿಸುತ್ತವೆ.';
  }

  @override
  String get backupErrorNotFile => 'ಇದು VendorOS ಬ್ಯಾಕಪ್ ಫೈಲ್ ಅಲ್ಲ.';

  @override
  String get backupErrorTooNew =>
      'ಈ ಬ್ಯಾಕಪ್ ಹೊಸ ವರ್ಷನ್‌ನದ್ದು. ದಯವಿಟ್ಟು ಮೊದಲು ಆ್ಯಪ್ ಅಪ್ಡೇಟ್ ಮಾಡಿ.';

  @override
  String get backupErrorCorrupt => 'ಈ ಬ್ಯಾಕಪ್ ಫೈಲ್ ಹಾಳಾಗಿದೆ, ಬಳಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get backupErrorEmpty => 'ಫೈಲ್ ಖಾಲಿ ಇದೆ.';

  @override
  String get exportGroupLabel => 'ಸ್ಪ್ರೆಡ್‌ಶೀಟ್ ಆಗಿ ಎಕ್ಸ್‌ಪೋರ್ಟ್ ಮಾಡಿ';

  @override
  String get exportSalesTitle => 'ಸೇಲ್ಸ್';

  @override
  String get exportSalesSubtitle =>
      'ದಿನಾಂಕ, ಐಟಂ ಮತ್ತು ಮೊತ್ತದೊಂದಿಗೆ ಪ್ರತಿಯೊಂದು ಸೇಲ್ ವಿವರ';

  @override
  String get exportBillsTitle => 'ಬಿಲ್‌ಗಳು';

  @override
  String get exportBillsSubtitle => 'ಬಿಲ್‌ವಾರು ಟೋಟಲ್, ಡಿಸ್ಕೌಂಟ್ ಮತ್ತು ಟ್ಯಾಕ್ಸ್';

  @override
  String get exportCreditTitle => 'ಉದ್ದರಿ ಬಾಕಿ';

  @override
  String get exportCreditSubtitle => 'ಯಾರು ಎಷ್ಟು ಬಾಕಿ ಕೊಡಬೇಕು ಎಂಬ ವಿವರ';

  @override
  String get exportStockTitle => 'ಸ್ಟಾಕ್';

  @override
  String get exportStockSubtitle => 'ಐಟಂಗಳು, ಇರುವ ಕ್ವಾಂಟಿಟಿ ಮತ್ತು ಬೆಲೆಗಳು';

  @override
  String get exportColDate => 'ದಿನಾಂಕ';

  @override
  String get exportColItem => 'ಐಟಂ';

  @override
  String get exportColMode => 'ಪಾವತಿ';

  @override
  String get exportColCustomer => 'ಗ್ರಾಹಕರು';

  @override
  String get exportColAmount => 'ಮೊತ್ತ';

  @override
  String get exportColBillNo => 'ಬಿಲ್ ನಂ.';

  @override
  String get exportColSubtotal => 'ಸಬ್‌ಟೋಟಲ್';

  @override
  String get exportColDiscount => 'ಡಿಸ್ಕೌಂಟ್';

  @override
  String get exportColTax => 'ಟ್ಯಾಕ್ಸ್';

  @override
  String get exportColTotal => 'ಟೋಟಲ್';

  @override
  String get exportColPayment => 'ಪಾವತಿ ವಿಧಾನ';

  @override
  String get exportColStatus => 'ಸ್ಟೇಟಸ್';

  @override
  String get exportColBalance => 'ಬಾಕಿ';

  @override
  String get exportColCode => 'ಕೋಡ್';

  @override
  String get exportColCategory => 'ಕೆಟಗರಿ';

  @override
  String get exportColUnit => 'ಯೂನಿಟ್';

  @override
  String get exportColQty => 'ಕ್ವಾಂಟಿಟಿ';

  @override
  String get exportColCost => 'ಖರೀದಿ ಬೆಲೆ';

  @override
  String get exportColPrice => 'ಮಾರಾಟ ಬೆಲೆ';

  @override
  String get gstReportTitle => 'GST ಸಾರಾಂಶ';

  @override
  String get gstReportSubtitle => 'ನಿಮ್ಮ ಅಕೌಂಟೆಂಟ್‌ಗಾಗಿ ತಿಂಗಳ ಪ್ರಕಾರ ಟ್ಯಾಕ್ಸ್';

  @override
  String get gstReportEmpty =>
      'ಇನ್ನೂ ಯಾವುದೇ GST ಬಿಲ್‌ಗಳಿಲ್ಲ. ಮೆನು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ GST ಆನ್ ಮಾಡಿ, ನಂತರ ಬಿಲ್ ಮಾಡಿ.';

  @override
  String get gstColMonth => 'ತಿಂಗಳು';

  @override
  String get gstColRate => 'ದರ';

  @override
  String get gstColTaxable => 'ಟ್ಯಾಕ್ಸ್‌ಗೆ ಒಳಪಡುವ ಮೌಲ್ಯ';

  @override
  String get gstColTax => 'ಒಟ್ಟು ಟ್ಯಾಕ್ಸ್';

  @override
  String get gstBills => 'ಬಿಲ್‌ಗಳು';

  @override
  String get gstSales => 'ಟ್ಯಾಕ್ಸ್ ಸೇರಿ ಮಾರಾಟ';

  @override
  String get gstByRate => 'ದರದ ಪ್ರಕಾರ';

  @override
  String get gstShareAction => 'ಸ್ಪ್ರೆಡ್‌ಶೀಟ್ ಶೇರ್ ಮಾಡಿ';

  @override
  String gstShareSubject(String month) {
    return 'GST ಸಾರಾಂಶ $month';
  }

  @override
  String get appearanceTitle => 'ಸ್ಕ್ರೀನ್ ಥೀಮ್';

  @override
  String get appearanceSubtitle => 'ಲೈಟ್ ಅಥವಾ ಡಾರ್ಕ್ ಸ್ಕ್ರೀನ್';

  @override
  String get appearanceSystem => 'ಫೋನ್ ಸೆಟ್ಟಿಂಗ್ ಪ್ರಕಾರ';

  @override
  String get appearanceLight => 'ಲೈಟ್';

  @override
  String get appearanceDark => 'ಡಾರ್ಕ್';

  @override
  String get appearanceChanged => 'ಥೀಮ್ ಬದಲಾಗಿದೆ';

  @override
  String get purchasesTitle => 'ಖರೀದಿಗಳು';

  @override
  String get purchasesSubtitle => 'ಸಪ್ಲೈಯರ್ ಬಿಲ್‌ಗಳು ಮತ್ತು ಉಳಿದ ಬಾಕಿ';

  @override
  String get purchasesEmpty =>
      'ಯಾವುದೇ ಖರೀದಿ ಬಿಲ್‌ಗಳಿಲ್ಲ. ಇತ್ತೀಚೆಗೆ ಖರೀದಿಸಿದ ಸ್ಟಾಕ್ ಸೇರಿಸಿ.';

  @override
  String get purchaseAdd => 'ಖರೀದಿ ಸೇರಿಸಿ';

  @override
  String get purchaseTotalDue => 'ಸಪ್ಲೈಯರ್‌ಗೆ ನೀಡಬೇಕಾದ ಬಾಕಿ';

  @override
  String get purchaseMonthSpend => 'ಈ ತಿಂಗಳ ಖರೀದಿ';

  @override
  String get purchaseDuesTitle => 'ಸಪ್ಲೈಯರ್ ಬಾಕಿಗಳು';

  @override
  String get purchaseNoDues => 'ಎಲ್ಲಾ ಸಪ್ಲೈಯರ್ ಬಿಲ್‌ಗಳು ಪಾವತಿಯಾಗಿವೆ.';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills ಬಿಲ್(ಗಳು) · ಹಳೆಯದು $days ದಿನ(ಗಳು)';
  }

  @override
  String get purchaseBillsTitle => 'ಖರೀದಿ ಬಿಲ್‌ಗಳು';

  @override
  String get purchasePaidFull => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String purchaseDueOf(String amount) {
    return '$amount ಬಾಕಿ';
  }

  @override
  String get purchaseSupplier => 'ಸಪ್ಲೈಯರ್';

  @override
  String purchasePayTitle(String name) {
    return '$name ಅವರಿಗೆ ಪಾವತಿಸಿ';
  }

  @override
  String get purchasePayAmount => 'ಪಾವತಿಸಿದ ಹಣ';

  @override
  String get purchasePay => 'ಪಾವತಿ ನಮೂದಿಸಿ';

  @override
  String get purchaseSubtotal => 'ಐಟಂಗಳ ಮೊತ್ತ';

  @override
  String get purchaseTax => 'ಟ್ಯಾಕ್ಸ್';

  @override
  String get purchaseTotal => 'ಒಟ್ಟು ಬಿಲ್';

  @override
  String get purchaseDue => 'ಇನ್ನೂ ಬಾಕಿ ಇದೆ';

  @override
  String get purchaseNewTitle => 'ಹೊಸ ಖರೀದಿ ಬಿಲ್';

  @override
  String get purchaseInvoiceNo => 'ಬಿಲ್ ನಂಬರ್';

  @override
  String get purchaseItems => 'ಖರೀದಿಸಿದ ಐಟಂಗಳು';

  @override
  String get purchaseLinkProduct => 'ನಿಮ್ಮ ಸ್ಟಾಕ್ ಲಿಸ್ಟ್‌ನಿಂದ ಆರಿಸಿ';

  @override
  String get purchaseFreeItem => 'ಐಟಂ ಹೆಸರು';

  @override
  String get purchaseQty => 'ಪ್ರಮಾಣ';

  @override
  String get purchaseUnitCost => 'ಯೂನಿಟ್ ಬೆಲೆ';

  @override
  String get purchaseAddLine => 'ಐಟಂ ಸೇರಿಸಿ';

  @override
  String get purchasePaidNow => 'ಈಗ ಪಾವತಿಸಿದ್ದು';

  @override
  String get purchaseNote => 'ಟಿಪ್ಪಣಿ';

  @override
  String get purchaseSaved => 'ಖರೀದಿ ಸೇವ್ ಆಗಿದೆ ಮತ್ತು ಸ್ಟಾಕ್ ಅಪ್ಡೇಟ್ ಆಗಿದೆ';

  @override
  String get permRecordPurchase => 'ಖರೀದಿ ಬಿಲ್ ದಾಖಲಿಸಿ';

  @override
  String get permPaySupplier => 'ಸಪ್ಲೈಯರ್‌ಗಳಿಗೆ ಪಾವತಿಸಿ';

  @override
  String get backupCloudTitle => 'ಆನ್‌ಲೈನ್ ಬ್ಯಾಕಪ್';

  @override
  String backupCloudLast(String when) {
    return 'ಕೊನೆಯ ಆನ್‌ಲೈನ್ ಬ್ಯಾಕಪ್: $when';
  }

  @override
  String get backupCloudNever => 'ಇನ್ನೂ ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಉಳಿಸಿಲ್ಲ';

  @override
  String get backupCloudNeedsShop => 'ಮೊದಲು ಕ್ಲೌಡ್ ಅಂಗಡಿ ರಚಿಸಿ';

  @override
  String get backupCloudNowAction => 'ಈಗ ಆನ್‌ಲೈನ್ ಬ್ಯಾಕಪ್ ಮಾಡಿ';

  @override
  String get backupCloudRestoreAction => 'ಆನ್‌ಲೈನ್‌ನಿಂದ ಮರುಸ್ಥಾಪಿಸಿ';

  @override
  String get backupCloudSavedToast => 'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get backupCloudFailedToast =>
      'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಉಳಿಸಲಾಗಲಿಲ್ಲ. ಸಿಗ್ನಲ್ ಬಂದಾಗ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get billWhatsapp => 'ವಾಟ್ಸಾಪ್‌ನಲ್ಲಿ ಕಳುಹಿಸಿ';

  @override
  String get billWhatsappFailed => 'ಈ ಫೋನ್‌ನಲ್ಲಿ ವಾಟ್ಸಾಪ್ ಇಲ್ಲ.';

  @override
  String get devicesStaffRole => 'ಸಿಬ್ಬಂದಿ ಪಾತ್ರ';

  @override
  String get devicesRoleDefault => 'ಡೀಫಾಲ್ಟ್ (ಕೆಲಸ ಮಾತ್ರ)';

  @override
  String get devicesRolePick => 'ಒಂದು ಸಿಬ್ಬಂದಿ ಪಾತ್ರವನ್ನು ಆರಿಸಿ';

  @override
  String get devicesRoleSaved => 'ಪಾತ್ರವನ್ನು ಆ ಫೋನ್‌ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get devicesRoleFailed =>
      'ಪಾತ್ರವನ್ನು ಹೊಂದಿಸಲಾಗಲಿಲ್ಲ. ಆನ್‌ಲೈನ್ ಇದ್ದಾಗ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get adminTitle => 'ಮಾಲೀಕರ ವರದಿಗಳು';

  @override
  String get adminSubtitle => 'ಏನಾಯಿತು, ಯಾರು ಮಾಡಿದರು, ನಗದು ಹೊಂದಿಕೆಯಾಯಿತೆ';

  @override
  String get adminExceptionsTitle => 'ವಿನಾಯಿತಿಗಳು';

  @override
  String get adminExceptionsSubtitle => 'ರಿಯಾಯಿತಿ, ರದ್ದಾದ ಬಿಲ್, ಮರುಮುದ್ರಣ, ಸಾಲ';

  @override
  String get adminStaffTitle => 'ಸಿಬ್ಬಂದಿ ವರದಿ';

  @override
  String get adminStaffSubtitle => 'ಈ ಅವಧಿಯಲ್ಲಿ ಪ್ರತಿಯೊಬ್ಬರೂ ಏನು ಮಾಡಿದರು';

  @override
  String get adminCashTitle => 'ನಗದು ಪುಸ್ತಕ';

  @override
  String get adminCashSubtitle => 'ನಿರೀಕ್ಷಿತ ಮತ್ತು ಎಣಿಸಿದ್ದು, ದಿನವಾರು';

  @override
  String get adminItemsTitle => 'ವಸ್ತು ಅಂತರ';

  @override
  String get adminItemsSubtitle => 'ಮಾರಾಟ ಮತ್ತು ದಾಸ್ತಾನಿನಿಂದ ತೆಗೆದದ್ದು';

  @override
  String get adminShopsTitle => 'ಎಲ್ಲಾ ಅಂಗಡಿಗಳು';

  @override
  String get adminShopsSubtitle => 'ನೀವು ನಡೆಸುವ ಪ್ರತಿ ಅಂಗಡಿಯ ಒಟ್ಟು';

  @override
  String get adminSummaryTitle => 'ಇಂದಿನ ಸಾರಾಂಶ';

  @override
  String get adminSummarySend => 'ಸಾರಾಂಶ ಕಳುಹಿಸಿ';

  @override
  String get adminShare => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get adminNoRows => 'ಈ ಅವಧಿಗೆ ಏನೂ ಇಲ್ಲ';

  @override
  String get adminFromBill => 'ಬಿಲ್‌ನಿಂದ';

  @override
  String get adminOwnerApproved => 'ಮಾಲೀಕರ ಅನುಮೋದನೆ';

  @override
  String get adminColActions => 'ಕ್ರಿಯೆಗಳು';

  @override
  String get adminColDiscount => 'ನೀಡಿದ ರಿಯಾಯಿತಿ';

  @override
  String get adminColCredit => 'ನೀಡಿದ ಸಾಲ';

  @override
  String get adminColVoids => 'ರದ್ದುಗೊಳಿಸಿದ ಬಿಲ್';

  @override
  String get adminColReprints => 'ಮರುಮುದ್ರಣಗಳು';

  @override
  String get adminColOverrides => 'ಮಾಲೀಕರ ಅನುಮೋದನೆಗಳು';

  @override
  String get adminSeeExceptions => 'ಇವರ ವಿನಾಯಿತಿಗಳನ್ನು ನೋಡಿ';

  @override
  String get adminCashOpening => 'ಆರಂಭಿಕ ನಗದು';

  @override
  String get adminCashExpected => 'ನಿರೀಕ್ಷಿತ';

  @override
  String get adminCashCounted => 'ಎಣಿಸಿದ್ದು';

  @override
  String get adminCashShort => 'ಕಡಿಮೆ';

  @override
  String get adminCashOver => 'ಹೆಚ್ಚು';

  @override
  String get adminCashNet => 'ನಿವ್ವಳ ವ್ಯತ್ಯಾಸ';

  @override
  String get adminCashMatched => 'ಹೊಂದಿಕೆಯಾದ ದಿನಗಳು';

  @override
  String get adminCashMatchedOne => 'ಹೊಂದಿಕೆ';

  @override
  String get adminCashShortDays => 'ಕಡಿಮೆಯಾದ ದಿನಗಳು';

  @override
  String get adminItemSold => 'ಮಾರಾಟವಾದದ್ದು';

  @override
  String get adminItemStockOut => 'ದಾಸ್ತಾನಿನಿಂದ ತೆಗೆದದ್ದು';

  @override
  String get adminItemGap => 'ಅಂತರ';

  @override
  String get adminItemWasted => 'ಹಾಳಾದದ್ದು';

  @override
  String get adminSummaryBills => 'ಬಿಲ್‌ಗಳು';

  @override
  String get adminSummarySales => 'ಮಾರಾಟ';

  @override
  String get adminSummaryCash => 'ನಗದು';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'ಸಾಲ';

  @override
  String get adminSummaryDiscount => 'ರಿಯಾಯಿತಿಗಳು';

  @override
  String get adminSummarySpend => 'ಖರ್ಚು';

  @override
  String get adminSummaryCashDiff => 'ನಗದು ವ್ಯತ್ಯಾಸ';

  @override
  String get adminSummaryTop => 'ಹೆಚ್ಚು ಮಾರಾಟವಾದವು';

  @override
  String get adminShopsAllTotal => 'ಎಲ್ಲಾ ಅಂಗಡಿಗಳು ಸೇರಿ';

  @override
  String get adminShopsOrders => 'ಆರ್ಡರ್‌ಗಳು (7 ದಿನ)';

  @override
  String get adminShopsValue => 'ಮೌಲ್ಯ (7 ದಿನ)';

  @override
  String get adminShopsAdd => 'ಇನ್ನೊಂದು ಅಂಗಡಿ ಸೇರಿಸಿ';

  @override
  String get adminShopsAddHelp =>
      'ಇನ್ನೊಂದು ಅಂಗಡಿಯ ಲಿಂಕ್ ಹೆಸರು ಮತ್ತು ಮಾಲೀಕರ ಕೀ ಬರೆಯಿರಿ.';

  @override
  String get adminShopsAddAction => 'ಅಂಗಡಿ ಸೇರಿಸಿ';

  @override
  String get adminShopsSlug => 'ಅಂಗಡಿ ಲಿಂಕ್ ಹೆಸರು';

  @override
  String get adminShopsKey => 'ಮಾಲೀಕರ ಕೀ';

  @override
  String get adminShopsRemove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get adminShopsRefresh => 'ರಿಫ್ರೆಶ್';

  @override
  String get adminShopsError => 'ಈ ಅಂಗಡಿಯನ್ನು ಓದಲಾಗಲಿಲ್ಲ';

  @override
  String get adminShopsInvalid => 'ಲಿಂಕ್ ಹೆಸರು ಮತ್ತು ಮಾಲೀಕರ ಕೀ ಪರಿಶೀಲಿಸಿ';

  @override
  String get adminShopsExists => 'ಆ ಅಂಗಡಿ ಈಗಾಗಲೇ ಪಟ್ಟಿಯಲ್ಲಿದೆ';

  @override
  String get permViewCashBook => 'ನಗದು ಪುಸ್ತಕ ನೋಡಿ';

  @override
  String get permExportData => 'ಡೇಟಾ ರಫ್ತು';

  @override
  String get permViewStaffReport => 'ಸಿಬ್ಬಂದಿ ವರದಿ ನೋಡಿ';
}
