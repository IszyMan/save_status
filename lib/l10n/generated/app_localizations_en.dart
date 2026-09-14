// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Save Statusly';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get selectPreferredLanguage => 'Select your preferred language';

  @override
  String get continueButton => 'Continue';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get statuses => 'Statuses';

  @override
  String get saved => 'Saved';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get manageWhatsAppStatusSources =>
      'Manage your WhatsApp status sources.';

  @override
  String get openWhatsApp => 'Open WhatsApp';

  @override
  String get returnDirectlyToWhatsApp => 'Return directly to WhatsApp';

  @override
  String get howToUseStatusly => 'How to Use Statusly';

  @override
  String get learnHowToViewAndSaveStatuses =>
      'Learn how to view and save statuses';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get learnHowStatuslyHandlesInformation =>
      'Learn how Statusly handles your information';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get readTermsForUsingStatusly => 'Read the terms for using Statusly';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get getHelpWithStatusly => 'Get help with Statusly';

  @override
  String get statusAccessIsConfigured => 'Status access is configured';

  @override
  String get statusFolderNeedsConfiguration =>
      'Status folder needs to be configured';

  @override
  String get noEmailAppFound => 'No email app was found on this device.';

  @override
  String get unableToOpenEmail => 'Unable to open your email app.';

  @override
  String get onboardingDescription =>
      'Save photos and videos from WhatsApp statuses.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get byContinuingYouAcknowledgeOur =>
      'By continuing, you acknowledge our';

  @override
  String get and => 'and';

  @override
  String get saveStatus => 'Save Status';

  @override
  String get savePhotosAndVideosFromWhatsAppStatuses =>
      'Save photos and videos from your WhatsApp statuses.';

  @override
  String get statusAccessIsReady => 'Status access is ready';

  @override
  String get setUpStatusAccess => 'Set up status access';

  @override
  String get whatsappNotFound => 'WhatsApp not found';

  @override
  String get installWhatsAppOrBusinessToUseStatusly =>
      'Install WhatsApp or WhatsApp Business to use Statusly.';

  @override
  String get noVideosFound => 'No videos found';

  @override
  String get noImagesFound => 'No images found';

  @override
  String get videoStatusesWillAppearHere => 'Video statuses will appear here.';

  @override
  String get imageStatusesWillAppearHere => 'Image statuses will appear here.';

  @override
  String get noSavedVideos => 'No saved videos';

  @override
  String get noSavedImages => 'No saved images';

  @override
  String get videosYouSaveWillAppearHere => 'Videos you save will appear here.';

  @override
  String get imagesYouSaveWillAppearHere => 'Images you save will appear here.';

  @override
  String get howToSaveAStatus => 'How to save a status';

  @override
  String viewAStatusOn(Object sourceName) {
    return 'View a status on $sourceName';
  }

  @override
  String get openSaveStatusly => 'Open Save Statusly';

  @override
  String get returnToSaveStatuslyAfterViewing =>
      'Return to Save Statusly after viewing the status.';

  @override
  String get saveOrDownloadTheStatus => 'Save or download the status';

  @override
  String get viewedStatusWillAppearHere =>
      'The viewed status will appear here. Open it and tap the Save or Download button.';

  @override
  String openSource(Object sourceName) {
    return 'Open $sourceName';
  }

  @override
  String get exitStatusly => 'Exit Statusly?';

  @override
  String get areYouSureYouWantToCloseTheApp =>
      'Are you sure you want to close the app?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get unableToOpenWhatsApp => 'Unable to open WhatsApp.';

  @override
  String sourceNotInstalled(Object sourceName) {
    return '$sourceName is not installed.';
  }

  @override
  String sourceStatusAccessReady(Object sourceName) {
    return '$sourceName status access is ready.';
  }

  @override
  String get pleaseSelectStatusesFolder =>
      'Please select the .Statuses folder.';

  @override
  String unableToSetUpStatusAccess(Object error) {
    return 'Unable to set up status access: $error';
  }

  @override
  String unableToOpenStatus(Object error) {
    return 'Unable to open status: $error';
  }

  @override
  String get openWhatsAppTooltip => 'Open WhatsApp';

  @override
  String openSourceAndViewStatus(Object sourceName) {
    return 'Open $sourceName and view the photo or video status you want to save.';
  }

  @override
  String get images => 'Images';

  @override
  String get videos => 'Videos';

  @override
  String get statusPhotosAndVideoDownloader =>
      'Status photos and video downloader';

  @override
  String get loading => 'Loading...';

  @override
  String get howToUseDescription =>
      'Save photos and videos from WhatsApp statuses directly to your device.';

  @override
  String get howToUseStep1Title => 'Choose WhatsApp';

  @override
  String get howToUseStep1Description =>
      'Select WhatsApp or WhatsApp Business depending on the status source you want to use.';

  @override
  String get howToUseStep2Title => 'Allow Statusly to access statuses';

  @override
  String get howToUseStep2Description =>
      'Android will ask you to allow Statusly to access the selected WhatsApp status folder. Follow the Android prompt and confirm the folder selection.';

  @override
  String get howToUseStep3Title => 'View available statuses';

  @override
  String get howToUseStep3Description =>
      'Once access is configured, Statusly will display available status photos and videos in the Statuses tab.';

  @override
  String get howToUseStep4Title => 'Open a status';

  @override
  String get howToUseStep4Description =>
      'Tap a photo or video to view it. Videos can be played directly inside Statusly.';

  @override
  String get howToUseStep5Title => 'Save a status';

  @override
  String get howToUseStep5Description =>
      'Use the save option when viewing a status to save the selected photo or video to your device.';

  @override
  String get howToUseStep6Title => 'Find your saved media';

  @override
  String get howToUseStep6Description =>
      'Saved photos and videos are available in the Saved tab inside Statusly. They are also stored on your device.';

  @override
  String get howToUseStep7Title => 'Share a status';

  @override
  String get howToUseStep7Description =>
      'Use the share option to send supported media through other apps installed on your device.';

  @override
  String get howToUseUsefulTips => 'Useful Tips';

  @override
  String get howToUseTip1 =>
      'If you use both WhatsApp and WhatsApp Business, configure each source separately from Settings.';

  @override
  String get howToUseTip2 =>
      'Statusly does not upload your status photos or videos to a Statusly server. Supported status media is processed locally on your device.';

  @override
  String get howToUseTip3 =>
      'If a new status does not appear immediately, return to the Statuses tab and refresh the list.';

  @override
  String get howToUseTip4 =>
      'Only save or share status media that you have permission or authorization to use.';

  @override
  String get howToUseNeedHelp => 'Need Help?';

  @override
  String get howToUseHelpDescription =>
      'If you experience a problem while using Statusly, contact support from the Settings screen.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyHeading => 'Statusly Privacy Policy';

  @override
  String get lastUpdated => 'Last updated: September 11, 2026';

  @override
  String get privacyPolicyIntro =>
      'Statusly is designed to help you view and save photos and videos from WhatsApp statuses on your Android device.';

  @override
  String get privacySection1 => '1. Introduction';

  @override
  String get privacySection1Paragraph1 =>
      'This Privacy Policy explains how Statusly handles information when you use the Statusly mobile application (\"Statusly\", \"the App\", or \"our App\").';

  @override
  String get privacySection1Paragraph2 =>
      'Statusly is designed with a local-first approach. The App does not require you to create an account and the current version does not operate a server that stores your WhatsApp status photos or videos.';

  @override
  String get privacySection1Paragraph3 =>
      'This Privacy Policy explains what information Statusly accesses, how that information is used, whether it is shared with third parties, and how information is retained or deleted.';

  @override
  String get privacySection2 => '2. Information Statusly Accesses';

  @override
  String get privacySection2Paragraph1 =>
      'Statusly may access photos and videos stored in supported WhatsApp status media locations on your Android device when you give the App the necessary access or select the relevant folder through Android\'s file or folder selection system.';

  @override
  String get privacySection2Paragraph2 =>
      'This access is necessary for Statusly\'s main functionality: displaying available WhatsApp status media so that you can view and save content to your device.';

  @override
  String get privacySection2Paragraph3 =>
      'Depending on your device, Android version, and installed WhatsApp applications, Statusly may support WhatsApp and WhatsApp Business status folders.';

  @override
  String get privacySection3 => '3. How Statusly Uses Accessed Media';

  @override
  String get privacySection3Paragraph1 =>
      'Statusly uses the status photos and videos it accesses to provide the App\'s features, including:';

  @override
  String get privacyBulletDisplayStatuses =>
      'Displaying available status photos and videos.';

  @override
  String get privacyBulletViewStatuses => 'Allowing you to view status media.';

  @override
  String get privacyBulletSaveStatuses =>
      'Allowing you to save selected status media.';

  @override
  String get privacyBulletViewSaved =>
      'Allowing you to view media saved through the App.';

  @override
  String get privacyBulletShareMedia =>
      'Allowing you to use supported sharing or opening functions on your device.';

  @override
  String get privacySection3Paragraph2 =>
      'The current version of Statusly processes supported status media locally on your device. Statusly does not need to upload your WhatsApp status photos or videos to a Statusly server to provide these core features.';

  @override
  String get privacySection4 => '4. Information We Do Not Collect';

  @override
  String get privacySection4Paragraph1 =>
      'The current version of Statusly does not require you to create an account and does not intentionally collect personal information such as:';

  @override
  String get privacyBulletName => 'Your name.';

  @override
  String get privacyBulletPhone => 'Your phone number.';

  @override
  String get privacyBulletEmail => 'Your email address through the App.';

  @override
  String get privacyBulletWhatsAppCredentials =>
      'Your WhatsApp account credentials.';

  @override
  String get privacyBulletWhatsAppMessages => 'Your WhatsApp messages.';

  @override
  String get privacyBulletWhatsAppContacts => 'Your WhatsApp contacts.';

  @override
  String get privacyBulletPasswords => 'Your passwords.';

  @override
  String get privacyBulletPayment => 'Your payment information.';

  @override
  String get privacyBulletLocation => 'Your precise location.';

  @override
  String get privacySection4Paragraph2 =>
      'Statusly also does not require a username or password to use its core functionality.';

  @override
  String get privacySection5 => '5. Local Storage and App Preferences';

  @override
  String get privacySection5Paragraph1 =>
      'Statusly may store certain application preferences locally on your device. These may include information such as whether you have completed the onboarding process or which supported status source you last selected.';

  @override
  String get privacySection5Paragraph2 =>
      'This information is stored locally on your device and is used to make the App function properly and remember your preferences.';

  @override
  String get privacySection5Paragraph3 =>
      'This local preference information is not used by Statusly to identify you personally.';

  @override
  String get privacySection6 => '6. Saved Photos and Videos';

  @override
  String get privacySection6Paragraph1 =>
      'When you choose to save a photo or video using Statusly, the resulting file is stored on your device according to the App\'s saving functionality and Android\'s storage system.';

  @override
  String get privacySection6Paragraph2 =>
      'Statusly does not maintain a server-side copy of your saved status media as part of the App\'s normal operation.';

  @override
  String get privacySection6Paragraph3 =>
      'Files saved by you remain on your device until you choose to delete them using the available device, gallery, file-management, or App functionality.';

  @override
  String get privacySection7 => '7. Sharing Information With Third Parties';

  @override
  String get privacySection7Paragraph1 =>
      'Statusly does not sell, rent, or trade your personal information.';

  @override
  String get privacySection7Paragraph2 =>
      'In the current version of the App, Statusly does not intentionally send your WhatsApp status photos or videos to third-party servers for storage or advertising purposes.';

  @override
  String get privacySection7Paragraph3 =>
      'If you choose to use Android\'s sharing, opening, or other third-party functionality, the information or media you choose to share may be handled by the application or service you select. That handling is governed by the privacy policy and terms of the third party involved.';

  @override
  String get privacySection8 => '8. Third-Party Services and Software';

  @override
  String get privacySection8Paragraph1 =>
      'Statusly may use third-party software libraries that are necessary to provide certain technical functions of the App.';

  @override
  String get privacySection8Paragraph2 =>
      'Third-party software may process information according to its own technical operation and applicable policies.';

  @override
  String get privacySection8Paragraph3 =>
      'If future versions of Statusly introduce analytics, advertising, crash reporting, cloud services, or other third-party services that collect or transmit user data, this Privacy Policy will be updated to explain the applicable data practices.';

  @override
  String get privacySection9 => '9. Advertising';

  @override
  String get privacySection9Paragraph1 =>
      'The current version of Statusly does not use advertising services as part of its core functionality.';

  @override
  String get privacySection9Paragraph2 =>
      'If advertising services are introduced in a future version, this Privacy Policy will be updated to explain the applicable advertising technology, data practices, and third-party services.';

  @override
  String get privacySection10 => '10. Data Security';

  @override
  String get privacySection10Paragraph1 =>
      'Reasonable measures are taken to protect information handled by Statusly and to limit access to information to what is necessary for the App\'s functionality.';

  @override
  String get privacySection10Paragraph2 =>
      'Because Statusly primarily processes supported status media locally on your Android device, your status media is not normally transmitted to a Statusly server for storage.';

  @override
  String get privacySection10Paragraph3 =>
      'However, no electronic storage system or method of transmission can be guaranteed to be completely secure. You should also use the security features provided by your Android device to protect your files and information.';

  @override
  String get privacySection11 => '11. Data Retention and Deletion';

  @override
  String get privacySection11Paragraph1 =>
      'Statusly does not maintain a server-side account containing your personal information.';

  @override
  String get privacySection11Paragraph2 =>
      'Local application preferences remain on your device while they are needed by the App. Depending on your Android device and settings, uninstalling Statusly or clearing the App\'s data can remove locally stored application data.';

  @override
  String get privacySection11Paragraph3 =>
      'Photos and videos that you save are files stored on your device. You can delete those files using your device\'s gallery, file-management application, or other available deletion functionality.';

  @override
  String get privacySection11Paragraph4 =>
      'Because Statusly does not require user accounts in the current version, there is no Statusly account that you need to request deletion of.';

  @override
  String get privacySection12 => '12. Children\'s Privacy';

  @override
  String get privacySection12Paragraph1 =>
      'Statusly is not specifically designed for children.';

  @override
  String get privacySection12Paragraph2 =>
      'We do not knowingly collect personal information from children through the App. If you believe that a child has provided personal information to us, please contact us so that the matter can be reviewed.';

  @override
  String get privacySection13 => '13. WhatsApp and Meta Disclaimer';

  @override
  String get privacySection13Paragraph1 =>
      'Statusly is an independent application and is not affiliated with, endorsed by, sponsored by, or officially connected with WhatsApp or Meta Platforms, Inc.';

  @override
  String get privacySection13Paragraph2 =>
      '\"WhatsApp\" and related names, trademarks, and logos belong to their respective owners.';

  @override
  String get privacySection13Paragraph3 =>
      'Statusly is a third-party utility intended to help users manage and save status media that they are authorized to access and save.';

  @override
  String get privacySection14 =>
      '14. Your Responsibility Regarding Saved Content';

  @override
  String get privacySection14Paragraph1 =>
      'Statusly provides tools for saving media that is accessible to you on your device.';

  @override
  String get privacySection14Paragraph2 =>
      'You are responsible for ensuring that you have the appropriate rights, permissions, or authorization to save, copy, share, or otherwise use any photo, video, or other content you access through the App.';

  @override
  String get privacySection14Paragraph3 =>
      'You should respect the privacy, copyright, intellectual property, and other legal rights of content creators and other individuals.';

  @override
  String get privacySection15 => '15. Changes to This Privacy Policy';

  @override
  String get privacySection15Paragraph1 =>
      'This Privacy Policy may be updated from time to time to reflect changes to Statusly, changes in applicable laws, or changes in data practices.';

  @override
  String get privacySection15Paragraph2 =>
      'When changes are made, the \"Last updated\" date at the top of this page will be updated.';

  @override
  String get privacySection15Paragraph3 =>
      'You are encouraged to review this Privacy Policy periodically to stay informed about how Statusly handles information.';

  @override
  String get privacySection16 => '16. Contact';

  @override
  String get privacySection16Paragraph1 =>
      'If you have questions, concerns, or requests regarding this Privacy Policy or Statusly\'s privacy practices, please contact:';

  @override
  String get privacyCopyright => '© 2026 Iszy_Man. All rights reserved.';

  @override
  String get privacyDisclaimer =>
      'Statusly is an independent application and is not affiliated with WhatsApp or Meta Platforms, Inc.';

  @override
  String get termsConditionsTitle => 'Terms & Conditions';

  @override
  String get termsConditionsDocumentTitle => 'Statusly Terms & Conditions';

  @override
  String get termsConditionsLastUpdated => 'Last updated: September 11, 2026';

  @override
  String get termsConditionsIntro =>
      'Please read these Terms & Conditions carefully before using Statusly.';

  @override
  String get termsConditionsSection1Title => 'Acceptance of These Terms';

  @override
  String get termsConditionsSection1Paragraph1 =>
      'These Terms & Conditions (\"Terms\") govern your use of the Statusly mobile application (\"Statusly\", \"the App\", or \"our App\").';

  @override
  String get termsConditionsSection1Paragraph2 =>
      'By downloading, installing, accessing, or using Statusly, you agree to be bound by these Terms.';

  @override
  String get termsConditionsSection1Paragraph3 =>
      'If you do not agree with these Terms, you should not use the App.';

  @override
  String get termsConditionsSection2Title => 'Description of the App';

  @override
  String get termsConditionsSection2Paragraph1 =>
      'Statusly is a utility application designed to help users view and save photos and videos from supported WhatsApp status media that they can access on their Android device.';

  @override
  String get termsConditionsSection2Paragraph2 =>
      'The App does not provide WhatsApp accounts, WhatsApp messaging services, or WhatsApp account management services.';

  @override
  String get termsConditionsSection3Title => 'Eligibility';

  @override
  String get termsConditionsSection3Paragraph1 =>
      'You are responsible for ensuring that your use of Statusly is permitted under the laws and regulations applicable to you.';

  @override
  String get termsConditionsSection3Paragraph2 =>
      'If you are not legally permitted to use an application of this type in your location, you must not use Statusly.';

  @override
  String get termsConditionsSection4Title => 'Proper Use of Statusly';

  @override
  String get termsConditionsSection4Paragraph1 =>
      'You agree to use Statusly only for lawful purposes and in accordance with these Terms.';

  @override
  String get termsConditionsSection4Paragraph2 =>
      'You must not use Statusly to:';

  @override
  String get termsConditionsSection4Bullet1 =>
      'Violate any applicable law or regulation.';

  @override
  String get termsConditionsSection4Bullet2 =>
      'Infringe the copyright, trademark, privacy, publicity, intellectual property, or other rights of another person.';

  @override
  String get termsConditionsSection4Bullet3 =>
      'Save, copy, distribute, or use content without appropriate authorization where authorization is required.';

  @override
  String get termsConditionsSection4Bullet4 =>
      'Harass, threaten, impersonate, or harm another person.';

  @override
  String get termsConditionsSection4Bullet5 =>
      'Attempt to interfere with, damage, reverse engineer, or disrupt the App or its supporting systems, except where such activity is expressly permitted by applicable law.';

  @override
  String get termsConditionsSection4Bullet6 =>
      'Use the App for fraudulent, abusive, or unlawful activities.';

  @override
  String get termsConditionsSection5Title => 'Responsibility for Saved Content';

  @override
  String get termsConditionsSection5Paragraph1 =>
      'Statusly does not determine whether you have permission to save, copy, share, publish, or otherwise use a particular photo or video.';

  @override
  String get termsConditionsSection5Paragraph2 =>
      'You are responsible for determining whether you have the necessary rights or permission to use content accessed through Statusly.';

  @override
  String get termsConditionsSection5Paragraph3 =>
      'You are also responsible for how you use any content saved using the App.';

  @override
  String get termsConditionsSection5Paragraph4 =>
      'You should respect the rights and wishes of content creators, owners, and other individuals represented in the content.';

  @override
  String get termsConditionsSection6Title => 'WhatsApp and Meta Disclaimer';

  @override
  String get termsConditionsSection6Paragraph1 =>
      'Statusly is an independent third-party application.';

  @override
  String get termsConditionsSection6Paragraph2 =>
      'Statusly is not affiliated with, endorsed by, sponsored by, or officially connected with WhatsApp or Meta Platforms, Inc.';

  @override
  String get termsConditionsSection6Paragraph3 =>
      'WhatsApp, Meta, and their respective names, trademarks, logos, and related intellectual property belong to their respective owners.';

  @override
  String get termsConditionsSection6Paragraph4 =>
      'Statusly does not claim ownership of WhatsApp or Meta\'s trademarks or intellectual property.';

  @override
  String get termsConditionsSection7Title => 'Privacy';

  @override
  String get termsConditionsSection7Paragraph1 =>
      'Your use of Statusly is also subject to our Privacy Policy.';

  @override
  String get termsConditionsSection7Paragraph2 =>
      'The Privacy Policy explains how Statusly handles information and the permissions required for the App\'s functionality.';

  @override
  String get termsConditionsSection8Title => 'App Permissions';

  @override
  String get termsConditionsSection8Paragraph1 =>
      'Statusly may request access to files, folders, photos, videos, or other device resources that are necessary for the App\'s status-saving functionality.';

  @override
  String get termsConditionsSection8Paragraph2 =>
      'You control whether to grant requested permissions or folder access through the Android operating system.';

  @override
  String get termsConditionsSection8Paragraph3 =>
      'If you do not grant access required for a particular feature, that feature may not function correctly.';

  @override
  String get termsConditionsSection9Title => 'Saved Files';

  @override
  String get termsConditionsSection9Paragraph1 =>
      'When you use Statusly to save media, the saved files are stored on your device.';

  @override
  String get termsConditionsSection9Paragraph2 =>
      'You are responsible for managing, protecting, backing up, and deleting files saved through the App.';

  @override
  String get termsConditionsSection9Paragraph3 =>
      'We are not responsible for files that you delete, move, overwrite, lose, or otherwise make inaccessible on your device.';

  @override
  String get termsConditionsSection10Title => 'Availability of the App';

  @override
  String get termsConditionsSection10Paragraph1 =>
      'We aim to keep Statusly available and functional, but we do not guarantee that the App will always operate without interruption, errors, delays, or compatibility problems.';

  @override
  String get termsConditionsSection10Paragraph2 =>
      'Statusly\'s functionality may be affected by factors outside our control, including Android updates, device configuration, storage limitations, file-system changes, WhatsApp changes, operating-system restrictions, or other third-party changes.';

  @override
  String get termsConditionsSection11Title => 'Changes to the App';

  @override
  String get termsConditionsSection11Paragraph1 =>
      'Statusly may be modified, updated, improved, restricted, suspended, or discontinued in whole or in part at any time.';

  @override
  String get termsConditionsSection11Paragraph2 =>
      'Updates may change how certain features work or introduce new functionality.';

  @override
  String get termsConditionsSection12Title => 'Third-Party Services';

  @override
  String get termsConditionsSection12Paragraph1 =>
      'Statusly may interact with or rely on functionality provided by third-party applications or services, including Android system functionality.';

  @override
  String get termsConditionsSection12Paragraph2 =>
      'Third-party applications and services are governed by their own terms and policies. Statusly is not responsible for the availability, content, policies, or practices of third-party services.';

  @override
  String get termsConditionsSection13Title => 'Intellectual Property';

  @override
  String get termsConditionsSection13Paragraph1 =>
      'Unless otherwise stated, the original software, design, branding, interface, graphics, text, and other original materials that make up Statusly are protected by applicable intellectual property laws.';

  @override
  String get termsConditionsSection13Paragraph2 =>
      'You may not reproduce, modify, distribute, sell, sublicense, or commercially exploit the App or its original components except where expressly permitted by applicable law or by the applicable rights holder.';

  @override
  String get termsConditionsSection14Title => 'No Warranty';

  @override
  String get termsConditionsSection14Paragraph1 =>
      'To the maximum extent permitted by applicable law, Statusly is provided on an \"as is\" and \"as available\" basis.';

  @override
  String get termsConditionsSection14Paragraph2 =>
      'We do not guarantee that the App will always be available, error-free, secure, compatible with every Android device, or capable of accessing every type of WhatsApp status media.';

  @override
  String get termsConditionsSection14Paragraph3 =>
      'We do not guarantee that every status photo or video will be successfully detected, displayed, previewed, or saved.';

  @override
  String get termsConditionsSection15Title => 'Limitation of Liability';

  @override
  String get termsConditionsSection15Paragraph1 =>
      'To the maximum extent permitted by applicable law, we shall not be responsible for indirect, incidental, special, consequential, or punitive damages arising from or related to your use of Statusly.';

  @override
  String get termsConditionsSection15Paragraph2 =>
      'This may include, where permitted by law, loss of files, loss of data, device issues, loss of profits, interruption of service, or problems caused by third-party applications or services.';

  @override
  String get termsConditionsSection15Paragraph3 =>
      'Nothing in these Terms is intended to exclude or limit liability that cannot lawfully be excluded or limited under applicable law.';

  @override
  String get termsConditionsSection16Title => 'Termination';

  @override
  String get termsConditionsSection16Paragraph1 =>
      'You may stop using Statusly at any time by uninstalling the App from your device.';

  @override
  String get termsConditionsSection16Paragraph2 =>
      'Access to the App or particular features may also be restricted or discontinued where necessary for security, legal, technical, or operational reasons.';

  @override
  String get termsConditionsSection17Title => 'Changes to These Terms';

  @override
  String get termsConditionsSection17Paragraph1 =>
      'These Terms may be updated from time to time.';

  @override
  String get termsConditionsSection17Paragraph2 =>
      'When changes are made, the \"Last updated\" date at the top of this page will be updated.';

  @override
  String get termsConditionsSection17Paragraph3 =>
      'Your continued use of Statusly after updated Terms become available means that you accept the updated Terms to the extent permitted by applicable law.';

  @override
  String get termsConditionsSection18Title => 'Governing Law';

  @override
  String get termsConditionsSection18Paragraph1 =>
      'These Terms shall be governed by and interpreted in accordance with applicable law, without regard to conflict-of-law principles, except where applicable law requires otherwise.';

  @override
  String get termsConditionsSection18Paragraph2 =>
      'Nothing in these Terms removes or limits any rights that you may have under mandatory consumer protection laws applicable to you.';

  @override
  String get termsConditionsSection19Title => 'Contact';

  @override
  String get termsConditionsSection19Paragraph1 =>
      'If you have questions about these Terms & Conditions or Statusly, please contact:';

  @override
  String get termsConditionsContactName => 'Iszy_Man';

  @override
  String get termsConditionsContactEmail => 'iszifyaws@gmail.com';

  @override
  String get termsConditionsCopyright =>
      '© 2026 Iszy_Man. All rights reserved.';

  @override
  String get termsConditionsFooterDisclaimer =>
      'Statusly is an independent application and is not affiliated with WhatsApp or Meta Platforms, Inc.';

  @override
  String get status => 'Status';

  @override
  String get alreadySavedToGallery => 'Already saved to your gallery.';

  @override
  String get savedToGallery => 'Saved to your gallery.';

  @override
  String get unableToSaveStatus => 'Unable to save status.';

  @override
  String unableToSaveStatusWithError(Object error) {
    return 'Unable to save status: $error';
  }

  @override
  String get unableToShareStatus => 'Unable to share status.';

  @override
  String unableToShareStatusWithError(Object error) {
    return 'Unable to share status: $error';
  }

  @override
  String get videoFileDoesNotExist => 'Video file does not exist.';

  @override
  String get videoFileIsEmpty => 'Video file is empty.';

  @override
  String get unableToPlayVideo => 'Unable to play video.';

  @override
  String get saving => 'Saving...';

  @override
  String get download => 'Download';

  @override
  String get sharing => 'Sharing...';

  @override
  String get share => 'Share';

  @override
  String saveSourceStatusTitle(Object sourceName) {
    return 'Save $sourceName\nStatus Videos & Photos';
  }

  @override
  String get allowAccessToStatusesFolder =>
      'Allow access to the\n\".Statuses\" folder';

  @override
  String get allowAccessButton => 'Allow Access 👈';
}
