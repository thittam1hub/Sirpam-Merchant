// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'నమస్కారం $name, $stall వద్ద మీ బాకీ Rs $amount. దయచేసి చెల్లించండి. ధన్యవాదాలు.$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navUdhaar => 'అప్పు';

  @override
  String get navSoundbox => 'సౌండ్';

  @override
  String get navMandi => 'మార్కెట్';

  @override
  String get navSales => 'అమ్మకాలు';

  @override
  String get navGroupOverview => 'ఓవర్‌వ్యూ';

  @override
  String get navGroupSell => 'అమ్మకం';

  @override
  String get navGroupOperations => 'కస్టమర్లు & పనులు';

  @override
  String get navGroupBusiness => 'వ్యాపారం';

  @override
  String get navGroupTeam => 'టీమ్';

  @override
  String get navGroupSystem => 'సిస్టమ్';

  @override
  String get moreLabel => 'మరిన్ని';

  @override
  String get menuLoanReport => 'లోన్ రిపోర్ట్';

  @override
  String get menuCartLocation => 'బండి లొకేషన్';

  @override
  String get menuSettings => 'సెట్టింగ్స్';

  @override
  String get notFoundTitle => 'పేజీ దొరకలేదు';

  @override
  String get goHome => 'హోమ్‌కి వెళ్లండి';

  @override
  String get ok => 'సరే';

  @override
  String get loading => 'లోడ్ అవుతోంది…';

  @override
  String storageWriteFailedKey(String key) {
    return 'సేవ్ కాలేదు ($key) — మళ్లీ ప్రయత్నించండి';
  }

  @override
  String get storageWriteFailed => 'సేవ్ కాలేదు — మళ్లీ ప్రయత్నించండి';

  @override
  String get micUnavailable =>
      'మైక్రోఫోన్ పని చేయడం లేదు — చేత్తో ఎంటర్ చేయండి';

  @override
  String get voiceNothingHeard => 'ఏమీ వినిపించలేదు — మళ్లీ మాట్లాడండి';

  @override
  String get voiceNoAmount =>
      'మొత్తం వినిపించలేదు — \"50 రూపాయల టమాటా\" అని చెప్పండి';

  @override
  String get voiceZeroAmount => 'మొత్తం సున్నా కాకూడదు';

  @override
  String get modeCash => 'నగదు';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'అప్పు';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount నమోదైంది';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'ఈరోజు మొత్తం వ్యాపారం $amount రూపాయలు';
  }

  @override
  String get todayCollection => 'ఈరోజు కలెక్షన్';

  @override
  String get quickEntry => 'క్విక్ ఎంట్రీ';

  @override
  String get todayEntries => 'ఈరోజు ఎంట్రీలు';

  @override
  String get noEntriesYet => 'ఇంకా ఎంట్రీలు లేవు — మైక్ నొక్కి మాట్లాడండి';

  @override
  String get listeningTapToStop => 'వింటోంది, ఆపడానికి నొక్కండి';

  @override
  String get tapToSpeak => 'రికార్డ్ చేయడానికి మాట్లాడండి';

  @override
  String get listening => 'వింటోంది…';

  @override
  String get speakToRecord => '🎙️ రికార్డ్ చేయడానికి మాట్లాడండి';

  @override
  String get voiceHint => '\"50 రూపాయలు టమాటా క్యాష్\" / \"రవి కి 200 అప్పు\"';

  @override
  String get addSale => 'సేల్ జోడించండి';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount రూపాయలు, $item';
  }

  @override
  String get delete => 'డిలీట్';

  @override
  String get locationServiceOff => 'లొకేషన్ సర్వీస్ ఆఫ్ చేయబడింది';

  @override
  String get locationPermissionDenied => 'లొకేషన్ పర్మిషన్ ఇవ్వలేదు';

  @override
  String get broadcastLive => 'లైవ్ షేరింగ్ అవుతోంది';

  @override
  String get locationSearching => 'లొకేషన్ వెతుకుతోంది…';

  @override
  String get permissionDenied => 'పర్మిషన్ ఇవ్వలేదు';

  @override
  String get unavailable => 'అందుబాటులో లేదు';

  @override
  String get broadcastStopped => 'షేరింగ్ ఆగిపోయింది';

  @override
  String get locationNotFetched => 'లొకేషన్ ఇంకా అందలేదు';

  @override
  String get stopBroadcast => 'షేరింగ్ ఆపండి';

  @override
  String get startBroadcast => 'షేరింగ్ ప్రారంభించండి';

  @override
  String get sendToCustomer => 'కస్టమర్లకు పంపండి';

  @override
  String get shareLocationHint => 'ఈరోజు బండి లొకేషన్ WhatsAppలో షేర్ చేయండి.';

  @override
  String get ourCart => 'మన బండి';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall ఈరోజు ఇక్కడ ఉంది 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'WhatsAppలో షేర్ చేయండి';

  @override
  String get openInMaps => 'Mapsలో చూడండి';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in రిక్వెస్ట్‌ను తిరస్కరించింది — API కీ సరిచూసుకోండి ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'కనెక్షన్ విఫలమైంది: $error';
  }

  @override
  String get mandiTitle => 'మార్కెట్ ధరలు';

  @override
  String get refresh => 'రీఫ్రెష్';

  @override
  String get mandiLoading => 'మార్కెట్ ధరలు లోడ్ అవుతున్నాయి';

  @override
  String get fetchFailed => 'డేటా రావడం లేదు';

  @override
  String get apiKeyNeeded => 'data.gov.in API కీ అవసరం';

  @override
  String get apiKeyNeededBody =>
      'లైవ్ APMC ధరల కోసం ఉచిత data.gov.in API కీని సెట్టింగ్స్‌లో జోడించండి. నకిలీ ధరలు చూపబడవు.';

  @override
  String get refreshFailed => 'రీఫ్రెష్ కాలేదు';

  @override
  String lastUpdated(String time) {
    return 'చివరి అప్‌డేట్: $time';
  }

  @override
  String get searchVegetable => 'కూరగాయను వెతకండి';

  @override
  String get loanReportHeading => 'వ్యాపార లోన్ రిపోర్ట్';

  @override
  String reportFailed(String error) {
    return 'రిపోర్ట్ రాలేదు: $error';
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
      other: '$daysString రోజులు',
      one: '1 రోజు',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'మొత్తం వ్యాపారం';

  @override
  String get digitalShare => 'డిజిటల్ వాటా';

  @override
  String get avgDailyIncome => 'సగటు రోజువారీ ఆదాయం';

  @override
  String get recordedDays => 'నమోదైన రోజులు';

  @override
  String get sha256Checksum => 'SHA-256 చెక్‌సమ్';

  @override
  String get noSalesYet =>
      'ఇంకా ఎలాంటి సేల్స్ నమోదు కాలేదు — రిపోర్ట్ కోసం మొదట సేల్స్ నమోదు చేయండి.';

  @override
  String get viewPdf => 'PDF చూడండి';

  @override
  String get sendToBank => 'బ్యాంకుకు పంపండి';

  @override
  String get stallName => 'స్టాల్ పేరు';

  @override
  String get ownerName => 'యజమాని పేరు';

  @override
  String get upiVpaLabel => 'UPI VPA (ఉదా. name@okaxis)';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get mandiMarket => 'మార్కెట్ (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API కీ';

  @override
  String get apiKeyHelp =>
      'కీ కోసం data.gov.in లో ఉచితంగా రిజిస్టర్ అవ్వండి. కీ లేకపోతే తాజా ధరలు కనిపించవు.';

  @override
  String get soundboxAnnounce => 'సౌండ్‌బాక్స్ ప్రకటనలు';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String soundboxSpeech(String amount) {
    return '$amount రూపాయలు వచ్చాయి';
  }

  @override
  String get soundboxTitle => 'సౌండ్‌బాక్స్';

  @override
  String get soundboxSubtitle => 'UPI పేమెంట్లు మీ భాషలోనే వినిపిస్తాయి';

  @override
  String get watchedApps => 'ట్రాక్ చేసే యాప్‌లు';

  @override
  String get soundboxTestHint =>
      'టెస్ట్: \"250 రూపాయలు వచ్చాయి\" అని వినిపిస్తుంది';

  @override
  String get speak => 'వినిపించండి';

  @override
  String get announcedPayments => 'ప్రకటించిన పేమెంట్లు';

  @override
  String get noUpiYet => 'ఇంకా UPI పేమెంట్లు ఏవీ రాలేదు';

  @override
  String get soundboxRunning => 'సౌండ్‌బాక్స్ నడుస్తోంది';

  @override
  String get notificationAccessNeeded => 'నోటిఫికేషన్ పర్మిషన్ అవసరం';

  @override
  String get soundboxAndroidHint =>
      'PhonePe, Paytm, Google Pay మరియు BHIM ద్వారా వచ్చే పేమెంట్లు ఆటోమేటిక్‌గా వినిపిస్తాయి.';

  @override
  String get soundboxGrantHint =>
      'Android సెట్టింగ్స్‌లో VendorOSకి నోటిఫికేషన్ పర్మిషన్ ఇవ్వండి.';

  @override
  String get grantAccess => 'పర్మిషన్ ఇవ్వండి';

  @override
  String get iosUnavailable => 'iOSలో అందుబాటులో లేదు';

  @override
  String get webUnavailable => 'బ్రౌజర్‌లో అందుబాటులో లేదు';

  @override
  String get iosSoundboxNote =>
      'Apple నిబంధనల వల్ల ఇతర యాప్‌ల నోటిఫికేషన్లు చదవలేము. మాన్యువల్ లేదా వాయిస్ ఎంట్రీ మాత్రమే.';

  @override
  String get webSoundboxNote =>
      'బ్రౌజర్ ఇతర యాప్‌ల UPI నోటిఫికేషన్లను చదవలేదు. సౌండ్‌బాక్స్ కోసం Android యాప్ ఇన్‌స్టాల్ చేసుకోండి.';

  @override
  String get serverSoundbox => 'బిజినెస్ UPI సౌండ్‌బాక్స్';

  @override
  String get serverSoundboxNote =>
      'మీ పేమెంట్ ప్రొవైడర్ నిర్ధారించిన పేమెంట్లు ఇక్కడ వినిపిస్తాయి. ఏదీ మిస్ అవ్వదు: ఈ ఫోన్ వినిపించేంత వరకు పేమెంట్ సర్వర్‌లో వేచి ఉంటుంది.';

  @override
  String get notPaired => 'ఈ ఫోన్ ఇంకా బిజినెస్ UPI ఖాతాకు లింక్ కాలేదు.';

  @override
  String get pairingCode => 'పేరింగ్ కోడ్';

  @override
  String get pair => 'ఫోన్ లింక్ చేయండి';

  @override
  String get unpair => 'లింక్ తీసివేయండి';

  @override
  String pairedWith(String name) {
    return '$nameకి లింక్ చేయబడింది';
  }

  @override
  String get syncNow => 'ఇప్పుడే చెక్ చేయండి';

  @override
  String lastChecked(String time) {
    return 'చివరిసారి $timeకి చెక్ చేసాము';
  }

  @override
  String get neverChecked => 'ఇంకా చెక్ చేయలేదు';

  @override
  String get soundboxStale =>
      'కొంతసేపటి నుండి సర్వర్‌తో కనెక్షన్ లేదు. ఇంటర్నెట్ సరిచూసుకోండి.';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ప్రకటించడానికి $countString పేమెంట్లు వేచి ఉన్నాయి',
      one: 'ప్రకటించడానికి 1 పేమెంట్ వేచి ఉంది',
      zero: 'ఏవీ వేచి లేవు',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'నోటిఫికేషన్ సౌండ్‌బాక్స్ (ఫాల్‌బ్యాక్)';

  @override
  String get udhaarTitle => 'ఉద్దెర ఖాతా';

  @override
  String get udhaarSubtitle => 'కస్టమర్ బకాయిలు';

  @override
  String get totalOutstanding => 'మొత్తం బకాయి';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString కస్టమర్లు',
      one: '1 కస్టమర్',
      zero: 'కస్టమర్లు లేరు',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'ఫిల్టర్: $name';
  }

  @override
  String get clearFilter => 'ఫిల్టర్ తీసివేయి';

  @override
  String get upiSetupHint =>
      'UPI కోసం సెట్టింగ్స్‌లో మీ VPA మరియు దుకాణం పేరును జోడించండి.';

  @override
  String get noOutstanding => 'బకాయిలు ఏమీ లేవు';

  @override
  String cannotOpen(String scheme) {
    return 'ఓపెన్ కాలేదు: $scheme';
  }

  @override
  String get askUpi => 'UPI అడగండి';

  @override
  String get collect => 'వసూలు';

  @override
  String get cancel => 'రద్దు';

  @override
  String get language => 'భాష';

  @override
  String get languageChanged => 'భాష మార్చబడింది';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return 'ఉద్దెర $name';
  }

  @override
  String get defaultStallName => 'VendorOS స్టాల్';

  @override
  String get merchantOnboardingTitle => 'బిజినెస్ UPI నమోదు చేయండి';

  @override
  String get merchantOnboardingSubtitle =>
      'మీ బిజినెస్ ఖాతాను సౌండ్‌బాక్స్‌కు లింక్ చేయండి';

  @override
  String get merchantStepsHint =>
      'మీ PhonePe for Business లేదా Paytm for Business డాష్‌బోర్డ్ వివరాలను ఎంటర్ చేయండి. మీకు పెయిరింగ్ కోడ్ వస్తుంది, వెంటనే ఈ ఫోన్ లింక్ అవుతుంది.';

  @override
  String get howToGetBusinessUpi => 'బిజినెస్ UPI ఖాతా ఎలా పొందాలి?';

  @override
  String get merchantFormIncomplete =>
      'బిజినెస్ పేరు, మర్చంట్ ఐడీ మరియు సీక్రెట్ కీ ఎంటర్ చేయండి.';

  @override
  String get merchantRegistered => 'వ్యాపారం నమోదైంది';

  @override
  String get pairingCodeSaveHint =>
      'ఈ పెయిరింగ్ కోడ్‌ను దాచుకోండి. రెండో ఫోన్‌ను లింక్ చేయడానికి దీన్ని వాడండి.';

  @override
  String get callbackUrlLabel => 'ప్రొవైడర్ డాష్‌బోర్డ్ కోసం Callback URL';

  @override
  String get backToSoundbox => 'తిరిగి సౌండ్‌బాక్స్‌కు';

  @override
  String get copy => 'కాపీ';

  @override
  String get copied => 'కాపీ అయింది';

  @override
  String get provider => 'పేమెంట్ ప్రొవైడర్';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'వ్యాపారం పేరు';

  @override
  String get businessNameHint =>
      'వాయిస్‌లో పలికే మరియు రిపోర్ట్‌లలో ప్రింట్ అయ్యే పేరు';

  @override
  String get businessVpa => 'బిజినెస్ UPI అడ్రస్';

  @override
  String get businessVpaHint => 'stallname@ybl';

  @override
  String get merchantIdLabel => 'మర్చంట్ ఐడీ (MID)';

  @override
  String get merchantIdHint => 'ప్రొవైడర్ డాష్‌బోర్డ్ నుండి';

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
      'Paytm డాష్‌బోర్డ్‌లో కూడా పేస్ట్ చేసే ఏదైనా బలమైన పాస్‌వర్డ్';

  @override
  String get secretStorageNote =>
      'సీక్రెట్ కీ సర్వర్‌లో మాత్రమే భద్రపరుచబడుతుంది, యాప్ దాన్ని ఎప్పటికీ తిరిగి చూపించదు.';

  @override
  String get registerBusiness => 'బిజినెస్ UPI రిజిస్టర్ చేయండి';

  @override
  String get helpTitle => 'సహాయం';

  @override
  String get helpSubtitle => 'బిజినెస్ UPI మరియు సౌండ్‌బాక్స్ గైడ్';

  @override
  String get helpWhyTitle => 'బిజినెస్ UPI ఖాతా ఎందుకు?';

  @override
  String get helpWhyBody =>
      'పర్సనల్ UPI ID పేమెంట్లను సర్వర్‌కు కన్ఫర్మ్ చేయలేదు, కాబట్టి సౌండ్‌బాక్స్ అనౌన్స్‌మెంట్లు మిస్ కావచ్చు. బిజినెస్ ఖాతా ప్రతి పేమెంట్‌ను VendorOSకి పంపుతుంది, కాబట్టి సౌండ్‌బాక్స్ ఏదీ మిస్ చేయదు.';

  @override
  String get helpDocsTitle => 'కావాల్సినవి';

  @override
  String get helpDocsAadhaar =>
      'ఆధార్ నంబర్ మరియు దానికి లింక్ చేసిన మొబైల్ నంబర్';

  @override
  String get helpDocsPan =>
      'పాన్ కార్డ్ (చిన్న దుకాణాలకు పర్సనల్ పాన్ సరిపోతుంది)';

  @override
  String get helpDocsBank =>
      'డబ్బులు జమ కావడానికి బ్యాంక్ ఖాతా నంబర్ మరియు IFSC';

  @override
  String get helpDocsShop => 'దుకాణం పేరు, అడ్రస్ మరియు దుకాణం ఫోటో';

  @override
  String get helpRegisterTitle => 'ప్రొవైడర్‌తో రిజిస్టర్ చేయండి';

  @override
  String get helpRegisterStep1 =>
      'Play Store నుండి PhonePe for Business లేదా Paytm for Business ఇన్‌స్టాల్ చేసుకోండి.';

  @override
  String get helpRegisterStep2 =>
      'మొబైల్ నంబర్‌తో సైన్ అప్ చేసి, ఆధార్ మరియు పాన్‌తో KYC పూర్తి చేయండి.';

  @override
  String get helpRegisterStep3 =>
      'డబ్బు జమ కావడానికి బ్యాంక్ ఖాతాను జోడించి, ఉచిత QR స్టిక్కర్ తీసుకోండి.';

  @override
  String get helpRegisterStep4 =>
      'యాప్‌లో కనిపించే బిజినెస్ UPI అడ్రస్ (ఉదాహరణకు stallname@ybl) నోట్ చేసుకోండి.';

  @override
  String get helpKeysTitle => 'Merchant ID మరియు సీక్రెట్ కీ';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: బిజినెస్ డాష్‌బోర్డ్ తెరిచి, Developer settingsకి వెళ్లి, merchant id, salt key మరియు salt index కాపీ చేయండి.';

  @override
  String get helpKeysPaytm =>
      'Paytm: బిజినెస్ డాష్‌బోర్డ్ తెరిచి, Developer settingsకి వెళ్లి, MID కాపీ చేయండి, అలాగే ఇక్కడ ఇచ్చే బలమైన webhook token రూపొందించండి.';

  @override
  String get helpKeysCallback =>
      'పేమెంట్లు VendorOSకి చేరేందుకు రిజిస్ట్రేషన్ తర్వాత కనిపించే కాల్‌బ్యాక్ URLను ప్రొవైడర్ డాష్‌బోర్డ్‌లో పేస్ట్ చేయండి.';

  @override
  String get helpLinkTitle => 'ఈ ఫోన్‌ను లింక్ చేయండి';

  @override
  String get helpLinkStep1 =>
      'Soundbox తెరిచి, \'బిజినెస్ UPI రిజిస్టర్ చేయండి\' పై నొక్కండి.';

  @override
  String get helpLinkStep2 =>
      'ఫారమ్ నింపండి; ఫోన్ ఆటోమేటిక్‌గా లింక్ అయ్యి పేరింగ్ కోడ్ కనిపిస్తుంది.';

  @override
  String get helpLinkStep3 =>
      'మరొక ఫోన్‌లో కూడా సౌండ్‌బాక్స్ తెరిచి, ఆ పేరింగ్ కోడ్ ఎంటర్ చేసి లింక్ చేయండి.';

  @override
  String get helpSafetyTitle => 'భద్రంగా ఉంచండి';

  @override
  String get helpSafetyBody =>
      'Salt key లేదా webhook token ఎవరితోనూ పంచుకోవద్దు. VendorOS దీన్ని సర్వర్‌లో మాత్రమే భద్రపరుస్తుంది, మళ్లీ ఎప్పటికీ చూపించదు.';

  @override
  String get menuInventory => 'స్టాక్';

  @override
  String get productsTitle => 'వస్తువులు';

  @override
  String get productsSubtitle => 'జాబితా మరియు స్టాక్';

  @override
  String get productsSearchHint => 'పేరు లేదా కోడ్ వెతకండి';

  @override
  String get productsEmpty =>
      'ఇంకా వస్తువులేవీ లేవు. మీ మొదటి ఐటెమ్‌ను జోడించండి.';

  @override
  String get productsAdd => 'వస్తువును జోడించండి';

  @override
  String get productsAllChip => 'అన్నీ';

  @override
  String get productsLowStockChip => 'తక్కువ స్టాక్';

  @override
  String get productEditTitle => 'వస్తువును సవరించండి';

  @override
  String get productMissing => 'ఈ ప్రోడక్ట్ లిస్ట్‌లో లేదు.';

  @override
  String get productSaved => 'సేవ్ అయ్యింది';

  @override
  String get productArchived => 'ప్రోడక్ట్ తీసేశారు';

  @override
  String get formInvalid => 'ప్రోడక్ట్ పేరు ఇవ్వండి';

  @override
  String get fieldName => 'పేరు';

  @override
  String get fieldLocalName => 'తమిళంలో పేరు';

  @override
  String get fieldCode => 'కోడ్';

  @override
  String get fieldCodeHint => 'బార్‌కోడ్, లేదా కొత్తదాని కోసం ఖాళీగా ఉంచండి';

  @override
  String get fieldCategory => 'కేటగిరీ';

  @override
  String get fieldUnit => 'యూనిట్';

  @override
  String get fieldCost => 'కొనుగోలు ధర';

  @override
  String get fieldPrice => 'అమ్మకం ధర';

  @override
  String get fieldReorder => 'రీఆర్డర్ లెవల్';

  @override
  String get saveLabel => 'సేవ్';

  @override
  String get discardTitle => 'మార్పులను రద్దు చేయాలా?';

  @override
  String get discardBody => 'సేవ్ చేయని మార్పులు ఉన్నాయి.';

  @override
  String get discardKeep => 'ఎడిట్ చేస్తూ ఉండండి';

  @override
  String get discardLeave => 'రద్దు చేయి';

  @override
  String get cancelLabel => 'రద్దు';

  @override
  String get deleteLabel => 'డిలీట్';

  @override
  String get confirmLabel => 'కన్ఫర్మ్';

  @override
  String get qtyLabel => 'క్వాంటిటీ';

  @override
  String get unitCostLabel => 'ఒక్కో యూనిట్ ధర';

  @override
  String get expiryLabel => 'ఎక్స్‌పైరీ (రోజుల్లో)';

  @override
  String get unitKg => 'కేజీ';

  @override
  String get unitGram => 'గ్రా';

  @override
  String get unitPiece => 'పీస్';

  @override
  String get unitLitre => 'లీటర్';

  @override
  String get unitBundle => 'కట్ట';

  @override
  String get detailSell => 'అమ్మకం';

  @override
  String get detailRestock => 'రీస్టాక్';

  @override
  String get detailWastage => 'వేస్టేజ్';

  @override
  String get detailCorrect => 'స్టాక్ లెక్క';

  @override
  String get detailBatches => 'బ్యాచ్‌లు';

  @override
  String get detailHistory => 'హిస్టరీ';

  @override
  String get detailLabel => 'లేబుల్ ప్రింట్';

  @override
  String get historyEmpty => 'ఇంకా స్టాక్ వివరాలేమీ లేవు';

  @override
  String get soldRecorded => 'అమ్మకం నమోదైంది';

  @override
  String get restocked => 'స్టాక్ చేర్చబడింది';

  @override
  String get wastageRecorded => 'వేస్టేజ్ నమోదైంది';

  @override
  String get stockCorrected => 'స్టాక్ అప్‌డేట్ అయింది';

  @override
  String get movementPurchase => 'కొనుగోలు';

  @override
  String get movementSale => 'అమ్మకం';

  @override
  String get movementWastage => 'వేస్టేజ్';

  @override
  String get movementReturn => 'రిటర్న్';

  @override
  String get movementCorrection => 'సవరణ';

  @override
  String get expiredTag => 'ఎక్స్‌పైర్ అయింది';

  @override
  String get expiryTodayTag => 'ఈరోజే ఎక్స్‌పైర్ అవుతుంది';

  @override
  String get noExpiry => 'ఎక్స్‌పైరీ లేదు';

  @override
  String get batchesTitle => 'బ్యాచ్‌లు';

  @override
  String get batchesSubtitle => 'ఎక్స్‌పైరీ వివరాలు';

  @override
  String get batchesEmpty => 'తేదీ ఉన్న బ్యాచ్‌లు లేవు';

  @override
  String get stockTitle => 'స్టాక్';

  @override
  String get stockSubtitle => 'విలువ, అలర్ట్‌లు మరియు ఎక్స్‌పైరీ';

  @override
  String get stockValuation => 'స్టాక్ విలువ';

  @override
  String get stockProfit => 'లాభం (30 రోజులు)';

  @override
  String get stockWastage => 'వేస్టేజ్ (30 రోజులు)';

  @override
  String get stockLowTitle => 'స్టాక్ తక్కువగా ఉంది';

  @override
  String get stockExpiryTitle => 'ఎక్స్‌పైరీ';

  @override
  String get stockNothingLow => 'స్టాక్ కొరత ఏమీ లేదు';

  @override
  String get stockNoExpiry => 'తేదీ ఉన్న బ్యాచ్‌లు లేవు';

  @override
  String get stockReorderNow => 'రీఆర్డర్ లిస్ట్ పంపండి';

  @override
  String get suppliersTitle => 'సప్లయర్లు';

  @override
  String get suppliersSubtitle => 'రీఆర్డర్ కాంటాక్ట్‌లు';

  @override
  String get suppliersEmpty => 'సప్లయర్లు ఎవరూ లేరు';

  @override
  String get supplierAdd => 'సప్లయర్‌ని జోడించండి';

  @override
  String get supplierName => 'పేరు';

  @override
  String get supplierPhone => 'ఫోన్';

  @override
  String get supplierNote => 'నోట్';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'స్కాన్';

  @override
  String get scanSubtitle => 'బార్‌కోడ్ లేదా QR';

  @override
  String get scanUnsupported =>
      'ఇక్కడ కెమెరా స్కానింగ్ పనిచేయదు. కింద కోడ్ టైప్ చేయండి.';

  @override
  String get scanPermission => 'స్కాన్ చేయడానికి కెమెరా పర్మిషన్ ఇవ్వండి';

  @override
  String get scanManualHint => 'కోడ్ టైప్ చేయండి లేదా పేస్ట్ చేయండి';

  @override
  String get scanCreateFromCode => 'ఈ కోడ్‌తో ప్రొడక్ట్ జోడించండి';

  @override
  String get labelsTitle => 'లేబుల్స్';

  @override
  String get labelsSubtitle => 'QR మరియు బార్‌కోడ్ లేబుల్స్ ప్రింట్ చేయండి';

  @override
  String get labelsSelect => 'ప్రొడక్ట్‌లను ఎంచుకోండి';

  @override
  String get labelsSize => 'లేబుల్ సైజు';

  @override
  String get labelsSymbology => 'సింబల్';

  @override
  String get labelsCopies => 'కాపీలు';

  @override
  String get labelsPrint => 'ప్రింట్ షీట్';

  @override
  String get labelsThermal => 'ప్రింటర్ కోడ్ కాపీ చేయండి';

  @override
  String get labelsCopied => 'ప్రింటర్ కోడ్ కాపీ అయింది';

  @override
  String get labelsNone => 'కనీసం ఒక ప్రొడక్ట్ ఎంచుకోండి';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'బార్‌కోడ్';

  @override
  String get paymentQrTitle => 'పేమెంట్ QR';

  @override
  String get paymentQrSubtitle =>
      'కస్టమర్లకు స్కాన్ చేసి పే చేసే వీలు కల్పించండి';

  @override
  String get paymentQrAmountHint => 'మొత్తం (ఆప్షనల్)';

  @override
  String get paymentQrNeedVpa => 'ముందుగా సెట్టింగ్స్‌లో మీ UPI ID జోడించండి.';

  @override
  String get paymentQrOpenSettings => 'సెట్టింగ్స్ తెరవండి';

  @override
  String get paymentQrPoster => 'పోస్టర్ సేవ్ చేయండి';

  @override
  String get paymentQrCopy => 'లింక్ కాపీ చేయండి';

  @override
  String get paymentQrCopied => 'లింక్ కాపీ అయింది';

  @override
  String get paymentQrNote =>
      'స్కాన్ చేస్తే కస్టమర్ UPI యాప్ ఓపెన్ అవుతుంది. సౌండ్‌బాక్స్ చెప్పినప్పుడే పేమెంట్ వచ్చినట్లు లెక్క.';

  @override
  String stockOnHand(String qty) {
    return 'స్టాక్ ఉంది: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'మార్జిన్ $pct%';
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
      other: '$count బ్యాచ్‌లను చూసుకోవాలి',
      one: '1 బ్యాచ్‌ను చూసుకోవాలి',
      zero: 'త్వరలో ఎక్స్‌పైర్ అయ్యేవి లేవు',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty మిగిలింది · ఒక్కోదానికి $cost';
  }

  @override
  String sellShortfall(String qty) {
    return 'స్టాక్‌లో $qty మాత్రమే ఉంది — అంతే రికార్డ్ చేశాము';
  }

  @override
  String productArchiveConfirm(String name) {
    return 'లిస్ట్ నుండి $name తొలగించాలా?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: దయచేసి $items పంపించండి';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return '$vpa కి చెల్లింపు';
  }

  @override
  String scanUnknownCode(String code) {
    return '$code కోడ్‌తో ఏ ప్రొడక్ట్ లేదు';
  }

  @override
  String get profileTitle => 'బిజినెస్ ప్రొఫైల్';

  @override
  String get vendorCategory => 'వ్యాపారం రకం';

  @override
  String get categoryCart => 'తోపుడు బండి';

  @override
  String get categoryStall => 'షాప్ / స్టాల్';

  @override
  String get categoryHotel => 'హోటల్ / టిఫిన్ సెంటర్';

  @override
  String get categoryService => 'సర్వీస్ పని';

  @override
  String get nicheLabel => 'మీరు ఏం అమ్ముతారు లేదా ఏం పని చేస్తారు?';

  @override
  String get districtLabel => 'జిల్లా';

  @override
  String get talukLabel => 'తాలూకా / ఊరు';

  @override
  String get marketAreaLabel => 'మార్కెట్ / ఏరియా';

  @override
  String get fssaiLabel => 'FSSAI నంబర్ (ఫుడ్ బిజినెస్)';

  @override
  String get udyamLabel => 'UDYAM రిజిస్ట్రేషన్ (ఆప్షనల్)';

  @override
  String get workingHoursLabel => 'పని వేళలు';

  @override
  String get perishableLabel => 'త్వరగా పాడైపోయే సరుకులు';

  @override
  String get profilePromptTitle => 'మీ వ్యాపార ప్రొఫైల్ సెట్ చేసుకోండి';

  @override
  String get profilePromptBody =>
      'మీరు ఏం అమ్ముతారో చెబితే, యాప్ మీకు కావాల్సినవే చూపిస్తుంది.';

  @override
  String get profilePromptAction => 'సెట్ చేయండి';

  @override
  String get profileSaved => 'ప్రొఫైల్ సేవ్ అయ్యింది';

  @override
  String get expensesTitle => 'ఖర్చులు';

  @override
  String get expensesSubtitle =>
      'పాలు, గ్యాస్, స్నాక్స్, అద్దె — మీ ఖర్చుల వివరాలు';

  @override
  String get expenseToday => 'నేటి ఖర్చు';

  @override
  String get expenseAdd => 'ఖర్చు రాయండి';

  @override
  String get expenseAmount => 'మొత్తం';

  @override
  String get expenseNote => 'నోట్ (ఆప్షనల్)';

  @override
  String get expenseTodayList => 'ఈరోజు ఖర్చులు';

  @override
  String get expenseEmpty => 'ఈరోజు ఎలాంటి ఖర్చులు రాయలేదు';

  @override
  String get expenseMilk => 'పాలు';

  @override
  String get expenseGas => 'గ్యాస్';

  @override
  String get expenseSnacks => 'స్నాక్స్';

  @override
  String get expenseProvisions => 'కిరాణా సరుకులు';

  @override
  String get expenseWages => 'కూలీ / జీతాలు';

  @override
  String get expenseRent => 'అద్దె';

  @override
  String get expenseElectricity => 'కరెంట్ బిల్లు';

  @override
  String get expenseTransport => 'రవాణా';

  @override
  String get expenseOther => 'ఇతరాలు';

  @override
  String get recurringTitle => 'రోజువారీ సరుకులు';

  @override
  String get recurringAdd => 'సరుకు కలపండి';

  @override
  String get recurringName => 'సరుకు పేరు';

  @override
  String get recurringEmpty =>
      'పాల క్యాన్లు లేదా స్నాక్స్‌ను ఇక్కడ సేవ్ చేసుకుని ఒకే ట్యాప్‌తో నమోదు చేయండి.';

  @override
  String get dayCloseTitle => 'డే క్లోజ్';

  @override
  String get dayCloseExpectedCash => 'గల్లాలో ఉండాల్సిన క్యాష్';

  @override
  String get dayCloseBreakdown => 'ఈరోజు లెక్కలు';

  @override
  String get dayCloseCollected => 'వసూలైన బాకీ';

  @override
  String get dayCloseWastage => 'వేస్టేజ్';

  @override
  String get dayCloseProfit => 'ఈరోజు లాభం';

  @override
  String get dayCloseCount => 'గల్లా లెక్కించండి';

  @override
  String get dayCloseCountedCash => 'లెక్కించిన క్యాష్';

  @override
  String get dayCloseSave => 'రోజు ముగించండి';

  @override
  String get dayCloseDiscounts => 'ఇచ్చిన డిస్కౌంట్లు';

  @override
  String get dayCloseTax => 'వసూలైన ట్యాక్స్';

  @override
  String get dayCloseLastToken => 'చివరి టోకెన్';

  @override
  String get dayCloseVoided => 'రద్దు చేసిన బిల్లులు';

  @override
  String get dayCloseExport => 'రోజు PDF ఎక్స్‌పోర్ట్';

  @override
  String get dayCloseVariancePosted => 'క్యాష్ తేడా లెడ్జర్‌లో చేర్చబడింది.';

  @override
  String get dayCloseExportFailed => 'రోజు సమ్మరీ ఎక్స్‌పోర్ట్ చేయడం కుదరలేదు.';

  @override
  String get dayCloseMatch => 'క్యాష్ సరిగ్గా సరిపోయింది.';

  @override
  String dayCloseSurplus(String amount) {
    return '$amount ఎక్కువగా ఉంది';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount తక్కువైంది';
  }

  @override
  String get insightsTitle => 'లెక్కలు';

  @override
  String get insightsSubtitle => 'రోజు, వారం, నెల మరియు సంవత్సరం';

  @override
  String get windowDay => 'రోజు';

  @override
  String get windowWeek => 'వారం';

  @override
  String get windowMonth => 'నెల';

  @override
  String get windowYear => 'సంవత్సరం';

  @override
  String get insightsTurnover => 'టర్నోవర్';

  @override
  String get insightsCosts => 'ఖర్చులు';

  @override
  String get insightsProfit => 'లాభం';

  @override
  String get insightsAvgDay => 'రోజుకు';

  @override
  String get insightsByDay => 'రోజువారీగా';

  @override
  String get insightsBestDay => 'బెస్ట్ రోజు';

  @override
  String get insightsTopItems => 'ఎక్కువగా అమ్ముడైనవి';

  @override
  String get insightsCostSplit => 'డబ్బు ఎందులోకి ఖర్చయింది';

  @override
  String get insightsEmpty => 'ఈ సమయంలో ఎలాంటి రికార్డులు లేవు';

  @override
  String get insightsMarginAlert => 'మార్జిన్ హెచ్చరిక';

  @override
  String get insightsMarginBody =>
      'ఈ ఐటమ్స్ ఖర్చుకి చాలా దగ్గర ధరకే అమ్ముడవుతున్నాయి. ధర పెంచండి లేదా ఖర్చు తగ్గించండి.';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'ఖర్చు $cost · ధర $price';
  }

  @override
  String get quickSaleTitle => 'క్విక్ సేల్';

  @override
  String get quickSaleSubtitle =>
      'కప్పుకు ఒక ట్యాప్ — పెద్ద ఆర్డర్ కోసం లాంగ్ ప్రెస్ చేయండి';

  @override
  String get quickSaleQty => 'క్వాంటిటీ';

  @override
  String quickSaleQtyTitle(String item) {
    return 'ఎన్ని $item?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount రికార్డ్ అయింది';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return 'ఒక $itemని $amountకి అమ్మండి';
  }

  @override
  String get quickSaleEmpty => 'క్విక్ మెనూ వాడటానికి ధరతో ఐటమ్స్ యాడ్ చేయండి.';

  @override
  String get starterPackAction => 'నా షాప్ కోసం స్టార్టర్ కిట్ లోడ్ చేయండి';

  @override
  String get starterTea => 'టీ';

  @override
  String get starterCoffee => 'కాఫీ';

  @override
  String get starterBun => 'బన్';

  @override
  String get starterBiscuit => 'బిస్కెట్';

  @override
  String get starterBajji => 'బజ్జీ';

  @override
  String get starterMilkSupply => 'పాల క్యాన్లు';

  @override
  String get starterSnackSupply => 'స్నాక్స్ ట్రే';

  @override
  String get menuDailyWork => 'రోజువారీ పనులు';

  @override
  String get stockOut => 'స్టాక్ అయిపోయింది';

  @override
  String get ordersTitle => 'ఆర్డర్లు';

  @override
  String get ordersSubtitle => 'కౌంటర్ మరియు QR ఆర్డర్లు, లైవ్';

  @override
  String get orderCounterNew => 'కొత్త కౌంటర్ ఆర్డర్';

  @override
  String get orderTable => 'టేబుల్';

  @override
  String get orderRemoveItem => 'ఒకటి తగ్గించు';

  @override
  String get orderAddItem => 'ఒకటి జోడించు';

  @override
  String get orderCancelReason => 'రద్దు చేయడానికి కారణం';

  @override
  String get orderCancel => 'ఆర్డర్ రద్దు చేయి';

  @override
  String get orderLive => 'లైవ్';

  @override
  String get orderHistory => 'హిస్టరీ';

  @override
  String get orderEmpty => 'ఇంకా ఆర్డర్లు లేవు.';

  @override
  String get orderNew => 'కొత్తది';

  @override
  String get orderPreparing => 'తయారవుతోంది';

  @override
  String get orderServed => 'సర్వ్ అయింది';

  @override
  String get orderPaid => 'చెల్లించారు';

  @override
  String get orderCancelled => 'రద్దయింది';

  @override
  String get orderAccept => 'స్వీకరించు';

  @override
  String get orderServe => 'సర్వ్ చేయండి';

  @override
  String get orderBulkAccept => 'కొత్తవన్నీ స్వీకరించు';

  @override
  String get orderBulkServe => 'రెడీ అయినవన్నీ సర్వ్ చేయి';

  @override
  String get orderBill => 'బిల్లు';

  @override
  String get orderTokenShort => 'టోకెన్';

  @override
  String get kotTitle => 'కిచెన్';

  @override
  String get kotSubtitle => 'తర్వాత ఏం తయారు చేయాలి';

  @override
  String get kotEmpty => 'కిచెన్‌లో ఏమీ పెండింగ్ లేదు.';

  @override
  String get kotDone => 'రెడీ';

  @override
  String get billTitle => 'బిల్లు';

  @override
  String get billNumberLabel => 'బిల్లు';

  @override
  String get billSubtotal => 'సబ్‌టోటల్';

  @override
  String get billDiscount => 'డిస్కౌంట్';

  @override
  String get billDiscountFlat => 'డిస్కౌంట్ మొత్తం';

  @override
  String get billDiscountPct => 'డిస్కౌంట్ %';

  @override
  String get billTax => 'GST';

  @override
  String get billTaxable => 'టాక్సబుల్ మొత్తం';

  @override
  String get billCgst => 'CGST';

  @override
  String get billSgst => 'SGST';

  @override
  String get billIgst => 'IGST';

  @override
  String get shopGstRegistered => 'GST రిజిస్టర్డ్ షాపు';

  @override
  String get shopGstRegisteredHint =>
      'బిల్లులపై CGST/SGST విభజన మరియు వస్తువు HSN కోడ్‌లు కనిపిస్తాయి';

  @override
  String get shopPriceIncludesTax => 'ధరలలో పన్ను కలిసి ఉంది';

  @override
  String get productTaxRate => 'GST రేటు %';

  @override
  String get productHsn => 'HSN / SAC కోడ్';

  @override
  String get productTaxHint => 'షాప్ రేటు వాడాలంటే ఖాళీగా ఉంచండి';

  @override
  String get billRounding => 'రౌండింగ్';

  @override
  String get billTotal => 'మొత్తం';

  @override
  String get billPaid => 'చెల్లించినది';

  @override
  String get billBalance => 'బాకీ';

  @override
  String get billReprint => 'రీప్రింట్';

  @override
  String get billShare => 'షేర్ చేయండి';

  @override
  String get billThanks => 'ధన్యవాదాలు, మళ్లీ రండి';

  @override
  String get billCustomer => 'కస్టమర్';

  @override
  String get billSplit => 'పేమెంట్';

  @override
  String get billRoundToRupee => 'రూపాయికి రౌండ్ చేయండి';

  @override
  String get billFillCash => 'మిగిలినది క్యాష్‌గా వేయండి';

  @override
  String get billFullyPaid => 'పూర్తిగా చెల్లించారు';

  @override
  String get billSettle => 'బిల్లు సెటిల్ చేయండి';

  @override
  String get close => 'మూసివేయి';

  @override
  String get billPreview => 'పేపర్ ప్రివ్యూ';

  @override
  String get billVoid => 'బిల్లు రద్దు చేయండి';

  @override
  String get billVoidTitle => 'ఈ బిల్లును రద్దు చేయండి';

  @override
  String get billVoidHint =>
      'బిల్లు నంబర్ లెక్కల్లోనే ఉంటుంది, లెడ్జర్ ఎంట్రీలు రివర్స్ అవుతాయి.';

  @override
  String get billVoidReason => 'కారణం';

  @override
  String get billVoidReasonRequired => 'బిల్లు రద్దు చేయడానికి కారణం రాయాలి';

  @override
  String get billVoided => 'బిల్లు రద్దయింది';

  @override
  String get billVoidFailed => 'ఈ బిల్లు రద్దు కాలేదు';

  @override
  String get billAudit => 'బిల్లు హిస్టరీ';

  @override
  String get menuTitle => 'QR మెనూ';

  @override
  String get menuSubtitle => 'స్కాన్ చేసినప్పుడు కస్టమర్లకు కనిపించేది';

  @override
  String get menuShopSection => 'షాప్';

  @override
  String get menuSlug => 'లింక్‌లో మెనూ పేరు';

  @override
  String get menuBaseUrl => 'మెనూ వెబ్ అడ్రస్';

  @override
  String get menuTableCount => 'టేబుల్స్';

  @override
  String get menuTaxPercent => 'GST %';

  @override
  String get menuGstin => 'GSTIN';

  @override
  String get menuAcceptOrders => 'QR ఆర్డర్లు స్వీకరించండి';

  @override
  String get menuSaved => 'మెనూ సెట్టింగ్స్ సేవ్ అయ్యాయి';

  @override
  String get menuQrSheet => 'QR షీట్ ప్రింట్ చేయండి';

  @override
  String get menuLinkSection => 'షాప్ QR';

  @override
  String get menuItemsSection => 'మెనూలోని ఐటమ్స్';

  @override
  String get menuSoldOut => 'అయిపోయింది';

  @override
  String get menuPublished => 'మెనూలో ఉంది';

  @override
  String get menuCounterQr => 'కౌంటర్';

  @override
  String get menuScanHint => 'మెనూ చూసి ఆర్డర్ చేయడానికి స్కాన్ చేయండి';

  @override
  String get printersTitle => 'రసీదు ప్రింటర్';

  @override
  String get printersSubtitle => 'పేపర్ సైజు, కనెక్షన్ మరియు టెస్ట్ ప్రింట్';

  @override
  String get printerWidth => 'పేపర్ వెడల్పు';

  @override
  String get printerTransport => 'కనెక్షన్';

  @override
  String get printerPdf => 'PDF / షేర్';

  @override
  String get printerBluetooth => 'బ్లూటూత్';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'ప్రింటర్ పేరు';

  @override
  String get printerDeviceAddress => 'ప్రింటర్ అడ్రస్';

  @override
  String get printerFallbackNote =>
      'ఈ డివైజ్‌కి డైరెక్ట్ ప్రింట్ ఇంకా అందుబాటులో లేదు, కాబట్టి బిల్లు PDF రూపంలో ఓపెన్ అవుతుంది. మీరు ప్రింట్ లేదా షేర్ చేసుకోవచ్చు.';

  @override
  String get printerAutoPrint => 'బిల్లు ఆటోమేటిక్‌గా ప్రింట్ చేయి';

  @override
  String get printerKot => 'కిచెన్ టికెట్ ప్రింట్ చేయి';

  @override
  String get printerTest => 'టెస్ట్ ప్రింట్';

  @override
  String get printerTestSent => 'టెస్ట్ రసీదు పంపబడింది';

  @override
  String get printerPaired => 'పెయిర్ చేసిన ప్రింటర్లు';

  @override
  String get printerScan => 'పెయిర్ చేసిన ప్రింటర్లను వెతకండి';

  @override
  String get printerScanning => 'వెతుకుతోంది…';

  @override
  String get printerNoDevices =>
      'పెయిర్ అయిన ప్రింటర్ ఏదీ దొరకలేదు. ముందుగా ఆండ్రాయిడ్ బ్లూటూత్ సెట్టింగ్స్‌లో పెయిర్ చేయండి.';

  @override
  String get printerConnect => 'కనెక్ట్ చేయి';

  @override
  String get printerConnected => 'ప్రింటర్ కనెక్ట్ అయింది';

  @override
  String get printerConnectFailed =>
      'కనెక్ట్ కాలేదు. ప్రింటర్ ఆన్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get printerBluetoothNote =>
      'బిల్లులు నేరుగా ఈ బ్లూటూత్ ప్రింటర్‌లో ప్రింట్ అవుతాయి. ఒకవేళ అది ఆఫ్ అయినా లేదా దూరంగా ఉన్నా, బిల్లు PDF రూపంలో ఓపెన్ అవుతుంది.';

  @override
  String orderToken(int token) {
    return 'టోకెన్ $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes నిమి';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ఐటమ్స్',
      one: '1 ఐటమ్',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'బిల్లు $number సెటిల్ అయింది';
  }

  @override
  String get dayCloseOrders => 'ఈరోజు ఆర్డర్లు';

  @override
  String get dayCloseOrdersTaken => 'తీసుకున్న ఆర్డర్లు';

  @override
  String get dayCloseOrdersCancelled => 'క్యాన్సిల్ అయినవి';

  @override
  String get dayCloseOrdersOpen => 'ఇంకా ఓపెన్‌లో ఉన్నవి';

  @override
  String get dayCloseOrdersBilled => 'బిల్ అయినవి';

  @override
  String get dayCloseAvgTicket => 'సగటు బిల్లు';

  @override
  String get menuCloudSection => 'క్లౌడ్ బోర్డ్';

  @override
  String get menuShopKey => 'షాప్ కీ (16+ అక్షరాలు)';

  @override
  String get menuCloudSync => 'ఆర్డర్లను క్లౌడ్‌తో సింక్ చేయండి';

  @override
  String get menuCloudPublish => 'మెనూను క్లౌడ్‌లో పబ్లిష్ చేయండి';

  @override
  String menuCloudPublished(int count) {
    return 'క్లౌడ్ మెనూకి $count ఐటమ్స్ పబ్లిష్ అయ్యాయి';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'క్లౌడ్ ఎర్రర్: $reason';
  }

  @override
  String get menuCloudLive => 'లైవ్: QR ఆర్డర్‌లు నేరుగా బోర్డుకి వస్తాయి.';

  @override
  String get menuCloudOffline =>
      'లోకల్ మాత్రమే. QR ఆర్డర్‌లు రావాలంటే షాప్ కీని జోడించి సింక్ ఆన్ చేయండి.';

  @override
  String get settleTitle => 'బాకీ క్లియర్ చేయండి';

  @override
  String get settleAmountSection => 'చెల్లింపు';

  @override
  String get settleAmount => 'మొత్తం';

  @override
  String get settleCash => 'నగదు';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'కొత్త అప్పు';

  @override
  String get settleNote => 'నోట్';

  @override
  String get settleCashHint =>
      'నగదు రాగానే బాకీ క్లోజ్ అవుతుంది, ఈరోజు క్యాష్ కలెక్షన్‌కి కలుస్తుంది.';

  @override
  String get settleUpiHint =>
      'UPI లో తీసుకుని కన్ఫర్మ్ చేయండి. బాకీ క్లోజ్ అయి ఈరోజు UPI కలెక్షన్ పెరుగుతుంది.';

  @override
  String get settleLoanHint =>
      'పాత బాకీ క్లోజ్ అయ్యి, అదే మొత్తం కొత్త అప్పుగా మారుతుంది.';

  @override
  String get settleConfirm => 'సెటిల్ చేయండి';

  @override
  String get settleDone => 'చెల్లింపు నమోదైంది';

  @override
  String get settleHistory => 'ఇటీవలి చెల్లింపులు';

  @override
  String settleTooMuch(String amount) {
    return 'మిగిలిన బాకీ ₹$amount కంటే ఎక్కువ ఉంది';
  }

  @override
  String settleLedgerItem(String name) {
    return 'బాకీ చెల్లించారు — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'బాకీ కొత్త అప్పుగా మార్చబడింది — $name';
  }

  @override
  String get menuAddress => 'షాపు అడ్రస్';

  @override
  String get menuPhone => 'ఫోన్ నంబర్';

  @override
  String get menuFssai => 'FSSAI లైసెన్స్';

  @override
  String get menuGrowSection => 'వృద్ధి & నిర్వహణ';

  @override
  String get recipesTitle => 'రెసిపీల పుస్తకం';

  @override
  String get recipesSubtitle => 'మీ కొలతలు, ఒక్కసారి రాసి పెట్టుకోండి';

  @override
  String get recipeAdd => 'వంటకాన్ని చేర్చండి';

  @override
  String get recipeName => 'వంటకం పేరు';

  @override
  String get recipeServings => 'ఎన్ని ప్లేట్లు వస్తుంది';

  @override
  String get recipeEmpty => 'ఇంకా ఏ వంటకం రాయలేదు.';

  @override
  String get recipeIngredients => 'కావలసిన సరుకులు';

  @override
  String get recipeSteps => 'చేసే విధానం';

  @override
  String get recipeAddIngredient => 'సరుకు చేర్చండి';

  @override
  String get recipeAddStep => 'స్టెప్ చేర్చండి';

  @override
  String get recipeQty => 'పరిమాణం';

  @override
  String get recipeLinkProduct => 'స్టాక్ ఐటమ్ నుండి తీసుకోండి';

  @override
  String get recipeNoLink => 'స్టాక్ నుండి కాదు';

  @override
  String get recipeCost => 'సరుకుల ఖర్చు';

  @override
  String get recipePerServing => 'ప్లేట్ ఖర్చు';

  @override
  String get recipeScale => 'ఎన్ని ప్లేట్లకు చేయాలి';

  @override
  String get recipeCookBatch => 'సరుకులను స్టాక్ నుండి తీయండి';

  @override
  String get recipeCooked => 'స్టాక్ నుండి సరుకు తీసేశారు';

  @override
  String get recipeStepsEmpty => 'ఇంకా స్టెప్స్ రాయలేదు.';

  @override
  String get recipeUnlinkedWarning =>
      'స్టాక్‌కి లింక్ చేయని ఐటమ్స్ ఖర్చులో కలపలేదు.';

  @override
  String get jobsTitle => 'కస్టమ్ ఆర్డర్లు';

  @override
  String get jobsSubtitle => 'అడ్వాన్స్ బుకింగ్‌లు మరియు ప్రత్యేక ఆర్డర్ పనులు';

  @override
  String get jobAdd => 'ఆర్డర్ తీసుకోండి';

  @override
  String get jobTitleField => 'ఏం తయారు చేయాలి';

  @override
  String get jobCustomer => 'కస్టమర్';

  @override
  String get jobPhone => 'ఫోన్';

  @override
  String get jobPrice => 'ధర';

  @override
  String get jobAdvance => 'తీసుకున్న అడ్వాన్స్';

  @override
  String get jobDue => 'ఇచ్చే తేదీ';

  @override
  String get jobEmpty => 'ఇక్కడ ఆర్డర్లు ఏమీ లేవు.';

  @override
  String get jobStatusTaken => 'తీసుకున్నారు';

  @override
  String get jobStatusMaking => 'చేస్తున్నారు';

  @override
  String get jobStatusReady => 'రెడీ';

  @override
  String get jobStatusDelivered => 'ఇచ్చేశారు';

  @override
  String get jobStatusCancelled => 'క్యాన్సిల్ అయ్యింది';

  @override
  String get jobAdvanceStatus => 'ముందుకు జరపండి';

  @override
  String get jobCancel => 'క్యాన్సిల్';

  @override
  String get jobRemind => 'WhatsAppలో మెసేజ్ చేయండి';

  @override
  String get jobFilterOpen => 'ఓపెన్';

  @override
  String get jobFilterToday => 'ఈరోజే ఇవ్వాలి';

  @override
  String get jobFilterDone => 'పూర్తయినవి';

  @override
  String get customersTitle => 'రెగ్యులర్ కస్టమర్లు';

  @override
  String get customersSubtitle =>
      'ఎవరు మళ్లీ వస్తున్నారు, మీ షాప్ ఎలా తెలిసింది';

  @override
  String get customerAdd => 'కస్టమర్‌ని కలపండి';

  @override
  String get customerName => 'పేరు';

  @override
  String get customerPhone => 'ఫోన్';

  @override
  String get sourceWalkIn => 'నేరుగా వచ్చారు';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'తెలిసినవాళ్లు చెప్పారు';

  @override
  String get sourceOther => 'ఇతర';

  @override
  String get customerRecordVisit => 'విజిట్ కలపండి';

  @override
  String get customerVisitAmount => 'మొత్తం';

  @override
  String get customerRewardDue => 'ఫ్రీ ఐటమ్ ఇవ్వాలి';

  @override
  String get customerGiveReward => 'ఫ్రీ ఐటమ్ ఇవ్వండి';

  @override
  String get customersEmpty => 'రెగ్యులర్ కస్టమర్లు ఇంకా ఎవరూ లేరు.';

  @override
  String get customerSourceSplit => 'డబ్బులు ఎక్కడి నుంచి వస్తున్నాయి';

  @override
  String get eventsTitle => 'ఈవెంట్లు & ఎగ్జిబిషన్లు';

  @override
  String get eventsSubtitle => 'స్టాల్ వేయడం వల్ల లాభం వచ్చిందా?';

  @override
  String get eventAdd => 'ఈవెంట్ జోడించండి';

  @override
  String get eventName => 'ఈవెంట్ పేరు';

  @override
  String get eventPlace => 'ప్రదేశం';

  @override
  String get eventDay => 'తేదీ';

  @override
  String get eventRent => 'స్టాల్ అద్దె';

  @override
  String get eventTravel => 'ప్రయాణం';

  @override
  String get eventOther => 'ఇతర ఖర్చు';

  @override
  String get eventSales => 'అమ్మకాలు';

  @override
  String get eventFootfall => 'వచ్చిన జనం';

  @override
  String get eventProfit => 'లాభం';

  @override
  String get eventLoss => 'నష్టం';

  @override
  String get eventPerVisitor => 'ఒక్కో విజిటర్‌కి';

  @override
  String get eventsEmpty => 'ఇంకా ఏ ఈవెంట్‌ను నమోదు చేయలేదు.';

  @override
  String get staffTitle => 'వర్కర్లు';

  @override
  String get staffSubtitle => 'హాజరు, అడ్వాన్సులు మరియు జీతాలు';

  @override
  String get staffAdd => 'వర్కర్‌ను జోడించండి';

  @override
  String get staffName => 'పేరు';

  @override
  String get staffPhone => 'ఫోన్';

  @override
  String get staffRole => 'చేసే పని';

  @override
  String get staffWage => 'రోజువారీ కూలీ';

  @override
  String get staffPresent => 'హాజరు';

  @override
  String get staffHalf => 'హాఫ్ డే';

  @override
  String get staffAbsent => 'రాలేదు';

  @override
  String get staffAdvance => 'అడ్వాన్స్';

  @override
  String get staffAdvanceAdd => 'అడ్వాన్స్ ఇవ్వండి';

  @override
  String get staffPayable => 'ఈ నెలకు ఇవ్వాల్సిన కూలీ';

  @override
  String get staffEmpty => 'వర్కర్లెవరూ లేరు.';

  @override
  String get staffRemove => 'తీసివేయండి';

  @override
  String get growthTitle => 'గ్రోత్ కిట్';

  @override
  String get growthSubtitle => 'ఎక్కువ మంది కస్టమర్లను రప్పించండి';

  @override
  String get growthMenuLink => 'మీ మెనూ లింక్';

  @override
  String get growthShareMenu => 'మెనూ పంపండి';

  @override
  String get growthAskReview => 'రివ్యూ అడగండి';

  @override
  String get growthOpenMaps => 'Maps పేజీ తెరవండి';

  @override
  String get growthWhatsappBroadcast => 'WhatsAppలో కస్టమర్లకు చెప్పండి';

  @override
  String get growthLinksSection => 'మీ లింక్‌లు';

  @override
  String get growthMapsUrl => 'Google Maps లింక్';

  @override
  String get growthReviewUrl => 'రివ్యూ లింక్';

  @override
  String get growthInstagram => 'Instagram పేరు';

  @override
  String get growthLoyalty => 'ఎన్ని విజిట్స్ తర్వాత ఒకటి ఉచితం';

  @override
  String get growthIdeas => 'ఈ వారం పోస్ట్ ఐడియాలు';

  @override
  String get growthShareIdea => 'పంపండి';

  @override
  String get growthIdea1 => 'ఉదయం మొదటి బ్యాచ్ తయారవుతున్న చిన్న వీడియో.';

  @override
  String get growthIdea2 => 'ధర స్పష్టంగా రాసి ఉన్న నేటి స్పెషల్.';

  @override
  String get growthIdea3 => 'రెగ్యులర్ కస్టమర్ తమ ఆర్డర్‌తో ఉన్న ఫోటో.';

  @override
  String get growthIdea4 =>
      'కౌంటర్ వెనుక: రోజూ షాప్ ఎలా మొదలవుతుందో చూపించండి.';

  @override
  String get growthIdea5 => 'రెండు రోజులు మాత్రమే ఉండే వీకెండ్ ఆఫర్.';

  @override
  String get growthSaved => 'సేవ్ అయింది';

  @override
  String get checklistTitle => 'షాప్ తెరిచే & మూసే చెక్‌లిస్ట్';

  @override
  String get checklistSubtitle => 'మర్చిపోతే ఇబ్బంది పెట్టే చిన్న చిన్న పనులు';

  @override
  String get checklistOpening => 'తెరిచే ముందు';

  @override
  String get checklistClosing => 'మూసే ముందు';

  @override
  String get checklistAdd => 'లిస్ట్‌కి జోడించండి';

  @override
  String get checklistItem => 'ఏం చెక్ చేయాలి';

  @override
  String get checklistEmpty => 'లిస్ట్‌లో ఇంకా ఏమీ లేదు.';

  @override
  String get checklistUseStarter => 'స్టార్టర్ లిస్ట్ వాడండి';

  @override
  String get checklistSeed1 => 'చిల్లర డబ్బులు రెడీగా పెట్టుకోవడం';

  @override
  String get checklistSeed2 => 'గ్యాస్ మరియు పాలు సరిచూసుకోవడం';

  @override
  String get checklistSeed3 => 'QR స్టాండ్, రేట్ల బోర్డు బయట పెట్టడం';

  @override
  String get checklistSeed4 => 'క్యాష్ లెక్కించి రాసిపెట్టుకోవడం';

  @override
  String get checklistSeed5 => 'ఫ్రిజ్, గ్యాస్, లైట్లు స్విచ్ ఆఫ్ చేయడం';

  @override
  String jobRemindMessage(String name, String title) {
    return 'నమస్తే $name, మీ ఆర్డర్ \"$title\" రెడీగా ఉంది.';
  }

  @override
  String customerVisits(String count) {
    return '$count విజిట్స్';
  }

  @override
  String customerToReward(String count) {
    return 'ఇంకా $count విజిట్స్';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return '$name నచ్చిందా? దయచేసి రివ్యూ ఇవ్వండి: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — నేటి మెనూ: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$total లో $done పూర్తయ్యాయి';
  }

  @override
  String get movementPrepared => 'తయారీ';

  @override
  String recipeShortStock(String item) {
    return 'స్టాక్‌లో సరిపడా $item లేదు';
  }

  @override
  String get starterIdli => 'ఇడ్లీ';

  @override
  String get starterDosa => 'దోశ';

  @override
  String get starterMeals => 'భోజనం';

  @override
  String get starterSnackPacket => 'స్నాక్ ప్యాకెట్';

  @override
  String get starterWaterBottle => 'వాటర్ బాటిల్';

  @override
  String get starterVegSupply => 'కూరగాయలు';

  @override
  String get starterGasSupply => 'గ్యాస్ సిలిండర్';

  @override
  String get checklistSeedHotel => 'పిండి, కూరగాయలు, గ్యాస్ సిద్ధం చేసుకోవడం';

  @override
  String get checklistSeedCart => 'బండి శుభ్రం చేసి స్టాక్ పెట్టుకోవడం';

  @override
  String get checklistSeedService => 'సామాన్లు, చిల్లర రెడీ';

  @override
  String get presetRecipeTea => 'షాప్ టీ (10 కప్పులు)';

  @override
  String get presetIngredientMilk => 'పాలు';

  @override
  String get presetIngredientWater => 'నీళ్లు';

  @override
  String get presetIngredientTeaPowder => 'టీ పొడి';

  @override
  String get presetIngredientSugar => 'చక్కెర';

  @override
  String get rolesTitle => 'రోల్స్';

  @override
  String get rolesSubtitle => 'ఎవరు ఏమి చేయవచ్చు';

  @override
  String get rolesHint =>
      'ఒక్కో హెల్పర్ రకానికి ఒక రోల్ తయారు చేసి, వారు చేసే పనిని మాత్రమే టిక్ చేయండి.';

  @override
  String get rolesEmpty => 'ఇంకా రోల్స్ లేవు';

  @override
  String get rolesOpen => 'యాక్టివ్ రోల్స్';

  @override
  String get roleNew => 'కొత్త రోల్';

  @override
  String get roleSuggestionsTitle => 'మీ షాప్ కోసం సూచనలు';

  @override
  String get roleSuggestionsHint =>
      'మీ బిజినెస్‌కు తగిన రోల్స్ సిద్ధంగా ఉన్నాయి. ఒకదాన్ని ఎంచుకుని, అవసరమైతే మార్చుకోండి.';

  @override
  String get tmplWaiter => 'వెయిటర్';

  @override
  String get tmplKitchen => 'కిచెన్ / చెఫ్';

  @override
  String get tmplCashier => 'క్యాషియర్';

  @override
  String get tmplCounter => 'కౌంటర్';

  @override
  String get tmplSalesHelper => 'సేల్స్ హెల్పర్';

  @override
  String get tmplStockKeeper => 'స్టాక్ కీపర్';

  @override
  String get tmplJobAssistant => 'జాబ్ అసిస్టెంట్';

  @override
  String get tmplCounterHelper => 'కౌంటర్ హెల్పర్';

  @override
  String get tmplAssistant => 'అసిస్టెంట్';

  @override
  String get roleOwner => 'ఓనర్';

  @override
  String get roleOwnerNote => 'ఎల్లప్పుడూ పూర్తి యాక్సెస్';

  @override
  String get roleInactive => 'వాడకంలో లేదు';

  @override
  String rolePermissionCount(String count) {
    return '$count అనుమతించబడ్డాయి';
  }

  @override
  String get roleEditSubtitle => 'పేరు, బాధ్యతలు మరియు పరిమితులు';

  @override
  String get roleName => 'రోల్ పేరు';

  @override
  String get roleNote => 'బాధ్యత';

  @override
  String get roleLimits => 'డబ్బు పరిమితులు (Rs, 0 = పరిమితి లేదు)';

  @override
  String get roleMaxDiscount => 'అనుమతించే గరిష్ట డిస్కౌంట్';

  @override
  String get roleMaxCredit => 'అనుమతించే గరిష్ట అప్పు';

  @override
  String get roleMaxRefund => 'అనుమతించే గరిష్ట రీఫండ్';

  @override
  String get roleLimitHint => 'ఈ మొత్తం మించితే ఓనర్ PIN అవసరం.';

  @override
  String get roleDuplicate => 'రోల్ కాపీ చేయండి';

  @override
  String get roleDeactivate => 'వాడకం ఆపండి';

  @override
  String get areaSales => 'సేల్స్';

  @override
  String get areaOrders => 'ఆర్డర్లు మరియు కిచెన్';

  @override
  String get areaBilling => 'బిల్లులు';

  @override
  String get areaCredit => 'అప్పు';

  @override
  String get areaStock => 'స్టాక్';

  @override
  String get areaPurchases => 'కొనుగోళ్లు & ఖర్చులు';

  @override
  String get areaMoney => 'డబ్బు & రిపోర్టులు';

  @override
  String get areaCustomers => 'కస్టమర్లు';

  @override
  String get areaStaff => 'సిబ్బంది';

  @override
  String get areaSettings => 'సెట్టింగ్స్';

  @override
  String get permRecordSale => 'అమ్మకాన్ని నమోదు చేయండి';

  @override
  String get permQuickSale => 'క్విక్ సేల్ వాడండి';

  @override
  String get permCollectUpi => 'పేమెంట్ QR చూపించండి';

  @override
  String get permTakeOrder => 'ఆర్డర్ తీసుకోండి';

  @override
  String get permChangeOrderStatus => 'ఆర్డర్ స్టేటస్ మార్చండి';

  @override
  String get permViewKitchen => 'కిచెన్ లిస్ట్ చూడండి';

  @override
  String get permEditMenu => 'మెనూ మార్చండి';

  @override
  String get permMakeBill => 'బిల్లు వేయండి';

  @override
  String get permGiveDiscount => 'డిస్కౌంట్ ఇవ్వండి';

  @override
  String get permVoidBill => 'బిల్లు రద్దు చేయండి';

  @override
  String get permReprintBill => 'బిల్లు మళ్లీ ప్రింట్ చేయండి';

  @override
  String get permGiveCredit => 'అప్పు ఇవ్వండి';

  @override
  String get permSettleCredit => 'అప్పు జమ చేయండి';

  @override
  String get permViewCredit => 'అప్పు బాకీలు చూడండి';

  @override
  String get permViewStock => 'స్టాక్ చూడండి';

  @override
  String get permAdjustStock => 'స్టాక్ మార్చండి';

  @override
  String get permEditProducts => 'ఐటమ్స్ చేర్చండి లేదా మార్చండి';

  @override
  String get permChangePrice => 'ధరలు మార్చండి';

  @override
  String get permCookRecipe => 'రెసిపీ తయారు చేయండి';

  @override
  String get permRecordExpense => 'ఖర్చు నమోదు చేయండి';

  @override
  String get permManageSuppliers => 'సప్లయర్లను మేనేజ్ చేయండి';

  @override
  String get permViewDayTotals => 'రోజు టోటల్ చూడండి';

  @override
  String get permViewProfit => 'లాభం చూడండి';

  @override
  String get permCloseDay => 'రోజును ముగించండి';

  @override
  String get permViewReports => 'రిపోర్టులు చూడండి';

  @override
  String get permViewCustomers => 'కస్టమర్లను చూడండి';

  @override
  String get permEditCustomers => 'కస్టమర్ వివరాలు మార్చండి';

  @override
  String get permManageStaff => 'సిబ్బందిని మేనేజ్ చేయండి';

  @override
  String get permMarkAttendance => 'హాజరు వేయండి';

  @override
  String get permPayWages => 'జీతాలు ఇవ్వండి';

  @override
  String get permManageRoles => 'రోల్స్ క్రియేట్ చేయండి';

  @override
  String get permViewAudit => 'యాక్టివిటీ హిస్టరీ చూడండి';

  @override
  String get permEditSettings => 'సెట్టింగ్స్ మార్చండి';

  @override
  String get permEditShop => 'షాప్ వివరాలు మార్చండి';

  @override
  String get permManagePrinters => 'ప్రింటర్లు సెటప్ చేయండి';

  @override
  String get accessTitle => 'యాక్సెస్ కంట్రోల్';

  @override
  String get accessSubtitle => 'ఒకే ఫోన్, వేర్వేరు వ్యక్తులు';

  @override
  String get accessEnable => 'PIN అడగండి';

  @override
  String get accessEnableHint =>
      'ఈ ఫోన్ వాడే ముందు ప్రతి హెల్పర్ సైన్ ఇన్ అవ్వాలి.';

  @override
  String get accessNeedsOwnerPin => 'ముందు ఓనర్ PIN సెట్ చేయండి';

  @override
  String get accessOwnerPin => 'ఓనర్ PIN';

  @override
  String get accessOwnerPinSet => 'ఓనర్ PIN సెట్ చేయండి (4-6 అంకెలు)';

  @override
  String get accessOwnerPinChange => 'ఓనర్ PIN మార్చండి (4-6 అంకెలు)';

  @override
  String get accessPinSaved => 'PIN సేవ్ అయింది';

  @override
  String get accessPinInvalid => '4 నుండి 6 అంకెలు ఉండాలి';

  @override
  String get accessAutoLock => 'ఆటో లాక్';

  @override
  String get accessIdleMinutes =>
      'ఇంత సమయం తర్వాత లాక్ అవ్వాలి (నిమిషాలు, 0 = ఎప్పటికీ వద్దు)';

  @override
  String get accessWorkers => 'హెల్పర్లు';

  @override
  String get accessNoWorkers => 'ముందు హెల్పర్లను జోడించండి';

  @override
  String get accessNoRole => 'ఇంకా రోల్ ఇవ్వలేదు';

  @override
  String get accessPinSet => 'PIN సెట్ అయింది';

  @override
  String get accessPinMissing => 'PIN లేదు';

  @override
  String get accessAssignTitle => 'రోల్ మరియు PIN';

  @override
  String get accessWorkerPin => 'కొత్త PIN (4-6 అంకెలు)';

  @override
  String get accessSaved => 'సేవ్ అయింది';

  @override
  String get accessEndShift => 'షిఫ్ట్ ముగించు';

  @override
  String get accessWrongPin => 'తప్పుడు PIN';

  @override
  String get lockTitle => 'కౌంటర్‌లో ఎవరున్నారు?';

  @override
  String get lockSubtitle => 'మీ పేరు ఎంచుకుని PIN ఎంటర్ చేయండి';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'షిఫ్ట్ మొదలుపెట్టు';

  @override
  String get auditTitle => 'యాక్టివిటీ హిస్టరీ';

  @override
  String get auditSubtitle => 'ఎవరు ఏం చేశారు';

  @override
  String get auditOpen => 'యాక్టివిటీ హిస్టరీ చూడండి';

  @override
  String get auditEveryone => 'అందరూ';

  @override
  String get auditEmpty => 'ఇంకా ఏమీ రికార్డ్ కాలేదు';

  @override
  String get auditApproved => 'ఓనర్ అప్రూవ్ చేశారు';

  @override
  String get settingsGroupBusiness => 'బిజినెస్';

  @override
  String get settingsGroupMoney => 'డబ్బులు';

  @override
  String get settingsGroupApp => 'యాప్ & డివైస్‌లు';

  @override
  String get settingsShopTitle => 'షాప్ వివరాలు';

  @override
  String get settingsPaymentsTitle => 'పేమెంట్లు & UPI';

  @override
  String get settingsMarketTitle => 'మార్కెట్ ధరలు';

  @override
  String get settingsNotSet => 'సెట్ చేయలేదు';

  @override
  String get settingsOn => 'ఆన్';

  @override
  String get settingsOff => 'ఆఫ్';

  @override
  String get settingsSaved => 'సెట్టింగ్స్ సేవ్ అయ్యాయి';

  @override
  String get dashboardTitle => 'డ్యాష్‌బోర్డ్';

  @override
  String get dashboardSubtitle =>
      'ఆర్డర్లు, పేమెంట్లు, ఖాతా బాకీలు, స్టాక్ వివరాలు';

  @override
  String get dashboardOrders => 'ఆర్డర్లు';

  @override
  String get dashboardPayments => 'రావాల్సిన పేమెంట్లు';

  @override
  String get dashboardCredit => 'ఖాతా బాకీలు';

  @override
  String get dashboardInventory => 'స్టాక్';

  @override
  String get dashboardShare => 'షేర్';

  @override
  String get dashboardPlaced => 'వచ్చినవి';

  @override
  String get dashboardServed => 'ఇచ్చినవి';

  @override
  String get dashboardCancelled => 'రద్దైనవి';

  @override
  String get dashboardOpenOrders => 'ఓపెన్ ఆర్డర్లు';

  @override
  String get dashboardBilled => 'బిల్ అయినవి';

  @override
  String get dashboardAvgBill => 'సగటు బిల్లు';

  @override
  String get dashboardCollected => 'వసూలైనవి';

  @override
  String get dashboardUnbilled => 'ఇంకా బిల్ చేయలేదు';

  @override
  String get dashboardPendingTotal => 'ఇంకా రావాల్సినవి';

  @override
  String get dashboardOutstanding => 'మొత్తం బాకీ';

  @override
  String get dashboardCreditGiven => 'ఇచ్చిన అప్పు';

  @override
  String get dashboardCustomers => 'కస్టమర్లు';

  @override
  String get dashboardOldest => 'పాత బాకీ';

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
  String get dashboardStockValue => 'స్టాక్ విలువ';

  @override
  String get dashboardLowStock => 'తక్కువ స్టాక్';

  @override
  String get dashboardExpiring => 'త్వరలో ఎక్స్‌పైర్ అయ్యేవి';

  @override
  String get dashboardWastage => 'వేస్టేజ్';

  @override
  String get dashboardPurchases => 'కొనుగోళ్లు';

  @override
  String get dashboardTopItems => 'ఎక్కువగా అమ్ముడైనవి';

  @override
  String get planTitle => 'సబ్‌స్క్రిప్షన్';

  @override
  String get planSubtitle => 'ఈ దుకాణానికి క్లౌడ్ ఫీచర్లు';

  @override
  String get planFree => 'ఉచితం';

  @override
  String get planPro => 'ప్రో';

  @override
  String get planFreeNote => 'ఈ ఫోన్‌లో అన్నీ ఉచితంగా పనిచేస్తూనే ఉంటాయి.';

  @override
  String get planProNote => 'ఈ దుకాణానికి క్లౌడ్ ఫీచర్లు యాక్టివ్‌గా ఉన్నాయి.';

  @override
  String get planCloudFeatures => 'క్లౌడ్ ఫీచర్లు';

  @override
  String get planFeatureAccount => 'క్లౌడ్ షాప్ అకౌంట్';

  @override
  String get planFeatureLiveSync => 'లైవ్ ఆర్డర్ బోర్డ్ సింక్';

  @override
  String get planFeatureQrOrdering => 'QR మెనూ ఆర్డరింగ్';

  @override
  String get planFeatureShareLinks => 'షేర్ చేయదగిన లింక్‌లు';

  @override
  String get planFeatureSoundbox => 'క్లౌడ్ సౌండ్‌బాక్స్';

  @override
  String get planFeatureBackup => 'మల్టీ-డివైస్ బ్యాకప్';

  @override
  String get planOn => 'ఆన్';

  @override
  String get planLocked => 'లాక్ చేయబడింది';

  @override
  String get planRefresh => 'సబ్‌స్క్రిప్షన్ తనిఖీ చేయండి';

  @override
  String get planChecking => 'తనిఖీ చేస్తోంది…';

  @override
  String get planCheckFailed =>
      'ఇప్పుడు తనిఖీ చేయడం వీలుపడలేదు. మునుపటి స్టేటస్ చూపబడుతోంది.';

  @override
  String get planNeedsShop => 'ముందుగా క్లౌడ్ షాప్‌ని సెటప్ చేయండి.';

  @override
  String get planOfflineNote =>
      'కొన్ని రోజులు ఆఫ్‌లైన్‌లో ఉన్నా ఫర్వాలేదు — గ్రేస్ పీరియడ్‌లో క్లౌడ్ ఫీచర్లు పనిచేస్తాయి.';

  @override
  String get shopTitle => 'నా దుకాణం';

  @override
  String get shopSubtitle => 'మీ వ్యాపారానికి తగిన వర్క్‌ఫ్లో';

  @override
  String get shopPickType => 'షాప్ రకం';

  @override
  String get shopWorkflow => 'రోజువారీ వర్క్‌ఫ్లో';

  @override
  String get shopTypeRestaurant => 'రెస్టారెంట్';

  @override
  String get shopTypeHotel => 'హోటల్';

  @override
  String get shopTypeStreet => 'స్ట్రీట్ స్టాల్';

  @override
  String get shopTypeDiy => 'DIY / క్రాఫ్ట్ స్టాల్';

  @override
  String get shopTypeMagnet => 'ఫ్రిజ్ మాగ్నెట్ స్టాల్';

  @override
  String get shopTypeTea => 'టీ షాప్';

  @override
  String get settingsOrderingTitle => 'ఆర్డరింగ్ నిబంధనలు';

  @override
  String get settingsOrderingSubtitle =>
      'సర్వీస్ రకం, పేమెంట్ సమయం, టేబుల్ బటన్లు';

  @override
  String get serviceStyle => 'సర్వీస్ రకం';

  @override
  String get serviceTable => 'టేబుల్ సర్వీస్';

  @override
  String get serviceSelf => 'సెల్ఫ్ సర్వీస్';

  @override
  String get serviceTakeaway => 'టేక్‌అవే మాత్రమే';

  @override
  String get paymentTiming => 'పేమెంట్ సమయం';

  @override
  String get payBefore => 'ముందే చెల్లించండి';

  @override
  String get payAfter => 'తర్వాత చెల్లించండి';

  @override
  String get payTimingHelp =>
      '\'ముందే చెల్లించండి\' అంటే ఆర్డర్ కన్ఫర్మ్ అయ్యే ముందే పేమెంట్ అడుగుతుంది. \'తర్వాత చెల్లించండి\' అంటే నేరుగా కిచెన్‌కి పంపుతుంది.';

  @override
  String get customerButtons => 'కస్టమర్ స్క్రీన్‌పై బటన్లు';

  @override
  String get allowCallStaff => 'స్టాఫ్‌ని పిలవండి';

  @override
  String get allowRequestBill => 'బిల్ అడగండి';

  @override
  String get customerButtonsHelp =>
      'ఇవి టేబుల్ సర్వీస్‌తో మాత్రమే కనిపిస్తాయి.';

  @override
  String get requestCallStaff => 'స్టాఫ్ కావాలి';

  @override
  String get requestBill => 'బిల్ ఇవ్వండి';

  @override
  String requestTable(String table) {
    return 'టేబుల్ $table';
  }

  @override
  String get requestCounter => 'కౌంటర్';

  @override
  String get requestSeen => 'చూశారు';

  @override
  String get payStateAwaiting => 'పేమెంట్ రావాలి';

  @override
  String get payStateDue => 'కౌంటర్ వద్ద చెల్లించండి';

  @override
  String get payStatePaid => 'చెల్లించారు';

  @override
  String get orderMarkPaid => 'చెల్లించినట్లు మార్క్ చేయండి';

  @override
  String get devicesTitle => 'ఫోన్లు & డివైజ్‌లు';

  @override
  String get devicesSubtitle => 'వెయిటర్, కిచెన్, కౌంటర్ ఫోన్లు ఒకే చోట';

  @override
  String get devicesPairThis => 'ఈ ఫోన్‌ను లింక్ చేయండి';

  @override
  String get devicesShopSlug => 'షాపు పేరు (మెనూ లింక్ పదం)';

  @override
  String get devicesEnterCode => 'ఓనర్ ఇచ్చే 6 అంకెల కోడ్';

  @override
  String get devicesLabel => 'ఫోన్ పేరు';

  @override
  String get devicesPairButton => 'ఫోన్‌ను లింక్ చేయండి';

  @override
  String get devicesPairSuccess => 'ఫోన్ షాపునకు లింక్ అయింది';

  @override
  String get devicesUnpair => 'ఈ ఫోన్ లింక్ తీసివేయండి';

  @override
  String devicesPairedAs(String role, String shop) {
    return '$role గా లింక్ అయింది · $shop';
  }

  @override
  String get devicesNewCode => 'కొత్త పెయిరింగ్ కోడ్';

  @override
  String get devicesCodeExpires =>
      '15 నిమిషాలు పనిచేస్తుంది · కాపీ చేయడానికి నొక్కండి';

  @override
  String get devicesList => 'లింక్ చేసిన ఫోన్లు';

  @override
  String get devicesEmpty => 'ఇంకా ఏ ఫోన్లు లింక్ చేయలేదు';

  @override
  String get devicesRevoke => 'తీసివేయండి';

  @override
  String get devicesRevoked => 'తీసివేశారు';

  @override
  String get devicesOnline => 'ఆన్‌లైన్';

  @override
  String get devicesOffline => 'ఆఫ్‌లైన్';

  @override
  String get devicesRoleWaiter => 'వెయిటర్';

  @override
  String get devicesRoleKitchen => 'కిచెన్';

  @override
  String get devicesRoleCounter => 'కౌంటర్';

  @override
  String get devicesProRequired =>
      'మల్టీ-డివైజ్ సింక్ అనేది Pro ఫీచర్. వెయిటర్, కిచెన్, కౌంటర్ ఫోన్లను కనెక్ట్ చేయడానికి అప్‌గ్రేడ్ చేయండి.';

  @override
  String get cloudShopSection => 'క్లౌడ్ షాప్';

  @override
  String get cloudShopHint =>
      'QR మెనూ ఆర్డర్లు, స్టాఫ్ ఫోన్లు ఒకే లైవ్ ఆర్డర్ లిస్ట్‌ను షేర్ చేసుకోవడానికి సర్వర్‌లో మీ షాప్‌ను క్రియేట్ చేయండి.';

  @override
  String get cloudShopSlug => 'లింక్‌ల కోసం షాపు పేరు (ఉదా. sirpam-tea)';

  @override
  String get cloudShopKey => 'షాప్ కీ (ప్రైవేట్, 16+ అక్షరాలు)';

  @override
  String get cloudShopGenerate => 'కీని జనరేట్ చేయండి';

  @override
  String get cloudShopCreate => 'క్లౌడ్ షాప్ క్రియేట్ చేయండి';

  @override
  String get cloudShopUpdate => 'క్లౌడ్ షాప్ అప్‌డేట్ చేయండి';

  @override
  String cloudShopLive(String slug) {
    return 'క్లౌడ్ షాప్ రెడీ: $slug';
  }

  @override
  String get cloudShopNone =>
      'ఇంకా క్లౌడ్ షాప్ లేదు. QR ఆర్డర్లు, స్టాఫ్ ఫోన్లు వాడటానికి ఒకటి క్రియేట్ చేయండి.';

  @override
  String get cloudShopCreated => 'క్లౌడ్ షాప్ క్రియేట్ అయింది';

  @override
  String get cloudShopKeyShort =>
      'షాపు పేరు మరియు కనీసం 16 అక్షరాల కీని ఎంటర్ చేయండి.';

  @override
  String get cloudShopCopyKey => 'కీ కాపీ చేయండి';

  @override
  String get cloudShopKeyCopied => 'షాప్ కీ కాపీ అయింది';

  @override
  String get approvalTitle => 'ఓనర్ అప్రూవల్';

  @override
  String approvalNeeded(String action) {
    return 'ఈ షిఫ్ట్‌లో ఇది చేయలేరు: $action. ఓనర్ ఒక్కసారి అనుమతించవచ్చు.';
  }

  @override
  String approvalOverLimit(String action) {
    return 'ఈ షిఫ్ట్ లిమిట్ కంటే ఎక్కువ ఉంది: $action. ఓనర్ ఒక్కసారి అనుమతించవచ్చు.';
  }

  @override
  String get approvalOwnerPin => 'ఓనర్ PIN';

  @override
  String get approvalApprove => 'ఒక్కసారి అనుమతించు';

  @override
  String get approvalGranted => 'ఓనర్ అనుమతించారు';

  @override
  String get approvalWrongPin => 'తప్పుడు ఓనర్ PIN';

  @override
  String get approvalBlockedTitle => 'అనుమతి లేదు';

  @override
  String approvalBlockedBody(String action) {
    return 'ఈ షిఫ్ట్‌కు $action చేసే యాక్సెస్ లేదు. రోల్ మార్చమని ఓనర్‌ను అడగండి.';
  }

  @override
  String get recurringRemove => 'తీసివేయి';

  @override
  String get recurringRemoved => 'రెగ్యులర్ ఖర్చు తొలగించబడింది';

  @override
  String recurringRemoveConfirm(String name) {
    return 'రెగ్యులర్ ఖర్చుల నుండి $nameని తీసివేయాలా?';
  }

  @override
  String get orderEditItems => 'ఐటమ్స్ మార్చు';

  @override
  String get orderEditItemsSaved => 'ఆర్డర్ ఐటమ్స్ అప్‌డేట్ అయ్యాయి';

  @override
  String get orderEditEmpty => 'ఆర్డర్‌లో కనీసం ఒక ఐటమ్ ఉండాలి.';

  @override
  String get printerStatus => 'ప్రింటర్ స్టేటస్';

  @override
  String get printerNotConnected => 'ప్రింటర్ కనెక్ట్ కాలేదు';

  @override
  String printerConnectedTo(String name) {
    return '$nameకి కనెక్ట్ అయింది';
  }

  @override
  String get printerDisconnect => 'డిస్‌కనెక్ట్ చేయి';

  @override
  String get printerDisconnected => 'ప్రింటర్ డిస్‌కనెక్ట్ అయింది';

  @override
  String get printerForget => 'ప్రింటర్‌ను తీసివేయి';

  @override
  String get printerForgotten =>
      'ప్రింటర్ తీసివేయబడింది. బిల్లులు PDF రూపంలో షేర్ చేయబడతాయి.';

  @override
  String get printerUnsupported =>
      'ఈ ఫోన్ నుండి బ్లూటూత్ ద్వారా ప్రింట్ చేయలేరు.';

  @override
  String get printerPermissionNeeded =>
      'యాప్ ప్రింటర్‌ను గుర్తించడానికి బ్లూటూత్ అనుమతి ఇవ్వండి.';

  @override
  String get printerPermissionDenied => 'బ్లూటూత్ అనుమతి ఇవ్వలేదు.';

  @override
  String get printerAllowBluetooth => 'బ్లూటూత్ అనుమతించు';

  @override
  String get devicesTest => 'కనెక్షన్ టెస్ట్ చేయి';

  @override
  String get devicesTestOk => 'షాపుకి కనెక్ట్ అయింది';

  @override
  String get devicesTestFailed =>
      'ఈ ఫోన్ కనెక్ట్ కాలేదు. ఓనర్‌ను కొత్త కోడ్ అడగండి.';

  @override
  String stockLastUpdated(String when) {
    return 'స్టాక్ చివరిగా అప్‌డేట్ చేసింది $when';
  }

  @override
  String get agoJustNow => 'ఇప్పుడే';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నిమిషాల క్రితం',
      one: '1 నిమిషం క్రితం',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count గంటల క్రితం',
      one: '1 గంట క్రితం',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రోజుల క్రితం',
      one: '1 రోజు క్రితం',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'ఉదయం ప్రిపరేషన్';

  @override
  String get prepSubtitle => 'మొదటి కస్టమర్ వచ్చేసరికి సిద్ధంగా ఉండాల్సినవి';

  @override
  String prepPending(String count) {
    return 'ఇంకా $count సిద్ధం చేయాలి';
  }

  @override
  String get prepUseStarter => 'స్టార్టర్ షీట్ వాడండి';

  @override
  String get prepTodaySheet => 'ఈరోజు షీట్';

  @override
  String get prepAddTitle => 'ప్రిపరేషన్ ఐటమ్ జోడించు';

  @override
  String get prepItemName => 'ఐటమ్';

  @override
  String get prepPlanned => 'ప్లాన్ చేసినవి';

  @override
  String get prepMade => 'చేసినవి';

  @override
  String get prepUnit => 'యూనిట్';

  @override
  String get prepAdd => 'షీట్‌లో చేర్చండి';

  @override
  String prepShort(String qty) {
    return '$qty తక్కువయ్యాయి';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$planned $unitలలో $made';
  }

  @override
  String get prepSeedMilk => 'పాలు';

  @override
  String get prepSeedBatter => 'పిండి';

  @override
  String get prepSeedSnacks => 'స్నాక్స్';

  @override
  String get prepSeedChange => 'చిల్లర';

  @override
  String get prepSeedDisplay => 'డిస్‌ప్లే సర్దండి';

  @override
  String get prepSeedStock => 'షెల్ఫ్‌లు నింపండి';

  @override
  String get prepUnitLitre => 'లీటర్';

  @override
  String get prepUnitPlate => 'ప్లేట్';

  @override
  String get prepUnitPiece => 'పీస్';

  @override
  String get prepUnitRupee => 'రూపాయి';

  @override
  String get insightsRush => 'రద్దీ సమయాలు';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return '$hour:00 గంటలకు $bills బిల్లులతో ఫుల్ రద్దీ — కౌంటర్ దగ్గర $staff ఉండేలా చూసుకోండి';
  }

  @override
  String get dayCloseOpeningCash => 'ఓపెనింగ్ క్యాష్';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item అయిపోయినట్లు మార్క్ చేయబడింది';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item మళ్లీ అమ్మకానికి సిద్ధం';
  }

  @override
  String get insightsHeroes => 'ఈ రోజు టాప్ ఐటమ్స్';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold అమ్మారు · $left మిగిలాయి';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return 'దాదాపు $hour:00 గంటలకు అయిపోవచ్చు';
  }

  @override
  String get customerLapsedTitle => 'ఈ మధ్య రానివాళ్లు';

  @override
  String get customerLapsedHint =>
      'ఓ చిన్న మెసేజ్ పంపితే మళ్లీ వచ్చే అవకాశం ఉంది.';

  @override
  String customerLapsedDays(String days) {
    return 'వచ్చి $days రోజులు అయింది';
  }

  @override
  String get customerNudge => 'మెసేజ్ పంపండి';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'హలో $name, $shopకి రాక చాలా రోజులైంది! ఈ వారం మీ కోసం కొత్త వెరైటీలు సిద్ధంగా ఉన్నాయి.';
  }

  @override
  String get offersTitle => 'ఆఫర్లు';

  @override
  String get offersSubtitle =>
      'మీరు ఇచ్చే డిస్కౌంట్లు, వాటి వల్ల మీకు అయ్యే ఖర్చు.';

  @override
  String get offerAdd => 'ఆఫర్‌ను జోడించండి';

  @override
  String get offerName => 'ఆఫర్ పేరు';

  @override
  String get offerCode => 'కస్టమర్ చెప్పే కోడ్ (ఐచ్ఛికం)';

  @override
  String get offerKindFlat => 'రూపాయల్లో తగ్గింపు';

  @override
  String get offerKindPercent => 'శాతంలో తగ్గింపు (%)';

  @override
  String get offerKindCombo => 'కాంబో ధర';

  @override
  String get offerAmount => 'తగ్గింపు మొత్తం';

  @override
  String get offerPercent => 'శాతం తగ్గింపు';

  @override
  String get offerComboPrice => 'కాంబో ధర';

  @override
  String get offersGivenTotal => 'ఇప్పటివరకు ఇచ్చినవి';

  @override
  String get offersEmpty =>
      'ఇంకా ఆఫర్లు ఏమీ లేవు. ఆఫర్ జోడిస్తే బిల్లుపై కనిపిస్తుంది.';

  @override
  String get offerLive => 'లైవ్';

  @override
  String get offerPaused => 'పాజ్ అయింది';

  @override
  String get offerPause => 'పాజ్ చేయండి';

  @override
  String get offerResume => 'మళ్లీ ప్రారంభించండి';

  @override
  String offerUsed(String count) {
    return '$count సార్లు వాడారు';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount తగ్గింపు ఇచ్చారు';
  }

  @override
  String get feedbackTitle => 'బిల్లు ఫీడ్‌బ్యాక్';

  @override
  String get feedbackSubtitle =>
      'చెల్లించాక 3 ట్యాప్‌లలో ఇచ్చే రేటింగ్, నేరుగా మీకే వస్తుంది.';

  @override
  String get feedbackQrTitle => 'కౌంటర్ QR';

  @override
  String get feedbackQrHint =>
      'దీన్ని ప్రింట్ తీసి కౌంటర్‌పై పెట్టండి, లేదా పేమెంట్ తర్వాత చూపించండి.';

  @override
  String get feedbackReviewMissing =>
      'కస్టమర్లు పబ్లిక్‌గా రివ్యూ ఇవ్వడానికి \'గ్రోత్\'లో మీ రివ్యూ పేజీ లింక్‌ను చేర్చండి.';

  @override
  String get feedbackLinkCopied => 'లింక్ కాపీ అయింది';

  @override
  String get feedbackScores => 'స్కోర్లు';

  @override
  String get feedbackTodayAvg => 'ఈరోజు (సగటు · సంఖ్య)';

  @override
  String get feedbackWeekAvg => 'గత 7 రోజులు (సగటు · సంఖ్య)';

  @override
  String get feedbackNeedsReply => 'రిప్లై ఇవ్వాలి';

  @override
  String get feedbackRecord => 'మీరే రేటింగ్ జోడించండి';

  @override
  String get feedbackHappy => 'బాగుంది';

  @override
  String get feedbackOkay => 'పర్వాలేదు';

  @override
  String get feedbackUnhappy => 'బాగోలేదు';

  @override
  String get feedbackRecent => 'ఇటీవలి రేటింగ్‌లు';

  @override
  String get feedbackEmpty => 'ఇంకా రేటింగ్‌లు లేవు.';

  @override
  String get enquiriesTitle => 'ఎంక్వైరీలు';

  @override
  String get enquiriesSubtitle =>
      'ఎవరు అడిగారు, మీరు ఎంత చెప్పారు, తర్వాత ఏమైంది.';

  @override
  String get enquiryAdd => 'ఎంక్వైరీని జోడించండి';

  @override
  String get enquiryName => 'కస్టమర్ పేరు';

  @override
  String get enquiryPhone => 'ఫోన్';

  @override
  String get enquiryWant => 'వారు ఏమి అడిగారు';

  @override
  String get enquiryQuote => 'మీరు చెప్పిన ధర';

  @override
  String get enquiryNoFollowUp => 'రిమైండర్ లేదు';

  @override
  String enquiryFollowUpDays(String days) {
    return '$days రోజుల్లో ఫాలో అప్ చేయండి';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% అమ్మకాలుగా మారాయి';
  }

  @override
  String get enquiryWonValue => 'వచ్చిన సేల్స్ విలువ';

  @override
  String get enquiryFilterToday => 'ఈరోజు';

  @override
  String get enquiryFilterOpen => 'ఓపెన్';

  @override
  String get enquiryFilterWon => 'సేల్ అయింది';

  @override
  String get enquiryFilterLost => 'మిస్ అయినవి';

  @override
  String get enquiryEmpty => 'ఇక్కడ ఏమీ లేదు.';

  @override
  String enquiryFollowUpOn(String day) {
    return '$dayన ఫాలో అప్ చేయండి';
  }

  @override
  String get enquiryMessage => 'మెసేజ్';

  @override
  String enquiryMessageText(String name, String item) {
    return 'నమస్తే $name, $item గురించి కనుక్కుంటున్నాం. మీ కోసం రెడీగా ఉంచమంటారా?';
  }

  @override
  String get enquiryWon => 'సక్సెస్';

  @override
  String get enquiryLost => 'మిస్ అయింది';

  @override
  String get enquiryReopen => 'మళ్లీ తెరవండి';

  @override
  String get customerRewardsDueTitle => 'ఇవ్వాల్సిన రివార్డులు';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'ఆ లింక్ పేరు ఇప్పటికే వాడకంలో ఉంది. $slug లాంటిది ట్రై చేయండి.';
  }

  @override
  String get cloudShopSlugInvalid =>
      'కనీసం 3 అక్షరాలు ఉండాలి. చిన్న అక్షరాలు, నంబర్లు, డాష్‌లు (-) మాత్రమే వాడండి.';

  @override
  String get cloudShopOffline =>
      'ప్రస్తుతం ఇంటర్నెట్ లేదు. కనెక్షన్ చూసుకుని మళ్లీ ప్రయత్నించండి.';

  @override
  String get cloudShopTryAgain =>
      'పని కాలేదు. కాసేపటి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get cloudShopLinkTitle => 'కస్టమర్ లింక్';

  @override
  String get cloudShopCopyLink => 'లింక్ కాపీ చేయండి';

  @override
  String get cloudShopLinkCopied => 'లింక్ కాపీ అయింది';

  @override
  String get cloudShopShowQr => 'QR చూపించండి';

  @override
  String get paymentQrScanTitle => 'మీ పేమెంట్ యాప్ QR వాడండి';

  @override
  String get paymentQrScanAction => 'నా QR స్కాన్ చేయండి';

  @override
  String get paymentQrScanHelp =>
      'GPay, PhonePe లేదా Paytm QR స్టిక్కర్‌పై కెమెరా పెట్టండి. దాని నుండి UPI ID తీసుకుంటాం, అప్పుడు బిల్లులు, కౌంటర్ QR చెల్లింపులు ఒకే ఖాతాలోకి వస్తాయి.';

  @override
  String paymentQrScanFound(String vpa) {
    return 'మీ QR నుండి వచ్చిన UPI ID: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'ఇది పేమెంట్ QR కాదు. మీ పేమెంట్ యాప్‌లో కనిపించే QRని ట్రై చేయండి.';

  @override
  String get receiptFeedbackLine => 'మీ అభిప్రాయం చెప్పడానికి స్కాన్ చేయండి';

  @override
  String get qrPrintCounterCard => 'కౌంటర్ కార్డ్ ప్రింట్ చేయండి';

  @override
  String get qrPayCaption => 'చెల్లించడానికి స్కాన్ చేయండి';

  @override
  String get qrFeedbackCaption => 'రేటింగ్ ఇవ్వడానికి స్కాన్ చేయండి';

  @override
  String get offerPrintCards => 'ఆఫర్ కార్డులు ప్రింట్ చేయండి';

  @override
  String get offerCardCaption => 'ఈ ఆఫర్ పొందడానికి స్కాన్ చేయండి';

  @override
  String get devicesPairQrHint => 'కొత్త ఫోన్‌తో దీన్ని స్కాన్ చేయించండి';

  @override
  String get devicesScanQr => 'పెయిరింగ్ QR స్కాన్ చేయండి';

  @override
  String get devicesScanInvalid =>
      'ఇది పెయిరింగ్ QR కాదు. ఓనర్‌ని మళ్లీ చూపించమనండి.';

  @override
  String get quickSaleScan => 'ఐటమ్ స్కాన్ చేయండి';

  @override
  String get quickSaleScanTitle => 'ఐటమ్ లేబుల్ స్కాన్ చేయండి';

  @override
  String quickSaleScanUnknown(String code) {
    return '$code కోడ్‌తో ఏ ఐటమ్ దొరకలేదు. ప్రోడక్ట్స్‌లో దీన్ని యాడ్ చేయండి.';
  }

  @override
  String get backupTitle => 'బ్యాకప్ & ఎక్స్‌పోర్ట్';

  @override
  String get backupSubtitle => 'మీ ఖాతా పుస్తకాల కాపీని భద్రంగా ఉంచుకోండి';

  @override
  String get backupNowAction => 'ఇప్పుడే బ్యాకప్ తీయండి';

  @override
  String get backupRestoreAction => 'ఫైల్ నుండి రీస్టోర్ చేయండి';

  @override
  String get backupShareSubject => 'VendorOS బ్యాకప్';

  @override
  String get backupSavedToast => 'బ్యాకప్ ఫైల్ తయారైంది';

  @override
  String get backupFailedToast =>
      'బ్యాకప్ చేయడం కుదరలేదు. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get backupRestoredToast => 'మీ ఖాతా లెక్కలు రీస్టోర్ అయ్యాయి';

  @override
  String get backupNeverSaved => 'ఎప్పుడూ బ్యాకప్ చేయలేదు';

  @override
  String backupLastSaved(String when) {
    return 'చివరి బ్యాకప్: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'దాదాపు $kb KB సేవ్ అవుతుంది';
  }

  @override
  String get backupRestoreWarning =>
      'రీస్టోర్ చేస్తే ఈ ఫోన్‌లోని సమాచారం పోయి ఫైల్‌లోనివి వస్తాయి.';

  @override
  String get backupRestoreConfirmTitle => 'ఈ బ్యాకప్‌ను రీస్టోర్ చేయాలా?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$when నాటి $rows ఎంట్రీలు ఈ ఫోన్‌లోని డేటాను రీప్లేస్ చేస్తాయి.';
  }

  @override
  String get backupErrorNotFile => 'ఇది VendorOS బ్యాకప్ ఫైల్ కాదు.';

  @override
  String get backupErrorTooNew =>
      'ఈ బ్యాకప్ కొత్త వెర్షన్‌ది. దయచేసి ముందుగా యాప్‌ను అప్‌డేట్ చేయండి.';

  @override
  String get backupErrorCorrupt => 'ఈ బ్యాకప్ ఫైల్ పాడైంది, పని చేయదు.';

  @override
  String get backupErrorEmpty => 'ఫైల్ ఖాళీగా ఉంది.';

  @override
  String get exportGroupLabel => 'స్ప్రెడ్‌షీట్‌గా ఎక్స్‌పోర్ట్ చేయండి';

  @override
  String get exportSalesTitle => 'అమ్మకాలు';

  @override
  String get exportSalesSubtitle =>
      'తేదీ, ఐటమ్ మరియు మొత్తంతో ప్రతి అమ్మకం వివరాలు';

  @override
  String get exportBillsTitle => 'బిల్లులు';

  @override
  String get exportBillsSubtitle =>
      'బిల్లుల వారీగా మొత్తం, డిస్కౌంట్ మరియు ట్యాక్స్';

  @override
  String get exportCreditTitle => 'బాకీ బ్యాలెన్స్‌లు';

  @override
  String get exportCreditSubtitle => 'ఎవరు ఎంత బాకీ ఉన్నారో వివరాలు';

  @override
  String get exportStockTitle => 'స్టాక్';

  @override
  String get exportStockSubtitle => 'ఐటమ్‌లు, ఉన్న స్టాక్ మరియు ధరలు';

  @override
  String get exportColDate => 'తేదీ';

  @override
  String get exportColItem => 'ఐటమ్';

  @override
  String get exportColMode => 'చెల్లింపు';

  @override
  String get exportColCustomer => 'కస్టమర్';

  @override
  String get exportColAmount => 'మొత్తం';

  @override
  String get exportColBillNo => 'బిల్లు నం.';

  @override
  String get exportColSubtotal => 'సబ్ టోటల్';

  @override
  String get exportColDiscount => 'డిస్కౌంట్';

  @override
  String get exportColTax => 'ట్యాక్స్';

  @override
  String get exportColTotal => 'మొత్తం';

  @override
  String get exportColPayment => 'చెల్లించిన విధానం';

  @override
  String get exportColStatus => 'స్టేటస్';

  @override
  String get exportColBalance => 'బ్యాలెన్స్';

  @override
  String get exportColCode => 'కోడ్';

  @override
  String get exportColCategory => 'కేటగిరీ';

  @override
  String get exportColUnit => 'యూనిట్';

  @override
  String get exportColQty => 'క్వాంటిటీ';

  @override
  String get exportColCost => 'కొన్న ధర';

  @override
  String get exportColPrice => 'ధర';

  @override
  String get gstReportTitle => 'GST సారాంశం';

  @override
  String get gstReportSubtitle => 'మీ అకౌంటెంట్ కోసం నెలవారీ ట్యాక్స్';

  @override
  String get gstReportEmpty =>
      'ఇంకా GST బిల్లులు లేవు. Menu సెట్టింగ్స్‌లో GST ఆన్ చేసి, ఐటెమ్ బిల్ చేయండి.';

  @override
  String get gstColMonth => 'నెల';

  @override
  String get gstColRate => 'రేటు';

  @override
  String get gstColTaxable => 'ట్యాక్సబుల్ విలువ';

  @override
  String get gstColTax => 'మొత్తం ట్యాక్స్';

  @override
  String get gstBills => 'బిల్లులు';

  @override
  String get gstSales => 'ట్యాక్స్‌తో అమ్మకాలు';

  @override
  String get gstByRate => 'రేటు ప్రకారం';

  @override
  String get gstShareAction => 'స్ప్రెడ్‌షీట్ షేర్ చేయండి';

  @override
  String gstShareSubject(String month) {
    return 'GST సారాంశం $month';
  }

  @override
  String get appearanceTitle => 'అప్పియరెన్స్';

  @override
  String get appearanceSubtitle => 'లైట్ లేదా డార్క్ స్క్రీన్';

  @override
  String get appearanceSystem => 'ఫోన్ లాగే';

  @override
  String get appearanceLight => 'లైట్';

  @override
  String get appearanceDark => 'డార్క్';

  @override
  String get appearanceChanged => 'అప్పియరెన్స్ మారింది';

  @override
  String get purchasesTitle => 'కొనుగోళ్లు';

  @override
  String get purchasesSubtitle => 'సప్లయర్ బిల్లులు మరియు బాకీ వివరాలు';

  @override
  String get purchasesEmpty =>
      'ఇంకా కొనుగోలు బిల్లులు లేవు. మీరు కొన్న చివరి స్టాక్ వివరాలు చేర్చండి.';

  @override
  String get purchaseAdd => 'కొనుగోలు చేర్చండి';

  @override
  String get purchaseTotalDue => 'సప్లయర్లకు బాకీ';

  @override
  String get purchaseMonthSpend => 'ఈ నెల కొన్నది';

  @override
  String get purchaseDuesTitle => 'సప్లయర్ బాకీలు';

  @override
  String get purchaseNoDues => 'సప్లయర్ బిల్లులన్నీ చెల్లించబడ్డాయి.';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills బిల్లు(లు) · పాతది $days రోజు(లు)';
  }

  @override
  String get purchaseBillsTitle => 'కొనుగోలు బిల్లులు';

  @override
  String get purchasePaidFull => 'చెల్లించారు';

  @override
  String purchaseDueOf(String amount) {
    return '$amount బాకీ';
  }

  @override
  String get purchaseSupplier => 'సప్లయర్';

  @override
  String purchasePayTitle(String name) {
    return '$nameకి చెల్లించండి';
  }

  @override
  String get purchasePayAmount => 'చెల్లించిన మొత్తం';

  @override
  String get purchasePay => 'పేమెంట్ నమోదు చేయండి';

  @override
  String get purchaseSubtotal => 'ఐటెమ్ మొత్తం';

  @override
  String get purchaseTax => 'ట్యాక్స్';

  @override
  String get purchaseTotal => 'బిల్లు మొత్తం';

  @override
  String get purchaseDue => 'మిగిలిన బాకీ';

  @override
  String get purchaseNewTitle => 'కొత్త కొనుగోలు బిల్లు';

  @override
  String get purchaseInvoiceNo => 'బిల్లు నంబర్';

  @override
  String get purchaseItems => 'కొన్న సరుకులు';

  @override
  String get purchaseLinkProduct => 'స్టాక్ లిస్ట్ నుండి ఎంచుకోండి';

  @override
  String get purchaseFreeItem => 'ఐటమ్ పేరు';

  @override
  String get purchaseQty => 'పరిమాణం';

  @override
  String get purchaseUnitCost => 'ఒక్కోదాని ధర';

  @override
  String get purchaseAddLine => 'ఐటమ్ జోడించండి';

  @override
  String get purchasePaidNow => 'ఇప్పుడు చెల్లించినది';

  @override
  String get purchaseNote => 'నోట్';

  @override
  String get purchaseSaved =>
      'కొనుగోలు సేవ్ అయ్యింది, స్టాక్ అప్‌డేట్ అయ్యింది';

  @override
  String get permRecordPurchase => 'కొనుగోలు బిల్లులను నమోదు చేయండి';

  @override
  String get permPaySupplier => 'సప్లయర్లకు చెల్లించండి';

  @override
  String get backupCloudTitle => 'ఆన్‌లైన్ బ్యాకప్';

  @override
  String backupCloudLast(String when) {
    return 'చివరి ఆన్‌లైన్ బ్యాకప్: $when';
  }

  @override
  String get backupCloudNever => 'ఇంకా ఆన్‌లైన్‌లో సేవ్ కాలేదు';

  @override
  String get backupCloudNeedsShop => 'ముందుగా క్లౌడ్ షాప్ సృష్టించండి';

  @override
  String get backupCloudNowAction => 'ఇప్పుడు ఆన్‌లైన్ బ్యాకప్ తీసుకోండి';

  @override
  String get backupCloudRestoreAction => 'ఆన్‌లైన్ నుండి పునరుద్ధరించండి';

  @override
  String get backupCloudSavedToast => 'ఆన్‌లైన్‌లో సేవ్ అయింది';

  @override
  String get backupCloudFailedToast =>
      'ఆన్‌లైన్‌లో సేవ్ కాలేదు. సిగ్నల్ వచ్చాక మళ్లీ ప్రయత్నించండి.';

  @override
  String get billWhatsapp => 'వాట్సాప్‌లో పంపండి';

  @override
  String get billWhatsappFailed => 'ఈ ఫోన్‌లో వాట్సాప్ లేదు.';

  @override
  String get devicesStaffRole => 'సిబ్బంది పాత్ర';

  @override
  String get devicesRoleDefault => 'డిఫాల్ట్ (పని మాత్రమే)';

  @override
  String get devicesRolePick => 'ఒక సిబ్బంది పాత్రను ఎంచుకోండి';

  @override
  String get devicesRoleSaved => 'పాత్ర ఆ ఫోన్‌కు పంపబడింది';

  @override
  String get devicesRoleFailed =>
      'పాత్రను సెట్ చేయలేకపోయాం. ఆన్‌లైన్‌లో ఉన్నప్పుడు మళ్లీ ప్రయత్నించండి.';

  @override
  String get adminTitle => 'యజమాని నివేదికలు';

  @override
  String get adminSubtitle => 'ఏం జరిగింది, ఎవరు చేశారు, నగదు సరిపోయిందా';

  @override
  String get adminExceptionsTitle => 'మినహాయింపులు';

  @override
  String get adminExceptionsSubtitle =>
      'డిస్కౌంట్, రద్దు బిల్లులు, రీప్రింట్, అప్పు';

  @override
  String get adminStaffTitle => 'సిబ్బంది నివేదిక';

  @override
  String get adminStaffSubtitle => 'ఈ కాలంలో ఎవరు ఏం చేశారు';

  @override
  String get adminCashTitle => 'నగదు పుస్తకం';

  @override
  String get adminCashSubtitle => 'అంచనా వర్సెస్ లెక్కించినది, రోజువారీ';

  @override
  String get adminItemsTitle => 'వస్తువుల తేడా';

  @override
  String get adminItemsSubtitle => 'అమ్మినది వర్సెస్ స్టాక్ నుండి తీసినది';

  @override
  String get adminShopsTitle => 'అన్ని దుకాణాలు';

  @override
  String get adminShopsSubtitle => 'మీరు నడిపే ప్రతి దుకాణం మొత్తం';

  @override
  String get adminSummaryTitle => 'ఈరోజు సారాంశం';

  @override
  String get adminSummarySend => 'సారాంశం పంపండి';

  @override
  String get adminShare => 'పంచుకోండి';

  @override
  String get adminNoRows => 'ఈ కాలానికి ఏమీ లేదు';

  @override
  String get adminFromBill => 'బిల్లు నుండి';

  @override
  String get adminOwnerApproved => 'యజమాని ఆమోదించారు';

  @override
  String get adminColActions => 'చర్యలు';

  @override
  String get adminColDiscount => 'ఇచ్చిన డిస్కౌంట్';

  @override
  String get adminColCredit => 'ఇచ్చిన అప్పు';

  @override
  String get adminColVoids => 'రద్దు చేసిన బిల్లులు';

  @override
  String get adminColReprints => 'రీప్రింట్లు';

  @override
  String get adminColOverrides => 'యజమాని ఆమోదాలు';

  @override
  String get adminSeeExceptions => 'వీరి మినహాయింపులు చూడండి';

  @override
  String get adminCashOpening => 'ప్రారంభ నగదు';

  @override
  String get adminCashExpected => 'అంచనా';

  @override
  String get adminCashCounted => 'లెక్కించినది';

  @override
  String get adminCashShort => 'తక్కువ';

  @override
  String get adminCashOver => 'ఎక్కువ';

  @override
  String get adminCashNet => 'నికర తేడా';

  @override
  String get adminCashMatched => 'సరిపోయిన రోజులు';

  @override
  String get adminCashMatchedOne => 'సరిపోయింది';

  @override
  String get adminCashShortDays => 'తక్కువ ఉన్న రోజులు';

  @override
  String get adminItemSold => 'అమ్మినది';

  @override
  String get adminItemStockOut => 'స్టాక్ నుండి తీసినది';

  @override
  String get adminItemGap => 'తేడా';

  @override
  String get adminItemWasted => 'వృథా';

  @override
  String get adminSummaryBills => 'బిల్లులు';

  @override
  String get adminSummarySales => 'అమ్మకాలు';

  @override
  String get adminSummaryCash => 'నగదు';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'అప్పు';

  @override
  String get adminSummaryDiscount => 'డిస్కౌంట్లు';

  @override
  String get adminSummarySpend => 'ఖర్చు';

  @override
  String get adminSummaryCashDiff => 'నగదు తేడా';

  @override
  String get adminSummaryTop => 'టాప్ వస్తువులు';

  @override
  String get adminShopsAllTotal => 'అన్ని దుకాణాలు కలిపి';

  @override
  String get adminShopsOrders => 'ఆర్డర్లు (7 రోజులు)';

  @override
  String get adminShopsValue => 'విలువ (7 రోజులు)';

  @override
  String get adminShopsAdd => 'మరో దుకాణం జోడించండి';

  @override
  String get adminShopsAddHelp =>
      'ఇతర దుకాణం లింక్ పేరు, యజమాని కీ టైప్ చేయండి.';

  @override
  String get adminShopsAddAction => 'దుకాణం జోడించు';

  @override
  String get adminShopsSlug => 'దుకాణం లింక్ పేరు';

  @override
  String get adminShopsKey => 'యజమాని కీ';

  @override
  String get adminShopsRemove => 'తీసివేయి';

  @override
  String get adminShopsRefresh => 'రిఫ్రెష్';

  @override
  String get adminShopsError => 'ఈ దుకాణం చదవలేకపోయాం';

  @override
  String get adminShopsInvalid => 'లింక్ పేరు, యజమాని కీ చూడండి';

  @override
  String get adminShopsExists => 'ఆ దుకాణం ఇప్పటికే జాబితాలో ఉంది';

  @override
  String get permViewCashBook => 'నగదు పుస్తకం చూడు';

  @override
  String get permExportData => 'డేటా ఎగుమతి';

  @override
  String get permViewStaffReport => 'సిబ్బంది నివేదికలు చూడు';
}
