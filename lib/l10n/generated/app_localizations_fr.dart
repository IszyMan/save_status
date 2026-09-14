// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Save Statusly';

  @override
  String get chooseLanguage => 'Choisissez votre langue';

  @override
  String get selectPreferredLanguage => 'Sélectionnez votre langue préférée';

  @override
  String get continueButton => 'Continuer';

  @override
  String get allowAccess => 'Autoriser l\'accès';

  @override
  String get statuses => 'Statuts';

  @override
  String get saved => 'Enregistrés';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get generalSettings => 'Paramètres généraux';

  @override
  String get manageWhatsAppStatusSources =>
      'Gérez vos sources de statuts WhatsApp.';

  @override
  String get openWhatsApp => 'Ouvrir WhatsApp';

  @override
  String get returnDirectlyToWhatsApp => 'Retourner directement sur WhatsApp';

  @override
  String get howToUseStatusly => 'Comment utiliser Statusly';

  @override
  String get learnHowToViewAndSaveStatuses =>
      'Découvrez comment voir et enregistrer les statuts';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get learnHowStatuslyHandlesInformation =>
      'Découvrez comment Statusly gère vos informations';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get readTermsForUsingStatusly =>
      'Lisez les conditions d\'utilisation de Statusly';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get getHelpWithStatusly => 'Obtenez de l\'aide avec Statusly';

  @override
  String get statusAccessIsConfigured => 'L\'accès aux statuts est configuré';

  @override
  String get statusFolderNeedsConfiguration =>
      'Le dossier des statuts doit être configuré';

  @override
  String get noEmailAppFound =>
      'Aucune application de messagerie n\'a été trouvée sur cet appareil.';

  @override
  String get unableToOpenEmail =>
      'Impossible d\'ouvrir votre application de messagerie.';

  @override
  String get onboardingDescription =>
      'Enregistrez des photos et des vidéos depuis les statuts WhatsApp.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get byContinuingYouAcknowledgeOur =>
      'En continuant, vous reconnaissez notre';

  @override
  String get and => 'et';

  @override
  String get saveStatus => 'Enregistrer le statut';

  @override
  String get savePhotosAndVideosFromWhatsAppStatuses =>
      'Enregistrez les photos et vidéos de vos statuts WhatsApp.';

  @override
  String get statusAccessIsReady => 'L\'accès aux statuts est prêt';

  @override
  String get setUpStatusAccess => 'Configurer l\'accès aux statuts';

  @override
  String get whatsappNotFound => 'WhatsApp introuvable';

  @override
  String get installWhatsAppOrBusinessToUseStatusly =>
      'Installez WhatsApp ou WhatsApp Business pour utiliser Statusly.';

  @override
  String get noVideosFound => 'Aucune vidéo trouvée';

  @override
  String get noImagesFound => 'Aucune image trouvée';

  @override
  String get videoStatusesWillAppearHere =>
      'Les statuts vidéo apparaîtront ici.';

  @override
  String get imageStatusesWillAppearHere =>
      'Les statuts image apparaîtront ici.';

  @override
  String get noSavedVideos => 'Aucune vidéo enregistrée';

  @override
  String get noSavedImages => 'Aucune image enregistrée';

  @override
  String get videosYouSaveWillAppearHere =>
      'Les vidéos que vous enregistrez apparaîtront ici.';

  @override
  String get imagesYouSaveWillAppearHere =>
      'Les images que vous enregistrez apparaîtront ici.';

  @override
  String get howToSaveAStatus => 'Comment enregistrer un statut';

  @override
  String viewAStatusOn(Object sourceName) {
    return 'Voir un statut sur $sourceName';
  }

  @override
  String get openSaveStatusly => 'Ouvrir Save Statusly';

  @override
  String get returnToSaveStatuslyAfterViewing =>
      'Retournez dans Save Statusly après avoir consulté le statut.';

  @override
  String get saveOrDownloadTheStatus => 'Enregistrer ou télécharger le statut';

  @override
  String get viewedStatusWillAppearHere =>
      'Le statut consulté apparaîtra ici. Ouvrez-le et appuyez sur le bouton Enregistrer ou Télécharger.';

  @override
  String openSource(Object sourceName) {
    return 'Ouvrir $sourceName';
  }

  @override
  String get exitStatusly => 'Quitter Statusly ?';

  @override
  String get areYouSureYouWantToCloseTheApp =>
      'Voulez-vous vraiment fermer l\'application ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get exit => 'Quitter';

  @override
  String get unableToOpenWhatsApp => 'Impossible d\'ouvrir WhatsApp.';

  @override
  String sourceNotInstalled(Object sourceName) {
    return '$sourceName n\'est pas installé.';
  }

  @override
  String sourceStatusAccessReady(Object sourceName) {
    return 'L\'accès aux statuts de $sourceName est prêt.';
  }

  @override
  String get pleaseSelectStatusesFolder =>
      'Veuillez sélectionner le dossier .Statuses.';

  @override
  String unableToSetUpStatusAccess(Object error) {
    return 'Impossible de configurer l\'accès aux statuts : $error';
  }

  @override
  String unableToOpenStatus(Object error) {
    return 'Impossible d\'ouvrir le statut : $error';
  }

  @override
  String get openWhatsAppTooltip => 'Ouvrir WhatsApp';

  @override
  String openSourceAndViewStatus(Object sourceName) {
    return 'Ouvrez $sourceName et consultez la photo ou la vidéo que vous souhaitez enregistrer.';
  }

  @override
  String get images => 'Images';

  @override
  String get videos => 'Vidéos';

  @override
  String get statusPhotosAndVideoDownloader =>
      'Téléchargeur de photos et vidéos de statuts';

  @override
  String get loading => 'Chargement...';

  @override
  String get howToUseDescription =>
      'Enregistrez les photos et vidéos des statuts WhatsApp directement sur votre appareil.';

  @override
  String get howToUseStep1Title => 'Choisir WhatsApp';

  @override
  String get howToUseStep1Description =>
      'Sélectionnez WhatsApp ou WhatsApp Business selon la source de statuts que vous souhaitez utiliser.';

  @override
  String get howToUseStep2Title => 'Autoriser Statusly à accéder aux statuts';

  @override
  String get howToUseStep2Description =>
      'Android vous demandera d\'autoriser Statusly à accéder au dossier de statuts WhatsApp sélectionné. Suivez les instructions d\'Android et confirmez la sélection du dossier.';

  @override
  String get howToUseStep3Title => 'Afficher les statuts disponibles';

  @override
  String get howToUseStep3Description =>
      'Une fois l\'accès configuré, Statusly affichera les photos et vidéos de statut disponibles dans l\'onglet Statuts.';

  @override
  String get howToUseStep4Title => 'Ouvrir un statut';

  @override
  String get howToUseStep4Description =>
      'Appuyez sur une photo ou une vidéo pour la regarder. Les vidéos peuvent être lues directement dans Statusly.';

  @override
  String get howToUseStep5Title => 'Enregistrer un statut';

  @override
  String get howToUseStep5Description =>
      'Utilisez l\'option d\'enregistrement lorsque vous consultez un statut pour enregistrer la photo ou la vidéo sélectionnée sur votre appareil.';

  @override
  String get howToUseStep6Title => 'Retrouver vos fichiers enregistrés';

  @override
  String get howToUseStep6Description =>
      'Les photos et vidéos enregistrées sont disponibles dans l\'onglet Enregistrés de Statusly. Elles sont également stockées sur votre appareil.';

  @override
  String get howToUseStep7Title => 'Partager un statut';

  @override
  String get howToUseStep7Description =>
      'Utilisez l\'option de partage pour envoyer des fichiers multimédias compatibles via d\'autres applications installées sur votre appareil.';

  @override
  String get howToUseUsefulTips => 'Conseils utiles';

  @override
  String get howToUseTip1 =>
      'Si vous utilisez WhatsApp et WhatsApp Business, configurez chaque source séparément depuis les Paramètres.';

  @override
  String get howToUseTip2 =>
      'Statusly n\'envoie pas vos photos ou vidéos de statut vers un serveur Statusly. Les fichiers multimédias pris en charge sont traités localement sur votre appareil.';

  @override
  String get howToUseTip3 =>
      'Si un nouveau statut n\'apparaît pas immédiatement, revenez dans l\'onglet Statuts et actualisez la liste.';

  @override
  String get howToUseTip4 =>
      'Enregistrez ou partagez uniquement les fichiers multimédias de statut que vous êtes autorisé à utiliser.';

  @override
  String get howToUseNeedHelp => 'Besoin d\'aide ?';

  @override
  String get howToUseHelpDescription =>
      'Si vous rencontrez un problème lors de l\'utilisation de Statusly, contactez le support depuis l\'écran Paramètres.';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get privacyPolicyHeading => 'Politique de confidentialité de Statusly';

  @override
  String get lastUpdated => 'Dernière mise à jour : 11 septembre 2026';

  @override
  String get privacyPolicyIntro =>
      'Statusly est conçu pour vous aider à consulter et à enregistrer les photos et vidéos des statuts WhatsApp sur votre appareil Android.';

  @override
  String get privacySection1 => '1. Introduction';

  @override
  String get privacySection1Paragraph1 =>
      'Cette Politique de confidentialité explique comment Statusly traite les informations lorsque vous utilisez l\'application mobile Statusly (« Statusly », « l\'application » ou « notre application »).';

  @override
  String get privacySection1Paragraph2 =>
      'Statusly est conçu selon une approche locale. L\'application ne vous demande pas de créer un compte et la version actuelle n\'utilise pas de serveur qui stocke vos photos ou vidéos de statuts WhatsApp.';

  @override
  String get privacySection1Paragraph3 =>
      'Cette Politique de confidentialité explique à quelles informations Statusly accède, comment ces informations sont utilisées, si elles sont partagées avec des tiers et comment elles sont conservées ou supprimées.';

  @override
  String get privacySection2 => '2. Informations auxquelles Statusly accède';

  @override
  String get privacySection2Paragraph1 =>
      'Statusly peut accéder aux photos et vidéos stockées dans les emplacements pris en charge des fichiers multimédias de statuts WhatsApp sur votre appareil Android lorsque vous accordez à l\'application les autorisations nécessaires ou sélectionnez le dossier approprié à l\'aide du système Android de sélection de fichiers ou de dossiers.';

  @override
  String get privacySection2Paragraph2 =>
      'Cet accès est nécessaire au fonctionnement principal de Statusly : afficher les fichiers multimédias de statuts WhatsApp disponibles afin que vous puissiez les consulter et les enregistrer sur votre appareil.';

  @override
  String get privacySection2Paragraph3 =>
      'Selon votre appareil, votre version d\'Android et les applications WhatsApp installées, Statusly peut prendre en charge les dossiers de statuts WhatsApp et WhatsApp Business.';

  @override
  String get privacySection3 =>
      '3. Utilisation des fichiers multimédias accessibles par Statusly';

  @override
  String get privacySection3Paragraph1 =>
      'Statusly utilise les photos et vidéos de statuts auxquelles il accède pour fournir les fonctionnalités de l\'application, notamment :';

  @override
  String get privacyBulletDisplayStatuses =>
      'Afficher les photos et vidéos de statuts disponibles.';

  @override
  String get privacyBulletViewStatuses =>
      'Vous permettre de consulter les fichiers multimédias des statuts.';

  @override
  String get privacyBulletSaveStatuses =>
      'Vous permettre d\'enregistrer les fichiers multimédias de statuts sélectionnés.';

  @override
  String get privacyBulletViewSaved =>
      'Vous permettre de consulter les fichiers multimédias enregistrés avec l\'application.';

  @override
  String get privacyBulletShareMedia =>
      'Vous permettre d\'utiliser les fonctions prises en charge de partage ou d\'ouverture sur votre appareil.';

  @override
  String get privacySection3Paragraph2 =>
      'La version actuelle de Statusly traite localement sur votre appareil les fichiers multimédias de statuts pris en charge. Statusly n\'a pas besoin d\'envoyer vos photos ou vidéos de statuts WhatsApp vers un serveur Statusly pour fournir ces fonctionnalités principales.';

  @override
  String get privacySection4 => '4. Informations que nous ne collectons pas';

  @override
  String get privacySection4Paragraph1 =>
      'La version actuelle de Statusly ne vous demande pas de créer un compte et ne collecte pas intentionnellement d\'informations personnelles telles que :';

  @override
  String get privacyBulletName => 'Votre nom.';

  @override
  String get privacyBulletPhone => 'Votre numéro de téléphone.';

  @override
  String get privacyBulletEmail => 'Votre adresse e-mail via l\'application.';

  @override
  String get privacyBulletWhatsAppCredentials =>
      'Les identifiants de votre compte WhatsApp.';

  @override
  String get privacyBulletWhatsAppMessages => 'Vos messages WhatsApp.';

  @override
  String get privacyBulletWhatsAppContacts => 'Vos contacts WhatsApp.';

  @override
  String get privacyBulletPasswords => 'Vos mots de passe.';

  @override
  String get privacyBulletPayment => 'Vos informations de paiement.';

  @override
  String get privacyBulletLocation => 'Votre emplacement précis.';

  @override
  String get privacySection4Paragraph2 =>
      'Statusly ne nécessite pas non plus de nom d\'utilisateur ni de mot de passe pour utiliser ses fonctionnalités principales.';

  @override
  String get privacySection5 =>
      '5. Stockage local et préférences de l\'application';

  @override
  String get privacySection5Paragraph1 =>
      'Statusly peut stocker certaines préférences de l\'application localement sur votre appareil. Il peut notamment s\'agir d\'informations indiquant si vous avez terminé le processus d\'intégration ou quelle source de statuts prise en charge vous avez sélectionnée en dernier.';

  @override
  String get privacySection5Paragraph2 =>
      'Ces informations sont stockées localement sur votre appareil et sont utilisées pour assurer le bon fonctionnement de l\'application et mémoriser vos préférences.';

  @override
  String get privacySection5Paragraph3 =>
      'Ces informations de préférences locales ne sont pas utilisées par Statusly pour vous identifier personnellement.';

  @override
  String get privacySection6 => '6. Photos et vidéos enregistrées';

  @override
  String get privacySection6Paragraph1 =>
      'Lorsque vous choisissez d\'enregistrer une photo ou une vidéo avec Statusly, le fichier résultant est stocké sur votre appareil conformément à la fonctionnalité d\'enregistrement de l\'application et au système de stockage Android.';

  @override
  String get privacySection6Paragraph2 =>
      'Statusly ne conserve pas de copie sur serveur de vos fichiers multimédias de statuts enregistrés dans le cadre du fonctionnement normal de l\'application.';

  @override
  String get privacySection6Paragraph3 =>
      'Les fichiers que vous enregistrez restent sur votre appareil jusqu\'à ce que vous décidiez de les supprimer à l\'aide des fonctionnalités disponibles de votre appareil, de votre galerie, de votre gestionnaire de fichiers ou de l\'application.';

  @override
  String get privacySection7 => '7. Partage d\'informations avec des tiers';

  @override
  String get privacySection7Paragraph1 =>
      'Statusly ne vend, ne loue et n\'échange pas vos informations personnelles.';

  @override
  String get privacySection7Paragraph2 =>
      'Dans la version actuelle de l\'application, Statusly n\'envoie pas intentionnellement vos photos ou vidéos de statuts WhatsApp vers des serveurs tiers à des fins de stockage ou de publicité.';

  @override
  String get privacySection7Paragraph3 =>
      'Si vous choisissez d\'utiliser les fonctions Android de partage, d\'ouverture ou d\'autres fonctionnalités tierces, les informations ou fichiers multimédias que vous choisissez de partager peuvent être traités par l\'application ou le service que vous sélectionnez. Ce traitement est régi par la politique de confidentialité et les conditions du tiers concerné.';

  @override
  String get privacySection8 => '8. Services et logiciels tiers';

  @override
  String get privacySection8Paragraph1 =>
      'Statusly peut utiliser des bibliothèques logicielles tierces nécessaires à certaines fonctions techniques de l\'application.';

  @override
  String get privacySection8Paragraph2 =>
      'Les logiciels tiers peuvent traiter les informations conformément à leur propre fonctionnement technique et aux politiques applicables.';

  @override
  String get privacySection8Paragraph3 =>
      'Si de futures versions de Statusly introduisent des outils d\'analyse, de la publicité, des rapports de plantage, des services cloud ou d\'autres services tiers qui collectent ou transmettent des données utilisateur, cette Politique de confidentialité sera mise à jour afin d\'expliquer les pratiques de données applicables.';

  @override
  String get privacySection9 => '9. Publicité';

  @override
  String get privacySection9Paragraph1 =>
      'La version actuelle de Statusly n\'utilise pas de services publicitaires dans le cadre de ses fonctionnalités principales.';

  @override
  String get privacySection9Paragraph2 =>
      'Si des services publicitaires sont introduits dans une future version, cette Politique de confidentialité sera mise à jour afin d\'expliquer la technologie publicitaire, les pratiques de données et les services tiers applicables.';

  @override
  String get privacySection10 => '10. Sécurité des données';

  @override
  String get privacySection10Paragraph1 =>
      'Des mesures raisonnables sont prises pour protéger les informations traitées par Statusly et limiter l\'accès aux informations à ce qui est nécessaire au fonctionnement de l\'application.';

  @override
  String get privacySection10Paragraph2 =>
      'Comme Statusly traite principalement les fichiers multimédias de statuts pris en charge localement sur votre appareil Android, vos fichiers multimédias de statuts ne sont normalement pas transmis à un serveur Statusly pour y être stockés.';

  @override
  String get privacySection10Paragraph3 =>
      'Cependant, aucun système de stockage électronique ni aucune méthode de transmission ne peut être garanti comme étant totalement sécurisé. Vous devez également utiliser les fonctions de sécurité fournies par votre appareil Android pour protéger vos fichiers et vos informations.';

  @override
  String get privacySection11 => '11. Conservation et suppression des données';

  @override
  String get privacySection11Paragraph1 =>
      'Statusly ne conserve pas de compte sur un serveur contenant vos informations personnelles.';

  @override
  String get privacySection11Paragraph2 =>
      'Les préférences locales de l\'application restent sur votre appareil aussi longtemps qu\'elles sont nécessaires à l\'application. Selon votre appareil Android et ses paramètres, la désinstallation de Statusly ou l\'effacement des données de l\'application peut supprimer les données stockées localement.';

  @override
  String get privacySection11Paragraph3 =>
      'Les photos et vidéos que vous enregistrez sont des fichiers stockés sur votre appareil. Vous pouvez supprimer ces fichiers à l\'aide de la galerie de votre appareil, de votre gestionnaire de fichiers ou d\'une autre fonction de suppression disponible.';

  @override
  String get privacySection11Paragraph4 =>
      'Comme Statusly ne nécessite pas de compte utilisateur dans sa version actuelle, il n\'existe aucun compte Statusly dont vous devez demander la suppression.';

  @override
  String get privacySection12 => '12. Protection de la vie privée des enfants';

  @override
  String get privacySection12Paragraph1 =>
      'Statusly n\'est pas spécialement conçu pour les enfants.';

  @override
  String get privacySection12Paragraph2 =>
      'Nous ne collectons pas sciemment d\'informations personnelles auprès des enfants par l\'intermédiaire de l\'application. Si vous pensez qu\'un enfant nous a fourni des informations personnelles, veuillez nous contacter afin que la situation puisse être examinée.';

  @override
  String get privacySection13 => '13. Avis concernant WhatsApp et Meta';

  @override
  String get privacySection13Paragraph1 =>
      'Statusly est une application indépendante et n\'est pas affiliée à WhatsApp ou Meta Platforms, Inc., ni approuvée, parrainée ou officiellement liée à ces sociétés.';

  @override
  String get privacySection13Paragraph2 =>
      '« WhatsApp » ainsi que les noms, marques commerciales et logos associés appartiennent à leurs propriétaires respectifs.';

  @override
  String get privacySection13Paragraph3 =>
      'Statusly est un outil tiers destiné à aider les utilisateurs à gérer et à enregistrer les fichiers multimédias de statuts auxquels ils sont autorisés à accéder et qu\'ils sont autorisés à enregistrer.';

  @override
  String get privacySection14 =>
      '14. Votre responsabilité concernant le contenu enregistré';

  @override
  String get privacySection14Paragraph1 =>
      'Statusly fournit des outils permettant d\'enregistrer les fichiers multimédias auxquels vous avez accès sur votre appareil.';

  @override
  String get privacySection14Paragraph2 =>
      'Vous êtes responsable de vous assurer que vous disposez des droits, autorisations ou permissions nécessaires pour enregistrer, copier, partager ou utiliser de toute autre manière toute photo, vidéo ou autre contenu auquel vous accédez via l\'application.';

  @override
  String get privacySection14Paragraph3 =>
      'Vous devez respecter la vie privée, les droits d\'auteur, la propriété intellectuelle et les autres droits légaux des créateurs de contenu et des autres personnes.';

  @override
  String get privacySection15 =>
      '15. Modifications de cette Politique de confidentialité';

  @override
  String get privacySection15Paragraph1 =>
      'Cette Politique de confidentialité peut être mise à jour périodiquement afin de refléter les modifications apportées à Statusly, les changements de la législation applicable ou les changements dans les pratiques relatives aux données.';

  @override
  String get privacySection15Paragraph2 =>
      'Lorsque des modifications sont apportées, la date de « Dernière mise à jour » en haut de cette page sera mise à jour.';

  @override
  String get privacySection15Paragraph3 =>
      'Nous vous encourageons à consulter régulièrement cette Politique de confidentialité afin de rester informé de la manière dont Statusly traite les informations.';

  @override
  String get privacySection16 => '16. Contact';

  @override
  String get privacySection16Paragraph1 =>
      'Si vous avez des questions, des préoccupations ou des demandes concernant cette Politique de confidentialité ou les pratiques de confidentialité de Statusly, veuillez contacter :';

  @override
  String get privacyCopyright => '© 2026 Iszy_Man. Tous droits réservés.';

  @override
  String get privacyDisclaimer =>
      'Statusly est une application indépendante et n\'est pas affiliée à WhatsApp ni à Meta Platforms, Inc.';

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
  String get status => 'Statut';

  @override
  String get alreadySavedToGallery => 'Déjà enregistré dans votre galerie.';

  @override
  String get savedToGallery => 'Enregistré dans votre galerie.';

  @override
  String get unableToSaveStatus => 'Impossible d’enregistrer le statut.';

  @override
  String unableToSaveStatusWithError(Object error) {
    return 'Impossible d’enregistrer le statut : $error';
  }

  @override
  String get unableToShareStatus => 'Impossible de partager le statut.';

  @override
  String unableToShareStatusWithError(Object error) {
    return 'Impossible de partager le statut : $error';
  }

  @override
  String get videoFileDoesNotExist => 'Le fichier vidéo n’existe pas.';

  @override
  String get videoFileIsEmpty => 'Le fichier vidéo est vide.';

  @override
  String get unableToPlayVideo => 'Impossible de lire la vidéo.';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get download => 'Télécharger';

  @override
  String get sharing => 'Partage...';

  @override
  String get share => 'Partager';

  @override
  String saveSourceStatusTitle(Object sourceName) {
    return 'Enregistrer les statuts de $sourceName\nVidéos et photos';
  }

  @override
  String get allowAccessToStatusesFolder =>
      'Autoriser l’accès au\ndossier \".Statuses\"';

  @override
  String get allowAccessButton => 'Autoriser l’accès 👈';
}
