import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Save Statusly'**
  String get appName;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectPreferredLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @statuses.
  ///
  /// In en, this message translates to:
  /// **'Statuses'**
  String get statuses;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @manageWhatsAppStatusSources.
  ///
  /// In en, this message translates to:
  /// **'Manage your WhatsApp status sources.'**
  String get manageWhatsAppStatusSources;

  /// No description provided for @openWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get openWhatsApp;

  /// No description provided for @returnDirectlyToWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Return directly to WhatsApp'**
  String get returnDirectlyToWhatsApp;

  /// No description provided for @howToUseStatusly.
  ///
  /// In en, this message translates to:
  /// **'How to Use Statusly'**
  String get howToUseStatusly;

  /// No description provided for @learnHowToViewAndSaveStatuses.
  ///
  /// In en, this message translates to:
  /// **'Learn how to view and save statuses'**
  String get learnHowToViewAndSaveStatuses;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @learnHowStatuslyHandlesInformation.
  ///
  /// In en, this message translates to:
  /// **'Learn how Statusly handles your information'**
  String get learnHowStatuslyHandlesInformation;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @readTermsForUsingStatusly.
  ///
  /// In en, this message translates to:
  /// **'Read the terms for using Statusly'**
  String get readTermsForUsingStatusly;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @getHelpWithStatusly.
  ///
  /// In en, this message translates to:
  /// **'Get help with Statusly'**
  String get getHelpWithStatusly;

  /// No description provided for @statusAccessIsConfigured.
  ///
  /// In en, this message translates to:
  /// **'Status access is configured'**
  String get statusAccessIsConfigured;

  /// No description provided for @statusFolderNeedsConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Status folder needs to be configured'**
  String get statusFolderNeedsConfiguration;

  /// No description provided for @noEmailAppFound.
  ///
  /// In en, this message translates to:
  /// **'No email app was found on this device.'**
  String get noEmailAppFound;

  /// No description provided for @unableToOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Unable to open your email app.'**
  String get unableToOpenEmail;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Save photos and videos from WhatsApp statuses.'**
  String get onboardingDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @byContinuingYouAcknowledgeOur.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge our'**
  String get byContinuingYouAcknowledgeOur;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @saveStatus.
  ///
  /// In en, this message translates to:
  /// **'Save Status'**
  String get saveStatus;

  /// No description provided for @savePhotosAndVideosFromWhatsAppStatuses.
  ///
  /// In en, this message translates to:
  /// **'Save photos and videos from your WhatsApp statuses.'**
  String get savePhotosAndVideosFromWhatsAppStatuses;

  /// No description provided for @statusAccessIsReady.
  ///
  /// In en, this message translates to:
  /// **'Status access is ready'**
  String get statusAccessIsReady;

  /// No description provided for @setUpStatusAccess.
  ///
  /// In en, this message translates to:
  /// **'Set up status access'**
  String get setUpStatusAccess;

  /// No description provided for @whatsappNotFound.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp not found'**
  String get whatsappNotFound;

  /// No description provided for @installWhatsAppOrBusinessToUseStatusly.
  ///
  /// In en, this message translates to:
  /// **'Install WhatsApp or WhatsApp Business to use Statusly.'**
  String get installWhatsAppOrBusinessToUseStatusly;

  /// No description provided for @noVideosFound.
  ///
  /// In en, this message translates to:
  /// **'No videos found'**
  String get noVideosFound;

  /// No description provided for @noImagesFound.
  ///
  /// In en, this message translates to:
  /// **'No images found'**
  String get noImagesFound;

  /// No description provided for @videoStatusesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Video statuses will appear here.'**
  String get videoStatusesWillAppearHere;

  /// No description provided for @imageStatusesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Image statuses will appear here.'**
  String get imageStatusesWillAppearHere;

  /// No description provided for @noSavedVideos.
  ///
  /// In en, this message translates to:
  /// **'No saved videos'**
  String get noSavedVideos;

  /// No description provided for @noSavedImages.
  ///
  /// In en, this message translates to:
  /// **'No saved images'**
  String get noSavedImages;

  /// No description provided for @videosYouSaveWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Videos you save will appear here.'**
  String get videosYouSaveWillAppearHere;

  /// No description provided for @imagesYouSaveWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Images you save will appear here.'**
  String get imagesYouSaveWillAppearHere;

  /// No description provided for @howToSaveAStatus.
  ///
  /// In en, this message translates to:
  /// **'How to save a status'**
  String get howToSaveAStatus;

  /// No description provided for @viewAStatusOn.
  ///
  /// In en, this message translates to:
  /// **'View a status on {sourceName}'**
  String viewAStatusOn(Object sourceName);

  /// No description provided for @openSaveStatusly.
  ///
  /// In en, this message translates to:
  /// **'Open Save Statusly'**
  String get openSaveStatusly;

  /// No description provided for @returnToSaveStatuslyAfterViewing.
  ///
  /// In en, this message translates to:
  /// **'Return to Save Statusly after viewing the status.'**
  String get returnToSaveStatuslyAfterViewing;

  /// No description provided for @saveOrDownloadTheStatus.
  ///
  /// In en, this message translates to:
  /// **'Save or download the status'**
  String get saveOrDownloadTheStatus;

  /// No description provided for @viewedStatusWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'The viewed status will appear here. Open it and tap the Save or Download button.'**
  String get viewedStatusWillAppearHere;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open {sourceName}'**
  String openSource(Object sourceName);

  /// No description provided for @exitStatusly.
  ///
  /// In en, this message translates to:
  /// **'Exit Statusly?'**
  String get exitStatusly;

  /// No description provided for @areYouSureYouWantToCloseTheApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the app?'**
  String get areYouSureYouWantToCloseTheApp;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @unableToOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Unable to open WhatsApp.'**
  String get unableToOpenWhatsApp;

  /// No description provided for @sourceNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'{sourceName} is not installed.'**
  String sourceNotInstalled(Object sourceName);

  /// No description provided for @sourceStatusAccessReady.
  ///
  /// In en, this message translates to:
  /// **'{sourceName} status access is ready.'**
  String sourceStatusAccessReady(Object sourceName);

  /// No description provided for @pleaseSelectStatusesFolder.
  ///
  /// In en, this message translates to:
  /// **'Please select the .Statuses folder.'**
  String get pleaseSelectStatusesFolder;

  /// No description provided for @unableToSetUpStatusAccess.
  ///
  /// In en, this message translates to:
  /// **'Unable to set up status access: {error}'**
  String unableToSetUpStatusAccess(Object error);

  /// No description provided for @unableToOpenStatus.
  ///
  /// In en, this message translates to:
  /// **'Unable to open status: {error}'**
  String unableToOpenStatus(Object error);

  /// No description provided for @openWhatsAppTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get openWhatsAppTooltip;

  /// No description provided for @openSourceAndViewStatus.
  ///
  /// In en, this message translates to:
  /// **'Open {sourceName} and view the photo or video status you want to save.'**
  String openSourceAndViewStatus(Object sourceName);

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @statusPhotosAndVideoDownloader.
  ///
  /// In en, this message translates to:
  /// **'Status photos and video downloader'**
  String get statusPhotosAndVideoDownloader;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @howToUseDescription.
  ///
  /// In en, this message translates to:
  /// **'Save photos and videos from WhatsApp statuses directly to your device.'**
  String get howToUseDescription;

  /// No description provided for @howToUseStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Choose WhatsApp'**
  String get howToUseStep1Title;

  /// No description provided for @howToUseStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Select WhatsApp or WhatsApp Business depending on the status source you want to use.'**
  String get howToUseStep1Description;

  /// No description provided for @howToUseStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Allow Statusly to access statuses'**
  String get howToUseStep2Title;

  /// No description provided for @howToUseStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Android will ask you to allow Statusly to access the selected WhatsApp status folder. Follow the Android prompt and confirm the folder selection.'**
  String get howToUseStep2Description;

  /// No description provided for @howToUseStep3Title.
  ///
  /// In en, this message translates to:
  /// **'View available statuses'**
  String get howToUseStep3Title;

  /// No description provided for @howToUseStep3Description.
  ///
  /// In en, this message translates to:
  /// **'Once access is configured, Statusly will display available status photos and videos in the Statuses tab.'**
  String get howToUseStep3Description;

  /// No description provided for @howToUseStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Open a status'**
  String get howToUseStep4Title;

  /// No description provided for @howToUseStep4Description.
  ///
  /// In en, this message translates to:
  /// **'Tap a photo or video to view it. Videos can be played directly inside Statusly.'**
  String get howToUseStep4Description;

  /// No description provided for @howToUseStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Save a status'**
  String get howToUseStep5Title;

  /// No description provided for @howToUseStep5Description.
  ///
  /// In en, this message translates to:
  /// **'Use the save option when viewing a status to save the selected photo or video to your device.'**
  String get howToUseStep5Description;

  /// No description provided for @howToUseStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Find your saved media'**
  String get howToUseStep6Title;

  /// No description provided for @howToUseStep6Description.
  ///
  /// In en, this message translates to:
  /// **'Saved photos and videos are available in the Saved tab inside Statusly. They are also stored on your device.'**
  String get howToUseStep6Description;

  /// No description provided for @howToUseStep7Title.
  ///
  /// In en, this message translates to:
  /// **'Share a status'**
  String get howToUseStep7Title;

  /// No description provided for @howToUseStep7Description.
  ///
  /// In en, this message translates to:
  /// **'Use the share option to send supported media through other apps installed on your device.'**
  String get howToUseStep7Description;

  /// No description provided for @howToUseUsefulTips.
  ///
  /// In en, this message translates to:
  /// **'Useful Tips'**
  String get howToUseUsefulTips;

  /// No description provided for @howToUseTip1.
  ///
  /// In en, this message translates to:
  /// **'If you use both WhatsApp and WhatsApp Business, configure each source separately from Settings.'**
  String get howToUseTip1;

  /// No description provided for @howToUseTip2.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not upload your status photos or videos to a Statusly server. Supported status media is processed locally on your device.'**
  String get howToUseTip2;

  /// No description provided for @howToUseTip3.
  ///
  /// In en, this message translates to:
  /// **'If a new status does not appear immediately, return to the Statuses tab and refresh the list.'**
  String get howToUseTip3;

  /// No description provided for @howToUseTip4.
  ///
  /// In en, this message translates to:
  /// **'Only save or share status media that you have permission or authorization to use.'**
  String get howToUseTip4;

  /// No description provided for @howToUseNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get howToUseNeedHelp;

  /// No description provided for @howToUseHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'If you experience a problem while using Statusly, contact support from the Settings screen.'**
  String get howToUseHelpDescription;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyHeading.
  ///
  /// In en, this message translates to:
  /// **'Statusly Privacy Policy'**
  String get privacyPolicyHeading;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: September 11, 2026'**
  String get lastUpdated;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'Statusly is designed to help you view and save photos and videos from WhatsApp statuses on your Android device.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacySection1.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacySection1;

  /// No description provided for @privacySection1Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains how Statusly handles information when you use the Statusly mobile application (\"Statusly\", \"the App\", or \"our App\").'**
  String get privacySection1Paragraph1;

  /// No description provided for @privacySection1Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Statusly is designed with a local-first approach. The App does not require you to create an account and the current version does not operate a server that stores your WhatsApp status photos or videos.'**
  String get privacySection1Paragraph2;

  /// No description provided for @privacySection1Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains what information Statusly accesses, how that information is used, whether it is shared with third parties, and how information is retained or deleted.'**
  String get privacySection1Paragraph3;

  /// No description provided for @privacySection2.
  ///
  /// In en, this message translates to:
  /// **'2. Information Statusly Accesses'**
  String get privacySection2;

  /// No description provided for @privacySection2Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may access photos and videos stored in supported WhatsApp status media locations on your Android device when you give the App the necessary access or select the relevant folder through Android\'s file or folder selection system.'**
  String get privacySection2Paragraph1;

  /// No description provided for @privacySection2Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'This access is necessary for Statusly\'s main functionality: displaying available WhatsApp status media so that you can view and save content to your device.'**
  String get privacySection2Paragraph2;

  /// No description provided for @privacySection2Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Depending on your device, Android version, and installed WhatsApp applications, Statusly may support WhatsApp and WhatsApp Business status folders.'**
  String get privacySection2Paragraph3;

  /// No description provided for @privacySection3.
  ///
  /// In en, this message translates to:
  /// **'3. How Statusly Uses Accessed Media'**
  String get privacySection3;

  /// No description provided for @privacySection3Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly uses the status photos and videos it accesses to provide the App\'s features, including:'**
  String get privacySection3Paragraph1;

  /// No description provided for @privacyBulletDisplayStatuses.
  ///
  /// In en, this message translates to:
  /// **'Displaying available status photos and videos.'**
  String get privacyBulletDisplayStatuses;

  /// No description provided for @privacyBulletViewStatuses.
  ///
  /// In en, this message translates to:
  /// **'Allowing you to view status media.'**
  String get privacyBulletViewStatuses;

  /// No description provided for @privacyBulletSaveStatuses.
  ///
  /// In en, this message translates to:
  /// **'Allowing you to save selected status media.'**
  String get privacyBulletSaveStatuses;

  /// No description provided for @privacyBulletViewSaved.
  ///
  /// In en, this message translates to:
  /// **'Allowing you to view media saved through the App.'**
  String get privacyBulletViewSaved;

  /// No description provided for @privacyBulletShareMedia.
  ///
  /// In en, this message translates to:
  /// **'Allowing you to use supported sharing or opening functions on your device.'**
  String get privacyBulletShareMedia;

  /// No description provided for @privacySection3Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'The current version of Statusly processes supported status media locally on your device. Statusly does not need to upload your WhatsApp status photos or videos to a Statusly server to provide these core features.'**
  String get privacySection3Paragraph2;

  /// No description provided for @privacySection4.
  ///
  /// In en, this message translates to:
  /// **'4. Information We Do Not Collect'**
  String get privacySection4;

  /// No description provided for @privacySection4Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'The current version of Statusly does not require you to create an account and does not intentionally collect personal information such as:'**
  String get privacySection4Paragraph1;

  /// No description provided for @privacyBulletName.
  ///
  /// In en, this message translates to:
  /// **'Your name.'**
  String get privacyBulletName;

  /// No description provided for @privacyBulletPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone number.'**
  String get privacyBulletPhone;

  /// No description provided for @privacyBulletEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email address through the App.'**
  String get privacyBulletEmail;

  /// No description provided for @privacyBulletWhatsAppCredentials.
  ///
  /// In en, this message translates to:
  /// **'Your WhatsApp account credentials.'**
  String get privacyBulletWhatsAppCredentials;

  /// No description provided for @privacyBulletWhatsAppMessages.
  ///
  /// In en, this message translates to:
  /// **'Your WhatsApp messages.'**
  String get privacyBulletWhatsAppMessages;

  /// No description provided for @privacyBulletWhatsAppContacts.
  ///
  /// In en, this message translates to:
  /// **'Your WhatsApp contacts.'**
  String get privacyBulletWhatsAppContacts;

  /// No description provided for @privacyBulletPasswords.
  ///
  /// In en, this message translates to:
  /// **'Your passwords.'**
  String get privacyBulletPasswords;

  /// No description provided for @privacyBulletPayment.
  ///
  /// In en, this message translates to:
  /// **'Your payment information.'**
  String get privacyBulletPayment;

  /// No description provided for @privacyBulletLocation.
  ///
  /// In en, this message translates to:
  /// **'Your precise location.'**
  String get privacyBulletLocation;

  /// No description provided for @privacySection4Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Statusly also does not require a username or password to use its core functionality.'**
  String get privacySection4Paragraph2;

  /// No description provided for @privacySection5.
  ///
  /// In en, this message translates to:
  /// **'5. Local Storage and App Preferences'**
  String get privacySection5;

  /// No description provided for @privacySection5Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may store certain application preferences locally on your device. These may include information such as whether you have completed the onboarding process or which supported status source you last selected.'**
  String get privacySection5Paragraph1;

  /// No description provided for @privacySection5Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'This information is stored locally on your device and is used to make the App function properly and remember your preferences.'**
  String get privacySection5Paragraph2;

  /// No description provided for @privacySection5Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'This local preference information is not used by Statusly to identify you personally.'**
  String get privacySection5Paragraph3;

  /// No description provided for @privacySection6.
  ///
  /// In en, this message translates to:
  /// **'6. Saved Photos and Videos'**
  String get privacySection6;

  /// No description provided for @privacySection6Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'When you choose to save a photo or video using Statusly, the resulting file is stored on your device according to the App\'s saving functionality and Android\'s storage system.'**
  String get privacySection6Paragraph1;

  /// No description provided for @privacySection6Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not maintain a server-side copy of your saved status media as part of the App\'s normal operation.'**
  String get privacySection6Paragraph2;

  /// No description provided for @privacySection6Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Files saved by you remain on your device until you choose to delete them using the available device, gallery, file-management, or App functionality.'**
  String get privacySection6Paragraph3;

  /// No description provided for @privacySection7.
  ///
  /// In en, this message translates to:
  /// **'7. Sharing Information With Third Parties'**
  String get privacySection7;

  /// No description provided for @privacySection7Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not sell, rent, or trade your personal information.'**
  String get privacySection7Paragraph1;

  /// No description provided for @privacySection7Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'In the current version of the App, Statusly does not intentionally send your WhatsApp status photos or videos to third-party servers for storage or advertising purposes.'**
  String get privacySection7Paragraph2;

  /// No description provided for @privacySection7Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'If you choose to use Android\'s sharing, opening, or other third-party functionality, the information or media you choose to share may be handled by the application or service you select. That handling is governed by the privacy policy and terms of the third party involved.'**
  String get privacySection7Paragraph3;

  /// No description provided for @privacySection8.
  ///
  /// In en, this message translates to:
  /// **'8. Third-Party Services and Software'**
  String get privacySection8;

  /// No description provided for @privacySection8Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may use third-party software libraries that are necessary to provide certain technical functions of the App.'**
  String get privacySection8Paragraph1;

  /// No description provided for @privacySection8Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Third-party software may process information according to its own technical operation and applicable policies.'**
  String get privacySection8Paragraph2;

  /// No description provided for @privacySection8Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'If future versions of Statusly introduce analytics, advertising, crash reporting, cloud services, or other third-party services that collect or transmit user data, this Privacy Policy will be updated to explain the applicable data practices.'**
  String get privacySection8Paragraph3;

  /// No description provided for @privacySection9.
  ///
  /// In en, this message translates to:
  /// **'9. Advertising'**
  String get privacySection9;

  /// No description provided for @privacySection9Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'The current version of Statusly does not use advertising services as part of its core functionality.'**
  String get privacySection9Paragraph1;

  /// No description provided for @privacySection9Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'If advertising services are introduced in a future version, this Privacy Policy will be updated to explain the applicable advertising technology, data practices, and third-party services.'**
  String get privacySection9Paragraph2;

  /// No description provided for @privacySection10.
  ///
  /// In en, this message translates to:
  /// **'10. Data Security'**
  String get privacySection10;

  /// No description provided for @privacySection10Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Reasonable measures are taken to protect information handled by Statusly and to limit access to information to what is necessary for the App\'s functionality.'**
  String get privacySection10Paragraph1;

  /// No description provided for @privacySection10Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Because Statusly primarily processes supported status media locally on your Android device, your status media is not normally transmitted to a Statusly server for storage.'**
  String get privacySection10Paragraph2;

  /// No description provided for @privacySection10Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'However, no electronic storage system or method of transmission can be guaranteed to be completely secure. You should also use the security features provided by your Android device to protect your files and information.'**
  String get privacySection10Paragraph3;

  /// No description provided for @privacySection11.
  ///
  /// In en, this message translates to:
  /// **'11. Data Retention and Deletion'**
  String get privacySection11;

  /// No description provided for @privacySection11Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not maintain a server-side account containing your personal information.'**
  String get privacySection11Paragraph1;

  /// No description provided for @privacySection11Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Local application preferences remain on your device while they are needed by the App. Depending on your Android device and settings, uninstalling Statusly or clearing the App\'s data can remove locally stored application data.'**
  String get privacySection11Paragraph2;

  /// No description provided for @privacySection11Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Photos and videos that you save are files stored on your device. You can delete those files using your device\'s gallery, file-management application, or other available deletion functionality.'**
  String get privacySection11Paragraph3;

  /// No description provided for @privacySection11Paragraph4.
  ///
  /// In en, this message translates to:
  /// **'Because Statusly does not require user accounts in the current version, there is no Statusly account that you need to request deletion of.'**
  String get privacySection11Paragraph4;

  /// No description provided for @privacySection12.
  ///
  /// In en, this message translates to:
  /// **'12. Children\'s Privacy'**
  String get privacySection12;

  /// No description provided for @privacySection12Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly is not specifically designed for children.'**
  String get privacySection12Paragraph1;

  /// No description provided for @privacySection12Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'We do not knowingly collect personal information from children through the App. If you believe that a child has provided personal information to us, please contact us so that the matter can be reviewed.'**
  String get privacySection12Paragraph2;

  /// No description provided for @privacySection13.
  ///
  /// In en, this message translates to:
  /// **'13. WhatsApp and Meta Disclaimer'**
  String get privacySection13;

  /// No description provided for @privacySection13Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly is an independent application and is not affiliated with, endorsed by, sponsored by, or officially connected with WhatsApp or Meta Platforms, Inc.'**
  String get privacySection13Paragraph1;

  /// No description provided for @privacySection13Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'\"WhatsApp\" and related names, trademarks, and logos belong to their respective owners.'**
  String get privacySection13Paragraph2;

  /// No description provided for @privacySection13Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Statusly is a third-party utility intended to help users manage and save status media that they are authorized to access and save.'**
  String get privacySection13Paragraph3;

  /// No description provided for @privacySection14.
  ///
  /// In en, this message translates to:
  /// **'14. Your Responsibility Regarding Saved Content'**
  String get privacySection14;

  /// No description provided for @privacySection14Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly provides tools for saving media that is accessible to you on your device.'**
  String get privacySection14Paragraph1;

  /// No description provided for @privacySection14Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for ensuring that you have the appropriate rights, permissions, or authorization to save, copy, share, or otherwise use any photo, video, or other content you access through the App.'**
  String get privacySection14Paragraph2;

  /// No description provided for @privacySection14Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'You should respect the privacy, copyright, intellectual property, and other legal rights of content creators and other individuals.'**
  String get privacySection14Paragraph3;

  /// No description provided for @privacySection15.
  ///
  /// In en, this message translates to:
  /// **'15. Changes to This Privacy Policy'**
  String get privacySection15;

  /// No description provided for @privacySection15Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy may be updated from time to time to reflect changes to Statusly, changes in applicable laws, or changes in data practices.'**
  String get privacySection15Paragraph1;

  /// No description provided for @privacySection15Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'When changes are made, the \"Last updated\" date at the top of this page will be updated.'**
  String get privacySection15Paragraph2;

  /// No description provided for @privacySection15Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'You are encouraged to review this Privacy Policy periodically to stay informed about how Statusly handles information.'**
  String get privacySection15Paragraph3;

  /// No description provided for @privacySection16.
  ///
  /// In en, this message translates to:
  /// **'16. Contact'**
  String get privacySection16;

  /// No description provided for @privacySection16Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'If you have questions, concerns, or requests regarding this Privacy Policy or Statusly\'s privacy practices, please contact:'**
  String get privacySection16Paragraph1;

  /// No description provided for @privacyCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Iszy_Man. All rights reserved.'**
  String get privacyCopyright;

  /// No description provided for @privacyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Statusly is an independent application and is not affiliated with WhatsApp or Meta Platforms, Inc.'**
  String get privacyDisclaimer;

  /// No description provided for @termsConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditionsTitle;

  /// No description provided for @termsConditionsDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Statusly Terms & Conditions'**
  String get termsConditionsDocumentTitle;

  /// No description provided for @termsConditionsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: September 11, 2026'**
  String get termsConditionsLastUpdated;

  /// No description provided for @termsConditionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read these Terms & Conditions carefully before using Statusly.'**
  String get termsConditionsIntro;

  /// No description provided for @termsConditionsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of These Terms'**
  String get termsConditionsSection1Title;

  /// No description provided for @termsConditionsSection1Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'These Terms & Conditions (\"Terms\") govern your use of the Statusly mobile application (\"Statusly\", \"the App\", or \"our App\").'**
  String get termsConditionsSection1Paragraph1;

  /// No description provided for @termsConditionsSection1Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'By downloading, installing, accessing, or using Statusly, you agree to be bound by these Terms.'**
  String get termsConditionsSection1Paragraph2;

  /// No description provided for @termsConditionsSection1Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'If you do not agree with these Terms, you should not use the App.'**
  String get termsConditionsSection1Paragraph3;

  /// No description provided for @termsConditionsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Description of the App'**
  String get termsConditionsSection2Title;

  /// No description provided for @termsConditionsSection2Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly is a utility application designed to help users view and save photos and videos from supported WhatsApp status media that they can access on their Android device.'**
  String get termsConditionsSection2Paragraph1;

  /// No description provided for @termsConditionsSection2Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'The App does not provide WhatsApp accounts, WhatsApp messaging services, or WhatsApp account management services.'**
  String get termsConditionsSection2Paragraph2;

  /// No description provided for @termsConditionsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get termsConditionsSection3Title;

  /// No description provided for @termsConditionsSection3Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for ensuring that your use of Statusly is permitted under the laws and regulations applicable to you.'**
  String get termsConditionsSection3Paragraph1;

  /// No description provided for @termsConditionsSection3Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'If you are not legally permitted to use an application of this type in your location, you must not use Statusly.'**
  String get termsConditionsSection3Paragraph2;

  /// No description provided for @termsConditionsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Proper Use of Statusly'**
  String get termsConditionsSection4Title;

  /// No description provided for @termsConditionsSection4Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'You agree to use Statusly only for lawful purposes and in accordance with these Terms.'**
  String get termsConditionsSection4Paragraph1;

  /// No description provided for @termsConditionsSection4Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You must not use Statusly to:'**
  String get termsConditionsSection4Paragraph2;

  /// No description provided for @termsConditionsSection4Bullet1.
  ///
  /// In en, this message translates to:
  /// **'Violate any applicable law or regulation.'**
  String get termsConditionsSection4Bullet1;

  /// No description provided for @termsConditionsSection4Bullet2.
  ///
  /// In en, this message translates to:
  /// **'Infringe the copyright, trademark, privacy, publicity, intellectual property, or other rights of another person.'**
  String get termsConditionsSection4Bullet2;

  /// No description provided for @termsConditionsSection4Bullet3.
  ///
  /// In en, this message translates to:
  /// **'Save, copy, distribute, or use content without appropriate authorization where authorization is required.'**
  String get termsConditionsSection4Bullet3;

  /// No description provided for @termsConditionsSection4Bullet4.
  ///
  /// In en, this message translates to:
  /// **'Harass, threaten, impersonate, or harm another person.'**
  String get termsConditionsSection4Bullet4;

  /// No description provided for @termsConditionsSection4Bullet5.
  ///
  /// In en, this message translates to:
  /// **'Attempt to interfere with, damage, reverse engineer, or disrupt the App or its supporting systems, except where such activity is expressly permitted by applicable law.'**
  String get termsConditionsSection4Bullet5;

  /// No description provided for @termsConditionsSection4Bullet6.
  ///
  /// In en, this message translates to:
  /// **'Use the App for fraudulent, abusive, or unlawful activities.'**
  String get termsConditionsSection4Bullet6;

  /// No description provided for @termsConditionsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Responsibility for Saved Content'**
  String get termsConditionsSection5Title;

  /// No description provided for @termsConditionsSection5Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not determine whether you have permission to save, copy, share, publish, or otherwise use a particular photo or video.'**
  String get termsConditionsSection5Paragraph1;

  /// No description provided for @termsConditionsSection5Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for determining whether you have the necessary rights or permission to use content accessed through Statusly.'**
  String get termsConditionsSection5Paragraph2;

  /// No description provided for @termsConditionsSection5Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'You are also responsible for how you use any content saved using the App.'**
  String get termsConditionsSection5Paragraph3;

  /// No description provided for @termsConditionsSection5Paragraph4.
  ///
  /// In en, this message translates to:
  /// **'You should respect the rights and wishes of content creators, owners, and other individuals represented in the content.'**
  String get termsConditionsSection5Paragraph4;

  /// No description provided for @termsConditionsSection6Title.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp and Meta Disclaimer'**
  String get termsConditionsSection6Title;

  /// No description provided for @termsConditionsSection6Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly is an independent third-party application.'**
  String get termsConditionsSection6Paragraph1;

  /// No description provided for @termsConditionsSection6Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Statusly is not affiliated with, endorsed by, sponsored by, or officially connected with WhatsApp or Meta Platforms, Inc.'**
  String get termsConditionsSection6Paragraph2;

  /// No description provided for @termsConditionsSection6Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp, Meta, and their respective names, trademarks, logos, and related intellectual property belong to their respective owners.'**
  String get termsConditionsSection6Paragraph3;

  /// No description provided for @termsConditionsSection6Paragraph4.
  ///
  /// In en, this message translates to:
  /// **'Statusly does not claim ownership of WhatsApp or Meta\'s trademarks or intellectual property.'**
  String get termsConditionsSection6Paragraph4;

  /// No description provided for @termsConditionsSection7Title.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get termsConditionsSection7Title;

  /// No description provided for @termsConditionsSection7Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Your use of Statusly is also subject to our Privacy Policy.'**
  String get termsConditionsSection7Paragraph1;

  /// No description provided for @termsConditionsSection7Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'The Privacy Policy explains how Statusly handles information and the permissions required for the App\'s functionality.'**
  String get termsConditionsSection7Paragraph2;

  /// No description provided for @termsConditionsSection8Title.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get termsConditionsSection8Title;

  /// No description provided for @termsConditionsSection8Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may request access to files, folders, photos, videos, or other device resources that are necessary for the App\'s status-saving functionality.'**
  String get termsConditionsSection8Paragraph1;

  /// No description provided for @termsConditionsSection8Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You control whether to grant requested permissions or folder access through the Android operating system.'**
  String get termsConditionsSection8Paragraph2;

  /// No description provided for @termsConditionsSection8Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'If you do not grant access required for a particular feature, that feature may not function correctly.'**
  String get termsConditionsSection8Paragraph3;

  /// No description provided for @termsConditionsSection9Title.
  ///
  /// In en, this message translates to:
  /// **'Saved Files'**
  String get termsConditionsSection9Title;

  /// No description provided for @termsConditionsSection9Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'When you use Statusly to save media, the saved files are stored on your device.'**
  String get termsConditionsSection9Paragraph1;

  /// No description provided for @termsConditionsSection9Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for managing, protecting, backing up, and deleting files saved through the App.'**
  String get termsConditionsSection9Paragraph2;

  /// No description provided for @termsConditionsSection9Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for files that you delete, move, overwrite, lose, or otherwise make inaccessible on your device.'**
  String get termsConditionsSection9Paragraph3;

  /// No description provided for @termsConditionsSection10Title.
  ///
  /// In en, this message translates to:
  /// **'Availability of the App'**
  String get termsConditionsSection10Title;

  /// No description provided for @termsConditionsSection10Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'We aim to keep Statusly available and functional, but we do not guarantee that the App will always operate without interruption, errors, delays, or compatibility problems.'**
  String get termsConditionsSection10Paragraph1;

  /// No description provided for @termsConditionsSection10Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Statusly\'s functionality may be affected by factors outside our control, including Android updates, device configuration, storage limitations, file-system changes, WhatsApp changes, operating-system restrictions, or other third-party changes.'**
  String get termsConditionsSection10Paragraph2;

  /// No description provided for @termsConditionsSection11Title.
  ///
  /// In en, this message translates to:
  /// **'Changes to the App'**
  String get termsConditionsSection11Title;

  /// No description provided for @termsConditionsSection11Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may be modified, updated, improved, restricted, suspended, or discontinued in whole or in part at any time.'**
  String get termsConditionsSection11Paragraph1;

  /// No description provided for @termsConditionsSection11Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Updates may change how certain features work or introduce new functionality.'**
  String get termsConditionsSection11Paragraph2;

  /// No description provided for @termsConditionsSection12Title.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get termsConditionsSection12Title;

  /// No description provided for @termsConditionsSection12Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Statusly may interact with or rely on functionality provided by third-party applications or services, including Android system functionality.'**
  String get termsConditionsSection12Paragraph1;

  /// No description provided for @termsConditionsSection12Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Third-party applications and services are governed by their own terms and policies. Statusly is not responsible for the availability, content, policies, or practices of third-party services.'**
  String get termsConditionsSection12Paragraph2;

  /// No description provided for @termsConditionsSection13Title.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get termsConditionsSection13Title;

  /// No description provided for @termsConditionsSection13Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'Unless otherwise stated, the original software, design, branding, interface, graphics, text, and other original materials that make up Statusly are protected by applicable intellectual property laws.'**
  String get termsConditionsSection13Paragraph1;

  /// No description provided for @termsConditionsSection13Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'You may not reproduce, modify, distribute, sell, sublicense, or commercially exploit the App or its original components except where expressly permitted by applicable law or by the applicable rights holder.'**
  String get termsConditionsSection13Paragraph2;

  /// No description provided for @termsConditionsSection14Title.
  ///
  /// In en, this message translates to:
  /// **'No Warranty'**
  String get termsConditionsSection14Title;

  /// No description provided for @termsConditionsSection14Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'To the maximum extent permitted by applicable law, Statusly is provided on an \"as is\" and \"as available\" basis.'**
  String get termsConditionsSection14Paragraph1;

  /// No description provided for @termsConditionsSection14Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'We do not guarantee that the App will always be available, error-free, secure, compatible with every Android device, or capable of accessing every type of WhatsApp status media.'**
  String get termsConditionsSection14Paragraph2;

  /// No description provided for @termsConditionsSection14Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'We do not guarantee that every status photo or video will be successfully detected, displayed, previewed, or saved.'**
  String get termsConditionsSection14Paragraph3;

  /// No description provided for @termsConditionsSection15Title.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get termsConditionsSection15Title;

  /// No description provided for @termsConditionsSection15Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'To the maximum extent permitted by applicable law, we shall not be responsible for indirect, incidental, special, consequential, or punitive damages arising from or related to your use of Statusly.'**
  String get termsConditionsSection15Paragraph1;

  /// No description provided for @termsConditionsSection15Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'This may include, where permitted by law, loss of files, loss of data, device issues, loss of profits, interruption of service, or problems caused by third-party applications or services.'**
  String get termsConditionsSection15Paragraph2;

  /// No description provided for @termsConditionsSection15Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Nothing in these Terms is intended to exclude or limit liability that cannot lawfully be excluded or limited under applicable law.'**
  String get termsConditionsSection15Paragraph3;

  /// No description provided for @termsConditionsSection16Title.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termsConditionsSection16Title;

  /// No description provided for @termsConditionsSection16Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'You may stop using Statusly at any time by uninstalling the App from your device.'**
  String get termsConditionsSection16Paragraph1;

  /// No description provided for @termsConditionsSection16Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Access to the App or particular features may also be restricted or discontinued where necessary for security, legal, technical, or operational reasons.'**
  String get termsConditionsSection16Paragraph2;

  /// No description provided for @termsConditionsSection17Title.
  ///
  /// In en, this message translates to:
  /// **'Changes to These Terms'**
  String get termsConditionsSection17Title;

  /// No description provided for @termsConditionsSection17Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'These Terms may be updated from time to time.'**
  String get termsConditionsSection17Paragraph1;

  /// No description provided for @termsConditionsSection17Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'When changes are made, the \"Last updated\" date at the top of this page will be updated.'**
  String get termsConditionsSection17Paragraph2;

  /// No description provided for @termsConditionsSection17Paragraph3.
  ///
  /// In en, this message translates to:
  /// **'Your continued use of Statusly after updated Terms become available means that you accept the updated Terms to the extent permitted by applicable law.'**
  String get termsConditionsSection17Paragraph3;

  /// No description provided for @termsConditionsSection18Title.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get termsConditionsSection18Title;

  /// No description provided for @termsConditionsSection18Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by and interpreted in accordance with applicable law, without regard to conflict-of-law principles, except where applicable law requires otherwise.'**
  String get termsConditionsSection18Paragraph1;

  /// No description provided for @termsConditionsSection18Paragraph2.
  ///
  /// In en, this message translates to:
  /// **'Nothing in these Terms removes or limits any rights that you may have under mandatory consumer protection laws applicable to you.'**
  String get termsConditionsSection18Paragraph2;

  /// No description provided for @termsConditionsSection19Title.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get termsConditionsSection19Title;

  /// No description provided for @termsConditionsSection19Paragraph1.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about these Terms & Conditions or Statusly, please contact:'**
  String get termsConditionsSection19Paragraph1;

  /// No description provided for @termsConditionsContactName.
  ///
  /// In en, this message translates to:
  /// **'Iszy_Man'**
  String get termsConditionsContactName;

  /// No description provided for @termsConditionsContactEmail.
  ///
  /// In en, this message translates to:
  /// **'iszifyaws@gmail.com'**
  String get termsConditionsContactEmail;

  /// No description provided for @termsConditionsCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Iszy_Man. All rights reserved.'**
  String get termsConditionsCopyright;

  /// No description provided for @termsConditionsFooterDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Statusly is an independent application and is not affiliated with WhatsApp or Meta Platforms, Inc.'**
  String get termsConditionsFooterDisclaimer;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @alreadySavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Already saved to your gallery.'**
  String get alreadySavedToGallery;

  /// No description provided for @savedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Saved to your gallery.'**
  String get savedToGallery;

  /// No description provided for @unableToSaveStatus.
  ///
  /// In en, this message translates to:
  /// **'Unable to save status.'**
  String get unableToSaveStatus;

  /// No description provided for @unableToSaveStatusWithError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save status: {error}'**
  String unableToSaveStatusWithError(Object error);

  /// No description provided for @unableToShareStatus.
  ///
  /// In en, this message translates to:
  /// **'Unable to share status.'**
  String get unableToShareStatus;

  /// No description provided for @unableToShareStatusWithError.
  ///
  /// In en, this message translates to:
  /// **'Unable to share status: {error}'**
  String unableToShareStatusWithError(Object error);

  /// No description provided for @videoFileDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Video file does not exist.'**
  String get videoFileDoesNotExist;

  /// No description provided for @videoFileIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Video file is empty.'**
  String get videoFileIsEmpty;

  /// No description provided for @unableToPlayVideo.
  ///
  /// In en, this message translates to:
  /// **'Unable to play video.'**
  String get unableToPlayVideo;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing...'**
  String get sharing;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveSourceStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Save {sourceName}\nStatus Videos & Photos'**
  String saveSourceStatusTitle(Object sourceName);

  /// No description provided for @allowAccessToStatusesFolder.
  ///
  /// In en, this message translates to:
  /// **'Allow access to the\n\".Statuses\" folder'**
  String get allowAccessToStatusesFolder;

  /// No description provided for @allowAccessButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Access 👈'**
  String get allowAccessButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
