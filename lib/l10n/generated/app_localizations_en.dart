// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String udhaarReminderMessage(
      String name, String stall, String amount, String link) {
    return 'Hello $name, your outstanding balance at $stall is Rs $amount. Please pay. Thank you.$link';
  }

  @override
  String get appTitle => 'VendorOS';

  @override
  String get navHome => 'Home';

  @override
  String get navUdhaar => 'Credit';

  @override
  String get navSoundbox => 'Sound';

  @override
  String get navMandi => 'Market';

  @override
  String get navSales => 'Sales';

  @override
  String get navGroupOverview => 'Overview';

  @override
  String get navGroupSell => 'Sell';

  @override
  String get navGroupOperations => 'Customers & operations';

  @override
  String get navGroupBusiness => 'Business';

  @override
  String get navGroupTeam => 'Team';

  @override
  String get navGroupSystem => 'System';

  @override
  String get moreLabel => 'More';

  @override
  String get menuLoanReport => 'Loan report';

  @override
  String get menuCartLocation => 'Cart location';

  @override
  String get menuSettings => 'Settings';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get goHome => 'Go home';

  @override
  String get ok => 'OK';

  @override
  String get loading => 'Loading…';

  @override
  String storageWriteFailedKey(String key) {
    return 'Could not save ($key) — please try again';
  }

  @override
  String get storageWriteFailed => 'Could not save — please try again';

  @override
  String get micUnavailable => 'Microphone unavailable — please enter manually';

  @override
  String get voiceNothingHeard => 'Nothing heard — please speak again';

  @override
  String get voiceNoAmount => 'No amount heard — say \"50 rupees tomato\"';

  @override
  String get voiceZeroAmount => 'Amount cannot be zero';

  @override
  String get modeCash => 'Cash';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCredit => 'Credit';

  @override
  String saleRecorded(String mode, String amount) {
    return '$mode ₹$amount recorded';
  }

  @override
  String todayTotalSemantic(String amount) {
    return 'Today\'s total business $amount rupees';
  }

  @override
  String get todayCollection => 'Today\'s collection';

  @override
  String get quickEntry => 'Quick entry';

  @override
  String get todayEntries => 'Today\'s entries';

  @override
  String get noEntriesYet => 'No entries yet — press the mic and speak';

  @override
  String get listeningTapToStop => 'Listening, tap to stop';

  @override
  String get tapToSpeak => 'Speak to record';

  @override
  String get listening => 'Listening…';

  @override
  String get speakToRecord => '🎙️ Speak to record';

  @override
  String get voiceHint => '\"50 rupees tomato cash\" / \"ravi ku 200 credit\"';

  @override
  String get addSale => 'Add sale';

  @override
  String saleSemantic(String label, String amount, String item) {
    return '$label $amount rupees, $item';
  }

  @override
  String get delete => 'Delete';

  @override
  String get locationServiceOff => 'Location service is turned off';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get broadcastLive => 'Broadcasting live';

  @override
  String get locationSearching => 'Finding location…';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get broadcastStopped => 'Broadcast stopped';

  @override
  String get locationNotFetched => 'Location not fetched yet';

  @override
  String get stopBroadcast => 'Stop broadcast';

  @override
  String get startBroadcast => 'Start broadcast';

  @override
  String get sendToCustomer => 'Send to customers';

  @override
  String get shareLocationHint => 'Share today\'s cart spot over WhatsApp.';

  @override
  String get ourCart => 'Our cart';

  @override
  String cartLocationMessage(String stall, String url) {
    return '$stall is here today 👇\n$url';
  }

  @override
  String get shareOnWhatsapp => 'Share on WhatsApp';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String mandiKeyRejected(String status) {
    return 'data.gov.in rejected the request — check the API key ($status)';
  }

  @override
  String connectionFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get mandiTitle => 'Market prices';

  @override
  String get refresh => 'Refresh';

  @override
  String get mandiLoading => 'Loading market prices';

  @override
  String get fetchFailed => 'Could not fetch data';

  @override
  String get apiKeyNeeded => 'data.gov.in API key required';

  @override
  String get apiKeyNeededBody =>
      'Get a free data.gov.in API key for live APMC prices and add it in Settings. No mock prices are shown.';

  @override
  String get refreshFailed => 'Latest refresh failed';

  @override
  String lastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get searchVegetable => 'Search vegetable';

  @override
  String get loanReportHeading => 'Business loan report';

  @override
  String reportFailed(String error) {
    return 'Report failed: $error';
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
      other: '$daysString days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get totalBusiness => 'Total business';

  @override
  String get digitalShare => 'Digital share';

  @override
  String get avgDailyIncome => 'Average daily income';

  @override
  String get recordedDays => 'Recorded days';

  @override
  String get sha256Checksum => 'SHA-256 checksum';

  @override
  String get noSalesYet =>
      'No sales recorded yet — record sales first to generate a report.';

  @override
  String get viewPdf => 'View PDF';

  @override
  String get sendToBank => 'Send to bank';

  @override
  String get stallName => 'Stall name';

  @override
  String get ownerName => 'Owner name';

  @override
  String get upiVpaLabel => 'UPI VPA (e.g. name@okaxis)';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get mandiMarket => 'Market (APMC)';

  @override
  String get mandiApiKeyLabel => 'data.gov.in API key';

  @override
  String get apiKeyHelp =>
      'Register free at data.gov.in to get a key. Without a key live prices are not shown.';

  @override
  String get soundboxAnnounce => 'Soundbox announcements';

  @override
  String get save => 'Save';

  @override
  String soundboxSpeech(String amount) {
    return 'Rupees $amount received';
  }

  @override
  String get soundboxTitle => 'Soundbox';

  @override
  String get soundboxSubtitle => 'UPI payments announced in your language';

  @override
  String get watchedApps => 'Watched apps';

  @override
  String get soundboxTestHint => 'Test: \"Rupees 250 received\" will be spoken';

  @override
  String get speak => 'Speak';

  @override
  String get announcedPayments => 'Announced payments';

  @override
  String get noUpiYet => 'No UPI payments received yet';

  @override
  String get soundboxRunning => 'Soundbox is running';

  @override
  String get notificationAccessNeeded => 'Notification access required';

  @override
  String get soundboxAndroidHint =>
      'Payments via PhonePe, Paytm, Google Pay and BHIM are announced automatically.';

  @override
  String get soundboxGrantHint =>
      'Give VendorOS notification access in Android settings.';

  @override
  String get grantAccess => 'Grant access';

  @override
  String get iosUnavailable => 'Not available on iOS';

  @override
  String get webUnavailable => 'Not available in the browser';

  @override
  String get iosSoundboxNote =>
      'Apple\'s background restrictions prevent reading other apps\' notifications. Manual/voice entry only.';

  @override
  String get webSoundboxNote =>
      'The browser cannot read UPI notifications from other apps. Install the Android APK for the soundbox.';

  @override
  String get serverSoundbox => 'Business UPI soundbox';

  @override
  String get serverSoundboxNote =>
      'Payments confirmed by your payment provider are announced here. Nothing is missed: a payment stays queued on the server until this phone speaks it.';

  @override
  String get notPaired =>
      'This phone is not linked to a business UPI account yet.';

  @override
  String get pairingCode => 'Pairing code';

  @override
  String get pair => 'Link phone';

  @override
  String get unpair => 'Unlink';

  @override
  String pairedWith(String name) {
    return 'Linked to $name';
  }

  @override
  String get syncNow => 'Check now';

  @override
  String lastChecked(String time) {
    return 'Last checked at $time';
  }

  @override
  String get neverChecked => 'Not checked yet';

  @override
  String get soundboxStale =>
      'No contact with the server recently. Check the internet connection.';

  @override
  String queuedPayments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString payments waiting to be announced',
      one: '1 payment waiting to be announced',
      zero: 'Nothing waiting',
    );
    return '$_temp0';
  }

  @override
  String get notificationSoundbox => 'Notification soundbox (fallback)';

  @override
  String get udhaarTitle => 'Credit book';

  @override
  String get udhaarSubtitle => 'Customer balances';

  @override
  String get totalOutstanding => 'Total outstanding';

  @override
  String customerCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString customers',
      one: '1 customer',
      zero: 'No customers',
    );
    return '$_temp0';
  }

  @override
  String filterBy(String name) {
    return 'Filter: $name';
  }

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get upiSetupHint =>
      'Add your VPA and stall name in Settings to request UPI.';

  @override
  String get noOutstanding => 'No outstanding credit';

  @override
  String cannotOpen(String scheme) {
    return 'Could not open: $scheme';
  }

  @override
  String get askUpi => 'Ask UPI';

  @override
  String get collect => 'Collect';

  @override
  String get cancel => 'Cancel';

  @override
  String get language => 'Language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String creditNote(String name) {
    return 'Credit $name';
  }

  @override
  String get defaultStallName => 'VendorOS Stall';

  @override
  String get merchantOnboardingTitle => 'Register business UPI';

  @override
  String get merchantOnboardingSubtitle =>
      'Link your business account to the soundbox';

  @override
  String get merchantStepsHint =>
      'Enter the details from your PhonePe for Business or Paytm for Business dashboard. You get a pairing code and this phone is linked right away.';

  @override
  String get howToGetBusinessUpi => 'How do I get a business UPI account?';

  @override
  String get merchantFormIncomplete =>
      'Fill the business name, merchant id and secret key.';

  @override
  String get merchantRegistered => 'Business registered';

  @override
  String get pairingCodeSaveHint =>
      'Save this pairing code. Use it to link a second phone.';

  @override
  String get callbackUrlLabel => 'Callback URL for the provider dashboard';

  @override
  String get backToSoundbox => 'Back to soundbox';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get provider => 'Payment provider';

  @override
  String get providerPhonePe => 'PhonePe';

  @override
  String get providerPaytm => 'Paytm';

  @override
  String get businessName => 'Business name';

  @override
  String get businessNameHint => 'Name spoken and printed on reports';

  @override
  String get businessVpa => 'Business UPI address';

  @override
  String get businessVpaHint => 'stallname@ybl';

  @override
  String get merchantIdLabel => 'Merchant id (MID)';

  @override
  String get merchantIdHint => 'From the provider dashboard';

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
      'Any strong password you also paste in the Paytm dashboard';

  @override
  String get secretStorageNote =>
      'The secret key is stored on the server only and can never be read back by the app.';

  @override
  String get registerBusiness => 'Register business UPI';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpSubtitle => 'Business UPI and soundbox guide';

  @override
  String get helpWhyTitle => 'Why a business UPI account?';

  @override
  String get helpWhyBody =>
      'A personal UPI id cannot confirm payments to a server, so announcements can be missed. A business account sends every successful payment to VendorOS, so the soundbox never loses one.';

  @override
  String get helpDocsTitle => 'What you need';

  @override
  String get helpDocsAadhaar =>
      'Aadhaar number and a mobile number linked to it';

  @override
  String get helpDocsPan => 'PAN card (personal PAN is fine for a small stall)';

  @override
  String get helpDocsBank => 'Bank account number and IFSC for settlement';

  @override
  String get helpDocsShop => 'Shop name, address and a photo of the stall';

  @override
  String get helpRegisterTitle => 'Register with a provider';

  @override
  String get helpRegisterStep1 =>
      'Install PhonePe for Business or Paytm for Business from the Play Store.';

  @override
  String get helpRegisterStep2 =>
      'Sign up with your mobile number and complete the KYC steps with Aadhaar and PAN.';

  @override
  String get helpRegisterStep3 =>
      'Add your bank account so money settles to it, and collect the free QR sticker.';

  @override
  String get helpRegisterStep4 =>
      'Note the business UPI address (for example stallname@ybl) shown in the app.';

  @override
  String get helpKeysTitle => 'Merchant id and secret key';

  @override
  String get helpKeysPhonePe =>
      'PhonePe: open the business dashboard, go to Developer settings, and copy the merchant id, salt key and salt index.';

  @override
  String get helpKeysPaytm =>
      'Paytm: open the business dashboard, go to Developer settings, copy the MID, and create a strong webhook token you also enter here.';

  @override
  String get helpKeysCallback =>
      'Paste the callback URL shown after registration into the provider dashboard so payments reach VendorOS.';

  @override
  String get helpLinkTitle => 'Link this phone';

  @override
  String get helpLinkStep1 => 'Open Soundbox and tap Register business UPI.';

  @override
  String get helpLinkStep2 =>
      'Fill the form; the phone links automatically and shows a pairing code.';

  @override
  String get helpLinkStep3 =>
      'On another phone, enter that pairing code in Soundbox to link it too.';

  @override
  String get helpSafetyTitle => 'Keep it safe';

  @override
  String get helpSafetyBody =>
      'Never share the salt key or webhook token with anyone. VendorOS stores it on the server only and never shows it again.';

  @override
  String get menuInventory => 'Inventory';

  @override
  String get productsTitle => 'Products';

  @override
  String get productsSubtitle => 'Catalogue and stock';

  @override
  String get productsSearchHint => 'Search name or code';

  @override
  String get productsEmpty => 'No products yet. Add your first item.';

  @override
  String get productsAdd => 'Add product';

  @override
  String get productsAllChip => 'All';

  @override
  String get productsLowStockChip => 'Low stock';

  @override
  String get productEditTitle => 'Edit product';

  @override
  String get productMissing => 'This product is no longer in the catalogue.';

  @override
  String get productSaved => 'Saved';

  @override
  String get productArchived => 'Product removed';

  @override
  String get formInvalid => 'Enter a product name';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldLocalName => 'Name in Tamil';

  @override
  String get fieldCode => 'Code';

  @override
  String get fieldCodeHint => 'Barcode, or leave blank for a new one';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldUnit => 'Unit';

  @override
  String get fieldCost => 'Purchase price';

  @override
  String get fieldPrice => 'Selling price';

  @override
  String get fieldReorder => 'Reorder level';

  @override
  String get saveLabel => 'Save';

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardBody => 'You have unsaved changes on this screen.';

  @override
  String get discardKeep => 'Keep editing';

  @override
  String get discardLeave => 'Discard';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get qtyLabel => 'Quantity';

  @override
  String get unitCostLabel => 'Cost per unit';

  @override
  String get expiryLabel => 'Expires in (days)';

  @override
  String get unitKg => 'kg';

  @override
  String get unitGram => 'g';

  @override
  String get unitPiece => 'piece';

  @override
  String get unitLitre => 'litre';

  @override
  String get unitBundle => 'bundle';

  @override
  String get detailSell => 'Sell';

  @override
  String get detailRestock => 'Restock';

  @override
  String get detailWastage => 'Wastage';

  @override
  String get detailCorrect => 'Stock count';

  @override
  String get detailBatches => 'Batches';

  @override
  String get detailHistory => 'History';

  @override
  String get detailLabel => 'Print label';

  @override
  String get historyEmpty => 'No stock movements yet';

  @override
  String get soldRecorded => 'Sale recorded';

  @override
  String get restocked => 'Stock added';

  @override
  String get wastageRecorded => 'Wastage recorded';

  @override
  String get stockCorrected => 'Stock updated';

  @override
  String get movementPurchase => 'Purchase';

  @override
  String get movementSale => 'Sale';

  @override
  String get movementWastage => 'Wastage';

  @override
  String get movementReturn => 'Return';

  @override
  String get movementCorrection => 'Correction';

  @override
  String get expiredTag => 'Expired';

  @override
  String get expiryTodayTag => 'Expires today';

  @override
  String get noExpiry => 'No expiry';

  @override
  String get batchesTitle => 'Batches';

  @override
  String get batchesSubtitle => 'Expiry watch';

  @override
  String get batchesEmpty => 'No dated batches yet';

  @override
  String get stockTitle => 'Stock';

  @override
  String get stockSubtitle => 'Value, alerts and expiry';

  @override
  String get stockValuation => 'Stock value';

  @override
  String get stockProfit => 'Profit (30 days)';

  @override
  String get stockWastage => 'Wastage (30 days)';

  @override
  String get stockLowTitle => 'Running low';

  @override
  String get stockExpiryTitle => 'Expiry';

  @override
  String get stockNothingLow => 'Nothing is running low';

  @override
  String get stockNoExpiry => 'No dated batches';

  @override
  String get stockReorderNow => 'Send reorder list';

  @override
  String get suppliersTitle => 'Suppliers';

  @override
  String get suppliersSubtitle => 'Reorder contacts';

  @override
  String get suppliersEmpty => 'No suppliers yet';

  @override
  String get supplierAdd => 'Add supplier';

  @override
  String get supplierName => 'Name';

  @override
  String get supplierPhone => 'Phone';

  @override
  String get supplierNote => 'Note';

  @override
  String get supplierWhatsapp => 'WhatsApp';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanSubtitle => 'Barcode or QR';

  @override
  String get scanUnsupported =>
      'Camera scanning is not available here. Type the code below.';

  @override
  String get scanPermission => 'Allow camera access to scan';

  @override
  String get scanManualHint => 'Type or paste a code';

  @override
  String get scanCreateFromCode => 'Add a product with this code';

  @override
  String get labelsTitle => 'Labels';

  @override
  String get labelsSubtitle => 'Print QR and barcode labels';

  @override
  String get labelsSelect => 'Choose products';

  @override
  String get labelsSize => 'Label size';

  @override
  String get labelsSymbology => 'Symbol';

  @override
  String get labelsCopies => 'Copies';

  @override
  String get labelsPrint => 'Print sheet';

  @override
  String get labelsThermal => 'Copy printer code';

  @override
  String get labelsCopied => 'Printer code copied';

  @override
  String get labelsNone => 'Select at least one product';

  @override
  String get symbolQr => 'QR';

  @override
  String get symbolBarcode => 'Barcode';

  @override
  String get paymentQrTitle => 'Payment QR';

  @override
  String get paymentQrSubtitle => 'Let customers scan and pay';

  @override
  String get paymentQrAmountHint => 'Amount (optional)';

  @override
  String get paymentQrNeedVpa => 'Add your UPI ID in Settings first.';

  @override
  String get paymentQrOpenSettings => 'Open settings';

  @override
  String get paymentQrPoster => 'Save poster';

  @override
  String get paymentQrCopy => 'Copy link';

  @override
  String get paymentQrCopied => 'Link copied';

  @override
  String get paymentQrNote =>
      'Scanning opens the customer\'s UPI app. A payment counts only when the soundbox announces it.';

  @override
  String stockOnHand(String qty) {
    return 'In stock: $qty';
  }

  @override
  String marginLabel(String pct) {
    return 'Margin $pct%';
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
      other: '$count batches need attention',
      one: '1 batch needs attention',
      zero: 'Nothing expiring soon',
    );
    return '$_temp0';
  }

  @override
  String batchLine(String qty, String cost) {
    return '$qty left · $cost per unit';
  }

  @override
  String sellShortfall(String qty) {
    return 'Only $qty was in stock — recorded that much';
  }

  @override
  String productArchiveConfirm(String name) {
    return 'Remove $name from the catalogue?';
  }

  @override
  String reorderMessage(String stall, String items) {
    return '$stall: please send $items';
  }

  @override
  String paymentQrPayingTo(String vpa) {
    return 'Paying to $vpa';
  }

  @override
  String scanUnknownCode(String code) {
    return 'No product has the code $code';
  }

  @override
  String get profileTitle => 'Business profile';

  @override
  String get vendorCategory => 'Business type';

  @override
  String get categoryCart => 'Street cart (thalluvandi)';

  @override
  String get categoryStall => 'Fixed stall / shop';

  @override
  String get categoryHotel => 'Hotel / eatery';

  @override
  String get categoryService => 'Service work';

  @override
  String get nicheLabel => 'What do you sell or do?';

  @override
  String get districtLabel => 'District';

  @override
  String get talukLabel => 'Taluk / town';

  @override
  String get marketAreaLabel => 'Market / area';

  @override
  String get fssaiLabel => 'FSSAI number (food business)';

  @override
  String get udyamLabel => 'UDYAM registration (optional)';

  @override
  String get workingHoursLabel => 'Working hours';

  @override
  String get perishableLabel => 'Sells perishable goods';

  @override
  String get profilePromptTitle => 'Set up your business profile';

  @override
  String get profilePromptBody =>
      'Tell us what you sell so the app shows only what you need.';

  @override
  String get profilePromptAction => 'Set up';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesSubtitle => 'Milk, gas, snacks, rent — what you pay out';

  @override
  String get expenseToday => 'Spent today';

  @override
  String get expenseAdd => 'Add expense';

  @override
  String get expenseAmount => 'Amount';

  @override
  String get expenseNote => 'Note (optional)';

  @override
  String get expenseTodayList => 'Today\'s expenses';

  @override
  String get expenseEmpty => 'No expense recorded today';

  @override
  String get expenseMilk => 'Milk';

  @override
  String get expenseGas => 'Gas';

  @override
  String get expenseSnacks => 'Snacks';

  @override
  String get expenseProvisions => 'Provisions';

  @override
  String get expenseWages => 'Wages';

  @override
  String get expenseRent => 'Rent';

  @override
  String get expenseElectricity => 'Current bill';

  @override
  String get expenseTransport => 'Transport';

  @override
  String get expenseOther => 'Other';

  @override
  String get recurringTitle => 'Daily supplies';

  @override
  String get recurringAdd => 'Add supply';

  @override
  String get recurringName => 'Supply name';

  @override
  String get recurringEmpty =>
      'Save milk cans or the snack tray here to book them in one tap.';

  @override
  String get dayCloseTitle => 'Day close';

  @override
  String get dayCloseExpectedCash => 'Cash that should be in the box';

  @override
  String get dayCloseBreakdown => 'Today\'s movement';

  @override
  String get dayCloseCollected => 'Credit collected';

  @override
  String get dayCloseWastage => 'Wastage';

  @override
  String get dayCloseProfit => 'Profit today';

  @override
  String get dayCloseCount => 'Count the box';

  @override
  String get dayCloseCountedCash => 'Cash counted';

  @override
  String get dayCloseSave => 'Close the day';

  @override
  String get dayCloseDiscounts => 'Discounts given';

  @override
  String get dayCloseTax => 'Tax collected';

  @override
  String get dayCloseLastToken => 'Last token';

  @override
  String get dayCloseVoided => 'Voided bills';

  @override
  String get dayCloseExport => 'Export day PDF';

  @override
  String get dayCloseVariancePosted => 'Cash difference posted to the ledger.';

  @override
  String get dayCloseExportFailed => 'Could not export the day summary.';

  @override
  String get dayCloseMatch => 'Cash matches exactly.';

  @override
  String dayCloseSurplus(String amount) {
    return '$amount more than expected';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount short';
  }

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsSubtitle => 'Day, week, month and year';

  @override
  String get windowDay => 'Day';

  @override
  String get windowWeek => 'Week';

  @override
  String get windowMonth => 'Month';

  @override
  String get windowYear => 'Year';

  @override
  String get insightsTurnover => 'Turnover';

  @override
  String get insightsCosts => 'Costs';

  @override
  String get insightsProfit => 'Profit';

  @override
  String get insightsAvgDay => 'Per day';

  @override
  String get insightsByDay => 'Day by day';

  @override
  String get insightsBestDay => 'Best day';

  @override
  String get insightsTopItems => 'Best sellers';

  @override
  String get insightsCostSplit => 'Where the money went';

  @override
  String get insightsEmpty => 'Nothing recorded in this period yet';

  @override
  String get insightsMarginAlert => 'Margin warning';

  @override
  String get insightsMarginBody =>
      'These items sell too close to their cost. Raise the price or lower the cost.';

  @override
  String insightsMarginRow(String cost, String price) {
    return 'cost $cost · price $price';
  }

  @override
  String get quickSaleTitle => 'Quick sale';

  @override
  String get quickSaleSubtitle =>
      'One tap per cup — long press for a bigger order';

  @override
  String get quickSaleQty => 'Quantity';

  @override
  String quickSaleQtyTitle(String item) {
    return 'How many $item?';
  }

  @override
  String quickSaleDone(String item, String amount) {
    return '$item · $amount recorded';
  }

  @override
  String quickSaleSemantic(String item, String amount) {
    return 'Sell one $item for $amount';
  }

  @override
  String get quickSaleEmpty => 'Add items with a price to use the quick menu.';

  @override
  String get starterPackAction => 'Load starter kit for my shop';

  @override
  String get starterTea => 'Tea';

  @override
  String get starterCoffee => 'Coffee';

  @override
  String get starterBun => 'Bun';

  @override
  String get starterBiscuit => 'Biscuit';

  @override
  String get starterBajji => 'Bajji';

  @override
  String get starterMilkSupply => 'Milk cans';

  @override
  String get starterSnackSupply => 'Snack tray';

  @override
  String get menuDailyWork => 'Daily running';

  @override
  String get stockOut => 'Out of stock';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersSubtitle => 'Counter and QR orders, live';

  @override
  String get orderCounterNew => 'New counter order';

  @override
  String get orderTable => 'Table';

  @override
  String get orderRemoveItem => 'Remove one';

  @override
  String get orderAddItem => 'Add one';

  @override
  String get orderCancelReason => 'Reason for cancelling';

  @override
  String get orderCancel => 'Cancel order';

  @override
  String get orderLive => 'Live';

  @override
  String get orderHistory => 'History';

  @override
  String get orderEmpty => 'No orders yet.';

  @override
  String get orderNew => 'New';

  @override
  String get orderPreparing => 'Preparing';

  @override
  String get orderServed => 'Served';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderCancelled => 'Cancelled';

  @override
  String get orderAccept => 'Accept';

  @override
  String get orderServe => 'Served';

  @override
  String get orderBulkAccept => 'Accept all new';

  @override
  String get orderBulkServe => 'Serve all ready';

  @override
  String get orderBill => 'Bill';

  @override
  String get orderTokenShort => 'Token';

  @override
  String get kotTitle => 'Kitchen';

  @override
  String get kotSubtitle => 'What has to be cooked next';

  @override
  String get kotEmpty => 'Kitchen queue is clear.';

  @override
  String get kotDone => 'Ready';

  @override
  String get billTitle => 'Bill';

  @override
  String get billNumberLabel => 'Bill';

  @override
  String get billSubtotal => 'Subtotal';

  @override
  String get billDiscount => 'Discount';

  @override
  String get billDiscountFlat => 'Discount amount';

  @override
  String get billDiscountPct => 'Discount %';

  @override
  String get billTax => 'GST';

  @override
  String get billTaxable => 'Taxable';

  @override
  String get billCgst => 'CGST';

  @override
  String get billSgst => 'SGST';

  @override
  String get billIgst => 'IGST';

  @override
  String get shopGstRegistered => 'GST registered shop';

  @override
  String get shopGstRegisteredHint =>
      'Bills show the CGST/SGST split and item HSN codes';

  @override
  String get shopPriceIncludesTax => 'Prices already include tax';

  @override
  String get productTaxRate => 'GST rate %';

  @override
  String get productHsn => 'HSN / SAC code';

  @override
  String get productTaxHint => 'Leave blank to use the shop\'s rate';

  @override
  String get billRounding => 'Rounding';

  @override
  String get billTotal => 'Total';

  @override
  String get billPaid => 'Paid';

  @override
  String get billBalance => 'Balance';

  @override
  String get billReprint => 'Reprint';

  @override
  String get billShare => 'Share';

  @override
  String get billThanks => 'Thank you, come again';

  @override
  String get billCustomer => 'Customer';

  @override
  String get billSplit => 'Payment';

  @override
  String get billRoundToRupee => 'Round to rupee';

  @override
  String get billFillCash => 'Fill balance in cash';

  @override
  String get billFullyPaid => 'Fully paid';

  @override
  String get billSettle => 'Settle bill';

  @override
  String get close => 'Close';

  @override
  String get billPreview => 'Paper preview';

  @override
  String get billVoid => 'Void bill';

  @override
  String get billVoidTitle => 'Void this bill';

  @override
  String get billVoidHint =>
      'The bill number stays in the books and the ledger entries are reversed.';

  @override
  String get billVoidReason => 'Reason';

  @override
  String get billVoidReasonRequired => 'A reason is needed to void a bill';

  @override
  String get billVoided => 'Bill voided';

  @override
  String get billVoidFailed => 'This bill could not be voided';

  @override
  String get billAudit => 'Bill history';

  @override
  String get menuTitle => 'QR menu';

  @override
  String get menuSubtitle => 'What customers see when they scan';

  @override
  String get menuShopSection => 'Shop';

  @override
  String get menuSlug => 'Menu name in the link';

  @override
  String get menuBaseUrl => 'Menu web address';

  @override
  String get menuTableCount => 'Tables';

  @override
  String get menuTaxPercent => 'GST %';

  @override
  String get menuGstin => 'GSTIN';

  @override
  String get menuAcceptOrders => 'Accept QR orders';

  @override
  String get menuSaved => 'Menu settings saved';

  @override
  String get menuQrSheet => 'Print QR sheet';

  @override
  String get menuLinkSection => 'Shop QR';

  @override
  String get menuItemsSection => 'Items on the menu';

  @override
  String get menuSoldOut => 'Sold out';

  @override
  String get menuPublished => 'On menu';

  @override
  String get menuCounterQr => 'Counter';

  @override
  String get menuScanHint => 'Scan to see the menu and order';

  @override
  String get printersTitle => 'Receipt printer';

  @override
  String get printersSubtitle => 'Paper size, connection and test print';

  @override
  String get printerWidth => 'Paper width';

  @override
  String get printerTransport => 'Connection';

  @override
  String get printerPdf => 'PDF / share';

  @override
  String get printerBluetooth => 'Bluetooth';

  @override
  String get printerUsb => 'USB';

  @override
  String get printerDeviceName => 'Printer name';

  @override
  String get printerDeviceAddress => 'Printer address';

  @override
  String get printerFallbackNote =>
      'Direct printing to this device is not ready yet, so the bill opens as a PDF you can print or share.';

  @override
  String get printerAutoPrint => 'Print bill automatically';

  @override
  String get printerKot => 'Print kitchen ticket';

  @override
  String get printerTest => 'Test print';

  @override
  String get printerTestSent => 'Test receipt sent';

  @override
  String get printerPaired => 'Paired printers';

  @override
  String get printerScan => 'Find paired printers';

  @override
  String get printerScanning => 'Looking…';

  @override
  String get printerNoDevices =>
      'No paired printer found. Pair it in Android Bluetooth settings first.';

  @override
  String get printerConnect => 'Connect';

  @override
  String get printerConnected => 'Printer connected';

  @override
  String get printerConnectFailed =>
      'Could not connect. Switch the printer on and try again.';

  @override
  String get printerBluetoothNote =>
      'Bills print straight to this Bluetooth printer. If it is off or out of range, the bill opens as a PDF instead so nothing is lost.';

  @override
  String orderToken(int token) {
    return 'Token $token';
  }

  @override
  String orderElapsed(int minutes) {
    return '$minutes min';
  }

  @override
  String orderItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String billSettled(String number) {
    return 'Bill $number settled';
  }

  @override
  String get dayCloseOrders => 'Orders today';

  @override
  String get dayCloseOrdersTaken => 'Orders taken';

  @override
  String get dayCloseOrdersCancelled => 'Cancelled';

  @override
  String get dayCloseOrdersOpen => 'Still open';

  @override
  String get dayCloseOrdersBilled => 'Billed';

  @override
  String get dayCloseAvgTicket => 'Average ticket';

  @override
  String get menuCloudSection => 'Cloud board';

  @override
  String get menuShopKey => 'Shop key (16+ characters)';

  @override
  String get menuCloudSync => 'Sync orders with the cloud';

  @override
  String get menuCloudPublish => 'Publish menu to cloud';

  @override
  String menuCloudPublished(int count) {
    return 'Published $count items to the cloud menu';
  }

  @override
  String menuCloudFailed(String reason) {
    return 'Cloud error: $reason';
  }

  @override
  String get menuCloudLive =>
      'Live: QR orders arrive on the board automatically.';

  @override
  String get menuCloudOffline =>
      'Local only. Add a shop key and turn on sync to receive QR orders.';

  @override
  String get settleTitle => 'Settle credit';

  @override
  String get settleAmountSection => 'Settlement';

  @override
  String get settleAmount => 'Amount';

  @override
  String get settleCash => 'Cash';

  @override
  String get settleUpi => 'UPI';

  @override
  String get settleLoan => 'New loan';

  @override
  String get settleNote => 'Note';

  @override
  String get settleCashHint =>
      'Cash received closes the balance and is added to today\'s cash takings.';

  @override
  String get settleUpiHint =>
      'Ask on UPI, then confirm. The balance closes and today\'s UPI takings go up.';

  @override
  String get settleLoanHint =>
      'The old balance closes and the same amount reopens as a fresh credit line.';

  @override
  String get settleConfirm => 'Settle';

  @override
  String get settleDone => 'Settlement recorded';

  @override
  String get settleHistory => 'Recent settlements';

  @override
  String settleTooMuch(String amount) {
    return 'More than the outstanding ₹$amount';
  }

  @override
  String settleLedgerItem(String name) {
    return 'Credit settled — $name';
  }

  @override
  String settleLoanItem(String name) {
    return 'Credit rolled into a new loan — $name';
  }

  @override
  String get menuAddress => 'Shop address';

  @override
  String get menuPhone => 'Contact number';

  @override
  String get menuFssai => 'FSSAI licence';

  @override
  String get menuGrowSection => 'Grow & manage';

  @override
  String get recipesTitle => 'Recipe book';

  @override
  String get recipesSubtitle => 'Your measurements, written down once';

  @override
  String get recipeAdd => 'Add a dish';

  @override
  String get recipeName => 'Dish name';

  @override
  String get recipeServings => 'Makes (plates)';

  @override
  String get recipeEmpty => 'No dishes written down yet.';

  @override
  String get recipeIngredients => 'What goes in';

  @override
  String get recipeSteps => 'How to make it';

  @override
  String get recipeAddIngredient => 'Add item';

  @override
  String get recipeAddStep => 'Add step';

  @override
  String get recipeQty => 'Quantity';

  @override
  String get recipeLinkProduct => 'Take from stock item';

  @override
  String get recipeNoLink => 'Not from stock';

  @override
  String get recipeCost => 'Material cost';

  @override
  String get recipePerServing => 'Cost per plate';

  @override
  String get recipeScale => 'Cook for';

  @override
  String get recipeCookBatch => 'Take materials out of stock';

  @override
  String get recipeCooked => 'Materials taken out of stock';

  @override
  String get recipeStepsEmpty => 'No steps written yet.';

  @override
  String get recipeUnlinkedWarning =>
      'Items not linked to stock are left out of the cost.';

  @override
  String get jobsTitle => 'Custom orders';

  @override
  String get jobsSubtitle => 'Advance bookings and made-to-order work';

  @override
  String get jobAdd => 'Take an order';

  @override
  String get jobTitleField => 'What is being made';

  @override
  String get jobCustomer => 'Customer';

  @override
  String get jobPhone => 'Phone';

  @override
  String get jobPrice => 'Price';

  @override
  String get jobAdvance => 'Advance taken';

  @override
  String get jobDue => 'Give on';

  @override
  String get jobEmpty => 'No orders here.';

  @override
  String get jobStatusTaken => 'Taken';

  @override
  String get jobStatusMaking => 'Making';

  @override
  String get jobStatusReady => 'Ready';

  @override
  String get jobStatusDelivered => 'Given';

  @override
  String get jobStatusCancelled => 'Cancelled';

  @override
  String get jobAdvanceStatus => 'Move on';

  @override
  String get jobCancel => 'Cancel';

  @override
  String get jobRemind => 'Message on WhatsApp';

  @override
  String get jobFilterOpen => 'Open';

  @override
  String get jobFilterToday => 'Due today';

  @override
  String get jobFilterDone => 'Finished';

  @override
  String get customersTitle => 'Regulars';

  @override
  String get customersSubtitle => 'Who comes back, and how they found you';

  @override
  String get customerAdd => 'Add customer';

  @override
  String get customerName => 'Name';

  @override
  String get customerPhone => 'Phone';

  @override
  String get sourceWalkIn => 'Walked in';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceMaps => 'Google Maps';

  @override
  String get sourceReferral => 'Told by a friend';

  @override
  String get sourceOther => 'Other';

  @override
  String get customerRecordVisit => 'Add a visit';

  @override
  String get customerVisitAmount => 'Amount';

  @override
  String get customerRewardDue => 'Free one due';

  @override
  String get customerGiveReward => 'Give the free one';

  @override
  String get customersEmpty => 'No regulars saved yet.';

  @override
  String get customerSourceSplit => 'Where the money comes from';

  @override
  String get eventsTitle => 'Events & exhibitions';

  @override
  String get eventsSubtitle => 'Was the stall worth it?';

  @override
  String get eventAdd => 'Add an event';

  @override
  String get eventName => 'Event name';

  @override
  String get eventPlace => 'Place';

  @override
  String get eventDay => 'Date';

  @override
  String get eventRent => 'Stall rent';

  @override
  String get eventTravel => 'Travel';

  @override
  String get eventOther => 'Other cost';

  @override
  String get eventSales => 'Sales';

  @override
  String get eventFootfall => 'Visitors';

  @override
  String get eventProfit => 'Profit';

  @override
  String get eventLoss => 'Loss';

  @override
  String get eventPerVisitor => 'Per visitor';

  @override
  String get eventsEmpty => 'No events recorded yet.';

  @override
  String get staffTitle => 'Workers';

  @override
  String get staffSubtitle => 'Attendance, advances and wages';

  @override
  String get staffAdd => 'Add a worker';

  @override
  String get staffName => 'Name';

  @override
  String get staffPhone => 'Phone';

  @override
  String get staffRole => 'Work';

  @override
  String get staffWage => 'Daily wage';

  @override
  String get staffPresent => 'Present';

  @override
  String get staffHalf => 'Half day';

  @override
  String get staffAbsent => 'Absent';

  @override
  String get staffAdvance => 'Advance';

  @override
  String get staffAdvanceAdd => 'Give advance';

  @override
  String get staffPayable => 'Wage due this month';

  @override
  String get staffEmpty => 'No workers added.';

  @override
  String get staffRemove => 'Remove';

  @override
  String get growthTitle => 'Growth kit';

  @override
  String get growthSubtitle => 'Bring more customers in';

  @override
  String get growthMenuLink => 'Your menu link';

  @override
  String get growthShareMenu => 'Send the menu';

  @override
  String get growthAskReview => 'Ask for a review';

  @override
  String get growthOpenMaps => 'Open Maps page';

  @override
  String get growthWhatsappBroadcast => 'Tell customers on WhatsApp';

  @override
  String get growthLinksSection => 'Your links';

  @override
  String get growthMapsUrl => 'Google Maps link';

  @override
  String get growthReviewUrl => 'Review link';

  @override
  String get growthInstagram => 'Instagram name';

  @override
  String get growthLoyalty => 'Free one after how many visits';

  @override
  String get growthIdeas => 'Post ideas for this week';

  @override
  String get growthShareIdea => 'Send';

  @override
  String get growthIdea1 =>
      'A short clip of the first batch being made in the morning.';

  @override
  String get growthIdea2 => 'Today\'s special with the price written clearly.';

  @override
  String get growthIdea3 => 'A happy regular holding their usual order.';

  @override
  String get growthIdea4 => 'Behind the counter: how the shop opens each day.';

  @override
  String get growthIdea5 =>
      'An offer for the weekend, valid for two days only.';

  @override
  String get growthSaved => 'Saved';

  @override
  String get checklistTitle => 'Opening & closing list';

  @override
  String get checklistSubtitle =>
      'The small things that spoil a day when forgotten';

  @override
  String get checklistOpening => 'Before opening';

  @override
  String get checklistClosing => 'Before closing';

  @override
  String get checklistAdd => 'Add to the list';

  @override
  String get checklistItem => 'What to check';

  @override
  String get checklistEmpty => 'Nothing on the list yet.';

  @override
  String get checklistUseStarter => 'Use a starter list';

  @override
  String get checklistSeed1 => 'Change money kept ready';

  @override
  String get checklistSeed2 => 'Gas and milk checked';

  @override
  String get checklistSeed3 => 'QR stand and price board out';

  @override
  String get checklistSeed4 => 'Cash counted and written down';

  @override
  String get checklistSeed5 => 'Fridge, gas and lights switched off';

  @override
  String jobRemindMessage(String name, String title) {
    return 'Hello $name, your order \"$title\" is ready.';
  }

  @override
  String customerVisits(String count) {
    return '$count visits';
  }

  @override
  String customerToReward(String count) {
    return '$count more visits';
  }

  @override
  String growthReviewMessage(String name, String link) {
    return 'Liked $name? Please leave a review: $link';
  }

  @override
  String growthBroadcastMessage(String name, String link) {
    return '$name — today\'s menu: $link';
  }

  @override
  String checklistProgress(String done, String total) {
    return '$done of $total done';
  }

  @override
  String get movementPrepared => 'Prep';

  @override
  String recipeShortStock(String item) {
    return 'Not enough $item in stock';
  }

  @override
  String get starterIdli => 'Idli';

  @override
  String get starterDosa => 'Dosa';

  @override
  String get starterMeals => 'Meals';

  @override
  String get starterSnackPacket => 'Snack packet';

  @override
  String get starterWaterBottle => 'Water bottle';

  @override
  String get starterVegSupply => 'Vegetables';

  @override
  String get starterGasSupply => 'Gas cylinder';

  @override
  String get checklistSeedHotel => 'Batter, vegetables and gas ready';

  @override
  String get checklistSeedCart => 'Cart cleaned and stock loaded';

  @override
  String get checklistSeedService => 'Tools and change ready';

  @override
  String get presetRecipeTea => 'Shop tea (10 cups)';

  @override
  String get presetIngredientMilk => 'Milk';

  @override
  String get presetIngredientWater => 'Water';

  @override
  String get presetIngredientTeaPowder => 'Tea powder';

  @override
  String get presetIngredientSugar => 'Sugar';

  @override
  String get rolesTitle => 'Roles';

  @override
  String get rolesSubtitle => 'Who can do what';

  @override
  String get rolesHint =>
      'Make a role for each kind of helper, then tick only the work they should be allowed to do.';

  @override
  String get rolesEmpty => 'No roles yet';

  @override
  String get rolesOpen => 'Open roles';

  @override
  String get roleNew => 'New role';

  @override
  String get roleSuggestionsTitle => 'Suggested for your shop';

  @override
  String get roleSuggestionsHint =>
      'Ready-made roles for your kind of business. Tap one to create it, then adjust.';

  @override
  String get tmplWaiter => 'Waiter';

  @override
  String get tmplKitchen => 'Kitchen / chef';

  @override
  String get tmplCashier => 'Cashier';

  @override
  String get tmplCounter => 'Counter';

  @override
  String get tmplSalesHelper => 'Sales helper';

  @override
  String get tmplStockKeeper => 'Stock keeper';

  @override
  String get tmplJobAssistant => 'Job assistant';

  @override
  String get tmplCounterHelper => 'Counter helper';

  @override
  String get tmplAssistant => 'Assistant';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleOwnerNote => 'Full access, always';

  @override
  String get roleInactive => 'Not in use';

  @override
  String rolePermissionCount(String count) {
    return '$count allowed';
  }

  @override
  String get roleEditSubtitle => 'Name, duties and limits';

  @override
  String get roleName => 'Role name';

  @override
  String get roleNote => 'Responsibility';

  @override
  String get roleLimits => 'Money limits (Rs, 0 = no limit)';

  @override
  String get roleMaxDiscount => 'Biggest discount allowed';

  @override
  String get roleMaxCredit => 'Biggest credit allowed';

  @override
  String get roleMaxRefund => 'Biggest refund allowed';

  @override
  String get roleLimitHint => 'Above these amounts the owner PIN is needed.';

  @override
  String get roleDuplicate => 'Copy role';

  @override
  String get roleDeactivate => 'Stop using';

  @override
  String get areaSales => 'Sales';

  @override
  String get areaOrders => 'Orders and kitchen';

  @override
  String get areaBilling => 'Bills';

  @override
  String get areaCredit => 'Credit';

  @override
  String get areaStock => 'Stock';

  @override
  String get areaPurchases => 'Buying and expenses';

  @override
  String get areaMoney => 'Money and reports';

  @override
  String get areaCustomers => 'Customers';

  @override
  String get areaStaff => 'Helpers';

  @override
  String get areaSettings => 'Setup';

  @override
  String get permRecordSale => 'Record a sale';

  @override
  String get permQuickSale => 'Use quick sale';

  @override
  String get permCollectUpi => 'Show payment QR';

  @override
  String get permTakeOrder => 'Take an order';

  @override
  String get permChangeOrderStatus => 'Move orders along';

  @override
  String get permViewKitchen => 'See kitchen list';

  @override
  String get permEditMenu => 'Change the menu';

  @override
  String get permMakeBill => 'Make a bill';

  @override
  String get permGiveDiscount => 'Give a discount';

  @override
  String get permVoidBill => 'Cancel a bill';

  @override
  String get permReprintBill => 'Print a bill again';

  @override
  String get permGiveCredit => 'Give credit';

  @override
  String get permSettleCredit => 'Settle credit';

  @override
  String get permViewCredit => 'See credit balances';

  @override
  String get permViewStock => 'See stock';

  @override
  String get permAdjustStock => 'Change stock';

  @override
  String get permEditProducts => 'Add or edit items';

  @override
  String get permChangePrice => 'Change prices';

  @override
  String get permCookRecipe => 'Cook a recipe';

  @override
  String get permRecordExpense => 'Record an expense';

  @override
  String get permManageSuppliers => 'Manage suppliers';

  @override
  String get permViewDayTotals => 'See day totals';

  @override
  String get permViewProfit => 'See profit';

  @override
  String get permCloseDay => 'Close the day';

  @override
  String get permViewReports => 'See reports';

  @override
  String get permViewCustomers => 'See customers';

  @override
  String get permEditCustomers => 'Edit customers';

  @override
  String get permManageStaff => 'Manage helpers';

  @override
  String get permMarkAttendance => 'Mark attendance';

  @override
  String get permPayWages => 'Pay wages';

  @override
  String get permManageRoles => 'Create roles';

  @override
  String get permViewAudit => 'See the activity trail';

  @override
  String get permEditSettings => 'Change settings';

  @override
  String get permEditShop => 'Change shop details';

  @override
  String get permManagePrinters => 'Set up printers';

  @override
  String get accessTitle => 'Access control';

  @override
  String get accessSubtitle => 'Shared phone, separate hands';

  @override
  String get accessEnable => 'Ask for a PIN';

  @override
  String get accessEnableHint =>
      'Each helper signs in before using this phone.';

  @override
  String get accessNeedsOwnerPin => 'Set your owner PIN first';

  @override
  String get accessOwnerPin => 'Owner PIN';

  @override
  String get accessOwnerPinSet => 'Set owner PIN (4-6 digits)';

  @override
  String get accessOwnerPinChange => 'Change owner PIN (4-6 digits)';

  @override
  String get accessPinSaved => 'PIN saved';

  @override
  String get accessPinInvalid => 'Use 4 to 6 digits';

  @override
  String get accessAutoLock => 'Auto lock';

  @override
  String get accessIdleMinutes => 'Lock after (minutes, 0 = never)';

  @override
  String get accessWorkers => 'Helpers';

  @override
  String get accessNoWorkers => 'Add helpers first';

  @override
  String get accessNoRole => 'No role yet';

  @override
  String get accessPinSet => 'PIN set';

  @override
  String get accessPinMissing => 'No PIN';

  @override
  String get accessAssignTitle => 'Role and PIN';

  @override
  String get accessWorkerPin => 'New PIN (4-6 digits)';

  @override
  String get accessSaved => 'Saved';

  @override
  String get accessEndShift => 'End shift';

  @override
  String get accessWrongPin => 'Wrong PIN';

  @override
  String get lockTitle => 'Who is on the counter?';

  @override
  String get lockSubtitle => 'Pick your name and type your PIN';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockUnlock => 'Start shift';

  @override
  String get auditTitle => 'Activity trail';

  @override
  String get auditSubtitle => 'Who did what';

  @override
  String get auditOpen => 'Open activity trail';

  @override
  String get auditEveryone => 'Everyone';

  @override
  String get auditEmpty => 'Nothing recorded yet';

  @override
  String get auditApproved => 'Owner approved';

  @override
  String get settingsGroupBusiness => 'Business';

  @override
  String get settingsGroupMoney => 'Money';

  @override
  String get settingsGroupApp => 'App & devices';

  @override
  String get settingsShopTitle => 'Shop details';

  @override
  String get settingsPaymentsTitle => 'Payments & UPI';

  @override
  String get settingsMarketTitle => 'Market prices';

  @override
  String get settingsNotSet => 'Not set';

  @override
  String get settingsOn => 'On';

  @override
  String get settingsOff => 'Off';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Orders, money, credit and stock at a glance';

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardPayments => 'Pending payments';

  @override
  String get dashboardCredit => 'Credit balances';

  @override
  String get dashboardInventory => 'Inventory';

  @override
  String get dashboardShare => 'Share';

  @override
  String get dashboardPlaced => 'Placed';

  @override
  String get dashboardServed => 'Served';

  @override
  String get dashboardCancelled => 'Cancelled';

  @override
  String get dashboardOpenOrders => 'Open orders';

  @override
  String get dashboardBilled => 'Billed';

  @override
  String get dashboardAvgBill => 'Average bill';

  @override
  String get dashboardCollected => 'Collected';

  @override
  String get dashboardUnbilled => 'Not billed yet';

  @override
  String get dashboardPendingTotal => 'Still to collect';

  @override
  String get dashboardOutstanding => 'Outstanding';

  @override
  String get dashboardCreditGiven => 'Credit given';

  @override
  String get dashboardCustomers => 'Customers';

  @override
  String get dashboardOldest => 'Oldest due';

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
  String get dashboardStockValue => 'Stock value';

  @override
  String get dashboardLowStock => 'Low stock';

  @override
  String get dashboardExpiring => 'Expiring soon';

  @override
  String get dashboardWastage => 'Wastage';

  @override
  String get dashboardPurchases => 'Purchases';

  @override
  String get dashboardTopItems => 'Top items';

  @override
  String get planTitle => 'Subscription';

  @override
  String get planSubtitle => 'Cloud features for this shop';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planFreeNote => 'Everything on this phone keeps working for free.';

  @override
  String get planProNote => 'Cloud features are active for this shop.';

  @override
  String get planCloudFeatures => 'Cloud features';

  @override
  String get planFeatureAccount => 'Cloud shop account';

  @override
  String get planFeatureLiveSync => 'Live order board sync';

  @override
  String get planFeatureQrOrdering => 'QR menu ordering';

  @override
  String get planFeatureShareLinks => 'Shareable links';

  @override
  String get planFeatureSoundbox => 'Cloud soundbox';

  @override
  String get planFeatureBackup => 'Multi-device backup';

  @override
  String get planOn => 'On';

  @override
  String get planLocked => 'Locked';

  @override
  String get planRefresh => 'Check subscription';

  @override
  String get planChecking => 'Checking…';

  @override
  String get planCheckFailed =>
      'Could not check right now. Last known status is used.';

  @override
  String get planNeedsShop => 'Set up the cloud shop first.';

  @override
  String get planOfflineNote =>
      'Offline for a few days is fine — cloud features keep working during the grace period.';

  @override
  String get shopTitle => 'My shop';

  @override
  String get shopSubtitle => 'Workflow made for your trade';

  @override
  String get shopPickType => 'Shop type';

  @override
  String get shopWorkflow => 'Daily workflow';

  @override
  String get shopTypeRestaurant => 'Restaurant';

  @override
  String get shopTypeHotel => 'Hotel';

  @override
  String get shopTypeStreet => 'Street stall';

  @override
  String get shopTypeDiy => 'DIY / craft stall';

  @override
  String get shopTypeMagnet => 'Fridge magnet stall';

  @override
  String get shopTypeTea => 'Tea shop';

  @override
  String get settingsOrderingTitle => 'Ordering rules';

  @override
  String get settingsOrderingSubtitle =>
      'Service style, payment timing, table buttons';

  @override
  String get serviceStyle => 'Service style';

  @override
  String get serviceTable => 'Table service';

  @override
  String get serviceSelf => 'Self service';

  @override
  String get serviceTakeaway => 'Takeaway only';

  @override
  String get paymentTiming => 'Payment timing';

  @override
  String get payBefore => 'Pay first';

  @override
  String get payAfter => 'Pay after';

  @override
  String get payTimingHelp =>
      'Pay first asks the customer to pay before the order is confirmed. Pay after sends it to the kitchen straight away.';

  @override
  String get customerButtons => 'Buttons on the customer screen';

  @override
  String get allowCallStaff => 'Call staff';

  @override
  String get allowRequestBill => 'Ask for the bill';

  @override
  String get customerButtonsHelp => 'These appear only with table service.';

  @override
  String get requestCallStaff => 'Staff needed';

  @override
  String get requestBill => 'Bill please';

  @override
  String requestTable(String table) {
    return 'Table $table';
  }

  @override
  String get requestCounter => 'Counter';

  @override
  String get requestSeen => 'Seen';

  @override
  String get payStateAwaiting => 'Awaiting payment';

  @override
  String get payStateDue => 'Pay at counter';

  @override
  String get payStatePaid => 'Paid';

  @override
  String get orderMarkPaid => 'Mark paid';

  @override
  String get devicesTitle => 'Phones & devices';

  @override
  String get devicesSubtitle =>
      'Waiter, kitchen and counter phones on one board';

  @override
  String get devicesPairThis => 'Pair this phone';

  @override
  String get devicesShopSlug => 'Shop name (menu link word)';

  @override
  String get devicesEnterCode => '6-digit code from the owner';

  @override
  String get devicesLabel => 'Phone name';

  @override
  String get devicesPairButton => 'Pair phone';

  @override
  String get devicesPairSuccess => 'Phone paired to the shop';

  @override
  String get devicesUnpair => 'Unpair this phone';

  @override
  String devicesPairedAs(String role, String shop) {
    return 'Paired as $role · $shop';
  }

  @override
  String get devicesNewCode => 'New pairing code';

  @override
  String get devicesCodeExpires => 'Valid for 15 minutes · tap to copy';

  @override
  String get devicesList => 'Paired phones';

  @override
  String get devicesEmpty => 'No phones paired yet';

  @override
  String get devicesRevoke => 'Remove';

  @override
  String get devicesRevoked => 'Removed';

  @override
  String get devicesOnline => 'online';

  @override
  String get devicesOffline => 'offline';

  @override
  String get devicesRoleWaiter => 'Waiter';

  @override
  String get devicesRoleKitchen => 'Kitchen';

  @override
  String get devicesRoleCounter => 'Counter';

  @override
  String get devicesProRequired =>
      'Multi-device sync is a Pro feature. Upgrade to connect waiter, kitchen and counter phones.';

  @override
  String get cloudShopSection => 'Cloud shop';

  @override
  String get cloudShopHint =>
      'Create your shop on the server so QR menu orders and staff phones share one live order list.';

  @override
  String get cloudShopSlug => 'Shop name for links (e.g. sirpam-tea)';

  @override
  String get cloudShopKey => 'Shop key (private, 16+ characters)';

  @override
  String get cloudShopGenerate => 'Generate key';

  @override
  String get cloudShopCreate => 'Create cloud shop';

  @override
  String get cloudShopUpdate => 'Update cloud shop';

  @override
  String cloudShopLive(String slug) {
    return 'Cloud shop ready: $slug';
  }

  @override
  String get cloudShopNone =>
      'No cloud shop yet. Create one to use QR ordering and staff phones.';

  @override
  String get cloudShopCreated => 'Cloud shop created';

  @override
  String get cloudShopKeyShort =>
      'Enter a shop name and a key of at least 16 characters.';

  @override
  String get cloudShopCopyKey => 'Copy key';

  @override
  String get cloudShopKeyCopied => 'Shop key copied';

  @override
  String get approvalTitle => 'Owner approval';

  @override
  String approvalNeeded(String action) {
    return 'This shift cannot do this: $action. The owner can allow it once.';
  }

  @override
  String approvalOverLimit(String action) {
    return 'This is above the limit for this shift: $action. The owner can allow it once.';
  }

  @override
  String get approvalOwnerPin => 'Owner PIN';

  @override
  String get approvalApprove => 'Allow once';

  @override
  String get approvalGranted => 'Owner approved this action';

  @override
  String get approvalWrongPin => 'Wrong owner PIN';

  @override
  String get approvalBlockedTitle => 'Not allowed';

  @override
  String approvalBlockedBody(String action) {
    return 'This shift does not have access to $action. Ask the owner to change the role.';
  }

  @override
  String get recurringRemove => 'Remove';

  @override
  String get recurringRemoved => 'Recurring cost removed';

  @override
  String recurringRemoveConfirm(String name) {
    return 'Remove $name from recurring costs?';
  }

  @override
  String get orderEditItems => 'Edit items';

  @override
  String get orderEditItemsSaved => 'Order items updated';

  @override
  String get orderEditEmpty => 'An order needs at least one item.';

  @override
  String get printerStatus => 'Printer status';

  @override
  String get printerNotConnected => 'No printer connected';

  @override
  String printerConnectedTo(String name) {
    return 'Connected to $name';
  }

  @override
  String get printerDisconnect => 'Disconnect';

  @override
  String get printerDisconnected => 'Printer disconnected';

  @override
  String get printerForget => 'Forget printer';

  @override
  String get printerForgotten =>
      'Printer removed. Bills will be shared as PDF.';

  @override
  String get printerUnsupported => 'This phone cannot print over Bluetooth.';

  @override
  String get printerPermissionNeeded =>
      'Allow Bluetooth so the app can see your printer.';

  @override
  String get printerPermissionDenied => 'Bluetooth permission was not given.';

  @override
  String get printerAllowBluetooth => 'Allow Bluetooth';

  @override
  String get devicesTest => 'Test connection';

  @override
  String get devicesTestOk => 'Connected to the shop';

  @override
  String get devicesTestFailed =>
      'This phone is not connected. Ask the owner for a new code.';

  @override
  String stockLastUpdated(String when) {
    return 'Stock last updated $when';
  }

  @override
  String get agoJustNow => 'just now';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get prepTitle => 'Morning prep';

  @override
  String get prepSubtitle => 'What must be ready before the first customer';

  @override
  String prepPending(String count) {
    return '$count still to prepare';
  }

  @override
  String get prepUseStarter => 'Use a starter sheet';

  @override
  String get prepTodaySheet => 'Today\'s sheet';

  @override
  String get prepAddTitle => 'Add a prep item';

  @override
  String get prepItemName => 'Item';

  @override
  String get prepPlanned => 'Planned';

  @override
  String get prepMade => 'Made';

  @override
  String get prepUnit => 'Unit';

  @override
  String get prepAdd => 'Add to sheet';

  @override
  String prepShort(String qty) {
    return '$qty short';
  }

  @override
  String prepProgressLine(String made, String planned, String unit) {
    return '$made of $planned $unit';
  }

  @override
  String get prepSeedMilk => 'Milk';

  @override
  String get prepSeedBatter => 'Batter / dough';

  @override
  String get prepSeedSnacks => 'Snacks';

  @override
  String get prepSeedChange => 'Change money';

  @override
  String get prepSeedDisplay => 'Set up display';

  @override
  String get prepSeedStock => 'Fill shelves';

  @override
  String get prepUnitLitre => 'litre';

  @override
  String get prepUnitPlate => 'plate';

  @override
  String get prepUnitPiece => 'piece';

  @override
  String get prepUnitRupee => 'rupee';

  @override
  String get insightsRush => 'Rush hours';

  @override
  String insightsHour(String hour) {
    return '$hour:00';
  }

  @override
  String insightsPeakHint(String hour, String bills, String staff) {
    return 'Busiest at $hour:00 with $bills bills — keep $staff at the counter';
  }

  @override
  String get dayCloseOpeningCash => 'Opening cash';

  @override
  String quickSaleSoldOutOn(String item) {
    return '$item marked sold out';
  }

  @override
  String quickSaleSoldOutOff(String item) {
    return '$item is back on sale';
  }

  @override
  String get insightsHeroes => 'Today\'s heroes';

  @override
  String insightsHeroLine(String sold, String left) {
    return '$sold sold · $left left';
  }

  @override
  String insightsHeroRunsOut(String hour) {
    return 'runs out around $hour:00';
  }

  @override
  String get customerLapsedTitle => 'Not seen lately';

  @override
  String get customerLapsedHint => 'A short message brings most of them back.';

  @override
  String customerLapsedDays(String days) {
    return '$days days since last visit';
  }

  @override
  String get customerNudge => 'Send message';

  @override
  String customerNudgeMessage(String name, String shop) {
    return 'Hi $name, we miss you at $shop! Something fresh is waiting for you this week.';
  }

  @override
  String get offersTitle => 'Offers';

  @override
  String get offersSubtitle =>
      'Discounts you run, and what each one costs you.';

  @override
  String get offerAdd => 'Add an offer';

  @override
  String get offerName => 'Offer name';

  @override
  String get offerCode => 'Code the customer says (optional)';

  @override
  String get offerKindFlat => 'Rupees off';

  @override
  String get offerKindPercent => 'Percent off';

  @override
  String get offerKindCombo => 'Combo price';

  @override
  String get offerAmount => 'Amount off';

  @override
  String get offerPercent => 'Percent off';

  @override
  String get offerComboPrice => 'Combo price';

  @override
  String get offersGivenTotal => 'Given away so far';

  @override
  String get offersEmpty =>
      'No offers yet. Add one and it shows up on the bill.';

  @override
  String get offerLive => 'Live';

  @override
  String get offerPaused => 'Paused';

  @override
  String get offerPause => 'Pause';

  @override
  String get offerResume => 'Resume';

  @override
  String offerUsed(String count) {
    return 'Used $count times';
  }

  @override
  String offerGivenAway(String amount) {
    return '$amount given away';
  }

  @override
  String get feedbackTitle => 'Bill feedback';

  @override
  String get feedbackSubtitle =>
      'A three-tap rating after paying, straight to you.';

  @override
  String get feedbackQrTitle => 'Counter QR';

  @override
  String get feedbackQrHint =>
      'Print this and keep it on the counter, or show it after payment.';

  @override
  String get feedbackReviewMissing =>
      'Add your review page link in Growth so happy customers can post it publicly.';

  @override
  String get feedbackLinkCopied => 'Link copied';

  @override
  String get feedbackScores => 'Scores';

  @override
  String get feedbackTodayAvg => 'Today (average · count)';

  @override
  String get feedbackWeekAvg => 'Last 7 days (average · count)';

  @override
  String get feedbackNeedsReply => 'Needs a reply';

  @override
  String get feedbackRecord => 'Add a rating yourself';

  @override
  String get feedbackHappy => 'Good';

  @override
  String get feedbackOkay => 'Okay';

  @override
  String get feedbackUnhappy => 'Not good';

  @override
  String get feedbackRecent => 'Recent ratings';

  @override
  String get feedbackEmpty => 'No ratings yet.';

  @override
  String get enquiriesTitle => 'Enquiries';

  @override
  String get enquiriesSubtitle =>
      'Who asked, what you quoted, and what came of it.';

  @override
  String get enquiryAdd => 'Add an enquiry';

  @override
  String get enquiryName => 'Customer name';

  @override
  String get enquiryPhone => 'Phone';

  @override
  String get enquiryWant => 'What they asked for';

  @override
  String get enquiryQuote => 'Price you quoted';

  @override
  String get enquiryNoFollowUp => 'No reminder';

  @override
  String enquiryFollowUpDays(String days) {
    return 'Follow up in $days days';
  }

  @override
  String enquiryWinRate(String rate) {
    return '$rate% turn into sales';
  }

  @override
  String get enquiryWonValue => 'Value won';

  @override
  String get enquiryFilterToday => 'Today';

  @override
  String get enquiryFilterOpen => 'Open';

  @override
  String get enquiryFilterWon => 'Won';

  @override
  String get enquiryFilterLost => 'Lost';

  @override
  String get enquiryEmpty => 'Nothing here.';

  @override
  String enquiryFollowUpOn(String day) {
    return 'Follow up on $day';
  }

  @override
  String get enquiryMessage => 'Message';

  @override
  String enquiryMessageText(String name, String item) {
    return 'Hi $name, following up about $item. Shall I keep it ready for you?';
  }

  @override
  String get enquiryWon => 'Won';

  @override
  String get enquiryLost => 'Lost';

  @override
  String get enquiryReopen => 'Reopen';

  @override
  String get customerRewardsDueTitle => 'Rewards due';

  @override
  String cloudShopSlugTaken(String slug) {
    return 'That link name is already taken. Try something like $slug.';
  }

  @override
  String get cloudShopSlugInvalid =>
      'Use small letters, numbers and dashes only, at least 3 characters.';

  @override
  String get cloudShopOffline =>
      'No internet just now. Check the connection and try again.';

  @override
  String get cloudShopTryAgain =>
      'That did not go through. Please try again in a moment.';

  @override
  String get cloudShopLinkTitle => 'Customer link';

  @override
  String get cloudShopCopyLink => 'Copy link';

  @override
  String get cloudShopLinkCopied => 'Link copied';

  @override
  String get cloudShopShowQr => 'Show QR';

  @override
  String get paymentQrScanTitle => 'Use your payment app QR';

  @override
  String get paymentQrScanAction => 'Scan my QR';

  @override
  String get paymentQrScanHelp =>
      'Point the camera at the QR sticker from GPay, PhonePe or Paytm. We read the UPI ID from it, so bills and the counter QR pay into the same account.';

  @override
  String paymentQrScanFound(String vpa) {
    return 'UPI ID taken from your QR: $vpa';
  }

  @override
  String get paymentQrScanNoUpi =>
      'That is not a payment QR. Try the QR shown inside your payment app.';

  @override
  String get receiptFeedbackLine => 'Scan to tell us how it was';

  @override
  String get qrPrintCounterCard => 'Print counter card';

  @override
  String get qrPayCaption => 'Scan to pay';

  @override
  String get qrFeedbackCaption => 'Scan to rate us';

  @override
  String get offerPrintCards => 'Print offer cards';

  @override
  String get offerCardCaption => 'Scan to open this offer';

  @override
  String get devicesPairQrHint => 'Let the new phone scan this';

  @override
  String get devicesScanQr => 'Scan pairing QR';

  @override
  String get devicesScanInvalid =>
      'That is not a pairing QR. Ask the owner to show it again.';

  @override
  String get quickSaleScan => 'Scan item';

  @override
  String get quickSaleScanTitle => 'Scan the item label';

  @override
  String quickSaleScanUnknown(String code) {
    return 'No item found for code $code. Add it in Products.';
  }

  @override
  String get backupTitle => 'Backup & export';

  @override
  String get backupSubtitle => 'Keep a copy of your books safe';

  @override
  String get backupNowAction => 'Back up now';

  @override
  String get backupRestoreAction => 'Restore from file';

  @override
  String get backupShareSubject => 'VendorOS backup';

  @override
  String get backupSavedToast => 'Backup file created';

  @override
  String get backupFailedToast =>
      'Could not create the backup. Please try again.';

  @override
  String get backupRestoredToast => 'Your books have been restored';

  @override
  String get backupNeverSaved => 'You have never backed up';

  @override
  String backupLastSaved(String when) {
    return 'Last backup: $when';
  }

  @override
  String backupSizeHint(int kb) {
    return 'About $kb KB will be saved';
  }

  @override
  String get backupRestoreWarning =>
      'Restoring replaces everything on this phone with the file.';

  @override
  String get backupRestoreConfirmTitle => 'Restore this backup?';

  @override
  String backupRestoreConfirmBody(int rows, String when) {
    return '$rows entries from $when will replace what is on this phone.';
  }

  @override
  String get backupErrorNotFile => 'This is not a VendorOS backup file.';

  @override
  String get backupErrorTooNew =>
      'This backup is from a newer version. Please update the app first.';

  @override
  String get backupErrorCorrupt =>
      'This backup file is damaged and cannot be used.';

  @override
  String get backupErrorEmpty => 'The file is empty.';

  @override
  String get exportGroupLabel => 'Export as spreadsheet';

  @override
  String get exportSalesTitle => 'Sales';

  @override
  String get exportSalesSubtitle => 'Every sale with date, item and amount';

  @override
  String get exportBillsTitle => 'Bills';

  @override
  String get exportBillsSubtitle => 'Bill-wise totals, discount and tax';

  @override
  String get exportCreditTitle => 'Credit balances';

  @override
  String get exportCreditSubtitle => 'Who still owes you and how much';

  @override
  String get exportStockTitle => 'Stock';

  @override
  String get exportStockSubtitle => 'Items, quantity on hand and prices';

  @override
  String get exportColDate => 'Date';

  @override
  String get exportColItem => 'Item';

  @override
  String get exportColMode => 'Payment';

  @override
  String get exportColCustomer => 'Customer';

  @override
  String get exportColAmount => 'Amount';

  @override
  String get exportColBillNo => 'Bill no';

  @override
  String get exportColSubtotal => 'Subtotal';

  @override
  String get exportColDiscount => 'Discount';

  @override
  String get exportColTax => 'Tax';

  @override
  String get exportColTotal => 'Total';

  @override
  String get exportColPayment => 'Paid by';

  @override
  String get exportColStatus => 'Status';

  @override
  String get exportColBalance => 'Balance';

  @override
  String get exportColCode => 'Code';

  @override
  String get exportColCategory => 'Category';

  @override
  String get exportColUnit => 'Unit';

  @override
  String get exportColQty => 'Quantity';

  @override
  String get exportColCost => 'Cost';

  @override
  String get exportColPrice => 'Price';

  @override
  String get gstReportTitle => 'GST summary';

  @override
  String get gstReportSubtitle => 'Month-wise tax for your accountant';

  @override
  String get gstReportEmpty =>
      'No GST bills yet. Turn on GST in Menu settings, then bill an item.';

  @override
  String get gstColMonth => 'Month';

  @override
  String get gstColRate => 'Rate';

  @override
  String get gstColTaxable => 'Taxable value';

  @override
  String get gstColTax => 'Total tax';

  @override
  String get gstBills => 'Bills';

  @override
  String get gstSales => 'Sales with tax';

  @override
  String get gstByRate => 'By rate';

  @override
  String get gstShareAction => 'Share spreadsheet';

  @override
  String gstShareSubject(String month) {
    return 'GST summary $month';
  }

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceSubtitle => 'Light or dark screen';

  @override
  String get appearanceSystem => 'Match phone';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceChanged => 'Appearance updated';

  @override
  String get purchasesTitle => 'Purchases';

  @override
  String get purchasesSubtitle => 'Supplier bills and what you still owe';

  @override
  String get purchasesEmpty =>
      'No purchase bills yet. Add the last stock you bought.';

  @override
  String get purchaseAdd => 'Add purchase';

  @override
  String get purchaseTotalDue => 'Owed to suppliers';

  @override
  String get purchaseMonthSpend => 'Bought this month';

  @override
  String get purchaseDuesTitle => 'Supplier dues';

  @override
  String get purchaseNoDues => 'All supplier bills are paid.';

  @override
  String purchaseDueBills(int bills, int days) {
    return '$bills bill(s) · oldest $days day(s)';
  }

  @override
  String get purchaseBillsTitle => 'Purchase bills';

  @override
  String get purchasePaidFull => 'Paid';

  @override
  String purchaseDueOf(String amount) {
    return '$amount due';
  }

  @override
  String get purchaseSupplier => 'Supplier';

  @override
  String purchasePayTitle(String name) {
    return 'Pay $name';
  }

  @override
  String get purchasePayAmount => 'Amount paid';

  @override
  String get purchasePay => 'Record payment';

  @override
  String get purchaseSubtotal => 'Item total';

  @override
  String get purchaseTax => 'Tax';

  @override
  String get purchaseTotal => 'Bill total';

  @override
  String get purchaseDue => 'Still due';

  @override
  String get purchaseNewTitle => 'New purchase bill';

  @override
  String get purchaseInvoiceNo => 'Bill number';

  @override
  String get purchaseItems => 'Items bought';

  @override
  String get purchaseLinkProduct => 'Pick from your stock list';

  @override
  String get purchaseFreeItem => 'Item name';

  @override
  String get purchaseQty => 'Quantity';

  @override
  String get purchaseUnitCost => 'Cost per unit';

  @override
  String get purchaseAddLine => 'Add item';

  @override
  String get purchasePaidNow => 'Paid now';

  @override
  String get purchaseNote => 'Note';

  @override
  String get purchaseSaved => 'Purchase saved and stock updated';

  @override
  String get permRecordPurchase => 'Record purchase bills';

  @override
  String get permPaySupplier => 'Pay suppliers';

  @override
  String get backupCloudTitle => 'Online backup';

  @override
  String backupCloudLast(String when) {
    return 'Last online backup: $when';
  }

  @override
  String get backupCloudNever => 'Not saved online yet';

  @override
  String get backupCloudNeedsShop => 'Create a cloud shop first';

  @override
  String get backupCloudNowAction => 'Back up online now';

  @override
  String get backupCloudRestoreAction => 'Restore from online';

  @override
  String get backupCloudSavedToast => 'Saved online';

  @override
  String get backupCloudFailedToast =>
      'Could not save online. Try again when you have signal.';

  @override
  String get billWhatsapp => 'Send on WhatsApp';

  @override
  String get billWhatsappFailed => 'WhatsApp is not installed on this phone.';

  @override
  String get devicesStaffRole => 'Staff role';

  @override
  String get devicesRoleDefault => 'Default (job only)';

  @override
  String get devicesRolePick => 'Choose a staff role';

  @override
  String get devicesRoleSaved => 'Role sent to that phone';

  @override
  String get devicesRoleFailed =>
      'Could not set the role. Try again when online.';

  @override
  String get adminTitle => 'Owner reports';

  @override
  String get adminSubtitle =>
      'What happened, who did it, and whether the cash matched';

  @override
  String get adminExceptionsTitle => 'Exceptions';

  @override
  String get adminExceptionsSubtitle =>
      'Discounts, cancelled bills, reprints and credit';

  @override
  String get adminStaffTitle => 'Staff report';

  @override
  String get adminStaffSubtitle => 'What each person did in this period';

  @override
  String get adminCashTitle => 'Cash book';

  @override
  String get adminCashSubtitle => 'Expected against counted, day by day';

  @override
  String get adminItemsTitle => 'Item gaps';

  @override
  String get adminItemsSubtitle => 'Sold against stock taken out';

  @override
  String get adminShopsTitle => 'All shops';

  @override
  String get adminShopsSubtitle => 'Totals from every shop you run';

  @override
  String get adminSummaryTitle => 'Today\'s summary';

  @override
  String get adminSummarySend => 'Send the summary';

  @override
  String get adminShare => 'Share';

  @override
  String get adminNoRows => 'Nothing to show for this period';

  @override
  String get adminFromBill => 'From the bill';

  @override
  String get adminOwnerApproved => 'Owner approved';

  @override
  String get adminColActions => 'Actions';

  @override
  String get adminColDiscount => 'Discount given';

  @override
  String get adminColCredit => 'Credit given';

  @override
  String get adminColVoids => 'Bills cancelled';

  @override
  String get adminColReprints => 'Reprints';

  @override
  String get adminColOverrides => 'Owner approvals';

  @override
  String get adminSeeExceptions => 'See their exceptions';

  @override
  String get adminCashOpening => 'Opening cash';

  @override
  String get adminCashExpected => 'Expected';

  @override
  String get adminCashCounted => 'Counted';

  @override
  String get adminCashShort => 'Short';

  @override
  String get adminCashOver => 'Extra';

  @override
  String get adminCashNet => 'Net difference';

  @override
  String get adminCashMatched => 'Days matched';

  @override
  String get adminCashMatchedOne => 'Matched';

  @override
  String get adminCashShortDays => 'Short days';

  @override
  String get adminItemSold => 'Sold';

  @override
  String get adminItemStockOut => 'Stock taken out';

  @override
  String get adminItemGap => 'Gap';

  @override
  String get adminItemWasted => 'Wasted';

  @override
  String get adminSummaryBills => 'Bills';

  @override
  String get adminSummarySales => 'Sales';

  @override
  String get adminSummaryCash => 'Cash';

  @override
  String get adminSummaryUpi => 'UPI';

  @override
  String get adminSummaryCredit => 'Credit';

  @override
  String get adminSummaryDiscount => 'Discounts';

  @override
  String get adminSummarySpend => 'Spend';

  @override
  String get adminSummaryCashDiff => 'Cash difference';

  @override
  String get adminSummaryTop => 'Top items';

  @override
  String get adminShopsAllTotal => 'All shops together';

  @override
  String get adminShopsOrders => 'Orders (7 days)';

  @override
  String get adminShopsValue => 'Value (7 days)';

  @override
  String get adminShopsAdd => 'Add another shop';

  @override
  String get adminShopsAddHelp =>
      'Type the other shop\'s link name and its owner key.';

  @override
  String get adminShopsAddAction => 'Add shop';

  @override
  String get adminShopsSlug => 'Shop link name';

  @override
  String get adminShopsKey => 'Owner key';

  @override
  String get adminShopsRemove => 'Remove';

  @override
  String get adminShopsRefresh => 'Refresh';

  @override
  String get adminShopsError => 'Could not read this shop';

  @override
  String get adminShopsInvalid => 'Check the link name and the owner key';

  @override
  String get adminShopsExists => 'That shop is already on the list';

  @override
  String get permViewCashBook => 'See the cash book';

  @override
  String get permExportData => 'Export data';

  @override
  String get permViewStaffReport => 'See staff reports';
}
