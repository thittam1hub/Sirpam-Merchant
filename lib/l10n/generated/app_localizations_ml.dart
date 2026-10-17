// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'നമസ്കാരം $name, $stall-ൽ നൽകാനുള്ള ബാക്കി തുക Rs $amount ആണ്. ദയവായി തുക അടയ്ക്കുക. നന്ദി.$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navUdhaar => 'കടം';

  @override
  String get navSoundbox => 'സൗണ്ട്';

  @override
  String get navMandi => 'മാർക്കറ്റ്';

  @override
  String get navSales => 'വിൽപ്പന';

  @override
  String get navGroupOverview => 'ഓവർവ്യൂ';

  @override
  String get navGroupSell => 'വിൽക്കുക';

  @override
  String get navGroupOperations => 'കസ്റ്റമേഴ്സും പ്രവർത്തനങ്ങളും';

  @override
  String get navGroupBusiness => 'ബിസിനസ്സ്';

  @override
  String get navGroupTeam => 'ടീം';

  @override
  String get navGroupSystem => 'സിസ്റ്റം';

  @override
  String get moreLabel => 'കൂടുതൽ';

  @override
  String get menuLoanReport => 'ലോൺ റിപ്പോർട്ട്';

  @override
  String get menuCartLocation => 'വണ്ടിയുടെ ലൊക്കേഷൻ';

  @override
  String get menuSettings => 'സെറ്റിങ്സ്';

  @override
  String get notFoundTitle => 'പേജ് കണ്ടെത്താനായില്ല';

  @override
  String get goHome => 'ഹോമിലേക്ക് പോകുക';

  @override
  String get ok => 'ശരി';

  @override
  String get loading => 'ലോഡിംഗ്…';

  @override
  String storageWriteFailedKey(String key) {
    return 'സേവ് ചെയ്യാനായില്ല ($key) — വീണ്ടും ശ്രമിക്കുക';
  }

  @override
  String get storageWriteFailed => 'സേവ് ചെയ്യാനായില്ല — വീണ്ടും ശ്രമിക്കുക';

  @override
  String get micUnavailable => 'മൈക്രോഫോൺ ലഭ്യമല്ല — നേരിട്ട് ടൈപ്പ് ചെയ്യുക';

  @override
  String get voiceNothingHeard => 'കേൾക്കാനായില്ല — വീണ്ടും പറയുക';

  @override
  String get voiceNoAmount =>
      'തുക കേൾക്കാനായില്ല — \"50 രൂപ തക്കാളി\" എന്ന് പറയൂ';

  @override
  String get voiceZeroAmount => 'തുക പൂജ്യമാകാൻ പാടില്ല';

  @override
  String get modeCash => 'ക്യാഷ്';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'കടം';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount രേഖപ്പെടുത്തി';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'ഇന്നത്തെ ആകെ കച്ചവടം $amount രൂപ';
  }

  @override
  String get todayCollection => 'ഇന്നത്തെ കളക്ഷൻ';

  @override
  String get quickEntry => 'പെട്ടെന്നുള്ള എൻട്രി';

  @override
  String get todayEntries => 'ഇന്നത്തെ എൻട്രികൾ';

  @override
  String get noEntriesYet => 'എൻട്രികൾ ഒന്നുമില്ല — മൈക്ക് അമർത്തി സംസാരിക്കുക';

  @override
  String get listeningTapToStop => 'കേൾക്കുന്നു, നിർത്താൻ അമർത്തുക';

  @override
  String get tapToSpeak => 'റെക്കോർഡ് ചെയ്യാൻ പറയുക';

  @override
  String get listening => 'കേൾക്കുന്നു…';

  @override
  String get speakToRecord => '🎙️ റെക്കോർഡ് ചെയ്യാൻ പറയുക';

  @override
  String get voiceHint => '\"50 രൂപ തക്കാളി ക്യാഷ്\" / \"രവിക്ക് 200 കടം\"';

  @override
  String get addSale => 'വിൽപന ചേർക്കുക';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount രൂപ, $item';
  }

  @override
  String get delete => 'ഡിലീറ്റ്';

  @override
  String get locationServiceOff => 'ലൊക്കേഷൻ സർവീസ് ഓഫാണ്';

  @override
  String get locationPermissionDenied => 'ലൊക്കേഷൻ അനുമതി നൽകിയിട്ടില്ല';

  @override
  String get broadcastLive => 'ലൈവായി പങ്കിടുന്നു';

  @override
  String get locationSearching => 'ലൊക്കേഷൻ കണ്ടെത്തുന്നു…';

  @override
  String get permissionDenied => 'അനുമതി നിഷേധിച്ചു';

  @override
  String get unavailable => 'ലഭ്യമല്ല';

  @override
  String get broadcastStopped => 'പങ്കിടുന്നത് നിർത്തി';

  @override
  String get locationNotFetched => 'ലൊക്കേഷൻ ഇതുവരെ കിട്ടിയിട്ടില്ല';

  @override
  String get stopBroadcast => 'പങ്കിടുന്നത് നിർത്തുക';

  @override
  String get startBroadcast => 'പങ്കിടാൻ തുടങ്ങുക';

  @override
  String get sendToCustomer => 'കസ്റ്റമേഴ്സിന് അയക്കുക';

  @override
  String get shareLocationHint =>
      'ഇന്നത്തെ വണ്ടിയുടെ ലൊക്കേഷൻ WhatsApp വഴി ഷെയർ ചെയ്യൂ.';

  @override
  String get ourCart => 'നമ്മുടെ വണ്ടി';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall ഇന്ന് ഇവിടെയുണ്ട് 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'WhatsApp-ൽ ഷെയർ ചെയ്യുക';

  @override
  String get openInMaps => 'മാപ്പിൽ തുറക്കുക';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in റിക്വസ്റ്റ് നിരസിച്ചു — API കീ പരിശോധിക്കുക ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'കണക്ഷൻ പരാജയപ്പെട്ടു: $error';
  }

  @override
  String get mandiTitle => 'മാർക്കറ്റ് വില';

  @override
  String get refresh => 'പുതുക്കുക';

  @override
  String get mandiLoading => 'മാർക്കറ്റ് വിലകൾ ലോഡ് ചെയ്യുന്നു';

  @override
  String get fetchFailed => 'വിവരങ്ങൾ ലഭ്യമല്ല';

  @override
  String get apiKeyNeeded => 'data.gov.in API കീ ആവശ്യമാണ്';

  @override
  String get apiKeyNeededBody =>
      'തത്സമയ APMC നിരക്കുകൾ അറിയാൻ സൗജന്യ data.gov.in API കീ നേടി Settings-ൽ ചേർക്കുക. വ്യാജ നിരക്കുകൾ കാണിക്കില്ല.';

  @override
  String get refreshFailed => 'പുതുക്കൽ പരാജയപ്പെട്ടു';

  @override
  String lastUpdated(String time) {
    return 'അവസാനം പുതുക്കിയത്: $time';
  }

  @override
  String get searchVegetable => 'പച്ചക്കറി തിരയുക';

  @override
  String get loanReportHeading => 'ബിസിനസ് ലോൺ റിപ്പോർട്ട്';

  @override
  String reportFailed(String error) {
    return 'റിപ്പോർട്ട് പരാജയപ്പെട്ടു: $error';
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
      other: '$daysString ദിവസം',
      one: '1 ദിവസം',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'ആകെ ബിസിനസ്';

  @override
  String get digitalShare => 'ഡിജിറ്റൽ വിഹിതം';

  @override
  String get avgDailyIncome => 'ശരാശരി ദിവസ വരുമാനം';

  @override
  String get recordedDays => 'രേഖപ്പെടുത്തിയ ദിവസങ്ങൾ';

  @override
  String get sha256Checksum => 'SHA-256 ചെക്ക്സം';

  @override
  String get noSalesYet =>
      'വിൽപനയൊന്നും രേഖപ്പെടുത്തിയിട്ടില്ല — റിപ്പോർട്ട് ലഭിക്കാൻ ആദ്യം വിൽപന രേഖപ്പെടുത്തുക.';

  @override
  String get viewPdf => 'PDF കാണുക';

  @override
  String get sendToBank => 'ബാങ്കിലേക്ക് അയക്കുക';

  @override
  String get stallName => 'കടയുടെ പേര്';

  @override
  String get ownerName => 'ഉടമയുടെ പേര്';

  @override
  String get upiVpaLabel => 'UPI VPA (ഉദാ: name@okaxis)';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get mandiMarket => 'മാർക്കറ്റ് (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API കീ';

  @override
  String get apiKeyHelp =>
      'കീ ലഭിക്കാൻ data.gov.in-ൽ സൗജന്യമായി രജിസ്റ്റർ ചെയ്യുക. കീ ഇല്ലാതെ ലൈവ് വിലകൾ കാണിക്കില്ല.';

  @override
  String get soundboxAnnounce => 'സൗണ്ട്ബോക്സ് അനൗൺസ്‌മെന്റുകൾ';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String soundboxSpeech(String amount) {
    return '$amount രൂപ ലഭിച്ചു';
  }

  @override
  String get soundboxTitle => 'സൗണ്ട്ബോക്സ്';

  @override
  String get soundboxSubtitle => 'UPI പേയ്‌മെന്റുകൾ നിങ്ങളുടെ ഭാഷയിൽ കേൾക്കാം';

  @override
  String get watchedApps => 'ശ്രദ്ധിക്കുന്ന ആപ്പുകൾ';

  @override
  String get soundboxTestHint =>
      'ടെസ്റ്റ്: \"250 രൂപ ലഭിച്ചു\" എന്ന് കേൾപ്പിക്കും';

  @override
  String get speak => 'ശബ്ദം കേൾക്കുക';

  @override
  String get announcedPayments => 'അനൗൺസ് ചെയ്ത പേയ്‌മെന്റുകൾ';

  @override
  String get noUpiYet => 'ഇതുവരെ UPI പേയ്‌മെന്റുകളൊന്നും ലഭിച്ചിട്ടില്ല';

  @override
  String get soundboxRunning => 'സൗണ്ട്ബോക്സ് പ്രവർത്തിക്കുന്നുണ്ട്';

  @override
  String get notificationAccessNeeded => 'നോട്ടിഫിക്കേഷൻ അനുമതി വേണം';

  @override
  String get soundboxAndroidHint =>
      'PhonePe, Paytm, Google Pay, BHIM വഴിയുള്ള പേയ്‌മെന്റുകൾ തനിയെ അനൗൺസ് ചെയ്യും.';

  @override
  String get soundboxGrantHint =>
      'Android സെറ്റിങ്സിൽ VendorOS-ന് നോട്ടിഫിക്കേഷൻ അനുമതി നൽകുക.';

  @override
  String get grantAccess => 'അനുമതി നൽകുക';

  @override
  String get iosUnavailable => 'iOS-ൽ ലഭ്യമല്ല';

  @override
  String get webUnavailable => 'ബ്രൗസറിൽ ലഭ്യമല്ല';

  @override
  String get iosSoundboxNote =>
      'Apple-ന്റെ നിയന്ത്രണങ്ങൾ കാരണം മറ്റ് ആപ്പുകളുടെ നോട്ടിഫിക്കേഷൻ വായിക്കാനാകില്ല. നേരിട്ടുള്ളതോ വോയ്‌സ് വഴിയുള്ളതോ ആയ എൻട്രി മാത്രം.';

  @override
  String get webSoundboxNote =>
      'മറ്റ് ആപ്പുകളിൽ നിന്നുള്ള UPI നോട്ടിഫിക്കേഷനുകൾ ബ്രൗസറിന് വായിക്കാൻ കഴിയില്ല. സൗണ്ട്ബോക്സിനായി Android APK ഇൻസ്റ്റാൾ ചെയ്യുക.';

  @override
  String get serverSoundbox => 'ബിസിനസ് UPI സൗണ്ട്ബോക്സ്';

  @override
  String get serverSoundboxNote =>
      'സ്ഥിരീകരിച്ച പേയ്‌മെന്റുകൾ ഇവിടെ അനൗൺസ് ചെയ്യും. ഒന്നും വിട്ടുപോകില്ല: ഫോണിൽ അനൗൺസ് ചെയ്യുന്നത് വരെ പേയ്‌മെന്റ് ക്യൂവിലുണ്ടാകും.';

  @override
  String get notPaired =>
      'ഈ ഫോൺ ഇതുവരെ ഒരു ബിസിനസ് UPI അക്കൗണ്ടുമായി ബന്ധിപ്പിച്ചിട്ടില്ല.';

  @override
  String get pairingCode => 'പെയറിംഗ് കോഡ്';

  @override
  String get pair => 'ഫോൺ ലിങ്ക് ചെയ്യുക';

  @override
  String get unpair => 'അൺലിങ്ക് ചെയ്യുക';

  @override
  String pairedWith(String name) {
    return '$name-മായി ബന്ധിപ്പിച്ചു';
  }

  @override
  String get syncNow => 'ഇപ്പോൾ പരിശോധിക്കുക';

  @override
  String lastChecked(String time) {
    return 'അവസാനം പരിശോധിച്ചത്: $time';
  }

  @override
  String get neverChecked => 'ഇതുവരെ പരിശോധിച്ചിട്ടില്ല';

  @override
  String get soundboxStale =>
      'സെർവറുമായി ബന്ധപ്പെടാൻ കഴിയുന്നില്ല. ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'അനൗൺസ് ചെയ്യാൻ $countString പേയ്‌മെന്റുകൾ ബാക്കിയുണ്ട്',
      one: 'അനൗൺസ് ചെയ്യാൻ 1 പേയ്‌മെന്റ് ബാക്കിയുണ്ട്',
      zero: 'ഒന്നും ബാക്കിയില്ല',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'നോട്ടിഫിക്കേഷൻ സൗണ്ട്ബോക്സ് (ബാക്കപ്പ്)';

  @override
  String get udhaarTitle => 'കടം ബുക്ക്';

  @override
  String get udhaarSubtitle => 'കസ്റ്റമർ ബാക്കി';

  @override
  String get totalOutstanding => 'ആകെ കിട്ടാനുള്ളത്';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString കസ്റ്റമർമാർ',
      one: '1 കസ്റ്റമർ',
      zero: 'കസ്റ്റമർമാരില്ല',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'ഫിൽട്ടർ: $name';
  }

  @override
  String get clearFilter => 'ഫിൽട്ടർ മാറ്റുക';

  @override
  String get upiSetupHint =>
      'UPI വഴി പണം ചോദിക്കാൻ സെറ്റിങ്സിൽ VPA-യും കടയുടെ പേരും നൽകുക.';

  @override
  String get noOutstanding => 'കടം ബാക്കിയില്ല';

  @override
  String cannotOpen(String scheme) {
    return 'തുറക്കാൻ കഴിഞ്ഞില്ല: $scheme';
  }

  @override
  String get askUpi => 'UPI ചോദിക്കുക';

  @override
  String get collect => 'വാങ്ങുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get language => 'ഭാഷ';

  @override
  String get languageChanged => 'ഭാഷ മാറ്റി';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return '$name-ന്റെ കടം';
  }

  @override
  String get defaultStallName => 'VendorOS സ്റ്റാൾ';

  @override
  String get merchantOnboardingTitle => 'ബിസിനസ്സ് UPI ചേർക്കുക';

  @override
  String get merchantOnboardingSubtitle =>
      'ബിസിനസ്സ് അക്കൗണ്ട് സൗണ്ട്ബോക്സുമായി ലിങ്ക് ചെയ്യുക';

  @override
  String get merchantStepsHint =>
      'PhonePe for Business അല്ലെങ്കിൽ Paytm for Business ഡാഷ്‌ബോർഡിലെ വിവരങ്ങൾ നൽകുക. പെയറിംഗ് കോഡ് ലഭിക്കുന്നതോടെ ഈ ഫോൺ ഉടൻ കണക്റ്റാകും.';

  @override
  String get howToGetBusinessUpi => 'ബിസിനസ്സ് UPI അക്കൗണ്ട് എങ്ങനെ തുടങ്ങാം?';

  @override
  String get merchantFormIncomplete =>
      'ബിസിനസ്സ് പേര്, merchant id, secret key എന്നിവ നൽകുക.';

  @override
  String get merchantRegistered => 'ബിസിനസ്സ് രജിസ്റ്റർ ചെയ്തു';

  @override
  String get pairingCodeSaveHint =>
      'ഈ പെയറിംഗ് കോഡ് സൂക്ഷിക്കുക. രണ്ടാമതൊരു ഫോൺ ലിങ്ക് ചെയ്യാൻ ഇത് ഉപയോഗിക്കാം.';

  @override
  String get callbackUrlLabel => 'ഡാഷ്‌ബോർഡിനുള്ള Callback URL';

  @override
  String get backToSoundbox => 'സൗണ്ട്ബോക്സിലേക്ക് മടങ്ങുക';

  @override
  String get copy => 'കോപ്പി';

  @override
  String get copied => 'കോപ്പി ചെയ്തു';

  @override
  String get provider => 'പേയ്‌മെന്റ് പ്രൊവൈഡർ';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'ബിസിനസ്സ് പേര്';

  @override
  String get businessNameHint =>
      'സൗണ്ട്ബോക്സ് പറയുന്നതും റിപ്പോർട്ടിൽ വരുന്നതുമായ പേര്';

  @override
  String get businessVpa => 'ബിസിനസ്സ് UPI വിലാസം';

  @override
  String get businessVpaHint => 'stallname@ybl';

  @override
  String get merchantIdLabel => 'Merchant id (MID)';

  @override
  String get merchantIdHint => 'പ്രൊവൈഡർ ഡാഷ്‌ബോർഡിൽ നിന്ന്';

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
      'Paytm ഡാഷ്‌ബോർഡിലും നൽകുന്ന ശക്തമായ പാസ്‌വേഡ്';

  @override
  String get secretStorageNote =>
      'രഹസ്യ കീ സെർവറിൽ മാത്രമേ സൂക്ഷിക്കൂ, ആപ്പിൽ ഇത് വീണ്ടും കാണാനാകില്ല.';

  @override
  String get registerBusiness => 'ബിസിനസ്സ് UPI രജിസ്റ്റർ ചെയ്യുക';

  @override
  String get helpTitle => 'സഹായം';

  @override
  String get helpSubtitle => 'ബിസിനസ്സ് UPI, സൗണ്ട്‌ബോക്‌സ് വിവരങ്ങൾ';

  @override
  String get helpWhyTitle => 'എന്തുകൊണ്ട് ബിസിനസ്സ് UPI അക്കൗണ്ട്?';

  @override
  String get helpWhyBody =>
      'വ്യക്തിഗത UPI വഴി പേയ്‌മെന്റുകൾ സെർവറിൽ സ്ഥിരീകരിക്കാനാകില്ല, അതിനാൽ അനൗൺസ്‌മെന്റുകൾ നഷ്ടപ്പെടാം. ബിസിനസ്സ് അക്കൗണ്ട് എല്ലാ പേയ്‌മെന്റുകളും VendorOS-ലേക്ക് എത്തിക്കുന്നു, സൗണ്ട്‌ബോക്‌സ് ഒന്നും വിട്ടുപോകില്ല.';

  @override
  String get helpDocsTitle => 'ആവശ്യമായവ';

  @override
  String get helpDocsAadhaar =>
      'Aadhaar നമ്പറും അതുമായി ലിങ്ക് ചെയ്ത മൊബൈൽ നമ്പറും';

  @override
  String get helpDocsPan => 'PAN കാർഡ് (ചെറുകിട കടകൾക്ക് സ്വന്തം PAN മതിയാകും)';

  @override
  String get helpDocsBank => 'പണം വരാനുള്ള ബാങ്ക് അക്കൗണ്ട് നമ്പറും IFSC-യും';

  @override
  String get helpDocsShop => 'കടയുടെ പേര്, വിലാസം, കടയുടെ ഫോട്ടോ';

  @override
  String get helpRegisterTitle => 'രജിസ്റ്റർ ചെയ്യേണ്ട വിധം';

  @override
  String get helpRegisterStep1 =>
      'Play Store-ൽ നിന്ന് PhonePe for Business അല്ലെങ്കിൽ Paytm for Business ഇൻസ്റ്റാൾ ചെയ്യുക.';

  @override
  String get helpRegisterStep2 =>
      'മൊബൈൽ നമ്പർ നൽകി സൈൻ അപ്പ് ചെയ്യുക, Aadhaar, PAN എന്നിവ നൽകി KYC പൂർത്തിയാക്കുക.';

  @override
  String get helpRegisterStep3 =>
      'പണം വരാൻ ബാങ്ക് അക്കൗണ്ട് ചേർക്കുക, സൗജന്യ QR സ്റ്റിക്കർ വാങ്ങുക.';

  @override
  String get helpRegisterStep4 =>
      'ആപ്പിൽ കാണിക്കുന്ന ബിസിനസ്സ് UPI അഡ്രസ്സ് (ഉദാ: stallname@ybl) കുറിച്ചുവെക്കുക.';

  @override
  String get helpKeysTitle => 'Merchant id-യും secret key-യും';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: ബിസിനസ്സ് ഡാഷ്‌ബോർഡ് തുറന്ന് Developer settings-ൽ പോയി merchant id, salt key, salt index എന്നിവ കോപ്പി ചെയ്യുക.';

  @override
  String get helpKeysPaytm =>
      'Paytm: ബിസിനസ്സ് ഡാഷ്‌ബോർഡ് തുറന്ന് Developer settings-ൽ പോയി MID കോപ്പി ചെയ്യുക, ഇവിടെ നൽകാനായി ശക്തമായ ഒരു webhook token ഉണ്ടാക്കുക.';

  @override
  String get helpKeysCallback =>
      'പേയ്‌മെന്റുകൾ VendorOS-ലേക്ക് എത്താൻ, രജിസ്ട്രേഷന് ശേഷം ലഭിക്കുന്ന callback URL പ്രൊവൈഡർ ഡാഷ്‌ബോർഡിൽ പേസ്റ്റ് ചെയ്യുക.';

  @override
  String get helpLinkTitle => 'ഈ ഫോൺ ലിങ്ക് ചെയ്യുക';

  @override
  String get helpLinkStep1 =>
      'Soundbox തുറന്ന് \'ബിസിനസ്സ് UPI രജിസ്റ്റർ ചെയ്യുക\' അമർത്തുക.';

  @override
  String get helpLinkStep2 =>
      'വിവരങ്ങൾ നൽകുക; ഫോൺ തനിയെ ലിങ്കായി പെയറിംഗ് കോഡ് കാണിക്കും.';

  @override
  String get helpLinkStep3 =>
      'മറ്റൊരു ഫോണിൽ ലിങ്ക് ചെയ്യാൻ, Soundbox-ൽ ആ പെയറിംഗ് കോഡ് നൽകുക.';

  @override
  String get helpSafetyTitle => 'സുരക്ഷിതമായി സൂക്ഷിക്കുക';

  @override
  String get helpSafetyBody =>
      'Salt key-യോ webhook token-ഓ ആരോടും പങ്കിടരുത്. VendorOS ഇത് സെർവറിൽ മാത്രമേ സൂക്ഷിക്കൂ, വീണ്ടും കാണിക്കില്ല.';

  @override
  String get menuInventory => 'സ്റ്റോക്ക്';

  @override
  String get productsTitle => 'സാധനങ്ങൾ';

  @override
  String get productsSubtitle => 'കാറ്റലോഗും സ്റ്റോക്കും';

  @override
  String get productsSearchHint => 'പേരോ കോഡോ തിരയുക';

  @override
  String get productsEmpty =>
      'സാധനങ്ങളൊന്നും ചേർത്തിട്ടില്ല. ആദ്യത്തെ ഐറ്റം ചേർക്കൂ.';

  @override
  String get productsAdd => 'സാധനം ചേർക്കുക';

  @override
  String get productsAllChip => 'എല്ലാം';

  @override
  String get productsLowStockChip => 'സ്റ്റോക്ക് കുറവ്';

  @override
  String get productEditTitle => 'സാധനം എഡിറ്റ് ചെയ്യുക';

  @override
  String get productMissing => 'ഈ സാധനം ലിസ്റ്റിൽ ഇല്ല.';

  @override
  String get productSaved => 'സേവ് ചെയ്തു';

  @override
  String get productArchived => 'സാധനം ഒഴിവാക്കി';

  @override
  String get formInvalid => 'സാധനത്തിന്റെ പേര് നൽകുക';

  @override
  String get fieldName => 'പേര്';

  @override
  String get fieldLocalName => 'തമിഴിലുള്ള പേര്';

  @override
  String get fieldCode => 'കോഡ്';

  @override
  String get fieldCodeHint => 'ബാർകോഡ്, അല്ലെങ്കിൽ പുതിയതിന് ഒഴിച്ചിടുക';

  @override
  String get fieldCategory => 'കാറ്റഗറി';

  @override
  String get fieldUnit => 'യൂണിറ്റ്';

  @override
  String get fieldCost => 'വാങ്ങിയ വില';

  @override
  String get fieldPrice => 'വിൽക്കുന്ന വില';

  @override
  String get fieldReorder => 'റീഓർഡർ ലെവൽ';

  @override
  String get saveLabel => 'സേവ് ചെയ്യുക';

  @override
  String get discardTitle => 'മാറ്റങ്ങൾ ഒഴിവാക്കണോ?';

  @override
  String get discardBody => 'സേവ് ചെയ്യാത്ത മാറ്റങ്ങളുണ്ട്.';

  @override
  String get discardKeep => 'തുടരുക';

  @override
  String get discardLeave => 'ഒഴിവാക്കുക';

  @override
  String get cancelLabel => 'റദ്ദാക്കുക';

  @override
  String get deleteLabel => 'ഡിലീറ്റ്';

  @override
  String get confirmLabel => 'ഉറപ്പാക്കുക';

  @override
  String get qtyLabel => 'അളവ്';

  @override
  String get unitCostLabel => 'യൂണിറ്റ് വില';

  @override
  String get expiryLabel => 'കാലാവധി (ദിവസങ്ങൾ)';

  @override
  String get unitKg => 'കിലോ';

  @override
  String get unitGram => 'ഗ്രാം';

  @override
  String get unitPiece => 'പീസ്';

  @override
  String get unitLitre => 'ലിറ്റർ';

  @override
  String get unitBundle => 'ബണ്ടിൽ';

  @override
  String get detailSell => 'വിൽക്കുക';

  @override
  String get detailRestock => 'സ്റ്റോക്ക് ചേർക്കുക';

  @override
  String get detailWastage => 'വേസ്റ്റേജ്';

  @override
  String get detailCorrect => 'സ്റ്റോക്ക് തിരുത്തുക';

  @override
  String get detailBatches => 'ബാച്ചുകൾ';

  @override
  String get detailHistory => 'ഹിസ്റ്ററി';

  @override
  String get detailLabel => 'ലേബൽ പ്രിന്റ് ചെയ്യുക';

  @override
  String get historyEmpty => 'സ്റ്റോക്ക് മാറ്റങ്ങളൊന്നും ഇതുവരെയില്ല';

  @override
  String get soldRecorded => 'വിൽപ്പന രേഖപ്പെടുത്തി';

  @override
  String get restocked => 'സ്റ്റോക്ക് ചേർത്തു';

  @override
  String get wastageRecorded => 'വേസ്റ്റേജ് രേഖപ്പെടുത്തി';

  @override
  String get stockCorrected => 'സ്റ്റോക്ക് അപ്‌ഡേറ്റ് ചെയ്തു';

  @override
  String get movementPurchase => 'പർച്ചേസ്';

  @override
  String get movementSale => 'വിൽപന';

  @override
  String get movementWastage => 'വേസ്റ്റേജ്';

  @override
  String get movementReturn => 'റിട്ടേൺ';

  @override
  String get movementCorrection => 'തിരുത്തൽ';

  @override
  String get expiredTag => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get expiryTodayTag => 'ഇന്ന് തീരും';

  @override
  String get noExpiry => 'എക്സ്പയറിയില്ല';

  @override
  String get batchesTitle => 'ബാച്ചുകൾ';

  @override
  String get batchesSubtitle => 'എക്സ്പയറി വിവരങ്ങൾ';

  @override
  String get batchesEmpty => 'ഡേറ്റുള്ള ബാച്ചുകൾ ഇല്ല';

  @override
  String get stockTitle => 'സ്റ്റോക്ക്';

  @override
  String get stockSubtitle => 'മൂല്യം, അലേർട്ടുകൾ, എക്സ്പയറി';

  @override
  String get stockValuation => 'സ്റ്റോക്ക് മൂല്യം';

  @override
  String get stockProfit => 'ലാഭം (30 ദിവസം)';

  @override
  String get stockWastage => 'വേസ്റ്റേജ് (30 ദിവസം)';

  @override
  String get stockLowTitle => 'തീരാറായി';

  @override
  String get stockExpiryTitle => 'എക്സ്പയറി';

  @override
  String get stockNothingLow => 'ഒന്നും തീരാറായിട്ടില്ല';

  @override
  String get stockNoExpiry => 'ഡേറ്റുള്ള ബാച്ചുകൾ ഇല്ല';

  @override
  String get stockReorderNow => 'റീഓർഡർ ലിസ്റ്റ് അയക്കുക';

  @override
  String get suppliersTitle => 'സപ്ലയർമാർ';

  @override
  String get suppliersSubtitle => 'റീഓർഡർ കോൺടാക്റ്റുകൾ';

  @override
  String get suppliersEmpty => 'സപ്ലയർമാരില്ല';

  @override
  String get supplierAdd => 'സപ്ലയറെ ചേർക്കുക';

  @override
  String get supplierName => 'പേര്';

  @override
  String get supplierPhone => 'ഫോൺ';

  @override
  String get supplierNote => 'കുറിപ്പ്';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'സ്കാൻ';

  @override
  String get scanSubtitle => 'ബാർകോഡ് അല്ലെങ്കിൽ QR';

  @override
  String get scanUnsupported =>
      'ഇവിടെ ക്യാമറ സ്കാനിംഗ് ലഭ്യമല്ല. കോഡ് താഴെ ടൈപ്പ് ചെയ്യുക.';

  @override
  String get scanPermission => 'സ്കാൻ ചെയ്യാൻ ക്യാമറ അനുമതി നൽകുക';

  @override
  String get scanManualHint =>
      'കോഡ് ടൈപ്പ് ചെയ്യുക അല്ലെങ്കിൽ പേസ്റ്റ് ചെയ്യുക';

  @override
  String get scanCreateFromCode => 'ഈ കോഡിൽ പ്രൊഡക്റ്റ് ചേർക്കുക';

  @override
  String get labelsTitle => 'ലേബലുകൾ';

  @override
  String get labelsSubtitle => 'QR, ബാർകോഡ് ലേബലുകൾ പ്രിന്റ് ചെയ്യുക';

  @override
  String get labelsSelect => 'പ്രൊഡക്റ്റുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get labelsSize => 'ലേബൽ സൈസ്';

  @override
  String get labelsSymbology => 'സിംബൽ';

  @override
  String get labelsCopies => 'കോപ്പികൾ';

  @override
  String get labelsPrint => 'ഷീറ്റ് പ്രിന്റ് ചെയ്യുക';

  @override
  String get labelsThermal => 'പ്രിന്റർ കോഡ് കോപ്പി ചെയ്യുക';

  @override
  String get labelsCopied => 'പ്രിന്റർ കോഡ് കോപ്പി ചെയ്തു';

  @override
  String get labelsNone => 'ഒരു സാധനമെങ്കിലും തിരഞ്ഞെടുക്കുക';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'ബാർകോഡ്';

  @override
  String get paymentQrTitle => 'പേയ്‌മെന്റ് QR';

  @override
  String get paymentQrSubtitle => 'കസ്റ്റമേഴ്സിന് സ്കാൻ ചെയ്ത് പണം നൽകാം';

  @override
  String get paymentQrAmountHint => 'തുക (നിർബന്ധമില്ല)';

  @override
  String get paymentQrNeedVpa => 'ആദ്യം സെറ്റിംഗ്സിൽ നിങ്ങളുടെ UPI ID നൽകുക.';

  @override
  String get paymentQrOpenSettings => 'സെറ്റിംഗ്സ് തുറക്കുക';

  @override
  String get paymentQrPoster => 'പോസ്റ്റർ സേവ് ചെയ്യുക';

  @override
  String get paymentQrCopy => 'ലിങ്ക് കോപ്പി ചെയ്യുക';

  @override
  String get paymentQrCopied => 'ലിങ്ക് കോപ്പി ചെയ്തു';

  @override
  String get paymentQrNote =>
      'സ്കാൻ ചെയ്യുമ്പോൾ കസ്റ്റമറുടെ UPI ആപ്പ് തുറക്കും. സൗണ്ട് ബോക്സ് പറഞ്ഞാൽ മാത്രമേ പേയ്‌മെന്റ് വന്നതായി ഉറപ്പിക്കാവൂ.';

  @override
  String stockOnHand(String qty) {
    return 'സ്റ്റോക്ക്: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'മാർജിൻ $pct%';
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
      other: '$count ബാച്ചുകൾ ശ്രദ്ധിക്കുക',
      one: '1 ബാച്ച് ശ്രദ്ധിക്കുക',
      zero: 'ഉടൻ കാലാവധി തീരുന്നവയൊന്നുമില്ല',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty ബാക്കി · ഒന്നിന് $cost';
  }

  @override
  String sellShortfall(String qty) {
    return '$qty മാത്രമേ സ്റ്റോക്കിൽ ഉണ്ടായിരുന്നുള്ളൂ — അത്രയും രേഖപ്പെടുത്തി';
  }

  @override
  String productArchiveConfirm(String name) {
    return 'കാറ്റലോഗിൽ നിന്ന് $name ഒഴിവാക്കണോ?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: ദയവായി $items അയക്കുക';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return '$vpa-ലേക്ക് പണം നൽകുന്നു';
  }

  @override
  String scanUnknownCode(String code) {
    return '$code എന്ന കോഡിൽ പ്രൊഡക്റ്റുകളൊന്നുമില്ല';
  }

  @override
  String get profileTitle => 'ബിസിനസ് പ്രൊഫൈൽ';

  @override
  String get vendorCategory => 'ബിസിനസ് തരം';

  @override
  String get categoryCart => 'തള്ളുവണ്ടി';

  @override
  String get categoryStall => 'കട / സ്റ്റാൾ';

  @override
  String get categoryHotel => 'ഹോട്ടൽ / തട്ടുകട';

  @override
  String get categoryService => 'സർവീസ് വർക്ക്';

  @override
  String get nicheLabel =>
      'നിങ്ങൾ എന്താണ് വിൽക്കുന്നത് അല്ലെങ്കിൽ ചെയ്യുന്നത്?';

  @override
  String get districtLabel => 'ജില്ല';

  @override
  String get talukLabel => 'താലൂക്ക് / ടൗൺ';

  @override
  String get marketAreaLabel => 'മാർക്കറ്റ് / പ്രദേശം';

  @override
  String get fssaiLabel => 'FSSAI നമ്പർ (ഭക്ഷണ ബിസിനസ്)';

  @override
  String get udyamLabel => 'UDYAM രജിസ്ട്രേഷൻ (നിർബന്ധമില്ല)';

  @override
  String get workingHoursLabel => 'പ്രവർത്തന സമയം';

  @override
  String get perishableLabel => 'കേടാകുന്ന സാധനങ്ങൾ വിൽക്കുന്നു';

  @override
  String get profilePromptTitle => 'ബിസിനസ് പ്രൊഫൈൽ സെറ്റ് ചെയ്യുക';

  @override
  String get profilePromptBody =>
      'നിങ്ങൾ എന്തൊക്കെയാണ് വിൽക്കുന്നതെന്ന് നൽകൂ, ആവശ്യമായവ മാത്രം ആപ്പ് കാണിക്കും.';

  @override
  String get profilePromptAction => 'സെറ്റ് ചെയ്യുക';

  @override
  String get profileSaved => 'പ്രൊഫൈൽ സേവ് ചെയ്തു';

  @override
  String get expensesTitle => 'ചെലവുകൾ';

  @override
  String get expensesSubtitle => 'പാൽ, ഗ്യാസ്, പലഹാരം, വാടക — കടയിലെ ചെലവുകൾ';

  @override
  String get expenseToday => 'ഇന്നത്തെ ചെലവ്';

  @override
  String get expenseAdd => 'ചെലവ് ചേർക്കുക';

  @override
  String get expenseAmount => 'തുക';

  @override
  String get expenseNote => 'കുറിപ്പ് (ഓപ്ഷണൽ)';

  @override
  String get expenseTodayList => 'ഇന്നത്തെ ചെലവുകൾ';

  @override
  String get expenseEmpty => 'ഇന്ന് ചെലവുകളൊന്നും ചേർത്തിട്ടില്ല';

  @override
  String get expenseMilk => 'പാൽ';

  @override
  String get expenseGas => 'ഗ്യാസ്';

  @override
  String get expenseSnacks => 'പലഹാരങ്ങൾ';

  @override
  String get expenseProvisions => 'പലചരക്ക്';

  @override
  String get expenseWages => 'കൂലി';

  @override
  String get expenseRent => 'വാടക';

  @override
  String get expenseElectricity => 'കറന്റ് ബിൽ';

  @override
  String get expenseTransport => 'വണ്ടിക്കൂലി';

  @override
  String get expenseOther => 'മറ്റുള്ളവ';

  @override
  String get recurringTitle => 'ദിവസേനയുള്ള സപ്ലൈസ്';

  @override
  String get recurringAdd => 'സപ്ലൈ ചേർക്കുക';

  @override
  String get recurringName => 'സാധനത്തിന്റെ പേര്';

  @override
  String get recurringEmpty =>
      'പാലോ പലഹാരങ്ങളോ ഇവിടെ സേവ് ചെയ്യുക, ഒറ്റ ടാപ്പിൽ ചെലവ് രേഖപ്പെടുത്താം.';

  @override
  String get dayCloseTitle => 'ഡേ ക്ലോസ്';

  @override
  String get dayCloseExpectedCash => 'പെട്ടിയിൽ ഉണ്ടാകേണ്ട പണം';

  @override
  String get dayCloseBreakdown => 'ഇന്നത്തെ വരവ്-ചെലവ്';

  @override
  String get dayCloseCollected => 'കടം പിരിച്ചത്';

  @override
  String get dayCloseWastage => 'വേസ്റ്റേജ്';

  @override
  String get dayCloseProfit => 'ഇന്നത്തെ ലാഭം';

  @override
  String get dayCloseCount => 'പെട്ടിയിലെ പണം എണ്ണുക';

  @override
  String get dayCloseCountedCash => 'എണ്ണിയ പണം';

  @override
  String get dayCloseSave => 'ഡേ ക്ലോസ് ചെയ്യുക';

  @override
  String get dayCloseDiscounts => 'നൽകിയ ഡിസ്കൗണ്ട്';

  @override
  String get dayCloseTax => 'പിരിച്ച ടാക്സ്';

  @override
  String get dayCloseLastToken => 'അവസാന ടോക്കൺ';

  @override
  String get dayCloseVoided => 'ക്യാൻസൽ ചെയ്ത ബില്ലുകൾ';

  @override
  String get dayCloseExport => 'ഡേ PDF എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String get dayCloseVariancePosted => 'പണത്തിലെ വ്യത്യാസം കണക്കിൽ ചേർത്തു.';

  @override
  String get dayCloseExportFailed =>
      'ദിവസത്തെ കണക്ക് എക്സ്പോർട്ട് ചെയ്യാനായില്ല.';

  @override
  String get dayCloseMatch => 'പണം കൃത്യമാണ്.';

  @override
  String dayCloseSurplus(String amount) {
    return 'പ്രതീക്ഷിച്ചതിലും $amount കൂടുതൽ';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount കുറവ്';
  }

  @override
  String get insightsTitle => 'വിവരങ്ങൾ';

  @override
  String get insightsSubtitle => 'ദിവസം, ആഴ്ച, മാസം, വർഷം';

  @override
  String get windowDay => 'ദിവസം';

  @override
  String get windowWeek => 'ആഴ്ച';

  @override
  String get windowMonth => 'മാസം';

  @override
  String get windowYear => 'വർഷം';

  @override
  String get insightsTurnover => 'വിറ്റുവരവ്';

  @override
  String get insightsCosts => 'ചെലവ്';

  @override
  String get insightsProfit => 'ലാഭം';

  @override
  String get insightsAvgDay => 'പ്രതിദിനം';

  @override
  String get insightsByDay => 'ഓരോ ദിവസവും';

  @override
  String get insightsBestDay => 'ഏറ്റവും മികച്ച ദിവസം';

  @override
  String get insightsTopItems => 'കൂടുതൽ വിറ്റവ';

  @override
  String get insightsCostSplit => 'പണം പോയ വഴികൾ';

  @override
  String get insightsEmpty => 'ഈ കാലയളവിൽ ഒന്നും രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String get insightsMarginAlert => 'മാർജിൻ മുന്നറിയിപ്പ്';

  @override
  String get insightsMarginBody =>
      'ഈ ഇനങ്ങൾ വാങ്ങിയ വിലയ്ക്കടുത്ത് തന്നെയാണ് വിൽക്കുന്നത്. വില കൂട്ടുകയോ വാങ്ങൽ ചെലവ് കുറയ്ക്കുകയോ ചെയ്യുക.';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'ചെലവ് $cost · വില $price';
  }

  @override
  String get quickSaleTitle => 'ക്വിക്ക് സെയിൽ';

  @override
  String get quickSaleSubtitle =>
      'ഓരോന്നിനും ഒറ്റ ടാപ്പ് — കൂടുതൽ എണ്ണത്തിന് അമർത്തിപ്പിടിക്കുക';

  @override
  String get quickSaleQty => 'എണ്ണം';

  @override
  String quickSaleQtyTitle(String item) {
    return 'എത്ര $item വേണം?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount രേഖപ്പെടുത്തി';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return 'ഒരു $item $amount-ന് വിൽക്കുക';
  }

  @override
  String get quickSaleEmpty =>
      'ക്വിക്ക് മെനു ഉപയോഗിക്കാൻ വില സഹിതം സാധനങ്ങൾ ചേർക്കുക.';

  @override
  String get starterPackAction =>
      'എന്റെ കടയ്ക്കുള്ള സ്റ്റാർട്ടർ കിറ്റ് ചേർക്കുക';

  @override
  String get starterTea => 'ചായ';

  @override
  String get starterCoffee => 'കാപ്പി';

  @override
  String get starterBun => 'ബൺ';

  @override
  String get starterBiscuit => 'ബിസ്ക്കറ്റ്';

  @override
  String get starterBajji => 'ബജ്ജി';

  @override
  String get starterMilkSupply => 'പാൽ ക്യാനുകൾ';

  @override
  String get starterSnackSupply => 'പലഹാര ട്രേ';

  @override
  String get menuDailyWork => 'ദൈനംദിന കാര്യങ്ങൾ';

  @override
  String get stockOut => 'സ്റ്റോക്ക് തീർന്നു';

  @override
  String get ordersTitle => 'ഓർഡറുകൾ';

  @override
  String get ordersSubtitle => 'കൗണ്ടർ, QR ഓർഡറുകൾ, ലൈവ്';

  @override
  String get orderCounterNew => 'പുതിയ കൗണ്ടർ ഓർഡർ';

  @override
  String get orderTable => 'ടേബിൾ';

  @override
  String get orderRemoveItem => 'ഒന്ന് കുറയ്ക്കുക';

  @override
  String get orderAddItem => 'ഒന്ന് കൂട്ടുക';

  @override
  String get orderCancelReason => 'ക്യാൻസൽ ചെയ്യാനുള്ള കാരണം';

  @override
  String get orderCancel => 'ഓർഡർ ക്യാൻസൽ ചെയ്യുക';

  @override
  String get orderLive => 'ലൈവ്';

  @override
  String get orderHistory => 'ഹിസ്റ്ററി';

  @override
  String get orderEmpty => 'ഓർഡറുകളൊന്നും ഇല്ല.';

  @override
  String get orderNew => 'പുതിയത്';

  @override
  String get orderPreparing => 'തയ്യാറാക്കുന്നു';

  @override
  String get orderServed => 'നൽകി';

  @override
  String get orderPaid => 'പെയ്ഡ്';

  @override
  String get orderCancelled => 'ക്യാൻസൽ ചെയ്തു';

  @override
  String get orderAccept => 'സ്വീകരിക്കുക';

  @override
  String get orderServe => 'നൽകി';

  @override
  String get orderBulkAccept => 'എല്ലാം സ്വീകരിക്കുക';

  @override
  String get orderBulkServe => 'റെഡിയായവയെല്ലാം നൽകുക';

  @override
  String get orderBill => 'ബിൽ';

  @override
  String get orderTokenShort => 'ടോക്കൺ';

  @override
  String get kotTitle => 'കിച്ചൻ';

  @override
  String get kotSubtitle => 'അടുത്തതായി തയ്യാറാക്കേണ്ടവ';

  @override
  String get kotEmpty => 'കിച്ചൻ ക്യൂ ക്ലിയറാണ്.';

  @override
  String get kotDone => 'റെഡി';

  @override
  String get billTitle => 'ബിൽ';

  @override
  String get billNumberLabel => 'ബിൽ';

  @override
  String get billSubtotal => 'സബ്‌ടോട്ടൽ';

  @override
  String get billDiscount => 'ഡിസ്കൗണ്ട്';

  @override
  String get billDiscountFlat => 'ഡിസ്കൗണ്ട് തുക';

  @override
  String get billDiscountPct => 'ഡിസ്കൗണ്ട് %';

  @override
  String get billTax => 'GST';

  @override
  String get billTaxable => 'ടാക്സബിൾ';

  @override
  String get billCgst => 'CGST';

  @override
  String get billSgst => 'SGST';

  @override
  String get billIgst => 'IGST';

  @override
  String get shopGstRegistered => 'GST രജിസ്റ്റർ ചെയ്ത കട';

  @override
  String get shopGstRegisteredHint =>
      'ബില്ലുകളിൽ CGST/SGST വിവരങ്ങളും സാധനങ്ങളുടെ HSN കോഡും കാണിക്കും';

  @override
  String get shopPriceIncludesTax => 'വിലയിൽ ടാക്സ് ഉൾപ്പെട്ടിട്ടുണ്ട്';

  @override
  String get productTaxRate => 'GST നിരക്ക് %';

  @override
  String get productHsn => 'HSN / SAC കോഡ്';

  @override
  String get productTaxHint => 'ഒഴിവാക്കിയാൽ കടയിലെ സാധാരണ നിരക്ക് വരും';

  @override
  String get billRounding => 'റൗണ്ടിംഗ്';

  @override
  String get billTotal => 'ആകെ';

  @override
  String get billPaid => 'നൽകിയത്';

  @override
  String get billBalance => 'ബാക്കി';

  @override
  String get billReprint => 'വീണ്ടും പ്രിന്റ് ചെയ്യുക';

  @override
  String get billShare => 'ഷെയർ';

  @override
  String get billThanks => 'നന്ദി, വീണ്ടും വരിക';

  @override
  String get billCustomer => 'കസ്റ്റമർ';

  @override
  String get billSplit => 'പേയ്‌മെന്റ്';

  @override
  String get billRoundToRupee => 'രൂപയിലേക്ക് റൗണ്ട് ചെയ്യുക';

  @override
  String get billFillCash => 'ബാക്കി തുക ക്യാഷാക്കുക';

  @override
  String get billFullyPaid => 'പൂർണ്ണമായി നൽകി';

  @override
  String get billSettle => 'ബിൽ സെറ്റിൽ ചെയ്യുക';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get billPreview => 'പേപ്പർ പ്രിവ്യൂ';

  @override
  String get billVoid => 'ബിൽ റദ്ദാക്കുക';

  @override
  String get billVoidTitle => 'ഈ ബിൽ റദ്ദാക്കുക';

  @override
  String get billVoidHint =>
      'ബിൽ നമ്പർ കണക്കിൽ തന്നെ കാണും, വരവുചെലവ് എൻട്രികൾ പഴയപടിയാകും.';

  @override
  String get billVoidReason => 'കാരണം';

  @override
  String get billVoidReasonRequired => 'ബിൽ റദ്ദാക്കാൻ കാരണം പറയണം';

  @override
  String get billVoided => 'ബിൽ റദ്ദാക്കി';

  @override
  String get billVoidFailed => 'ഈ ബിൽ റദ്ദാക്കാനായില്ല';

  @override
  String get billAudit => 'ബിൽ ഹിസ്റ്ററി';

  @override
  String get menuTitle => 'QR മെനു';

  @override
  String get menuSubtitle => 'സ്കാൻ ചെയ്യുമ്പോൾ കസ്റ്റമർ കാണുന്നത്';

  @override
  String get menuShopSection => 'കട';

  @override
  String get menuSlug => 'ലിങ്കിലെ മെനു പേര്';

  @override
  String get menuBaseUrl => 'മെനു വെബ് വിലാസം';

  @override
  String get menuTableCount => 'ടേബിളുകൾ';

  @override
  String get menuTaxPercent => 'GST %';

  @override
  String get menuGstin => 'GSTIN';

  @override
  String get menuAcceptOrders => 'QR ഓർഡറുകൾ സ്വീകരിക്കുക';

  @override
  String get menuSaved => 'മെനു വിവരങ്ങൾ സേവ് ചെയ്തു';

  @override
  String get menuQrSheet => 'QR ഷീറ്റ് പ്രിന്റ് ചെയ്യുക';

  @override
  String get menuLinkSection => 'കടയുടെ QR';

  @override
  String get menuItemsSection => 'മെനുവിലെ ഐറ്റങ്ങൾ';

  @override
  String get menuSoldOut => 'തീർന്നു';

  @override
  String get menuPublished => 'മെനുവിലുണ്ട്';

  @override
  String get menuCounterQr => 'കൗണ്ടർ';

  @override
  String get menuScanHint => 'മെനു കണ്ട് ഓർഡർ ചെയ്യാൻ സ്കാൻ ചെയ്യുക';

  @override
  String get printersTitle => 'റസീപ്റ്റ് പ്രിന്റർ';

  @override
  String get printersSubtitle => 'പേപ്പർ സൈസ്, കണക്ഷൻ, ടെസ്റ്റ് പ്രിന്റ്';

  @override
  String get printerWidth => 'പേപ്പർ വീതി';

  @override
  String get printerTransport => 'കണക്ഷൻ';

  @override
  String get printerPdf => 'PDF / ഷെയർ';

  @override
  String get printerBluetooth => 'Bluetooth';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'പ്രിന്ററിന്റെ പേര്';

  @override
  String get printerDeviceAddress => 'പ്രിന്റർ വിലാസം';

  @override
  String get printerFallbackNote =>
      'ഈ ഡിവൈസിലേക്ക് നേരിട്ട് പ്രിന്റ് ചെയ്യാൻ ഇപ്പോൾ സാധ്യമല്ല, അതിനാൽ ബിൽ PDF ആയി തുറക്കും. ഇത് പ്രിന്റ് ചെയ്യുകയോ ഷെയർ ചെയ്യുകയോ ചെയ്യാം.';

  @override
  String get printerAutoPrint => 'ബിൽ ഓട്ടോമാറ്റിക്കായി പ്രിന്റ് ചെയ്യുക';

  @override
  String get printerKot => 'കിച്ചൻ ടിക്കറ്റ് പ്രിന്റ് ചെയ്യുക';

  @override
  String get printerTest => 'ടെസ്റ്റ് പ്രിന്റ്';

  @override
  String get printerTestSent => 'ടെസ്റ്റ് റസീപ്റ്റ് അയച്ചു';

  @override
  String get printerPaired => 'പെയർ ചെയ്ത പ്രിന്ററുകൾ';

  @override
  String get printerScan => 'പെയർ ചെയ്ത പ്രിന്ററുകൾ കണ്ടെത്തുക';

  @override
  String get printerScanning => 'തിരയുന്നു…';

  @override
  String get printerNoDevices =>
      'പെയർ ചെയ്ത പ്രിന്ററുകളൊന്നും കണ്ടില്ല. ആദ്യം Android Bluetooth സെറ്റിങ്സിൽ പെയർ ചെയ്യുക.';

  @override
  String get printerConnect => 'കണക്റ്റ് ചെയ്യുക';

  @override
  String get printerConnected => 'പ്രിന്റർ കണക്റ്റായി';

  @override
  String get printerConnectFailed =>
      'കണക്റ്റ് ചെയ്യാനായില്ല. പ്രിന്റർ ഓൺ ചെയ്ത് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get printerBluetoothNote =>
      'ബില്ലുകൾ നേരിട്ട് ഈ Bluetooth പ്രിന്ററിൽ പ്രിന്റാകും. പ്രിന്റർ ഓഫാണെങ്കിലോ റേഞ്ച് ഇല്ലെങ്കിലോ ബിൽ നഷ്ടപ്പെടാതിരിക്കാൻ PDF ആയി തുറക്കും.';

  @override
  String orderToken(int token) {
    return 'ടോക്കൺ $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes മിനിറ്റ്';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഇനങ്ങൾ',
      one: '1 ഇനം',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'ബിൽ $number സെറ്റിൽ ചെയ്തു';
  }

  @override
  String get dayCloseOrders => 'ഇന്നത്തെ ഓർഡറുകൾ';

  @override
  String get dayCloseOrdersTaken => 'എടുത്ത ഓർഡറുകൾ';

  @override
  String get dayCloseOrdersCancelled => 'ക്യാൻസൽ ചെയ്തവ';

  @override
  String get dayCloseOrdersOpen => 'പൂർത്തിയാകാത്തവ';

  @override
  String get dayCloseOrdersBilled => 'ബിൽ ചെയ്തവ';

  @override
  String get dayCloseAvgTicket => 'ശരാശരി ബിൽ തുക';

  @override
  String get menuCloudSection => 'ക്ലൗഡ് ബോർഡ്';

  @override
  String get menuShopKey => 'ഷോപ്പ് കീ (16+ അക്ഷരങ്ങൾ)';

  @override
  String get menuCloudSync => 'ഓർഡറുകൾ ക്ലൗഡുമായി സിങ്ക് ചെയ്യുക';

  @override
  String get menuCloudPublish => 'മെനു ക്ലൗഡിലേക്ക് പബ്ലിഷ് ചെയ്യുക';

  @override
  String menuCloudPublished(int count) {
    return 'ക്ലൗഡ് മെനുവിലേക്ക് $count ഇനങ്ങൾ പബ്ലിഷ് ചെയ്തു';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'ക്ലൗഡ് തകരാർ: $reason';
  }

  @override
  String get menuCloudLive => 'ലൈവ്: QR ഓർഡറുകൾ തനിയെ ബോർഡിൽ എത്തും.';

  @override
  String get menuCloudOffline =>
      'ലോക്കൽ മാത്രം. QR ഓർഡറുകൾ ലഭിക്കാൻ ഷോപ്പ് കീ നൽകി സിങ്ക് ഓണാക്കുക.';

  @override
  String get settleTitle => 'കടം തീർക്കുക';

  @override
  String get settleAmountSection => 'തീർപ്പാക്കൽ';

  @override
  String get settleAmount => 'തുക';

  @override
  String get settleCash => 'ക്യാഷ്';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'പുതിയ കടം';

  @override
  String get settleNote => 'കുറിപ്പ്';

  @override
  String get settleCashHint =>
      'ക്യാഷ് കിട്ടിയാൽ ബാക്കി തുക തീർന്ന് ഇന്നത്തെ ക്യാഷ് കണക്കിലേക്ക് ചേരും.';

  @override
  String get settleUpiHint =>
      'UPI വഴി വാങ്ങിയ ശേഷം സ്ഥിരീകരിക്കുക. ബാക്കി തുക തീർന്ന് ഇന്നത്തെ UPI കണക്കിൽ കൂടും.';

  @override
  String get settleLoanHint =>
      'പഴയ കടം തീർത്ത് അതേ തുക പുതിയ കടമായി മാറ്റുന്നു.';

  @override
  String get settleConfirm => 'തീർപ്പാക്കുക';

  @override
  String get settleDone => 'കണക്ക് രേഖപ്പെടുത്തി';

  @override
  String get settleHistory => 'സമീപകാല ഇടപാടുകൾ';

  @override
  String settleTooMuch(String amount) {
    return 'ബാക്കിയുള്ള ₹$amount-നേക്കാൾ കൂടുതൽ';
  }

  @override
  String settleLedgerItem(String name) {
    return 'കടം വീട്ടി — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'പുതിയ കടത്തിലേക്ക് മാറ്റി — $name';
  }

  @override
  String get menuAddress => 'കടയുടെ വിലാസം';

  @override
  String get menuPhone => 'ഫോൺ നമ്പർ';

  @override
  String get menuFssai => 'FSSAI ലൈസൻസ്';

  @override
  String get menuGrowSection => 'ബിസിനസ്സ് വളർത്താം';

  @override
  String get recipesTitle => 'റെസിപ്പി ബുക്ക്';

  @override
  String get recipesSubtitle => 'നിങ്ങളുടെ അളവുകൾ, ഒരിക്കൽ കുറിച്ചുവെക്കാം';

  @override
  String get recipeAdd => 'വിഭവം ചേർക്കുക';

  @override
  String get recipeName => 'വിഭവത്തിന്റെ പേര്';

  @override
  String get recipeServings => 'എണ്ണം (പ്ലേറ്റ്)';

  @override
  String get recipeEmpty => 'വിഭവങ്ങളൊന്നും ചേർത്തിട്ടില്ല.';

  @override
  String get recipeIngredients => 'ചേരുവകൾ';

  @override
  String get recipeSteps => 'ഉണ്ടാക്കുന്ന വിധം';

  @override
  String get recipeAddIngredient => 'സാധനം ചേർക്കുക';

  @override
  String get recipeAddStep => 'സ്റ്റെപ്പ് ചേർക്കുക';

  @override
  String get recipeQty => 'അളവ്';

  @override
  String get recipeLinkProduct => 'സ്റ്റോക്കിൽ നിന്ന് എടുക്കുക';

  @override
  String get recipeNoLink => 'സ്റ്റോക്കിൽ നിന്നല്ല';

  @override
  String get recipeCost => 'സാധനങ്ങളുടെ ചെലവ്';

  @override
  String get recipePerServing => 'ഒരു പ്ലേറ്റിന്റെ ചെലവ്';

  @override
  String get recipeScale => 'ഇത്ര പേർക്ക് ഉണ്ടാക്കുക';

  @override
  String get recipeCookBatch => 'സ്റ്റോക്കിൽ നിന്ന് സാധനങ്ങൾ കുറയ്ക്കുക';

  @override
  String get recipeCooked => 'സ്റ്റോക്കിൽ നിന്ന് സാധനങ്ങൾ എടുത്തു';

  @override
  String get recipeStepsEmpty => 'ഘട്ടങ്ങളൊന്നും ചേർത്തിട്ടില്ല.';

  @override
  String get recipeUnlinkedWarning =>
      'സ്റ്റോക്കുമായി ബന്ധിപ്പിക്കാത്ത സാധനങ്ങൾ ചിലവിൽ കൂട്ടിയിട്ടില്ല.';

  @override
  String get jobsTitle => 'കസ്റ്റം ഓർഡറുകൾ';

  @override
  String get jobsSubtitle => 'അഡ്വാൻസ് ബുക്കിംഗുകളും ഓർഡർ വർക്കുകളും';

  @override
  String get jobAdd => 'ഓർഡർ എടുക്കൂ';

  @override
  String get jobTitleField => 'എന്താണ് ഉണ്ടാക്കുന്നത്';

  @override
  String get jobCustomer => 'കസ്റ്റമർ';

  @override
  String get jobPhone => 'ഫോൺ';

  @override
  String get jobPrice => 'വില';

  @override
  String get jobAdvance => 'വാങ്ങിയ അഡ്വാൻസ്';

  @override
  String get jobDue => 'കൊടുക്കേണ്ട തിയതി';

  @override
  String get jobEmpty => 'ഓർഡറുകളൊന്നുമില്ല.';

  @override
  String get jobStatusTaken => 'എടുത്തു';

  @override
  String get jobStatusMaking => 'ഉണ്ടാക്കുന്നു';

  @override
  String get jobStatusReady => 'റെഡി';

  @override
  String get jobStatusDelivered => 'കൊടുത്തു';

  @override
  String get jobStatusCancelled => 'റദ്ദാക്കി';

  @override
  String get jobAdvanceStatus => 'അടുത്തതിലേക്ക്';

  @override
  String get jobCancel => 'റദ്ദാക്കുക';

  @override
  String get jobRemind => 'WhatsApp-ൽ മെസ്സേജ് അയക്കുക';

  @override
  String get jobFilterOpen => 'ഓപ്പൺ';

  @override
  String get jobFilterToday => 'ഇന്ന് കൊടുക്കേണ്ടത്';

  @override
  String get jobFilterDone => 'കഴിഞ്ഞത്';

  @override
  String get customersTitle => 'സ്ഥിരം കസ്റ്റമേഴ്സ്';

  @override
  String get customersSubtitle =>
      'വീണ്ടും വരുന്നവരും, അവർ നിങ്ങളെ കണ്ടെത്തിയ വഴിയും';

  @override
  String get customerAdd => 'കസ്റ്റമറെ ചേർക്കൂ';

  @override
  String get customerName => 'പേര്';

  @override
  String get customerPhone => 'ഫോൺ';

  @override
  String get sourceWalkIn => 'നേരിട്ട് വന്നത്';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'സുഹൃത്ത് വഴി';

  @override
  String get sourceOther => 'മറ്റുള്ളവ';

  @override
  String get customerRecordVisit => 'സന്ദർശനം ചേർക്കൂ';

  @override
  String get customerVisitAmount => 'തുക';

  @override
  String get customerRewardDue => 'ഫ്രീ ഐറ്റം ബാക്കിയുണ്ട്';

  @override
  String get customerGiveReward => 'ഫ്രീ ഐറ്റം നൽകൂ';

  @override
  String get customersEmpty => 'സ്ഥിരം കസ്റ്റമർമാരെ ചേർത്തിട്ടില്ല.';

  @override
  String get customerSourceSplit => 'പണം എവിടെ നിന്നാണ് വരുന്നത്';

  @override
  String get eventsTitle => 'ഇവന്റുകളും എക്സിബിഷനുകളും';

  @override
  String get eventsSubtitle => 'സ്റ്റാൾ ലാഭമായിരുന്നോ?';

  @override
  String get eventAdd => 'ഇവന്റ് ചേർക്കുക';

  @override
  String get eventName => 'ഇവന്റിന്റെ പേര്';

  @override
  String get eventPlace => 'സ്ഥലം';

  @override
  String get eventDay => 'തീയതി';

  @override
  String get eventRent => 'സ്റ്റാൾ വാടക';

  @override
  String get eventTravel => 'യാത്രാച്ചെലവ്';

  @override
  String get eventOther => 'മറ്റു ചെലവുകൾ';

  @override
  String get eventSales => 'വിൽപ്പന';

  @override
  String get eventFootfall => 'സന്ദർശകർ';

  @override
  String get eventProfit => 'ലാഭം';

  @override
  String get eventLoss => 'നഷ്ടം';

  @override
  String get eventPerVisitor => 'ഒരാൾക്ക്';

  @override
  String get eventsEmpty => 'ഇവന്റുകളൊന്നും ചേർത്തിട്ടില്ല.';

  @override
  String get staffTitle => 'ജോലിക്കാർ';

  @override
  String get staffSubtitle => 'ഹാജർ, അഡ്വാൻസ്, ശമ്പളം';

  @override
  String get staffAdd => 'ജോലിക്കാരനെ ചേർക്കുക';

  @override
  String get staffName => 'പേര്';

  @override
  String get staffPhone => 'ഫോൺ';

  @override
  String get staffRole => 'ജോലി';

  @override
  String get staffWage => 'ദിവസക്കൂലി';

  @override
  String get staffPresent => 'ഹാജർ';

  @override
  String get staffHalf => 'ഹാഫ് ഡേ';

  @override
  String get staffAbsent => 'അവധി';

  @override
  String get staffAdvance => 'അഡ്വാൻസ്';

  @override
  String get staffAdvanceAdd => 'അഡ്വാൻസ് നൽകുക';

  @override
  String get staffPayable => 'ഈ മാസം നൽകാനുള്ള ശമ്പളം';

  @override
  String get staffEmpty => 'ജോലിക്കാരെ ചേർത്തിട്ടില്ല.';

  @override
  String get staffRemove => 'ഒഴിവാക്കുക';

  @override
  String get growthTitle => 'ഗ്രോത്ത് കിറ്റ്';

  @override
  String get growthSubtitle => 'കൂടുതൽ കസ്റ്റമേഴ്സിനെ എത്തിക്കുക';

  @override
  String get growthMenuLink => 'മെനു ലിങ്ക്';

  @override
  String get growthShareMenu => 'മെനു അയക്കുക';

  @override
  String get growthAskReview => 'റിവ്യൂ ചോദിക്കുക';

  @override
  String get growthOpenMaps => 'മാപ്സ് തുറക്കുക';

  @override
  String get growthWhatsappBroadcast => 'WhatsApp-ൽ അറിയിക്കുക';

  @override
  String get growthLinksSection => 'നിങ്ങളുടെ ലിങ്കുകൾ';

  @override
  String get growthMapsUrl => 'Google Maps ലിങ്ക്';

  @override
  String get growthReviewUrl => 'റിവ്യൂ ലിങ്ക്';

  @override
  String get growthInstagram => 'Instagram പേര്';

  @override
  String get growthLoyalty => 'എത്ര തവണ വന്നാൽ ഒരെണ്ണം ഫ്രീ';

  @override
  String get growthIdeas => 'ഈ ആഴ്ചയിലെ പോസ്റ്റ് ഐഡിയകൾ';

  @override
  String get growthShareIdea => 'അയക്കൂ';

  @override
  String get growthIdea1 => 'രാവിലെ ആദ്യത്തെ ബാച്ച് ഉണ്ടാക്കുന്ന ചെറിയ വീഡിയോ.';

  @override
  String get growthIdea2 =>
      'ഇന്നത്തെ സ്പെഷ്യലും വിലയും വ്യക്തമായി കാണിക്കുന്നത്.';

  @override
  String get growthIdea3 => 'പതിവ് കസ്റ്റമർ അവരുടെ ഓർഡറുമായി നിൽക്കുന്നത്.';

  @override
  String get growthIdea4 => 'കൗണ്ടറിന് പിന്നിൽ: കട തുറക്കുമ്പോഴുള്ള കാഴ്ച.';

  @override
  String get growthIdea5 => 'രണ്ട് ദിവസത്തേക്ക് മാത്രമുള്ള വാരാന്ത്യ ഓഫർ.';

  @override
  String get growthSaved => 'സേവ് ചെയ്തു';

  @override
  String get checklistTitle => 'തുറക്കുമ്പോഴും അടയ്ക്കുമ്പോഴും';

  @override
  String get checklistSubtitle => 'മറന്നുപോയാൽ പണി കിട്ടുന്ന ചെറിയ കാര്യങ്ങൾ';

  @override
  String get checklistOpening => 'തുറക്കുന്നതിന് മുൻപ്';

  @override
  String get checklistClosing => 'അടയ്ക്കുന്നതിന് മുൻപ്';

  @override
  String get checklistAdd => 'ലിസ്റ്റിൽ ചേർക്കൂ';

  @override
  String get checklistItem => 'എന്താണ് നോക്കേണ്ടത്';

  @override
  String get checklistEmpty => 'ലിസ്റ്റിൽ ഒന്നും ചേർത്തിട്ടില്ല.';

  @override
  String get checklistUseStarter => 'റെഡിമെയ്ഡ് ലിസ്റ്റ് ഉപയോഗിക്കുക';

  @override
  String get checklistSeed1 => 'ചില്ലറ എടുത്തു വെച്ചു';

  @override
  String get checklistSeed2 => 'ഗ്യാസും പാലും പരിശോധിച്ചു';

  @override
  String get checklistSeed3 => 'QR സ്റ്റാൻഡും വിലവിവരപ്പട്ടികയും പുറത്തുവെച്ചു';

  @override
  String get checklistSeed4 => 'പണം എണ്ണി എഴുതിവെച്ചു';

  @override
  String get checklistSeed5 => 'ഫ്രിഡ്ജ്, ഗ്യാസ്, ലൈറ്റുകൾ ഓഫ് ചെയ്തു';

  @override
  String jobRemindMessage(String name, String title) {
    return 'നമസ്കാരം $name, നിങ്ങളുടെ ഓർഡറായ \"$title\" റെഡിയായിട്ടുണ്ട്.';
  }

  @override
  String customerVisits(String count) {
    return '$count തവണ വന്നു';
  }

  @override
  String customerToReward(String count) {
    return 'ഇനി $count തവണ കൂടി';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return '$name ഇഷ്ടമായോ? ഒരു റിവ്യൂ തരൂ: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — ഇന്നത്തെ മെനു: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$total-ൽ $done കഴിഞ്ഞു';
  }

  @override
  String get movementPrepared => 'തയ്യാറാക്കൽ';

  @override
  String recipeShortStock(String item) {
    return 'സ്റ്റോക്കിൽ ആവശ്യത്തിന് $item ഇല്ല';
  }

  @override
  String get starterIdli => 'ഇഡ്ഡലി';

  @override
  String get starterDosa => 'ദോശ';

  @override
  String get starterMeals => 'ഊണ്';

  @override
  String get starterSnackPacket => 'സ്നാക്സ് പാക്കറ്റ്';

  @override
  String get starterWaterBottle => 'വെള്ളക്കുപ്പി';

  @override
  String get starterVegSupply => 'പച്ചക്കറികൾ';

  @override
  String get starterGasSupply => 'ഗ്യാസ് സിലിണ്ടർ';

  @override
  String get checklistSeedHotel =>
      'മാവ്, പച്ചക്കറികൾ, ഗ്യാസ് എന്നിവ റെഡിയാക്കി';

  @override
  String get checklistSeedCart => 'വണ്ടി വൃത്തിയാക്കി സാധനങ്ങൾ കയറ്റി';

  @override
  String get checklistSeedService => 'സാധനങ്ങളും ചില്ലറയും റെഡി';

  @override
  String get presetRecipeTea => 'ചായ (10 ഗ്ലാസ്)';

  @override
  String get presetIngredientMilk => 'പാൽ';

  @override
  String get presetIngredientWater => 'വെള്ളം';

  @override
  String get presetIngredientTeaPowder => 'ചായപ്പൊടി';

  @override
  String get presetIngredientSugar => 'പഞ്ചസാര';

  @override
  String get rolesTitle => 'റോളുകൾ';

  @override
  String get rolesSubtitle => 'ആർക്കൊക്കെ എന്തൊക്കെ ചെയ്യാം';

  @override
  String get rolesHint =>
      'ഓരോ സഹായിക്കും റോൾ ഉണ്ടാക്കി, അവർ ചെയ്യേണ്ട കാര്യങ്ങൾ മാത്രം ടിക്ക് ചെയ്യുക.';

  @override
  String get rolesEmpty => 'റോളുകൾ ഒന്നും ചേർത്തിട്ടില്ല';

  @override
  String get rolesOpen => 'തുറന്ന റോളുകൾ';

  @override
  String get roleNew => 'പുതിയ റോൾ';

  @override
  String get roleSuggestionsTitle => 'കടയ്ക്ക് അനുയോജ്യമായവ';

  @override
  String get roleSuggestionsHint =>
      'കടകൾക്കായുള്ള റെഡിമെയ്ഡ് റോളുകൾ. ഒരെണ്ണം തിരഞ്ഞെടുത്ത് ആവശ്യമെങ്കിൽ മാറ്റം വരുത്താം.';

  @override
  String get tmplWaiter => 'വെയിറ്റർ';

  @override
  String get tmplKitchen => 'അടുക്കള / ഷെഫ്';

  @override
  String get tmplCashier => 'ക്യാഷ്യർ';

  @override
  String get tmplCounter => 'കൗണ്ടർ';

  @override
  String get tmplSalesHelper => 'സെയിൽസ് സഹായി';

  @override
  String get tmplStockKeeper => 'സ്റ്റോക്ക് കീപ്പർ';

  @override
  String get tmplJobAssistant => 'ജോബ് അസിസ്റ്റന്റ്';

  @override
  String get tmplCounterHelper => 'കൗണ്ടർ സഹായി';

  @override
  String get tmplAssistant => 'അസിസ്റ്റന്റ്';

  @override
  String get roleOwner => 'ഓണർ';

  @override
  String get roleOwnerNote => 'എപ്പോഴും ഫുൾ ആക്സസ്';

  @override
  String get roleInactive => 'ഉപയോഗത്തിലില്ല';

  @override
  String rolePermissionCount(String count) {
    return '$count എണ്ണം അനുവദിച്ചു';
  }

  @override
  String get roleEditSubtitle => 'പേര്, ചുമതലകൾ, പരിധികൾ';

  @override
  String get roleName => 'റോളിന്റെ പേര്';

  @override
  String get roleNote => 'ചുമതല';

  @override
  String get roleLimits => 'പണത്തിന്റെ പരിധി (Rs, 0 = പരിധിയില്ല)';

  @override
  String get roleMaxDiscount => 'നൽകാവുന്ന പരമാവധി ഡിസ്കൗണ്ട്';

  @override
  String get roleMaxCredit => 'നൽകാവുന്ന പരമാവധി കടം';

  @override
  String get roleMaxRefund => 'നൽകാവുന്ന പരമാവധി റീഫണ്ട്';

  @override
  String get roleLimitHint => 'ഈ തുകയ്ക്ക് മുകളിലാണെങ്കിൽ ഓണറുടെ PIN വേണം.';

  @override
  String get roleDuplicate => 'റോൾ കോപ്പി ചെയ്യുക';

  @override
  String get roleDeactivate => 'ഉപയോഗം നിർത്തുക';

  @override
  String get areaSales => 'സെയിൽസ്';

  @override
  String get areaOrders => 'ഓർഡറുകളും അടുക്കളയും';

  @override
  String get areaBilling => 'ബില്ലുകൾ';

  @override
  String get areaCredit => 'കടം';

  @override
  String get areaStock => 'സ്റ്റോക്ക്';

  @override
  String get areaPurchases => 'വാങ്ങലും ചെലവുകളും';

  @override
  String get areaMoney => 'പണവും റിപ്പോർട്ടുകളും';

  @override
  String get areaCustomers => 'കസ്റ്റമേഴ്സ്';

  @override
  String get areaStaff => 'സഹായികൾ';

  @override
  String get areaSettings => 'സെറ്റിംഗ്സ്';

  @override
  String get permRecordSale => 'വിൽപ്പന രേഖപ്പെടുത്തുക';

  @override
  String get permQuickSale => 'ക്വിക്ക് സെയിൽ ഉപയോഗിക്കുക';

  @override
  String get permCollectUpi => 'പേയ്‌മെന്റ് QR കാണിക്കുക';

  @override
  String get permTakeOrder => 'ഓർഡർ എടുക്കുക';

  @override
  String get permChangeOrderStatus => 'ഓർഡർ സ്റ്റാറ്റസ് മാറ്റുക';

  @override
  String get permViewKitchen => 'കിച്ചൻ ലിസ്റ്റ് കാണുക';

  @override
  String get permEditMenu => 'മെനു മാറ്റുക';

  @override
  String get permMakeBill => 'ബിൽ അടിക്കുക';

  @override
  String get permGiveDiscount => 'ഡിസ്കൗണ്ട് നൽകുക';

  @override
  String get permVoidBill => 'ബിൽ ക്യാൻസൽ ചെയ്യുക';

  @override
  String get permReprintBill => 'ബിൽ വീണ്ടും പ്രിന്റ് ചെയ്യുക';

  @override
  String get permGiveCredit => 'കടം നൽകുക';

  @override
  String get permSettleCredit => 'കടം തീർക്കുക';

  @override
  String get permViewCredit => 'കടം ബാക്കി കാണുക';

  @override
  String get permViewStock => 'സ്റ്റോക്ക് കാണുക';

  @override
  String get permAdjustStock => 'സ്റ്റോക്ക് തിരുത്തുക';

  @override
  String get permEditProducts => 'സാധനങ്ങൾ ചേർക്കുകയോ മാറ്റുകയോ ചെയ്യുക';

  @override
  String get permChangePrice => 'വില മാറ്റുക';

  @override
  String get permCookRecipe => 'റെസിപ്പി ഉണ്ടാക്കുക';

  @override
  String get permRecordExpense => 'ചെലവ് രേഖപ്പെടുത്തുക';

  @override
  String get permManageSuppliers => 'സപ്ലയർമാരെ മാനേജ് ചെയ്യുക';

  @override
  String get permViewDayTotals => 'ദിവസത്തെ ആകെത്തുക കാണുക';

  @override
  String get permViewProfit => 'ലാഭം കാണുക';

  @override
  String get permCloseDay => 'ദിവസ കണക്ക് ക്ലോസ് ചെയ്യുക';

  @override
  String get permViewReports => 'റിപ്പോർട്ടുകൾ കാണുക';

  @override
  String get permViewCustomers => 'കസ്റ്റമേഴ്സിനെ കാണുക';

  @override
  String get permEditCustomers => 'കസ്റ്റമർ വിവരങ്ങൾ മാറ്റുക';

  @override
  String get permManageStaff => 'സഹായികളെ മാനേജ് ചെയ്യുക';

  @override
  String get permMarkAttendance => 'ഹാജർ രേഖപ്പെടുത്തുക';

  @override
  String get permPayWages => 'ശമ്പളം നൽകുക';

  @override
  String get permManageRoles => 'റോളുകൾ ഉണ്ടാക്കുക';

  @override
  String get permViewAudit => 'പ്രവർത്തന ഹിസ്റ്ററി കാണുക';

  @override
  String get permEditSettings => 'സെറ്റിംഗ്സ് മാറ്റുക';

  @override
  String get permEditShop => 'കടയുടെ വിവരങ്ങൾ മാറ്റുക';

  @override
  String get permManagePrinters => 'പ്രിന്ററുകൾ സെറ്റ് ചെയ്യുക';

  @override
  String get accessTitle => 'ആക്സസ് കൺട്രോൾ';

  @override
  String get accessSubtitle => 'ഫോൺ ഒന്ന്, ആളുകൾ പലത്';

  @override
  String get accessEnable => 'PIN ചോദിക്കുക';

  @override
  String get accessEnableHint =>
      'ഫോൺ ഉപയോഗിക്കുന്നതിന് മുൻപ് സഹായികൾ ലോഗിൻ ചെയ്യണം.';

  @override
  String get accessNeedsOwnerPin => 'ആദ്യം ഓണർ PIN സെറ്റ് ചെയ്യുക';

  @override
  String get accessOwnerPin => 'ഓണർ PIN';

  @override
  String get accessOwnerPinSet => 'ഓണർ PIN സെറ്റ് ചെയ്യുക (4-6 അക്കങ്ങൾ)';

  @override
  String get accessOwnerPinChange => 'ഓണർ PIN മാറ്റുക (4-6 അക്കങ്ങൾ)';

  @override
  String get accessPinSaved => 'PIN സേവ് ചെയ്തു';

  @override
  String get accessPinInvalid => '4 മുതൽ 6 അക്കങ്ങൾ നൽകുക';

  @override
  String get accessAutoLock => 'ഓട്ടോ ലോക്ക്';

  @override
  String get accessIdleMinutes => 'ലോക്കാവേണ്ട സമയം (മിനിറ്റ്, 0 = വേണ്ട)';

  @override
  String get accessWorkers => 'സഹായികൾ';

  @override
  String get accessNoWorkers => 'ആദ്യം സഹായികളെ ചേർക്കുക';

  @override
  String get accessNoRole => 'ചുമതല നൽകിയിട്ടില്ല';

  @override
  String get accessPinSet => 'PIN സെറ്റ് ചെയ്തു';

  @override
  String get accessPinMissing => 'PIN ഇല്ല';

  @override
  String get accessAssignTitle => 'റോളും PIN-ഉം';

  @override
  String get accessWorkerPin => 'പുതിയ PIN (4-6 അക്കങ്ങൾ)';

  @override
  String get accessSaved => 'സേവ് ചെയ്തു';

  @override
  String get accessEndShift => 'ഷിഫ്റ്റ് അവസാനിപ്പിക്കുക';

  @override
  String get accessWrongPin => 'തെറ്റായ PIN';

  @override
  String get lockTitle => 'കൗണ്ടറിൽ ആരാണ്?';

  @override
  String get lockSubtitle => 'പേര് തിരഞ്ഞെടുത്ത് PIN അടിക്കുക';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'ഷിഫ്റ്റ് തുടങ്ങുക';

  @override
  String get auditTitle => 'ആക്ടിവിറ്റി ഹിസ്റ്ററി';

  @override
  String get auditSubtitle => 'ആര് എന്ത് ചെയ്തു';

  @override
  String get auditOpen => 'ആക്ടിവിറ്റി ഹിസ്റ്ററി കാണുക';

  @override
  String get auditEveryone => 'എല്ലാവരും';

  @override
  String get auditEmpty => 'ഇതുവരെ വിവരങ്ങളൊന്നുമില്ല';

  @override
  String get auditApproved => 'ഓണർ അംഗീകരിച്ചു';

  @override
  String get settingsGroupBusiness => 'ബിസിനസ്';

  @override
  String get settingsGroupMoney => 'പണം';

  @override
  String get settingsGroupApp => 'ആപ്പും ഉപകരണങ്ങളും';

  @override
  String get settingsShopTitle => 'കടയുടെ വിവരങ്ങൾ';

  @override
  String get settingsPaymentsTitle => 'പേയ്‌മെന്റും UPI-യും';

  @override
  String get settingsMarketTitle => 'മാർക്കറ്റ് നിരക്കുകൾ';

  @override
  String get settingsNotSet => 'സെറ്റ് ചെയ്തിട്ടില്ല';

  @override
  String get settingsOn => 'ഓൺ';

  @override
  String get settingsOff => 'ഓഫ്';

  @override
  String get settingsSaved => 'സെറ്റിംഗ്സ് സേവ് ചെയ്തു';

  @override
  String get dashboardTitle => 'ഡാഷ്‌ബോർഡ്';

  @override
  String get dashboardSubtitle =>
      'ഓർഡറുകൾ, പണം, കടം, സ്റ്റോക്ക് ഒറ്റനോട്ടത്തിൽ';

  @override
  String get dashboardOrders => 'ഓർഡറുകൾ';

  @override
  String get dashboardPayments => 'കിട്ടാനുള്ള പണം';

  @override
  String get dashboardCredit => 'കടം ബാക്കി';

  @override
  String get dashboardInventory => 'സ്റ്റോക്ക്';

  @override
  String get dashboardShare => 'ഷെയർ';

  @override
  String get dashboardPlaced => 'ലഭിച്ചവ';

  @override
  String get dashboardServed => 'നൽകിയവ';

  @override
  String get dashboardCancelled => 'റദ്ദാക്കിയവ';

  @override
  String get dashboardOpenOrders => 'ഓപ്പൺ ഓർഡറുകൾ';

  @override
  String get dashboardBilled => 'ബിൽ ചെയ്തവ';

  @override
  String get dashboardAvgBill => 'ശരാശരി ബിൽ';

  @override
  String get dashboardCollected => 'ലഭിച്ചത്';

  @override
  String get dashboardUnbilled => 'ബിൽ ചെയ്യാത്തവ';

  @override
  String get dashboardPendingTotal => 'ഇനി കിട്ടാനുള്ളത്';

  @override
  String get dashboardOutstanding => 'കിട്ടാനുള്ള ബാക്കി';

  @override
  String get dashboardCreditGiven => 'നൽകിയ കടം';

  @override
  String get dashboardCustomers => 'കസ്റ്റമർമാർ';

  @override
  String get dashboardOldest => 'പഴയ കുടിശ്ശിക';

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
  String get dashboardStockValue => 'സ്റ്റോക്ക് മൂല്യം';

  @override
  String get dashboardLowStock => 'കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get dashboardExpiring => 'ഉടൻ കാലാവധി തീരുന്നവ';

  @override
  String get dashboardWastage => 'വേസ്റ്റേജ്';

  @override
  String get dashboardPurchases => 'പർച്ചേസുകൾ';

  @override
  String get dashboardTopItems => 'കൂടുതൽ വിറ്റവ';

  @override
  String get planTitle => 'സബ്‌സ്‌ക്രിപ്ഷൻ';

  @override
  String get planSubtitle => 'ഈ കടയ്ക്കുള്ള ക്ലൗഡ് ഫീച്ചറുകൾ';

  @override
  String get planFree => 'സൗജന്യം';

  @override
  String get planPro => 'പ്രോ';

  @override
  String get planFreeNote => 'ഈ ഫോണിലെല്ലാം സൗജന്യമായി പ്രവർത്തിക്കും.';

  @override
  String get planProNote => 'ഈ കടയ്ക്കായി ക്ലൗഡ് ഫീച്ചറുകൾ ആക്ടീവാണ്.';

  @override
  String get planCloudFeatures => 'ക്ലൗഡ് ഫീച്ചറുകൾ';

  @override
  String get planFeatureAccount => 'ക്ലൗഡ് ഷോപ്പ് അക്കൗണ്ട്';

  @override
  String get planFeatureLiveSync => 'ലൈവ് ഓർഡർ ബോർഡ് സിങ്ക്';

  @override
  String get planFeatureQrOrdering => 'QR മെനു ഓർഡറിംഗ്';

  @override
  String get planFeatureShareLinks => 'ഷെയർ ചെയ്യാവുന്ന ലിങ്കുകൾ';

  @override
  String get planFeatureSoundbox => 'ക്ലൗഡ് സൗണ്ട്ബോക്സ്';

  @override
  String get planFeatureBackup => 'മൾട്ടി-ഡിവൈസ് ബാക്കപ്പ്';

  @override
  String get planOn => 'ഓൺ';

  @override
  String get planLocked => 'ലോക്ക്ഡ്';

  @override
  String get planRefresh => 'സബ്‌സ്ക്രിപ്ഷൻ പരിശോധിക്കുക';

  @override
  String get planChecking => 'പരിശോധിക്കുന്നു…';

  @override
  String get planCheckFailed =>
      'ഇപ്പോൾ പരിശോധിക്കാൻ കഴിഞ്ഞില്ല. പഴയ വിവരങ്ങൾ ഉപയോഗിക്കുന്നു.';

  @override
  String get planNeedsShop => 'ആദ്യം ക്ലൗഡ് ഷോപ്പ് സെറ്റ് ചെയ്യുക.';

  @override
  String get planOfflineNote =>
      'കുറച്ചു ദിവസം ഓഫ്‌ലൈൻ ആയാലും കുഴപ്പമില്ല — ഗ്രേസ് പീരിയഡിൽ ക്ലൗഡ് ഫീച്ചറുകൾ പ്രവർത്തിക്കും.';

  @override
  String get shopTitle => 'എന്റെ ഷോപ്പ്';

  @override
  String get shopSubtitle => 'നിങ്ങളുടെ ബിസിനസ്സിന് അനുയോജ്യമായ രീതി';

  @override
  String get shopPickType => 'കടയുടെ തരം';

  @override
  String get shopWorkflow => 'ദിവസേനയുള്ള രീതി';

  @override
  String get shopTypeRestaurant => 'റെസ്റ്റോറന്റ്';

  @override
  String get shopTypeHotel => 'ഹോട്ടൽ';

  @override
  String get shopTypeStreet => 'തട്ടുകട';

  @override
  String get shopTypeDiy => 'ക്രാഫ്റ്റ് / DIY സ്റ്റാൾ';

  @override
  String get shopTypeMagnet => 'ഫ്രിഡ്ജ് മാഗ്നറ്റ് സ്റ്റാൾ';

  @override
  String get shopTypeTea => 'ചായക്കട';

  @override
  String get settingsOrderingTitle => 'ഓർഡറിംഗ് നിയമങ്ങൾ';

  @override
  String get settingsOrderingSubtitle =>
      'സർവീസ് രീതി, പണം വാങ്ങുന്ന സമയം, ടേബിൾ ബട്ടണുകൾ';

  @override
  String get serviceStyle => 'സർവീസ് രീതി';

  @override
  String get serviceTable => 'ടേബിൾ സർവീസ്';

  @override
  String get serviceSelf => 'സെൽഫ് സർവീസ്';

  @override
  String get serviceTakeaway => 'പാഴ്സൽ മാത്രം';

  @override
  String get paymentTiming => 'പണം വാങ്ങുന്ന സമയം';

  @override
  String get payBefore => 'ആദ്യം പണം വാങ്ങുക';

  @override
  String get payAfter => 'പിന്നീട് പണം വാങ്ങുക';

  @override
  String get payTimingHelp =>
      'ആദ്യം പണം വാങ്ങുകയാണെങ്കിൽ ഓർഡർ ഉറപ്പാക്കുന്നതിന് മുമ്പ് കസ്റ്റമർ പണം അടയ്ക്കണം. ശേഷമാണെങ്കിൽ ഓർഡർ നേരെ അടുക്കളയിലേക്ക് പോകും.';

  @override
  String get customerButtons => 'കസ്റ്റമർ സ്ക്രീനിലെ ബട്ടണുകൾ';

  @override
  String get allowCallStaff => 'സ്റ്റാഫിനെ വിളിക്കുക';

  @override
  String get allowRequestBill => 'ബിൽ ചോദിക്കുക';

  @override
  String get customerButtonsHelp => 'ടേബിൾ സർവീസിൽ മാത്രമേ ഇവ കാണിക്കൂ.';

  @override
  String get requestCallStaff => 'സ്റ്റാഫ് വരണം';

  @override
  String get requestBill => 'ബിൽ തരൂ';

  @override
  String requestTable(String table) {
    return 'ടേബിൾ $table';
  }

  @override
  String get requestCounter => 'കൗണ്ടർ';

  @override
  String get requestSeen => 'കണ്ടു';

  @override
  String get payStateAwaiting => 'പേയ്‌മെന്റ് കാത്തിരിക്കുന്നു';

  @override
  String get payStateDue => 'കൗണ്ടറിൽ നൽകുക';

  @override
  String get payStatePaid => 'നൽകി';

  @override
  String get orderMarkPaid => 'പണം ലഭിച്ചതായി രേഖപ്പെടുത്തുക';

  @override
  String get devicesTitle => 'ഫോണുകളും ഡിവൈസുകളും';

  @override
  String get devicesSubtitle =>
      'വെയ്റ്റർ, കിച്ചൻ, കൗണ്ടർ ഫോണുകൾ ഒരൊറ്റ സ്ക്രീനിൽ';

  @override
  String get devicesPairThis => 'ഈ ഫോൺ കണക്റ്റ് ചെയ്യുക';

  @override
  String get devicesShopSlug => 'കടയുടെ പേര് (മെനു ലിങ്ക് വേഡ്)';

  @override
  String get devicesEnterCode => 'ഓണറുടെ 6 അക്ക കോഡ്';

  @override
  String get devicesLabel => 'ഫോണിന്റെ പേര്';

  @override
  String get devicesPairButton => 'ഫോൺ കണക്റ്റ് ചെയ്യുക';

  @override
  String get devicesPairSuccess => 'ഫോൺ കടയുമായി കണക്റ്റ് ചെയ്തു';

  @override
  String get devicesUnpair => 'ഈ ഫോൺ ഒഴിവാക്കുക';

  @override
  String devicesPairedAs(String role, String shop) {
    return '$role ആയി കണക്റ്റ് ചെയ്തു · $shop';
  }

  @override
  String get devicesNewCode => 'പുതിയ പെയറിംഗ് കോഡ്';

  @override
  String get devicesCodeExpires =>
      '15 മിനിറ്റ് വാലിഡിറ്റി · കോപ്പി ചെയ്യാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get devicesList => 'കണക്റ്റ് ചെയ്ത ഫോണുകൾ';

  @override
  String get devicesEmpty => 'ഫോണുകളൊന്നും കണക്റ്റ് ചെയ്തിട്ടില്ല';

  @override
  String get devicesRevoke => 'ഒഴിവാക്കുക';

  @override
  String get devicesRevoked => 'ഒഴിവാക്കി';

  @override
  String get devicesOnline => 'ഓൺലൈൻ';

  @override
  String get devicesOffline => 'ഓഫ്‌ലൈൻ';

  @override
  String get devicesRoleWaiter => 'വെയ്റ്റർ';

  @override
  String get devicesRoleKitchen => 'കിച്ചൻ';

  @override
  String get devicesRoleCounter => 'കൗണ്ടർ';

  @override
  String get devicesProRequired =>
      'മൾട്ടി-ഡിവൈസ് സിങ്ക് ഒരു Pro ഫീച്ചറാണ്. വെയ്റ്റർ, കിച്ചൻ, കൗണ്ടർ ഫോണുകൾ കണക്റ്റ് ചെയ്യാൻ അപ്‌ഗ്രേഡ് ചെയ്യുക.';

  @override
  String get cloudShopSection => 'ക്ലൗഡ് ഷോപ്പ്';

  @override
  String get cloudShopHint =>
      'QR മെനു ഓർഡറുകളും സ്റ്റാഫ് ഫോണുകളും ഒരൊറ്റ ലൈവ് ഓർഡർ ലിസ്റ്റിൽ വരാൻ സർവറിൽ നിങ്ങളുടെ ഷോപ്പ് ഉണ്ടാക്കുക.';

  @override
  String get cloudShopSlug => 'ലിങ്കുകൾക്കായുള്ള കടയുടെ പേര് (ഉദാ. sirpam-tea)';

  @override
  String get cloudShopKey => 'ഷോപ്പ് കീ (രഹസ്യ നമ്പർ, 16+ അക്ഷരങ്ങൾ)';

  @override
  String get cloudShopGenerate => 'കീ ഉണ്ടാക്കുക';

  @override
  String get cloudShopCreate => 'ക്ലൗഡ് ഷോപ്പ് ഉണ്ടാക്കുക';

  @override
  String get cloudShopUpdate => 'ക്ലൗഡ് ഷോപ്പ് അപ്ഡേറ്റ് ചെയ്യുക';

  @override
  String cloudShopLive(String slug) {
    return 'ക്ലൗഡ് ഷോപ്പ് തയ്യാറാണ്: $slug';
  }

  @override
  String get cloudShopNone =>
      'ക്ലൗഡ് ഷോപ്പ് ഇതുവരെ ഉണ്ടാക്കിയിട്ടില്ല. QR ഓർഡറിംഗും സ്റ്റാഫ് ഫോണുകളും ഉപയോഗിക്കാൻ ഒന്ന് ഉണ്ടാക്കുക.';

  @override
  String get cloudShopCreated => 'ക്ലൗഡ് ഷോപ്പ് ഉണ്ടാക്കി';

  @override
  String get cloudShopKeyShort =>
      'കടയുടെ പേരും കുറഞ്ഞത് 16 അക്ഷരങ്ങളുള്ള കീയും നൽകുക.';

  @override
  String get cloudShopCopyKey => 'കീ കോപ്പി ചെയ്യുക';

  @override
  String get cloudShopKeyCopied => 'ഷോപ്പ് കീ കോപ്പി ചെയ്തു';

  @override
  String get approvalTitle => 'ഓണറുടെ അനുമതി';

  @override
  String approvalNeeded(String action) {
    return 'ഈ ഷിഫ്റ്റിൽ ഇത് ചെയ്യാൻ കഴിയില്ല: $action. ഉടമയ്ക്ക് ഒരു തവണ അനുവദിക്കാം.';
  }

  @override
  String approvalOverLimit(String action) {
    return 'ഇത് ഈ ഷിഫ്റ്റിന്റെ പരിധിക്ക് മുകളിലാണ്: $action. ഉടമയ്ക്ക് ഒരു തവണ അനുവദിക്കാം.';
  }

  @override
  String get approvalOwnerPin => 'ഉടമയുടെ PIN';

  @override
  String get approvalApprove => 'ഒരു തവണ അനുവദിക്കുക';

  @override
  String get approvalGranted => 'ഉടമ അനുമതി നൽകി';

  @override
  String get approvalWrongPin => 'തെറ്റായ ഉടമ PIN';

  @override
  String get approvalBlockedTitle => 'അനുവാദമില്ല';

  @override
  String approvalBlockedBody(String action) {
    return 'ഈ ഷിഫ്റ്റിന് $action ചെയ്യാനുള്ള അനുവാദമില്ല. റോൾ മാറ്റാൻ ഉടമയോട് പറയുക.';
  }

  @override
  String get recurringRemove => 'ഒഴിവാക്കുക';

  @override
  String get recurringRemoved => 'സ്ഥിരം ചെലവ് ഒഴിവാക്കി';

  @override
  String recurringRemoveConfirm(String name) {
    return 'സ്ഥിരം ചെലവുകളിൽ നിന്ന് $name ഒഴിവാക്കണോ?';
  }

  @override
  String get orderEditItems => 'ഇനങ്ങൾ മാറ്റുക';

  @override
  String get orderEditItemsSaved => 'ഓർഡർ ഇനങ്ങൾ പുതുക്കി';

  @override
  String get orderEditEmpty => 'ഓർഡറിൽ ചുരുങ്ങിയത് ഒരു ഇനമെങ്കിലും വേണം.';

  @override
  String get printerStatus => 'പ്രിന്റർ സ്റ്റാറ്റസ്';

  @override
  String get printerNotConnected => 'പ്രിന്റർ കണക്ട് ചെയ്തിട്ടില്ല';

  @override
  String printerConnectedTo(String name) {
    return '$name-ലേക്ക് കണക്ട് ചെയ്തു';
  }

  @override
  String get printerDisconnect => 'ഡിസ്‌കണക്ട് ചെയ്യുക';

  @override
  String get printerDisconnected => 'പ്രിന്റർ ഡിസ്‌കണക്റ്റായി';

  @override
  String get printerForget => 'പ്രിന്റർ ഒഴിവാക്കുക';

  @override
  String get printerForgotten =>
      'പ്രിന്റർ ഒഴിവാക്കി. ബില്ലുകൾ PDF ആയി പങ്കിടാം.';

  @override
  String get printerUnsupported =>
      'ഈ ഫോണിൽ നിന്ന് Bluetooth വഴി പ്രിന്റ് ചെയ്യാനാകില്ല.';

  @override
  String get printerPermissionNeeded =>
      'പ്രിന്റർ കണ്ടെത്താൻ Bluetooth പെർമിഷൻ നൽകുക.';

  @override
  String get printerPermissionDenied => 'Bluetooth പെർമിഷൻ നൽകിയിട്ടില്ല.';

  @override
  String get printerAllowBluetooth => 'Bluetooth അനുവദിക്കുക';

  @override
  String get devicesTest => 'കണക്ഷൻ പരിശോധിക്കുക';

  @override
  String get devicesTestOk => 'കടയുമായി കണക്ട് ചെയ്തിരിക്കുന്നു';

  @override
  String get devicesTestFailed =>
      'ഈ ഫോൺ കണക്റ്റല്ല. പുതിയ കോഡിനായി ഉടമയോട് ചോദിക്കുക.';

  @override
  String stockLastUpdated(String when) {
    return 'സ്റ്റോക്ക് അവസാനം പുതുക്കിയത് $when';
  }

  @override
  String get agoJustNow => 'ഇപ്പോൾ';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മിനിറ്റ് മുൻപ്',
      one: '1 മിനിറ്റ് മുൻപ്',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മണിക്കൂർ മുൻപ്',
      one: '1 മണിക്കൂർ മുൻപ്',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം മുൻപ്',
      one: '1 ദിവസം മുൻപ്',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'രാവിലത്തെ ഒരുക്കങ്ങൾ';

  @override
  String get prepSubtitle => 'ആദ്യ കസ്റ്റമർ വരുന്നതിന് മുൻപ് റെഡിയാക്കേണ്ടവ';

  @override
  String prepPending(String count) {
    return 'ഇനിയും $count എണ്ണം തയ്യാറാക്കാനുണ്ട്';
  }

  @override
  String get prepUseStarter => 'സ്റ്റാർട്ടർ ഷീറ്റ് ഉപയോഗിക്കുക';

  @override
  String get prepTodaySheet => 'ഇന്നത്തെ ഷീറ്റ്';

  @override
  String get prepAddTitle => 'ഒരുക്കാനുള്ള ഇനം ചേർക്കുക';

  @override
  String get prepItemName => 'ഇനം';

  @override
  String get prepPlanned => 'പ്ലാൻ ചെയ്തത്';

  @override
  String get prepMade => 'ഉണ്ടാക്കിയത്';

  @override
  String get prepUnit => 'യൂണിറ്റ്';

  @override
  String get prepAdd => 'ലിസ്റ്റിൽ ചേർക്കുക';

  @override
  String prepShort(String qty) {
    return '$qty കുറവ്';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$planned $unit-ൽ $made';
  }

  @override
  String get prepSeedMilk => 'പാൽ';

  @override
  String get prepSeedBatter => 'മാവ്';

  @override
  String get prepSeedSnacks => 'പലഹാരങ്ങൾ';

  @override
  String get prepSeedChange => 'ചില്ലറ പണം';

  @override
  String get prepSeedDisplay => 'ഡിസ്പ്ലേ ഒരുക്കുക';

  @override
  String get prepSeedStock => 'ഷെൽഫ് നിറയ്ക്കുക';

  @override
  String get prepUnitLitre => 'ലിറ്റർ';

  @override
  String get prepUnitPlate => 'പ്ലേറ്റ്';

  @override
  String get prepUnitPiece => 'പീസ്';

  @override
  String get prepUnitRupee => 'രൂപ';

  @override
  String get insightsRush => 'തിരക്കുള്ള സമയം';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return '$hour:00 മണിക്ക് നല്ല തിരക്ക് ($bills ബില്ലുകൾ) — കൗണ്ടറിൽ $staff ഉണ്ടാകണം';
  }

  @override
  String get dayCloseOpeningCash => 'തുടക്കത്തിലെ ക്യാഷ്';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item തീർന്നു എന്ന് അടയാളപ്പെടുത്തി';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item വീണ്ടും ലഭ്യമാണ്';
  }

  @override
  String get insightsHeroes => 'ഇന്നത്തെ ഹീറോസ്';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold വിറ്റു · $left ബാക്കി';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return 'ഏകദേശം $hour:00 മണിക്ക് തീരും';
  }

  @override
  String get customerLapsedTitle => 'കുറെയായി വരാത്തവർ';

  @override
  String get customerLapsedHint =>
      'ഒരു ചെറിയ മെസ്സേജ് അയച്ചാൽ പലരും തിരികെ വരും.';

  @override
  String customerLapsedDays(String days) {
    return 'വന്നിട്ട് $days ദിവസമായി';
  }

  @override
  String get customerNudge => 'മെസ്സേജ് അയക്കുക';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'ഹലോ $name, $shop-ലേക്ക് കുറെയായി കണ്ടിട്ട്! നിങ്ങൾക്കായി പുതിയ വിഭവങ്ങൾ കാത്തിരിക്കുന്നു.';
  }

  @override
  String get offersTitle => 'ഓഫറുകൾ';

  @override
  String get offersSubtitle => 'നിങ്ങൾ നൽകുന്ന ഡിസ്കൗണ്ടുകളും അവയുടെ ചെലവും.';

  @override
  String get offerAdd => 'ഓഫർ ചേർക്കുക';

  @override
  String get offerName => 'ഓഫറിന്റെ പേര്';

  @override
  String get offerCode => 'കസ്റ്റമർ പറയേണ്ട കോഡ് (നിർബന്ധമില്ല)';

  @override
  String get offerKindFlat => 'രൂപ കുറവ്';

  @override
  String get offerKindPercent => 'ശതമാനം കുറവ്';

  @override
  String get offerKindCombo => 'കോംബോ വില';

  @override
  String get offerAmount => 'കുറയ്ക്കുന്ന തുക';

  @override
  String get offerPercent => 'ശതമാനം ഇളവ്';

  @override
  String get offerComboPrice => 'കോംബോ വില';

  @override
  String get offersGivenTotal => 'ഇതുവരെ നൽകിയ ഇളവ്';

  @override
  String get offersEmpty =>
      'ഓഫറുകളൊന്നും ഇല്ല. ഒരെണ്ണം ചേർത്താൽ ബില്ലിൽ കാണാം.';

  @override
  String get offerLive => 'ലൈവ്';

  @override
  String get offerPaused => 'നിർത്തിവെച്ചു';

  @override
  String get offerPause => 'നിർത്തുക';

  @override
  String get offerResume => 'വീണ്ടും തുടങ്ങുക';

  @override
  String offerUsed(String count) {
    return '$count തവണ ഉപയോഗിച്ചു';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount ഇളവ് നൽകി';
  }

  @override
  String get feedbackTitle => 'ബിൽ ഫീഡ്‌ബാക്ക്';

  @override
  String get feedbackSubtitle =>
      'പണം നൽകിയ ഉടൻ കസ്റ്റമറുടെ റേറ്റിംഗ് നേരിട്ട് നിങ്ങൾക്ക് ലഭിക്കും.';

  @override
  String get feedbackQrTitle => 'കൗണ്ടർ QR';

  @override
  String get feedbackQrHint =>
      'ഇത് പ്രിന്റ് ചെയ്ത് കൗണ്ടറിൽ വെക്കാം, അല്ലെങ്കിൽ പേയ്‌മെന്റിന് ശേഷം കാണിക്കാം.';

  @override
  String get feedbackReviewMissing =>
      'കസ്റ്റമർമാർക്ക് നേരിട്ട് റിവ്യൂ ഇടാൻ \'ഗ്രോത്ത്\' പേജിൽ നിങ്ങളുടെ റിവ്യൂ ലിങ്ക് ചേർക്കുക.';

  @override
  String get feedbackLinkCopied => 'ലിങ്ക് കോപ്പി ചെയ്തു';

  @override
  String get feedbackScores => 'സ്കോറുകൾ';

  @override
  String get feedbackTodayAvg => 'ഇന്ന് (ശരാശരി · എണ്ണം)';

  @override
  String get feedbackWeekAvg => 'കഴിഞ്ഞ 7 ദിവസം (ശരാശരി · എണ്ണം)';

  @override
  String get feedbackNeedsReply => 'മറുപടി നൽകണം';

  @override
  String get feedbackRecord => 'സ്വന്തമായി റേറ്റിംഗ് ചേർക്കുക';

  @override
  String get feedbackHappy => 'കൊള്ളാം';

  @override
  String get feedbackOkay => 'കുഴപ്പമില്ല';

  @override
  String get feedbackUnhappy => 'പോരാ';

  @override
  String get feedbackRecent => 'പുതിയ റേറ്റിംഗുകൾ';

  @override
  String get feedbackEmpty => 'റേറ്റിംഗുകളൊന്നും ലഭിച്ചിട്ടില്ല.';

  @override
  String get enquiriesTitle => 'അന്വേഷണങ്ങൾ';

  @override
  String get enquiriesSubtitle =>
      'ആര് ചോദിച്ചു, എന്ത് വില പറഞ്ഞു, എന്തായി എന്ന വിവരങ്ങൾ.';

  @override
  String get enquiryAdd => 'അന്വേഷണം ചേർക്കുക';

  @override
  String get enquiryName => 'കസ്റ്റമറുടെ പേര്';

  @override
  String get enquiryPhone => 'ഫോൺ';

  @override
  String get enquiryWant => 'എന്താണ് ചോദിച്ചത്';

  @override
  String get enquiryQuote => 'നിങ്ങൾ പറഞ്ഞ വില';

  @override
  String get enquiryNoFollowUp => 'ഓർമ്മപ്പെടുത്തൽ വേണ്ട';

  @override
  String enquiryFollowUpDays(String days) {
    return '$days ദിവസത്തിനുള്ളിൽ ബന്ധപ്പെടുക';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% കച്ചവടമായി മാറി';
  }

  @override
  String get enquiryWonValue => 'ഉറപ്പിച്ച കച്ചവടം';

  @override
  String get enquiryFilterToday => 'ഇന്ന്';

  @override
  String get enquiryFilterOpen => 'ഓപ്പൺ';

  @override
  String get enquiryFilterWon => 'ഉറപ്പിച്ചത്';

  @override
  String get enquiryFilterLost => 'നഷ്ടമായവ';

  @override
  String get enquiryEmpty => 'ഇവിടെ ഒന്നുമില്ല.';

  @override
  String enquiryFollowUpOn(String day) {
    return '$day-ന് ബന്ധപ്പെടുക';
  }

  @override
  String get enquiryMessage => 'മെസ്സേജ്';

  @override
  String enquiryMessageText(String name, String item) {
    return 'ഹലോ $name, $item കാര്യത്തിനായി ബന്ധപ്പെട്ടതാണ്. നിങ്ങൾക്കായി അത് എടുത്തു വെക്കണോ?';
  }

  @override
  String get enquiryWon => 'വിജയിച്ചത്';

  @override
  String get enquiryLost => 'നഷ്ടമായത്';

  @override
  String get enquiryReopen => 'വീണ്ടും തുറക്കുക';

  @override
  String get customerRewardsDueTitle => 'നൽകാനുള്ള റിവാർഡുകൾ';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'ഈ ലിങ്ക് പേര് നിലവിലുണ്ട്. $slug പോലെ ഒന്ന് പരീക്ഷിക്കൂ.';
  }

  @override
  String get cloudShopSlugInvalid =>
      'ചെറിയ അക്ഷരങ്ങളും നമ്പറുകളും ഡാഷും (-) മാത്രം ഉപയോഗിക്കുക, കുറഞ്ഞത് 3 അക്ഷരങ്ങൾ വേണം.';

  @override
  String get cloudShopOffline =>
      'ഇപ്പോൾ ഇന്റർനെറ്റ് ഇല്ല. കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കൂ.';

  @override
  String get cloudShopTryAgain =>
      'നടന്നില്ല. അൽപ്പസമയത്തിന് ശേഷം വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get cloudShopLinkTitle => 'കസ്റ്റമർ ലിങ്ക്';

  @override
  String get cloudShopCopyLink => 'ലിങ്ക് കോപ്പി ചെയ്യുക';

  @override
  String get cloudShopLinkCopied => 'ലിങ്ക് കോപ്പി ചെയ്തു';

  @override
  String get cloudShopShowQr => 'QR കാണിക്കുക';

  @override
  String get paymentQrScanTitle => 'നിങ്ങളുടെ പേയ്‌മെന്റ് ആപ്പ് QR ഉപയോഗിക്കുക';

  @override
  String get paymentQrScanAction => 'എന്റെ QR സ്കാൻ ചെയ്യുക';

  @override
  String get paymentQrScanHelp =>
      'GPay, PhonePe അല്ലെങ്കിൽ Paytm-ന്റെ QR സ്റ്റിക്കറിലേക്ക് ക്യാമറ തിരിക്കുക. അതിൽ നിന്ന് UPI ID എടുക്കുന്നതിനാൽ, ബില്ലുകളും കൗണ്ടർ QR-ഉം ഒരേ അക്കൗണ്ടിലേക്ക് എത്തും.';

  @override
  String paymentQrScanFound(String vpa) {
    return 'നിങ്ങളുടെ QR-ൽ നിന്നുള്ള UPI ID: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'ഇത് പേയ്‌മെന്റ് QR അല്ല. പേയ്‌മെന്റ് ആപ്പിലുള്ള QR സ്കാൻ ചെയ്തു നോക്കൂ.';

  @override
  String get receiptFeedbackLine => 'അഭിപ്രായം അറിയിക്കാൻ സ്കാൻ ചെയ്യുക';

  @override
  String get qrPrintCounterCard => 'കൗണ്ടർ കാർഡ് പ്രിന്റ് ചെയ്യുക';

  @override
  String get qrPayCaption => 'പണം നൽകാൻ സ്കാൻ ചെയ്യുക';

  @override
  String get qrFeedbackCaption => 'റേറ്റ് ചെയ്യാൻ സ്കാൻ ചെയ്യുക';

  @override
  String get offerPrintCards => 'ഓഫർ കാർഡുകൾ പ്രിന്റ് ചെയ്യുക';

  @override
  String get offerCardCaption => 'ഈ ഓഫർ കാണാൻ സ്കാൻ ചെയ്യുക';

  @override
  String get devicesPairQrHint => 'പുതിയ ഫോൺ ഉപയോഗിച്ച് ഇത് സ്കാൻ ചെയ്യുക';

  @override
  String get devicesScanQr => 'പെയറിംഗ് QR സ്കാൻ ചെയ്യുക';

  @override
  String get devicesScanInvalid =>
      'ഇതൊരു പെയറിംഗ് QR അല്ല. ഉടമയോട് വീണ്ടും കാണിക്കാൻ പറയുക.';

  @override
  String get quickSaleScan => 'സാധനം സ്കാൻ ചെയ്യുക';

  @override
  String get quickSaleScanTitle => 'സാധനത്തിന്റെ ലേബൽ സ്കാൻ ചെയ്യുക';

  @override
  String quickSaleScanUnknown(String code) {
    return '$code കോഡിൽ സാധനമൊന്നും കണ്ടെത്തിയില്ല. Products-ൽ ഇത് ചേർക്കുക.';
  }

  @override
  String get backupTitle => 'ബാക്കപ്പും എക്‌സ്‌പോർട്ടും';

  @override
  String get backupSubtitle =>
      'കണക്കുകളുടെ ഒരു പകർപ്പ് സുരക്ഷിതമായി സൂക്ഷിക്കുക';

  @override
  String get backupNowAction => 'ഇപ്പോൾ ബാക്കപ്പ് ചെയ്യുക';

  @override
  String get backupRestoreAction => 'ഫയലിൽ നിന്ന് റീസ്റ്റോർ ചെയ്യുക';

  @override
  String get backupShareSubject => 'VendorOS ബാക്കപ്പ്';

  @override
  String get backupSavedToast => 'ബാക്കപ്പ് ഫയൽ ഉണ്ടാക്കി';

  @override
  String get backupFailedToast =>
      'ബാക്കപ്പ് എടുക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get backupRestoredToast => 'കണക്കുകൾ റീസ്റ്റോർ ചെയ്തു';

  @override
  String get backupNeverSaved => 'ഇതുവരെ ബാക്കപ്പ് എടുത്തിട്ടില്ല';

  @override
  String backupLastSaved(String when) {
    return 'അവസാന ബാക്കപ്പ്: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'ഏകദേശം $kb KB സേവ് ചെയ്യപ്പെടും';
  }

  @override
  String get backupRestoreWarning =>
      'റീസ്റ്റോർ ചെയ്യുമ്പോൾ ഈ ഫോണിലെ വിവരങ്ങൾക്ക് പകരം ഫയലിലെ വിവരങ്ങൾ വരും.';

  @override
  String get backupRestoreConfirmTitle => 'ഈ ബാക്കപ്പ് റീസ്റ്റോർ ചെയ്യണോ?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$when-ലെ $rows വിവരങ്ങൾ ഈ ഫോണിലുള്ളതിന് പകരമായി വരും.';
  }

  @override
  String get backupErrorNotFile => 'ഇത് VendorOS ബാക്കപ്പ് ഫയലല്ല.';

  @override
  String get backupErrorTooNew =>
      'ഈ ബാക്കപ്പ് പുതിയ വേർഷനിലുള്ളതാണ്. ആദ്യം ആപ്പ് അപ്ഡേറ്റ് ചെയ്യുക.';

  @override
  String get backupErrorCorrupt =>
      'ഈ ബാക്കപ്പ് ഫയൽ കേടായതാണ്, ഉപയോഗിക്കാൻ കഴിയില്ല.';

  @override
  String get backupErrorEmpty => 'ഫയലിൽ വിവരങ്ങളൊന്നുമില്ല.';

  @override
  String get exportGroupLabel => 'സ്‌പ്രെഡ്‌ഷീറ്റായി എക്‌സ്‌പോർട്ട് ചെയ്യുക';

  @override
  String get exportSalesTitle => 'വിൽപ്പന';

  @override
  String get exportSalesSubtitle =>
      'തീയതി, ഐറ്റം, തുക എന്നിവയോടുകൂടിയ ഓരോ വിൽപ്പനയും';

  @override
  String get exportBillsTitle => 'ബില്ലുകൾ';

  @override
  String get exportBillsSubtitle => 'ബിൽ തുക, ഡിസ്കൗണ്ട്, ടാക്സ് വിവരങ്ങൾ';

  @override
  String get exportCreditTitle => 'കടം ബാക്കി';

  @override
  String get exportCreditSubtitle => 'ആരൊക്കെ എത്ര തരാനുണ്ട് എന്ന വിവരങ്ങൾ';

  @override
  String get exportStockTitle => 'സ്റ്റോക്ക്';

  @override
  String get exportStockSubtitle => 'ഐറ്റങ്ങൾ, കൈയിലുള്ള അളവ്, വില';

  @override
  String get exportColDate => 'തീയതി';

  @override
  String get exportColItem => 'ഐറ്റം';

  @override
  String get exportColMode => 'പേയ്‌മെന്റ്';

  @override
  String get exportColCustomer => 'കസ്റ്റമർ';

  @override
  String get exportColAmount => 'തുക';

  @override
  String get exportColBillNo => 'ബിൽ നമ്പർ';

  @override
  String get exportColSubtotal => 'സബ്‌ടോട്ടൽ';

  @override
  String get exportColDiscount => 'ഡിസ്‌കൗണ്ട്';

  @override
  String get exportColTax => 'ടാക്സ്';

  @override
  String get exportColTotal => 'ആകെ';

  @override
  String get exportColPayment => 'നൽകിയ രീതി';

  @override
  String get exportColStatus => 'സ്റ്റാറ്റസ്';

  @override
  String get exportColBalance => 'ബാക്കി';

  @override
  String get exportColCode => 'കോഡ്';

  @override
  String get exportColCategory => 'കാറ്റഗറി';

  @override
  String get exportColUnit => 'യൂണിറ്റ്';

  @override
  String get exportColQty => 'അളവ്';

  @override
  String get exportColCost => 'വാങ്ങിയ വില';

  @override
  String get exportColPrice => 'വില';

  @override
  String get gstReportTitle => 'GST സംഗ്രഹം';

  @override
  String get gstReportSubtitle =>
      'അക്കൗണ്ടന്റിനായി മാസാടിസ്ഥാനത്തിലുള്ള ടാക്സ് വിവരങ്ങൾ';

  @override
  String get gstReportEmpty =>
      'GST ബില്ലുകളൊന്നും ഇതുവരെയില്ല. മെനു സെറ്റിങ്സിൽ GST ഓൺ ചെയ്ത ശേഷം ബിൽ ചെയ്യുക.';

  @override
  String get gstColMonth => 'മാസം';

  @override
  String get gstColRate => 'റേറ്റ്';

  @override
  String get gstColTaxable => 'ടാക്സബിൾ തുക';

  @override
  String get gstColTax => 'ആകെ ടാക്സ്';

  @override
  String get gstBills => 'ബില്ലുകൾ';

  @override
  String get gstSales => 'ടാക്സ് ഉൾപ്പെടെയുള്ള വിൽപന';

  @override
  String get gstByRate => 'റേറ്റ് പ്രകാരം';

  @override
  String get gstShareAction => 'സ്പ്രെഡ്‌ഷീറ്റ് ഷെയർ ചെയ്യുക';

  @override
  String gstShareSubject(String month) {
    return 'GST സംഗ്രഹം $month';
  }

  @override
  String get appearanceTitle => 'ഡിസ്‌പ്ലേ';

  @override
  String get appearanceSubtitle => 'ലൈറ്റ് അല്ലെങ്കിൽ ഡാർക്ക് സ്ക്രീൻ';

  @override
  String get appearanceSystem => 'ഫോൺ സെറ്റിങ്സ് പോലെ';

  @override
  String get appearanceLight => 'ലൈറ്റ്';

  @override
  String get appearanceDark => 'ഡാർക്ക്';

  @override
  String get appearanceChanged => 'ഡിസ്‌പ്ലേ മാറ്റി';

  @override
  String get purchasesTitle => 'പർച്ചേസുകൾ';

  @override
  String get purchasesSubtitle => 'സപ്ലയർ ബില്ലുകളും നൽകാനുള്ള ബാക്കി തുകയും';

  @override
  String get purchasesEmpty =>
      'പർച്ചേസ് ബില്ലുകളൊന്നും ഇല്ല. അവസാനം വാങ്ങിയ സ്റ്റോക്ക് ചേർക്കുക.';

  @override
  String get purchaseAdd => 'പർച്ചേസ് ചേർക്കുക';

  @override
  String get purchaseTotalDue => 'സപ്ലയർമാർക്ക് നൽകാനുള്ളത്';

  @override
  String get purchaseMonthSpend => 'ഈ മാസം വാങ്ങിയത്';

  @override
  String get purchaseDuesTitle => 'സപ്ലയർ ബാക്കികൾ';

  @override
  String get purchaseNoDues => 'എല്ലാ സപ്ലയർ ബില്ലുകളും നൽകി തീർത്തു.';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills ബില്ലുകൾ · ഏറ്റവും പഴയത് $days ദിവസം';
  }

  @override
  String get purchaseBillsTitle => 'പർച്ചേസ് ബില്ലുകൾ';

  @override
  String get purchasePaidFull => 'നൽകി';

  @override
  String purchaseDueOf(String amount) {
    return '$amount ബാക്കി';
  }

  @override
  String get purchaseSupplier => 'സപ്ലയർ';

  @override
  String purchasePayTitle(String name) {
    return '$name-ന് പണം നൽകുക';
  }

  @override
  String get purchasePayAmount => 'നൽകിയ തുക';

  @override
  String get purchasePay => 'പേയ്‌മെന്റ് ചേർക്കുക';

  @override
  String get purchaseSubtotal => 'ഐറ്റം ആകെ';

  @override
  String get purchaseTax => 'ടാക്സ്';

  @override
  String get purchaseTotal => 'ബിൽ ആകെ';

  @override
  String get purchaseDue => 'നൽകാനുള്ള ബാക്കി';

  @override
  String get purchaseNewTitle => 'പുതിയ പർച്ചേസ് ബിൽ';

  @override
  String get purchaseInvoiceNo => 'ബിൽ നമ്പർ';

  @override
  String get purchaseItems => 'വാങ്ങിയ സാധനങ്ങൾ';

  @override
  String get purchaseLinkProduct => 'സ്റ്റോക്ക് ലിസ്റ്റിൽ നിന്ന് എടുക്കുക';

  @override
  String get purchaseFreeItem => 'സാധനത്തിന്റെ പേര്';

  @override
  String get purchaseQty => 'അളവ്';

  @override
  String get purchaseUnitCost => 'ഒന്നിന്റെ വില';

  @override
  String get purchaseAddLine => 'സാധനം ചേർക്കുക';

  @override
  String get purchasePaidNow => 'ഇപ്പോൾ നൽകിയത്';

  @override
  String get purchaseNote => 'കുറിപ്പ്';

  @override
  String get purchaseSaved => 'പർച്ചേസ് സേവ് ചെയ്തു, സ്റ്റോക്ക് അപ്ഡേറ്റായി';

  @override
  String get permRecordPurchase => 'പർച്ചേസ് ബില്ലുകൾ രേഖപ്പെടുത്തുക';

  @override
  String get permPaySupplier => 'സപ്ലയർമാർക്ക് പണം നൽകുക';

  @override
  String get backupCloudTitle => 'ഓൺലൈൻ ബാക്കപ്പ്';

  @override
  String backupCloudLast(String when) {
    return 'അവസാന ഓൺലൈൻ ബാക്കപ്പ്: $when';
  }

  @override
  String get backupCloudNever => 'ഇതുവരെ ഓൺലൈനിൽ സേവ് ചെയ്തിട്ടില്ല';

  @override
  String get backupCloudNeedsShop => 'ആദ്യം ക്ലൗഡ് ഷോപ്പ് ഉണ്ടാക്കുക';

  @override
  String get backupCloudNowAction => 'ഇപ്പോൾ ഓൺലൈൻ ബാക്കപ്പ് എടുക്കുക';

  @override
  String get backupCloudRestoreAction => 'ഓൺലൈനിൽ നിന്ന് പുനഃസ്ഥാപിക്കുക';

  @override
  String get backupCloudSavedToast => 'ഓൺലൈനിൽ സേവ് ചെയ്തു';

  @override
  String get backupCloudFailedToast =>
      'ഓൺലൈനിൽ സേവ് ചെയ്യാനായില്ല. സിഗ്നൽ വരുമ്പോൾ വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get billWhatsapp => 'വാട്സ്ആപ്പിൽ അയയ്ക്കുക';

  @override
  String get billWhatsappFailed => 'ഈ ഫോണിൽ വാട്സ്ആപ്പ് ഇല്ല.';

  @override
  String get devicesStaffRole => 'ജീവനക്കാരുടെ ചുമതല';

  @override
  String get devicesRoleDefault => 'സ്ഥിരം (ജോലി മാത്രം)';

  @override
  String get devicesRolePick => 'ഒരു ചുമതല തിരഞ്ഞെടുക്കുക';

  @override
  String get devicesRoleSaved => 'ചുമതല ആ ഫോണിലേക്ക് അയച്ചു';

  @override
  String get devicesRoleFailed =>
      'ചുമതല സജ്ജമാക്കാനായില്ല. ഓൺലൈൻ ആകുമ്പോൾ വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get adminTitle => 'ഉടമയുടെ റിപ്പോർട്ടുകൾ';

  @override
  String get adminSubtitle => 'എന്ത് നടന്നു, ആര് ചെയ്തു, പണം ഒത്തുവന്നോ';

  @override
  String get adminExceptionsTitle => 'ഒഴിവുകൾ';

  @override
  String get adminExceptionsSubtitle =>
      'ഡിസ്കൗണ്ട്, റദ്ദാക്കിയ ബില്ല്, വീണ്ടും പ്രിന്റ്, കടം';

  @override
  String get adminStaffTitle => 'ജീവനക്കാരുടെ റിപ്പോർട്ട്';

  @override
  String get adminStaffSubtitle => 'ഈ കാലയളവിൽ ഓരോരുത്തരും ചെയ്തത്';

  @override
  String get adminCashTitle => 'പണപ്പുസ്തകം';

  @override
  String get adminCashSubtitle => 'പ്രതീക്ഷിച്ചതും എണ്ണിയതും, ദിവസവും';

  @override
  String get adminItemsTitle => 'ഇന വ്യത്യാസം';

  @override
  String get adminItemsSubtitle => 'വിറ്റതും സ്റ്റോക്കിൽ നിന്ന് എടുത്തതും';

  @override
  String get adminShopsTitle => 'എല്ലാ കടകളും';

  @override
  String get adminShopsSubtitle => 'നിങ്ങൾ നടത്തുന്ന എല്ലാ കടകളുടെയും ആകെ';

  @override
  String get adminSummaryTitle => 'ഇന്നത്തെ ചുരുക്കം';

  @override
  String get adminSummarySend => 'ചുരുക്കം അയയ്ക്കുക';

  @override
  String get adminShare => 'പങ്കിടുക';

  @override
  String get adminNoRows => 'ഈ കാലയളവിൽ ഒന്നുമില്ല';

  @override
  String get adminFromBill => 'ബില്ലിൽ നിന്ന്';

  @override
  String get adminOwnerApproved => 'ഉടമ അംഗീകരിച്ചു';

  @override
  String get adminColActions => 'പ്രവർത്തനങ്ങൾ';

  @override
  String get adminColDiscount => 'നൽകിയ ഡിസ്കൗണ്ട്';

  @override
  String get adminColCredit => 'നൽകിയ കടം';

  @override
  String get adminColVoids => 'റദ്ദാക്കിയ ബില്ലുകൾ';

  @override
  String get adminColReprints => 'വീണ്ടും പ്രിന്റുകൾ';

  @override
  String get adminColOverrides => 'ഉടമയുടെ അംഗീകാരങ്ങൾ';

  @override
  String get adminSeeExceptions => 'ഇവരുടെ ഒഴിവുകൾ കാണുക';

  @override
  String get adminCashOpening => 'തുടക്ക പണം';

  @override
  String get adminCashExpected => 'പ്രതീക്ഷിച്ചത്';

  @override
  String get adminCashCounted => 'എണ്ണിയത്';

  @override
  String get adminCashShort => 'കുറവ്';

  @override
  String get adminCashOver => 'കൂടുതൽ';

  @override
  String get adminCashNet => 'ആകെ വ്യത്യാസം';

  @override
  String get adminCashMatched => 'ഒത്തുവന്ന ദിവസങ്ങൾ';

  @override
  String get adminCashMatchedOne => 'ഒത്തു';

  @override
  String get adminCashShortDays => 'കുറവുള്ള ദിവസങ്ങൾ';

  @override
  String get adminItemSold => 'വിറ്റത്';

  @override
  String get adminItemStockOut => 'സ്റ്റോക്കിൽ നിന്ന് എടുത്തത്';

  @override
  String get adminItemGap => 'വ്യത്യാസം';

  @override
  String get adminItemWasted => 'പാഴായത്';

  @override
  String get adminSummaryBills => 'ബില്ലുകൾ';

  @override
  String get adminSummarySales => 'വിൽപ്പന';

  @override
  String get adminSummaryCash => 'പണം';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'കടം';

  @override
  String get adminSummaryDiscount => 'ഡിസ്കൗണ്ടുകൾ';

  @override
  String get adminSummarySpend => 'ചെലവ്';

  @override
  String get adminSummaryCashDiff => 'പണ വ്യത്യാസം';

  @override
  String get adminSummaryTop => 'കൂടുതൽ വിറ്റവ';

  @override
  String get adminShopsAllTotal => 'എല്ലാ കടകളും ചേർത്ത്';

  @override
  String get adminShopsOrders => 'ഓർഡറുകൾ (7 ദിവസം)';

  @override
  String get adminShopsValue => 'മൂല്യം (7 ദിവസം)';

  @override
  String get adminShopsAdd => 'മറ്റൊരു കട ചേർക്കുക';

  @override
  String get adminShopsAddHelp =>
      'മറ്റേ കടയുടെ ലിങ്ക് പേരും ഉടമ കീയും ടൈപ്പ് ചെയ്യുക.';

  @override
  String get adminShopsAddAction => 'കട ചേർക്കുക';

  @override
  String get adminShopsSlug => 'കട ലിങ്ക് പേര്';

  @override
  String get adminShopsKey => 'ഉടമ കീ';

  @override
  String get adminShopsRemove => 'നീക്കുക';

  @override
  String get adminShopsRefresh => 'പുതുക്കുക';

  @override
  String get adminShopsError => 'ഈ കട വായിക്കാനായില്ല';

  @override
  String get adminShopsInvalid => 'ലിങ്ക് പേരും ഉടമ കീയും പരിശോധിക്കുക';

  @override
  String get adminShopsExists => 'ആ കട ഇതിനകം പട്ടികയിലുണ്ട്';

  @override
  String get permViewCashBook => 'പണപ്പുസ്തകം കാണുക';

  @override
  String get permExportData => 'ഡാറ്റ കയറ്റുമതി';

  @override
  String get permViewStaffReport => 'ജീവനക്കാരുടെ റിപ്പോർട്ട് കാണുക';
}
