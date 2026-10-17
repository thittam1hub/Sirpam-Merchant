import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @udhaarReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, your outstanding balance at {stall} is Rs {amount}. Please pay. Thank you.{link}'**
  String udhaarReminderMessage(
      String name, String stall, String amount, String link);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VendorOS'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get navUdhaar;

  /// No description provided for @navSoundbox.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get navSoundbox;

  /// No description provided for @navMandi.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMandi;

  /// No description provided for @navSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get navSales;

  /// No description provided for @navGroupOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navGroupOverview;

  /// No description provided for @navGroupSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get navGroupSell;

  /// No description provided for @navGroupOperations.
  ///
  /// In en, this message translates to:
  /// **'Customers & operations'**
  String get navGroupOperations;

  /// No description provided for @navGroupBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get navGroupBusiness;

  /// No description provided for @navGroupTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get navGroupTeam;

  /// No description provided for @navGroupSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get navGroupSystem;

  /// No description provided for @moreLabel.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreLabel;

  /// No description provided for @menuLoanReport.
  ///
  /// In en, this message translates to:
  /// **'Loan report'**
  String get menuLoanReport;

  /// No description provided for @menuCartLocation.
  ///
  /// In en, this message translates to:
  /// **'Cart location'**
  String get menuCartLocation;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get goHome;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @storageWriteFailedKey.
  ///
  /// In en, this message translates to:
  /// **'Could not save ({key}) — please try again'**
  String storageWriteFailedKey(String key);

  /// No description provided for @storageWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save — please try again'**
  String get storageWriteFailed;

  /// No description provided for @micUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Microphone unavailable — please enter manually'**
  String get micUnavailable;

  /// No description provided for @voiceNothingHeard.
  ///
  /// In en, this message translates to:
  /// **'Nothing heard — please speak again'**
  String get voiceNothingHeard;

  /// No description provided for @voiceNoAmount.
  ///
  /// In en, this message translates to:
  /// **'No amount heard — say \"50 rupees tomato\"'**
  String get voiceNoAmount;

  /// No description provided for @voiceZeroAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be zero'**
  String get voiceZeroAmount;

  /// No description provided for @modeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get modeCash;

  /// No description provided for @modeUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get modeUpi;

  /// No description provided for @modeCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get modeCredit;

  /// No description provided for @saleRecorded.
  ///
  /// In en, this message translates to:
  /// **'{mode} ₹{amount} recorded'**
  String saleRecorded(String mode, String amount);

  /// No description provided for @todayTotalSemantic.
  ///
  /// In en, this message translates to:
  /// **'Today\'s total business {amount} rupees'**
  String todayTotalSemantic(String amount);

  /// No description provided for @todayCollection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s collection'**
  String get todayCollection;

  /// No description provided for @quickEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick entry'**
  String get quickEntry;

  /// No description provided for @todayEntries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entries'**
  String get todayEntries;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet — press the mic and speak'**
  String get noEntriesYet;

  /// No description provided for @listeningTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Listening, tap to stop'**
  String get listeningTapToStop;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak to record'**
  String get tapToSpeak;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @speakToRecord.
  ///
  /// In en, this message translates to:
  /// **'🎙️ Speak to record'**
  String get speakToRecord;

  /// No description provided for @voiceHint.
  ///
  /// In en, this message translates to:
  /// **'\"50 rupees tomato cash\" / \"ravi ku 200 credit\"'**
  String get voiceHint;

  /// No description provided for @addSale.
  ///
  /// In en, this message translates to:
  /// **'Add sale'**
  String get addSale;

  /// No description provided for @saleSemantic.
  ///
  /// In en, this message translates to:
  /// **'{label} {amount} rupees, {item}'**
  String saleSemantic(String label, String amount, String item);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location service is turned off'**
  String get locationServiceOff;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @broadcastLive.
  ///
  /// In en, this message translates to:
  /// **'Broadcasting live'**
  String get broadcastLive;

  /// No description provided for @locationSearching.
  ///
  /// In en, this message translates to:
  /// **'Finding location…'**
  String get locationSearching;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @broadcastStopped.
  ///
  /// In en, this message translates to:
  /// **'Broadcast stopped'**
  String get broadcastStopped;

  /// No description provided for @locationNotFetched.
  ///
  /// In en, this message translates to:
  /// **'Location not fetched yet'**
  String get locationNotFetched;

  /// No description provided for @stopBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Stop broadcast'**
  String get stopBroadcast;

  /// No description provided for @startBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Start broadcast'**
  String get startBroadcast;

  /// No description provided for @sendToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Send to customers'**
  String get sendToCustomer;

  /// No description provided for @shareLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Share today\'s cart spot over WhatsApp.'**
  String get shareLocationHint;

  /// No description provided for @ourCart.
  ///
  /// In en, this message translates to:
  /// **'Our cart'**
  String get ourCart;

  /// No description provided for @cartLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'{stall} is here today 👇\n{url}'**
  String cartLocationMessage(String stall, String url);

  /// No description provided for @shareOnWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsapp;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @mandiKeyRejected.
  ///
  /// In en, this message translates to:
  /// **'data.gov.in rejected the request — check the API key ({status})'**
  String mandiKeyRejected(String status);

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailed(String error);

  /// No description provided for @mandiTitle.
  ///
  /// In en, this message translates to:
  /// **'Market prices'**
  String get mandiTitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @mandiLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading market prices'**
  String get mandiLoading;

  /// No description provided for @fetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch data'**
  String get fetchFailed;

  /// No description provided for @apiKeyNeeded.
  ///
  /// In en, this message translates to:
  /// **'data.gov.in API key required'**
  String get apiKeyNeeded;

  /// No description provided for @apiKeyNeededBody.
  ///
  /// In en, this message translates to:
  /// **'Get a free data.gov.in API key for live APMC prices and add it in Settings. No mock prices are shown.'**
  String get apiKeyNeededBody;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Latest refresh failed'**
  String get refreshFailed;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdated(String time);

  /// No description provided for @searchVegetable.
  ///
  /// In en, this message translates to:
  /// **'Search vegetable'**
  String get searchVegetable;

  /// No description provided for @loanReportHeading.
  ///
  /// In en, this message translates to:
  /// **'Business loan report'**
  String get loanReportHeading;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Report failed: {error}'**
  String reportFailed(String error);

  /// No description provided for @daysWindow.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String daysWindow(num days);

  /// No description provided for @totalBusiness.
  ///
  /// In en, this message translates to:
  /// **'Total business'**
  String get totalBusiness;

  /// No description provided for @digitalShare.
  ///
  /// In en, this message translates to:
  /// **'Digital share'**
  String get digitalShare;

  /// No description provided for @avgDailyIncome.
  ///
  /// In en, this message translates to:
  /// **'Average daily income'**
  String get avgDailyIncome;

  /// No description provided for @recordedDays.
  ///
  /// In en, this message translates to:
  /// **'Recorded days'**
  String get recordedDays;

  /// No description provided for @sha256Checksum.
  ///
  /// In en, this message translates to:
  /// **'SHA-256 checksum'**
  String get sha256Checksum;

  /// No description provided for @noSalesYet.
  ///
  /// In en, this message translates to:
  /// **'No sales recorded yet — record sales first to generate a report.'**
  String get noSalesYet;

  /// No description provided for @viewPdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdf;

  /// No description provided for @sendToBank.
  ///
  /// In en, this message translates to:
  /// **'Send to bank'**
  String get sendToBank;

  /// No description provided for @stallName.
  ///
  /// In en, this message translates to:
  /// **'Stall name'**
  String get stallName;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerName;

  /// No description provided for @upiVpaLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI VPA (e.g. name@okaxis)'**
  String get upiVpaLabel;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @mandiMarket.
  ///
  /// In en, this message translates to:
  /// **'Market (APMC)'**
  String get mandiMarket;

  /// No description provided for @mandiApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'data.gov.in API key'**
  String get mandiApiKeyLabel;

  /// No description provided for @apiKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Register free at data.gov.in to get a key. Without a key live prices are not shown.'**
  String get apiKeyHelp;

  /// No description provided for @soundboxAnnounce.
  ///
  /// In en, this message translates to:
  /// **'Soundbox announcements'**
  String get soundboxAnnounce;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @soundboxSpeech.
  ///
  /// In en, this message translates to:
  /// **'Rupees {amount} received'**
  String soundboxSpeech(String amount);

  /// No description provided for @soundboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Soundbox'**
  String get soundboxTitle;

  /// No description provided for @soundboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'UPI payments announced in your language'**
  String get soundboxSubtitle;

  /// No description provided for @watchedApps.
  ///
  /// In en, this message translates to:
  /// **'Watched apps'**
  String get watchedApps;

  /// No description provided for @soundboxTestHint.
  ///
  /// In en, this message translates to:
  /// **'Test: \"Rupees 250 received\" will be spoken'**
  String get soundboxTestHint;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @announcedPayments.
  ///
  /// In en, this message translates to:
  /// **'Announced payments'**
  String get announcedPayments;

  /// No description provided for @noUpiYet.
  ///
  /// In en, this message translates to:
  /// **'No UPI payments received yet'**
  String get noUpiYet;

  /// No description provided for @soundboxRunning.
  ///
  /// In en, this message translates to:
  /// **'Soundbox is running'**
  String get soundboxRunning;

  /// No description provided for @notificationAccessNeeded.
  ///
  /// In en, this message translates to:
  /// **'Notification access required'**
  String get notificationAccessNeeded;

  /// No description provided for @soundboxAndroidHint.
  ///
  /// In en, this message translates to:
  /// **'Payments via PhonePe, Paytm, Google Pay and BHIM are announced automatically.'**
  String get soundboxAndroidHint;

  /// No description provided for @soundboxGrantHint.
  ///
  /// In en, this message translates to:
  /// **'Give VendorOS notification access in Android settings.'**
  String get soundboxGrantHint;

  /// No description provided for @grantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get grantAccess;

  /// No description provided for @iosUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on iOS'**
  String get iosUnavailable;

  /// No description provided for @webUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available in the browser'**
  String get webUnavailable;

  /// No description provided for @iosSoundboxNote.
  ///
  /// In en, this message translates to:
  /// **'Apple\'s background restrictions prevent reading other apps\' notifications. Manual/voice entry only.'**
  String get iosSoundboxNote;

  /// No description provided for @webSoundboxNote.
  ///
  /// In en, this message translates to:
  /// **'The browser cannot read UPI notifications from other apps. Install the Android APK for the soundbox.'**
  String get webSoundboxNote;

  /// No description provided for @serverSoundbox.
  ///
  /// In en, this message translates to:
  /// **'Business UPI soundbox'**
  String get serverSoundbox;

  /// No description provided for @serverSoundboxNote.
  ///
  /// In en, this message translates to:
  /// **'Payments confirmed by your payment provider are announced here. Nothing is missed: a payment stays queued on the server until this phone speaks it.'**
  String get serverSoundboxNote;

  /// No description provided for @notPaired.
  ///
  /// In en, this message translates to:
  /// **'This phone is not linked to a business UPI account yet.'**
  String get notPaired;

  /// No description provided for @pairingCode.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get pairingCode;

  /// No description provided for @pair.
  ///
  /// In en, this message translates to:
  /// **'Link phone'**
  String get pair;

  /// No description provided for @unpair.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unpair;

  /// No description provided for @pairedWith.
  ///
  /// In en, this message translates to:
  /// **'Linked to {name}'**
  String pairedWith(String name);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get syncNow;

  /// No description provided for @lastChecked.
  ///
  /// In en, this message translates to:
  /// **'Last checked at {time}'**
  String lastChecked(String time);

  /// No description provided for @neverChecked.
  ///
  /// In en, this message translates to:
  /// **'Not checked yet'**
  String get neverChecked;

  /// No description provided for @soundboxStale.
  ///
  /// In en, this message translates to:
  /// **'No contact with the server recently. Check the internet connection.'**
  String get soundboxStale;

  /// No description provided for @queuedPayments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing waiting} =1{1 payment waiting to be announced} other{{count} payments waiting to be announced}}'**
  String queuedPayments(num count);

  /// No description provided for @notificationSoundbox.
  ///
  /// In en, this message translates to:
  /// **'Notification soundbox (fallback)'**
  String get notificationSoundbox;

  /// No description provided for @udhaarTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit book'**
  String get udhaarTitle;

  /// No description provided for @udhaarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer balances'**
  String get udhaarSubtitle;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding'**
  String get totalOutstanding;

  /// No description provided for @customerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No customers} =1{1 customer} other{{count} customers}}'**
  String customerCount(num count);

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter: {name}'**
  String filterBy(String name);

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clearFilter;

  /// No description provided for @upiSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Add your VPA and stall name in Settings to request UPI.'**
  String get upiSetupHint;

  /// No description provided for @noOutstanding.
  ///
  /// In en, this message translates to:
  /// **'No outstanding credit'**
  String get noOutstanding;

  /// No description provided for @cannotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open: {scheme}'**
  String cannotOpen(String scheme);

  /// No description provided for @askUpi.
  ///
  /// In en, this message translates to:
  /// **'Ask UPI'**
  String get askUpi;

  /// No description provided for @collect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collect;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @creditNote.
  ///
  /// In en, this message translates to:
  /// **'Credit {name}'**
  String creditNote(String name);

  /// No description provided for @defaultStallName.
  ///
  /// In en, this message translates to:
  /// **'VendorOS Stall'**
  String get defaultStallName;

  /// No description provided for @merchantOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Register business UPI'**
  String get merchantOnboardingTitle;

  /// No description provided for @merchantOnboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link your business account to the soundbox'**
  String get merchantOnboardingSubtitle;

  /// No description provided for @merchantStepsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the details from your PhonePe for Business or Paytm for Business dashboard. You get a pairing code and this phone is linked right away.'**
  String get merchantStepsHint;

  /// No description provided for @howToGetBusinessUpi.
  ///
  /// In en, this message translates to:
  /// **'How do I get a business UPI account?'**
  String get howToGetBusinessUpi;

  /// No description provided for @merchantFormIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Fill the business name, merchant id and secret key.'**
  String get merchantFormIncomplete;

  /// No description provided for @merchantRegistered.
  ///
  /// In en, this message translates to:
  /// **'Business registered'**
  String get merchantRegistered;

  /// No description provided for @pairingCodeSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Save this pairing code. Use it to link a second phone.'**
  String get pairingCodeSaveHint;

  /// No description provided for @callbackUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Callback URL for the provider dashboard'**
  String get callbackUrlLabel;

  /// No description provided for @backToSoundbox.
  ///
  /// In en, this message translates to:
  /// **'Back to soundbox'**
  String get backToSoundbox;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Payment provider'**
  String get provider;

  /// No description provided for @providerPhonePe.
  ///
  /// In en, this message translates to:
  /// **'PhonePe'**
  String get providerPhonePe;

  /// No description provided for @providerPaytm.
  ///
  /// In en, this message translates to:
  /// **'Paytm'**
  String get providerPaytm;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @businessNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name spoken and printed on reports'**
  String get businessNameHint;

  /// No description provided for @businessVpa.
  ///
  /// In en, this message translates to:
  /// **'Business UPI address'**
  String get businessVpa;

  /// No description provided for @businessVpaHint.
  ///
  /// In en, this message translates to:
  /// **'stallname@ybl'**
  String get businessVpaHint;

  /// No description provided for @merchantIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Merchant id (MID)'**
  String get merchantIdLabel;

  /// No description provided for @merchantIdHint.
  ///
  /// In en, this message translates to:
  /// **'From the provider dashboard'**
  String get merchantIdHint;

  /// No description provided for @saltKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Salt key'**
  String get saltKeyLabel;

  /// No description provided for @saltKeyHint.
  ///
  /// In en, this message translates to:
  /// **'PhonePe salt key'**
  String get saltKeyHint;

  /// No description provided for @saltIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'Salt index'**
  String get saltIndexLabel;

  /// No description provided for @webhookTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Webhook token'**
  String get webhookTokenLabel;

  /// No description provided for @webhookTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Any strong password you also paste in the Paytm dashboard'**
  String get webhookTokenHint;

  /// No description provided for @secretStorageNote.
  ///
  /// In en, this message translates to:
  /// **'The secret key is stored on the server only and can never be read back by the app.'**
  String get secretStorageNote;

  /// No description provided for @registerBusiness.
  ///
  /// In en, this message translates to:
  /// **'Register business UPI'**
  String get registerBusiness;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Business UPI and soundbox guide'**
  String get helpSubtitle;

  /// No description provided for @helpWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why a business UPI account?'**
  String get helpWhyTitle;

  /// No description provided for @helpWhyBody.
  ///
  /// In en, this message translates to:
  /// **'A personal UPI id cannot confirm payments to a server, so announcements can be missed. A business account sends every successful payment to VendorOS, so the soundbox never loses one.'**
  String get helpWhyBody;

  /// No description provided for @helpDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'What you need'**
  String get helpDocsTitle;

  /// No description provided for @helpDocsAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number and a mobile number linked to it'**
  String get helpDocsAadhaar;

  /// No description provided for @helpDocsPan.
  ///
  /// In en, this message translates to:
  /// **'PAN card (personal PAN is fine for a small stall)'**
  String get helpDocsPan;

  /// No description provided for @helpDocsBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account number and IFSC for settlement'**
  String get helpDocsBank;

  /// No description provided for @helpDocsShop.
  ///
  /// In en, this message translates to:
  /// **'Shop name, address and a photo of the stall'**
  String get helpDocsShop;

  /// No description provided for @helpRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Register with a provider'**
  String get helpRegisterTitle;

  /// No description provided for @helpRegisterStep1.
  ///
  /// In en, this message translates to:
  /// **'Install PhonePe for Business or Paytm for Business from the Play Store.'**
  String get helpRegisterStep1;

  /// No description provided for @helpRegisterStep2.
  ///
  /// In en, this message translates to:
  /// **'Sign up with your mobile number and complete the KYC steps with Aadhaar and PAN.'**
  String get helpRegisterStep2;

  /// No description provided for @helpRegisterStep3.
  ///
  /// In en, this message translates to:
  /// **'Add your bank account so money settles to it, and collect the free QR sticker.'**
  String get helpRegisterStep3;

  /// No description provided for @helpRegisterStep4.
  ///
  /// In en, this message translates to:
  /// **'Note the business UPI address (for example stallname@ybl) shown in the app.'**
  String get helpRegisterStep4;

  /// No description provided for @helpKeysTitle.
  ///
  /// In en, this message translates to:
  /// **'Merchant id and secret key'**
  String get helpKeysTitle;

  /// No description provided for @helpKeysPhonePe.
  ///
  /// In en, this message translates to:
  /// **'PhonePe: open the business dashboard, go to Developer settings, and copy the merchant id, salt key and salt index.'**
  String get helpKeysPhonePe;

  /// No description provided for @helpKeysPaytm.
  ///
  /// In en, this message translates to:
  /// **'Paytm: open the business dashboard, go to Developer settings, copy the MID, and create a strong webhook token you also enter here.'**
  String get helpKeysPaytm;

  /// No description provided for @helpKeysCallback.
  ///
  /// In en, this message translates to:
  /// **'Paste the callback URL shown after registration into the provider dashboard so payments reach VendorOS.'**
  String get helpKeysCallback;

  /// No description provided for @helpLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Link this phone'**
  String get helpLinkTitle;

  /// No description provided for @helpLinkStep1.
  ///
  /// In en, this message translates to:
  /// **'Open Soundbox and tap Register business UPI.'**
  String get helpLinkStep1;

  /// No description provided for @helpLinkStep2.
  ///
  /// In en, this message translates to:
  /// **'Fill the form; the phone links automatically and shows a pairing code.'**
  String get helpLinkStep2;

  /// No description provided for @helpLinkStep3.
  ///
  /// In en, this message translates to:
  /// **'On another phone, enter that pairing code in Soundbox to link it too.'**
  String get helpLinkStep3;

  /// No description provided for @helpSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it safe'**
  String get helpSafetyTitle;

  /// No description provided for @helpSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Never share the salt key or webhook token with anyone. VendorOS stores it on the server only and never shows it again.'**
  String get helpSafetyBody;

  /// No description provided for @menuInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get menuInventory;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @productsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catalogue and stock'**
  String get productsSubtitle;

  /// No description provided for @productsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or code'**
  String get productsSearchHint;

  /// No description provided for @productsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add your first item.'**
  String get productsEmpty;

  /// No description provided for @productsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get productsAdd;

  /// No description provided for @productsAllChip.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get productsAllChip;

  /// No description provided for @productsLowStockChip.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get productsLowStockChip;

  /// No description provided for @productEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get productEditTitle;

  /// No description provided for @productMissing.
  ///
  /// In en, this message translates to:
  /// **'This product is no longer in the catalogue.'**
  String get productMissing;

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get productSaved;

  /// No description provided for @productArchived.
  ///
  /// In en, this message translates to:
  /// **'Product removed'**
  String get productArchived;

  /// No description provided for @formInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a product name'**
  String get formInvalid;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldLocalName.
  ///
  /// In en, this message translates to:
  /// **'Name in Tamil'**
  String get fieldLocalName;

  /// No description provided for @fieldCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get fieldCode;

  /// No description provided for @fieldCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Barcode, or leave blank for a new one'**
  String get fieldCodeHint;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get fieldUnit;

  /// No description provided for @fieldCost.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get fieldCost;

  /// No description provided for @fieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get fieldPrice;

  /// No description provided for @fieldReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder level'**
  String get fieldReorder;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes on this screen.'**
  String get discardBody;

  /// No description provided for @discardKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discardKeep;

  /// No description provided for @discardLeave.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardLeave;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @confirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLabel;

  /// No description provided for @qtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get qtyLabel;

  /// No description provided for @unitCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost per unit'**
  String get unitCostLabel;

  /// No description provided for @expiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expires in (days)'**
  String get expiryLabel;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitGram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGram;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get unitPiece;

  /// No description provided for @unitLitre.
  ///
  /// In en, this message translates to:
  /// **'litre'**
  String get unitLitre;

  /// No description provided for @unitBundle.
  ///
  /// In en, this message translates to:
  /// **'bundle'**
  String get unitBundle;

  /// No description provided for @detailSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get detailSell;

  /// No description provided for @detailRestock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get detailRestock;

  /// No description provided for @detailWastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage'**
  String get detailWastage;

  /// No description provided for @detailCorrect.
  ///
  /// In en, this message translates to:
  /// **'Stock count'**
  String get detailCorrect;

  /// No description provided for @detailBatches.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get detailBatches;

  /// No description provided for @detailHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get detailHistory;

  /// No description provided for @detailLabel.
  ///
  /// In en, this message translates to:
  /// **'Print label'**
  String get detailLabel;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stock movements yet'**
  String get historyEmpty;

  /// No description provided for @soldRecorded.
  ///
  /// In en, this message translates to:
  /// **'Sale recorded'**
  String get soldRecorded;

  /// No description provided for @restocked.
  ///
  /// In en, this message translates to:
  /// **'Stock added'**
  String get restocked;

  /// No description provided for @wastageRecorded.
  ///
  /// In en, this message translates to:
  /// **'Wastage recorded'**
  String get wastageRecorded;

  /// No description provided for @stockCorrected.
  ///
  /// In en, this message translates to:
  /// **'Stock updated'**
  String get stockCorrected;

  /// No description provided for @movementPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get movementPurchase;

  /// No description provided for @movementSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get movementSale;

  /// No description provided for @movementWastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage'**
  String get movementWastage;

  /// No description provided for @movementReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get movementReturn;

  /// No description provided for @movementCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get movementCorrection;

  /// No description provided for @expiredTag.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiredTag;

  /// No description provided for @expiryTodayTag.
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get expiryTodayTag;

  /// No description provided for @noExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get noExpiry;

  /// No description provided for @batchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get batchesTitle;

  /// No description provided for @batchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expiry watch'**
  String get batchesSubtitle;

  /// No description provided for @batchesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No dated batches yet'**
  String get batchesEmpty;

  /// No description provided for @stockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockTitle;

  /// No description provided for @stockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Value, alerts and expiry'**
  String get stockSubtitle;

  /// No description provided for @stockValuation.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get stockValuation;

  /// No description provided for @stockProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit (30 days)'**
  String get stockProfit;

  /// No description provided for @stockWastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage (30 days)'**
  String get stockWastage;

  /// No description provided for @stockLowTitle.
  ///
  /// In en, this message translates to:
  /// **'Running low'**
  String get stockLowTitle;

  /// No description provided for @stockExpiryTitle.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get stockExpiryTitle;

  /// No description provided for @stockNothingLow.
  ///
  /// In en, this message translates to:
  /// **'Nothing is running low'**
  String get stockNothingLow;

  /// No description provided for @stockNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No dated batches'**
  String get stockNoExpiry;

  /// No description provided for @stockReorderNow.
  ///
  /// In en, this message translates to:
  /// **'Send reorder list'**
  String get stockReorderNow;

  /// No description provided for @suppliersTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliersTitle;

  /// No description provided for @suppliersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder contacts'**
  String get suppliersSubtitle;

  /// No description provided for @suppliersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet'**
  String get suppliersEmpty;

  /// No description provided for @supplierAdd.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get supplierAdd;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get supplierName;

  /// No description provided for @supplierPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get supplierPhone;

  /// No description provided for @supplierNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get supplierNote;

  /// No description provided for @supplierWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get supplierWhatsapp;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTitle;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Barcode or QR'**
  String get scanSubtitle;

  /// No description provided for @scanUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Camera scanning is not available here. Type the code below.'**
  String get scanUnsupported;

  /// No description provided for @scanPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to scan'**
  String get scanPermission;

  /// No description provided for @scanManualHint.
  ///
  /// In en, this message translates to:
  /// **'Type or paste a code'**
  String get scanManualHint;

  /// No description provided for @scanCreateFromCode.
  ///
  /// In en, this message translates to:
  /// **'Add a product with this code'**
  String get scanCreateFromCode;

  /// No description provided for @labelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsTitle;

  /// No description provided for @labelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print QR and barcode labels'**
  String get labelsSubtitle;

  /// No description provided for @labelsSelect.
  ///
  /// In en, this message translates to:
  /// **'Choose products'**
  String get labelsSelect;

  /// No description provided for @labelsSize.
  ///
  /// In en, this message translates to:
  /// **'Label size'**
  String get labelsSize;

  /// No description provided for @labelsSymbology.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get labelsSymbology;

  /// No description provided for @labelsCopies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get labelsCopies;

  /// No description provided for @labelsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print sheet'**
  String get labelsPrint;

  /// No description provided for @labelsThermal.
  ///
  /// In en, this message translates to:
  /// **'Copy printer code'**
  String get labelsThermal;

  /// No description provided for @labelsCopied.
  ///
  /// In en, this message translates to:
  /// **'Printer code copied'**
  String get labelsCopied;

  /// No description provided for @labelsNone.
  ///
  /// In en, this message translates to:
  /// **'Select at least one product'**
  String get labelsNone;

  /// No description provided for @symbolQr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get symbolQr;

  /// No description provided for @symbolBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get symbolBarcode;

  /// No description provided for @paymentQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment QR'**
  String get paymentQrTitle;

  /// No description provided for @paymentQrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let customers scan and pay'**
  String get paymentQrSubtitle;

  /// No description provided for @paymentQrAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount (optional)'**
  String get paymentQrAmountHint;

  /// No description provided for @paymentQrNeedVpa.
  ///
  /// In en, this message translates to:
  /// **'Add your UPI ID in Settings first.'**
  String get paymentQrNeedVpa;

  /// No description provided for @paymentQrOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get paymentQrOpenSettings;

  /// No description provided for @paymentQrPoster.
  ///
  /// In en, this message translates to:
  /// **'Save poster'**
  String get paymentQrPoster;

  /// No description provided for @paymentQrCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get paymentQrCopy;

  /// No description provided for @paymentQrCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get paymentQrCopied;

  /// No description provided for @paymentQrNote.
  ///
  /// In en, this message translates to:
  /// **'Scanning opens the customer\'s UPI app. A payment counts only when the soundbox announces it.'**
  String get paymentQrNote;

  /// No description provided for @stockOnHand.
  ///
  /// In en, this message translates to:
  /// **'In stock: {qty}'**
  String stockOnHand(String qty);

  /// No description provided for @marginLabel.
  ///
  /// In en, this message translates to:
  /// **'Margin {pct}%'**
  String marginLabel(String pct);

  /// No description provided for @expirySoonTag.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} one{1 day} other{{days} days}}'**
  String expirySoonTag(int days);

  /// No description provided for @expiryWatchCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing expiring soon} one{1 batch needs attention} other{{count} batches need attention}}'**
  String expiryWatchCount(int count);

  /// No description provided for @batchLine.
  ///
  /// In en, this message translates to:
  /// **'{qty} left · {cost} per unit'**
  String batchLine(String qty, String cost);

  /// No description provided for @sellShortfall.
  ///
  /// In en, this message translates to:
  /// **'Only {qty} was in stock — recorded that much'**
  String sellShortfall(String qty);

  /// No description provided for @productArchiveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the catalogue?'**
  String productArchiveConfirm(String name);

  /// No description provided for @reorderMessage.
  ///
  /// In en, this message translates to:
  /// **'{stall}: please send {items}'**
  String reorderMessage(String stall, String items);

  /// No description provided for @paymentQrPayingTo.
  ///
  /// In en, this message translates to:
  /// **'Paying to {vpa}'**
  String paymentQrPayingTo(String vpa);

  /// No description provided for @scanUnknownCode.
  ///
  /// In en, this message translates to:
  /// **'No product has the code {code}'**
  String scanUnknownCode(String code);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get profileTitle;

  /// No description provided for @vendorCategory.
  ///
  /// In en, this message translates to:
  /// **'Business type'**
  String get vendorCategory;

  /// No description provided for @categoryCart.
  ///
  /// In en, this message translates to:
  /// **'Street cart (thalluvandi)'**
  String get categoryCart;

  /// No description provided for @categoryStall.
  ///
  /// In en, this message translates to:
  /// **'Fixed stall / shop'**
  String get categoryStall;

  /// No description provided for @categoryHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel / eatery'**
  String get categoryHotel;

  /// No description provided for @categoryService.
  ///
  /// In en, this message translates to:
  /// **'Service work'**
  String get categoryService;

  /// No description provided for @nicheLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you sell or do?'**
  String get nicheLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @talukLabel.
  ///
  /// In en, this message translates to:
  /// **'Taluk / town'**
  String get talukLabel;

  /// No description provided for @marketAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Market / area'**
  String get marketAreaLabel;

  /// No description provided for @fssaiLabel.
  ///
  /// In en, this message translates to:
  /// **'FSSAI number (food business)'**
  String get fssaiLabel;

  /// No description provided for @udyamLabel.
  ///
  /// In en, this message translates to:
  /// **'UDYAM registration (optional)'**
  String get udyamLabel;

  /// No description provided for @workingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHoursLabel;

  /// No description provided for @perishableLabel.
  ///
  /// In en, this message translates to:
  /// **'Sells perishable goods'**
  String get perishableLabel;

  /// No description provided for @profilePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your business profile'**
  String get profilePromptTitle;

  /// No description provided for @profilePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you sell so the app shows only what you need.'**
  String get profilePromptBody;

  /// No description provided for @profilePromptAction.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get profilePromptAction;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Milk, gas, snacks, rent — what you pay out'**
  String get expensesSubtitle;

  /// No description provided for @expenseToday.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get expenseToday;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAdd;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expenseNote;

  /// No description provided for @expenseTodayList.
  ///
  /// In en, this message translates to:
  /// **'Today\'s expenses'**
  String get expenseTodayList;

  /// No description provided for @expenseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expense recorded today'**
  String get expenseEmpty;

  /// No description provided for @expenseMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get expenseMilk;

  /// No description provided for @expenseGas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get expenseGas;

  /// No description provided for @expenseSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get expenseSnacks;

  /// No description provided for @expenseProvisions.
  ///
  /// In en, this message translates to:
  /// **'Provisions'**
  String get expenseProvisions;

  /// No description provided for @expenseWages.
  ///
  /// In en, this message translates to:
  /// **'Wages'**
  String get expenseWages;

  /// No description provided for @expenseRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get expenseRent;

  /// No description provided for @expenseElectricity.
  ///
  /// In en, this message translates to:
  /// **'Current bill'**
  String get expenseElectricity;

  /// No description provided for @expenseTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expenseTransport;

  /// No description provided for @expenseOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseOther;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily supplies'**
  String get recurringTitle;

  /// No description provided for @recurringAdd.
  ///
  /// In en, this message translates to:
  /// **'Add supply'**
  String get recurringAdd;

  /// No description provided for @recurringName.
  ///
  /// In en, this message translates to:
  /// **'Supply name'**
  String get recurringName;

  /// No description provided for @recurringEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save milk cans or the snack tray here to book them in one tap.'**
  String get recurringEmpty;

  /// No description provided for @dayCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Day close'**
  String get dayCloseTitle;

  /// No description provided for @dayCloseExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Cash that should be in the box'**
  String get dayCloseExpectedCash;

  /// No description provided for @dayCloseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Today\'s movement'**
  String get dayCloseBreakdown;

  /// No description provided for @dayCloseCollected.
  ///
  /// In en, this message translates to:
  /// **'Credit collected'**
  String get dayCloseCollected;

  /// No description provided for @dayCloseWastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage'**
  String get dayCloseWastage;

  /// No description provided for @dayCloseProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit today'**
  String get dayCloseProfit;

  /// No description provided for @dayCloseCount.
  ///
  /// In en, this message translates to:
  /// **'Count the box'**
  String get dayCloseCount;

  /// No description provided for @dayCloseCountedCash.
  ///
  /// In en, this message translates to:
  /// **'Cash counted'**
  String get dayCloseCountedCash;

  /// No description provided for @dayCloseSave.
  ///
  /// In en, this message translates to:
  /// **'Close the day'**
  String get dayCloseSave;

  /// No description provided for @dayCloseDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts given'**
  String get dayCloseDiscounts;

  /// No description provided for @dayCloseTax.
  ///
  /// In en, this message translates to:
  /// **'Tax collected'**
  String get dayCloseTax;

  /// No description provided for @dayCloseLastToken.
  ///
  /// In en, this message translates to:
  /// **'Last token'**
  String get dayCloseLastToken;

  /// No description provided for @dayCloseVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided bills'**
  String get dayCloseVoided;

  /// No description provided for @dayCloseExport.
  ///
  /// In en, this message translates to:
  /// **'Export day PDF'**
  String get dayCloseExport;

  /// No description provided for @dayCloseVariancePosted.
  ///
  /// In en, this message translates to:
  /// **'Cash difference posted to the ledger.'**
  String get dayCloseVariancePosted;

  /// No description provided for @dayCloseExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export the day summary.'**
  String get dayCloseExportFailed;

  /// No description provided for @dayCloseMatch.
  ///
  /// In en, this message translates to:
  /// **'Cash matches exactly.'**
  String get dayCloseMatch;

  /// No description provided for @dayCloseSurplus.
  ///
  /// In en, this message translates to:
  /// **'{amount} more than expected'**
  String dayCloseSurplus(String amount);

  /// No description provided for @dayCloseShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} short'**
  String dayCloseShort(String amount);

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Day, week, month and year'**
  String get insightsSubtitle;

  /// No description provided for @windowDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get windowDay;

  /// No description provided for @windowWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get windowWeek;

  /// No description provided for @windowMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get windowMonth;

  /// No description provided for @windowYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get windowYear;

  /// No description provided for @insightsTurnover.
  ///
  /// In en, this message translates to:
  /// **'Turnover'**
  String get insightsTurnover;

  /// No description provided for @insightsCosts.
  ///
  /// In en, this message translates to:
  /// **'Costs'**
  String get insightsCosts;

  /// No description provided for @insightsProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get insightsProfit;

  /// No description provided for @insightsAvgDay.
  ///
  /// In en, this message translates to:
  /// **'Per day'**
  String get insightsAvgDay;

  /// No description provided for @insightsByDay.
  ///
  /// In en, this message translates to:
  /// **'Day by day'**
  String get insightsByDay;

  /// No description provided for @insightsBestDay.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get insightsBestDay;

  /// No description provided for @insightsTopItems.
  ///
  /// In en, this message translates to:
  /// **'Best sellers'**
  String get insightsTopItems;

  /// No description provided for @insightsCostSplit.
  ///
  /// In en, this message translates to:
  /// **'Where the money went'**
  String get insightsCostSplit;

  /// No description provided for @insightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in this period yet'**
  String get insightsEmpty;

  /// No description provided for @insightsMarginAlert.
  ///
  /// In en, this message translates to:
  /// **'Margin warning'**
  String get insightsMarginAlert;

  /// No description provided for @insightsMarginBody.
  ///
  /// In en, this message translates to:
  /// **'These items sell too close to their cost. Raise the price or lower the cost.'**
  String get insightsMarginBody;

  /// No description provided for @insightsMarginRow.
  ///
  /// In en, this message translates to:
  /// **'cost {cost} · price {price}'**
  String insightsMarginRow(String cost, String price);

  /// No description provided for @quickSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick sale'**
  String get quickSaleTitle;

  /// No description provided for @quickSaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One tap per cup — long press for a bigger order'**
  String get quickSaleSubtitle;

  /// No description provided for @quickSaleQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quickSaleQty;

  /// No description provided for @quickSaleQtyTitle.
  ///
  /// In en, this message translates to:
  /// **'How many {item}?'**
  String quickSaleQtyTitle(String item);

  /// No description provided for @quickSaleDone.
  ///
  /// In en, this message translates to:
  /// **'{item} · {amount} recorded'**
  String quickSaleDone(String item, String amount);

  /// No description provided for @quickSaleSemantic.
  ///
  /// In en, this message translates to:
  /// **'Sell one {item} for {amount}'**
  String quickSaleSemantic(String item, String amount);

  /// No description provided for @quickSaleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add items with a price to use the quick menu.'**
  String get quickSaleEmpty;

  /// No description provided for @starterPackAction.
  ///
  /// In en, this message translates to:
  /// **'Load starter kit for my shop'**
  String get starterPackAction;

  /// No description provided for @starterTea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get starterTea;

  /// No description provided for @starterCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get starterCoffee;

  /// No description provided for @starterBun.
  ///
  /// In en, this message translates to:
  /// **'Bun'**
  String get starterBun;

  /// No description provided for @starterBiscuit.
  ///
  /// In en, this message translates to:
  /// **'Biscuit'**
  String get starterBiscuit;

  /// No description provided for @starterBajji.
  ///
  /// In en, this message translates to:
  /// **'Bajji'**
  String get starterBajji;

  /// No description provided for @starterMilkSupply.
  ///
  /// In en, this message translates to:
  /// **'Milk cans'**
  String get starterMilkSupply;

  /// No description provided for @starterSnackSupply.
  ///
  /// In en, this message translates to:
  /// **'Snack tray'**
  String get starterSnackSupply;

  /// No description provided for @menuDailyWork.
  ///
  /// In en, this message translates to:
  /// **'Daily running'**
  String get menuDailyWork;

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get stockOut;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Counter and QR orders, live'**
  String get ordersSubtitle;

  /// No description provided for @orderCounterNew.
  ///
  /// In en, this message translates to:
  /// **'New counter order'**
  String get orderCounterNew;

  /// No description provided for @orderTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get orderTable;

  /// No description provided for @orderRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove one'**
  String get orderRemoveItem;

  /// No description provided for @orderAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add one'**
  String get orderAddItem;

  /// No description provided for @orderCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling'**
  String get orderCancelReason;

  /// No description provided for @orderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get orderCancel;

  /// No description provided for @orderLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get orderLive;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get orderHistory;

  /// No description provided for @orderEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get orderEmpty;

  /// No description provided for @orderNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get orderNew;

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get orderPreparing;

  /// No description provided for @orderServed.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get orderServed;

  /// No description provided for @orderPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderPaid;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderCancelled;

  /// No description provided for @orderAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get orderAccept;

  /// No description provided for @orderServe.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get orderServe;

  /// No description provided for @orderBulkAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept all new'**
  String get orderBulkAccept;

  /// No description provided for @orderBulkServe.
  ///
  /// In en, this message translates to:
  /// **'Serve all ready'**
  String get orderBulkServe;

  /// No description provided for @orderBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get orderBill;

  /// No description provided for @orderTokenShort.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get orderTokenShort;

  /// No description provided for @kotTitle.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kotTitle;

  /// No description provided for @kotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What has to be cooked next'**
  String get kotSubtitle;

  /// No description provided for @kotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Kitchen queue is clear.'**
  String get kotEmpty;

  /// No description provided for @kotDone.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get kotDone;

  /// No description provided for @billTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get billTitle;

  /// No description provided for @billNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get billNumberLabel;

  /// No description provided for @billSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get billSubtotal;

  /// No description provided for @billDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get billDiscount;

  /// No description provided for @billDiscountFlat.
  ///
  /// In en, this message translates to:
  /// **'Discount amount'**
  String get billDiscountFlat;

  /// No description provided for @billDiscountPct.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get billDiscountPct;

  /// No description provided for @billTax.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get billTax;

  /// No description provided for @billTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable'**
  String get billTaxable;

  /// No description provided for @billCgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get billCgst;

  /// No description provided for @billSgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get billSgst;

  /// No description provided for @billIgst.
  ///
  /// In en, this message translates to:
  /// **'IGST'**
  String get billIgst;

  /// No description provided for @shopGstRegistered.
  ///
  /// In en, this message translates to:
  /// **'GST registered shop'**
  String get shopGstRegistered;

  /// No description provided for @shopGstRegisteredHint.
  ///
  /// In en, this message translates to:
  /// **'Bills show the CGST/SGST split and item HSN codes'**
  String get shopGstRegisteredHint;

  /// No description provided for @shopPriceIncludesTax.
  ///
  /// In en, this message translates to:
  /// **'Prices already include tax'**
  String get shopPriceIncludesTax;

  /// No description provided for @productTaxRate.
  ///
  /// In en, this message translates to:
  /// **'GST rate %'**
  String get productTaxRate;

  /// No description provided for @productHsn.
  ///
  /// In en, this message translates to:
  /// **'HSN / SAC code'**
  String get productHsn;

  /// No description provided for @productTaxHint.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to use the shop\'s rate'**
  String get productTaxHint;

  /// No description provided for @billRounding.
  ///
  /// In en, this message translates to:
  /// **'Rounding'**
  String get billRounding;

  /// No description provided for @billTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get billTotal;

  /// No description provided for @billPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billPaid;

  /// No description provided for @billBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get billBalance;

  /// No description provided for @billReprint.
  ///
  /// In en, this message translates to:
  /// **'Reprint'**
  String get billReprint;

  /// No description provided for @billShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get billShare;

  /// No description provided for @billThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you, come again'**
  String get billThanks;

  /// No description provided for @billCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get billCustomer;

  /// No description provided for @billSplit.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get billSplit;

  /// No description provided for @billRoundToRupee.
  ///
  /// In en, this message translates to:
  /// **'Round to rupee'**
  String get billRoundToRupee;

  /// No description provided for @billFillCash.
  ///
  /// In en, this message translates to:
  /// **'Fill balance in cash'**
  String get billFillCash;

  /// No description provided for @billFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Fully paid'**
  String get billFullyPaid;

  /// No description provided for @billSettle.
  ///
  /// In en, this message translates to:
  /// **'Settle bill'**
  String get billSettle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @billPreview.
  ///
  /// In en, this message translates to:
  /// **'Paper preview'**
  String get billPreview;

  /// No description provided for @billVoid.
  ///
  /// In en, this message translates to:
  /// **'Void bill'**
  String get billVoid;

  /// No description provided for @billVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void this bill'**
  String get billVoidTitle;

  /// No description provided for @billVoidHint.
  ///
  /// In en, this message translates to:
  /// **'The bill number stays in the books and the ledger entries are reversed.'**
  String get billVoidHint;

  /// No description provided for @billVoidReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get billVoidReason;

  /// No description provided for @billVoidReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is needed to void a bill'**
  String get billVoidReasonRequired;

  /// No description provided for @billVoided.
  ///
  /// In en, this message translates to:
  /// **'Bill voided'**
  String get billVoided;

  /// No description provided for @billVoidFailed.
  ///
  /// In en, this message translates to:
  /// **'This bill could not be voided'**
  String get billVoidFailed;

  /// No description provided for @billAudit.
  ///
  /// In en, this message translates to:
  /// **'Bill history'**
  String get billAudit;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'QR menu'**
  String get menuTitle;

  /// No description provided for @menuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What customers see when they scan'**
  String get menuSubtitle;

  /// No description provided for @menuShopSection.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get menuShopSection;

  /// No description provided for @menuSlug.
  ///
  /// In en, this message translates to:
  /// **'Menu name in the link'**
  String get menuSlug;

  /// No description provided for @menuBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Menu web address'**
  String get menuBaseUrl;

  /// No description provided for @menuTableCount.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get menuTableCount;

  /// No description provided for @menuTaxPercent.
  ///
  /// In en, this message translates to:
  /// **'GST %'**
  String get menuTaxPercent;

  /// No description provided for @menuGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get menuGstin;

  /// No description provided for @menuAcceptOrders.
  ///
  /// In en, this message translates to:
  /// **'Accept QR orders'**
  String get menuAcceptOrders;

  /// No description provided for @menuSaved.
  ///
  /// In en, this message translates to:
  /// **'Menu settings saved'**
  String get menuSaved;

  /// No description provided for @menuQrSheet.
  ///
  /// In en, this message translates to:
  /// **'Print QR sheet'**
  String get menuQrSheet;

  /// No description provided for @menuLinkSection.
  ///
  /// In en, this message translates to:
  /// **'Shop QR'**
  String get menuLinkSection;

  /// No description provided for @menuItemsSection.
  ///
  /// In en, this message translates to:
  /// **'Items on the menu'**
  String get menuItemsSection;

  /// No description provided for @menuSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get menuSoldOut;

  /// No description provided for @menuPublished.
  ///
  /// In en, this message translates to:
  /// **'On menu'**
  String get menuPublished;

  /// No description provided for @menuCounterQr.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get menuCounterQr;

  /// No description provided for @menuScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan to see the menu and order'**
  String get menuScanHint;

  /// No description provided for @printersTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt printer'**
  String get printersTitle;

  /// No description provided for @printersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paper size, connection and test print'**
  String get printersSubtitle;

  /// No description provided for @printerWidth.
  ///
  /// In en, this message translates to:
  /// **'Paper width'**
  String get printerWidth;

  /// No description provided for @printerTransport.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get printerTransport;

  /// No description provided for @printerPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF / share'**
  String get printerPdf;

  /// No description provided for @printerBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get printerBluetooth;

  /// No description provided for @printerUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get printerUsb;

  /// No description provided for @printerDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Printer name'**
  String get printerDeviceName;

  /// No description provided for @printerDeviceAddress.
  ///
  /// In en, this message translates to:
  /// **'Printer address'**
  String get printerDeviceAddress;

  /// No description provided for @printerFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'Direct printing to this device is not ready yet, so the bill opens as a PDF you can print or share.'**
  String get printerFallbackNote;

  /// No description provided for @printerAutoPrint.
  ///
  /// In en, this message translates to:
  /// **'Print bill automatically'**
  String get printerAutoPrint;

  /// No description provided for @printerKot.
  ///
  /// In en, this message translates to:
  /// **'Print kitchen ticket'**
  String get printerKot;

  /// No description provided for @printerTest.
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get printerTest;

  /// No description provided for @printerTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test receipt sent'**
  String get printerTestSent;

  /// No description provided for @printerPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired printers'**
  String get printerPaired;

  /// No description provided for @printerScan.
  ///
  /// In en, this message translates to:
  /// **'Find paired printers'**
  String get printerScan;

  /// No description provided for @printerScanning.
  ///
  /// In en, this message translates to:
  /// **'Looking…'**
  String get printerScanning;

  /// No description provided for @printerNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No paired printer found. Pair it in Android Bluetooth settings first.'**
  String get printerNoDevices;

  /// No description provided for @printerConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get printerConnect;

  /// No description provided for @printerConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer connected'**
  String get printerConnected;

  /// No description provided for @printerConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Switch the printer on and try again.'**
  String get printerConnectFailed;

  /// No description provided for @printerBluetoothNote.
  ///
  /// In en, this message translates to:
  /// **'Bills print straight to this Bluetooth printer. If it is off or out of range, the bill opens as a PDF instead so nothing is lost.'**
  String get printerBluetoothNote;

  /// No description provided for @orderToken.
  ///
  /// In en, this message translates to:
  /// **'Token {token}'**
  String orderToken(int token);

  /// No description provided for @orderElapsed.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String orderElapsed(int minutes);

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String orderItems(int count);

  /// No description provided for @billSettled.
  ///
  /// In en, this message translates to:
  /// **'Bill {number} settled'**
  String billSettled(String number);

  /// No description provided for @dayCloseOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders today'**
  String get dayCloseOrders;

  /// No description provided for @dayCloseOrdersTaken.
  ///
  /// In en, this message translates to:
  /// **'Orders taken'**
  String get dayCloseOrdersTaken;

  /// No description provided for @dayCloseOrdersCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dayCloseOrdersCancelled;

  /// No description provided for @dayCloseOrdersOpen.
  ///
  /// In en, this message translates to:
  /// **'Still open'**
  String get dayCloseOrdersOpen;

  /// No description provided for @dayCloseOrdersBilled.
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get dayCloseOrdersBilled;

  /// No description provided for @dayCloseAvgTicket.
  ///
  /// In en, this message translates to:
  /// **'Average ticket'**
  String get dayCloseAvgTicket;

  /// No description provided for @menuCloudSection.
  ///
  /// In en, this message translates to:
  /// **'Cloud board'**
  String get menuCloudSection;

  /// No description provided for @menuShopKey.
  ///
  /// In en, this message translates to:
  /// **'Shop key (16+ characters)'**
  String get menuShopKey;

  /// No description provided for @menuCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Sync orders with the cloud'**
  String get menuCloudSync;

  /// No description provided for @menuCloudPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish menu to cloud'**
  String get menuCloudPublish;

  /// No description provided for @menuCloudPublished.
  ///
  /// In en, this message translates to:
  /// **'Published {count} items to the cloud menu'**
  String menuCloudPublished(int count);

  /// No description provided for @menuCloudFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud error: {reason}'**
  String menuCloudFailed(String reason);

  /// No description provided for @menuCloudLive.
  ///
  /// In en, this message translates to:
  /// **'Live: QR orders arrive on the board automatically.'**
  String get menuCloudLive;

  /// No description provided for @menuCloudOffline.
  ///
  /// In en, this message translates to:
  /// **'Local only. Add a shop key and turn on sync to receive QR orders.'**
  String get menuCloudOffline;

  /// No description provided for @settleTitle.
  ///
  /// In en, this message translates to:
  /// **'Settle credit'**
  String get settleTitle;

  /// No description provided for @settleAmountSection.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get settleAmountSection;

  /// No description provided for @settleAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get settleAmount;

  /// No description provided for @settleCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get settleCash;

  /// No description provided for @settleUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get settleUpi;

  /// No description provided for @settleLoan.
  ///
  /// In en, this message translates to:
  /// **'New loan'**
  String get settleLoan;

  /// No description provided for @settleNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get settleNote;

  /// No description provided for @settleCashHint.
  ///
  /// In en, this message translates to:
  /// **'Cash received closes the balance and is added to today\'s cash takings.'**
  String get settleCashHint;

  /// No description provided for @settleUpiHint.
  ///
  /// In en, this message translates to:
  /// **'Ask on UPI, then confirm. The balance closes and today\'s UPI takings go up.'**
  String get settleUpiHint;

  /// No description provided for @settleLoanHint.
  ///
  /// In en, this message translates to:
  /// **'The old balance closes and the same amount reopens as a fresh credit line.'**
  String get settleLoanHint;

  /// No description provided for @settleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Settle'**
  String get settleConfirm;

  /// No description provided for @settleDone.
  ///
  /// In en, this message translates to:
  /// **'Settlement recorded'**
  String get settleDone;

  /// No description provided for @settleHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent settlements'**
  String get settleHistory;

  /// No description provided for @settleTooMuch.
  ///
  /// In en, this message translates to:
  /// **'More than the outstanding ₹{amount}'**
  String settleTooMuch(String amount);

  /// No description provided for @settleLedgerItem.
  ///
  /// In en, this message translates to:
  /// **'Credit settled — {name}'**
  String settleLedgerItem(String name);

  /// No description provided for @settleLoanItem.
  ///
  /// In en, this message translates to:
  /// **'Credit rolled into a new loan — {name}'**
  String settleLoanItem(String name);

  /// No description provided for @menuAddress.
  ///
  /// In en, this message translates to:
  /// **'Shop address'**
  String get menuAddress;

  /// No description provided for @menuPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get menuPhone;

  /// No description provided for @menuFssai.
  ///
  /// In en, this message translates to:
  /// **'FSSAI licence'**
  String get menuFssai;

  /// No description provided for @menuGrowSection.
  ///
  /// In en, this message translates to:
  /// **'Grow & manage'**
  String get menuGrowSection;

  /// No description provided for @recipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe book'**
  String get recipesTitle;

  /// No description provided for @recipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your measurements, written down once'**
  String get recipesSubtitle;

  /// No description provided for @recipeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a dish'**
  String get recipeAdd;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Dish name'**
  String get recipeName;

  /// No description provided for @recipeServings.
  ///
  /// In en, this message translates to:
  /// **'Makes (plates)'**
  String get recipeServings;

  /// No description provided for @recipeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No dishes written down yet.'**
  String get recipeEmpty;

  /// No description provided for @recipeIngredients.
  ///
  /// In en, this message translates to:
  /// **'What goes in'**
  String get recipeIngredients;

  /// No description provided for @recipeSteps.
  ///
  /// In en, this message translates to:
  /// **'How to make it'**
  String get recipeSteps;

  /// No description provided for @recipeAddIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get recipeAddIngredient;

  /// No description provided for @recipeAddStep.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get recipeAddStep;

  /// No description provided for @recipeQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get recipeQty;

  /// No description provided for @recipeLinkProduct.
  ///
  /// In en, this message translates to:
  /// **'Take from stock item'**
  String get recipeLinkProduct;

  /// No description provided for @recipeNoLink.
  ///
  /// In en, this message translates to:
  /// **'Not from stock'**
  String get recipeNoLink;

  /// No description provided for @recipeCost.
  ///
  /// In en, this message translates to:
  /// **'Material cost'**
  String get recipeCost;

  /// No description provided for @recipePerServing.
  ///
  /// In en, this message translates to:
  /// **'Cost per plate'**
  String get recipePerServing;

  /// No description provided for @recipeScale.
  ///
  /// In en, this message translates to:
  /// **'Cook for'**
  String get recipeScale;

  /// No description provided for @recipeCookBatch.
  ///
  /// In en, this message translates to:
  /// **'Take materials out of stock'**
  String get recipeCookBatch;

  /// No description provided for @recipeCooked.
  ///
  /// In en, this message translates to:
  /// **'Materials taken out of stock'**
  String get recipeCooked;

  /// No description provided for @recipeStepsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No steps written yet.'**
  String get recipeStepsEmpty;

  /// No description provided for @recipeUnlinkedWarning.
  ///
  /// In en, this message translates to:
  /// **'Items not linked to stock are left out of the cost.'**
  String get recipeUnlinkedWarning;

  /// No description provided for @jobsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom orders'**
  String get jobsTitle;

  /// No description provided for @jobsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advance bookings and made-to-order work'**
  String get jobsSubtitle;

  /// No description provided for @jobAdd.
  ///
  /// In en, this message translates to:
  /// **'Take an order'**
  String get jobAdd;

  /// No description provided for @jobTitleField.
  ///
  /// In en, this message translates to:
  /// **'What is being made'**
  String get jobTitleField;

  /// No description provided for @jobCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get jobCustomer;

  /// No description provided for @jobPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get jobPhone;

  /// No description provided for @jobPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get jobPrice;

  /// No description provided for @jobAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance taken'**
  String get jobAdvance;

  /// No description provided for @jobDue.
  ///
  /// In en, this message translates to:
  /// **'Give on'**
  String get jobDue;

  /// No description provided for @jobEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders here.'**
  String get jobEmpty;

  /// No description provided for @jobStatusTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get jobStatusTaken;

  /// No description provided for @jobStatusMaking.
  ///
  /// In en, this message translates to:
  /// **'Making'**
  String get jobStatusMaking;

  /// No description provided for @jobStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get jobStatusReady;

  /// No description provided for @jobStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get jobStatusDelivered;

  /// No description provided for @jobStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get jobStatusCancelled;

  /// No description provided for @jobAdvanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Move on'**
  String get jobAdvanceStatus;

  /// No description provided for @jobCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get jobCancel;

  /// No description provided for @jobRemind.
  ///
  /// In en, this message translates to:
  /// **'Message on WhatsApp'**
  String get jobRemind;

  /// No description provided for @jobFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get jobFilterOpen;

  /// No description provided for @jobFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get jobFilterToday;

  /// No description provided for @jobFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get jobFilterDone;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Regulars'**
  String get customersTitle;

  /// No description provided for @customersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who comes back, and how they found you'**
  String get customersSubtitle;

  /// No description provided for @customerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customerAdd;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get customerName;

  /// No description provided for @customerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get customerPhone;

  /// No description provided for @sourceWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walked in'**
  String get sourceWalkIn;

  /// No description provided for @sourceInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get sourceInstagram;

  /// No description provided for @sourceMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get sourceMaps;

  /// No description provided for @sourceReferral.
  ///
  /// In en, this message translates to:
  /// **'Told by a friend'**
  String get sourceReferral;

  /// No description provided for @sourceOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sourceOther;

  /// No description provided for @customerRecordVisit.
  ///
  /// In en, this message translates to:
  /// **'Add a visit'**
  String get customerRecordVisit;

  /// No description provided for @customerVisitAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get customerVisitAmount;

  /// No description provided for @customerRewardDue.
  ///
  /// In en, this message translates to:
  /// **'Free one due'**
  String get customerRewardDue;

  /// No description provided for @customerGiveReward.
  ///
  /// In en, this message translates to:
  /// **'Give the free one'**
  String get customerGiveReward;

  /// No description provided for @customersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No regulars saved yet.'**
  String get customersEmpty;

  /// No description provided for @customerSourceSplit.
  ///
  /// In en, this message translates to:
  /// **'Where the money comes from'**
  String get customerSourceSplit;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events & exhibitions'**
  String get eventsTitle;

  /// No description provided for @eventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Was the stall worth it?'**
  String get eventsSubtitle;

  /// No description provided for @eventAdd.
  ///
  /// In en, this message translates to:
  /// **'Add an event'**
  String get eventAdd;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventName;

  /// No description provided for @eventPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get eventPlace;

  /// No description provided for @eventDay.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDay;

  /// No description provided for @eventRent.
  ///
  /// In en, this message translates to:
  /// **'Stall rent'**
  String get eventRent;

  /// No description provided for @eventTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get eventTravel;

  /// No description provided for @eventOther.
  ///
  /// In en, this message translates to:
  /// **'Other cost'**
  String get eventOther;

  /// No description provided for @eventSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get eventSales;

  /// No description provided for @eventFootfall.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get eventFootfall;

  /// No description provided for @eventProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get eventProfit;

  /// No description provided for @eventLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get eventLoss;

  /// No description provided for @eventPerVisitor.
  ///
  /// In en, this message translates to:
  /// **'Per visitor'**
  String get eventPerVisitor;

  /// No description provided for @eventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events recorded yet.'**
  String get eventsEmpty;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get staffTitle;

  /// No description provided for @staffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance, advances and wages'**
  String get staffSubtitle;

  /// No description provided for @staffAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a worker'**
  String get staffAdd;

  /// No description provided for @staffName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffName;

  /// No description provided for @staffPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get staffPhone;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get staffRole;

  /// No description provided for @staffWage.
  ///
  /// In en, this message translates to:
  /// **'Daily wage'**
  String get staffWage;

  /// No description provided for @staffPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get staffPresent;

  /// No description provided for @staffHalf.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get staffHalf;

  /// No description provided for @staffAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get staffAbsent;

  /// No description provided for @staffAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get staffAdvance;

  /// No description provided for @staffAdvanceAdd.
  ///
  /// In en, this message translates to:
  /// **'Give advance'**
  String get staffAdvanceAdd;

  /// No description provided for @staffPayable.
  ///
  /// In en, this message translates to:
  /// **'Wage due this month'**
  String get staffPayable;

  /// No description provided for @staffEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workers added.'**
  String get staffEmpty;

  /// No description provided for @staffRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get staffRemove;

  /// No description provided for @growthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth kit'**
  String get growthTitle;

  /// No description provided for @growthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring more customers in'**
  String get growthSubtitle;

  /// No description provided for @growthMenuLink.
  ///
  /// In en, this message translates to:
  /// **'Your menu link'**
  String get growthMenuLink;

  /// No description provided for @growthShareMenu.
  ///
  /// In en, this message translates to:
  /// **'Send the menu'**
  String get growthShareMenu;

  /// No description provided for @growthAskReview.
  ///
  /// In en, this message translates to:
  /// **'Ask for a review'**
  String get growthAskReview;

  /// No description provided for @growthOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Open Maps page'**
  String get growthOpenMaps;

  /// No description provided for @growthWhatsappBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Tell customers on WhatsApp'**
  String get growthWhatsappBroadcast;

  /// No description provided for @growthLinksSection.
  ///
  /// In en, this message translates to:
  /// **'Your links'**
  String get growthLinksSection;

  /// No description provided for @growthMapsUrl.
  ///
  /// In en, this message translates to:
  /// **'Google Maps link'**
  String get growthMapsUrl;

  /// No description provided for @growthReviewUrl.
  ///
  /// In en, this message translates to:
  /// **'Review link'**
  String get growthReviewUrl;

  /// No description provided for @growthInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram name'**
  String get growthInstagram;

  /// No description provided for @growthLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Free one after how many visits'**
  String get growthLoyalty;

  /// No description provided for @growthIdeas.
  ///
  /// In en, this message translates to:
  /// **'Post ideas for this week'**
  String get growthIdeas;

  /// No description provided for @growthShareIdea.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get growthShareIdea;

  /// No description provided for @growthIdea1.
  ///
  /// In en, this message translates to:
  /// **'A short clip of the first batch being made in the morning.'**
  String get growthIdea1;

  /// No description provided for @growthIdea2.
  ///
  /// In en, this message translates to:
  /// **'Today\'s special with the price written clearly.'**
  String get growthIdea2;

  /// No description provided for @growthIdea3.
  ///
  /// In en, this message translates to:
  /// **'A happy regular holding their usual order.'**
  String get growthIdea3;

  /// No description provided for @growthIdea4.
  ///
  /// In en, this message translates to:
  /// **'Behind the counter: how the shop opens each day.'**
  String get growthIdea4;

  /// No description provided for @growthIdea5.
  ///
  /// In en, this message translates to:
  /// **'An offer for the weekend, valid for two days only.'**
  String get growthIdea5;

  /// No description provided for @growthSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get growthSaved;

  /// No description provided for @checklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Opening & closing list'**
  String get checklistTitle;

  /// No description provided for @checklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The small things that spoil a day when forgotten'**
  String get checklistSubtitle;

  /// No description provided for @checklistOpening.
  ///
  /// In en, this message translates to:
  /// **'Before opening'**
  String get checklistOpening;

  /// No description provided for @checklistClosing.
  ///
  /// In en, this message translates to:
  /// **'Before closing'**
  String get checklistClosing;

  /// No description provided for @checklistAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to the list'**
  String get checklistAdd;

  /// No description provided for @checklistItem.
  ///
  /// In en, this message translates to:
  /// **'What to check'**
  String get checklistItem;

  /// No description provided for @checklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the list yet.'**
  String get checklistEmpty;

  /// No description provided for @checklistUseStarter.
  ///
  /// In en, this message translates to:
  /// **'Use a starter list'**
  String get checklistUseStarter;

  /// No description provided for @checklistSeed1.
  ///
  /// In en, this message translates to:
  /// **'Change money kept ready'**
  String get checklistSeed1;

  /// No description provided for @checklistSeed2.
  ///
  /// In en, this message translates to:
  /// **'Gas and milk checked'**
  String get checklistSeed2;

  /// No description provided for @checklistSeed3.
  ///
  /// In en, this message translates to:
  /// **'QR stand and price board out'**
  String get checklistSeed3;

  /// No description provided for @checklistSeed4.
  ///
  /// In en, this message translates to:
  /// **'Cash counted and written down'**
  String get checklistSeed4;

  /// No description provided for @checklistSeed5.
  ///
  /// In en, this message translates to:
  /// **'Fridge, gas and lights switched off'**
  String get checklistSeed5;

  /// No description provided for @jobRemindMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, your order \"{title}\" is ready.'**
  String jobRemindMessage(String name, String title);

  /// No description provided for @customerVisits.
  ///
  /// In en, this message translates to:
  /// **'{count} visits'**
  String customerVisits(String count);

  /// No description provided for @customerToReward.
  ///
  /// In en, this message translates to:
  /// **'{count} more visits'**
  String customerToReward(String count);

  /// No description provided for @growthReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Liked {name}? Please leave a review: {link}'**
  String growthReviewMessage(String name, String link);

  /// No description provided for @growthBroadcastMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} — today\'s menu: {link}'**
  String growthBroadcastMessage(String name, String link);

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String checklistProgress(String done, String total);

  /// No description provided for @movementPrepared.
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get movementPrepared;

  /// No description provided for @recipeShortStock.
  ///
  /// In en, this message translates to:
  /// **'Not enough {item} in stock'**
  String recipeShortStock(String item);

  /// No description provided for @starterIdli.
  ///
  /// In en, this message translates to:
  /// **'Idli'**
  String get starterIdli;

  /// No description provided for @starterDosa.
  ///
  /// In en, this message translates to:
  /// **'Dosa'**
  String get starterDosa;

  /// No description provided for @starterMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get starterMeals;

  /// No description provided for @starterSnackPacket.
  ///
  /// In en, this message translates to:
  /// **'Snack packet'**
  String get starterSnackPacket;

  /// No description provided for @starterWaterBottle.
  ///
  /// In en, this message translates to:
  /// **'Water bottle'**
  String get starterWaterBottle;

  /// No description provided for @starterVegSupply.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get starterVegSupply;

  /// No description provided for @starterGasSupply.
  ///
  /// In en, this message translates to:
  /// **'Gas cylinder'**
  String get starterGasSupply;

  /// No description provided for @checklistSeedHotel.
  ///
  /// In en, this message translates to:
  /// **'Batter, vegetables and gas ready'**
  String get checklistSeedHotel;

  /// No description provided for @checklistSeedCart.
  ///
  /// In en, this message translates to:
  /// **'Cart cleaned and stock loaded'**
  String get checklistSeedCart;

  /// No description provided for @checklistSeedService.
  ///
  /// In en, this message translates to:
  /// **'Tools and change ready'**
  String get checklistSeedService;

  /// No description provided for @presetRecipeTea.
  ///
  /// In en, this message translates to:
  /// **'Shop tea (10 cups)'**
  String get presetRecipeTea;

  /// No description provided for @presetIngredientMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get presetIngredientMilk;

  /// No description provided for @presetIngredientWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get presetIngredientWater;

  /// No description provided for @presetIngredientTeaPowder.
  ///
  /// In en, this message translates to:
  /// **'Tea powder'**
  String get presetIngredientTeaPowder;

  /// No description provided for @presetIngredientSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get presetIngredientSugar;

  /// No description provided for @rolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get rolesTitle;

  /// No description provided for @rolesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who can do what'**
  String get rolesSubtitle;

  /// No description provided for @rolesHint.
  ///
  /// In en, this message translates to:
  /// **'Make a role for each kind of helper, then tick only the work they should be allowed to do.'**
  String get rolesHint;

  /// No description provided for @rolesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No roles yet'**
  String get rolesEmpty;

  /// No description provided for @rolesOpen.
  ///
  /// In en, this message translates to:
  /// **'Open roles'**
  String get rolesOpen;

  /// No description provided for @roleNew.
  ///
  /// In en, this message translates to:
  /// **'New role'**
  String get roleNew;

  /// No description provided for @roleSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested for your shop'**
  String get roleSuggestionsTitle;

  /// No description provided for @roleSuggestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Ready-made roles for your kind of business. Tap one to create it, then adjust.'**
  String get roleSuggestionsHint;

  /// No description provided for @tmplWaiter.
  ///
  /// In en, this message translates to:
  /// **'Waiter'**
  String get tmplWaiter;

  /// No description provided for @tmplKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen / chef'**
  String get tmplKitchen;

  /// No description provided for @tmplCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get tmplCashier;

  /// No description provided for @tmplCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get tmplCounter;

  /// No description provided for @tmplSalesHelper.
  ///
  /// In en, this message translates to:
  /// **'Sales helper'**
  String get tmplSalesHelper;

  /// No description provided for @tmplStockKeeper.
  ///
  /// In en, this message translates to:
  /// **'Stock keeper'**
  String get tmplStockKeeper;

  /// No description provided for @tmplJobAssistant.
  ///
  /// In en, this message translates to:
  /// **'Job assistant'**
  String get tmplJobAssistant;

  /// No description provided for @tmplCounterHelper.
  ///
  /// In en, this message translates to:
  /// **'Counter helper'**
  String get tmplCounterHelper;

  /// No description provided for @tmplAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get tmplAssistant;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleOwnerNote.
  ///
  /// In en, this message translates to:
  /// **'Full access, always'**
  String get roleOwnerNote;

  /// No description provided for @roleInactive.
  ///
  /// In en, this message translates to:
  /// **'Not in use'**
  String get roleInactive;

  /// No description provided for @rolePermissionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} allowed'**
  String rolePermissionCount(String count);

  /// No description provided for @roleEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, duties and limits'**
  String get roleEditSubtitle;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role name'**
  String get roleName;

  /// No description provided for @roleNote.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get roleNote;

  /// No description provided for @roleLimits.
  ///
  /// In en, this message translates to:
  /// **'Money limits (Rs, 0 = no limit)'**
  String get roleLimits;

  /// No description provided for @roleMaxDiscount.
  ///
  /// In en, this message translates to:
  /// **'Biggest discount allowed'**
  String get roleMaxDiscount;

  /// No description provided for @roleMaxCredit.
  ///
  /// In en, this message translates to:
  /// **'Biggest credit allowed'**
  String get roleMaxCredit;

  /// No description provided for @roleMaxRefund.
  ///
  /// In en, this message translates to:
  /// **'Biggest refund allowed'**
  String get roleMaxRefund;

  /// No description provided for @roleLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Above these amounts the owner PIN is needed.'**
  String get roleLimitHint;

  /// No description provided for @roleDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Copy role'**
  String get roleDuplicate;

  /// No description provided for @roleDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Stop using'**
  String get roleDeactivate;

  /// No description provided for @areaSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get areaSales;

  /// No description provided for @areaOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders and kitchen'**
  String get areaOrders;

  /// No description provided for @areaBilling.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get areaBilling;

  /// No description provided for @areaCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get areaCredit;

  /// No description provided for @areaStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get areaStock;

  /// No description provided for @areaPurchases.
  ///
  /// In en, this message translates to:
  /// **'Buying and expenses'**
  String get areaPurchases;

  /// No description provided for @areaMoney.
  ///
  /// In en, this message translates to:
  /// **'Money and reports'**
  String get areaMoney;

  /// No description provided for @areaCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get areaCustomers;

  /// No description provided for @areaStaff.
  ///
  /// In en, this message translates to:
  /// **'Helpers'**
  String get areaStaff;

  /// No description provided for @areaSettings.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get areaSettings;

  /// No description provided for @permRecordSale.
  ///
  /// In en, this message translates to:
  /// **'Record a sale'**
  String get permRecordSale;

  /// No description provided for @permQuickSale.
  ///
  /// In en, this message translates to:
  /// **'Use quick sale'**
  String get permQuickSale;

  /// No description provided for @permCollectUpi.
  ///
  /// In en, this message translates to:
  /// **'Show payment QR'**
  String get permCollectUpi;

  /// No description provided for @permTakeOrder.
  ///
  /// In en, this message translates to:
  /// **'Take an order'**
  String get permTakeOrder;

  /// No description provided for @permChangeOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Move orders along'**
  String get permChangeOrderStatus;

  /// No description provided for @permViewKitchen.
  ///
  /// In en, this message translates to:
  /// **'See kitchen list'**
  String get permViewKitchen;

  /// No description provided for @permEditMenu.
  ///
  /// In en, this message translates to:
  /// **'Change the menu'**
  String get permEditMenu;

  /// No description provided for @permMakeBill.
  ///
  /// In en, this message translates to:
  /// **'Make a bill'**
  String get permMakeBill;

  /// No description provided for @permGiveDiscount.
  ///
  /// In en, this message translates to:
  /// **'Give a discount'**
  String get permGiveDiscount;

  /// No description provided for @permVoidBill.
  ///
  /// In en, this message translates to:
  /// **'Cancel a bill'**
  String get permVoidBill;

  /// No description provided for @permReprintBill.
  ///
  /// In en, this message translates to:
  /// **'Print a bill again'**
  String get permReprintBill;

  /// No description provided for @permGiveCredit.
  ///
  /// In en, this message translates to:
  /// **'Give credit'**
  String get permGiveCredit;

  /// No description provided for @permSettleCredit.
  ///
  /// In en, this message translates to:
  /// **'Settle credit'**
  String get permSettleCredit;

  /// No description provided for @permViewCredit.
  ///
  /// In en, this message translates to:
  /// **'See credit balances'**
  String get permViewCredit;

  /// No description provided for @permViewStock.
  ///
  /// In en, this message translates to:
  /// **'See stock'**
  String get permViewStock;

  /// No description provided for @permAdjustStock.
  ///
  /// In en, this message translates to:
  /// **'Change stock'**
  String get permAdjustStock;

  /// No description provided for @permEditProducts.
  ///
  /// In en, this message translates to:
  /// **'Add or edit items'**
  String get permEditProducts;

  /// No description provided for @permChangePrice.
  ///
  /// In en, this message translates to:
  /// **'Change prices'**
  String get permChangePrice;

  /// No description provided for @permCookRecipe.
  ///
  /// In en, this message translates to:
  /// **'Cook a recipe'**
  String get permCookRecipe;

  /// No description provided for @permRecordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record an expense'**
  String get permRecordExpense;

  /// No description provided for @permManageSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Manage suppliers'**
  String get permManageSuppliers;

  /// No description provided for @permViewDayTotals.
  ///
  /// In en, this message translates to:
  /// **'See day totals'**
  String get permViewDayTotals;

  /// No description provided for @permViewProfit.
  ///
  /// In en, this message translates to:
  /// **'See profit'**
  String get permViewProfit;

  /// No description provided for @permCloseDay.
  ///
  /// In en, this message translates to:
  /// **'Close the day'**
  String get permCloseDay;

  /// No description provided for @permViewReports.
  ///
  /// In en, this message translates to:
  /// **'See reports'**
  String get permViewReports;

  /// No description provided for @permViewCustomers.
  ///
  /// In en, this message translates to:
  /// **'See customers'**
  String get permViewCustomers;

  /// No description provided for @permEditCustomers.
  ///
  /// In en, this message translates to:
  /// **'Edit customers'**
  String get permEditCustomers;

  /// No description provided for @permManageStaff.
  ///
  /// In en, this message translates to:
  /// **'Manage helpers'**
  String get permManageStaff;

  /// No description provided for @permMarkAttendance.
  ///
  /// In en, this message translates to:
  /// **'Mark attendance'**
  String get permMarkAttendance;

  /// No description provided for @permPayWages.
  ///
  /// In en, this message translates to:
  /// **'Pay wages'**
  String get permPayWages;

  /// No description provided for @permManageRoles.
  ///
  /// In en, this message translates to:
  /// **'Create roles'**
  String get permManageRoles;

  /// No description provided for @permViewAudit.
  ///
  /// In en, this message translates to:
  /// **'See the activity trail'**
  String get permViewAudit;

  /// No description provided for @permEditSettings.
  ///
  /// In en, this message translates to:
  /// **'Change settings'**
  String get permEditSettings;

  /// No description provided for @permEditShop.
  ///
  /// In en, this message translates to:
  /// **'Change shop details'**
  String get permEditShop;

  /// No description provided for @permManagePrinters.
  ///
  /// In en, this message translates to:
  /// **'Set up printers'**
  String get permManagePrinters;

  /// No description provided for @accessTitle.
  ///
  /// In en, this message translates to:
  /// **'Access control'**
  String get accessTitle;

  /// No description provided for @accessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shared phone, separate hands'**
  String get accessSubtitle;

  /// No description provided for @accessEnable.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN'**
  String get accessEnable;

  /// No description provided for @accessEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Each helper signs in before using this phone.'**
  String get accessEnableHint;

  /// No description provided for @accessNeedsOwnerPin.
  ///
  /// In en, this message translates to:
  /// **'Set your owner PIN first'**
  String get accessNeedsOwnerPin;

  /// No description provided for @accessOwnerPin.
  ///
  /// In en, this message translates to:
  /// **'Owner PIN'**
  String get accessOwnerPin;

  /// No description provided for @accessOwnerPinSet.
  ///
  /// In en, this message translates to:
  /// **'Set owner PIN (4-6 digits)'**
  String get accessOwnerPinSet;

  /// No description provided for @accessOwnerPinChange.
  ///
  /// In en, this message translates to:
  /// **'Change owner PIN (4-6 digits)'**
  String get accessOwnerPinChange;

  /// No description provided for @accessPinSaved.
  ///
  /// In en, this message translates to:
  /// **'PIN saved'**
  String get accessPinSaved;

  /// No description provided for @accessPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use 4 to 6 digits'**
  String get accessPinInvalid;

  /// No description provided for @accessAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto lock'**
  String get accessAutoLock;

  /// No description provided for @accessIdleMinutes.
  ///
  /// In en, this message translates to:
  /// **'Lock after (minutes, 0 = never)'**
  String get accessIdleMinutes;

  /// No description provided for @accessWorkers.
  ///
  /// In en, this message translates to:
  /// **'Helpers'**
  String get accessWorkers;

  /// No description provided for @accessNoWorkers.
  ///
  /// In en, this message translates to:
  /// **'Add helpers first'**
  String get accessNoWorkers;

  /// No description provided for @accessNoRole.
  ///
  /// In en, this message translates to:
  /// **'No role yet'**
  String get accessNoRole;

  /// No description provided for @accessPinSet.
  ///
  /// In en, this message translates to:
  /// **'PIN set'**
  String get accessPinSet;

  /// No description provided for @accessPinMissing.
  ///
  /// In en, this message translates to:
  /// **'No PIN'**
  String get accessPinMissing;

  /// No description provided for @accessAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Role and PIN'**
  String get accessAssignTitle;

  /// No description provided for @accessWorkerPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN (4-6 digits)'**
  String get accessWorkerPin;

  /// No description provided for @accessSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get accessSaved;

  /// No description provided for @accessEndShift.
  ///
  /// In en, this message translates to:
  /// **'End shift'**
  String get accessEndShift;

  /// No description provided for @accessWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get accessWrongPin;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is on the counter?'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your name and type your PIN'**
  String get lockSubtitle;

  /// No description provided for @lockPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get lockPin;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Start shift'**
  String get lockUnlock;

  /// No description provided for @auditTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity trail'**
  String get auditTitle;

  /// No description provided for @auditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who did what'**
  String get auditSubtitle;

  /// No description provided for @auditOpen.
  ///
  /// In en, this message translates to:
  /// **'Open activity trail'**
  String get auditOpen;

  /// No description provided for @auditEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get auditEveryone;

  /// No description provided for @auditEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get auditEmpty;

  /// No description provided for @auditApproved.
  ///
  /// In en, this message translates to:
  /// **'Owner approved'**
  String get auditApproved;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get settingsGroupBusiness;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get settingsGroupMoney;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'App & devices'**
  String get settingsGroupApp;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get settingsShopTitle;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Payments & UPI'**
  String get settingsPaymentsTitle;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Market prices'**
  String get settingsMarketTitle;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsNotSet;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsOn;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsOff;

  /// Settings hub label
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// Dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Orders, money, credit and stock at a glance
  ///
  /// In en, this message translates to:
  /// **'Orders, money, credit and stock at a glance'**
  String get dashboardSubtitle;

  /// Orders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardOrders;

  /// Pending payments
  ///
  /// In en, this message translates to:
  /// **'Pending payments'**
  String get dashboardPayments;

  /// Credit balances
  ///
  /// In en, this message translates to:
  /// **'Credit balances'**
  String get dashboardCredit;

  /// Inventory
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get dashboardInventory;

  /// Share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dashboardShare;

  /// Placed
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get dashboardPlaced;

  /// Served
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get dashboardServed;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dashboardCancelled;

  /// Open orders
  ///
  /// In en, this message translates to:
  /// **'Open orders'**
  String get dashboardOpenOrders;

  /// Billed
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get dashboardBilled;

  /// Average bill
  ///
  /// In en, this message translates to:
  /// **'Average bill'**
  String get dashboardAvgBill;

  /// Collected
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get dashboardCollected;

  /// Not billed yet
  ///
  /// In en, this message translates to:
  /// **'Not billed yet'**
  String get dashboardUnbilled;

  /// Still to collect
  ///
  /// In en, this message translates to:
  /// **'Still to collect'**
  String get dashboardPendingTotal;

  /// Outstanding
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get dashboardOutstanding;

  /// Credit given
  ///
  /// In en, this message translates to:
  /// **'Credit given'**
  String get dashboardCreditGiven;

  /// Customers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardCustomers;

  /// Oldest due
  ///
  /// In en, this message translates to:
  /// **'Oldest due'**
  String get dashboardOldest;

  /// Age of the oldest unpaid credit balance
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{today} =1{1 day} other{{count} days}}'**
  String dashboardDays(num count);

  /// Stock value
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get dashboardStockValue;

  /// Low stock
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get dashboardLowStock;

  /// Expiring soon
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get dashboardExpiring;

  /// Wastage
  ///
  /// In en, this message translates to:
  /// **'Wastage'**
  String get dashboardWastage;

  /// Purchases
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get dashboardPurchases;

  /// Top items
  ///
  /// In en, this message translates to:
  /// **'Top items'**
  String get dashboardTopItems;

  /// Subscription
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get planTitle;

  /// Cloud features for this shop
  ///
  /// In en, this message translates to:
  /// **'Cloud features for this shop'**
  String get planSubtitle;

  /// Free
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// Pro
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get planPro;

  /// Everything on this phone keeps working for free.
  ///
  /// In en, this message translates to:
  /// **'Everything on this phone keeps working for free.'**
  String get planFreeNote;

  /// Cloud features are active for this shop.
  ///
  /// In en, this message translates to:
  /// **'Cloud features are active for this shop.'**
  String get planProNote;

  /// Cloud features
  ///
  /// In en, this message translates to:
  /// **'Cloud features'**
  String get planCloudFeatures;

  /// Cloud shop account
  ///
  /// In en, this message translates to:
  /// **'Cloud shop account'**
  String get planFeatureAccount;

  /// Live order board sync
  ///
  /// In en, this message translates to:
  /// **'Live order board sync'**
  String get planFeatureLiveSync;

  /// QR menu ordering
  ///
  /// In en, this message translates to:
  /// **'QR menu ordering'**
  String get planFeatureQrOrdering;

  /// Shareable links
  ///
  /// In en, this message translates to:
  /// **'Shareable links'**
  String get planFeatureShareLinks;

  /// Cloud soundbox
  ///
  /// In en, this message translates to:
  /// **'Cloud soundbox'**
  String get planFeatureSoundbox;

  /// Multi-device backup
  ///
  /// In en, this message translates to:
  /// **'Multi-device backup'**
  String get planFeatureBackup;

  /// On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get planOn;

  /// Locked
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get planLocked;

  /// Check subscription
  ///
  /// In en, this message translates to:
  /// **'Check subscription'**
  String get planRefresh;

  /// Checking…
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get planChecking;

  /// Could not check right now. Last known status is used.
  ///
  /// In en, this message translates to:
  /// **'Could not check right now. Last known status is used.'**
  String get planCheckFailed;

  /// Set up the cloud shop first.
  ///
  /// In en, this message translates to:
  /// **'Set up the cloud shop first.'**
  String get planNeedsShop;

  /// Offline for a few days is fine — cloud features keep working during the grace period.
  ///
  /// In en, this message translates to:
  /// **'Offline for a few days is fine — cloud features keep working during the grace period.'**
  String get planOfflineNote;

  /// My shop
  ///
  /// In en, this message translates to:
  /// **'My shop'**
  String get shopTitle;

  /// Workflow made for your trade
  ///
  /// In en, this message translates to:
  /// **'Workflow made for your trade'**
  String get shopSubtitle;

  /// Shop type
  ///
  /// In en, this message translates to:
  /// **'Shop type'**
  String get shopPickType;

  /// Daily workflow
  ///
  /// In en, this message translates to:
  /// **'Daily workflow'**
  String get shopWorkflow;

  /// Restaurant
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get shopTypeRestaurant;

  /// Hotel
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get shopTypeHotel;

  /// Street stall
  ///
  /// In en, this message translates to:
  /// **'Street stall'**
  String get shopTypeStreet;

  /// DIY / craft stall
  ///
  /// In en, this message translates to:
  /// **'DIY / craft stall'**
  String get shopTypeDiy;

  /// Fridge magnet stall
  ///
  /// In en, this message translates to:
  /// **'Fridge magnet stall'**
  String get shopTypeMagnet;

  /// Tea shop
  ///
  /// In en, this message translates to:
  /// **'Tea shop'**
  String get shopTypeTea;

  /// Ordering rules
  ///
  /// In en, this message translates to:
  /// **'Ordering rules'**
  String get settingsOrderingTitle;

  /// Service style, payment timing, table buttons
  ///
  /// In en, this message translates to:
  /// **'Service style, payment timing, table buttons'**
  String get settingsOrderingSubtitle;

  /// Service style
  ///
  /// In en, this message translates to:
  /// **'Service style'**
  String get serviceStyle;

  /// Table service
  ///
  /// In en, this message translates to:
  /// **'Table service'**
  String get serviceTable;

  /// Self service
  ///
  /// In en, this message translates to:
  /// **'Self service'**
  String get serviceSelf;

  /// Takeaway only
  ///
  /// In en, this message translates to:
  /// **'Takeaway only'**
  String get serviceTakeaway;

  /// Payment timing
  ///
  /// In en, this message translates to:
  /// **'Payment timing'**
  String get paymentTiming;

  /// Pay first
  ///
  /// In en, this message translates to:
  /// **'Pay first'**
  String get payBefore;

  /// Pay after
  ///
  /// In en, this message translates to:
  /// **'Pay after'**
  String get payAfter;

  /// Pay first asks the customer to pay before the order is confirmed. Pay after sends it to the kitchen straight away.
  ///
  /// In en, this message translates to:
  /// **'Pay first asks the customer to pay before the order is confirmed. Pay after sends it to the kitchen straight away.'**
  String get payTimingHelp;

  /// Buttons on the customer screen
  ///
  /// In en, this message translates to:
  /// **'Buttons on the customer screen'**
  String get customerButtons;

  /// Call staff
  ///
  /// In en, this message translates to:
  /// **'Call staff'**
  String get allowCallStaff;

  /// Ask for the bill
  ///
  /// In en, this message translates to:
  /// **'Ask for the bill'**
  String get allowRequestBill;

  /// These appear only with table service.
  ///
  /// In en, this message translates to:
  /// **'These appear only with table service.'**
  String get customerButtonsHelp;

  /// Staff needed
  ///
  /// In en, this message translates to:
  /// **'Staff needed'**
  String get requestCallStaff;

  /// Bill please
  ///
  /// In en, this message translates to:
  /// **'Bill please'**
  String get requestBill;

  /// Table label
  ///
  /// In en, this message translates to:
  /// **'Table {table}'**
  String requestTable(String table);

  /// Counter
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get requestCounter;

  /// Seen
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get requestSeen;

  /// Awaiting payment
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get payStateAwaiting;

  /// Pay at counter
  ///
  /// In en, this message translates to:
  /// **'Pay at counter'**
  String get payStateDue;

  /// Paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payStatePaid;

  /// Mark paid
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get orderMarkPaid;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Phones & devices'**
  String get devicesTitle;

  /// No description provided for @devicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Waiter, kitchen and counter phones on one board'**
  String get devicesSubtitle;

  /// No description provided for @devicesPairThis.
  ///
  /// In en, this message translates to:
  /// **'Pair this phone'**
  String get devicesPairThis;

  /// No description provided for @devicesShopSlug.
  ///
  /// In en, this message translates to:
  /// **'Shop name (menu link word)'**
  String get devicesShopSlug;

  /// No description provided for @devicesEnterCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code from the owner'**
  String get devicesEnterCode;

  /// No description provided for @devicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone name'**
  String get devicesLabel;

  /// No description provided for @devicesPairButton.
  ///
  /// In en, this message translates to:
  /// **'Pair phone'**
  String get devicesPairButton;

  /// No description provided for @devicesPairSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone paired to the shop'**
  String get devicesPairSuccess;

  /// No description provided for @devicesUnpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair this phone'**
  String get devicesUnpair;

  /// No description provided for @devicesPairedAs.
  ///
  /// In en, this message translates to:
  /// **'Paired as {role} · {shop}'**
  String devicesPairedAs(String role, String shop);

  /// No description provided for @devicesNewCode.
  ///
  /// In en, this message translates to:
  /// **'New pairing code'**
  String get devicesNewCode;

  /// No description provided for @devicesCodeExpires.
  ///
  /// In en, this message translates to:
  /// **'Valid for 15 minutes · tap to copy'**
  String get devicesCodeExpires;

  /// No description provided for @devicesList.
  ///
  /// In en, this message translates to:
  /// **'Paired phones'**
  String get devicesList;

  /// No description provided for @devicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No phones paired yet'**
  String get devicesEmpty;

  /// No description provided for @devicesRevoke.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get devicesRevoke;

  /// No description provided for @devicesRevoked.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get devicesRevoked;

  /// No description provided for @devicesOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get devicesOnline;

  /// No description provided for @devicesOffline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get devicesOffline;

  /// No description provided for @devicesRoleWaiter.
  ///
  /// In en, this message translates to:
  /// **'Waiter'**
  String get devicesRoleWaiter;

  /// No description provided for @devicesRoleKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get devicesRoleKitchen;

  /// No description provided for @devicesRoleCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get devicesRoleCounter;

  /// No description provided for @devicesProRequired.
  ///
  /// In en, this message translates to:
  /// **'Multi-device sync is a Pro feature. Upgrade to connect waiter, kitchen and counter phones.'**
  String get devicesProRequired;

  /// No description provided for @cloudShopSection.
  ///
  /// In en, this message translates to:
  /// **'Cloud shop'**
  String get cloudShopSection;

  /// No description provided for @cloudShopHint.
  ///
  /// In en, this message translates to:
  /// **'Create your shop on the server so QR menu orders and staff phones share one live order list.'**
  String get cloudShopHint;

  /// No description provided for @cloudShopSlug.
  ///
  /// In en, this message translates to:
  /// **'Shop name for links (e.g. sirpam-tea)'**
  String get cloudShopSlug;

  /// No description provided for @cloudShopKey.
  ///
  /// In en, this message translates to:
  /// **'Shop key (private, 16+ characters)'**
  String get cloudShopKey;

  /// No description provided for @cloudShopGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate key'**
  String get cloudShopGenerate;

  /// No description provided for @cloudShopCreate.
  ///
  /// In en, this message translates to:
  /// **'Create cloud shop'**
  String get cloudShopCreate;

  /// No description provided for @cloudShopUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update cloud shop'**
  String get cloudShopUpdate;

  /// No description provided for @cloudShopLive.
  ///
  /// In en, this message translates to:
  /// **'Cloud shop ready: {slug}'**
  String cloudShopLive(String slug);

  /// No description provided for @cloudShopNone.
  ///
  /// In en, this message translates to:
  /// **'No cloud shop yet. Create one to use QR ordering and staff phones.'**
  String get cloudShopNone;

  /// No description provided for @cloudShopCreated.
  ///
  /// In en, this message translates to:
  /// **'Cloud shop created'**
  String get cloudShopCreated;

  /// No description provided for @cloudShopKeyShort.
  ///
  /// In en, this message translates to:
  /// **'Enter a shop name and a key of at least 16 characters.'**
  String get cloudShopKeyShort;

  /// No description provided for @cloudShopCopyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get cloudShopCopyKey;

  /// No description provided for @cloudShopKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Shop key copied'**
  String get cloudShopKeyCopied;

  /// No description provided for @approvalTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner approval'**
  String get approvalTitle;

  /// No description provided for @approvalNeeded.
  ///
  /// In en, this message translates to:
  /// **'This shift cannot do this: {action}. The owner can allow it once.'**
  String approvalNeeded(String action);

  /// No description provided for @approvalOverLimit.
  ///
  /// In en, this message translates to:
  /// **'This is above the limit for this shift: {action}. The owner can allow it once.'**
  String approvalOverLimit(String action);

  /// No description provided for @approvalOwnerPin.
  ///
  /// In en, this message translates to:
  /// **'Owner PIN'**
  String get approvalOwnerPin;

  /// No description provided for @approvalApprove.
  ///
  /// In en, this message translates to:
  /// **'Allow once'**
  String get approvalApprove;

  /// No description provided for @approvalGranted.
  ///
  /// In en, this message translates to:
  /// **'Owner approved this action'**
  String get approvalGranted;

  /// No description provided for @approvalWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong owner PIN'**
  String get approvalWrongPin;

  /// No description provided for @approvalBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not allowed'**
  String get approvalBlockedTitle;

  /// No description provided for @approvalBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'This shift does not have access to {action}. Ask the owner to change the role.'**
  String approvalBlockedBody(String action);

  /// No description provided for @recurringRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get recurringRemove;

  /// No description provided for @recurringRemoved.
  ///
  /// In en, this message translates to:
  /// **'Recurring cost removed'**
  String get recurringRemoved;

  /// No description provided for @recurringRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from recurring costs?'**
  String recurringRemoveConfirm(String name);

  /// No description provided for @orderEditItems.
  ///
  /// In en, this message translates to:
  /// **'Edit items'**
  String get orderEditItems;

  /// No description provided for @orderEditItemsSaved.
  ///
  /// In en, this message translates to:
  /// **'Order items updated'**
  String get orderEditItemsSaved;

  /// No description provided for @orderEditEmpty.
  ///
  /// In en, this message translates to:
  /// **'An order needs at least one item.'**
  String get orderEditEmpty;

  /// No description provided for @printerStatus.
  ///
  /// In en, this message translates to:
  /// **'Printer status'**
  String get printerStatus;

  /// No description provided for @printerNotConnected.
  ///
  /// In en, this message translates to:
  /// **'No printer connected'**
  String get printerNotConnected;

  /// No description provided for @printerConnectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {name}'**
  String printerConnectedTo(String name);

  /// No description provided for @printerDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get printerDisconnect;

  /// No description provided for @printerDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Printer disconnected'**
  String get printerDisconnected;

  /// No description provided for @printerForget.
  ///
  /// In en, this message translates to:
  /// **'Forget printer'**
  String get printerForget;

  /// No description provided for @printerForgotten.
  ///
  /// In en, this message translates to:
  /// **'Printer removed. Bills will be shared as PDF.'**
  String get printerForgotten;

  /// No description provided for @printerUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This phone cannot print over Bluetooth.'**
  String get printerUnsupported;

  /// No description provided for @printerPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow Bluetooth so the app can see your printer.'**
  String get printerPermissionNeeded;

  /// No description provided for @printerPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission was not given.'**
  String get printerPermissionDenied;

  /// No description provided for @printerAllowBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Allow Bluetooth'**
  String get printerAllowBluetooth;

  /// No description provided for @devicesTest.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get devicesTest;

  /// No description provided for @devicesTestOk.
  ///
  /// In en, this message translates to:
  /// **'Connected to the shop'**
  String get devicesTestOk;

  /// No description provided for @devicesTestFailed.
  ///
  /// In en, this message translates to:
  /// **'This phone is not connected. Ask the owner for a new code.'**
  String get devicesTestFailed;

  /// No description provided for @stockLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stock last updated {when}'**
  String stockLastUpdated(String when);

  /// No description provided for @agoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get agoJustNow;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String agoMinutes(int count);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String agoHours(int count);

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String agoDays(int count);

  /// No description provided for @prepTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning prep'**
  String get prepTitle;

  /// No description provided for @prepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What must be ready before the first customer'**
  String get prepSubtitle;

  /// No description provided for @prepPending.
  ///
  /// In en, this message translates to:
  /// **'{count} still to prepare'**
  String prepPending(String count);

  /// No description provided for @prepUseStarter.
  ///
  /// In en, this message translates to:
  /// **'Use a starter sheet'**
  String get prepUseStarter;

  /// No description provided for @prepTodaySheet.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sheet'**
  String get prepTodaySheet;

  /// No description provided for @prepAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a prep item'**
  String get prepAddTitle;

  /// No description provided for @prepItemName.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get prepItemName;

  /// No description provided for @prepPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get prepPlanned;

  /// No description provided for @prepMade.
  ///
  /// In en, this message translates to:
  /// **'Made'**
  String get prepMade;

  /// No description provided for @prepUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get prepUnit;

  /// No description provided for @prepAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to sheet'**
  String get prepAdd;

  /// No description provided for @prepShort.
  ///
  /// In en, this message translates to:
  /// **'{qty} short'**
  String prepShort(String qty);

  /// No description provided for @prepProgressLine.
  ///
  /// In en, this message translates to:
  /// **'{made} of {planned} {unit}'**
  String prepProgressLine(String made, String planned, String unit);

  /// No description provided for @prepSeedMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get prepSeedMilk;

  /// No description provided for @prepSeedBatter.
  ///
  /// In en, this message translates to:
  /// **'Batter / dough'**
  String get prepSeedBatter;

  /// No description provided for @prepSeedSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get prepSeedSnacks;

  /// No description provided for @prepSeedChange.
  ///
  /// In en, this message translates to:
  /// **'Change money'**
  String get prepSeedChange;

  /// No description provided for @prepSeedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Set up display'**
  String get prepSeedDisplay;

  /// No description provided for @prepSeedStock.
  ///
  /// In en, this message translates to:
  /// **'Fill shelves'**
  String get prepSeedStock;

  /// No description provided for @prepUnitLitre.
  ///
  /// In en, this message translates to:
  /// **'litre'**
  String get prepUnitLitre;

  /// No description provided for @prepUnitPlate.
  ///
  /// In en, this message translates to:
  /// **'plate'**
  String get prepUnitPlate;

  /// No description provided for @prepUnitPiece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get prepUnitPiece;

  /// No description provided for @prepUnitRupee.
  ///
  /// In en, this message translates to:
  /// **'rupee'**
  String get prepUnitRupee;

  /// No description provided for @insightsRush.
  ///
  /// In en, this message translates to:
  /// **'Rush hours'**
  String get insightsRush;

  /// No description provided for @insightsHour.
  ///
  /// In en, this message translates to:
  /// **'{hour}:00'**
  String insightsHour(String hour);

  /// No description provided for @insightsPeakHint.
  ///
  /// In en, this message translates to:
  /// **'Busiest at {hour}:00 with {bills} bills — keep {staff} at the counter'**
  String insightsPeakHint(String hour, String bills, String staff);

  /// No description provided for @dayCloseOpeningCash.
  ///
  /// In en, this message translates to:
  /// **'Opening cash'**
  String get dayCloseOpeningCash;

  /// No description provided for @quickSaleSoldOutOn.
  ///
  /// In en, this message translates to:
  /// **'{item} marked sold out'**
  String quickSaleSoldOutOn(String item);

  /// No description provided for @quickSaleSoldOutOff.
  ///
  /// In en, this message translates to:
  /// **'{item} is back on sale'**
  String quickSaleSoldOutOff(String item);

  /// No description provided for @insightsHeroes.
  ///
  /// In en, this message translates to:
  /// **'Today\'s heroes'**
  String get insightsHeroes;

  /// No description provided for @insightsHeroLine.
  ///
  /// In en, this message translates to:
  /// **'{sold} sold · {left} left'**
  String insightsHeroLine(String sold, String left);

  /// No description provided for @insightsHeroRunsOut.
  ///
  /// In en, this message translates to:
  /// **'runs out around {hour}:00'**
  String insightsHeroRunsOut(String hour);

  /// No description provided for @customerLapsedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not seen lately'**
  String get customerLapsedTitle;

  /// No description provided for @customerLapsedHint.
  ///
  /// In en, this message translates to:
  /// **'A short message brings most of them back.'**
  String get customerLapsedHint;

  /// No description provided for @customerLapsedDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days since last visit'**
  String customerLapsedDays(String days);

  /// No description provided for @customerNudge.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get customerNudge;

  /// No description provided for @customerNudgeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, we miss you at {shop}! Something fresh is waiting for you this week.'**
  String customerNudgeMessage(String name, String shop);

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitle;

  /// No description provided for @offersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discounts you run, and what each one costs you.'**
  String get offersSubtitle;

  /// No description provided for @offerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add an offer'**
  String get offerAdd;

  /// No description provided for @offerName.
  ///
  /// In en, this message translates to:
  /// **'Offer name'**
  String get offerName;

  /// No description provided for @offerCode.
  ///
  /// In en, this message translates to:
  /// **'Code the customer says (optional)'**
  String get offerCode;

  /// No description provided for @offerKindFlat.
  ///
  /// In en, this message translates to:
  /// **'Rupees off'**
  String get offerKindFlat;

  /// No description provided for @offerKindPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent off'**
  String get offerKindPercent;

  /// No description provided for @offerKindCombo.
  ///
  /// In en, this message translates to:
  /// **'Combo price'**
  String get offerKindCombo;

  /// No description provided for @offerAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount off'**
  String get offerAmount;

  /// No description provided for @offerPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent off'**
  String get offerPercent;

  /// No description provided for @offerComboPrice.
  ///
  /// In en, this message translates to:
  /// **'Combo price'**
  String get offerComboPrice;

  /// No description provided for @offersGivenTotal.
  ///
  /// In en, this message translates to:
  /// **'Given away so far'**
  String get offersGivenTotal;

  /// No description provided for @offersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No offers yet. Add one and it shows up on the bill.'**
  String get offersEmpty;

  /// No description provided for @offerLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get offerLive;

  /// No description provided for @offerPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get offerPaused;

  /// No description provided for @offerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get offerPause;

  /// No description provided for @offerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get offerResume;

  /// No description provided for @offerUsed.
  ///
  /// In en, this message translates to:
  /// **'Used {count} times'**
  String offerUsed(String count);

  /// No description provided for @offerGivenAway.
  ///
  /// In en, this message translates to:
  /// **'{amount} given away'**
  String offerGivenAway(String amount);

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A three-tap rating after paying, straight to you.'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Counter QR'**
  String get feedbackQrTitle;

  /// No description provided for @feedbackQrHint.
  ///
  /// In en, this message translates to:
  /// **'Print this and keep it on the counter, or show it after payment.'**
  String get feedbackQrHint;

  /// No description provided for @feedbackReviewMissing.
  ///
  /// In en, this message translates to:
  /// **'Add your review page link in Growth so happy customers can post it publicly.'**
  String get feedbackReviewMissing;

  /// No description provided for @feedbackLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get feedbackLinkCopied;

  /// No description provided for @feedbackScores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get feedbackScores;

  /// No description provided for @feedbackTodayAvg.
  ///
  /// In en, this message translates to:
  /// **'Today (average · count)'**
  String get feedbackTodayAvg;

  /// No description provided for @feedbackWeekAvg.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days (average · count)'**
  String get feedbackWeekAvg;

  /// No description provided for @feedbackNeedsReply.
  ///
  /// In en, this message translates to:
  /// **'Needs a reply'**
  String get feedbackNeedsReply;

  /// No description provided for @feedbackRecord.
  ///
  /// In en, this message translates to:
  /// **'Add a rating yourself'**
  String get feedbackRecord;

  /// No description provided for @feedbackHappy.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get feedbackHappy;

  /// No description provided for @feedbackOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get feedbackOkay;

  /// No description provided for @feedbackUnhappy.
  ///
  /// In en, this message translates to:
  /// **'Not good'**
  String get feedbackUnhappy;

  /// No description provided for @feedbackRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent ratings'**
  String get feedbackRecent;

  /// No description provided for @feedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet.'**
  String get feedbackEmpty;

  /// No description provided for @enquiriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get enquiriesTitle;

  /// No description provided for @enquiriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who asked, what you quoted, and what came of it.'**
  String get enquiriesSubtitle;

  /// No description provided for @enquiryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add an enquiry'**
  String get enquiryAdd;

  /// No description provided for @enquiryName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get enquiryName;

  /// No description provided for @enquiryPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get enquiryPhone;

  /// No description provided for @enquiryWant.
  ///
  /// In en, this message translates to:
  /// **'What they asked for'**
  String get enquiryWant;

  /// No description provided for @enquiryQuote.
  ///
  /// In en, this message translates to:
  /// **'Price you quoted'**
  String get enquiryQuote;

  /// No description provided for @enquiryNoFollowUp.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get enquiryNoFollowUp;

  /// No description provided for @enquiryFollowUpDays.
  ///
  /// In en, this message translates to:
  /// **'Follow up in {days} days'**
  String enquiryFollowUpDays(String days);

  /// No description provided for @enquiryWinRate.
  ///
  /// In en, this message translates to:
  /// **'{rate}% turn into sales'**
  String enquiryWinRate(String rate);

  /// No description provided for @enquiryWonValue.
  ///
  /// In en, this message translates to:
  /// **'Value won'**
  String get enquiryWonValue;

  /// No description provided for @enquiryFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get enquiryFilterToday;

  /// No description provided for @enquiryFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get enquiryFilterOpen;

  /// No description provided for @enquiryFilterWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get enquiryFilterWon;

  /// No description provided for @enquiryFilterLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get enquiryFilterLost;

  /// No description provided for @enquiryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get enquiryEmpty;

  /// No description provided for @enquiryFollowUpOn.
  ///
  /// In en, this message translates to:
  /// **'Follow up on {day}'**
  String enquiryFollowUpOn(String day);

  /// No description provided for @enquiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get enquiryMessage;

  /// No description provided for @enquiryMessageText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, following up about {item}. Shall I keep it ready for you?'**
  String enquiryMessageText(String name, String item);

  /// No description provided for @enquiryWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get enquiryWon;

  /// No description provided for @enquiryLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get enquiryLost;

  /// No description provided for @enquiryReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get enquiryReopen;

  /// No description provided for @customerRewardsDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards due'**
  String get customerRewardsDueTitle;

  /// No description provided for @cloudShopSlugTaken.
  ///
  /// In en, this message translates to:
  /// **'That link name is already taken. Try something like {slug}.'**
  String cloudShopSlugTaken(String slug);

  /// No description provided for @cloudShopSlugInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use small letters, numbers and dashes only, at least 3 characters.'**
  String get cloudShopSlugInvalid;

  /// No description provided for @cloudShopOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet just now. Check the connection and try again.'**
  String get cloudShopOffline;

  /// No description provided for @cloudShopTryAgain.
  ///
  /// In en, this message translates to:
  /// **'That did not go through. Please try again in a moment.'**
  String get cloudShopTryAgain;

  /// No description provided for @cloudShopLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer link'**
  String get cloudShopLinkTitle;

  /// No description provided for @cloudShopCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get cloudShopCopyLink;

  /// No description provided for @cloudShopLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get cloudShopLinkCopied;

  /// No description provided for @cloudShopShowQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get cloudShopShowQr;

  /// No description provided for @paymentQrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Use your payment app QR'**
  String get paymentQrScanTitle;

  /// No description provided for @paymentQrScanAction.
  ///
  /// In en, this message translates to:
  /// **'Scan my QR'**
  String get paymentQrScanAction;

  /// No description provided for @paymentQrScanHelp.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR sticker from GPay, PhonePe or Paytm. We read the UPI ID from it, so bills and the counter QR pay into the same account.'**
  String get paymentQrScanHelp;

  /// No description provided for @paymentQrScanFound.
  ///
  /// In en, this message translates to:
  /// **'UPI ID taken from your QR: {vpa}'**
  String paymentQrScanFound(String vpa);

  /// No description provided for @paymentQrScanNoUpi.
  ///
  /// In en, this message translates to:
  /// **'That is not a payment QR. Try the QR shown inside your payment app.'**
  String get paymentQrScanNoUpi;

  /// No description provided for @receiptFeedbackLine.
  ///
  /// In en, this message translates to:
  /// **'Scan to tell us how it was'**
  String get receiptFeedbackLine;

  /// No description provided for @qrPrintCounterCard.
  ///
  /// In en, this message translates to:
  /// **'Print counter card'**
  String get qrPrintCounterCard;

  /// No description provided for @qrPayCaption.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay'**
  String get qrPayCaption;

  /// No description provided for @qrFeedbackCaption.
  ///
  /// In en, this message translates to:
  /// **'Scan to rate us'**
  String get qrFeedbackCaption;

  /// No description provided for @offerPrintCards.
  ///
  /// In en, this message translates to:
  /// **'Print offer cards'**
  String get offerPrintCards;

  /// No description provided for @offerCardCaption.
  ///
  /// In en, this message translates to:
  /// **'Scan to open this offer'**
  String get offerCardCaption;

  /// No description provided for @devicesPairQrHint.
  ///
  /// In en, this message translates to:
  /// **'Let the new phone scan this'**
  String get devicesPairQrHint;

  /// No description provided for @devicesScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan pairing QR'**
  String get devicesScanQr;

  /// No description provided for @devicesScanInvalid.
  ///
  /// In en, this message translates to:
  /// **'That is not a pairing QR. Ask the owner to show it again.'**
  String get devicesScanInvalid;

  /// No description provided for @quickSaleScan.
  ///
  /// In en, this message translates to:
  /// **'Scan item'**
  String get quickSaleScan;

  /// No description provided for @quickSaleScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the item label'**
  String get quickSaleScanTitle;

  /// No description provided for @quickSaleScanUnknown.
  ///
  /// In en, this message translates to:
  /// **'No item found for code {code}. Add it in Products.'**
  String quickSaleScanUnknown(String code);

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & export'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep a copy of your books safe'**
  String get backupSubtitle;

  /// No description provided for @backupNowAction.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNowAction;

  /// No description provided for @backupRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore from file'**
  String get backupRestoreAction;

  /// No description provided for @backupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'VendorOS backup'**
  String get backupShareSubject;

  /// No description provided for @backupSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Backup file created'**
  String get backupSavedToast;

  /// No description provided for @backupFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Could not create the backup. Please try again.'**
  String get backupFailedToast;

  /// No description provided for @backupRestoredToast.
  ///
  /// In en, this message translates to:
  /// **'Your books have been restored'**
  String get backupRestoredToast;

  /// No description provided for @backupNeverSaved.
  ///
  /// In en, this message translates to:
  /// **'You have never backed up'**
  String get backupNeverSaved;

  /// No description provided for @backupLastSaved.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String backupLastSaved(String when);

  /// No description provided for @backupSizeHint.
  ///
  /// In en, this message translates to:
  /// **'About {kb} KB will be saved'**
  String backupSizeHint(int kb);

  /// No description provided for @backupRestoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces everything on this phone with the file.'**
  String get backupRestoreWarning;

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupRestoreConfirmTitle;

  /// No description provided for @backupRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{rows} entries from {when} will replace what is on this phone.'**
  String backupRestoreConfirmBody(int rows, String when);

  /// No description provided for @backupErrorNotFile.
  ///
  /// In en, this message translates to:
  /// **'This is not a VendorOS backup file.'**
  String get backupErrorNotFile;

  /// No description provided for @backupErrorTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version. Please update the app first.'**
  String get backupErrorTooNew;

  /// No description provided for @backupErrorCorrupt.
  ///
  /// In en, this message translates to:
  /// **'This backup file is damaged and cannot be used.'**
  String get backupErrorCorrupt;

  /// No description provided for @backupErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'The file is empty.'**
  String get backupErrorEmpty;

  /// No description provided for @exportGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Export as spreadsheet'**
  String get exportGroupLabel;

  /// No description provided for @exportSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get exportSalesTitle;

  /// No description provided for @exportSalesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every sale with date, item and amount'**
  String get exportSalesSubtitle;

  /// No description provided for @exportBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get exportBillsTitle;

  /// No description provided for @exportBillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bill-wise totals, discount and tax'**
  String get exportBillsSubtitle;

  /// No description provided for @exportCreditTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit balances'**
  String get exportCreditTitle;

  /// No description provided for @exportCreditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who still owes you and how much'**
  String get exportCreditSubtitle;

  /// No description provided for @exportStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get exportStockTitle;

  /// No description provided for @exportStockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items, quantity on hand and prices'**
  String get exportStockSubtitle;

  /// No description provided for @exportColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get exportColDate;

  /// No description provided for @exportColItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get exportColItem;

  /// No description provided for @exportColMode.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get exportColMode;

  /// No description provided for @exportColCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get exportColCustomer;

  /// No description provided for @exportColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get exportColAmount;

  /// No description provided for @exportColBillNo.
  ///
  /// In en, this message translates to:
  /// **'Bill no'**
  String get exportColBillNo;

  /// No description provided for @exportColSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get exportColSubtotal;

  /// No description provided for @exportColDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get exportColDiscount;

  /// No description provided for @exportColTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get exportColTax;

  /// No description provided for @exportColTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get exportColTotal;

  /// No description provided for @exportColPayment.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get exportColPayment;

  /// No description provided for @exportColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get exportColStatus;

  /// No description provided for @exportColBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get exportColBalance;

  /// No description provided for @exportColCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get exportColCode;

  /// No description provided for @exportColCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exportColCategory;

  /// No description provided for @exportColUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get exportColUnit;

  /// No description provided for @exportColQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get exportColQty;

  /// No description provided for @exportColCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get exportColCost;

  /// No description provided for @exportColPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get exportColPrice;

  /// No description provided for @gstReportTitle.
  ///
  /// In en, this message translates to:
  /// **'GST summary'**
  String get gstReportTitle;

  /// No description provided for @gstReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Month-wise tax for your accountant'**
  String get gstReportSubtitle;

  /// No description provided for @gstReportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No GST bills yet. Turn on GST in Menu settings, then bill an item.'**
  String get gstReportEmpty;

  /// No description provided for @gstColMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get gstColMonth;

  /// No description provided for @gstColRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get gstColRate;

  /// No description provided for @gstColTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable value'**
  String get gstColTaxable;

  /// No description provided for @gstColTax.
  ///
  /// In en, this message translates to:
  /// **'Total tax'**
  String get gstColTax;

  /// No description provided for @gstBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get gstBills;

  /// No description provided for @gstSales.
  ///
  /// In en, this message translates to:
  /// **'Sales with tax'**
  String get gstSales;

  /// No description provided for @gstByRate.
  ///
  /// In en, this message translates to:
  /// **'By rate'**
  String get gstByRate;

  /// No description provided for @gstShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share spreadsheet'**
  String get gstShareAction;

  /// No description provided for @gstShareSubject.
  ///
  /// In en, this message translates to:
  /// **'GST summary {month}'**
  String gstShareSubject(String month);

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light or dark screen'**
  String get appearanceSubtitle;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'Match phone'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceChanged.
  ///
  /// In en, this message translates to:
  /// **'Appearance updated'**
  String get appearanceChanged;

  /// No description provided for @purchasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchasesTitle;

  /// No description provided for @purchasesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier bills and what you still owe'**
  String get purchasesSubtitle;

  /// No description provided for @purchasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchase bills yet. Add the last stock you bought.'**
  String get purchasesEmpty;

  /// No description provided for @purchaseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add purchase'**
  String get purchaseAdd;

  /// No description provided for @purchaseTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Owed to suppliers'**
  String get purchaseTotalDue;

  /// No description provided for @purchaseMonthSpend.
  ///
  /// In en, this message translates to:
  /// **'Bought this month'**
  String get purchaseMonthSpend;

  /// No description provided for @purchaseDuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier dues'**
  String get purchaseDuesTitle;

  /// No description provided for @purchaseNoDues.
  ///
  /// In en, this message translates to:
  /// **'All supplier bills are paid.'**
  String get purchaseNoDues;

  /// No description provided for @purchaseDueBills.
  ///
  /// In en, this message translates to:
  /// **'{bills} bill(s) · oldest {days} day(s)'**
  String purchaseDueBills(int bills, int days);

  /// No description provided for @purchaseBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase bills'**
  String get purchaseBillsTitle;

  /// No description provided for @purchasePaidFull.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get purchasePaidFull;

  /// No description provided for @purchaseDueOf.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String purchaseDueOf(String amount);

  /// No description provided for @purchaseSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get purchaseSupplier;

  /// No description provided for @purchasePayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay {name}'**
  String purchasePayTitle(String name);

  /// No description provided for @purchasePayAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get purchasePayAmount;

  /// No description provided for @purchasePay.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get purchasePay;

  /// No description provided for @purchaseSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Item total'**
  String get purchaseSubtotal;

  /// No description provided for @purchaseTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get purchaseTax;

  /// No description provided for @purchaseTotal.
  ///
  /// In en, this message translates to:
  /// **'Bill total'**
  String get purchaseTotal;

  /// No description provided for @purchaseDue.
  ///
  /// In en, this message translates to:
  /// **'Still due'**
  String get purchaseDue;

  /// No description provided for @purchaseNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New purchase bill'**
  String get purchaseNewTitle;

  /// No description provided for @purchaseInvoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Bill number'**
  String get purchaseInvoiceNo;

  /// No description provided for @purchaseItems.
  ///
  /// In en, this message translates to:
  /// **'Items bought'**
  String get purchaseItems;

  /// No description provided for @purchaseLinkProduct.
  ///
  /// In en, this message translates to:
  /// **'Pick from your stock list'**
  String get purchaseLinkProduct;

  /// No description provided for @purchaseFreeItem.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get purchaseFreeItem;

  /// No description provided for @purchaseQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get purchaseQty;

  /// No description provided for @purchaseUnitCost.
  ///
  /// In en, this message translates to:
  /// **'Cost per unit'**
  String get purchaseUnitCost;

  /// No description provided for @purchaseAddLine.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get purchaseAddLine;

  /// No description provided for @purchasePaidNow.
  ///
  /// In en, this message translates to:
  /// **'Paid now'**
  String get purchasePaidNow;

  /// No description provided for @purchaseNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get purchaseNote;

  /// No description provided for @purchaseSaved.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved and stock updated'**
  String get purchaseSaved;

  /// No description provided for @permRecordPurchase.
  ///
  /// In en, this message translates to:
  /// **'Record purchase bills'**
  String get permRecordPurchase;

  /// No description provided for @permPaySupplier.
  ///
  /// In en, this message translates to:
  /// **'Pay suppliers'**
  String get permPaySupplier;

  /// No description provided for @backupCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Online backup'**
  String get backupCloudTitle;

  /// No description provided for @backupCloudLast.
  ///
  /// In en, this message translates to:
  /// **'Last online backup: {when}'**
  String backupCloudLast(String when);

  /// No description provided for @backupCloudNever.
  ///
  /// In en, this message translates to:
  /// **'Not saved online yet'**
  String get backupCloudNever;

  /// No description provided for @backupCloudNeedsShop.
  ///
  /// In en, this message translates to:
  /// **'Create a cloud shop first'**
  String get backupCloudNeedsShop;

  /// No description provided for @backupCloudNowAction.
  ///
  /// In en, this message translates to:
  /// **'Back up online now'**
  String get backupCloudNowAction;

  /// No description provided for @backupCloudRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore from online'**
  String get backupCloudRestoreAction;

  /// No description provided for @backupCloudSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved online'**
  String get backupCloudSavedToast;

  /// No description provided for @backupCloudFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Could not save online. Try again when you have signal.'**
  String get backupCloudFailedToast;

  /// No description provided for @billWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get billWhatsapp;

  /// No description provided for @billWhatsappFailed.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed on this phone.'**
  String get billWhatsappFailed;

  /// No description provided for @devicesStaffRole.
  ///
  /// In en, this message translates to:
  /// **'Staff role'**
  String get devicesStaffRole;

  /// No description provided for @devicesRoleDefault.
  ///
  /// In en, this message translates to:
  /// **'Default (job only)'**
  String get devicesRoleDefault;

  /// No description provided for @devicesRolePick.
  ///
  /// In en, this message translates to:
  /// **'Choose a staff role'**
  String get devicesRolePick;

  /// No description provided for @devicesRoleSaved.
  ///
  /// In en, this message translates to:
  /// **'Role sent to that phone'**
  String get devicesRoleSaved;

  /// No description provided for @devicesRoleFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not set the role. Try again when online.'**
  String get devicesRoleFailed;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner reports'**
  String get adminTitle;

  /// No description provided for @adminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What happened, who did it, and whether the cash matched'**
  String get adminSubtitle;

  /// No description provided for @adminExceptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Exceptions'**
  String get adminExceptionsTitle;

  /// No description provided for @adminExceptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discounts, cancelled bills, reprints and credit'**
  String get adminExceptionsSubtitle;

  /// No description provided for @adminStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff report'**
  String get adminStaffTitle;

  /// No description provided for @adminStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What each person did in this period'**
  String get adminStaffSubtitle;

  /// No description provided for @adminCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash book'**
  String get adminCashTitle;

  /// No description provided for @adminCashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expected against counted, day by day'**
  String get adminCashSubtitle;

  /// No description provided for @adminItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Item gaps'**
  String get adminItemsTitle;

  /// No description provided for @adminItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sold against stock taken out'**
  String get adminItemsSubtitle;

  /// No description provided for @adminShopsTitle.
  ///
  /// In en, this message translates to:
  /// **'All shops'**
  String get adminShopsTitle;

  /// No description provided for @adminShopsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Totals from every shop you run'**
  String get adminShopsSubtitle;

  /// No description provided for @adminSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get adminSummaryTitle;

  /// No description provided for @adminSummarySend.
  ///
  /// In en, this message translates to:
  /// **'Send the summary'**
  String get adminSummarySend;

  /// No description provided for @adminShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get adminShare;

  /// No description provided for @adminNoRows.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show for this period'**
  String get adminNoRows;

  /// No description provided for @adminFromBill.
  ///
  /// In en, this message translates to:
  /// **'From the bill'**
  String get adminFromBill;

  /// No description provided for @adminOwnerApproved.
  ///
  /// In en, this message translates to:
  /// **'Owner approved'**
  String get adminOwnerApproved;

  /// No description provided for @adminColActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get adminColActions;

  /// No description provided for @adminColDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount given'**
  String get adminColDiscount;

  /// No description provided for @adminColCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit given'**
  String get adminColCredit;

  /// No description provided for @adminColVoids.
  ///
  /// In en, this message translates to:
  /// **'Bills cancelled'**
  String get adminColVoids;

  /// No description provided for @adminColReprints.
  ///
  /// In en, this message translates to:
  /// **'Reprints'**
  String get adminColReprints;

  /// No description provided for @adminColOverrides.
  ///
  /// In en, this message translates to:
  /// **'Owner approvals'**
  String get adminColOverrides;

  /// No description provided for @adminSeeExceptions.
  ///
  /// In en, this message translates to:
  /// **'See their exceptions'**
  String get adminSeeExceptions;

  /// No description provided for @adminCashOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening cash'**
  String get adminCashOpening;

  /// No description provided for @adminCashExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get adminCashExpected;

  /// No description provided for @adminCashCounted.
  ///
  /// In en, this message translates to:
  /// **'Counted'**
  String get adminCashCounted;

  /// No description provided for @adminCashShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get adminCashShort;

  /// No description provided for @adminCashOver.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get adminCashOver;

  /// No description provided for @adminCashNet.
  ///
  /// In en, this message translates to:
  /// **'Net difference'**
  String get adminCashNet;

  /// No description provided for @adminCashMatched.
  ///
  /// In en, this message translates to:
  /// **'Days matched'**
  String get adminCashMatched;

  /// No description provided for @adminCashMatchedOne.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get adminCashMatchedOne;

  /// No description provided for @adminCashShortDays.
  ///
  /// In en, this message translates to:
  /// **'Short days'**
  String get adminCashShortDays;

  /// No description provided for @adminItemSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get adminItemSold;

  /// No description provided for @adminItemStockOut.
  ///
  /// In en, this message translates to:
  /// **'Stock taken out'**
  String get adminItemStockOut;

  /// No description provided for @adminItemGap.
  ///
  /// In en, this message translates to:
  /// **'Gap'**
  String get adminItemGap;

  /// No description provided for @adminItemWasted.
  ///
  /// In en, this message translates to:
  /// **'Wasted'**
  String get adminItemWasted;

  /// No description provided for @adminSummaryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get adminSummaryBills;

  /// No description provided for @adminSummarySales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get adminSummarySales;

  /// No description provided for @adminSummaryCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get adminSummaryCash;

  /// No description provided for @adminSummaryUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get adminSummaryUpi;

  /// No description provided for @adminSummaryCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get adminSummaryCredit;

  /// No description provided for @adminSummaryDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get adminSummaryDiscount;

  /// No description provided for @adminSummarySpend.
  ///
  /// In en, this message translates to:
  /// **'Spend'**
  String get adminSummarySpend;

  /// No description provided for @adminSummaryCashDiff.
  ///
  /// In en, this message translates to:
  /// **'Cash difference'**
  String get adminSummaryCashDiff;

  /// No description provided for @adminSummaryTop.
  ///
  /// In en, this message translates to:
  /// **'Top items'**
  String get adminSummaryTop;

  /// No description provided for @adminShopsAllTotal.
  ///
  /// In en, this message translates to:
  /// **'All shops together'**
  String get adminShopsAllTotal;

  /// No description provided for @adminShopsOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders (7 days)'**
  String get adminShopsOrders;

  /// No description provided for @adminShopsValue.
  ///
  /// In en, this message translates to:
  /// **'Value (7 days)'**
  String get adminShopsValue;

  /// No description provided for @adminShopsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add another shop'**
  String get adminShopsAdd;

  /// No description provided for @adminShopsAddHelp.
  ///
  /// In en, this message translates to:
  /// **'Type the other shop\'s link name and its owner key.'**
  String get adminShopsAddHelp;

  /// No description provided for @adminShopsAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add shop'**
  String get adminShopsAddAction;

  /// No description provided for @adminShopsSlug.
  ///
  /// In en, this message translates to:
  /// **'Shop link name'**
  String get adminShopsSlug;

  /// No description provided for @adminShopsKey.
  ///
  /// In en, this message translates to:
  /// **'Owner key'**
  String get adminShopsKey;

  /// No description provided for @adminShopsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get adminShopsRemove;

  /// No description provided for @adminShopsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminShopsRefresh;

  /// No description provided for @adminShopsError.
  ///
  /// In en, this message translates to:
  /// **'Could not read this shop'**
  String get adminShopsError;

  /// No description provided for @adminShopsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the link name and the owner key'**
  String get adminShopsInvalid;

  /// No description provided for @adminShopsExists.
  ///
  /// In en, this message translates to:
  /// **'That shop is already on the list'**
  String get adminShopsExists;

  /// No description provided for @permViewCashBook.
  ///
  /// In en, this message translates to:
  /// **'See the cash book'**
  String get permViewCashBook;

  /// No description provided for @permExportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get permExportData;

  /// No description provided for @permViewStaffReport.
  ///
  /// In en, this message translates to:
  /// **'See staff reports'**
  String get permViewStaffReport;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'hi',
        'kn',
        'ml',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
