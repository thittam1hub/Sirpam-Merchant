// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'नमस्ते $name, $stall पर आपका Rs $amount बकाया है। कृपया भुगतान करें। धन्यवाद।$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'होम';

  @override
  String get navUdhaar => 'उधार';

  @override
  String get navSoundbox => 'साउंड';

  @override
  String get navMandi => 'मंडी';

  @override
  String get navSales => 'बिक्री';

  @override
  String get navGroupOverview => 'ओवरव्यू';

  @override
  String get navGroupSell => 'बेचें';

  @override
  String get navGroupOperations => 'ग्राहक और कामकाज';

  @override
  String get navGroupBusiness => 'कारोबार';

  @override
  String get navGroupTeam => 'टीम';

  @override
  String get navGroupSystem => 'सिस्टम';

  @override
  String get moreLabel => 'और';

  @override
  String get menuLoanReport => 'लोन रिपोर्ट';

  @override
  String get menuCartLocation => 'ठेले की लोकेशन';

  @override
  String get menuSettings => 'सेटिंग्स';

  @override
  String get notFoundTitle => 'पेज नहीं मिला';

  @override
  String get goHome => 'होम पर जाएं';

  @override
  String get ok => 'ठीक है';

  @override
  String get loading => 'लोड हो रहा है…';

  @override
  String storageWriteFailedKey(String key) {
    return 'सेव नहीं हो सका ($key) — फिर कोशिश करें';
  }

  @override
  String get storageWriteFailed => 'सेव नहीं हो सका — फिर कोशिश करें';

  @override
  String get micUnavailable => 'माइक चालू नहीं है — हाथ से दर्ज करें';

  @override
  String get voiceNothingHeard => 'कुछ सुनाई नहीं दिया — दोबारा बोलें';

  @override
  String get voiceNoAmount => 'रकम समझ नहीं आई — बोलें \"50 रुपये टमाटर\"';

  @override
  String get voiceZeroAmount => 'रकम 0 नहीं हो सकती';

  @override
  String get modeCash => 'कैश';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'उधार';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount दर्ज हुआ';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'आज की कुल बिक्री $amount रुपये';
  }

  @override
  String get todayCollection => 'आज का कलेक्शन';

  @override
  String get quickEntry => 'तुरंत एंट्री';

  @override
  String get todayEntries => 'आज की एंट्री';

  @override
  String get noEntriesYet => 'अभी कोई एंट्री नहीं — माइक दबाकर बोलें';

  @override
  String get listeningTapToStop => 'सुन रहे हैं, रोकने के लिए दबाएं';

  @override
  String get tapToSpeak => 'बोलकर दर्ज करें';

  @override
  String get listening => 'सुन रहे हैं…';

  @override
  String get speakToRecord => '🎙️ बोलकर दर्ज करें';

  @override
  String get voiceHint => '\"50 रुपये टमाटर कैश\" / \"रवि को 200 उधार\"';

  @override
  String get addSale => 'बिक्री जोड़ें';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount रुपये, $item';
  }

  @override
  String get delete => 'हटाएं';

  @override
  String get locationServiceOff => 'लोकेशन सेवा बंद है';

  @override
  String get locationPermissionDenied => 'लोकेशन की अनुमति नहीं मिली';

  @override
  String get broadcastLive => 'लाइव ब्रॉडकास्ट चालू है';

  @override
  String get locationSearching => 'लोकेशन खोजी जा रही है…';

  @override
  String get permissionDenied => 'अनुमति नहीं मिली';

  @override
  String get unavailable => 'उपलब्ध नहीं';

  @override
  String get broadcastStopped => 'ब्रॉडकास्ट बंद हुआ';

  @override
  String get locationNotFetched => 'लोकेशन अभी नहीं मिली';

  @override
  String get stopBroadcast => 'ब्रॉडकास्ट रोकें';

  @override
  String get startBroadcast => 'ब्रॉडकास्ट शुरू करें';

  @override
  String get sendToCustomer => 'ग्राहकों को भेजें';

  @override
  String get shareLocationHint => 'आज ठेले की लोकेशन WhatsApp पर शेयर करें।';

  @override
  String get ourCart => 'हमारा ठेला';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall आज यहाँ है 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'WhatsApp पर शेयर करें';

  @override
  String get openInMaps => 'Maps में खोलें';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in ने अनुरोध अस्वीकार किया — API key जांचें ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'कनेक्शन नहीं हो पाया: $error';
  }

  @override
  String get mandiTitle => 'मंडी भाव';

  @override
  String get refresh => 'रिफ्रेश करें';

  @override
  String get mandiLoading => 'मंडी भाव लोड हो रहे हैं';

  @override
  String get fetchFailed => 'डेटा नहीं मिल पाया';

  @override
  String get apiKeyNeeded => 'data.gov.in API key ज़रूरी है';

  @override
  String get apiKeyNeededBody =>
      'लाइव APMC भावों के लिए data.gov.in से मुफ़्त API key लें और सेटिंग्स में जोड़ें। फ़र्ज़ी भाव नहीं दिखाए जाते।';

  @override
  String get refreshFailed => 'ताज़ा अपडेट नहीं हो पाया';

  @override
  String lastUpdated(String time) {
    return 'आखिरी अपडेट: $time';
  }

  @override
  String get searchVegetable => 'सब्ज़ी खोजें';

  @override
  String get loanReportHeading => 'बिज़नेस लोन रिपोर्ट';

  @override
  String reportFailed(String error) {
    return 'रिपोर्ट नहीं बन पाई: $error';
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
      other: '$daysString दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'कुल बिक्री';

  @override
  String get digitalShare => 'डिजिटल हिस्सा';

  @override
  String get avgDailyIncome => 'रोज़ाना औसत कमाई';

  @override
  String get recordedDays => 'दर्ज दिन';

  @override
  String get sha256Checksum => 'SHA-256 चेकसम';

  @override
  String get noSalesYet =>
      'अभी कोई बिक्री दर्ज नहीं है — रिपोर्ट बनाने के लिए पहले बिक्री दर्ज करें।';

  @override
  String get viewPdf => 'PDF देखें';

  @override
  String get sendToBank => 'बैंक में भेजें';

  @override
  String get stallName => 'स्टॉल का नाम';

  @override
  String get ownerName => 'मालिक का नाम';

  @override
  String get upiVpaLabel => 'UPI VPA (जैसे name@okaxis)';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get mandiMarket => 'मंडी (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API key';

  @override
  String get apiKeyHelp =>
      'key पाने के लिए data.gov.in पर मुफ़्त रजिस्टर करें। बिना key के लाइव भाव नहीं दिखेंगे।';

  @override
  String get soundboxAnnounce => 'साउंडबॉक्स आवाज़';

  @override
  String get save => 'सेव करें';

  @override
  String soundboxSpeech(String amount) {
    return '$amount रुपये प्राप्त हुए';
  }

  @override
  String get soundboxTitle => 'साउंडबॉक्स';

  @override
  String get soundboxSubtitle => 'UPI पेमेंट की आवाज़ अपनी भाषा में सुनें';

  @override
  String get watchedApps => 'ट्रैक किए जाने वाले ऐप';

  @override
  String get soundboxTestHint => 'टेस्ट: \"250 रुपये प्राप्त हुए\" सुनाई देगा';

  @override
  String get speak => 'बोलकर सुनाएं';

  @override
  String get announcedPayments => 'सुनाई गई पेमेंट';

  @override
  String get noUpiYet => 'अभी तक कोई UPI पेमेंट नहीं मिली';

  @override
  String get soundboxRunning => 'साउंडबॉक्स चालू है';

  @override
  String get notificationAccessNeeded => 'नोटिफिकेशन परमिशन ज़रूरी है';

  @override
  String get soundboxAndroidHint =>
      'PhonePe, Paytm, Google Pay और BHIM से पेमेंट आने पर आवाज़ आएगी।';

  @override
  String get soundboxGrantHint =>
      'Android सेटिंग्स में VendorOS को नोटिफिकेशन की परमिशन दें।';

  @override
  String get grantAccess => 'परमिशन दें';

  @override
  String get iosUnavailable => 'iOS पर उपलब्ध नहीं है';

  @override
  String get webUnavailable => 'ब्राउज़र में उपलब्ध नहीं है';

  @override
  String get iosSoundboxNote =>
      'Apple की पाबंदियों के कारण दूसरे ऐप के नोटिफिकेशन नहीं पढ़े जा सकते। केवल हाथ से या बोलकर एंट्री करें।';

  @override
  String get webSoundboxNote =>
      'ब्राउज़र दूसरे ऐप के UPI नोटिफिकेशन नहीं पढ़ सकता। साउंडबॉक्स के लिए Android APK इंस्टॉल करें।';

  @override
  String get serverSoundbox => 'बिज़नेस UPI साउंडबॉक्स';

  @override
  String get serverSoundboxNote =>
      'पेमेंट प्रोवाइडर से कन्फ़र्म पेमेंट यहां सुनाई देगी। कोई पेमेंट नहीं छूटेगी: जब तक यह फ़ोन बोल नहीं देता, पेमेंट सर्वर पर रहेगी।';

  @override
  String get notPaired => 'यह फ़ोन अभी किसी बिज़नेस UPI खाते से नहीं जुड़ा है।';

  @override
  String get pairingCode => 'पेयरिंग कोड';

  @override
  String get pair => 'फ़ोन जोड़ें';

  @override
  String get unpair => 'हटाएं';

  @override
  String pairedWith(String name) {
    return '$name से जुड़ा है';
  }

  @override
  String get syncNow => 'अभी चेक करें';

  @override
  String lastChecked(String time) {
    return 'पिछली बार $time बजे चेक किया गया';
  }

  @override
  String get neverChecked => 'अभी तक चेक नहीं किया गया';

  @override
  String get soundboxStale =>
      'सर्वर से संपर्क नहीं हो पा रहा है। इंटरनेट कनेक्शन चेक करें।';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString पेमेंट बोलना बाकी हैं',
      one: '1 पेमेंट बोलना बाकी है',
      zero: 'कोई पेमेंट पेंडिंग नहीं',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'नोटिफिकेशन साउंडबॉक्स (फ़ॉलबैक)';

  @override
  String get udhaarTitle => 'उधार खाता';

  @override
  String get udhaarSubtitle => 'ग्राहकों का बाकी';

  @override
  String get totalOutstanding => 'कुल बाकी';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ग्राहक',
      one: '1 ग्राहक',
      zero: 'कोई ग्राहक नहीं',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'फ़िल्टर: $name';
  }

  @override
  String get clearFilter => 'फ़िल्टर हटाएं';

  @override
  String get upiSetupHint =>
      'UPI से पैसे मांगने के लिए सेटिंग्स में अपना VPA और दुकान का नाम जोड़ें।';

  @override
  String get noOutstanding => 'कोई उधार बाकी नहीं';

  @override
  String cannotOpen(String scheme) {
    return 'खुल नहीं सका: $scheme';
  }

  @override
  String get askUpi => 'UPI मांगें';

  @override
  String get collect => 'पैसे लें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get language => 'भाषा';

  @override
  String get languageChanged => 'भाषा बदल गई';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return '$name का उधार';
  }

  @override
  String get defaultStallName => 'VendorOS स्टॉल';

  @override
  String get merchantOnboardingTitle => 'बिज़नेस UPI जोड़ें';

  @override
  String get merchantOnboardingSubtitle =>
      'साउंडबॉक्स से अपना बिज़नेस खाता जोड़ें';

  @override
  String get merchantStepsHint =>
      'अपने PhonePe for Business या Paytm for Business डैशबोर्ड से डीटेल्स डालें। आपको एक पेयरिंग कोड मिलेगा और यह फ़ोन तुरंत लिंक हो जाएगा।';

  @override
  String get howToGetBusinessUpi => 'बिज़नेस UPI खाता कैसे बनाएं?';

  @override
  String get merchantFormIncomplete =>
      'बिज़नेस का नाम, Merchant ID और Secret Key भरें।';

  @override
  String get merchantRegistered => 'बिज़नेस रजिस्टर हो गया';

  @override
  String get pairingCodeSaveHint =>
      'यह पेयरिंग कोड संभाल कर रखें। दूसरा फ़ोन जोड़ने के लिए इसका इस्तेमाल करें।';

  @override
  String get callbackUrlLabel => 'प्रोवाइडर डैशबोर्ड के लिए Callback URL';

  @override
  String get backToSoundbox => 'साउंडबॉक्स पर वापस जाएं';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get copied => 'कॉपी हो गया';

  @override
  String get provider => 'पेमेंट प्रोवाइडर';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'बिज़नेस का नाम';

  @override
  String get businessNameHint => 'जो नाम बोला जाएगा और रिपोर्ट पर छपेगा';

  @override
  String get businessVpa => 'बिज़नेस UPI ID';

  @override
  String get businessVpaHint => 'stallname@ybl';

  @override
  String get merchantIdLabel => 'Merchant ID (MID)';

  @override
  String get merchantIdHint => 'प्रोवाइडर डैशबोर्ड से';

  @override
  String get saltKeyLabel => 'सॉल्ट की';

  @override
  String get saltKeyHint => 'PhonePe सॉल्ट की';

  @override
  String get saltIndexLabel => 'सॉल्ट इंडेक्स';

  @override
  String get webhookTokenLabel => 'वेबहुक टोकन';

  @override
  String get webhookTokenHint =>
      'कोई मजबूत पासवर्ड जिसे आप Paytm डैशबोर्ड में भी डालें';

  @override
  String get secretStorageNote =>
      'सीक्रेट की सिर्फ सर्वर पर सुरक्षित रखी जाती है और ऐप इसे दोबारा कभी नहीं पढ़ सकता।';

  @override
  String get registerBusiness => 'बिजनेस UPI रजिस्टर करें';

  @override
  String get helpTitle => 'मदद';

  @override
  String get helpSubtitle => 'बिजनेस UPI और साउंडबॉक्स गाइड';

  @override
  String get helpWhyTitle => 'बिजनेस UPI अकाउंट क्यों?';

  @override
  String get helpWhyBody =>
      'पर्सनल UPI आईडी से पेमेंट की पुष्टि सर्वर पर नहीं हो पाती, जिससे आवाज़ छूट सकती है। बिजनेस अकाउंट से हर पेमेंट की जानकारी VendorOS तक पहुंचती है, ताकि साउंडबॉक्स कोई पेमेंट न चूके।';

  @override
  String get helpDocsTitle => 'ज़रूरी चीज़ें';

  @override
  String get helpDocsAadhaar => 'Aadhaar नंबर और उससे जुड़ा मोबाइल नंबर';

  @override
  String get helpDocsPan =>
      'PAN कार्ड (छोटी दुकान या ठेले के लिए पर्सनल PAN भी चलेगा)';

  @override
  String get helpDocsBank => 'खाता नंबर और IFSC (पैसे खाते में आने के लिए)';

  @override
  String get helpDocsShop => 'दुकान का नाम, पता और दुकान/ठेले की फोटो';

  @override
  String get helpRegisterTitle => 'कंपनी में रजिस्टर करें';

  @override
  String get helpRegisterStep1 =>
      'Play Store से PhonePe for Business या Paytm for Business इंस्टॉल करें।';

  @override
  String get helpRegisterStep2 =>
      'मोबाइल नंबर से साइन अप करें और Aadhaar व PAN से KYC पूरी करें।';

  @override
  String get helpRegisterStep3 =>
      'बैंक खाता जोड़ें ताकि पैसे सीधे खाते में आएं, और फ्री QR स्टिकर लें।';

  @override
  String get helpRegisterStep4 =>
      'ऐप में दिख रहा बिजनेस UPI एड्रेस (जैसे stallname@ybl) नोट कर लें।';

  @override
  String get helpKeysTitle => 'मर्चेंट आईडी और सीक्रेट की';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: बिजनेस डैशबोर्ड खोलें, Developer सेटिंग्स में जाएं और मर्चेंट आईडी, सॉल्ट की व सॉल्ट इंडेक्स कॉपी करें।';

  @override
  String get helpKeysPaytm =>
      'Paytm: बिजनेस डैशबोर्ड खोलें, Developer सेटिंग्स में जाएं, MID कॉपी करें और एक मजबूत वेबहुक टोकन बनाएं जिसे यहाँ भी डालें।';

  @override
  String get helpKeysCallback =>
      'रजिस्ट्रेशन के बाद दिखने वाला कॉलबैक URL कंपनी डैशबोर्ड में पेस्ट करें ताकि पेमेंट VendorOS तक पहुंचे।';

  @override
  String get helpLinkTitle => 'यह फोन लिंक करें';

  @override
  String get helpLinkStep1 =>
      'Soundbox खोलें और \'बिजनेस UPI रजिस्टर करें\' दबाएं।';

  @override
  String get helpLinkStep2 =>
      'फॉर्म भरें; फोन अपने आप लिंक हो जाएगा और एक पेयरिंग कोड दिखेगा।';

  @override
  String get helpLinkStep3 =>
      'दूसरे फोन पर भी लिंक करने के लिए Soundbox में वही पेयरिंग कोड डालें।';

  @override
  String get helpSafetyTitle => 'सुरक्षित रखें';

  @override
  String get helpSafetyBody =>
      'सॉल्ट की या वेबहुक टोकन किसी को न बताएं। VendorOS इसे सिर्फ सर्वर पर सुरक्षित रखता है और दोबारा कभी नहीं दिखाता।';

  @override
  String get menuInventory => 'इन्वेंट्री';

  @override
  String get productsTitle => 'प्रोडक्ट्स';

  @override
  String get productsSubtitle => 'कैटलॉग और स्टॉक';

  @override
  String get productsSearchHint => 'नाम या कोड खोजें';

  @override
  String get productsEmpty => 'अभी कोई प्रोडक्ट नहीं है। पहला आइटम जोड़ें।';

  @override
  String get productsAdd => 'प्रोडक्ट जोड़ें';

  @override
  String get productsAllChip => 'सभी';

  @override
  String get productsLowStockChip => 'कम स्टॉक';

  @override
  String get productEditTitle => 'प्रोडक्ट एडिट करें';

  @override
  String get productMissing => 'यह आइटम अब लिस्ट में नहीं है।';

  @override
  String get productSaved => 'सेव हो गया';

  @override
  String get productArchived => 'प्रोडक्ट हटा दिया गया';

  @override
  String get formInvalid => 'प्रोडक्ट का नाम लिखें';

  @override
  String get fieldName => 'नाम';

  @override
  String get fieldLocalName => 'तमिल में नाम';

  @override
  String get fieldCode => 'कोड';

  @override
  String get fieldCodeHint => 'बारकोड डालें, या नए के लिए खाली छोड़ें';

  @override
  String get fieldCategory => 'कैटेगरी';

  @override
  String get fieldUnit => 'यूनिट';

  @override
  String get fieldCost => 'खरीद भाव';

  @override
  String get fieldPrice => 'बिक्री भाव';

  @override
  String get fieldReorder => 'रीऑर्डर लेवल';

  @override
  String get saveLabel => 'सेव करें';

  @override
  String get discardTitle => 'बदलाव रद्द करें?';

  @override
  String get discardBody => 'आपके बदलाव अभी सेव नहीं हुए हैं।';

  @override
  String get discardKeep => 'एडिट जारी रखें';

  @override
  String get discardLeave => 'छोड़ें';

  @override
  String get cancelLabel => 'रद्द करें';

  @override
  String get deleteLabel => 'डिलीट करें';

  @override
  String get confirmLabel => 'कन्फर्म करें';

  @override
  String get qtyLabel => 'मात्रा';

  @override
  String get unitCostLabel => 'प्रति यूनिट भाव';

  @override
  String get expiryLabel => 'एक्सपायरी (दिनों में)';

  @override
  String get unitKg => 'किग्रा';

  @override
  String get unitGram => 'ग्रा';

  @override
  String get unitPiece => 'पीस';

  @override
  String get unitLitre => 'लीटर';

  @override
  String get unitBundle => 'बंडल';

  @override
  String get detailSell => 'बेचें';

  @override
  String get detailRestock => 'स्टॉक जोड़ें';

  @override
  String get detailWastage => 'वेस्टेज';

  @override
  String get detailCorrect => 'स्टॉक गिनती';

  @override
  String get detailBatches => 'बैच';

  @override
  String get detailHistory => 'हिस्ट्री';

  @override
  String get detailLabel => 'लेबल प्रिंट करें';

  @override
  String get historyEmpty => 'अभी कोई स्टॉक हिस्ट्री नहीं है';

  @override
  String get soldRecorded => 'बिक्री दर्ज हो गई';

  @override
  String get restocked => 'स्टॉक जोड़ दिया';

  @override
  String get wastageRecorded => 'वेस्टेज दर्ज हो गया';

  @override
  String get stockCorrected => 'स्टॉक अपडेट हुआ';

  @override
  String get movementPurchase => 'खरीद';

  @override
  String get movementSale => 'बिक्री';

  @override
  String get movementWastage => 'खराबी';

  @override
  String get movementReturn => 'वापसी';

  @override
  String get movementCorrection => 'सुधार';

  @override
  String get expiredTag => 'एक्सपायर्ड';

  @override
  String get expiryTodayTag => 'आज एक्सपायर होगा';

  @override
  String get noExpiry => 'कोई एक्सपायरी नहीं';

  @override
  String get batchesTitle => 'बैच';

  @override
  String get batchesSubtitle => 'एक्सपायरी लिस्ट';

  @override
  String get batchesEmpty => 'अभी कोई एक्सपायरी बैच नहीं है';

  @override
  String get stockTitle => 'स्टॉक';

  @override
  String get stockSubtitle => 'वैल्यू, अलर्ट और एक्सपायरी';

  @override
  String get stockValuation => 'स्टॉक वैल्यू';

  @override
  String get stockProfit => 'मुनाफ़ा (30 दिन)';

  @override
  String get stockWastage => 'खराबी (30 दिन)';

  @override
  String get stockLowTitle => 'कम स्टॉक';

  @override
  String get stockExpiryTitle => 'एक्सपायरी';

  @override
  String get stockNothingLow => 'कोई सामान कम नहीं है';

  @override
  String get stockNoExpiry => 'कोई एक्सपायरी बैच नहीं';

  @override
  String get stockReorderNow => 'ऑर्डर लिस्ट भेजें';

  @override
  String get suppliersTitle => 'सप्लायर';

  @override
  String get suppliersSubtitle => 'ऑर्डर के कॉन्टैक्ट्स';

  @override
  String get suppliersEmpty => 'अभी कोई सप्लायर नहीं है';

  @override
  String get supplierAdd => 'सप्लायर जोड़ें';

  @override
  String get supplierName => 'नाम';

  @override
  String get supplierPhone => 'फ़ोन';

  @override
  String get supplierNote => 'नोट';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'स्कैन';

  @override
  String get scanSubtitle => 'बारकोड या QR';

  @override
  String get scanUnsupported =>
      'यहाँ कैमरा स्कैन उपलब्ध नहीं है। नीचे कोड डालें।';

  @override
  String get scanPermission => 'स्कैन करने के लिए कैमरा की अनुमति दें';

  @override
  String get scanManualHint => 'कोड डालें या पेस्ट करें';

  @override
  String get scanCreateFromCode => 'इस कोड से नया आइटम जोड़ें';

  @override
  String get labelsTitle => 'लेबल';

  @override
  String get labelsSubtitle => 'QR और बारकोड लेबल प्रिंट करें';

  @override
  String get labelsSelect => 'आइटम चुनें';

  @override
  String get labelsSize => 'लेबल साइज़';

  @override
  String get labelsSymbology => 'सिंबल';

  @override
  String get labelsCopies => 'कॉपी';

  @override
  String get labelsPrint => 'शीट प्रिंट करें';

  @override
  String get labelsThermal => 'प्रिंटर कोड कॉपी करें';

  @override
  String get labelsCopied => 'प्रिंटर कोड कॉपी हो गया';

  @override
  String get labelsNone => 'कम से कम एक आइटम चुनें';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'बारकोड';

  @override
  String get paymentQrTitle => 'पेमेंट QR';

  @override
  String get paymentQrSubtitle => 'ग्राहक स्कैन करके पेमेंट कर सकते हैं';

  @override
  String get paymentQrAmountHint => 'रकम (वैकल्पिक)';

  @override
  String get paymentQrNeedVpa => 'पहले सेटिंग्स में अपनी UPI ID जोड़ें।';

  @override
  String get paymentQrOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get paymentQrPoster => 'पोस्टर सेव करें';

  @override
  String get paymentQrCopy => 'लिंक कॉपी करें';

  @override
  String get paymentQrCopied => 'लिंक कॉपी हो गया';

  @override
  String get paymentQrNote =>
      'स्कैन करने पर ग्राहक का UPI ऐप खुलेगा। पेमेंट तभी पक्का मानें जब साउंडबॉक्स बोले।';

  @override
  String stockOnHand(String qty) {
    return 'स्टॉक में: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'मार्जिन $pct%';
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
      other: '$count बैचों पर ध्यान दें',
      one: '1 बैच पर ध्यान दें',
      zero: 'कुछ भी जल्द एक्सपायर नहीं हो रहा',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty बचे · $cost प्रति यूनिट';
  }

  @override
  String sellShortfall(String qty) {
    return 'स्टॉक में सिर्फ $qty था — उतना ही दर्ज किया';
  }

  @override
  String productArchiveConfirm(String name) {
    return '$name को कैटलॉग से हटाएं?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: कृपया $items भेजें';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return '$vpa को पेमेंट';
  }

  @override
  String scanUnknownCode(String code) {
    return '$code कोड का कोई आइटम नहीं मिला';
  }

  @override
  String get profileTitle => 'बिजनेस प्रोफाइल';

  @override
  String get vendorCategory => 'बिजनेस का प्रकार';

  @override
  String get categoryCart => 'ठेला / रेहड़ी';

  @override
  String get categoryStall => 'दुकान / पक्का स्टॉल';

  @override
  String get categoryHotel => 'होटल / ढाबा / रेस्टोरेंट';

  @override
  String get categoryService => 'सर्विस / सेवा कार्य';

  @override
  String get nicheLabel => 'आप क्या बेचते या करते हैं?';

  @override
  String get districtLabel => 'ज़िला';

  @override
  String get talukLabel => 'तहसील / कस्बा';

  @override
  String get marketAreaLabel => 'मार्केट / इलाका';

  @override
  String get fssaiLabel => 'FSSAI नंबर (खाने का काम)';

  @override
  String get udyamLabel => 'उद्यम रजिस्ट्रेशन (वैकल्पिक)';

  @override
  String get workingHoursLabel => 'काम के घंटे';

  @override
  String get perishableLabel => 'जल्दी खराब होने वाला सामान';

  @override
  String get profilePromptTitle => 'दुकान की प्रोफाइल सेट करें';

  @override
  String get profilePromptBody =>
      'बताएं कि आप क्या बेचते हैं, ताकि ऐप में सिर्फ जरूरी चीजें दिखें।';

  @override
  String get profilePromptAction => 'सेट करें';

  @override
  String get profileSaved => 'प्रोफाइल सेव हो गई';

  @override
  String get expensesTitle => 'खर्चे';

  @override
  String get expensesSubtitle => 'दूध, गैस, नाश्ता, किराया — जो भी खर्च हुआ';

  @override
  String get expenseToday => 'आज का खर्च';

  @override
  String get expenseAdd => 'खर्च जोड़ें';

  @override
  String get expenseAmount => 'रकम';

  @override
  String get expenseNote => 'नोट (वैकल्पिक)';

  @override
  String get expenseTodayList => 'आज के खर्चे';

  @override
  String get expenseEmpty => 'आज कोई खर्च दर्ज नहीं है';

  @override
  String get expenseMilk => 'दूध';

  @override
  String get expenseGas => 'गैस';

  @override
  String get expenseSnacks => 'नाश्ता';

  @override
  String get expenseProvisions => 'किराना / राशन';

  @override
  String get expenseWages => 'मजदूरी';

  @override
  String get expenseRent => 'किराया';

  @override
  String get expenseElectricity => 'बिजली बिल';

  @override
  String get expenseTransport => 'भाड़ा';

  @override
  String get expenseOther => 'अन्य';

  @override
  String get recurringTitle => 'रोज का सामान';

  @override
  String get recurringAdd => 'सामान जोड़ें';

  @override
  String get recurringName => 'सामान का नाम';

  @override
  String get recurringEmpty =>
      'दूध के कैन या नाश्ते की ट्रे यहां सेव करें, ताकि एक टैप में दर्ज हो जाएं।';

  @override
  String get dayCloseTitle => 'दिन की क्लोजिंग';

  @override
  String get dayCloseExpectedCash => 'गल्ले में होना चाहिए इतना कैश';

  @override
  String get dayCloseBreakdown => 'आज का हिसाब';

  @override
  String get dayCloseCollected => 'उधारी वसूली';

  @override
  String get dayCloseWastage => 'वेस्टेज / नुकसान';

  @override
  String get dayCloseProfit => 'आज का मुनाफा';

  @override
  String get dayCloseCount => 'गल्ला गिनें';

  @override
  String get dayCloseCountedCash => 'गिना हुआ कैश';

  @override
  String get dayCloseSave => 'दिन क्लोज करें';

  @override
  String get dayCloseDiscounts => 'दी गई छूट';

  @override
  String get dayCloseTax => 'टैक्स कलेक्शन';

  @override
  String get dayCloseLastToken => 'आखिरी टोकन';

  @override
  String get dayCloseVoided => 'रद्द बिल';

  @override
  String get dayCloseExport => 'दिन की PDF निकालें';

  @override
  String get dayCloseVariancePosted => 'कैश का अंतर खाते में दर्ज कर दिया गया।';

  @override
  String get dayCloseExportFailed => 'दिन की समरी एक्सपोर्ट नहीं हो सकी।';

  @override
  String get dayCloseMatch => 'कैश बिल्कुल सही मिला।';

  @override
  String dayCloseSurplus(String amount) {
    return 'हिसाब से $amount ज़्यादा';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount कम';
  }

  @override
  String get insightsTitle => 'रिपोर्ट';

  @override
  String get insightsSubtitle => 'दिन, हफ़्ता, महीना और साल';

  @override
  String get windowDay => 'दिन';

  @override
  String get windowWeek => 'हफ़्ता';

  @override
  String get windowMonth => 'महीना';

  @override
  String get windowYear => 'साल';

  @override
  String get insightsTurnover => 'कुल बिक्री';

  @override
  String get insightsCosts => 'खर्च';

  @override
  String get insightsProfit => 'मुनाफ़ा';

  @override
  String get insightsAvgDay => 'प्रति दिन';

  @override
  String get insightsByDay => 'दिन के हिसाब से';

  @override
  String get insightsBestDay => 'सबसे अच्छा दिन';

  @override
  String get insightsTopItems => 'सबसे ज़्यादा बिकने वाले';

  @override
  String get insightsCostSplit => 'पैसे कहाँ खर्च हुए';

  @override
  String get insightsEmpty => 'इस दौरान अभी कोई रिकॉर्ड नहीं है';

  @override
  String get insightsMarginAlert => 'मार्जिन अलर्ट';

  @override
  String get insightsMarginBody =>
      'ये आइटम लागत के बहुत करीब बिक रहे हैं। दाम बढ़ाएं या लागत घटाएं।';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'लागत $cost · दाम $price';
  }

  @override
  String get quickSaleTitle => 'क्विक सेल';

  @override
  String get quickSaleSubtitle =>
      'एक कप के लिए एक टैप — ज़्यादा के लिए दबाकर रखें';

  @override
  String get quickSaleQty => 'मात्रा';

  @override
  String quickSaleQtyTitle(String item) {
    return 'कितने $item?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount दर्ज हुआ';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return '$amount में एक $item बेचें';
  }

  @override
  String get quickSaleEmpty =>
      'क्विक मेन्यू इस्तेमाल करने के लिए कीमत के साथ आइटम जोड़ें।';

  @override
  String get starterPackAction => 'दुकान के लिए स्टार्टर किट लोड करें';

  @override
  String get starterTea => 'चाय';

  @override
  String get starterCoffee => 'कॉफ़ी';

  @override
  String get starterBun => 'बन';

  @override
  String get starterBiscuit => 'बिस्कुट';

  @override
  String get starterBajji => 'बज्जी';

  @override
  String get starterMilkSupply => 'दूध की कैन';

  @override
  String get starterSnackSupply => 'स्नैक ट्रे';

  @override
  String get menuDailyWork => 'रोज़ का काम';

  @override
  String get stockOut => 'स्टॉक खत्म';

  @override
  String get ordersTitle => 'ऑर्डर';

  @override
  String get ordersSubtitle => 'काउंटर और QR ऑर्डर, लाइव';

  @override
  String get orderCounterNew => 'नया काउंटर ऑर्डर';

  @override
  String get orderTable => 'टेबल';

  @override
  String get orderRemoveItem => 'एक हटाएं';

  @override
  String get orderAddItem => 'एक जोड़ें';

  @override
  String get orderCancelReason => 'कैंसिल करने की वजह';

  @override
  String get orderCancel => 'ऑर्डर कैंसिल करें';

  @override
  String get orderLive => 'लाइव';

  @override
  String get orderHistory => 'हिस्ट्री';

  @override
  String get orderEmpty => 'अभी कोई ऑर्डर नहीं है।';

  @override
  String get orderNew => 'नया';

  @override
  String get orderPreparing => 'बन रहा है';

  @override
  String get orderServed => 'सर्व हुआ';

  @override
  String get orderPaid => 'पेड';

  @override
  String get orderCancelled => 'कैंसिल हुआ';

  @override
  String get orderAccept => 'स्वीकारें';

  @override
  String get orderServe => 'सर्व करें';

  @override
  String get orderBulkAccept => 'सभी नए स्वीकारें';

  @override
  String get orderBulkServe => 'सभी तैयार सर्व करें';

  @override
  String get orderBill => 'बिल';

  @override
  String get orderTokenShort => 'टोकन';

  @override
  String get kotTitle => 'किचन';

  @override
  String get kotSubtitle => 'आगे क्या बनना है';

  @override
  String get kotEmpty => 'किचन में कोई ऑर्डर बाकी नहीं है।';

  @override
  String get kotDone => 'तैयार';

  @override
  String get billTitle => 'बिल';

  @override
  String get billNumberLabel => 'बिल';

  @override
  String get billSubtotal => 'सबटोटल';

  @override
  String get billDiscount => 'डिस्काउंट';

  @override
  String get billDiscountFlat => 'डिस्काउंट रकम';

  @override
  String get billDiscountPct => 'डिस्काउंट %';

  @override
  String get billTax => 'GST';

  @override
  String get billTaxable => 'टैक्सेबल';

  @override
  String get billCgst => 'CGST';

  @override
  String get billSgst => 'SGST';

  @override
  String get billIgst => 'IGST';

  @override
  String get shopGstRegistered => 'GST रजिस्टर्ड दुकान';

  @override
  String get shopGstRegisteredHint => 'बिल पर CGST/SGST और आइटम HSN कोड दिखेगा';

  @override
  String get shopPriceIncludesTax => 'कीमतों में टैक्स शामिल है';

  @override
  String get productTaxRate => 'GST दर %';

  @override
  String get productHsn => 'HSN / SAC कोड';

  @override
  String get productTaxHint => 'दुकान की दर लागू करने के लिए खाली छोड़ें';

  @override
  String get billRounding => 'राउंडिंग';

  @override
  String get billTotal => 'कुल';

  @override
  String get billPaid => 'जमा';

  @override
  String get billBalance => 'बाकी';

  @override
  String get billReprint => 'दोबारा प्रिंट';

  @override
  String get billShare => 'शेयर करें';

  @override
  String get billThanks => 'धन्यवाद, फिर आएं';

  @override
  String get billCustomer => 'ग्राहक';

  @override
  String get billSplit => 'पेमेंट';

  @override
  String get billRoundToRupee => 'रुपये में राउंड करें';

  @override
  String get billFillCash => 'बाकी कैश में भरें';

  @override
  String get billFullyPaid => 'पूरा भुगतान';

  @override
  String get billSettle => 'बिल सेटल करें';

  @override
  String get close => 'बंद करें';

  @override
  String get billPreview => 'पेपर प्रीव्यू';

  @override
  String get billVoid => 'बिल रद्द करें';

  @override
  String get billVoidTitle => 'यह बिल रद्द करें';

  @override
  String get billVoidHint => 'बिल नंबर खाते में रहेगा और हिसाब उलट दिया जाएगा।';

  @override
  String get billVoidReason => 'कारण';

  @override
  String get billVoidReasonRequired => 'बिल रद्द करने के लिए कारण जरूरी है';

  @override
  String get billVoided => 'बिल रद्द किया गया';

  @override
  String get billVoidFailed => 'यह बिल रद्द नहीं हो सका';

  @override
  String get billAudit => 'बिल हिस्ट्री';

  @override
  String get menuTitle => 'QR मेन्यू';

  @override
  String get menuSubtitle => 'स्कैन करने पर ग्राहकों को क्या दिखेगा';

  @override
  String get menuShopSection => 'दुकान';

  @override
  String get menuSlug => 'लिंक में मेन्यू का नाम';

  @override
  String get menuBaseUrl => 'मेन्यू का वेब पता';

  @override
  String get menuTableCount => 'टेबल';

  @override
  String get menuTaxPercent => 'GST %';

  @override
  String get menuGstin => 'GSTIN';

  @override
  String get menuAcceptOrders => 'QR ऑर्डर लें';

  @override
  String get menuSaved => 'मेन्यू सेटिंग्स सेव हो गईं';

  @override
  String get menuQrSheet => 'QR शीट प्रिंट करें';

  @override
  String get menuLinkSection => 'दुकान का QR';

  @override
  String get menuItemsSection => 'मेन्यू के आइटम';

  @override
  String get menuSoldOut => 'खत्म';

  @override
  String get menuPublished => 'मेनू पर';

  @override
  String get menuCounterQr => 'काउंटर';

  @override
  String get menuScanHint => 'मेनू देखने और आर्डर करने के लिए स्कैन करें';

  @override
  String get printersTitle => 'रसीद प्रिंटर';

  @override
  String get printersSubtitle => 'कागज़ साइज़, कनेक्शन और टेस्ट प्रिंट';

  @override
  String get printerWidth => 'कागज़ की चौड़ाई';

  @override
  String get printerTransport => 'कनेक्शन';

  @override
  String get printerPdf => 'PDF / शेयर';

  @override
  String get printerBluetooth => 'Bluetooth';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'प्रिंटर का नाम';

  @override
  String get printerDeviceAddress => 'प्रिंटर पता';

  @override
  String get printerFallbackNote =>
      'इस डिवाइस पर सीधा प्रिंट अभी तैयार नहीं है, इसलिए बिल PDF में खुलेगा जिसे आप प्रिंट या शेयर कर सकते हैं।';

  @override
  String get printerAutoPrint => 'बिल अपने आप प्रिंट करें';

  @override
  String get printerKot => 'किचन पर्ची प्रिंट करें';

  @override
  String get printerTest => 'टेस्ट प्रिंट';

  @override
  String get printerTestSent => 'टेस्ट रसीद भेजी गई';

  @override
  String get printerPaired => 'पेयर किए गए प्रिंटर';

  @override
  String get printerScan => 'पेयर प्रिंटर खोजें';

  @override
  String get printerScanning => 'ढूंढ रहे हैं…';

  @override
  String get printerNoDevices =>
      'कोई पेयर प्रिंटर नहीं मिला। पहले Android Bluetooth सेटिंग में पेयर करें।';

  @override
  String get printerConnect => 'कनेक्ट करें';

  @override
  String get printerConnected => 'प्रिंटर कनेक्ट हो गया';

  @override
  String get printerConnectFailed =>
      'कनेक्ट नहीं हो सका। प्रिंटर चालू करके दोबारा कोशिश करें।';

  @override
  String get printerBluetoothNote =>
      'बिल सीधे इस Bluetooth प्रिंटर पर प्रिंट होंगे। अगर यह बंद या रेंज से बाहर हुआ, तो बिल PDF में खुलेगा ताकि कोई रिकॉर्ड न छूटे।';

  @override
  String orderToken(int token) {
    return 'टोकन $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'बिल $number सेटल हुआ';
  }

  @override
  String get dayCloseOrders => 'आज के आर्डर';

  @override
  String get dayCloseOrdersTaken => 'लिए गए आर्डर';

  @override
  String get dayCloseOrdersCancelled => 'रद्द किए';

  @override
  String get dayCloseOrdersOpen => 'अभी बाकी';

  @override
  String get dayCloseOrdersBilled => 'बिल बने';

  @override
  String get dayCloseAvgTicket => 'औसत बिल';

  @override
  String get menuCloudSection => 'क्लाउड बोर्ड';

  @override
  String get menuShopKey => 'शॉप की (16+ अक्षर)';

  @override
  String get menuCloudSync => 'आर्डर क्लाउड से सिंक करें';

  @override
  String get menuCloudPublish => 'मेनू क्लाउड पर डालें';

  @override
  String menuCloudPublished(int count) {
    return 'क्लाउड मेनू में $count आइटम डाले गए';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'क्लाउड गड़बड़ी: $reason';
  }

  @override
  String get menuCloudLive => 'लाइव: QR ऑर्डर सीधे स्क्रीन पर आएंगे।';

  @override
  String get menuCloudOffline =>
      'सिर्फ लोकल। QR ऑर्डर पाने के लिए शॉप की (key) डालें और सिंक चालू करें।';

  @override
  String get settleTitle => 'उधारी चुकता करें';

  @override
  String get settleAmountSection => 'हिसाब चुकता';

  @override
  String get settleAmount => 'रकम';

  @override
  String get settleCash => 'कैश';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'नया उधार';

  @override
  String get settleNote => 'नोट';

  @override
  String get settleCashHint =>
      'कैश मिलने पर बकाया चुकता होगा और आज की कैश बिक्री में जुड़ेगा।';

  @override
  String get settleUpiHint =>
      'UPI पर पैसे लेकर कन्फ़र्म करें। बकाया चुकता होगा और आज की UPI बिक्री बढ़ेगी।';

  @override
  String get settleLoanHint =>
      'पुराना बकाया बंद होकर वही रकम नए उधार में जुड़ जाएगी।';

  @override
  String get settleConfirm => 'चुकता करें';

  @override
  String get settleDone => 'हिसाब चुकता दर्ज हुआ';

  @override
  String get settleHistory => 'हालिया हिसाब';

  @override
  String settleTooMuch(String amount) {
    return 'बाकी ₹$amount से ज़्यादा है';
  }

  @override
  String settleLedgerItem(String name) {
    return 'उधार चुकता हुआ — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'उधार नए लोन में बदला — $name';
  }

  @override
  String get menuAddress => 'दुकान का पता';

  @override
  String get menuPhone => 'फ़ोन नंबर';

  @override
  String get menuFssai => 'FSSAI लाइसेंस';

  @override
  String get menuGrowSection => 'बढ़ाएं और संभालें';

  @override
  String get recipesTitle => 'रेसिपी बुक';

  @override
  String get recipesSubtitle => 'नाप-तौल का हिसाब, एक बार लिख लें';

  @override
  String get recipeAdd => 'डिश जोड़ें';

  @override
  String get recipeName => 'डिश का नाम';

  @override
  String get recipeServings => 'कितनी प्लेट बनेगी';

  @override
  String get recipeEmpty => 'अभी कोई डिश नहीं जोड़ी गई।';

  @override
  String get recipeIngredients => 'क्या-क्या डलेगा';

  @override
  String get recipeSteps => 'बनाने का तरीका';

  @override
  String get recipeAddIngredient => 'सामान जोड़ें';

  @override
  String get recipeAddStep => 'स्टेप जोड़ें';

  @override
  String get recipeQty => 'मात्रा';

  @override
  String get recipeLinkProduct => 'स्टॉक आइटम से लें';

  @override
  String get recipeNoLink => 'स्टॉक से बाहर';

  @override
  String get recipeCost => 'सामान की लागत';

  @override
  String get recipePerServing => 'हर प्लेट की लागत';

  @override
  String get recipeScale => 'कितना बनाना है';

  @override
  String get recipeCookBatch => 'स्टॉक से सामान घटाएं';

  @override
  String get recipeCooked => 'सामान स्टॉक से कट गया';

  @override
  String get recipeStepsEmpty => 'अभी कोई स्टेप्स नहीं लिखे।';

  @override
  String get recipeUnlinkedWarning =>
      'जो आइटम स्टॉक से नहीं जुड़े हैं, वे लागत में नहीं गिने जाएंगे।';

  @override
  String get jobsTitle => 'कस्टम ऑर्डर';

  @override
  String get jobsSubtitle => 'एडवांस बुकिंग और ऑर्डर का काम';

  @override
  String get jobAdd => 'ऑर्डर लें';

  @override
  String get jobTitleField => 'क्या बनाना है';

  @override
  String get jobCustomer => 'ग्राहक';

  @override
  String get jobPhone => 'फ़ोन';

  @override
  String get jobPrice => 'कीमत';

  @override
  String get jobAdvance => 'एडवांस मिला';

  @override
  String get jobDue => 'कब देना है';

  @override
  String get jobEmpty => 'यहाँ कोई ऑर्डर नहीं है।';

  @override
  String get jobStatusTaken => 'लिया गया';

  @override
  String get jobStatusMaking => 'बन रहा है';

  @override
  String get jobStatusReady => 'तैयार';

  @override
  String get jobStatusDelivered => 'दे दिया';

  @override
  String get jobStatusCancelled => 'कैंसिल';

  @override
  String get jobAdvanceStatus => 'आगे बढ़ाएं';

  @override
  String get jobCancel => 'कैंसिल करें';

  @override
  String get jobRemind => 'WhatsApp पर भेजें';

  @override
  String get jobFilterOpen => 'चालू';

  @override
  String get jobFilterToday => 'आज देना है';

  @override
  String get jobFilterDone => 'पूरा हुआ';

  @override
  String get customersTitle => 'पक्के ग्राहक';

  @override
  String get customersSubtitle =>
      'कौन बार-बार आता है, और उन्हें दुकान कैसे मिली';

  @override
  String get customerAdd => 'ग्राहक जोड़ें';

  @override
  String get customerName => 'नाम';

  @override
  String get customerPhone => 'फ़ोन';

  @override
  String get sourceWalkIn => 'सीधे दुकान पर आए';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'किसी के बताने पर';

  @override
  String get sourceOther => 'अन्य';

  @override
  String get customerRecordVisit => 'विज़िट जोड़ें';

  @override
  String get customerVisitAmount => 'रकम';

  @override
  String get customerRewardDue => 'फ्री वाला बाकी है';

  @override
  String get customerGiveReward => 'फ्री वाला दें';

  @override
  String get customersEmpty => 'अभी कोई पक्का ग्राहक नहीं जुड़ा।';

  @override
  String get customerSourceSplit => 'कमाई कहाँ से आ रही है';

  @override
  String get eventsTitle => 'इवेंट और मेले';

  @override
  String get eventsSubtitle => 'क्या स्टॉल लगाना फ़ायदेमंद रहा?';

  @override
  String get eventAdd => 'इवेंट जोड़ें';

  @override
  String get eventName => 'इवेंट का नाम';

  @override
  String get eventPlace => 'जगह';

  @override
  String get eventDay => 'तारीख';

  @override
  String get eventRent => 'स्टॉल का किराया';

  @override
  String get eventTravel => 'आने-जाने का खर्च';

  @override
  String get eventOther => 'अन्य खर्च';

  @override
  String get eventSales => 'बिक्री';

  @override
  String get eventFootfall => 'विज़िटर्स';

  @override
  String get eventProfit => 'मुनाफ़ा';

  @override
  String get eventLoss => 'नुकसान';

  @override
  String get eventPerVisitor => 'प्रति विज़िटर';

  @override
  String get eventsEmpty => 'अभी कोई इवेंट दर्ज नहीं है।';

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get staffSubtitle => 'हाज़िरी, एडवांस और पगार';

  @override
  String get staffAdd => 'स्टाफ जोड़ें';

  @override
  String get staffName => 'नाम';

  @override
  String get staffPhone => 'फ़ोन';

  @override
  String get staffRole => 'काम';

  @override
  String get staffWage => 'दिहाड़ी';

  @override
  String get staffPresent => 'हाज़िर';

  @override
  String get staffHalf => 'हाफ डे';

  @override
  String get staffAbsent => 'गैरहाज़िर';

  @override
  String get staffAdvance => 'एडवांस';

  @override
  String get staffAdvanceAdd => 'एडवांस दें';

  @override
  String get staffPayable => 'इस महीने की बाकी पगार';

  @override
  String get staffEmpty => 'कोई स्टाफ नहीं जोड़ा गया।';

  @override
  String get staffRemove => 'हटाएं';

  @override
  String get growthTitle => 'ग्रोथ किट';

  @override
  String get growthSubtitle => 'दुकान पर और ग्राहक लाएं';

  @override
  String get growthMenuLink => 'आपके मेन्यू का लिंक';

  @override
  String get growthShareMenu => 'मेन्यू भेजें';

  @override
  String get growthAskReview => 'रिव्यू मांगें';

  @override
  String get growthOpenMaps => 'Maps पेज खोलें';

  @override
  String get growthWhatsappBroadcast => 'WhatsApp पर ग्राहकों को बताएं';

  @override
  String get growthLinksSection => 'आपके लिंक्स';

  @override
  String get growthMapsUrl => 'Google Maps लिंक';

  @override
  String get growthReviewUrl => 'रिव्यू लिंक';

  @override
  String get growthInstagram => 'Instagram नाम';

  @override
  String get growthLoyalty => 'कितने विज़िट पर 1 फ़्री';

  @override
  String get growthIdeas => 'इस हफ़्ते के पोस्ट आइडिया';

  @override
  String get growthShareIdea => 'भेजें';

  @override
  String get growthIdea1 => 'सुबह की पहली खेप बनते हुए छोटी वीडियो क्लिप।';

  @override
  String get growthIdea2 => 'आज का स्पेशल, साफ़-साफ़ रेट के साथ।';

  @override
  String get growthIdea3 => 'पुराना ग्राहक अपने रोज़ के ऑर्डर के साथ।';

  @override
  String get growthIdea4 => 'काउंटर के पीछे: दुकान की रोज़ की शुरुआत।';

  @override
  String get growthIdea5 => 'वीकेंड ऑफ़र, सिर्फ़ दो दिनों के लिए।';

  @override
  String get growthSaved => 'सेव हुआ';

  @override
  String get checklistTitle => 'दुकान खोलने व बंद करने की लिस्ट';

  @override
  String get checklistSubtitle => 'छोटी चीज़ें जो भूल जाएं तो काम बिगड़ जाए';

  @override
  String get checklistOpening => 'खोलने से पहले';

  @override
  String get checklistClosing => 'बंद करने से पहले';

  @override
  String get checklistAdd => 'लिस्ट में जोड़ें';

  @override
  String get checklistItem => 'क्या चेक करना है';

  @override
  String get checklistEmpty => 'लिस्ट में अभी कुछ नहीं है।';

  @override
  String get checklistUseStarter => 'तैयार लिस्ट इस्तेमाल करें';

  @override
  String get checklistSeed1 => 'छुट्टे पैसे तैयार रखे हैं';

  @override
  String get checklistSeed2 => 'गैस और दूध चेक कर लिया';

  @override
  String get checklistSeed3 => 'QR स्टैंड और रेट बोर्ड बाहर रखा';

  @override
  String get checklistSeed4 => 'कैश गिनकर लिख लिया';

  @override
  String get checklistSeed5 => 'फ्रिज, गैस और लाइट बंद कर दी';

  @override
  String jobRemindMessage(String name, String title) {
    return 'नमस्ते $name, आपका ऑर्डर \"$title\" तैयार है।';
  }

  @override
  String customerVisits(String count) {
    return '$count विज़िट';
  }

  @override
  String customerToReward(String count) {
    return '$count विज़िट और बाकी';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return '$name पसंद आया? कृपया रिव्यू दें: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — आज का मेन्यू: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$total में से $done पूरे';
  }

  @override
  String get movementPrepared => 'तैयारी';

  @override
  String recipeShortStock(String item) {
    return 'स्टॉक में $item कम है';
  }

  @override
  String get starterIdli => 'इडली';

  @override
  String get starterDosa => 'डोसा';

  @override
  String get starterMeals => 'थाली';

  @override
  String get starterSnackPacket => 'स्नैक पैकेट';

  @override
  String get starterWaterBottle => 'पानी की बोतल';

  @override
  String get starterVegSupply => 'सब्ज़ियां';

  @override
  String get starterGasSupply => 'गैस सिलेंडर';

  @override
  String get checklistSeedHotel => 'बैटर, सब्ज़ी और गैस तैयार';

  @override
  String get checklistSeedCart => 'ठेला साफ़ और सामान लोड';

  @override
  String get checklistSeedService => 'सामान और छुट्टे पैसे तैयार';

  @override
  String get presetRecipeTea => 'दुकान की चाय (10 कप)';

  @override
  String get presetIngredientMilk => 'दूध';

  @override
  String get presetIngredientWater => 'पानी';

  @override
  String get presetIngredientTeaPowder => 'चायपत्ती';

  @override
  String get presetIngredientSugar => 'चीनी';

  @override
  String get rolesTitle => 'रोल';

  @override
  String get rolesSubtitle => 'कौन क्या कर सकता है';

  @override
  String get rolesHint =>
      'हर हेल्पर के लिए रोल बनाएं, फिर चुनें कि वो क्या-क्या काम कर सकते हैं।';

  @override
  String get rolesEmpty => 'अभी कोई रोल नहीं है';

  @override
  String get rolesOpen => 'चालू रोल';

  @override
  String get roleNew => 'नया रोल';

  @override
  String get roleSuggestionsTitle => 'आपकी दुकान के लिए सुझाव';

  @override
  String get roleSuggestionsHint =>
      'आपके काम के हिसाब से बने-बनाए रोल। चुनने के लिए टैप करें, फिर बदलें।';

  @override
  String get tmplWaiter => 'वेटर';

  @override
  String get tmplKitchen => 'रसोई / शेफ';

  @override
  String get tmplCashier => 'कैशियर';

  @override
  String get tmplCounter => 'काउंटर';

  @override
  String get tmplSalesHelper => 'सेल्स हेल्पर';

  @override
  String get tmplStockKeeper => 'स्टॉक कीपर';

  @override
  String get tmplJobAssistant => 'जॉब असिस्टेंट';

  @override
  String get tmplCounterHelper => 'काउंटर हेल्पर';

  @override
  String get tmplAssistant => 'असिस्टेंट';

  @override
  String get roleOwner => 'मालिक';

  @override
  String get roleOwnerNote => 'हमेशा पूरा एक्सेस';

  @override
  String get roleInactive => 'बंद है';

  @override
  String rolePermissionCount(String count) {
    return '$count की अनुमति है';
  }

  @override
  String get roleEditSubtitle => 'नाम, काम और लिमिट';

  @override
  String get roleName => 'रोल का नाम';

  @override
  String get roleNote => 'जिम्मेदारी';

  @override
  String get roleLimits => 'रुपयों की लिमिट (Rs, 0 = कोई लिमिट नहीं)';

  @override
  String get roleMaxDiscount => 'ज्यादा से ज्यादा छूट';

  @override
  String get roleMaxCredit => 'ज्यादा से ज्यादा उधारी';

  @override
  String get roleMaxRefund => 'ज्यादा से ज्यादा रिफंड';

  @override
  String get roleLimitHint => 'इस रकम से ऊपर मालिक का PIN लगेगा।';

  @override
  String get roleDuplicate => 'रोल कॉपी करें';

  @override
  String get roleDeactivate => 'बंद करें';

  @override
  String get areaSales => 'बिक्री';

  @override
  String get areaOrders => 'ऑर्डर और रसोई';

  @override
  String get areaBilling => 'बिल';

  @override
  String get areaCredit => 'उधार';

  @override
  String get areaStock => 'स्टॉक';

  @override
  String get areaPurchases => 'खरीद और खर्चे';

  @override
  String get areaMoney => 'हिसाब और रिपोर्ट';

  @override
  String get areaCustomers => 'ग्राहक';

  @override
  String get areaStaff => 'हेल्पर';

  @override
  String get areaSettings => 'सेटिंग्स';

  @override
  String get permRecordSale => 'बिक्री दर्ज करें';

  @override
  String get permQuickSale => 'क्विक सेल इस्तेमाल करें';

  @override
  String get permCollectUpi => 'पेमेंट QR दिखाएं';

  @override
  String get permTakeOrder => 'ऑर्डर लें';

  @override
  String get permChangeOrderStatus => 'ऑर्डर आगे बढ़ाएं';

  @override
  String get permViewKitchen => 'किचन लिस्ट देखें';

  @override
  String get permEditMenu => 'मेनू बदलें';

  @override
  String get permMakeBill => 'बिल बनाएं';

  @override
  String get permGiveDiscount => 'डिस्काउंट दें';

  @override
  String get permVoidBill => 'बिल कैंसल करें';

  @override
  String get permReprintBill => 'बिल दोबारा प्रिंट करें';

  @override
  String get permGiveCredit => 'उधार दें';

  @override
  String get permSettleCredit => 'उधारी चुकता करें';

  @override
  String get permViewCredit => 'उधारी का बकाया देखें';

  @override
  String get permViewStock => 'स्टॉक देखें';

  @override
  String get permAdjustStock => 'स्टॉक बदलें';

  @override
  String get permEditProducts => 'आइटम जोड़ें या बदलें';

  @override
  String get permChangePrice => 'रेट बदलें';

  @override
  String get permCookRecipe => 'रेसिपी तैयार करें';

  @override
  String get permRecordExpense => 'खर्चा दर्ज करें';

  @override
  String get permManageSuppliers => 'सप्लायर संभालें';

  @override
  String get permViewDayTotals => 'दिन का कुल हिसाब देखें';

  @override
  String get permViewProfit => 'मुनाफा देखें';

  @override
  String get permCloseDay => 'दिन का हिसाब बंद करें';

  @override
  String get permViewReports => 'रिपोर्ट देखें';

  @override
  String get permViewCustomers => 'ग्राहक देखें';

  @override
  String get permEditCustomers => 'ग्राहक की जानकारी बदलें';

  @override
  String get permManageStaff => 'हेल्पर संभालें';

  @override
  String get permMarkAttendance => 'हाजिरी लगाएं';

  @override
  String get permPayWages => 'पगार दें';

  @override
  String get permManageRoles => 'रोल बनाएं';

  @override
  String get permViewAudit => 'काम का रिकॉर्ड देखें';

  @override
  String get permEditSettings => 'सेटिंग्स बदलें';

  @override
  String get permEditShop => 'दुकान की जानकारी बदलें';

  @override
  String get permManagePrinters => 'प्रिंटर सेट करें';

  @override
  String get accessTitle => 'एक्सेस कंट्रोल';

  @override
  String get accessSubtitle => 'फोन एक, स्टाफ अलग';

  @override
  String get accessEnable => 'PIN मांगें';

  @override
  String get accessEnableHint =>
      'फोन इस्तेमाल करने से पहले हर हेल्पर लॉगिन करेगा।';

  @override
  String get accessNeedsOwnerPin => 'पहले ओनर PIN सेट करें';

  @override
  String get accessOwnerPin => 'ओनर PIN';

  @override
  String get accessOwnerPinSet => 'ओनर PIN सेट करें (4-6 अंक)';

  @override
  String get accessOwnerPinChange => 'ओनर PIN बदलें (4-6 अंक)';

  @override
  String get accessPinSaved => 'PIN सेव हो गया';

  @override
  String get accessPinInvalid => '4 से 6 अंकों का PIN डालें';

  @override
  String get accessAutoLock => 'ऑटो लॉक';

  @override
  String get accessIdleMinutes => 'कितने समय बाद लॉक करें (मिनट, 0 = कभी नहीं)';

  @override
  String get accessWorkers => 'हेल्पर';

  @override
  String get accessNoWorkers => 'पहले हेल्पर जोड़ें';

  @override
  String get accessNoRole => 'कोई रोल नहीं';

  @override
  String get accessPinSet => 'PIN सेट है';

  @override
  String get accessPinMissing => 'PIN नहीं है';

  @override
  String get accessAssignTitle => 'रोल और PIN';

  @override
  String get accessWorkerPin => 'नया PIN (4-6 अंक)';

  @override
  String get accessSaved => 'सेव हो गया';

  @override
  String get accessEndShift => 'शिफ्ट खत्म करें';

  @override
  String get accessWrongPin => 'गलत PIN';

  @override
  String get lockTitle => 'काउंटर पर कौन है?';

  @override
  String get lockSubtitle => 'अपना नाम चुनें और PIN डालें';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'शिफ्ट शुरू करें';

  @override
  String get auditTitle => 'काम का रिकॉर्ड';

  @override
  String get auditSubtitle => 'किसने क्या किया';

  @override
  String get auditOpen => 'काम का रिकॉर्ड देखें';

  @override
  String get auditEveryone => 'सभी';

  @override
  String get auditEmpty => 'अभी कोई रिकॉर्ड नहीं है';

  @override
  String get auditApproved => 'ओनर द्वारा मंजूर';

  @override
  String get settingsGroupBusiness => 'बिजनेस';

  @override
  String get settingsGroupMoney => 'रुपये-पैसे';

  @override
  String get settingsGroupApp => 'ऐप और डिवाइस';

  @override
  String get settingsShopTitle => 'दुकान की जानकारी';

  @override
  String get settingsPaymentsTitle => 'पेमेंट और UPI';

  @override
  String get settingsMarketTitle => 'बाजार भाव';

  @override
  String get settingsNotSet => 'सेट नहीं है';

  @override
  String get settingsOn => 'चालू';

  @override
  String get settingsOff => 'बंद';

  @override
  String get settingsSaved => 'सेटिंग्स सेव हो गईं';

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get dashboardSubtitle => 'ऑर्डर, कमाई, उधारी और स्टॉक एक नज़र में';

  @override
  String get dashboardOrders => 'ऑर्डर';

  @override
  String get dashboardPayments => 'बाकी पेमेंट';

  @override
  String get dashboardCredit => 'उधारी खाता';

  @override
  String get dashboardInventory => 'स्टॉक';

  @override
  String get dashboardShare => 'शेयर करें';

  @override
  String get dashboardPlaced => 'आए हुए';

  @override
  String get dashboardServed => 'दिए गए';

  @override
  String get dashboardCancelled => 'रद्द हुए';

  @override
  String get dashboardOpenOrders => 'चालू ऑर्डर';

  @override
  String get dashboardBilled => 'बिल बने';

  @override
  String get dashboardAvgBill => 'औसत बिल';

  @override
  String get dashboardCollected => 'वसूल हुआ';

  @override
  String get dashboardUnbilled => 'बिल नहीं बना';

  @override
  String get dashboardPendingTotal => 'लेना बाकी';

  @override
  String get dashboardOutstanding => 'कुल बाकी';

  @override
  String get dashboardCreditGiven => 'उधार दिया';

  @override
  String get dashboardCustomers => 'ग्राहक';

  @override
  String get dashboardOldest => 'सबसे पुरानी उधारी';

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
  String get dashboardStockValue => 'स्टॉक की कीमत';

  @override
  String get dashboardLowStock => 'कम स्टॉक';

  @override
  String get dashboardExpiring => 'जल्द एक्सपायर';

  @override
  String get dashboardWastage => 'वेस्टेज';

  @override
  String get dashboardPurchases => 'खरीद';

  @override
  String get dashboardTopItems => 'टॉप आइटम';

  @override
  String get planTitle => 'सब्सक्रिप्शन';

  @override
  String get planSubtitle => 'दुकान के लिए क्लाउड फीचर्स';

  @override
  String get planFree => 'फ्री';

  @override
  String get planPro => 'प्रो';

  @override
  String get planFreeNote => 'इस फोन पर सब कुछ हमेशा फ्री चलता रहेगा।';

  @override
  String get planProNote => 'इस दुकान के लिए क्लाउड फीचर्स चालू हैं।';

  @override
  String get planCloudFeatures => 'क्लाउड फीचर्स';

  @override
  String get planFeatureAccount => 'क्लाउड शॉप अकाउंट';

  @override
  String get planFeatureLiveSync => 'लाइव ऑर्डर बोर्ड सिंक';

  @override
  String get planFeatureQrOrdering => 'QR मेन्यू ऑर्डरिंग';

  @override
  String get planFeatureShareLinks => 'शेयर करने वाले लिंक';

  @override
  String get planFeatureSoundbox => 'क्लाउड साउंडबॉक्स';

  @override
  String get planFeatureBackup => 'मल्टी-डिवाइस बैकअप';

  @override
  String get planOn => 'चालू';

  @override
  String get planLocked => 'लॉक';

  @override
  String get planRefresh => 'सब्सक्रिप्शन चेक करें';

  @override
  String get planChecking => 'चेक हो रहा है…';

  @override
  String get planCheckFailed =>
      'अभी चेक नहीं हो सका। पुराना स्टेटस दिखाया जा रहा है।';

  @override
  String get planNeedsShop => 'पहले क्लाउड शॉप सेट करें।';

  @override
  String get planOfflineNote =>
      'कुछ दिन ऑफलाइन रहने से दिक्कत नहीं — ग्रेस पीरियड में क्लाउड फीचर्स चलते रहेंगे।';

  @override
  String get shopTitle => 'मेरी दुकान';

  @override
  String get shopSubtitle => 'आपके काम के हिसाब से बना सिस्टम';

  @override
  String get shopPickType => 'दुकान का प्रकार';

  @override
  String get shopWorkflow => 'रोज़ का काम';

  @override
  String get shopTypeRestaurant => 'रेस्टोरेंट';

  @override
  String get shopTypeHotel => 'होटल';

  @override
  String get shopTypeStreet => 'ठेला / स्टॉल';

  @override
  String get shopTypeDiy => 'DIY / क्राफ्ट स्टॉल';

  @override
  String get shopTypeMagnet => 'फ्रिज मैग्नेट स्टॉल';

  @override
  String get shopTypeTea => 'चाय की दुकान';

  @override
  String get settingsOrderingTitle => 'ऑर्डर के नियम';

  @override
  String get settingsOrderingSubtitle =>
      'सर्विस का तरीका, पेमेंट टाइमिंग, टेबल बटन';

  @override
  String get serviceStyle => 'सर्विस का तरीका';

  @override
  String get serviceTable => 'टेबल सर्विस';

  @override
  String get serviceSelf => 'सेल्फ सर्विस';

  @override
  String get serviceTakeaway => 'सिर्फ टेकअवे';

  @override
  String get paymentTiming => 'पेमेंट कब लें';

  @override
  String get payBefore => 'पहले पेमेंट';

  @override
  String get payAfter => 'बाद में पेमेंट';

  @override
  String get payTimingHelp =>
      '\'पहले पेमेंट\' में ऑर्डर पक्का होने से पहले पेमेंट ली जाती है। \'बाद में पेमेंट\' में ऑर्डर सीधे किचन में चला जाता है।';

  @override
  String get customerButtons => 'कस्टमर स्क्रीन पर बटन';

  @override
  String get allowCallStaff => 'स्टाफ को बुलाएं';

  @override
  String get allowRequestBill => 'बिल मांगें';

  @override
  String get customerButtonsHelp => 'ये सिर्फ टेबल सर्विस में दिखेंगे।';

  @override
  String get requestCallStaff => 'स्टाफ चाहिए';

  @override
  String get requestBill => 'बिल चाहिए';

  @override
  String requestTable(String table) {
    return 'टेबल $table';
  }

  @override
  String get requestCounter => 'काउंटर';

  @override
  String get requestSeen => 'देख लिया';

  @override
  String get payStateAwaiting => 'पेमेंट बाकी है';

  @override
  String get payStateDue => 'काउंटर पर पेमेंट करें';

  @override
  String get payStatePaid => 'पेमेंट हो गया';

  @override
  String get orderMarkPaid => 'पेड मार्क करें';

  @override
  String get devicesTitle => 'फ़ोन और डिवाइस';

  @override
  String get devicesSubtitle => 'वेटर, किचन और काउंटर के फ़ोन एक ही जगह';

  @override
  String get devicesPairThis => 'यह फ़ोन जोड़ें';

  @override
  String get devicesShopSlug => 'दुकान का नाम (मेन्यू लिंक कोड)';

  @override
  String get devicesEnterCode => 'मालिक से मिला 6-अंकों का कोड';

  @override
  String get devicesLabel => 'फ़ोन का नाम';

  @override
  String get devicesPairButton => 'फ़ोन जोड़ें';

  @override
  String get devicesPairSuccess => 'फ़ोन दुकान से जुड़ गया';

  @override
  String get devicesUnpair => 'फ़ोन हटाएं';

  @override
  String devicesPairedAs(String role, String shop) {
    return '$role के रूप में जुड़ा · $shop';
  }

  @override
  String get devicesNewCode => 'नया पेयरिंग कोड';

  @override
  String get devicesCodeExpires =>
      '15 मिनट के लिए मान्य · कॉपी करने के लिए टैप करें';

  @override
  String get devicesList => 'जुड़े हुए फ़ोन';

  @override
  String get devicesEmpty => 'अभी कोई फ़ोन नहीं जुड़ा है';

  @override
  String get devicesRevoke => 'हटाएं';

  @override
  String get devicesRevoked => 'हटा दिया';

  @override
  String get devicesOnline => 'ऑनलाइन';

  @override
  String get devicesOffline => 'ऑफ़लाइन';

  @override
  String get devicesRoleWaiter => 'वेटर';

  @override
  String get devicesRoleKitchen => 'किचन';

  @override
  String get devicesRoleCounter => 'काउंटर';

  @override
  String get devicesProRequired =>
      'मल्टी-डिवाइस सिंक Pro फ़ीचर है। वेटर, किचन और काउंटर फ़ोन जोड़ने के लिए अपग्रेड करें।';

  @override
  String get cloudShopSection => 'क्लाउड शॉप';

  @override
  String get cloudShopHint =>
      'सर्वर पर दुकान बनाएं ताकि QR मेन्यू ऑर्डर और स्टाफ फ़ोन पर एक ही लाइव ऑर्डर लिस्ट दिखे।';

  @override
  String get cloudShopSlug => 'लिंक के लिए दुकान का नाम (उदा. sirpam-tea)';

  @override
  String get cloudShopKey => 'शॉप की (प्राइवेट, 16+ अक्षर)';

  @override
  String get cloudShopGenerate => 'की बनाएं';

  @override
  String get cloudShopCreate => 'क्लाउड शॉप बनाएं';

  @override
  String get cloudShopUpdate => 'क्लाउड शॉप अपडेट करें';

  @override
  String cloudShopLive(String slug) {
    return 'क्लाउड शॉप तैयार: $slug';
  }

  @override
  String get cloudShopNone =>
      'अभी कोई क्लाउड शॉप नहीं है। QR ऑर्डर और स्टाफ फ़ोन के लिए शॉप बनाएं।';

  @override
  String get cloudShopCreated => 'क्लाउड शॉप बन गई';

  @override
  String get cloudShopKeyShort =>
      'दुकान का नाम और कम से कम 16 अक्षरों की \'की\' डालें।';

  @override
  String get cloudShopCopyKey => 'की कॉपी करें';

  @override
  String get cloudShopKeyCopied => 'शॉप की कॉपी हो गई';

  @override
  String get approvalTitle => 'मालिक की मंज़ूरी';

  @override
  String approvalNeeded(String action) {
    return 'इस शिफ्ट में यह करने की अनुमति नहीं है: $action। मालिक एक बार मंज़ूरी दे सकते हैं।';
  }

  @override
  String approvalOverLimit(String action) {
    return 'यह इस शिफ्ट की लिमिट से ज़्यादा है: $action। मालिक एक बार मंज़ूरी दे सकते हैं।';
  }

  @override
  String get approvalOwnerPin => 'मालिक का PIN';

  @override
  String get approvalApprove => 'एक बार अनुमति दें';

  @override
  String get approvalGranted => 'मालिक ने मंज़ूरी दे दी';

  @override
  String get approvalWrongPin => 'गलत मालिक PIN';

  @override
  String get approvalBlockedTitle => 'अनुमति नहीं है';

  @override
  String approvalBlockedBody(String action) {
    return 'इस शिफ्ट में $action का अधिकार नहीं है। मालिक से रोल बदलने को कहें।';
  }

  @override
  String get recurringRemove => 'हटाएं';

  @override
  String get recurringRemoved => 'रेकरिंग खर्च हटा दिया गया';

  @override
  String recurringRemoveConfirm(String name) {
    return 'क्या $name को रेकरिंग खर्च से हटाना है?';
  }

  @override
  String get orderEditItems => 'आइटम बदलें';

  @override
  String get orderEditItemsSaved => 'ऑर्डर के आइटम अपडेट हो गए';

  @override
  String get orderEditEmpty => 'ऑर्डर में कम से कम एक आइटम होना चाहिए।';

  @override
  String get printerStatus => 'प्रिंटर स्टेटस';

  @override
  String get printerNotConnected => 'कोई प्रिंटर कनेक्ट नहीं है';

  @override
  String printerConnectedTo(String name) {
    return '$name से कनेक्टेड';
  }

  @override
  String get printerDisconnect => 'डिस्कनेक्ट करें';

  @override
  String get printerDisconnected => 'प्रिंटर डिस्कनेक्ट हो गया';

  @override
  String get printerForget => 'प्रिंटर हटाएं';

  @override
  String get printerForgotten =>
      'प्रिंटर हटा दिया गया। बिल PDF में शेयर होंगे।';

  @override
  String get printerUnsupported => 'यह फोन ब्लूटूथ से प्रिंट नहीं कर सकता।';

  @override
  String get printerPermissionNeeded =>
      'प्रिंटर खोजने के लिए ब्लूटूथ की अनुमति दें।';

  @override
  String get printerPermissionDenied => 'ब्लूटूथ की अनुमति नहीं मिली।';

  @override
  String get printerAllowBluetooth => 'ब्लूटूथ की अनुमति दें';

  @override
  String get devicesTest => 'कनेक्शन टेस्ट करें';

  @override
  String get devicesTestOk => 'दुकान से कनेक्टेड है';

  @override
  String get devicesTestFailed =>
      'यह फोन कनेक्टेड नहीं है। मालिक से नया कोड मांगें।';

  @override
  String stockLastUpdated(String when) {
    return 'स्टॉक आखिरी बार अपडेट: $when';
  }

  @override
  String get agoJustNow => 'अभी-अभी';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट पहले',
      one: '1 मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '1 घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'सुबह की तैयारी';

  @override
  String get prepSubtitle => 'पहले ग्राहक से पहले क्या तैयार होना चाहिए';

  @override
  String prepPending(String count) {
    return '$count तैयार करना बाकी है';
  }

  @override
  String get prepUseStarter => 'शुरुआती लिस्ट इस्तेमाल करें';

  @override
  String get prepTodaySheet => 'आज की लिस्ट';

  @override
  String get prepAddTitle => 'तैयारी का आइटम जोड़ें';

  @override
  String get prepItemName => 'आइटम';

  @override
  String get prepPlanned => 'तय';

  @override
  String get prepMade => 'बनाया';

  @override
  String get prepUnit => 'यूनिट';

  @override
  String get prepAdd => 'शीट में जोड़ें';

  @override
  String prepShort(String qty) {
    return '$qty कम';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$planned $unit में से $made';
  }

  @override
  String get prepSeedMilk => 'दूध';

  @override
  String get prepSeedBatter => 'घोल / आटा';

  @override
  String get prepSeedSnacks => 'स्नैक्स';

  @override
  String get prepSeedChange => 'छुट्टे पैसे';

  @override
  String get prepSeedDisplay => 'डिस्प्ले लगाएं';

  @override
  String get prepSeedStock => 'शेल्फ भरें';

  @override
  String get prepUnitLitre => 'लीटर';

  @override
  String get prepUnitPlate => 'प्लेट';

  @override
  String get prepUnitPiece => 'पीस';

  @override
  String get prepUnitRupee => 'रुपये';

  @override
  String get insightsRush => 'भीड़ का समय';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return '$hour:00 बजे सबसे ज़्यादा भीड़ ($bills बिल) — काउंटर पर $staff को रखें';
  }

  @override
  String get dayCloseOpeningCash => 'शुरुआती कैश';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item खत्म मार्क किया गया';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item वापस बिक्री में उपलब्ध';
  }

  @override
  String get insightsHeroes => 'आज के टॉप आइटम';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold बिके · $left बचे';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return 'लगभग $hour:00 बजे खत्म हो जाएगा';
  }

  @override
  String get customerLapsedTitle => 'काफ़ी समय से नहीं आए';

  @override
  String get customerLapsedHint =>
      'एक छोटा मैसेज भेजने से ज़्यादातर ग्राहक लौट आते हैं।';

  @override
  String customerLapsedDays(String days) {
    return 'आखिरी विज़िट को $days दिन हुए';
  }

  @override
  String get customerNudge => 'मैसेज भेजें';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'नमस्ते $name, $shop पर आपकी याद आ रही है! इस हफ्ते आपके लिए कुछ ताज़ा तैयार है।';
  }

  @override
  String get offersTitle => 'ऑफ़र';

  @override
  String get offersSubtitle => 'आपके चालू डिस्काउंट और उन पर होने वाला खर्च।';

  @override
  String get offerAdd => 'ऑफ़र जोड़ें';

  @override
  String get offerName => 'ऑफ़र का नाम';

  @override
  String get offerCode => 'ग्राहक द्वारा बोला जाने वाला कोड (वैकल्पिक)';

  @override
  String get offerKindFlat => 'रुपये की छूट';

  @override
  String get offerKindPercent => '% छूट';

  @override
  String get offerKindCombo => 'कॉम्बो कीमत';

  @override
  String get offerAmount => 'छूट की रकम';

  @override
  String get offerPercent => '% छूट';

  @override
  String get offerComboPrice => 'कॉम्बो रेट';

  @override
  String get offersGivenTotal => 'अब तक दी गई छूट';

  @override
  String get offersEmpty =>
      'अभी कोई ऑफर नहीं है। नया जोड़ें और यह बिल पर दिखेगा।';

  @override
  String get offerLive => 'चालू';

  @override
  String get offerPaused => 'रोका हुआ';

  @override
  String get offerPause => 'रोकें';

  @override
  String get offerResume => 'फिर चालू करें';

  @override
  String offerUsed(String count) {
    return '$count बार इस्तेमाल हुआ';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount की छूट दी';
  }

  @override
  String get feedbackTitle => 'बिल फीडबैक';

  @override
  String get feedbackSubtitle => 'पेमेंट के बाद आसान रेटिंग, सीधे आपके पास।';

  @override
  String get feedbackQrTitle => 'काउंटर QR';

  @override
  String get feedbackQrHint =>
      'प्रिंट करके काउंटर पर रखें, या पेमेंट के बाद दिखाएं।';

  @override
  String get feedbackReviewMissing =>
      'Growth में रिव्यू लिंक जोड़ें ताकि खुश ग्राहक ऑनलाइन रिव्यू दे सकें।';

  @override
  String get feedbackLinkCopied => 'लिंक कॉपी हो गया';

  @override
  String get feedbackScores => 'स्कोर';

  @override
  String get feedbackTodayAvg => 'आज (औसत · गिनती)';

  @override
  String get feedbackWeekAvg => 'पिछले 7 दिन (औसत · गिनती)';

  @override
  String get feedbackNeedsReply => 'जवाब देना बाकी';

  @override
  String get feedbackRecord => 'खुद रेटिंग दर्ज करें';

  @override
  String get feedbackHappy => 'अच्छा';

  @override
  String get feedbackOkay => 'ठीक-ठाक';

  @override
  String get feedbackUnhappy => 'अच्छा नहीं';

  @override
  String get feedbackRecent => 'हाल की रेटिंग';

  @override
  String get feedbackEmpty => 'अभी कोई रेटिंग नहीं है।';

  @override
  String get enquiriesTitle => 'पूछताछ';

  @override
  String get enquiriesSubtitle => 'किसने पूछा, क्या रेट दिया और क्या बात बनी।';

  @override
  String get enquiryAdd => 'पूछताछ जोड़ें';

  @override
  String get enquiryName => 'ग्राहक का नाम';

  @override
  String get enquiryPhone => 'फ़ोन';

  @override
  String get enquiryWant => 'क्या सामान चाहिए';

  @override
  String get enquiryQuote => 'दिया गया रेट';

  @override
  String get enquiryNoFollowUp => 'कोई रिमाइंडर नहीं';

  @override
  String enquiryFollowUpDays(String days) {
    return '$days दिन बाद फॉलो-अप';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% बिक्री में बदलीं';
  }

  @override
  String get enquiryWonValue => 'बिक्री वैल्यू';

  @override
  String get enquiryFilterToday => 'आज';

  @override
  String get enquiryFilterOpen => 'ओपन';

  @override
  String get enquiryFilterWon => 'पक्की हुई';

  @override
  String get enquiryFilterLost => 'रद्द';

  @override
  String get enquiryEmpty => 'यहाँ कुछ नहीं है।';

  @override
  String enquiryFollowUpOn(String day) {
    return '$day को बात करें';
  }

  @override
  String get enquiryMessage => 'मैसेज';

  @override
  String enquiryMessageText(String name, String item) {
    return 'नमस्ते $name, $item के बारे में पूछना था। क्या आपके लिए तैयार रखूँ?';
  }

  @override
  String get enquiryWon => 'पक्की हुई';

  @override
  String get enquiryLost => 'रद्द';

  @override
  String get enquiryReopen => 'फिर खोलें';

  @override
  String get customerRewardsDueTitle => 'बाकी रिवॉर्ड्स';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'यह लिंक नाम पहले से किसी और का है। $slug जैसा कुछ आज़माएँ।';
  }

  @override
  String get cloudShopSlugInvalid =>
      'सिर्फ छोटे अक्षर, नंबर और डैश (-) डालें, कम से कम 3 अक्षर।';

  @override
  String get cloudShopOffline =>
      'इंटरनेट बंद है। कनेक्शन चेक करके दोबारा कोशिश करें।';

  @override
  String get cloudShopTryAgain =>
      'काम नहीं हो पाया। कृपया थोड़ी देर में फिर कोशिश करें।';

  @override
  String get cloudShopLinkTitle => 'ग्राहक लिंक';

  @override
  String get cloudShopCopyLink => 'लिंक कॉपी करें';

  @override
  String get cloudShopLinkCopied => 'लिंक कॉपी हो गया';

  @override
  String get cloudShopShowQr => 'QR दिखाएँ';

  @override
  String get paymentQrScanTitle => 'अपने पेमेंट ऐप का QR इस्तेमाल करें';

  @override
  String get paymentQrScanAction => 'अपना QR स्कैन करें';

  @override
  String get paymentQrScanHelp =>
      'कैमरा GPay, PhonePe या Paytm के QR स्टीकर पर रखें। हम उससे UPI ID ले लेंगे, ताकि बिल और काउंटर QR के पैसे उसी खाते में आएँ।';

  @override
  String paymentQrScanFound(String vpa) {
    return 'आपके QR से मिली UPI ID: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'यह पेमेंट QR नहीं है। अपने पेमेंट ऐप में दिखने वाला QR आज़माएँ।';

  @override
  String get receiptFeedbackLine => 'कैसा लगा, बताने के लिए स्कैन करें';

  @override
  String get qrPrintCounterCard => 'काउंटर कार्ड प्रिंट करें';

  @override
  String get qrPayCaption => 'पेमेंट के लिए स्कैन करें';

  @override
  String get qrFeedbackCaption => 'रेटिंग देने के लिए स्कैन करें';

  @override
  String get offerPrintCards => 'ऑफ़र कार्ड प्रिंट करें';

  @override
  String get offerCardCaption => 'यह ऑफ़र पाने के लिए स्कैन करें';

  @override
  String get devicesPairQrHint => 'नए फ़ोन से इसे स्कैन कराएँ';

  @override
  String get devicesScanQr => 'पेयरिंग QR स्कैन करें';

  @override
  String get devicesScanInvalid =>
      'यह पेयरिंग QR नहीं है। ओनर से दोबारा दिखाने को कहें।';

  @override
  String get quickSaleScan => 'सामान स्कैन करें';

  @override
  String get quickSaleScanTitle => 'सामान का लेबल स्कैन करें';

  @override
  String quickSaleScanUnknown(String code) {
    return 'कोड $code का कोई सामान नहीं मिला। इसे \'प्रोडक्ट्स\' में जोड़ें।';
  }

  @override
  String get backupTitle => 'बैकअप और एक्सपोर्ट';

  @override
  String get backupSubtitle => 'अपने खाते की एक कॉपी सुरक्षित रखें';

  @override
  String get backupNowAction => 'अभी बैकअप लें';

  @override
  String get backupRestoreAction => 'फ़ाइल से रीस्टोर करें';

  @override
  String get backupShareSubject => 'VendorOS बैकअप';

  @override
  String get backupSavedToast => 'बैकअप फ़ाइल बन गई';

  @override
  String get backupFailedToast => 'बैकअप नहीं बन सका। कृपया फिर कोशिश करें।';

  @override
  String get backupRestoredToast => 'आपका हिसाब-किताब रीस्टोर हो गया है';

  @override
  String get backupNeverSaved => 'कभी बैकअप नहीं लिया गया';

  @override
  String backupLastSaved(String when) {
    return 'आख़िरी बैकअप: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'लगभग $kb KB सेव होगा';
  }

  @override
  String get backupRestoreWarning =>
      'रीस्टोर करने से इस फ़ोन का सारा डेटा फ़ाइल वाले डेटा से बदल जाएगा।';

  @override
  String get backupRestoreConfirmTitle => 'यह बैकअप रीस्टोर करें?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$when की $rows एंट्रीज़ से इस फ़ोन का डेटा बदल जाएगा।';
  }

  @override
  String get backupErrorNotFile => 'यह VendorOS बैकअप फ़ाइल नहीं है।';

  @override
  String get backupErrorTooNew =>
      'यह बैकअप नए वर्शन का है। कृपया पहले ऐप अपडेट करें।';

  @override
  String get backupErrorCorrupt =>
      'यह बैकअप फ़ाइल खराब है और इस्तेमाल नहीं हो सकती।';

  @override
  String get backupErrorEmpty => 'फ़ाइल खाली है।';

  @override
  String get exportGroupLabel => 'स्प्रेडशीट में एक्सपोर्ट करें';

  @override
  String get exportSalesTitle => 'बिक्री';

  @override
  String get exportSalesSubtitle => 'तारीख़, सामान और रकम के साथ हर बिक्री';

  @override
  String get exportBillsTitle => 'बिल';

  @override
  String get exportBillsSubtitle => 'बिल के हिसाब से कुल रकम, छूट और टैक्स';

  @override
  String get exportCreditTitle => 'उधारी बाकी';

  @override
  String get exportCreditSubtitle => 'किस पर कितनी उधारी बाकी है';

  @override
  String get exportStockTitle => 'स्टॉक';

  @override
  String get exportStockSubtitle => 'सामान, बचा हुआ स्टॉक और कीमतें';

  @override
  String get exportColDate => 'तारीख़';

  @override
  String get exportColItem => 'सामान';

  @override
  String get exportColMode => 'पेमेंट';

  @override
  String get exportColCustomer => 'ग्राहक';

  @override
  String get exportColAmount => 'रकम';

  @override
  String get exportColBillNo => 'बिल नं.';

  @override
  String get exportColSubtotal => 'सबटोटल';

  @override
  String get exportColDiscount => 'छूट';

  @override
  String get exportColTax => 'टैक्स';

  @override
  String get exportColTotal => 'कुल';

  @override
  String get exportColPayment => 'पेमेंट का तरीका';

  @override
  String get exportColStatus => 'स्टेटस';

  @override
  String get exportColBalance => 'बाकी';

  @override
  String get exportColCode => 'कोड';

  @override
  String get exportColCategory => 'कैटेगरी';

  @override
  String get exportColUnit => 'यूनिट';

  @override
  String get exportColQty => 'मात्रा';

  @override
  String get exportColCost => 'लागत';

  @override
  String get exportColPrice => 'कीमत';

  @override
  String get gstReportTitle => 'GST सारांश';

  @override
  String get gstReportSubtitle => 'अकाउंटेंट के लिए महीने का टैक्स';

  @override
  String get gstReportEmpty =>
      'अभी कोई GST बिल नहीं है। मेन्यू सेटिंग्स में GST ऑन करें, फिर बिल बनाएं।';

  @override
  String get gstColMonth => 'महीना';

  @override
  String get gstColRate => 'रेट';

  @override
  String get gstColTaxable => 'टैक्सेबल रकम';

  @override
  String get gstColTax => 'कुल टैक्स';

  @override
  String get gstBills => 'बिल';

  @override
  String get gstSales => 'टैक्स सहित बिक्री';

  @override
  String get gstByRate => 'रेट अनुसार';

  @override
  String get gstShareAction => 'स्प्रेडशीट शेयर करें';

  @override
  String gstShareSubject(String month) {
    return 'GST सारांश $month';
  }

  @override
  String get appearanceTitle => 'थीम';

  @override
  String get appearanceSubtitle => 'लाइट या डार्क स्क्रीन';

  @override
  String get appearanceSystem => 'फ़ोन जैसा';

  @override
  String get appearanceLight => 'लाइट';

  @override
  String get appearanceDark => 'डार्क';

  @override
  String get appearanceChanged => 'थीम बदल दी गई';

  @override
  String get purchasesTitle => 'खरीदारी';

  @override
  String get purchasesSubtitle => 'सप्लायर बिल और बाकी रकम';

  @override
  String get purchasesEmpty =>
      'अभी कोई खरीद बिल नहीं है। हाल में खरीदा माल जोड़ें।';

  @override
  String get purchaseAdd => 'खरीद जोड़ें';

  @override
  String get purchaseTotalDue => 'सप्लायर का बाकी';

  @override
  String get purchaseMonthSpend => 'इस महीने की खरीद';

  @override
  String get purchaseDuesTitle => 'सप्लायर का बकाया';

  @override
  String get purchaseNoDues => 'सप्लायर के सभी बिल चुकता हैं।';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills बिल · सबसे पुराना $days दिन';
  }

  @override
  String get purchaseBillsTitle => 'खरीद बिल';

  @override
  String get purchasePaidFull => 'चुकता';

  @override
  String purchaseDueOf(String amount) {
    return '$amount बाकी';
  }

  @override
  String get purchaseSupplier => 'सप्लायर';

  @override
  String purchasePayTitle(String name) {
    return '$name को पेमेंट';
  }

  @override
  String get purchasePayAmount => 'दी गई रकम';

  @override
  String get purchasePay => 'पेमेंट दर्ज करें';

  @override
  String get purchaseSubtotal => 'सामान का कुल';

  @override
  String get purchaseTax => 'टैक्स';

  @override
  String get purchaseTotal => 'कुल बिल';

  @override
  String get purchaseDue => 'अभी बाकी';

  @override
  String get purchaseNewTitle => 'नया खरीद बिल';

  @override
  String get purchaseInvoiceNo => 'बिल नंबर';

  @override
  String get purchaseItems => 'खरीदा गया सामान';

  @override
  String get purchaseLinkProduct => 'स्टॉक लिस्ट से चुनें';

  @override
  String get purchaseFreeItem => 'आइटम का नाम';

  @override
  String get purchaseQty => 'मात्रा';

  @override
  String get purchaseUnitCost => 'प्रति यूनिट रेट';

  @override
  String get purchaseAddLine => 'आइटम जोड़ें';

  @override
  String get purchasePaidNow => 'अभी दिया';

  @override
  String get purchaseNote => 'नोट';

  @override
  String get purchaseSaved => 'खरीद सेव हुई और स्टॉक अपडेट हुआ';

  @override
  String get permRecordPurchase => 'खरीद बिल दर्ज करें';

  @override
  String get permPaySupplier => 'सप्लायर को पेमेंट करें';

  @override
  String get backupCloudTitle => 'ऑनलाइन बैकअप';

  @override
  String backupCloudLast(String when) {
    return 'पिछला ऑनलाइन बैकअप: $when';
  }

  @override
  String get backupCloudNever => 'अभी तक ऑनलाइन सेव नहीं हुआ';

  @override
  String get backupCloudNeedsShop => 'पहले क्लाउड दुकान बनाएँ';

  @override
  String get backupCloudNowAction => 'अभी ऑनलाइन बैकअप लें';

  @override
  String get backupCloudRestoreAction => 'ऑनलाइन से वापस लाएँ';

  @override
  String get backupCloudSavedToast => 'ऑनलाइन सेव हो गया';

  @override
  String get backupCloudFailedToast =>
      'ऑनलाइन सेव नहीं हो सका। नेटवर्क आने पर दोबारा कोशिश करें।';

  @override
  String get billWhatsapp => 'व्हाट्सएप पर भेजें';

  @override
  String get billWhatsappFailed => 'इस फ़ोन में व्हाट्सएप नहीं है।';

  @override
  String get devicesStaffRole => 'स्टाफ भूमिका';

  @override
  String get devicesRoleDefault => 'डिफ़ॉल्ट (सिर्फ़ काम)';

  @override
  String get devicesRolePick => 'एक स्टाफ भूमिका चुनें';

  @override
  String get devicesRoleSaved => 'भूमिका उस फ़ोन को भेज दी गई';

  @override
  String get devicesRoleFailed =>
      'भूमिका सेट नहीं हो सकी। ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String get adminTitle => 'मालिक की रिपोर्ट';

  @override
  String get adminSubtitle => 'क्या हुआ, किसने किया, और नकद मिला या नहीं';

  @override
  String get adminExceptionsTitle => 'अपवाद';

  @override
  String get adminExceptionsSubtitle => 'छूट, रद्द बिल, दोबारा प्रिंट और उधार';

  @override
  String get adminStaffTitle => 'स्टाफ रिपोर्ट';

  @override
  String get adminStaffSubtitle => 'इस अवधि में हर व्यक्ति ने क्या किया';

  @override
  String get adminCashTitle => 'नकद बही';

  @override
  String get adminCashSubtitle => 'अनुमानित बनाम गिना गया, हर दिन';

  @override
  String get adminItemsTitle => 'आइटम अंतर';

  @override
  String get adminItemsSubtitle => 'बिका हुआ बनाम स्टॉक से निकला';

  @override
  String get adminShopsTitle => 'सभी दुकानें';

  @override
  String get adminShopsSubtitle => 'आपकी हर दुकान का कुल';

  @override
  String get adminSummaryTitle => 'आज का सारांश';

  @override
  String get adminSummarySend => 'सारांश भेजें';

  @override
  String get adminShare => 'साझा करें';

  @override
  String get adminNoRows => 'इस अवधि के लिए कुछ नहीं';

  @override
  String get adminFromBill => 'बिल से';

  @override
  String get adminOwnerApproved => 'मालिक ने मंजूरी दी';

  @override
  String get adminColActions => 'कार्य';

  @override
  String get adminColDiscount => 'दी गई छूट';

  @override
  String get adminColCredit => 'दिया गया उधार';

  @override
  String get adminColVoids => 'रद्द बिल';

  @override
  String get adminColReprints => 'दोबारा प्रिंट';

  @override
  String get adminColOverrides => 'मालिक की मंजूरियां';

  @override
  String get adminSeeExceptions => 'इनके अपवाद देखें';

  @override
  String get adminCashOpening => 'शुरुआती नकद';

  @override
  String get adminCashExpected => 'अनुमानित';

  @override
  String get adminCashCounted => 'गिना गया';

  @override
  String get adminCashShort => 'कम';

  @override
  String get adminCashOver => 'अधिक';

  @override
  String get adminCashNet => 'कुल अंतर';

  @override
  String get adminCashMatched => 'मिले हुए दिन';

  @override
  String get adminCashMatchedOne => 'मिला';

  @override
  String get adminCashShortDays => 'कम वाले दिन';

  @override
  String get adminItemSold => 'बिका';

  @override
  String get adminItemStockOut => 'स्टॉक से निकला';

  @override
  String get adminItemGap => 'अंतर';

  @override
  String get adminItemWasted => 'बर्बाद';

  @override
  String get adminSummaryBills => 'बिल';

  @override
  String get adminSummarySales => 'बिक्री';

  @override
  String get adminSummaryCash => 'नकद';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'उधार';

  @override
  String get adminSummaryDiscount => 'छूट';

  @override
  String get adminSummarySpend => 'खर्च';

  @override
  String get adminSummaryCashDiff => 'नकद अंतर';

  @override
  String get adminSummaryTop => 'टॉप आइटम';

  @override
  String get adminShopsAllTotal => 'सभी दुकानें मिलाकर';

  @override
  String get adminShopsOrders => 'ऑर्डर (7 दिन)';

  @override
  String get adminShopsValue => 'मूल्य (7 दिन)';

  @override
  String get adminShopsAdd => 'दूसरी दुकान जोड़ें';

  @override
  String get adminShopsAddHelp =>
      'दूसरी दुकान का लिंक नाम और मालिक की कुंजी लिखें।';

  @override
  String get adminShopsAddAction => 'दुकान जोड़ें';

  @override
  String get adminShopsSlug => 'दुकान लिंक नाम';

  @override
  String get adminShopsKey => 'मालिक की कुंजी';

  @override
  String get adminShopsRemove => 'हटाएं';

  @override
  String get adminShopsRefresh => 'ताज़ा करें';

  @override
  String get adminShopsError => 'यह दुकान नहीं पढ़ पाए';

  @override
  String get adminShopsInvalid => 'लिंक नाम और मालिक की कुंजी जांचें';

  @override
  String get adminShopsExists => 'वह दुकान पहले से सूची में है';

  @override
  String get permViewCashBook => 'नकद बही देखें';

  @override
  String get permExportData => 'डेटा निर्यात करें';

  @override
  String get permViewStaffReport => 'स्टाफ रिपोर्ट देखें';
}
