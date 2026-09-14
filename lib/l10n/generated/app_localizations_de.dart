// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Save Statusly';

  @override
  String get chooseLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get selectPreferredLanguage => 'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get continueButton => 'Weiter';

  @override
  String get allowAccess => 'Zugriff erlauben';

  @override
  String get statuses => 'Status';

  @override
  String get saved => 'Gespeichert';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get generalSettings => 'Allgemeine Einstellungen';

  @override
  String get manageWhatsAppStatusSources =>
      'Verwalten Sie Ihre WhatsApp-Statusquellen.';

  @override
  String get openWhatsApp => 'WhatsApp öffnen';

  @override
  String get returnDirectlyToWhatsApp => 'Direkt zu WhatsApp zurückkehren';

  @override
  String get howToUseStatusly => 'So verwenden Sie Statusly';

  @override
  String get learnHowToViewAndSaveStatuses =>
      'Erfahren Sie, wie Sie Status ansehen und speichern';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get learnHowStatuslyHandlesInformation =>
      'Erfahren Sie, wie Statusly Ihre Informationen verarbeitet';

  @override
  String get termsAndConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get readTermsForUsingStatusly =>
      'Lesen Sie die Bedingungen für die Nutzung von Statusly';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get getHelpWithStatusly => 'Hilfe bei Statusly erhalten';

  @override
  String get statusAccessIsConfigured => 'Statuszugriff ist konfiguriert';

  @override
  String get statusFolderNeedsConfiguration =>
      'Statusordner muss konfiguriert werden';

  @override
  String get noEmailAppFound =>
      'Auf diesem Gerät wurde keine E-Mail-App gefunden.';

  @override
  String get unableToOpenEmail =>
      'Ihre E-Mail-App konnte nicht geöffnet werden.';

  @override
  String get onboardingDescription =>
      'Speichern Sie Fotos und Videos aus WhatsApp-Statusmeldungen.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get byContinuingYouAcknowledgeOur =>
      'Indem Sie fortfahren, bestätigen Sie unsere';

  @override
  String get and => 'und';

  @override
  String get saveStatus => 'Status speichern';

  @override
  String get savePhotosAndVideosFromWhatsAppStatuses =>
      'Speichern Sie Fotos und Videos aus Ihren WhatsApp-Statusmeldungen.';

  @override
  String get statusAccessIsReady => 'Statuszugriff ist bereit';

  @override
  String get setUpStatusAccess => 'Statuszugriff einrichten';

  @override
  String get whatsappNotFound => 'WhatsApp nicht gefunden';

  @override
  String get installWhatsAppOrBusinessToUseStatusly =>
      'Installieren Sie WhatsApp oder WhatsApp Business, um Statusly zu verwenden.';

  @override
  String get noVideosFound => 'Keine Videos gefunden';

  @override
  String get noImagesFound => 'Keine Bilder gefunden';

  @override
  String get videoStatusesWillAppearHere =>
      'Videostatus werden hier angezeigt.';

  @override
  String get imageStatusesWillAppearHere => 'Bildstatus werden hier angezeigt.';

  @override
  String get noSavedVideos => 'Keine gespeicherten Videos';

  @override
  String get noSavedImages => 'Keine gespeicherten Bilder';

  @override
  String get videosYouSaveWillAppearHere =>
      'Gespeicherte Videos werden hier angezeigt.';

  @override
  String get imagesYouSaveWillAppearHere =>
      'Gespeicherte Bilder werden hier angezeigt.';

  @override
  String get howToSaveAStatus => 'So speichern Sie einen Status';

  @override
  String viewAStatusOn(Object sourceName) {
    return 'Status auf $sourceName ansehen';
  }

  @override
  String get openSaveStatusly => 'Save Statusly öffnen';

  @override
  String get returnToSaveStatuslyAfterViewing =>
      'Kehren Sie nach dem Ansehen des Status zu Save Statusly zurück.';

  @override
  String get saveOrDownloadTheStatus => 'Status speichern oder herunterladen';

  @override
  String get viewedStatusWillAppearHere =>
      'Der angesehene Status wird hier angezeigt. Öffnen Sie ihn und tippen Sie auf Speichern oder Herunterladen.';

  @override
  String openSource(Object sourceName) {
    return '$sourceName öffnen';
  }

  @override
  String get exitStatusly => 'Statusly beenden?';

  @override
  String get areYouSureYouWantToCloseTheApp =>
      'Möchten Sie die App wirklich schließen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get exit => 'Beenden';

  @override
  String get unableToOpenWhatsApp => 'WhatsApp konnte nicht geöffnet werden.';

  @override
  String sourceNotInstalled(Object sourceName) {
    return '$sourceName ist nicht installiert.';
  }

  @override
  String sourceStatusAccessReady(Object sourceName) {
    return 'Der Statuszugriff für $sourceName ist bereit.';
  }

  @override
  String get pleaseSelectStatusesFolder =>
      'Bitte wählen Sie den Ordner .Statuses aus.';

  @override
  String unableToSetUpStatusAccess(Object error) {
    return 'Der Statuszugriff konnte nicht eingerichtet werden: $error';
  }

  @override
  String unableToOpenStatus(Object error) {
    return 'Der Status konnte nicht geöffnet werden: $error';
  }

  @override
  String get openWhatsAppTooltip => 'WhatsApp öffnen';

  @override
  String openSourceAndViewStatus(Object sourceName) {
    return 'Öffnen Sie $sourceName und sehen Sie sich den Foto- oder Videostatus an, den Sie speichern möchten.';
  }

  @override
  String get images => 'Bilder';

  @override
  String get videos => 'Videos';

  @override
  String get statusPhotosAndVideoDownloader =>
      'Downloader für Statusfotos und -videos';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get howToUseDescription =>
      'Speichere Fotos und Videos aus WhatsApp-Statusmeldungen direkt auf deinem Gerät.';

  @override
  String get howToUseStep1Title => 'WhatsApp auswählen';

  @override
  String get howToUseStep1Description =>
      'Wähle WhatsApp oder WhatsApp Business aus, je nachdem, welche Statusquelle du verwenden möchtest.';

  @override
  String get howToUseStep2Title =>
      'Statusly den Zugriff auf Statusmeldungen erlauben';

  @override
  String get howToUseStep2Description =>
      'Android fordert dich auf, Statusly den Zugriff auf den ausgewählten WhatsApp-Statusordner zu erlauben. Folge der Android-Anweisung und bestätige die Auswahl des Ordners.';

  @override
  String get howToUseStep3Title => 'Verfügbare Statusmeldungen anzeigen';

  @override
  String get howToUseStep3Description =>
      'Sobald der Zugriff eingerichtet ist, zeigt Statusly verfügbare Statusfotos und -videos im Tab Status an.';

  @override
  String get howToUseStep4Title => 'Eine Statusmeldung öffnen';

  @override
  String get howToUseStep4Description =>
      'Tippe auf ein Foto oder Video, um es anzusehen. Videos können direkt in Statusly abgespielt werden.';

  @override
  String get howToUseStep5Title => 'Eine Statusmeldung speichern';

  @override
  String get howToUseStep5Description =>
      'Verwende beim Anzeigen einer Statusmeldung die Speicheroption, um das ausgewählte Foto oder Video auf deinem Gerät zu speichern.';

  @override
  String get howToUseStep6Title => 'Gespeicherte Medien finden';

  @override
  String get howToUseStep6Description =>
      'Gespeicherte Fotos und Videos sind im Tab Gespeichert in Statusly verfügbar. Sie werden auch auf deinem Gerät gespeichert.';

  @override
  String get howToUseStep7Title => 'Eine Statusmeldung teilen';

  @override
  String get howToUseStep7Description =>
      'Verwende die Teilen-Option, um unterstützte Medien über andere auf deinem Gerät installierte Apps zu senden.';

  @override
  String get howToUseUsefulTips => 'Nützliche Tipps';

  @override
  String get howToUseTip1 =>
      'Wenn du sowohl WhatsApp als auch WhatsApp Business verwendest, konfiguriere jede Quelle separat über die Einstellungen.';

  @override
  String get howToUseTip2 =>
      'Statusly lädt deine Statusfotos oder -videos nicht auf einen Statusly-Server hoch. Unterstützte Statusmedien werden lokal auf deinem Gerät verarbeitet.';

  @override
  String get howToUseTip3 =>
      'Wenn ein neuer Status nicht sofort angezeigt wird, kehre zum Tab Status zurück und aktualisiere die Liste.';

  @override
  String get howToUseTip4 =>
      'Speichere oder teile nur Statusmedien, für deren Nutzung du die entsprechende Erlaubnis oder Genehmigung hast.';

  @override
  String get howToUseNeedHelp => 'Brauchst du Hilfe?';

  @override
  String get howToUseHelpDescription =>
      'Wenn du bei der Verwendung von Statusly ein Problem hast, kontaktiere den Support über den Einstellungsbildschirm.';

  @override
  String get privacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get privacyPolicyHeading => 'Datenschutzerklärung von Statusly';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert: 11. September 2026';

  @override
  String get privacyPolicyIntro =>
      'Statusly wurde entwickelt, damit du Fotos und Videos aus WhatsApp-Statusmeldungen auf deinem Android-Gerät ansehen und speichern kannst.';

  @override
  String get privacySection1 => '1. Einleitung';

  @override
  String get privacySection1Paragraph1 =>
      'Diese Datenschutzerklärung erläutert, wie Statusly mit Informationen umgeht, wenn du die mobile Statusly-Anwendung („Statusly“, „die App“ oder „unsere App“) verwendest.';

  @override
  String get privacySection1Paragraph2 =>
      'Statusly ist nach einem lokalen Ansatz konzipiert. Die App erfordert keine Erstellung eines Kontos und die aktuelle Version verwendet keinen Server, auf dem deine WhatsApp-Statusfotos oder -videos gespeichert werden.';

  @override
  String get privacySection1Paragraph3 =>
      'Diese Datenschutzerklärung erläutert, auf welche Informationen Statusly zugreift, wie diese Informationen verwendet werden, ob sie mit Dritten geteilt werden und wie Informationen gespeichert oder gelöscht werden.';

  @override
  String get privacySection2 => '2. Auf welche Informationen Statusly zugreift';

  @override
  String get privacySection2Paragraph1 =>
      'Statusly kann auf Fotos und Videos zugreifen, die an unterstützten Speicherorten für WhatsApp-Statusmedien auf deinem Android-Gerät gespeichert sind, wenn du der App den erforderlichen Zugriff gewährst oder den entsprechenden Ordner über das Datei- oder Ordnerauswahlsystem von Android auswählst.';

  @override
  String get privacySection2Paragraph2 =>
      'Dieser Zugriff ist für die Hauptfunktion von Statusly erforderlich: verfügbare WhatsApp-Statusmedien anzuzeigen, damit du sie ansehen und auf deinem Gerät speichern kannst.';

  @override
  String get privacySection2Paragraph3 =>
      'Abhängig von deinem Gerät, deiner Android-Version und den installierten WhatsApp-Anwendungen unterstützt Statusly möglicherweise Statusordner von WhatsApp und WhatsApp Business.';

  @override
  String get privacySection3 => '3. Wie Statusly aufgerufene Medien verwendet';

  @override
  String get privacySection3Paragraph1 =>
      'Statusly verwendet die Statusfotos und -videos, auf die es zugreift, um die Funktionen der App bereitzustellen, darunter:';

  @override
  String get privacyBulletDisplayStatuses =>
      'Verfügbare Statusfotos und -videos anzeigen.';

  @override
  String get privacyBulletViewStatuses =>
      'Dir das Anzeigen von Statusmedien ermöglichen.';

  @override
  String get privacyBulletSaveStatuses =>
      'Dir das Speichern ausgewählter Statusmedien ermöglichen.';

  @override
  String get privacyBulletViewSaved =>
      'Dir das Anzeigen von mit der App gespeicherten Medien ermöglichen.';

  @override
  String get privacyBulletShareMedia =>
      'Dir die Nutzung unterstützter Funktionen zum Teilen oder Öffnen auf deinem Gerät ermöglichen.';

  @override
  String get privacySection3Paragraph2 =>
      'Die aktuelle Version von Statusly verarbeitet unterstützte Statusmedien lokal auf deinem Gerät. Statusly muss deine WhatsApp-Statusfotos oder -videos nicht auf einen Statusly-Server hochladen, um diese Kernfunktionen bereitzustellen.';

  @override
  String get privacySection4 => '4. Informationen, die wir nicht erfassen';

  @override
  String get privacySection4Paragraph1 =>
      'Die aktuelle Version von Statusly erfordert keine Erstellung eines Kontos und erfasst nicht absichtlich personenbezogene Informationen wie:';

  @override
  String get privacyBulletName => 'Deinen Namen.';

  @override
  String get privacyBulletPhone => 'Deine Telefonnummer.';

  @override
  String get privacyBulletEmail => 'Deine E-Mail-Adresse über die App.';

  @override
  String get privacyBulletWhatsAppCredentials =>
      'Deine Zugangsdaten für dein WhatsApp-Konto.';

  @override
  String get privacyBulletWhatsAppMessages => 'Deine WhatsApp-Nachrichten.';

  @override
  String get privacyBulletWhatsAppContacts => 'Deine WhatsApp-Kontakte.';

  @override
  String get privacyBulletPasswords => 'Deine Passwörter.';

  @override
  String get privacyBulletPayment => 'Deine Zahlungsinformationen.';

  @override
  String get privacyBulletLocation => 'Deinen genauen Standort.';

  @override
  String get privacySection4Paragraph2 =>
      'Statusly benötigt für seine Kernfunktionen außerdem keinen Benutzernamen und kein Passwort.';

  @override
  String get privacySection5 => '5. Lokaler Speicher und App-Einstellungen';

  @override
  String get privacySection5Paragraph1 =>
      'Statusly kann bestimmte App-Einstellungen lokal auf deinem Gerät speichern. Dazu können Informationen darüber gehören, ob du die Einrichtung abgeschlossen hast oder welche unterstützte Statusquelle du zuletzt ausgewählt hast.';

  @override
  String get privacySection5Paragraph2 =>
      'Diese Informationen werden lokal auf deinem Gerät gespeichert und verwendet, damit die App ordnungsgemäß funktioniert und deine Einstellungen gespeichert werden.';

  @override
  String get privacySection5Paragraph3 =>
      'Diese lokal gespeicherten Einstellungsinformationen werden von Statusly nicht verwendet, um dich persönlich zu identifizieren.';

  @override
  String get privacySection6 => '6. Gespeicherte Fotos und Videos';

  @override
  String get privacySection6Paragraph1 =>
      'Wenn du ein Foto oder Video mit Statusly speicherst, wird die resultierende Datei entsprechend der Speicherfunktion der App und dem Android-Speichersystem auf deinem Gerät gespeichert.';

  @override
  String get privacySection6Paragraph2 =>
      'Statusly speichert im normalen Betrieb der App keine serverseitige Kopie deiner gespeicherten Statusmedien.';

  @override
  String get privacySection6Paragraph3 =>
      'Von dir gespeicherte Dateien bleiben auf deinem Gerät, bis du sie über die verfügbaren Funktionen deines Geräts, der Galerie, des Dateimanagers oder der App löschst.';

  @override
  String get privacySection7 => '7. Weitergabe von Informationen an Dritte';

  @override
  String get privacySection7Paragraph1 =>
      'Statusly verkauft, vermietet oder handelt nicht mit deinen personenbezogenen Informationen.';

  @override
  String get privacySection7Paragraph2 =>
      'In der aktuellen Version der App sendet Statusly deine WhatsApp-Statusfotos oder -videos nicht absichtlich zur Speicherung oder zu Werbezwecken an Server von Drittanbietern.';

  @override
  String get privacySection7Paragraph3 =>
      'Wenn du die Android-Funktionen zum Teilen, Öffnen oder andere Funktionen von Drittanbietern verwendest, können die von dir ausgewählten Informationen oder Medien von der ausgewählten Anwendung oder dem ausgewählten Dienst verarbeitet werden. Diese Verarbeitung unterliegt der Datenschutzerklärung und den Nutzungsbedingungen des jeweiligen Drittanbieters.';

  @override
  String get privacySection8 => '8. Dienste und Software von Drittanbietern';

  @override
  String get privacySection8Paragraph1 =>
      'Statusly kann Softwarebibliotheken von Drittanbietern verwenden, die für bestimmte technische Funktionen der App erforderlich sind.';

  @override
  String get privacySection8Paragraph2 =>
      'Software von Drittanbietern kann Informationen entsprechend ihrer eigenen technischen Funktionsweise und den geltenden Richtlinien verarbeiten.';

  @override
  String get privacySection8Paragraph3 =>
      'Wenn zukünftige Versionen von Statusly Analysefunktionen, Werbung, Absturzberichte, Cloud-Dienste oder andere Dienste von Drittanbietern einführen, die Nutzerdaten erfassen oder übertragen, wird diese Datenschutzerklärung aktualisiert, um die entsprechenden Datenpraktiken zu erläutern.';

  @override
  String get privacySection9 => '9. Werbung';

  @override
  String get privacySection9Paragraph1 =>
      'Die aktuelle Version von Statusly verwendet keine Werbedienste als Teil ihrer Kernfunktionen.';

  @override
  String get privacySection9Paragraph2 =>
      'Wenn in einer zukünftigen Version Werbedienste eingeführt werden, wird diese Datenschutzerklärung aktualisiert, um die entsprechende Werbetechnologie, Datenpraktiken und Dienste von Drittanbietern zu erläutern.';

  @override
  String get privacySection10 => '10. Datensicherheit';

  @override
  String get privacySection10Paragraph1 =>
      'Es werden angemessene Maßnahmen getroffen, um die von Statusly verarbeiteten Informationen zu schützen und den Zugriff auf die für die Funktion der App erforderlichen Informationen zu beschränken.';

  @override
  String get privacySection10Paragraph2 =>
      'Da Statusly unterstützte Statusmedien hauptsächlich lokal auf deinem Android-Gerät verarbeitet, werden deine Statusmedien normalerweise nicht zur Speicherung an einen Statusly-Server übertragen.';

  @override
  String get privacySection10Paragraph3 =>
      'Allerdings kann kein elektronisches Speichersystem und keine Übertragungsmethode als vollständig sicher garantiert werden. Du solltest außerdem die Sicherheitsfunktionen deines Android-Geräts verwenden, um deine Dateien und Informationen zu schützen.';

  @override
  String get privacySection11 => '11. Aufbewahrung und Löschung von Daten';

  @override
  String get privacySection11Paragraph1 =>
      'Statusly führt kein serverseitiges Konto, das deine personenbezogenen Informationen enthält.';

  @override
  String get privacySection11Paragraph2 =>
      'Lokale App-Einstellungen bleiben auf deinem Gerät gespeichert, solange sie von der App benötigt werden. Je nach Android-Gerät und Einstellungen können durch die Deinstallation von Statusly oder das Löschen der App-Daten lokal gespeicherte App-Daten entfernt werden.';

  @override
  String get privacySection11Paragraph3 =>
      'Fotos und Videos, die du speicherst, sind Dateien auf deinem Gerät. Du kannst diese Dateien über die Galerie deines Geräts, den Dateimanager oder eine andere verfügbare Löschfunktion entfernen.';

  @override
  String get privacySection11Paragraph4 =>
      'Da Statusly in der aktuellen Version keine Benutzerkonten erfordert, gibt es kein Statusly-Konto, dessen Löschung du beantragen musst.';

  @override
  String get privacySection12 => '12. Datenschutz für Kinder';

  @override
  String get privacySection12Paragraph1 =>
      'Statusly wurde nicht speziell für Kinder entwickelt.';

  @override
  String get privacySection12Paragraph2 =>
      'Wir erfassen über die App nicht wissentlich personenbezogene Informationen von Kindern. Wenn du glaubst, dass ein Kind uns personenbezogene Informationen zur Verfügung gestellt hat, kontaktiere uns bitte, damit der Fall geprüft werden kann.';

  @override
  String get privacySection13 => '13. Haftungsausschluss zu WhatsApp und Meta';

  @override
  String get privacySection13Paragraph1 =>
      'Statusly ist eine unabhängige Anwendung und steht nicht mit WhatsApp oder Meta Platforms, Inc. in Verbindung, wird von ihnen nicht unterstützt oder gesponsert und ist nicht offiziell mit ihnen verbunden.';

  @override
  String get privacySection13Paragraph2 =>
      '„WhatsApp“ sowie die zugehörigen Namen, Marken und Logos gehören ihren jeweiligen Eigentümern.';

  @override
  String get privacySection13Paragraph3 =>
      'Statusly ist ein Dienstprogramm eines Drittanbieters, das Nutzern dabei helfen soll, Statusmedien zu verwalten und zu speichern, auf die sie zugreifen und die sie speichern dürfen.';

  @override
  String get privacySection14 =>
      '14. Deine Verantwortung für gespeicherte Inhalte';

  @override
  String get privacySection14Paragraph1 =>
      'Statusly stellt Werkzeuge zum Speichern von Medien bereit, auf die du auf deinem Gerät zugreifen kannst.';

  @override
  String get privacySection14Paragraph2 =>
      'Du bist dafür verantwortlich sicherzustellen, dass du über die erforderlichen Rechte, Genehmigungen oder Erlaubnisse verfügst, um Fotos, Videos oder andere Inhalte, auf die du über die App zugreifst, zu speichern, zu kopieren, zu teilen oder anderweitig zu verwenden.';

  @override
  String get privacySection14Paragraph3 =>
      'Du solltest die Privatsphäre, Urheberrechte, geistigen Eigentumsrechte und sonstigen gesetzlichen Rechte von Inhaltserstellern und anderen Personen respektieren.';

  @override
  String get privacySection15 => '15. Änderungen dieser Datenschutzerklärung';

  @override
  String get privacySection15Paragraph1 =>
      'Diese Datenschutzerklärung kann von Zeit zu Zeit aktualisiert werden, um Änderungen an Statusly, Änderungen geltender Gesetze oder Änderungen der Datenpraktiken widerzuspiegeln.';

  @override
  String get privacySection15Paragraph2 =>
      'Wenn Änderungen vorgenommen werden, wird das Datum „Zuletzt aktualisiert“ oben auf dieser Seite aktualisiert.';

  @override
  String get privacySection15Paragraph3 =>
      'Wir empfehlen dir, diese Datenschutzerklärung regelmäßig zu lesen, um darüber informiert zu bleiben, wie Statusly mit Informationen umgeht.';

  @override
  String get privacySection16 => '16. Kontakt';

  @override
  String get privacySection16Paragraph1 =>
      'Wenn du Fragen, Bedenken oder Anfragen zu dieser Datenschutzerklärung oder den Datenschutzpraktiken von Statusly hast, kontaktiere bitte:';

  @override
  String get privacyCopyright => '© 2026 Iszy_Man. Alle Rechte vorbehalten.';

  @override
  String get privacyDisclaimer =>
      'Statusly ist eine unabhängige Anwendung und steht nicht mit WhatsApp oder Meta Platforms, Inc. in Verbindung.';

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
  String get alreadySavedToGallery => 'Bereits in deiner Galerie gespeichert.';

  @override
  String get savedToGallery => 'In deiner Galerie gespeichert.';

  @override
  String get unableToSaveStatus => 'Status konnte nicht gespeichert werden.';

  @override
  String unableToSaveStatusWithError(Object error) {
    return 'Status konnte nicht gespeichert werden: $error';
  }

  @override
  String get unableToShareStatus => 'Status konnte nicht geteilt werden.';

  @override
  String unableToShareStatusWithError(Object error) {
    return 'Status konnte nicht geteilt werden: $error';
  }

  @override
  String get videoFileDoesNotExist => 'Die Videodatei existiert nicht.';

  @override
  String get videoFileIsEmpty => 'Die Videodatei ist leer.';

  @override
  String get unableToPlayVideo => 'Video konnte nicht wiedergegeben werden.';

  @override
  String get saving => 'Wird gespeichert...';

  @override
  String get download => 'Herunterladen';

  @override
  String get sharing => 'Wird geteilt...';

  @override
  String get share => 'Teilen';

  @override
  String saveSourceStatusTitle(Object sourceName) {
    return 'Status von $sourceName speichern\nVideos und Fotos';
  }

  @override
  String get allowAccessToStatusesFolder =>
      'Zugriff auf den\n\".Statuses\"-Ordner erlauben';

  @override
  String get allowAccessButton => 'Zugriff erlauben 👈';
}
