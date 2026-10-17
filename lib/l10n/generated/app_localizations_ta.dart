// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'வணக்கம் $name, $stall-ல் உங்கள் நிலுவை ₹$amount. தயவுசெய்து செலுத்தவும். நன்றி.$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'வீடு';

  @override
  String get navUdhaar => 'கடன்';

  @override
  String get navSoundbox => 'ஒலி';

  @override
  String get navMandi => 'சந்தை';

  @override
  String get navSales => 'விற்பனை';

  @override
  String get navGroupOverview => 'மேலோட்டம்';

  @override
  String get navGroupSell => 'விற்பனை';

  @override
  String get navGroupOperations => 'வாடிக்கையாளர் & செயல்பாடுகள்';

  @override
  String get navGroupBusiness => 'வணிகம்';

  @override
  String get navGroupTeam => 'குழு';

  @override
  String get navGroupSystem => 'அமைப்பு';

  @override
  String get moreLabel => 'மேலும்';

  @override
  String get menuLoanReport => 'கடன் அறிக்கை';

  @override
  String get menuCartLocation => 'வண்டி இருப்பிடம்';

  @override
  String get menuSettings => 'அமைப்புகள்';

  @override
  String get notFoundTitle => 'பக்கம் கிடைக்கவில்லை';

  @override
  String get goHome => 'முகப்புக்கு செல்';

  @override
  String get ok => 'சரி';

  @override
  String get loading => 'ஏற்றுகிறது…';

  @override
  String storageWriteFailedKey(String key) {
    return 'சேமிக்க முடியவில்லை ($key) — மீண்டும் முயற்சிக்கவும்';
  }

  @override
  String get storageWriteFailed =>
      'சேமிக்க முடியவில்லை — மீண்டும் முயற்சிக்கவும்';

  @override
  String get micUnavailable =>
      'ஒலிவாங்கி கிடைக்கவில்லை — கைமுறையாக பதிவு செய்யவும்';

  @override
  String get voiceNothingHeard => 'ஏதும் கேட்கவில்லை — மீண்டும் பேசவும்';

  @override
  String get voiceNoAmount =>
      'தொகை கேட்கவில்லை — \"50 rupees tomato\" என்று சொல்லவும்';

  @override
  String get voiceZeroAmount => 'தொகை பூஜ்ஜியமாக இருக்க முடியாது';

  @override
  String get modeCash => 'காசு';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'கடன்';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount பதிவானது';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'இன்றைய மொத்த வியாபாரம் $amount ரூபாய்';
  }

  @override
  String get todayCollection => 'இன்றைய வசூல்';

  @override
  String get quickEntry => 'விரைவு பதிவு';

  @override
  String get todayEntries => 'இன்றைய பதிவுகள்';

  @override
  String get noEntriesYet => 'இன்னும் பதிவு இல்லை — மைக் அழுத்தி பேசவும்';

  @override
  String get listeningTapToStop => 'கேட்கிறது, நிறுத்த அழுத்தவும்';

  @override
  String get tapToSpeak => 'பேசி பதியவும்';

  @override
  String get listening => 'கேட்கிறது…';

  @override
  String get speakToRecord => '🎙️ பேசி பதியவும்';

  @override
  String get voiceHint => '\"50 ரூபாய் தக்காளி காசு\" / \"ravi ku 200 கடன்\"';

  @override
  String get addSale => 'விற்பனையை சேர்க்கவும்';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount ரூபாய், $item';
  }

  @override
  String get delete => 'நீக்கு';

  @override
  String get locationServiceOff => 'இருப்பிட சேவை அணைக்கப்பட்டுள்ளது';

  @override
  String get locationPermissionDenied => 'இருப்பிட அனுமதி மறுக்கப்பட்டது';

  @override
  String get broadcastLive => 'நேரலையில் ஒளிபரப்பு';

  @override
  String get locationSearching => 'இருப்பிடம் தேடுகிறது…';

  @override
  String get permissionDenied => 'அனுமதி மறுக்கப்பட்டது';

  @override
  String get unavailable => 'கிடைக்கவில்லை';

  @override
  String get broadcastStopped => 'ஒளிபரப்பு நிறுத்தம்';

  @override
  String get locationNotFetched => 'இருப்பிடம் இன்னும் பெறப்படவில்லை';

  @override
  String get stopBroadcast => 'ஒளிபரப்பை நிறுத்து';

  @override
  String get startBroadcast => 'ஒளிபரப்பு தொடங்கு';

  @override
  String get sendToCustomer => 'வாடிக்கையாளருக்கு அனுப்பு';

  @override
  String get shareLocationHint =>
      'இன்று வண்டி நிற்கும் இடத்தை WhatsApp வழியாக பகிரவும்.';

  @override
  String get ourCart => 'எங்கள் வண்டி';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall இன்று இங்கே இருக்கிறது 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'WhatsApp-ல் பகிர்';

  @override
  String get openInMaps => 'வரைபடத்தில் திற';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in நிராகரித்தது — API சாவியை சரிபார்க்கவும் ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'இணைப்பு தோல்வி: $error';
  }

  @override
  String get mandiTitle => 'சந்தை விலை';

  @override
  String get refresh => 'புதுப்பி';

  @override
  String get mandiLoading => 'சந்தை விலைகள் ஏற்றுகிறது';

  @override
  String get fetchFailed => 'தரவு பெற முடியவில்லை';

  @override
  String get apiKeyNeeded => 'data.gov.in API சாவி தேவை';

  @override
  String get apiKeyNeededBody =>
      'நேரடி APMC விலைகளுக்கு data.gov.in-ல் இலவச API சாவி பெற்று, அமைப்புகளில் சேர்க்கவும். போலி விலைகள் காட்டப்படாது.';

  @override
  String get refreshFailed => 'சமீபத்திய புதுப்பிப்பு தோல்வி';

  @override
  String lastUpdated(String time) {
    return 'கடைசி புதுப்பிப்பு: $time';
  }

  @override
  String get searchVegetable => 'காய்கறி தேடு';

  @override
  String get loanReportHeading => 'வியாபாரக் கடன் அறிக்கை';

  @override
  String reportFailed(String error) {
    return 'அறிக்கை தோல்வி: $error';
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
      other: '$daysString நாட்கள்',
      one: '1 நாள்',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'மொத்த வியாபாரம்';

  @override
  String get digitalShare => 'டிஜிட்டல் பங்கு';

  @override
  String get avgDailyIncome => 'சராசரி நாள் வருமானம்';

  @override
  String get recordedDays => 'பதிவான நாட்கள்';

  @override
  String get sha256Checksum => 'SHA-256 சரிபார்ப்பு';

  @override
  String get noSalesYet =>
      'இன்னும் விற்பனை பதிவு இல்லை — அறிக்கை உருவாக்க முதலில் பதிவு செய்யவும்.';

  @override
  String get viewPdf => 'PDF பார்க்க';

  @override
  String get sendToBank => 'வங்கிக்கு அனுப்பு';

  @override
  String get stallName => 'கடை பெயர்';

  @override
  String get ownerName => 'உரிமையாளர் பெயர்';

  @override
  String get upiVpaLabel => 'UPI முகவரி (எ.கா. name@okaxis)';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get mandiMarket => 'சந்தை (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API சாவி';

  @override
  String get apiKeyHelp =>
      'இலவசமாக data.gov.in-ல் பதிவு செய்து சாவி பெறவும். சாவி இல்லாமல் நேரடி விலைகள் காட்டப்படாது.';

  @override
  String get soundboxAnnounce => 'ஒலி பெட்டி அறிவிப்பு';

  @override
  String get save => 'சேமி';

  @override
  String soundboxSpeech(String amount) {
    return 'ரூபாய் $amount பெறப்பட்டது';
  }

  @override
  String get soundboxTitle => 'ஒலி பெட்டி';

  @override
  String get soundboxSubtitle => 'UPI பணம் தமிழில் அறிவிப்பு';

  @override
  String get watchedApps => 'கண்காணிக்கப்படும் செயலிகள்';

  @override
  String get soundboxTestHint =>
      'சோதனை: \"ரூபாய் 250 பெறப்பட்டது\" தமிழில் ஒலிக்கும்';

  @override
  String get speak => 'ஒலிக்க';

  @override
  String get announcedPayments => 'அறிவிக்கப்பட்ட பணம்';

  @override
  String get noUpiYet => 'இதுவரை UPI பணம் வரவில்லை';

  @override
  String get soundboxRunning => 'ஒலி பெட்டி இயங்குகிறது';

  @override
  String get notificationAccessNeeded => 'அறிவிப்பு அணுகல் தேவை';

  @override
  String get soundboxAndroidHint =>
      'PhonePe, Paytm, Google Pay, BHIM வழியாக வரும் பணம் தானாக தமிழில் அறிவிக்கப்படும்.';

  @override
  String get soundboxGrantHint =>
      'Android அமைப்புகளில் VendorOS-க்கு அறிவிப்பு அணுகல் கொடுக்கவும்.';

  @override
  String get grantAccess => 'அணுகல் கொடு';

  @override
  String get iosUnavailable => 'iOS-ல் கிடைக்காது';

  @override
  String get webUnavailable => 'உலாவியில் கிடைக்காது';

  @override
  String get iosSoundboxNote =>
      'Apple-இன் பின்னணி கட்டுப்பாட்டால் மற்ற செயலிகளின் அறிவிப்புகளை படிக்க முடியாது. கைமுறை/குரல் பதிவு மட்டும்.';

  @override
  String get webSoundboxNote =>
      'உலாவி பிற செயலிகளின் UPI அறிவிப்புகளை படிக்க முடியாது. Android APK-ஐ நிறுவினால் ஒலி பெட்டி இயங்கும்.';

  @override
  String get serverSoundbox => 'வணிக UPI ஒலி பெட்டி';

  @override
  String get serverSoundboxNote =>
      'உங்கள் பணம் வழங்குநர் உறுதி செய்த பணம் இங்கே அறிவிக்கப்படும். எதுவும் தவறாது: இந்த தொலைபேசி ஒலிக்கும் வரை பணம் சேவையகத்தில் காத்திருக்கும்.';

  @override
  String get notPaired =>
      'இந்த தொலைபேசி இன்னும் வணிக UPI கணக்குடன் இணைக்கப்படவில்லை.';

  @override
  String get pairingCode => 'இணைப்பு குறியீடு';

  @override
  String get pair => 'தொலைபேசியை இணை';

  @override
  String get unpair => 'இணைப்பை நீக்கு';

  @override
  String pairedWith(String name) {
    return '$name உடன் இணைக்கப்பட்டது';
  }

  @override
  String get syncNow => 'இப்போது சரிபார்';

  @override
  String lastChecked(String time) {
    return 'கடைசியாக $time மணிக்கு சரிபார்க்கப்பட்டது';
  }

  @override
  String get neverChecked => 'இன்னும் சரிபார்க்கவில்லை';

  @override
  String get soundboxStale =>
      'சமீபத்தில் சேவையகத்துடன் தொடர்பு இல்லை. இணைய இணைப்பை சரிபார்க்கவும்.';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString பணம் அறிவிக்க காத்திருக்கிறது',
      one: '1 பணம் அறிவிக்க காத்திருக்கிறது',
      zero: 'காத்திருப்பு இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'அறிவிப்பு ஒலி பெட்டி (துணை)';

  @override
  String get udhaarTitle => 'கடன் கணக்கு';

  @override
  String get udhaarSubtitle => 'வாடிக்கையாளர் நிலுவை';

  @override
  String get totalOutstanding => 'மொத்த நிலுவை';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString வாடிக்கையாளர்கள்',
      one: '1 வாடிக்கையாளர்',
      zero: 'வாடிக்கையாளர் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'வடிகட்டல்: $name';
  }

  @override
  String get clearFilter => 'வடிகட்டலை நீக்கு';

  @override
  String get upiSetupHint =>
      'UPI கேட்க அமைப்புகளில் VPA மற்றும் கடை பெயரை சேர்க்கவும்.';

  @override
  String get noOutstanding => 'நிலுவைக் கடன் இல்லை';

  @override
  String cannotOpen(String scheme) {
    return 'திறக்க முடியவில்லை: $scheme';
  }

  @override
  String get askUpi => 'UPI கேள்';

  @override
  String get collect => 'வசூல்';

  @override
  String get cancel => 'ரத்து';

  @override
  String get language => 'மொழி';

  @override
  String get languageChanged => 'மொழி மாற்றப்பட்டது';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return 'கடன் $name';
  }

  @override
  String get defaultStallName => 'VendorOS கடை';

  @override
  String get merchantOnboardingTitle => 'வணிக UPI பதிவு';

  @override
  String get merchantOnboardingSubtitle =>
      'உங்கள் வணிகக் கணக்கை சவுண்ட்பாக்ஸுடன் இணைக்கவும்';

  @override
  String get merchantStepsHint =>
      'PhonePe for Business அல்லது Paytm for Business கணக்கில் உள்ள விவரங்களை இங்கே பதிவிடுங்கள். இணைப்புச் சாவி கிடைக்கும், இந்தத் தொலைபேசி உடனே இணைக்கப்படும்.';

  @override
  String get howToGetBusinessUpi => 'வணிக UPI கணக்கை எப்படி பெறுவது?';

  @override
  String get merchantFormIncomplete =>
      'வணிகப் பெயர், வணிக எண் மற்றும் ரகசியச் சாவியை நிரப்பவும்.';

  @override
  String get merchantRegistered => 'வணிகம் பதிவானது';

  @override
  String get pairingCodeSaveHint =>
      'இந்த இணைப்புச் சாவியை சேமித்து வையுங்கள். இரண்டாவது தொலைபேசியை இணைக்க இது தேவை.';

  @override
  String get callbackUrlLabel =>
      'வழங்குநர் கணக்கில் இட வேண்டிய callback முகவரி';

  @override
  String get backToSoundbox => 'சவுண்ட்பாக்ஸுக்கு திரும்பு';

  @override
  String get copy => 'நகலெடு';

  @override
  String get copied => 'நகலெடுக்கப்பட்டது';

  @override
  String get provider => 'பணம் வழங்குநர்';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'வணிகப் பெயர்';

  @override
  String get businessNameHint => 'அறிவிப்பிலும் அறிக்கையிலும் வரும் பெயர்';

  @override
  String get businessVpa => 'வணிக UPI முகவரி';

  @override
  String get businessVpaHint => 'kadaipeyar@ybl';

  @override
  String get merchantIdLabel => 'வணிக எண் (MID)';

  @override
  String get merchantIdHint => 'வழங்குநர் கணக்கில் இருந்து';

  @override
  String get saltKeyLabel => 'Salt சாவி';

  @override
  String get saltKeyHint => 'PhonePe salt சாவி';

  @override
  String get saltIndexLabel => 'Salt எண்';

  @override
  String get webhookTokenLabel => 'Webhook சாவி';

  @override
  String get webhookTokenHint => 'Paytm கணக்கிலும் இடும் வலுவான ரகசியச் சொல்';

  @override
  String get secretStorageNote =>
      'ரகசியச் சாவி சேவையகத்தில் மட்டுமே சேமிக்கப்படும்; செயலி அதை மீண்டும் படிக்க முடியாது.';

  @override
  String get registerBusiness => 'வணிக UPI பதிவு';

  @override
  String get helpTitle => 'உதவி';

  @override
  String get helpSubtitle => 'வணிக UPI மற்றும் சவுண்ட்பாக்ஸ் வழிகாட்டி';

  @override
  String get helpWhyTitle => 'ஏன் வணிக UPI கணக்கு?';

  @override
  String get helpWhyBody =>
      'தனிநபர் UPI முகவரியால் பணப் பரிவர்த்தனையை சேவையகத்தில் உறுதி செய்ய முடியாது; அறிவிப்பு தவறிப் போகலாம். வணிகக் கணக்கு ஒவ்வொரு வெற்றிகரமான பணத்தையும் VendorOS-க்கு அனுப்புகிறது, அதனால் சவுண்ட்பாக்ஸ் எதையும் தவறவிடாது.';

  @override
  String get helpDocsTitle => 'தேவையானவை';

  @override
  String get helpDocsAadhaar => 'ஆதார் எண் மற்றும் அதனுடன் இணைந்த கைபேசி எண்';

  @override
  String get helpDocsPan => 'பான் அட்டை (சிறு கடைக்கு தனிநபர் பான் போதும்)';

  @override
  String get helpDocsBank => 'பணம் வரவு வைக்க வங்கிக் கணக்கு எண் மற்றும் IFSC';

  @override
  String get helpDocsShop => 'கடை பெயர், முகவரி மற்றும் கடையின் புகைப்படம்';

  @override
  String get helpRegisterTitle => 'வழங்குநரிடம் பதிவு';

  @override
  String get helpRegisterStep1 =>
      'Play Store-இல் PhonePe for Business அல்லது Paytm for Business செயலியை நிறுவவும்.';

  @override
  String get helpRegisterStep2 =>
      'கைபேசி எண்ணில் பதிவு செய்து, ஆதார் மற்றும் பான் கொண்டு KYC-ஐ முடிக்கவும்.';

  @override
  String get helpRegisterStep3 =>
      'வங்கிக் கணக்கை இணைத்து, இலவச QR ஸ்டிக்கரை பெறவும்.';

  @override
  String get helpRegisterStep4 =>
      'செயலியில் காட்டப்படும் வணிக UPI முகவரியை (எ.கா. kadaipeyar@ybl) குறித்து வைக்கவும்.';

  @override
  String get helpKeysTitle => 'வணிக எண் மற்றும் ரகசியச் சாவி';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: வணிகக் கணக்கில் Developer settings பகுதிக்கு சென்று வணிக எண், salt சாவி, salt எண் ஆகியவற்றை நகலெடுக்கவும்.';

  @override
  String get helpKeysPaytm =>
      'Paytm: வணிகக் கணக்கில் Developer settings பகுதிக்கு சென்று MID-ஐ நகலெடுத்து, இங்கேயும் இடும் வலுவான webhook சாவியை உருவாக்கவும்.';

  @override
  String get helpKeysCallback =>
      'பதிவுக்குப் பிறகு காட்டப்படும் callback முகவரியை வழங்குநர் கணக்கில் ஒட்டவும்; அப்போதுதான் பணம் VendorOS-ஐ சேரும்.';

  @override
  String get helpLinkTitle => 'இந்தத் தொலைபேசியை இணைக்க';

  @override
  String get helpLinkStep1 =>
      'சவுண்ட்பாக்ஸ் பக்கத்தில் வணிக UPI பதிவு என்பதை அழுத்தவும்.';

  @override
  String get helpLinkStep2 =>
      'படிவத்தை நிரப்பினால் தொலைபேசி தானாக இணையும், இணைப்புச் சாவி காட்டப்படும்.';

  @override
  String get helpLinkStep3 =>
      'இன்னொரு தொலைபேசியில் அதே இணைப்புச் சாவியை சவுண்ட்பாக்ஸில் பதிவிட்டு இணைக்கவும்.';

  @override
  String get helpSafetyTitle => 'பாதுகாப்பாக வையுங்கள்';

  @override
  String get helpSafetyBody =>
      'Salt சாவியையோ webhook சாவியையோ யாருடனும் பகிர வேண்டாம். VendorOS அதை சேவையகத்தில் மட்டும் சேமிக்கும், மீண்டும் காட்டாது.';

  @override
  String get menuInventory => 'சரக்கு';

  @override
  String get productsTitle => 'பொருட்கள்';

  @override
  String get productsSubtitle => 'பட்டியலும் சரக்கும்';

  @override
  String get productsSearchHint => 'பெயர் அல்லது குறியீட்டைத் தேடுங்கள்';

  @override
  String get productsEmpty =>
      'இன்னும் பொருட்கள் இல்லை. முதல் பொருளைச் சேர்க்கவும்.';

  @override
  String get productsAdd => 'பொருள் சேர்';

  @override
  String get productsAllChip => 'அனைத்தும்';

  @override
  String get productsLowStockChip => 'குறைந்த சரக்கு';

  @override
  String get productEditTitle => 'பொருளைத் திருத்து';

  @override
  String get productMissing => 'இந்தப் பொருள் பட்டியலில் இல்லை.';

  @override
  String get productSaved => 'சேமிக்கப்பட்டது';

  @override
  String get productArchived => 'பொருள் நீக்கப்பட்டது';

  @override
  String get formInvalid => 'பொருளின் பெயரைப் பதிவிடவும்';

  @override
  String get fieldName => 'பெயர்';

  @override
  String get fieldLocalName => 'தமிழ்ப் பெயர்';

  @override
  String get fieldCode => 'குறியீடு';

  @override
  String get fieldCodeHint => 'பார்கோடு, இல்லையெனில் காலியாக விடவும்';

  @override
  String get fieldCategory => 'வகை';

  @override
  String get fieldUnit => 'அளவை';

  @override
  String get fieldCost => 'வாங்கிய விலை';

  @override
  String get fieldPrice => 'விற்பனை விலை';

  @override
  String get fieldReorder => 'மீள்கொள்முதல் அளவு';

  @override
  String get saveLabel => 'சேமி';

  @override
  String get discardTitle => 'மாற்றங்களை விட்டுவிடலாமா?';

  @override
  String get discardBody => 'இந்தத் திரையில் சேமிக்கப்படாத மாற்றங்கள் உள்ளன.';

  @override
  String get discardKeep => 'தொடர்ந்து திருத்து';

  @override
  String get discardLeave => 'விட்டுவிடு';

  @override
  String get cancelLabel => 'ரத்து';

  @override
  String get deleteLabel => 'நீக்கு';

  @override
  String get confirmLabel => 'உறுதி';

  @override
  String get qtyLabel => 'அளவு';

  @override
  String get unitCostLabel => 'ஒரு அலகு விலை';

  @override
  String get expiryLabel => 'காலாவதி (நாட்கள்)';

  @override
  String get unitKg => 'கிலோ';

  @override
  String get unitGram => 'கிராம்';

  @override
  String get unitPiece => 'எண்ணிக்கை';

  @override
  String get unitLitre => 'லிட்டர்';

  @override
  String get unitBundle => 'கட்டு';

  @override
  String get detailSell => 'விற்பனை';

  @override
  String get detailRestock => 'சரக்கு சேர்';

  @override
  String get detailWastage => 'வீணானது';

  @override
  String get detailCorrect => 'சரக்கு எண்ணிக்கை';

  @override
  String get detailBatches => 'தொகுதிகள்';

  @override
  String get detailHistory => 'வரலாறு';

  @override
  String get detailLabel => 'சீட்டு அச்சிடு';

  @override
  String get historyEmpty => 'இன்னும் சரக்கு நடவடிக்கை இல்லை';

  @override
  String get soldRecorded => 'விற்பனை பதிவானது';

  @override
  String get restocked => 'சரக்கு சேர்க்கப்பட்டது';

  @override
  String get wastageRecorded => 'வீணானது பதிவானது';

  @override
  String get stockCorrected => 'சரக்கு புதுப்பிக்கப்பட்டது';

  @override
  String get movementPurchase => 'கொள்முதல்';

  @override
  String get movementSale => 'விற்பனை';

  @override
  String get movementWastage => 'வீணானது';

  @override
  String get movementReturn => 'திரும்பியது';

  @override
  String get movementCorrection => 'திருத்தம்';

  @override
  String get expiredTag => 'காலாவதி';

  @override
  String get expiryTodayTag => 'இன்று காலாவதி';

  @override
  String get noExpiry => 'காலாவதி இல்லை';

  @override
  String get batchesTitle => 'தொகுதிகள்';

  @override
  String get batchesSubtitle => 'காலாவதி கண்காணிப்பு';

  @override
  String get batchesEmpty => 'தேதியுள்ள தொகுதிகள் இல்லை';

  @override
  String get stockTitle => 'சரக்கு';

  @override
  String get stockSubtitle => 'மதிப்பு, எச்சரிக்கை, காலாவதி';

  @override
  String get stockValuation => 'சரக்கு மதிப்பு';

  @override
  String get stockProfit => 'லாபம் (30 நாட்கள்)';

  @override
  String get stockWastage => 'வீணானது (30 நாட்கள்)';

  @override
  String get stockLowTitle => 'குறைந்து வருபவை';

  @override
  String get stockExpiryTitle => 'காலாவதி';

  @override
  String get stockNothingLow => 'எதுவும் குறையவில்லை';

  @override
  String get stockNoExpiry => 'தேதியுள்ள தொகுதிகள் இல்லை';

  @override
  String get stockReorderNow => 'மீள்கொள்முதல் பட்டியலை அனுப்பு';

  @override
  String get suppliersTitle => 'சப்ளையர்கள்';

  @override
  String get suppliersSubtitle => 'கொள்முதல் தொடர்புகள்';

  @override
  String get suppliersEmpty => 'இன்னும் சப்ளையர் இல்லை';

  @override
  String get supplierAdd => 'சப்ளையரைச் சேர்';

  @override
  String get supplierName => 'பெயர்';

  @override
  String get supplierPhone => 'தொலைபேசி';

  @override
  String get supplierNote => 'குறிப்பு';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'ஸ்கேன்';

  @override
  String get scanSubtitle => 'பார்கோடு அல்லது QR';

  @override
  String get scanUnsupported =>
      'இங்கு கேமரா ஸ்கேன் கிடைக்கவில்லை. குறியீட்டைத் தட்டச்சு செய்யவும்.';

  @override
  String get scanPermission => 'ஸ்கேன் செய்ய கேமரா அனுமதி தேவை';

  @override
  String get scanManualHint => 'குறியீட்டைத் தட்டச்சு செய்யவும்';

  @override
  String get scanCreateFromCode => 'இந்தக் குறியீட்டுடன் பொருளைச் சேர்';

  @override
  String get labelsTitle => 'சீட்டுகள்';

  @override
  String get labelsSubtitle => 'QR மற்றும் பார்கோடு சீட்டுகள்';

  @override
  String get labelsSelect => 'பொருட்களைத் தேர்வு செய்';

  @override
  String get labelsSize => 'சீட்டு அளவு';

  @override
  String get labelsSymbology => 'குறியீட்டு வகை';

  @override
  String get labelsCopies => 'பிரதிகள்';

  @override
  String get labelsPrint => 'தாள் அச்சிடு';

  @override
  String get labelsThermal => 'அச்சுப்பொறி குறியீட்டை நகலெடு';

  @override
  String get labelsCopied => 'அச்சுப்பொறி குறியீடு நகலெடுக்கப்பட்டது';

  @override
  String get labelsNone => 'குறைந்தது ஒரு பொருளைத் தேர்வு செய்யவும்';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'பார்கோடு';

  @override
  String get paymentQrTitle => 'பணம் QR';

  @override
  String get paymentQrSubtitle => 'வாடிக்கையாளர் ஸ்கேன் செய்து பணம் தரலாம்';

  @override
  String get paymentQrAmountHint => 'தொகை (விரும்பினால்)';

  @override
  String get paymentQrNeedVpa =>
      'முதலில் அமைப்புகளில் UPI முகவரியைப் பதிவிடவும்.';

  @override
  String get paymentQrOpenSettings => 'அமைப்புகளைத் திற';

  @override
  String get paymentQrPoster => 'சுவரொட்டியைச் சேமி';

  @override
  String get paymentQrCopy => 'இணைப்பை நகலெடு';

  @override
  String get paymentQrCopied => 'இணைப்பு நகலெடுக்கப்பட்டது';

  @override
  String get paymentQrNote =>
      'ஸ்கேன் செய்தால் வாடிக்கையாளரின் UPI செயலி திறக்கும். சவுண்ட்பாக்ஸ் அறிவித்தால் மட்டுமே பணம் வந்ததாகக் கொள்ளவும்.';

  @override
  String stockOnHand(String qty) {
    return 'இருப்பு: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'லாபம் $pct%';
  }

  @override
  String expirySoonTag(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days நாட்கள்',
      one: '1 நாள்',
      zero: 'இன்று',
    );
    return '$_temp0';
  }

  @override
  String expiryWatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தொகுதிகள் கவனிக்க வேண்டும்',
      one: '1 தொகுதி கவனிக்க வேண்டும்',
      zero: 'விரைவில் காலாவதி இல்லை',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty மீதம் · ஒரு அலகு $cost';
  }

  @override
  String sellShortfall(String qty) {
    return '$qty மட்டுமே இருப்பில் இருந்தது — அதுவே பதிவானது';
  }

  @override
  String productArchiveConfirm(String name) {
    return '$name பொருளை பட்டியலிலிருந்து நீக்கவா?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: $items அனுப்பவும்';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return '$vpa க்கு பணம்';
  }

  @override
  String scanUnknownCode(String code) {
    return '$code குறியீட்டுடன் பொருள் இல்லை';
  }

  @override
  String get profileTitle => 'வணிக விவரம்';

  @override
  String get vendorCategory => 'வணிக வகை';

  @override
  String get categoryCart => 'தள்ளுவண்டி';

  @override
  String get categoryStall => 'நிரந்தர கடை';

  @override
  String get categoryHotel => 'உணவகம்';

  @override
  String get categoryService => 'சேவை வேலை';

  @override
  String get nicheLabel => 'என்ன விற்கிறீர்கள் அல்லது செய்கிறீர்கள்?';

  @override
  String get districtLabel => 'மாவட்டம்';

  @override
  String get talukLabel => 'வட்டம் / ஊர்';

  @override
  String get marketAreaLabel => 'சந்தை / பகுதி';

  @override
  String get fssaiLabel => 'FSSAI எண் (உணவு வணிகம்)';

  @override
  String get udyamLabel => 'UDYAM பதிவு (விருப்பம்)';

  @override
  String get workingHoursLabel => 'வேலை நேரம்';

  @override
  String get perishableLabel => 'விரைவில் கெடும் பொருட்கள் விற்பனை';

  @override
  String get profilePromptTitle => 'உங்கள் வணிக விவரத்தை அமைக்கவும்';

  @override
  String get profilePromptBody =>
      'நீங்கள் என்ன விற்கிறீர்கள் என்று சொல்லுங்கள்; தேவையான அம்சங்களை மட்டும் காண்பிக்கிறோம்.';

  @override
  String get profilePromptAction => 'அமைக்க';

  @override
  String get profileSaved => 'விவரம் சேமிக்கப்பட்டது';

  @override
  String get expensesTitle => 'செலவுகள்';

  @override
  String get expensesSubtitle =>
      'பால், கியாஸ், தின்பண்டம், வாடகை — வெளியே போகும் பணம்';

  @override
  String get expenseToday => 'இன்றைய செலவு';

  @override
  String get expenseAdd => 'செலவு சேர்';

  @override
  String get expenseAmount => 'தொகை';

  @override
  String get expenseNote => 'குறிப்பு (விருப்பம்)';

  @override
  String get expenseTodayList => 'இன்றைய செலவுகள்';

  @override
  String get expenseEmpty => 'இன்று செலவு எதுவும் பதியவில்லை';

  @override
  String get expenseMilk => 'பால்';

  @override
  String get expenseGas => 'கியாஸ்';

  @override
  String get expenseSnacks => 'தின்பண்டம்';

  @override
  String get expenseProvisions => 'மளிகை';

  @override
  String get expenseWages => 'கூலி';

  @override
  String get expenseRent => 'வாடகை';

  @override
  String get expenseElectricity => 'மின் கட்டணம்';

  @override
  String get expenseTransport => 'போக்குவரத்து';

  @override
  String get expenseOther => 'மற்றவை';

  @override
  String get recurringTitle => 'தினசரி சரக்கு';

  @override
  String get recurringAdd => 'சரக்கு சேர்';

  @override
  String get recurringName => 'சரக்கு பெயர்';

  @override
  String get recurringEmpty =>
      'பால் கேன், தின்பண்ட தட்டு போன்றவற்றை இங்கே சேமித்தால் ஒரே தட்டில் பதியலாம்.';

  @override
  String get dayCloseTitle => 'நாள் முடிப்பு';

  @override
  String get dayCloseExpectedCash => 'பெட்டியில் இருக்க வேண்டிய பணம்';

  @override
  String get dayCloseBreakdown => 'இன்றைய நடப்பு';

  @override
  String get dayCloseCollected => 'கடன் வசூல்';

  @override
  String get dayCloseWastage => 'வீணானது';

  @override
  String get dayCloseProfit => 'இன்றைய லாபம்';

  @override
  String get dayCloseCount => 'பெட்டியை எண்ணுங்கள்';

  @override
  String get dayCloseCountedCash => 'எண்ணிய பணம்';

  @override
  String get dayCloseSave => 'நாளை முடி';

  @override
  String get dayCloseDiscounts => 'கொடுத்த தள்ளுபடி';

  @override
  String get dayCloseTax => 'வசூலித்த வரி';

  @override
  String get dayCloseLastToken => 'கடைசி டோக்கன்';

  @override
  String get dayCloseVoided => 'ரத்து செய்த பில்கள்';

  @override
  String get dayCloseExport => 'நாள் PDF ஏற்றுமதி';

  @override
  String get dayCloseVariancePosted => 'பண வித்தியாசம் கணக்கில் பதிவானது.';

  @override
  String get dayCloseExportFailed =>
      'நாள் சுருக்கத்தை ஏற்றுமதி செய்ய முடியவில்லை.';

  @override
  String get dayCloseMatch => 'பணம் சரியாக பொருந்துகிறது.';

  @override
  String dayCloseSurplus(String amount) {
    return 'எதிர்பார்த்ததை விட $amount அதிகம்';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount குறைவு';
  }

  @override
  String get insightsTitle => 'பார்வை';

  @override
  String get insightsSubtitle => 'நாள், வாரம், மாதம், வருடம்';

  @override
  String get windowDay => 'நாள்';

  @override
  String get windowWeek => 'வாரம்';

  @override
  String get windowMonth => 'மாதம்';

  @override
  String get windowYear => 'வருடம்';

  @override
  String get insightsTurnover => 'வருவாய்';

  @override
  String get insightsCosts => 'செலவு';

  @override
  String get insightsProfit => 'லாபம்';

  @override
  String get insightsAvgDay => 'நாளுக்கு';

  @override
  String get insightsByDay => 'நாள் வாரியாக';

  @override
  String get insightsBestDay => 'சிறந்த நாள்';

  @override
  String get insightsTopItems => 'அதிகம் விற்றவை';

  @override
  String get insightsCostSplit => 'பணம் எங்கே போனது';

  @override
  String get insightsEmpty => 'இந்த காலத்தில் பதிவு எதுவும் இல்லை';

  @override
  String get insightsMarginAlert => 'லாப எச்சரிக்கை';

  @override
  String get insightsMarginBody =>
      'இந்த பொருட்கள் அசல் விலைக்கு மிக அருகில் விற்கின்றன. விலையை உயர்த்தவும் அல்லது அசலை குறைக்கவும்.';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'அசல் $cost · விலை $price';
  }

  @override
  String get quickSaleTitle => 'விரைவு விற்பனை';

  @override
  String get quickSaleSubtitle =>
      'ஒரு டம்ளருக்கு ஒரு தட்டு — அதிகம் என்றால் நீண்ட நேரம் அழுத்தவும்';

  @override
  String get quickSaleQty => 'எண்ணிக்கை';

  @override
  String quickSaleQtyTitle(String item) {
    return '$item எத்தனை?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount பதிவானது';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return '$item ஒன்று $amountக்கு விற்க';
  }

  @override
  String get quickSaleEmpty =>
      'விரைவு பட்டியலுக்கு விலையுடன் பொருட்களை சேர்க்கவும்.';

  @override
  String get starterPackAction => 'என் கடைக்கான தொடக்க தொகுப்பை ஏற்று';

  @override
  String get starterTea => 'டீ';

  @override
  String get starterCoffee => 'காபி';

  @override
  String get starterBun => 'பன்';

  @override
  String get starterBiscuit => 'பிஸ்கட்';

  @override
  String get starterBajji => 'பஜ்ஜி';

  @override
  String get starterMilkSupply => 'பால் கேன்';

  @override
  String get starterSnackSupply => 'தின்பண்ட தட்டு';

  @override
  String get menuDailyWork => 'தினசரி நடப்பு';

  @override
  String get stockOut => 'இருப்பு இல்லை';

  @override
  String get ordersTitle => 'ஆர்டர்கள்';

  @override
  String get ordersSubtitle => 'கவுண்டர் மற்றும் QR ஆர்டர்கள், நேரலை';

  @override
  String get orderCounterNew => 'புதிய கவுண்டர் ஆர்டர்';

  @override
  String get orderTable => 'மேசை';

  @override
  String get orderRemoveItem => 'ஒன்று குறை';

  @override
  String get orderAddItem => 'ஒன்று சேர்';

  @override
  String get orderCancelReason => 'ரத்து செய்யும் காரணம்';

  @override
  String get orderCancel => 'ஆர்டர் ரத்து';

  @override
  String get orderLive => 'நேரலை';

  @override
  String get orderHistory => 'வரலாறு';

  @override
  String get orderEmpty => 'இன்னும் ஆர்டர் இல்லை.';

  @override
  String get orderNew => 'புதியது';

  @override
  String get orderPreparing => 'தயாராகிறது';

  @override
  String get orderServed => 'கொடுத்தாச்சு';

  @override
  String get orderPaid => 'பணம் வந்தது';

  @override
  String get orderCancelled => 'ரத்து';

  @override
  String get orderAccept => 'ஏற்கவும்';

  @override
  String get orderServe => 'கொடுத்தாச்சு';

  @override
  String get orderBulkAccept => 'எல்லா புதிய ஆர்டரையும் ஏற்கவும்';

  @override
  String get orderBulkServe => 'எல்லாவற்றையும் கொடுத்தாச்சு';

  @override
  String get orderBill => 'பில்';

  @override
  String get orderTokenShort => 'டோக்கன்';

  @override
  String get kotTitle => 'சமையல்';

  @override
  String get kotSubtitle => 'அடுத்து சமைக்க வேண்டியவை';

  @override
  String get kotEmpty => 'சமையல் வரிசை காலி.';

  @override
  String get kotDone => 'தயார்';

  @override
  String get billTitle => 'பில்';

  @override
  String get billNumberLabel => 'பில்';

  @override
  String get billSubtotal => 'மொத்தம் (தள்ளுபடிக்கு முன்)';

  @override
  String get billDiscount => 'தள்ளுபடி';

  @override
  String get billDiscountFlat => 'தள்ளுபடி தொகை';

  @override
  String get billDiscountPct => 'தள்ளுபடி %';

  @override
  String get billTax => 'ஜிஎஸ்டி';

  @override
  String get billTaxable => 'வரிக்குரிய தொகை';

  @override
  String get billCgst => 'சிஜிஎஸ்டி';

  @override
  String get billSgst => 'எஸ்ஜிஎஸ்டி';

  @override
  String get billIgst => 'ஐஜிஎஸ்டி';

  @override
  String get shopGstRegistered => 'ஜிஎஸ்டி பதிவு செய்த கடை';

  @override
  String get shopGstRegisteredHint =>
      'பில்லில் சிஜிஎஸ்டி/எஸ்ஜிஎஸ்டி பிரிவும் HSN குறியீடும் அச்சாகும்';

  @override
  String get shopPriceIncludesTax => 'விலையில் வரி சேர்ந்துள்ளது';

  @override
  String get productTaxRate => 'ஜிஎஸ்டி விகிதம் %';

  @override
  String get productHsn => 'HSN / SAC குறியீடு';

  @override
  String get productTaxHint => 'காலியாக விட்டால் கடையின் விகிதம் பயன்படும்';

  @override
  String get billRounding => 'முழுமையாக்கல்';

  @override
  String get billTotal => 'மொத்தம்';

  @override
  String get billPaid => 'கட்டியது';

  @override
  String get billBalance => 'பாக்கி';

  @override
  String get billReprint => 'மீண்டும் அச்சிடு';

  @override
  String get billShare => 'பகிர்';

  @override
  String get billThanks => 'நன்றி, மீண்டும் வாருங்கள்';

  @override
  String get billCustomer => 'வாடிக்கையாளர்';

  @override
  String get billSplit => 'பணம்';

  @override
  String get billRoundToRupee => 'ரூபாயாக முழுமையாக்கு';

  @override
  String get billFillCash => 'பாக்கியை ரொக்கமாக நிரப்பு';

  @override
  String get billFullyPaid => 'முழுவதும் கட்டியாச்சு';

  @override
  String get billSettle => 'பில் முடி';

  @override
  String get close => 'மூடு';

  @override
  String get billPreview => 'ரசீது முன்னோட்டம்';

  @override
  String get billVoid => 'ரசீதை ரத்து செய்';

  @override
  String get billVoidTitle => 'இந்த ரசீதை ரத்து செய்';

  @override
  String get billVoidHint =>
      'ரசீது எண் கணக்கில் இருக்கும்; பதிவேட்டு பதிவுகள் திரும்பப் பெறப்படும்.';

  @override
  String get billVoidReason => 'காரணம்';

  @override
  String get billVoidReasonRequired => 'ரத்து செய்ய காரணம் தேவை';

  @override
  String get billVoided => 'ரசீது ரத்து செய்யப்பட்டது';

  @override
  String get billVoidFailed => 'இந்த ரசீதை ரத்து செய்ய முடியவில்லை';

  @override
  String get billAudit => 'ரசீது வரலாறு';

  @override
  String get menuTitle => 'QR மெனு';

  @override
  String get menuSubtitle => 'ஸ்கேன் செய்யும் வாடிக்கையாளர் பார்ப்பது';

  @override
  String get menuShopSection => 'கடை';

  @override
  String get menuSlug => 'இணைப்பில் கடை பெயர்';

  @override
  String get menuBaseUrl => 'மெனு இணைய முகவரி';

  @override
  String get menuTableCount => 'மேசைகள்';

  @override
  String get menuTaxPercent => 'ஜிஎஸ்டி %';

  @override
  String get menuGstin => 'ஜிஎஸ்டிஐஎன்';

  @override
  String get menuAcceptOrders => 'QR ஆர்டர்களை ஏற்கவும்';

  @override
  String get menuSaved => 'மெனு அமைப்பு சேமிக்கப்பட்டது';

  @override
  String get menuQrSheet => 'QR தாள் அச்சிடு';

  @override
  String get menuLinkSection => 'கடை QR';

  @override
  String get menuItemsSection => 'மெனுவில் உள்ள பொருட்கள்';

  @override
  String get menuSoldOut => 'தீர்ந்தது';

  @override
  String get menuPublished => 'மெனுவில்';

  @override
  String get menuCounterQr => 'கவுண்டர்';

  @override
  String get menuScanHint => 'மெனு பார்க்க, ஆர்டர் செய்ய ஸ்கேன் செய்யவும்';

  @override
  String get printersTitle => 'ரசீது பிரிண்டர்';

  @override
  String get printersSubtitle => 'தாள் அளவு, இணைப்பு, சோதனை அச்சு';

  @override
  String get printerWidth => 'தாள் அகலம்';

  @override
  String get printerTransport => 'இணைப்பு';

  @override
  String get printerPdf => 'PDF / பகிர்வு';

  @override
  String get printerBluetooth => 'புளூடூத்';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'பிரிண்டர் பெயர்';

  @override
  String get printerDeviceAddress => 'பிரிண்டர் முகவரி';

  @override
  String get printerFallbackNote =>
      'இந்த சாதனத்திற்கு நேரடி அச்சு இன்னும் தயாராகவில்லை; பில் PDF ஆக திறக்கும் — அச்சிடலாம் அல்லது பகிரலாம்.';

  @override
  String get printerAutoPrint => 'பில்லை தானாக அச்சிடு';

  @override
  String get printerKot => 'சமையல் சீட்டு அச்சிடு';

  @override
  String get printerTest => 'சோதனை அச்சு';

  @override
  String get printerTestSent => 'சோதனை ரசீது அனுப்பப்பட்டது';

  @override
  String get printerPaired => 'இணைக்கப்பட்ட அச்சுப்பொறிகள்';

  @override
  String get printerScan => 'இணைக்கப்பட்ட அச்சுப்பொறிகளைத் தேடு';

  @override
  String get printerScanning => 'தேடுகிறது…';

  @override
  String get printerNoDevices =>
      'இணைக்கப்பட்ட அச்சுப்பொறி இல்லை. முதலில் Android Bluetooth அமைப்புகளில் இணைக்கவும்.';

  @override
  String get printerConnect => 'இணை';

  @override
  String get printerConnected => 'அச்சுப்பொறி இணைக்கப்பட்டது';

  @override
  String get printerConnectFailed =>
      'இணைக்க முடியவில்லை. அச்சுப்பொறியை இயக்கி மீண்டும் முயற்சிக்கவும்.';

  @override
  String get printerBluetoothNote =>
      'ரசீதுகள் நேரடியாக இந்த Bluetooth அச்சுப்பொறியில் அச்சாகும். அது அணைந்திருந்தால் ரசீது PDF ஆகத் திறக்கும், எதுவும் தொலையாது.';

  @override
  String orderToken(int token) {
    return 'டோக்கன் $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes நிமிடம்';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள்',
      one: '1 பொருள்',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'பில் $number முடிந்தது';
  }

  @override
  String get dayCloseOrders => 'இன்றைய ஆர்டர்கள்';

  @override
  String get dayCloseOrdersTaken => 'பெற்ற ஆர்டர்கள்';

  @override
  String get dayCloseOrdersCancelled => 'ரத்து';

  @override
  String get dayCloseOrdersOpen => 'இன்னும் நிலுவை';

  @override
  String get dayCloseOrdersBilled => 'பில் தொகை';

  @override
  String get dayCloseAvgTicket => 'சராசரி பில்';

  @override
  String get menuCloudSection => 'கிளவுட் ஆர்டர் பலகை';

  @override
  String get menuShopKey => 'கடை சாவி (16+ எழுத்துகள்)';

  @override
  String get menuCloudSync => 'ஆர்டர்களை கிளவுட் உடன் ஒத்திசை';

  @override
  String get menuCloudPublish => 'மெனுவை கிளவுட்டில் வெளியிடு';

  @override
  String menuCloudPublished(int count) {
    return '$count பொருட்கள் கிளவுட் மெனுவில் வெளியிடப்பட்டன';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'கிளவுட் பிழை: $reason';
  }

  @override
  String get menuCloudLive => 'நேரலை: QR ஆர்டர்கள் தானாக பலகையில் வரும்.';

  @override
  String get menuCloudOffline =>
      'உள்ளூர் மட்டும். QR ஆர்டர்கள் பெற கடை சாவி சேர்த்து ஒத்திசைவை இயக்கவும்.';

  @override
  String get settleTitle => 'கடன் தீர்வு';

  @override
  String get settleAmountSection => 'தீர்வு';

  @override
  String get settleAmount => 'தொகை';

  @override
  String get settleCash => 'ரொக்கம்';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'புதிய கடன்';

  @override
  String get settleNote => 'குறிப்பு';

  @override
  String get settleCashHint =>
      'ரொக்கம் வந்ததும் பாக்கி முடிகிறது; இன்றைய ரொக்க வரவில் சேர்க்கப்படும்.';

  @override
  String get settleUpiHint =>
      'UPI-ல் கேட்டு உறுதி செய்யவும். பாக்கி முடிந்து இன்றைய UPI வரவு கூடும்.';

  @override
  String get settleLoanHint =>
      'பழைய பாக்கி முடிந்து அதே தொகை புதிய கடனாக தொடங்கும்.';

  @override
  String get settleConfirm => 'தீர்வு செய்';

  @override
  String get settleDone => 'தீர்வு பதிவானது';

  @override
  String get settleHistory => 'சமீபத்திய தீர்வுகள்';

  @override
  String settleTooMuch(String amount) {
    return 'பாக்கி ₹$amount-ஐ விட அதிகம்';
  }

  @override
  String settleLedgerItem(String name) {
    return 'கடன் தீர்வு — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'புதிய கடனாக மாற்றப்பட்டது — $name';
  }

  @override
  String get menuAddress => 'கடை முகவரி';

  @override
  String get menuPhone => 'தொடர்பு எண்';

  @override
  String get menuFssai => 'FSSAI உரிமம்';

  @override
  String get menuGrowSection => 'வளர்ச்சி & நிர்வாகம்';

  @override
  String get recipesTitle => 'சமையல் குறிப்பு';

  @override
  String get recipesSubtitle => 'உங்கள் அளவுகள் ஒரு முறை எழுதி வையுங்கள்';

  @override
  String get recipeAdd => 'உணவு சேர்';

  @override
  String get recipeName => 'உணவின் பெயர்';

  @override
  String get recipeServings => 'எத்தனை தட்டு';

  @override
  String get recipeEmpty => 'இன்னும் எதுவும் எழுதப்படவில்லை.';

  @override
  String get recipeIngredients => 'தேவையானவை';

  @override
  String get recipeSteps => 'செய்முறை';

  @override
  String get recipeAddIngredient => 'பொருள் சேர்';

  @override
  String get recipeAddStep => 'படி சேர்';

  @override
  String get recipeQty => 'அளவு';

  @override
  String get recipeLinkProduct => 'கையிருப்பு பொருள்';

  @override
  String get recipeNoLink => 'கையிருப்பில் இல்லை';

  @override
  String get recipeCost => 'பொருள் செலவு';

  @override
  String get recipePerServing => 'ஒரு தட்டுக்கு செலவு';

  @override
  String get recipeScale => 'எத்தனைக்கு சமைக்க';

  @override
  String get recipeCookBatch => 'கையிருப்பிலிருந்து கழி';

  @override
  String get recipeCooked => 'கையிருப்பிலிருந்து கழிக்கப்பட்டது';

  @override
  String get recipeStepsEmpty => 'செய்முறை இன்னும் எழுதவில்லை.';

  @override
  String get recipeUnlinkedWarning =>
      'கையிருப்புடன் இணைக்காத பொருட்கள் செலவில் சேர்க்கப்படவில்லை.';

  @override
  String get jobsTitle => 'ஆர்டர் வேலைகள்';

  @override
  String get jobsSubtitle => 'முன்பதிவு மற்றும் ஆர்டருக்கு செய்யும் வேலை';

  @override
  String get jobAdd => 'ஆர்டர் எடு';

  @override
  String get jobTitleField => 'என்ன செய்ய வேண்டும்';

  @override
  String get jobCustomer => 'வாடிக்கையாளர்';

  @override
  String get jobPhone => 'தொலைபேசி';

  @override
  String get jobPrice => 'விலை';

  @override
  String get jobAdvance => 'முன்பணம்';

  @override
  String get jobDue => 'கொடுக்க வேண்டிய நாள்';

  @override
  String get jobEmpty => 'இங்கு ஆர்டர் இல்லை.';

  @override
  String get jobStatusTaken => 'எடுத்தாச்சு';

  @override
  String get jobStatusMaking => 'செய்கிறோம்';

  @override
  String get jobStatusReady => 'தயார்';

  @override
  String get jobStatusDelivered => 'கொடுத்தாச்சு';

  @override
  String get jobStatusCancelled => 'ரத்து';

  @override
  String get jobAdvanceStatus => 'அடுத்த நிலை';

  @override
  String get jobCancel => 'ரத்து செய்';

  @override
  String get jobRemind => 'WhatsApp-ல் தெரிவி';

  @override
  String get jobFilterOpen => 'நடப்பில்';

  @override
  String get jobFilterToday => 'இன்று கொடுக்க';

  @override
  String get jobFilterDone => 'முடிந்தவை';

  @override
  String get customersTitle => 'வழக்கமான வாடிக்கையாளர்';

  @override
  String get customersSubtitle => 'யார் திரும்ப வருகிறார், எப்படி தெரிந்தது';

  @override
  String get customerAdd => 'வாடிக்கையாளர் சேர்';

  @override
  String get customerName => 'பெயர்';

  @override
  String get customerPhone => 'தொலைபேசி';

  @override
  String get sourceWalkIn => 'நேரடியாக வந்தவர்';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'நண்பர் சொன்னார்';

  @override
  String get sourceOther => 'மற்றவை';

  @override
  String get customerRecordVisit => 'வருகை பதிவு';

  @override
  String get customerVisitAmount => 'தொகை';

  @override
  String get customerRewardDue => 'இலவசம் கொடுக்க வேண்டும்';

  @override
  String get customerGiveReward => 'இலவசம் கொடு';

  @override
  String get customersEmpty => 'இன்னும் யாரும் சேர்க்கப்படவில்லை.';

  @override
  String get customerSourceSplit => 'பணம் எங்கிருந்து வருகிறது';

  @override
  String get eventsTitle => 'கண்காட்சி & விழா கடை';

  @override
  String get eventsSubtitle => 'அந்த கடை லாபமா?';

  @override
  String get eventAdd => 'நிகழ்வு சேர்';

  @override
  String get eventName => 'நிகழ்வின் பெயர்';

  @override
  String get eventPlace => 'இடம்';

  @override
  String get eventDay => 'தேதி';

  @override
  String get eventRent => 'கடை வாடகை';

  @override
  String get eventTravel => 'பயணச் செலவு';

  @override
  String get eventOther => 'மற்ற செலவு';

  @override
  String get eventSales => 'விற்பனை';

  @override
  String get eventFootfall => 'வந்தவர்கள்';

  @override
  String get eventProfit => 'லாபம்';

  @override
  String get eventLoss => 'நஷ்டம்';

  @override
  String get eventPerVisitor => 'ஒருவருக்கு';

  @override
  String get eventsEmpty => 'இன்னும் நிகழ்வு பதியப்படவில்லை.';

  @override
  String get staffTitle => 'வேலையாட்கள்';

  @override
  String get staffSubtitle => 'வருகை, முன்பணம், சம்பளம்';

  @override
  String get staffAdd => 'ஆள் சேர்';

  @override
  String get staffName => 'பெயர்';

  @override
  String get staffPhone => 'தொலைபேசி';

  @override
  String get staffRole => 'வேலை';

  @override
  String get staffWage => 'நாள் கூலி';

  @override
  String get staffPresent => 'வந்தார்';

  @override
  String get staffHalf => 'அரை நாள்';

  @override
  String get staffAbsent => 'வரவில்லை';

  @override
  String get staffAdvance => 'முன்பணம்';

  @override
  String get staffAdvanceAdd => 'முன்பணம் கொடு';

  @override
  String get staffPayable => 'இந்த மாத சம்பளம்';

  @override
  String get staffEmpty => 'ஆள் யாரும் சேர்க்கப்படவில்லை.';

  @override
  String get staffRemove => 'நீக்கு';

  @override
  String get growthTitle => 'வளர்ச்சி கருவி';

  @override
  String get growthSubtitle => 'அதிக வாடிக்கையாளர் வர';

  @override
  String get growthMenuLink => 'உங்கள் மெனு இணைப்பு';

  @override
  String get growthShareMenu => 'மெனுவை அனுப்பு';

  @override
  String get growthAskReview => 'விமர்சனம் கேள்';

  @override
  String get growthOpenMaps => 'Maps பக்கம் திற';

  @override
  String get growthWhatsappBroadcast => 'WhatsApp-ல் தெரிவி';

  @override
  String get growthLinksSection => 'உங்கள் இணைப்புகள்';

  @override
  String get growthMapsUrl => 'Google Maps இணைப்பு';

  @override
  String get growthReviewUrl => 'விமர்சன இணைப்பு';

  @override
  String get growthInstagram => 'Instagram பெயர்';

  @override
  String get growthLoyalty => 'எத்தனை வருகைக்கு ஒரு இலவசம்';

  @override
  String get growthIdeas => 'இந்த வார பதிவு யோசனைகள்';

  @override
  String get growthShareIdea => 'அனுப்பு';

  @override
  String get growthIdea1 => 'காலை முதல் பேட்ச் தயாராகும் சிறு காணொளி.';

  @override
  String get growthIdea2 => 'இன்றைய சிறப்பு உணவு, விலையுடன் தெளிவாக.';

  @override
  String get growthIdea3 => 'வழக்கமான வாடிக்கையாளர் தன் ஆர்டருடன்.';

  @override
  String get growthIdea4 => 'கடை காலையில் திறக்கும் விதம்.';

  @override
  String get growthIdea5 => 'வார இறுதிக்கு மட்டும் ஒரு சலுகை, இரண்டு நாள்.';

  @override
  String get growthSaved => 'சேமிக்கப்பட்டது';

  @override
  String get checklistTitle => 'திறக்கும் & மூடும் பட்டியல்';

  @override
  String get checklistSubtitle => 'மறந்தால் நாளை கெடுக்கும் சிறு விஷயங்கள்';

  @override
  String get checklistOpening => 'திறப்பதற்கு முன்';

  @override
  String get checklistClosing => 'மூடுவதற்கு முன்';

  @override
  String get checklistAdd => 'பட்டியலில் சேர்';

  @override
  String get checklistItem => 'என்ன பார்க்க வேண்டும்';

  @override
  String get checklistEmpty => 'பட்டியலில் எதுவும் இல்லை.';

  @override
  String get checklistUseStarter => 'தொடக்க பட்டியலை பயன்படுத்து';

  @override
  String get checklistSeed1 => 'சில்லறை தயாராக வைத்தாச்சா';

  @override
  String get checklistSeed2 => 'கேஸ், பால் பார்த்தாச்சா';

  @override
  String get checklistSeed3 => 'QR ஸ்டாண்ட், விலை பலகை வெளியே';

  @override
  String get checklistSeed4 => 'பணம் எண்ணி எழுதியாச்சா';

  @override
  String get checklistSeed5 => 'ஃபிரிட்ஜ், கேஸ், விளக்கு அணைத்தாச்சா';

  @override
  String jobRemindMessage(String name, String title) {
    return 'வணக்கம் $name, உங்கள் \"$title\" ஆர்டர் தயார்.';
  }

  @override
  String customerVisits(String count) {
    return '$count வருகை';
  }

  @override
  String customerToReward(String count) {
    return 'இன்னும் $count வருகை';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return '$name பிடித்ததா? ஒரு விமர்சனம் எழுதுங்கள்: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — இன்றைய மெனு: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$total-ல் $done முடிந்தது';
  }

  @override
  String get movementPrepared => 'தயாரிப்பு';

  @override
  String recipeShortStock(String item) {
    return '$item கையிருப்பு போதவில்லை';
  }

  @override
  String get starterIdli => 'இட்லி';

  @override
  String get starterDosa => 'தோசை';

  @override
  String get starterMeals => 'சாப்பாடு';

  @override
  String get starterSnackPacket => 'தின்பண்ட பாக்கெட்';

  @override
  String get starterWaterBottle => 'தண்ணீர் பாட்டில்';

  @override
  String get starterVegSupply => 'காய்கறிகள்';

  @override
  String get starterGasSupply => 'கேஸ் சிலிண்டர்';

  @override
  String get checklistSeedHotel => 'மாவு, காய்கறி, கேஸ் தயார்';

  @override
  String get checklistSeedCart => 'வண்டி சுத்தம், சரக்கு ஏற்றியாச்சா';

  @override
  String get checklistSeedService => 'கருவிகள், சில்லறை தயார்';

  @override
  String get presetRecipeTea => 'கடை டீ (10 கப்)';

  @override
  String get presetIngredientMilk => 'பால்';

  @override
  String get presetIngredientWater => 'தண்ணீர்';

  @override
  String get presetIngredientTeaPowder => 'தேயிலை';

  @override
  String get presetIngredientSugar => 'சர்க்கரை';

  @override
  String get rolesTitle => 'பணிப் பொறுப்புகள்';

  @override
  String get rolesSubtitle => 'யார் என்ன செய்யலாம்';

  @override
  String get rolesHint =>
      'ஒவ்வொரு உதவியாளர் வகைக்கும் ஒரு பொறுப்பை உருவாக்கி, அவர்கள் செய்யவேண்டியதை மட்டும் தேர்வு செய்யுங்கள்.';

  @override
  String get rolesEmpty => 'இன்னும் பொறுப்புகள் இல்லை';

  @override
  String get rolesOpen => 'பொறுப்புகளைத் திற';

  @override
  String get roleNew => 'புதிய பொறுப்பு';

  @override
  String get roleSuggestionsTitle => 'உங்கள் கடைக்கான பரிந்துரைகள்';

  @override
  String get roleSuggestionsHint =>
      'உங்கள் வகை வணிகத்திற்கான தயார்நிலைப் பொறுப்புகள். ஒன்றைத் தட்டி உருவாக்கி, பின் மாற்றவும்.';

  @override
  String get tmplWaiter => 'பணியாளர்';

  @override
  String get tmplKitchen => 'சமையலறை / சமையல்காரர்';

  @override
  String get tmplCashier => 'காசாளர்';

  @override
  String get tmplCounter => 'கவுண்டர்';

  @override
  String get tmplSalesHelper => 'விற்பனை உதவியாளர்';

  @override
  String get tmplStockKeeper => 'சரக்கு பொறுப்பாளர்';

  @override
  String get tmplJobAssistant => 'வேலை உதவியாளர்';

  @override
  String get tmplCounterHelper => 'கவுண்டர் உதவியாளர்';

  @override
  String get tmplAssistant => 'உதவியாளர்';

  @override
  String get roleOwner => 'உரிமையாளர்';

  @override
  String get roleOwnerNote => 'எப்போதும் முழு அனுமதி';

  @override
  String get roleInactive => 'பயன்பாட்டில் இல்லை';

  @override
  String rolePermissionCount(String count) {
    return '$count அனுமதி';
  }

  @override
  String get roleEditSubtitle => 'பெயர், வேலை, வரம்பு';

  @override
  String get roleName => 'பொறுப்பின் பெயர்';

  @override
  String get roleNote => 'வேலை விவரம்';

  @override
  String get roleLimits => 'பண வரம்பு (ரூ, 0 = வரம்பு இல்லை)';

  @override
  String get roleMaxDiscount => 'அதிகபட்ச தள்ளுபடி';

  @override
  String get roleMaxCredit => 'அதிகபட்ச கடன்';

  @override
  String get roleMaxRefund => 'அதிகபட்ச திருப்பிக் கொடுத்தல்';

  @override
  String get roleLimitHint => 'இந்த தொகைக்கு மேல் உரிமையாளர் PIN தேவை.';

  @override
  String get roleDuplicate => 'நகல் எடு';

  @override
  String get roleDeactivate => 'பயன்பாட்டை நிறுத்து';

  @override
  String get areaSales => 'விற்பனை';

  @override
  String get areaOrders => 'ஆர்டர், சமையல்';

  @override
  String get areaBilling => 'பில்';

  @override
  String get areaCredit => 'கடன்';

  @override
  String get areaStock => 'சரக்கு';

  @override
  String get areaPurchases => 'வாங்குதல், செலவு';

  @override
  String get areaMoney => 'பணம், அறிக்கை';

  @override
  String get areaCustomers => 'வாடிக்கையாளர்';

  @override
  String get areaStaff => 'உதவியாளர்';

  @override
  String get areaSettings => 'அமைப்பு';

  @override
  String get permRecordSale => 'விற்பனை பதிவு';

  @override
  String get permQuickSale => 'விரைவு விற்பனை';

  @override
  String get permCollectUpi => 'பணம் QR காட்டு';

  @override
  String get permTakeOrder => 'ஆர்டர் எடு';

  @override
  String get permChangeOrderStatus => 'ஆர்டர் நிலை மாற்று';

  @override
  String get permViewKitchen => 'சமையல் பட்டியல் பார்';

  @override
  String get permEditMenu => 'மெனு மாற்று';

  @override
  String get permMakeBill => 'பில் போடு';

  @override
  String get permGiveDiscount => 'தள்ளுபடி கொடு';

  @override
  String get permVoidBill => 'பில் ரத்து';

  @override
  String get permReprintBill => 'பில் மீண்டும் அச்சிடு';

  @override
  String get permGiveCredit => 'கடன் கொடு';

  @override
  String get permSettleCredit => 'கடன் அடை';

  @override
  String get permViewCredit => 'கடன் நிலுவை பார்';

  @override
  String get permViewStock => 'சரக்கு பார்';

  @override
  String get permAdjustStock => 'சரக்கு மாற்று';

  @override
  String get permEditProducts => 'பொருள் சேர்/திருத்து';

  @override
  String get permChangePrice => 'விலை மாற்று';

  @override
  String get permCookRecipe => 'சமையல் செய்';

  @override
  String get permRecordExpense => 'செலவு பதிவு';

  @override
  String get permManageSuppliers => 'சப்ளையர் நிர்வாகம்';

  @override
  String get permViewDayTotals => 'நாள் மொத்தம் பார்';

  @override
  String get permViewProfit => 'லாபம் பார்';

  @override
  String get permCloseDay => 'நாள் முடி';

  @override
  String get permViewReports => 'அறிக்கை பார்';

  @override
  String get permViewCustomers => 'வாடிக்கையாளர் பார்';

  @override
  String get permEditCustomers => 'வாடிக்கையாளர் திருத்து';

  @override
  String get permManageStaff => 'உதவியாளர் நிர்வாகம்';

  @override
  String get permMarkAttendance => 'வருகை பதிவு';

  @override
  String get permPayWages => 'சம்பளம் கொடு';

  @override
  String get permManageRoles => 'பொறுப்பு உருவாக்கு';

  @override
  String get permViewAudit => 'செயல் பதிவு பார்';

  @override
  String get permEditSettings => 'அமைப்பு மாற்று';

  @override
  String get permEditShop => 'கடை விவரம் மாற்று';

  @override
  String get permManagePrinters => 'பிரிண்டர் அமை';

  @override
  String get accessTitle => 'அணுகல் கட்டுப்பாடு';

  @override
  String get accessSubtitle => 'ஒரே போன், தனித்தனி அனுமதி';

  @override
  String get accessEnable => 'PIN கேள்';

  @override
  String get accessEnableHint => 'ஒவ்வொரு உதவியாளரும் PIN போட்டு உள்நுழைவார்.';

  @override
  String get accessNeedsOwnerPin => 'முதலில் உரிமையாளர் PIN அமைக்கவும்';

  @override
  String get accessOwnerPin => 'உரிமையாளர் PIN';

  @override
  String get accessOwnerPinSet => 'உரிமையாளர் PIN அமை (4-6 இலக்கம்)';

  @override
  String get accessOwnerPinChange => 'உரிமையாளர் PIN மாற்று (4-6 இலக்கம்)';

  @override
  String get accessPinSaved => 'PIN சேமிக்கப்பட்டது';

  @override
  String get accessPinInvalid => '4 முதல் 6 இலக்கம் பயன்படுத்தவும்';

  @override
  String get accessAutoLock => 'தானாக பூட்டு';

  @override
  String get accessIdleMinutes => 'பூட்ட நேரம் (நிமிடம், 0 = வேண்டாம்)';

  @override
  String get accessWorkers => 'உதவியாளர்கள்';

  @override
  String get accessNoWorkers => 'முதலில் உதவியாளர்களைச் சேர்க்கவும்';

  @override
  String get accessNoRole => 'பொறுப்பு இல்லை';

  @override
  String get accessPinSet => 'PIN உள்ளது';

  @override
  String get accessPinMissing => 'PIN இல்லை';

  @override
  String get accessAssignTitle => 'பொறுப்பு மற்றும் PIN';

  @override
  String get accessWorkerPin => 'புதிய PIN (4-6 இலக்கம்)';

  @override
  String get accessSaved => 'சேமிக்கப்பட்டது';

  @override
  String get accessEndShift => 'பணி முடி';

  @override
  String get accessWrongPin => 'தவறான PIN';

  @override
  String get lockTitle => 'கவுண்டரில் யார்?';

  @override
  String get lockSubtitle => 'உங்கள் பெயரைத் தேர்ந்து PIN போடுங்கள்';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'பணி தொடங்கு';

  @override
  String get auditTitle => 'செயல் பதிவு';

  @override
  String get auditSubtitle => 'யார் என்ன செய்தார்';

  @override
  String get auditOpen => 'செயல் பதிவைத் திற';

  @override
  String get auditEveryone => 'அனைவரும்';

  @override
  String get auditEmpty => 'இன்னும் பதிவு இல்லை';

  @override
  String get auditApproved => 'உரிமையாளர் ஒப்புதல்';

  @override
  String get settingsGroupBusiness => 'வணிகம்';

  @override
  String get settingsGroupMoney => 'பணம்';

  @override
  String get settingsGroupApp => 'செயலி & சாதனங்கள்';

  @override
  String get settingsShopTitle => 'கடை விவரங்கள்';

  @override
  String get settingsPaymentsTitle => 'பணம் & UPI';

  @override
  String get settingsMarketTitle => 'சந்தை விலைகள்';

  @override
  String get settingsNotSet => 'அமைக்கப்படவில்லை';

  @override
  String get settingsOn => 'இயக்கம்';

  @override
  String get settingsOff => 'நிறுத்தம்';

  @override
  String get settingsSaved => 'அமைப்புகள் சேமிக்கப்பட்டன';

  @override
  String get dashboardTitle => 'டாஷ்போர்டு';

  @override
  String get dashboardSubtitle => 'ஆர்டர், பணம், கடன், சரக்கு ஒரே பார்வையில்';

  @override
  String get dashboardOrders => 'ஆர்டர்கள்';

  @override
  String get dashboardPayments => 'வர வேண்டிய பணம்';

  @override
  String get dashboardCredit => 'கடன் இருப்பு';

  @override
  String get dashboardInventory => 'சரக்கு';

  @override
  String get dashboardShare => 'பகிர்';

  @override
  String get dashboardPlaced => 'பெறப்பட்டது';

  @override
  String get dashboardServed => 'பரிமாறியது';

  @override
  String get dashboardCancelled => 'ரத்து';

  @override
  String get dashboardOpenOrders => 'திறந்த ஆர்டர்கள்';

  @override
  String get dashboardBilled => 'பில் செய்தது';

  @override
  String get dashboardAvgBill => 'சராசரி பில்';

  @override
  String get dashboardCollected => 'வசூலானது';

  @override
  String get dashboardUnbilled => 'இன்னும் பில் இல்லை';

  @override
  String get dashboardPendingTotal => 'வசூலிக்க வேண்டியது';

  @override
  String get dashboardOutstanding => 'நிலுவை';

  @override
  String get dashboardCreditGiven => 'கொடுத்த கடன்';

  @override
  String get dashboardCustomers => 'வாடிக்கையாளர்கள்';

  @override
  String get dashboardOldest => 'மிக பழைய நிலுவை';

  @override
  String dashboardDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString நாட்கள்',
      one: '1 நாள்',
      zero: 'இன்று',
    );
    return '$_temp0';
  }

  @override
  String get dashboardStockValue => 'சரக்கு மதிப்பு';

  @override
  String get dashboardLowStock => 'குறைந்த சரக்கு';

  @override
  String get dashboardExpiring => 'விரைவில் காலாவதி';

  @override
  String get dashboardWastage => 'வீணானது';

  @override
  String get dashboardPurchases => 'கொள்முதல்';

  @override
  String get dashboardTopItems => 'அதிகம் விற்றவை';

  @override
  String get planTitle => 'சந்தா';

  @override
  String get planSubtitle => 'இந்த கடைக்கான கிளவுட் வசதிகள்';

  @override
  String get planFree => 'இலவசம்';

  @override
  String get planPro => 'புரோ';

  @override
  String get planFreeNote =>
      'இந்த ஃபோனில் உள்ள அனைத்தும் இலவசமாக வேலை செய்யும்.';

  @override
  String get planProNote => 'இந்த கடைக்கு கிளவுட் வசதிகள் இயங்குகின்றன.';

  @override
  String get planCloudFeatures => 'கிளவுட் வசதிகள்';

  @override
  String get planFeatureAccount => 'கிளவுட் கடை கணக்கு';

  @override
  String get planFeatureLiveSync => 'நேரடி ஆர்டர் ஒத்திசைவு';

  @override
  String get planFeatureQrOrdering => 'QR மெனு ஆர்டர்';

  @override
  String get planFeatureShareLinks => 'பகிரக்கூடிய இணைப்புகள்';

  @override
  String get planFeatureSoundbox => 'கிளவுட் சவுண்ட்பாக்ஸ்';

  @override
  String get planFeatureBackup => 'பல சாதன காப்பு';

  @override
  String get planOn => 'இயக்கம்';

  @override
  String get planLocked => 'பூட்டியது';

  @override
  String get planRefresh => 'சந்தாவை சரிபார்';

  @override
  String get planChecking => 'சரிபார்க்கிறது…';

  @override
  String get planCheckFailed =>
      'இப்போது சரிபார்க்க முடியவில்லை. கடைசி நிலை பயன்படுகிறது.';

  @override
  String get planNeedsShop => 'முதலில் கிளவுட் கடையை அமைக்கவும்.';

  @override
  String get planOfflineNote =>
      'சில நாட்கள் இணையம் இல்லாவிட்டாலும் சலுகை காலத்தில் வசதிகள் தொடரும்.';

  @override
  String get shopTitle => 'என் கடை';

  @override
  String get shopSubtitle => 'உங்கள் தொழிலுக்கான வேலை வரிசை';

  @override
  String get shopPickType => 'கடை வகை';

  @override
  String get shopWorkflow => 'தினசரி வேலை வரிசை';

  @override
  String get shopTypeRestaurant => 'உணவகம்';

  @override
  String get shopTypeHotel => 'ஹோட்டல்';

  @override
  String get shopTypeStreet => 'தள்ளுவண்டி கடை';

  @override
  String get shopTypeDiy => 'கைவினை கடை';

  @override
  String get shopTypeMagnet => 'ஃப்ரிட்ஜ் மேக்னட் கடை';

  @override
  String get shopTypeTea => 'டீ கடை';

  @override
  String get settingsOrderingTitle => 'ஆர்டர் விதிகள்';

  @override
  String get settingsOrderingSubtitle =>
      'சேவை முறை, பணம் செலுத்தும் நேரம், மேசை பொத்தான்கள்';

  @override
  String get serviceStyle => 'சேவை முறை';

  @override
  String get serviceTable => 'மேசைக்கு பரிமாறல்';

  @override
  String get serviceSelf => 'சுயமாக எடுத்துக்கொள்ளல்';

  @override
  String get serviceTakeaway => 'பார்சல் மட்டும்';

  @override
  String get paymentTiming => 'பணம் செலுத்தும் நேரம்';

  @override
  String get payBefore => 'முன்பணம்';

  @override
  String get payAfter => 'பின்பு பணம்';

  @override
  String get payTimingHelp =>
      'முன்பணம் என்றால் ஆர்டர் உறுதி செய்யும் முன் வாடிக்கையாளர் பணம் செலுத்த வேண்டும். பின்பு பணம் என்றால் ஆர்டர் உடனே சமையலுக்கு செல்லும்.';

  @override
  String get customerButtons => 'வாடிக்கையாளர் திரையில் பொத்தான்கள்';

  @override
  String get allowCallStaff => 'பணியாளரை அழைக்க';

  @override
  String get allowRequestBill => 'பில் கேட்க';

  @override
  String get customerButtonsHelp =>
      'மேசைக்கு பரிமாறும் முறையில் மட்டுமே இவை தெரியும்.';

  @override
  String get requestCallStaff => 'பணியாளர் தேவை';

  @override
  String get requestBill => 'பில் வேண்டும்';

  @override
  String requestTable(String table) {
    return 'மேசை $table';
  }

  @override
  String get requestCounter => 'கவுண்டர்';

  @override
  String get requestSeen => 'பார்த்தேன்';

  @override
  String get payStateAwaiting => 'பணம் வரவில்லை';

  @override
  String get payStateDue => 'கவுண்டரில் பணம்';

  @override
  String get payStatePaid => 'பணம் வந்தது';

  @override
  String get orderMarkPaid => 'பணம் வந்ததாக குறி';

  @override
  String get devicesTitle => 'தொலைபேசிகள் & சாதனங்கள்';

  @override
  String get devicesSubtitle =>
      'பணியாளர், சமையலறை, கவுண்டர் தொலைபேசிகள் ஒரே பலகையில்';

  @override
  String get devicesPairThis => 'இந்த தொலைபேசியை இணைக்க';

  @override
  String get devicesShopSlug => 'கடை பெயர் (மெனு இணைப்புச் சொல்)';

  @override
  String get devicesEnterCode => 'உரிமையாளரிடமிருந்து 6-இலக்க குறியீடு';

  @override
  String get devicesLabel => 'தொலைபேசி பெயர்';

  @override
  String get devicesPairButton => 'தொலைபேசியை இணை';

  @override
  String get devicesPairSuccess => 'தொலைபேசி கடையுடன் இணைக்கப்பட்டது';

  @override
  String get devicesUnpair => 'இந்த தொலைபேசியை அகற்று';

  @override
  String devicesPairedAs(String role, String shop) {
    return '$role ஆக இணைக்கப்பட்டது · $shop';
  }

  @override
  String get devicesNewCode => 'புதிய இணைப்புக் குறியீடு';

  @override
  String get devicesCodeExpires =>
      '15 நிமிடங்களுக்கு மட்டுமே · நகலெடுக்க தட்டவும்';

  @override
  String get devicesList => 'இணைக்கப்பட்ட தொலைபேசிகள்';

  @override
  String get devicesEmpty => 'இன்னும் தொலைபேசிகள் இணைக்கப்படவில்லை';

  @override
  String get devicesRevoke => 'அகற்று';

  @override
  String get devicesRevoked => 'அகற்றப்பட்டது';

  @override
  String get devicesOnline => 'இணைப்பில்';

  @override
  String get devicesOffline => 'இணைப்பில்லை';

  @override
  String get devicesRoleWaiter => 'பரிமாறுபவர்';

  @override
  String get devicesRoleKitchen => 'சமையலறை';

  @override
  String get devicesRoleCounter => 'கவுண்டர்';

  @override
  String get devicesProRequired =>
      'பல சாதன ஒத்திசைவு Pro அம்சம். பணியாளர், சமையலறை, கவுண்டர் தொலைபேசிகளை இணைக்க மேம்படுத்தவும்.';

  @override
  String get cloudShopSection => 'கிளவுட் கடை';

  @override
  String get cloudShopHint =>
      'QR மெனு ஆர்டர்களும் பணியாளர் தொலைபேசிகளும் ஒரே நேரடி ஆர்டர் பட்டியலைப் பகிர சர்வரில் கடையை உருவாக்குங்கள்.';

  @override
  String get cloudShopSlug => 'இணைப்புக்கான கடைப் பெயர் (எ.கா. sirpam-tea)';

  @override
  String get cloudShopKey => 'கடை சாவி (தனிப்பட்டது, 16+ எழுத்துகள்)';

  @override
  String get cloudShopGenerate => 'சாவி உருவாக்கு';

  @override
  String get cloudShopCreate => 'கிளவுட் கடையை உருவாக்கு';

  @override
  String get cloudShopUpdate => 'கிளவுட் கடையைப் புதுப்பி';

  @override
  String cloudShopLive(String slug) {
    return 'கிளவுட் கடை தயார்: $slug';
  }

  @override
  String get cloudShopNone =>
      'இன்னும் கிளவுட் கடை இல்லை. QR ஆர்டர் மற்றும் பணியாளர் தொலைபேசிகளுக்கு ஒன்றை உருவாக்குங்கள்.';

  @override
  String get cloudShopCreated => 'கிளவுட் கடை உருவாக்கப்பட்டது';

  @override
  String get cloudShopKeyShort =>
      'கடைப் பெயரையும் குறைந்தது 16 எழுத்துகள் கொண்ட சாவியையும் உள்ளிடவும்.';

  @override
  String get cloudShopCopyKey => 'சாவியை நகலெடு';

  @override
  String get cloudShopKeyCopied => 'கடை சாவி நகலெடுக்கப்பட்டது';

  @override
  String get approvalTitle => 'உரிமையாளர் அனுமதி';

  @override
  String approvalNeeded(String action) {
    return 'இந்த ஷிப்டில் இதை செய்ய முடியாது: $action. உரிமையாளர் ஒருமுறை அனுமதிக்கலாம்.';
  }

  @override
  String approvalOverLimit(String action) {
    return 'இது இந்த ஷிப்டின் வரம்பை மீறுகிறது: $action. உரிமையாளர் ஒருமுறை அனுமதிக்கலாம்.';
  }

  @override
  String get approvalOwnerPin => 'உரிமையாளர் பின்';

  @override
  String get approvalApprove => 'ஒருமுறை அனுமதி';

  @override
  String get approvalGranted => 'உரிமையாளர் அனுமதித்தார்';

  @override
  String get approvalWrongPin => 'பின் தவறு';

  @override
  String get approvalBlockedTitle => 'அனுமதி இல்லை';

  @override
  String approvalBlockedBody(String action) {
    return 'இந்த ஷிப்டுக்கு $action அணுகல் இல்லை. உரிமையாளரிடம் கேளுங்கள்.';
  }

  @override
  String get recurringRemove => 'நீக்கு';

  @override
  String get recurringRemoved => 'வழக்கமான செலவு நீக்கப்பட்டது';

  @override
  String recurringRemoveConfirm(String name) {
    return '$name வழக்கமான செலவுகளில் இருந்து நீக்கவா?';
  }

  @override
  String get orderEditItems => 'பொருட்களை மாற்று';

  @override
  String get orderEditItemsSaved => 'ஆர்டர் பொருட்கள் மாற்றப்பட்டன';

  @override
  String get orderEditEmpty => 'ஆர்டரில் குறைந்தது ஒரு பொருள் வேண்டும்.';

  @override
  String get printerStatus => 'பிரிண்டர் நிலை';

  @override
  String get printerNotConnected => 'பிரிண்டர் இணைக்கப்படவில்லை';

  @override
  String printerConnectedTo(String name) {
    return '$name உடன் இணைக்கப்பட்டது';
  }

  @override
  String get printerDisconnect => 'துண்டி';

  @override
  String get printerDisconnected => 'பிரிண்டர் துண்டிக்கப்பட்டது';

  @override
  String get printerForget => 'பிரிண்டரை நீக்கு';

  @override
  String get printerForgotten =>
      'பிரிண்டர் நீக்கப்பட்டது. பில் PDF ஆக பகிரப்படும்.';

  @override
  String get printerUnsupported => 'இந்த ஃபோனில் ப்ளூடூத் பிரிண்ட் இயலாது.';

  @override
  String get printerPermissionNeeded => 'பிரிண்டரைக் காண ப்ளூடூத் அனுமதி தேவை.';

  @override
  String get printerPermissionDenied => 'ப்ளூடூத் அனுமதி வழங்கப்படவில்லை.';

  @override
  String get printerAllowBluetooth => 'ப்ளூடூத் அனுமதி';

  @override
  String get devicesTest => 'இணைப்பைச் சோதி';

  @override
  String get devicesTestOk => 'கடையுடன் இணைக்கப்பட்டது';

  @override
  String get devicesTestFailed =>
      'இந்த ஃபோன் இணைக்கப்படவில்லை. உரிமையாளரிடம் புதிய கோடு கேளுங்கள்.';

  @override
  String stockLastUpdated(String when) {
    return 'சரக்கு கடைசியாக $when புதுப்பிக்கப்பட்டது';
  }

  @override
  String get agoJustNow => 'இப்போது';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நிமிடங்கள் முன்பு',
      one: '1 நிமிடம் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மணி முன்பு',
      one: '1 மணி முன்பு',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள் முன்பு',
      one: '1 நாள் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'காலை தயாரிப்பு';

  @override
  String get prepSubtitle => 'முதல் வாடிக்கையாளருக்கு முன் தயாராக வேண்டியவை';

  @override
  String prepPending(String count) {
    return '$count இன்னும் தயாரிக்க வேண்டும்';
  }

  @override
  String get prepUseStarter => 'தொடக்க பட்டியலைப் பயன்படுத்து';

  @override
  String get prepTodaySheet => 'இன்றைய பட்டியல்';

  @override
  String get prepAddTitle => 'தயாரிப்பு உருப்படி சேர்';

  @override
  String get prepItemName => 'உருப்படி';

  @override
  String get prepPlanned => 'திட்டம்';

  @override
  String get prepMade => 'செய்தது';

  @override
  String get prepUnit => 'அலகு';

  @override
  String get prepAdd => 'பட்டியலில் சேர்';

  @override
  String prepShort(String qty) {
    return '$qty குறைவு';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$planned $unitல் $made';
  }

  @override
  String get prepSeedMilk => 'பால்';

  @override
  String get prepSeedBatter => 'மாவு';

  @override
  String get prepSeedSnacks => 'பலகாரம்';

  @override
  String get prepSeedChange => 'சில்லறை';

  @override
  String get prepSeedDisplay => 'காட்சி அமைப்பு';

  @override
  String get prepSeedStock => 'அடுக்கு நிரப்பு';

  @override
  String get prepUnitLitre => 'லிட்டர்';

  @override
  String get prepUnitPlate => 'தட்டு';

  @override
  String get prepUnitPiece => 'எண்ணிக்கை';

  @override
  String get prepUnitRupee => 'ரூபாய்';

  @override
  String get insightsRush => 'கூட்ட நேரம்';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return '$hour:00 மணிக்கு $bills பில் — கவுண்டரில் $staff பேர் இருக்கட்டும்';
  }

  @override
  String get dayCloseOpeningCash => 'தொடக்க ரொக்கம்';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item தீர்ந்தது எனக் குறிக்கப்பட்டது';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item மீண்டும் விற்பனையில்';
  }

  @override
  String get insightsHeroes => 'இன்றைய சிறந்த பொருட்கள்';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold விற்பனை · $left மீதம்';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return '$hour:00 மணிக்கு தீர்ந்துவிடும்';
  }

  @override
  String get customerLapsedTitle => 'சமீபத்தில் வரவில்லை';

  @override
  String get customerLapsedHint =>
      'ஒரு சிறு செய்தி அவர்களை மீண்டும் கொண்டு வரும்.';

  @override
  String customerLapsedDays(String days) {
    return 'கடைசி வருகைக்குப் பிறகு $days நாட்கள்';
  }

  @override
  String get customerNudge => 'செய்தி அனுப்பு';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'வணக்கம் $name, $shop கடையில் உங்களை மிஸ் செய்கிறோம்! இந்த வாரம் புதிதாக ஒன்று காத்திருக்கிறது.';
  }

  @override
  String get offersTitle => 'சலுகைகள்';

  @override
  String get offersSubtitle =>
      'நீங்கள் தரும் தள்ளுபடிகளும், அவை உங்களுக்கு ஆகும் செலவும்.';

  @override
  String get offerAdd => 'சலுகை சேர்';

  @override
  String get offerName => 'சலுகைப் பெயர்';

  @override
  String get offerCode => 'வாடிக்கையாளர் சொல்லும் குறியீடு (விருப்பம்)';

  @override
  String get offerKindFlat => 'ரூபாய் தள்ளுபடி';

  @override
  String get offerKindPercent => 'சதவீதத் தள்ளுபடி';

  @override
  String get offerKindCombo => 'கூட்டு விலை';

  @override
  String get offerAmount => 'தள்ளுபடித் தொகை';

  @override
  String get offerPercent => 'தள்ளுபடி சதவீதம்';

  @override
  String get offerComboPrice => 'கூட்டு விலை';

  @override
  String get offersGivenTotal => 'இதுவரை தந்தது';

  @override
  String get offersEmpty =>
      'சலுகை எதுவும் இல்லை. சேர்த்தால் பில்லில் தெரியும்.';

  @override
  String get offerLive => 'இயங்குகிறது';

  @override
  String get offerPaused => 'நிறுத்தப்பட்டது';

  @override
  String get offerPause => 'நிறுத்து';

  @override
  String get offerResume => 'மீண்டும் இயக்கு';

  @override
  String offerUsed(String count) {
    return '$count முறை பயன்படுத்தப்பட்டது';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount தள்ளுபடி தரப்பட்டது';
  }

  @override
  String get feedbackTitle => 'பில் கருத்து';

  @override
  String get feedbackSubtitle =>
      'பணம் கட்டியதும் மூன்று தட்டல் மதிப்பீடு, நேரடியாக உங்களுக்கு.';

  @override
  String get feedbackQrTitle => 'கவுன்டர் QR';

  @override
  String get feedbackQrHint =>
      'இதை அச்சிட்டு கவுன்டரில் வையுங்கள், அல்லது பணம் கட்டியதும் காட்டுங்கள்.';

  @override
  String get feedbackReviewMissing =>
      'வளர்ச்சி பக்கத்தில் விமர்சன இணைப்பைச் சேர்த்தால், மகிழ்ந்தவர்கள் பொதுவில் எழுதலாம்.';

  @override
  String get feedbackLinkCopied => 'இணைப்பு நகலெடுக்கப்பட்டது';

  @override
  String get feedbackScores => 'மதிப்பெண்கள்';

  @override
  String get feedbackTodayAvg => 'இன்று (சராசரி · எண்ணிக்கை)';

  @override
  String get feedbackWeekAvg => 'கடந்த 7 நாட்கள் (சராசரி · எண்ணிக்கை)';

  @override
  String get feedbackNeedsReply => 'பதில் தேவை';

  @override
  String get feedbackRecord => 'நீங்களே மதிப்பீடு சேர்க்க';

  @override
  String get feedbackHappy => 'நல்லது';

  @override
  String get feedbackOkay => 'பரவாயில்லை';

  @override
  String get feedbackUnhappy => 'சரியில்லை';

  @override
  String get feedbackRecent => 'சமீபத்திய மதிப்பீடுகள்';

  @override
  String get feedbackEmpty => 'இன்னும் மதிப்பீடு இல்லை.';

  @override
  String get enquiriesTitle => 'விசாரணைகள்';

  @override
  String get enquiriesSubtitle =>
      'யார் கேட்டார்கள், என்ன விலை சொன்னீர்கள், என்ன ஆனது.';

  @override
  String get enquiryAdd => 'விசாரணை சேர்';

  @override
  String get enquiryName => 'வாடிக்கையாளர் பெயர்';

  @override
  String get enquiryPhone => 'தொலைபேசி';

  @override
  String get enquiryWant => 'என்ன கேட்டார்கள்';

  @override
  String get enquiryQuote => 'நீங்கள் சொன்ன விலை';

  @override
  String get enquiryNoFollowUp => 'நினைவூட்டல் வேண்டாம்';

  @override
  String enquiryFollowUpDays(String days) {
    return '$days நாட்களில் தொடர்பு கொள்';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% விற்பனையாக மாறுகிறது';
  }

  @override
  String get enquiryWonValue => 'வென்ற மதிப்பு';

  @override
  String get enquiryFilterToday => 'இன்று';

  @override
  String get enquiryFilterOpen => 'நிலுவை';

  @override
  String get enquiryFilterWon => 'வென்றது';

  @override
  String get enquiryFilterLost => 'தவறியது';

  @override
  String get enquiryEmpty => 'இங்கே எதுவும் இல்லை.';

  @override
  String enquiryFollowUpOn(String day) {
    return '$day அன்று தொடர்பு கொள்';
  }

  @override
  String get enquiryMessage => 'செய்தி';

  @override
  String enquiryMessageText(String name, String item) {
    return 'வணக்கம் $name, $item பற்றி கேட்டீர்களே. தயார் செய்து வைக்கவா?';
  }

  @override
  String get enquiryWon => 'வென்றது';

  @override
  String get enquiryLost => 'தவறியது';

  @override
  String get enquiryReopen => 'மீண்டும் திற';

  @override
  String get customerRewardsDueTitle => 'பரிசு நிலுவை';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'அந்த இணைப்பு பெயர் ஏற்கனவே உள்ளது. $slug போன்று ஒன்றை முயற்சி செய்யுங்கள்.';
  }

  @override
  String get cloudShopSlugInvalid =>
      'சிறிய எழுத்து, எண், கோடு மட்டும்; குறைந்தது 3 எழுத்து.';

  @override
  String get cloudShopOffline =>
      'இணையம் இல்லை. இணைப்பை சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get cloudShopTryAgain =>
      'முடியவில்லை. சிறிது நேரம் கழித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get cloudShopLinkTitle => 'வாடிக்கையாளர் இணைப்பு';

  @override
  String get cloudShopCopyLink => 'இணைப்பை நகலெடு';

  @override
  String get cloudShopLinkCopied => 'இணைப்பு நகலெடுக்கப்பட்டது';

  @override
  String get cloudShopShowQr => 'QR காட்டு';

  @override
  String get paymentQrScanTitle => 'உங்கள் பேமெண்ட் ஆப் QR';

  @override
  String get paymentQrScanAction => 'என் QR-ஐ ஸ்கேன் செய்';

  @override
  String get paymentQrScanHelp =>
      'GPay, PhonePe அல்லது Paytm QR ஸ்டிக்கரை கேமராவில் காட்டுங்கள். அதிலிருந்து UPI ஐடி எடுக்கப்படும்.';

  @override
  String paymentQrScanFound(String vpa) {
    return 'QR-இல் இருந்து எடுக்கப்பட்ட UPI ஐடி: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'இது பேமெண்ட் QR அல்ல. உங்கள் பேமெண்ட் ஆப்பில் உள்ள QR-ஐ முயற்சிக்கவும்.';

  @override
  String get receiptFeedbackLine =>
      'எப்படி இருந்தது என்று சொல்ல ஸ்கேன் செய்யவும்';

  @override
  String get qrPrintCounterCard => 'கவுண்டர் கார்டை அச்சிடு';

  @override
  String get qrPayCaption => 'பணம் செலுத்த ஸ்கேன் செய்யவும்';

  @override
  String get qrFeedbackCaption => 'கருத்து சொல்ல ஸ்கேன் செய்யவும்';

  @override
  String get offerPrintCards => 'ஆஃபர் கார்டுகளை அச்சிடு';

  @override
  String get offerCardCaption => 'இந்த ஆஃபரை பார்க்க ஸ்கேன் செய்யவும்';

  @override
  String get devicesPairQrHint => 'புதிய போனில் இதை ஸ்கேன் செய்யுங்கள்';

  @override
  String get devicesScanQr => 'இணைப்பு QR ஸ்கேன்';

  @override
  String get devicesScanInvalid =>
      'இது இணைப்பு QR அல்ல. உரிமையாளரிடம் மீண்டும் காட்டச் சொல்லுங்கள்.';

  @override
  String get quickSaleScan => 'பொருளை ஸ்கேன் செய்';

  @override
  String get quickSaleScanTitle => 'பொருள் லேபிளை ஸ்கேன் செய்யுங்கள்';

  @override
  String quickSaleScanUnknown(String code) {
    return '$code குறியீட்டுக்கு பொருள் இல்லை. பொருட்களில் சேர்க்கவும்.';
  }

  @override
  String get backupTitle => 'காப்பு & ஏற்றுமதி';

  @override
  String get backupSubtitle => 'உங்கள் கணக்கின் நகலை பத்திரமாக வையுங்கள்';

  @override
  String get backupNowAction => 'இப்போது காப்பு எடு';

  @override
  String get backupRestoreAction => 'கோப்பிலிருந்து மீட்டெடு';

  @override
  String get backupShareSubject => 'VendorOS காப்பு';

  @override
  String get backupSavedToast => 'காப்பு கோப்பு உருவாக்கப்பட்டது';

  @override
  String get backupFailedToast =>
      'காப்பு எடுக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get backupRestoredToast => 'உங்கள் கணக்குகள் மீட்டெடுக்கப்பட்டன';

  @override
  String get backupNeverSaved => 'இதுவரை காப்பு எடுக்கவில்லை';

  @override
  String backupLastSaved(String when) {
    return 'கடைசி காப்பு: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'சுமார் $kb KB சேமிக்கப்படும்';
  }

  @override
  String get backupRestoreWarning =>
      'மீட்டெடுத்தால் இந்த தொலைபேசியில் உள்ள அனைத்தும் கோப்பால் மாற்றப்படும்.';

  @override
  String get backupRestoreConfirmTitle => 'இந்த காப்பை மீட்டெடுக்கவா?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$when தேதியிலிருந்து $rows பதிவுகள் இந்த தொலைபேசியில் உள்ளதை மாற்றும்.';
  }

  @override
  String get backupErrorNotFile => 'இது VendorOS காப்பு கோப்பு அல்ல.';

  @override
  String get backupErrorTooNew =>
      'இந்த காப்பு புதிய பதிப்பிலிருந்து வந்தது. முதலில் செயலியை புதுப்பிக்கவும்.';

  @override
  String get backupErrorCorrupt => 'இந்த காப்பு கோப்பு சேதமடைந்துள்ளது.';

  @override
  String get backupErrorEmpty => 'கோப்பு காலியாக உள்ளது.';

  @override
  String get exportGroupLabel => 'விரிதாளாக ஏற்றுமதி';

  @override
  String get exportSalesTitle => 'விற்பனை';

  @override
  String get exportSalesSubtitle => 'தேதி, பொருள், தொகையுடன் ஒவ்வொரு விற்பனை';

  @override
  String get exportBillsTitle => 'பில்கள்';

  @override
  String get exportBillsSubtitle => 'பில் வாரியாக மொத்தம், தள்ளுபடி, வரி';

  @override
  String get exportCreditTitle => 'கடன் இருப்பு';

  @override
  String get exportCreditSubtitle => 'யார் எவ்வளவு தர வேண்டும்';

  @override
  String get exportStockTitle => 'இருப்பு';

  @override
  String get exportStockSubtitle => 'பொருட்கள், இருப்பு அளவு, விலைகள்';

  @override
  String get exportColDate => 'தேதி';

  @override
  String get exportColItem => 'பொருள்';

  @override
  String get exportColMode => 'பணம்';

  @override
  String get exportColCustomer => 'வாடிக்கையாளர்';

  @override
  String get exportColAmount => 'தொகை';

  @override
  String get exportColBillNo => 'பில் எண்';

  @override
  String get exportColSubtotal => 'கூட்டுத்தொகை';

  @override
  String get exportColDiscount => 'தள்ளுபடி';

  @override
  String get exportColTax => 'வரி';

  @override
  String get exportColTotal => 'மொத்தம்';

  @override
  String get exportColPayment => 'செலுத்திய முறை';

  @override
  String get exportColStatus => 'நிலை';

  @override
  String get exportColBalance => 'இருப்பு';

  @override
  String get exportColCode => 'குறியீடு';

  @override
  String get exportColCategory => 'வகை';

  @override
  String get exportColUnit => 'அலகு';

  @override
  String get exportColQty => 'அளவு';

  @override
  String get exportColCost => 'செலவு';

  @override
  String get exportColPrice => 'விலை';

  @override
  String get gstReportTitle => 'ஜிஎஸ்டி சுருக்கம்';

  @override
  String get gstReportSubtitle => 'கணக்கருக்கான மாத வாரி வரி';

  @override
  String get gstReportEmpty =>
      'இன்னும் ஜிஎஸ்டி பில் இல்லை. மெனு அமைப்பில் ஜிஎஸ்டியை இயக்கி ஒரு பொருளை பில் செய்யுங்கள்.';

  @override
  String get gstColMonth => 'மாதம்';

  @override
  String get gstColRate => 'வீதம்';

  @override
  String get gstColTaxable => 'வரிக்குரிய தொகை';

  @override
  String get gstColTax => 'மொத்த வரி';

  @override
  String get gstBills => 'பில்கள்';

  @override
  String get gstSales => 'வரியுடன் விற்பனை';

  @override
  String get gstByRate => 'வீதம் வாரியாக';

  @override
  String get gstShareAction => 'விரிதாளை பகிர்';

  @override
  String gstShareSubject(String month) {
    return 'ஜிஎஸ்டி சுருக்கம் $month';
  }

  @override
  String get appearanceTitle => 'தோற்றம்';

  @override
  String get appearanceSubtitle => 'வெளிச்சம் அல்லது இருள் திரை';

  @override
  String get appearanceSystem => 'போனைப் பின்பற்று';

  @override
  String get appearanceLight => 'வெளிச்சம்';

  @override
  String get appearanceDark => 'இருள்';

  @override
  String get appearanceChanged => 'தோற்றம் மாற்றப்பட்டது';

  @override
  String get purchasesTitle => 'கொள்முதல்';

  @override
  String get purchasesSubtitle =>
      'சப்ளையர் பில்கள் மற்றும் நீங்கள் தர வேண்டியது';

  @override
  String get purchasesEmpty =>
      'இன்னும் கொள்முதல் பில் இல்லை. கடைசியாக வாங்கிய சரக்கைச் சேர்க்கவும்.';

  @override
  String get purchaseAdd => 'கொள்முதல் சேர்';

  @override
  String get purchaseTotalDue => 'சப்ளையருக்குத் தர வேண்டியது';

  @override
  String get purchaseMonthSpend => 'இந்த மாதம் வாங்கியது';

  @override
  String get purchaseDuesTitle => 'சப்ளையர் பாக்கி';

  @override
  String get purchaseNoDues => 'அனைத்து சப்ளையர் பில்களும் செலுத்தப்பட்டன.';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills பில் · பழையது $days நாள்';
  }

  @override
  String get purchaseBillsTitle => 'கொள்முதல் பில்கள்';

  @override
  String get purchasePaidFull => 'செலுத்தப்பட்டது';

  @override
  String purchaseDueOf(String amount) {
    return '$amount பாக்கி';
  }

  @override
  String get purchaseSupplier => 'சப்ளையர்';

  @override
  String purchasePayTitle(String name) {
    return '$name க்குச் செலுத்து';
  }

  @override
  String get purchasePayAmount => 'செலுத்திய தொகை';

  @override
  String get purchasePay => 'பணம் பதிவு செய்';

  @override
  String get purchaseSubtotal => 'பொருள் மொத்தம்';

  @override
  String get purchaseTax => 'வரி';

  @override
  String get purchaseTotal => 'பில் மொத்தம்';

  @override
  String get purchaseDue => 'இன்னும் பாக்கி';

  @override
  String get purchaseNewTitle => 'புதிய கொள்முதல் பில்';

  @override
  String get purchaseInvoiceNo => 'பில் எண்';

  @override
  String get purchaseItems => 'வாங்கிய பொருட்கள்';

  @override
  String get purchaseLinkProduct => 'உங்கள் சரக்குப் பட்டியலில் இருந்து தேர்வு';

  @override
  String get purchaseFreeItem => 'பொருள் பெயர்';

  @override
  String get purchaseQty => 'அளவு';

  @override
  String get purchaseUnitCost => 'ஒரு யூனிட் விலை';

  @override
  String get purchaseAddLine => 'பொருள் சேர்';

  @override
  String get purchasePaidNow => 'இப்போது செலுத்தியது';

  @override
  String get purchaseNote => 'குறிப்பு';

  @override
  String get purchaseSaved =>
      'கொள்முதல் சேமிக்கப்பட்டது, சரக்கு புதுப்பிக்கப்பட்டது';

  @override
  String get permRecordPurchase => 'கொள்முதல் பில் பதிவு';

  @override
  String get permPaySupplier => 'சப்ளையருக்குச் செலுத்துதல்';

  @override
  String get backupCloudTitle => 'இணையக் காப்புப் பிரதி';

  @override
  String backupCloudLast(String when) {
    return 'கடைசி இணையக் காப்பு: $when';
  }

  @override
  String get backupCloudNever => 'இன்னும் இணையத்தில் சேமிக்கப்படவில்லை';

  @override
  String get backupCloudNeedsShop => 'முதலில் கிளவுட் கடையை உருவாக்குங்கள்';

  @override
  String get backupCloudNowAction => 'இப்போது இணையத்தில் காப்பு எடு';

  @override
  String get backupCloudRestoreAction => 'இணையத்திலிருந்து மீட்டெடு';

  @override
  String get backupCloudSavedToast => 'இணையத்தில் சேமிக்கப்பட்டது';

  @override
  String get backupCloudFailedToast =>
      'இணையத்தில் சேமிக்க முடியவில்லை. சிக்னல் வரும்போது மீண்டும் முயற்சிக்கவும்.';

  @override
  String get billWhatsapp => 'வாட்ஸ்ஆப்பில் அனுப்பு';

  @override
  String get billWhatsappFailed => 'இந்த ஃபோனில் வாட்ஸ்ஆப் இல்லை.';

  @override
  String get devicesStaffRole => 'பணிப் பொறுப்பு';

  @override
  String get devicesRoleDefault => 'இயல்பு (வேலை மட்டும்)';

  @override
  String get devicesRolePick => 'ஒரு பணிப் பொறுப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get devicesRoleSaved => 'பொறுப்பு அந்த ஃபோனுக்கு அனுப்பப்பட்டது';

  @override
  String get devicesRoleFailed =>
      'பொறுப்பை அமைக்க முடியவில்லை. இணையம் வந்ததும் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get adminTitle => 'உரிமையாளர் அறிக்கைகள்';

  @override
  String get adminSubtitle =>
      'என்ன நடந்தது, யார் செய்தார்கள், பணம் சரியாக இருந்ததா';

  @override
  String get adminExceptionsTitle => 'விதிவிலக்குகள்';

  @override
  String get adminExceptionsSubtitle =>
      'தள்ளுபடி, ரத்து செய்த பில், மறுபதிவு, கடன்';

  @override
  String get adminStaffTitle => 'பணியாளர் அறிக்கை';

  @override
  String get adminStaffSubtitle =>
      'இந்த காலத்தில் ஒவ்வொருவரும் என்ன செய்தார்கள்';

  @override
  String get adminCashTitle => 'பணப் புத்தகம்';

  @override
  String get adminCashSubtitle => 'எதிர்பார்த்ததும் எண்ணியதும், நாள்தோறும்';

  @override
  String get adminItemsTitle => 'பொருள் இடைவெளி';

  @override
  String get adminItemsSubtitle => 'விற்றதும் இருப்பிலிருந்து எடுத்ததும்';

  @override
  String get adminShopsTitle => 'எல்லா கடைகளும்';

  @override
  String get adminShopsSubtitle => 'நீங்கள் நடத்தும் ஒவ்வொரு கடையின் மொத்தம்';

  @override
  String get adminSummaryTitle => 'இன்றைய சுருக்கம்';

  @override
  String get adminSummarySend => 'சுருக்கத்தை அனுப்பு';

  @override
  String get adminShare => 'பகிர்';

  @override
  String get adminNoRows => 'இந்த காலத்திற்கு எதுவும் இல்லை';

  @override
  String get adminFromBill => 'பில்லிலிருந்து';

  @override
  String get adminOwnerApproved => 'உரிமையாளர் ஒப்புதல்';

  @override
  String get adminColActions => 'செயல்கள்';

  @override
  String get adminColDiscount => 'கொடுத்த தள்ளுபடி';

  @override
  String get adminColCredit => 'கொடுத்த கடன்';

  @override
  String get adminColVoids => 'ரத்து செய்த பில்';

  @override
  String get adminColReprints => 'மறுபதிவுகள்';

  @override
  String get adminColOverrides => 'உரிமையாளர் ஒப்புதல்கள்';

  @override
  String get adminSeeExceptions => 'இவரின் விதிவிலக்குகளைப் பார்';

  @override
  String get adminCashOpening => 'தொடக்க பணம்';

  @override
  String get adminCashExpected => 'எதிர்பார்த்தது';

  @override
  String get adminCashCounted => 'எண்ணியது';

  @override
  String get adminCashShort => 'குறைவு';

  @override
  String get adminCashOver => 'அதிகம்';

  @override
  String get adminCashNet => 'நிகர வித்தியாசம்';

  @override
  String get adminCashMatched => 'சரியான நாட்கள்';

  @override
  String get adminCashMatchedOne => 'சரி';

  @override
  String get adminCashShortDays => 'குறைவான நாட்கள்';

  @override
  String get adminItemSold => 'விற்றது';

  @override
  String get adminItemStockOut => 'இருப்பிலிருந்து எடுத்தது';

  @override
  String get adminItemGap => 'இடைவெளி';

  @override
  String get adminItemWasted => 'வீணானது';

  @override
  String get adminSummaryBills => 'பில்கள்';

  @override
  String get adminSummarySales => 'விற்பனை';

  @override
  String get adminSummaryCash => 'பணம்';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'கடன்';

  @override
  String get adminSummaryDiscount => 'தள்ளுபடிகள்';

  @override
  String get adminSummarySpend => 'செலவு';

  @override
  String get adminSummaryCashDiff => 'பண வித்தியாசம்';

  @override
  String get adminSummaryTop => 'அதிகம் விற்றவை';

  @override
  String get adminShopsAllTotal => 'எல்லா கடைகளும் சேர்ந்து';

  @override
  String get adminShopsOrders => 'ஆர்டர்கள் (7 நாட்கள்)';

  @override
  String get adminShopsValue => 'மதிப்பு (7 நாட்கள்)';

  @override
  String get adminShopsAdd => 'இன்னொரு கடையைச் சேர்';

  @override
  String get adminShopsAddHelp =>
      'மற்ற கடையின் இணைப்புப் பெயரையும் உரிமையாளர் சாவியையும் தட்டச்சு செய்யவும்.';

  @override
  String get adminShopsAddAction => 'கடையைச் சேர்';

  @override
  String get adminShopsSlug => 'கடை இணைப்புப் பெயர்';

  @override
  String get adminShopsKey => 'உரிமையாளர் சாவி';

  @override
  String get adminShopsRemove => 'நீக்கு';

  @override
  String get adminShopsRefresh => 'புதுப்பி';

  @override
  String get adminShopsError => 'இந்த கடையைப் படிக்க முடியவில்லை';

  @override
  String get adminShopsInvalid =>
      'இணைப்புப் பெயரையும் உரிமையாளர் சாவியையும் சரிபார்க்கவும்';

  @override
  String get adminShopsExists => 'அந்த கடை ஏற்கனவே பட்டியலில் உள்ளது';

  @override
  String get permViewCashBook => 'பணப் புத்தகத்தைப் பார்';

  @override
  String get permExportData => 'தரவை ஏற்றுமதி செய்';

  @override
  String get permViewStaffReport => 'பணியாளர் அறிக்கைகளைப் பார்';
}
