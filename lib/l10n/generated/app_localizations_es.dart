// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Save Statusly';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get selectPreferredLanguage => 'Selecciona tu idioma preferido';

  @override
  String get continueButton => 'Continuar';

  @override
  String get allowAccess => 'Permitir acceso';

  @override
  String get statuses => 'Estados';

  @override
  String get saved => 'Guardados';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get generalSettings => 'Configuración general';

  @override
  String get manageWhatsAppStatusSources =>
      'Administra tus fuentes de estados de WhatsApp.';

  @override
  String get openWhatsApp => 'Abrir WhatsApp';

  @override
  String get returnDirectlyToWhatsApp => 'Volver directamente a WhatsApp';

  @override
  String get howToUseStatusly => 'Cómo usar Statusly';

  @override
  String get learnHowToViewAndSaveStatuses => 'Aprende a ver y guardar estados';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get learnHowStatuslyHandlesInformation =>
      'Conoce cómo Statusly gestiona tu información';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get readTermsForUsingStatusly => 'Lee los términos para usar Statusly';

  @override
  String get contactSupport => 'Contactar con soporte';

  @override
  String get getHelpWithStatusly => 'Obtén ayuda con Statusly';

  @override
  String get statusAccessIsConfigured =>
      'El acceso a los estados está configurado';

  @override
  String get statusFolderNeedsConfiguration =>
      'Es necesario configurar la carpeta de estados';

  @override
  String get noEmailAppFound =>
      'No se encontró ninguna aplicación de correo en este dispositivo.';

  @override
  String get unableToOpenEmail => 'No se pudo abrir tu aplicación de correo.';

  @override
  String get onboardingDescription =>
      'Guarda fotos y vídeos de los estados de WhatsApp.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get byContinuingYouAcknowledgeOur => 'Al continuar, reconoces nuestra';

  @override
  String get and => 'y';

  @override
  String get saveStatus => 'Guardar estado';

  @override
  String get savePhotosAndVideosFromWhatsAppStatuses =>
      'Guarda fotos y vídeos de tus estados de WhatsApp.';

  @override
  String get statusAccessIsReady => 'El acceso a los estados está listo';

  @override
  String get setUpStatusAccess => 'Configurar el acceso a los estados';

  @override
  String get whatsappNotFound => 'WhatsApp no encontrado';

  @override
  String get installWhatsAppOrBusinessToUseStatusly =>
      'Instala WhatsApp o WhatsApp Business para usar Statusly.';

  @override
  String get noVideosFound => 'No se encontraron vídeos';

  @override
  String get noImagesFound => 'No se encontraron imágenes';

  @override
  String get videoStatusesWillAppearHere =>
      'Los estados de vídeo aparecerán aquí.';

  @override
  String get imageStatusesWillAppearHere =>
      'Los estados de imagen aparecerán aquí.';

  @override
  String get noSavedVideos => 'No hay vídeos guardados';

  @override
  String get noSavedImages => 'No hay imágenes guardadas';

  @override
  String get videosYouSaveWillAppearHere =>
      'Los vídeos que guardes aparecerán aquí.';

  @override
  String get imagesYouSaveWillAppearHere =>
      'Las imágenes que guardes aparecerán aquí.';

  @override
  String get howToSaveAStatus => 'Cómo guardar un estado';

  @override
  String viewAStatusOn(Object sourceName) {
    return 'Ver un estado en $sourceName';
  }

  @override
  String get openSaveStatusly => 'Abrir Save Statusly';

  @override
  String get returnToSaveStatuslyAfterViewing =>
      'Vuelve a Save Statusly después de ver el estado.';

  @override
  String get saveOrDownloadTheStatus => 'Guardar o descargar el estado';

  @override
  String get viewedStatusWillAppearHere =>
      'El estado que hayas visto aparecerá aquí. Ábrelo y toca el botón Guardar o Descargar.';

  @override
  String openSource(Object sourceName) {
    return 'Abrir $sourceName';
  }

  @override
  String get exitStatusly => '¿Salir de Statusly?';

  @override
  String get areYouSureYouWantToCloseTheApp =>
      '¿Estás seguro de que quieres cerrar la aplicación?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exit => 'Salir';

  @override
  String get unableToOpenWhatsApp => 'No se pudo abrir WhatsApp.';

  @override
  String sourceNotInstalled(Object sourceName) {
    return '$sourceName no está instalado.';
  }

  @override
  String sourceStatusAccessReady(Object sourceName) {
    return 'El acceso a los estados de $sourceName está listo.';
  }

  @override
  String get pleaseSelectStatusesFolder => 'Selecciona la carpeta .Statuses.';

  @override
  String unableToSetUpStatusAccess(Object error) {
    return 'No se pudo configurar el acceso a los estados: $error';
  }

  @override
  String unableToOpenStatus(Object error) {
    return 'No se pudo abrir el estado: $error';
  }

  @override
  String get openWhatsAppTooltip => 'Abrir WhatsApp';

  @override
  String openSourceAndViewStatus(Object sourceName) {
    return 'Abre $sourceName y mira el estado de foto o vídeo que quieras guardar.';
  }

  @override
  String get images => 'Imágenes';

  @override
  String get videos => 'Vídeos';

  @override
  String get statusPhotosAndVideoDownloader =>
      'Descargador de fotos y vídeos de estados';

  @override
  String get loading => 'Cargando...';

  @override
  String get howToUseDescription =>
      'Guarda fotos y videos de los estados de WhatsApp directamente en tu dispositivo.';

  @override
  String get howToUseStep1Title => 'Elegir WhatsApp';

  @override
  String get howToUseStep1Description =>
      'Selecciona WhatsApp o WhatsApp Business según la fuente de estados que quieras utilizar.';

  @override
  String get howToUseStep2Title => 'Permitir que Statusly acceda a los estados';

  @override
  String get howToUseStep2Description =>
      'Android te pedirá que permitas a Statusly acceder a la carpeta de estados de WhatsApp seleccionada. Sigue las indicaciones de Android y confirma la selección de la carpeta.';

  @override
  String get howToUseStep3Title => 'Ver los estados disponibles';

  @override
  String get howToUseStep3Description =>
      'Una vez configurado el acceso, Statusly mostrará las fotos y videos de estado disponibles en la pestaña Estados.';

  @override
  String get howToUseStep4Title => 'Abrir un estado';

  @override
  String get howToUseStep4Description =>
      'Toca una foto o un video para verlo. Los videos se pueden reproducir directamente dentro de Statusly.';

  @override
  String get howToUseStep5Title => 'Guardar un estado';

  @override
  String get howToUseStep5Description =>
      'Usa la opción de guardar mientras ves un estado para guardar la foto o el video seleccionado en tu dispositivo.';

  @override
  String get howToUseStep6Title => 'Encontrar tus archivos guardados';

  @override
  String get howToUseStep6Description =>
      'Las fotos y videos guardados están disponibles en la pestaña Guardados dentro de Statusly. También se almacenan en tu dispositivo.';

  @override
  String get howToUseStep7Title => 'Compartir un estado';

  @override
  String get howToUseStep7Description =>
      'Usa la opción de compartir para enviar archivos multimedia compatibles mediante otras aplicaciones instaladas en tu dispositivo.';

  @override
  String get howToUseUsefulTips => 'Consejos útiles';

  @override
  String get howToUseTip1 =>
      'Si utilizas WhatsApp y WhatsApp Business, configura cada fuente por separado desde Ajustes.';

  @override
  String get howToUseTip2 =>
      'Statusly no sube tus fotos o videos de estado a ningún servidor de Statusly. Los archivos multimedia compatibles se procesan localmente en tu dispositivo.';

  @override
  String get howToUseTip3 =>
      'Si un estado nuevo no aparece inmediatamente, vuelve a la pestaña Estados y actualiza la lista.';

  @override
  String get howToUseTip4 =>
      'Guarda o comparte únicamente archivos multimedia de estados que tengas permiso o autorización para utilizar.';

  @override
  String get howToUseNeedHelp => '¿Necesitas ayuda?';

  @override
  String get howToUseHelpDescription =>
      'Si tienes algún problema al utilizar Statusly, contacta con el soporte desde la pantalla de Ajustes.';

  @override
  String get privacyPolicyTitle => 'Política de Privacidad';

  @override
  String get privacyPolicyHeading => 'Política de Privacidad de Statusly';

  @override
  String get lastUpdated => 'Última actualización: 11 de septiembre de 2026';

  @override
  String get privacyPolicyIntro =>
      'Statusly está diseñado para ayudarte a ver y guardar fotos y videos de los estados de WhatsApp en tu dispositivo Android.';

  @override
  String get privacySection1 => '1. Introducción';

  @override
  String get privacySection1Paragraph1 =>
      'Esta Política de Privacidad explica cómo Statusly gestiona la información cuando utilizas la aplicación móvil Statusly (\"Statusly\", \"la aplicación\" o \"nuestra aplicación\").';

  @override
  String get privacySection1Paragraph2 =>
      'Statusly está diseñado con un enfoque local. La aplicación no requiere que crees una cuenta y la versión actual no utiliza un servidor que almacene tus fotos o videos de estados de WhatsApp.';

  @override
  String get privacySection1Paragraph3 =>
      'Esta Política de Privacidad explica a qué información accede Statusly, cómo se utiliza esa información, si se comparte con terceros y cómo se conserva o elimina la información.';

  @override
  String get privacySection2 => '2. Información a la que accede Statusly';

  @override
  String get privacySection2Paragraph1 =>
      'Statusly puede acceder a fotos y videos almacenados en ubicaciones compatibles de archivos multimedia de estados de WhatsApp en tu dispositivo Android cuando otorgas a la aplicación el acceso necesario o seleccionas la carpeta correspondiente mediante el sistema de selección de archivos o carpetas de Android.';

  @override
  String get privacySection2Paragraph2 =>
      'Este acceso es necesario para la función principal de Statusly: mostrar los archivos multimedia de estados de WhatsApp disponibles para que puedas verlos y guardarlos en tu dispositivo.';

  @override
  String get privacySection2Paragraph3 =>
      'Dependiendo de tu dispositivo, versión de Android y aplicaciones de WhatsApp instaladas, Statusly puede admitir las carpetas de estados de WhatsApp y WhatsApp Business.';

  @override
  String get privacySection3 =>
      '3. Cómo utiliza Statusly los archivos multimedia a los que accede';

  @override
  String get privacySection3Paragraph1 =>
      'Statusly utiliza las fotos y videos de estados a los que accede para proporcionar las funciones de la aplicación, entre ellas:';

  @override
  String get privacyBulletDisplayStatuses =>
      'Mostrar las fotos y videos de estados disponibles.';

  @override
  String get privacyBulletViewStatuses =>
      'Permitir ver los archivos multimedia de los estados.';

  @override
  String get privacyBulletSaveStatuses =>
      'Permitir guardar los archivos multimedia de estados seleccionados.';

  @override
  String get privacyBulletViewSaved =>
      'Permitir ver los archivos multimedia guardados mediante la aplicación.';

  @override
  String get privacyBulletShareMedia =>
      'Permitir utilizar las funciones compatibles para compartir o abrir archivos en tu dispositivo.';

  @override
  String get privacySection3Paragraph2 =>
      'La versión actual de Statusly procesa los archivos multimedia de estados compatibles localmente en tu dispositivo. Statusly no necesita subir tus fotos o videos de estados de WhatsApp a un servidor de Statusly para proporcionar estas funciones principales.';

  @override
  String get privacySection4 => '4. Información que no recopilamos';

  @override
  String get privacySection4Paragraph1 =>
      'La versión actual de Statusly no requiere que crees una cuenta y no recopila intencionadamente información personal como:';

  @override
  String get privacyBulletName => 'Tu nombre.';

  @override
  String get privacyBulletPhone => 'Tu número de teléfono.';

  @override
  String get privacyBulletEmail =>
      'Tu dirección de correo electrónico a través de la aplicación.';

  @override
  String get privacyBulletWhatsAppCredentials =>
      'Las credenciales de tu cuenta de WhatsApp.';

  @override
  String get privacyBulletWhatsAppMessages => 'Tus mensajes de WhatsApp.';

  @override
  String get privacyBulletWhatsAppContacts => 'Tus contactos de WhatsApp.';

  @override
  String get privacyBulletPasswords => 'Tus contraseñas.';

  @override
  String get privacyBulletPayment => 'Tu información de pago.';

  @override
  String get privacyBulletLocation => 'Tu ubicación precisa.';

  @override
  String get privacySection4Paragraph2 =>
      'Statusly tampoco requiere un nombre de usuario ni una contraseña para utilizar sus funciones principales.';

  @override
  String get privacySection5 =>
      '5. Almacenamiento local y preferencias de la aplicación';

  @override
  String get privacySection5Paragraph1 =>
      'Statusly puede almacenar determinadas preferencias de la aplicación localmente en tu dispositivo. Estas pueden incluir información como si has completado el proceso de incorporación o qué fuente de estados compatible seleccionaste por última vez.';

  @override
  String get privacySection5Paragraph2 =>
      'Esta información se almacena localmente en tu dispositivo y se utiliza para que la aplicación funcione correctamente y recuerde tus preferencias.';

  @override
  String get privacySection5Paragraph3 =>
      'Statusly no utiliza esta información de preferencias locales para identificarte personalmente.';

  @override
  String get privacySection6 => '6. Fotos y videos guardados';

  @override
  String get privacySection6Paragraph1 =>
      'Cuando eliges guardar una foto o un video mediante Statusly, el archivo resultante se almacena en tu dispositivo de acuerdo con la función de guardado de la aplicación y el sistema de almacenamiento de Android.';

  @override
  String get privacySection6Paragraph2 =>
      'Statusly no mantiene una copia de tus archivos multimedia de estados guardados en un servidor como parte del funcionamiento normal de la aplicación.';

  @override
  String get privacySection6Paragraph3 =>
      'Los archivos que guardas permanecen en tu dispositivo hasta que decidas eliminarlos mediante las funciones disponibles del dispositivo, la galería, el administrador de archivos o la aplicación.';

  @override
  String get privacySection7 => '7. Compartir información con terceros';

  @override
  String get privacySection7Paragraph1 =>
      'Statusly no vende, alquila ni comercializa tu información personal.';

  @override
  String get privacySection7Paragraph2 =>
      'En la versión actual de la aplicación, Statusly no envía intencionadamente tus fotos o videos de estados de WhatsApp a servidores de terceros para almacenamiento o publicidad.';

  @override
  String get privacySection7Paragraph3 =>
      'Si eliges utilizar las funciones de Android para compartir, abrir archivos u otras funciones de terceros, la información o los archivos multimedia que decidas compartir pueden ser gestionados por la aplicación o el servicio que selecciones. Dicho tratamiento se rige por la política de privacidad y los términos del tercero correspondiente.';

  @override
  String get privacySection8 => '8. Servicios y software de terceros';

  @override
  String get privacySection8Paragraph1 =>
      'Statusly puede utilizar bibliotecas de software de terceros que sean necesarias para proporcionar determinadas funciones técnicas de la aplicación.';

  @override
  String get privacySection8Paragraph2 =>
      'El software de terceros puede procesar información de acuerdo con su propio funcionamiento técnico y las políticas aplicables.';

  @override
  String get privacySection8Paragraph3 =>
      'Si futuras versiones de Statusly incorporan análisis, publicidad, informes de errores, servicios en la nube u otros servicios de terceros que recopilen o transmitan datos de los usuarios, esta Política de Privacidad se actualizará para explicar las prácticas de datos correspondientes.';

  @override
  String get privacySection9 => '9. Publicidad';

  @override
  String get privacySection9Paragraph1 =>
      'La versión actual de Statusly no utiliza servicios de publicidad como parte de sus funciones principales.';

  @override
  String get privacySection9Paragraph2 =>
      'Si se introducen servicios de publicidad en una versión futura, esta Política de Privacidad se actualizará para explicar la tecnología publicitaria, las prácticas de datos y los servicios de terceros correspondientes.';

  @override
  String get privacySection10 => '10. Seguridad de los datos';

  @override
  String get privacySection10Paragraph1 =>
      'Se toman medidas razonables para proteger la información gestionada por Statusly y limitar el acceso a la información a lo necesario para el funcionamiento de la aplicación.';

  @override
  String get privacySection10Paragraph2 =>
      'Dado que Statusly procesa principalmente los archivos multimedia de estados compatibles localmente en tu dispositivo Android, tus archivos multimedia de estados normalmente no se transmiten a un servidor de Statusly para su almacenamiento.';

  @override
  String get privacySection10Paragraph3 =>
      'Sin embargo, ningún sistema de almacenamiento electrónico ni método de transmisión puede garantizar una seguridad completa. También debes utilizar las funciones de seguridad proporcionadas por tu dispositivo Android para proteger tus archivos e información.';

  @override
  String get privacySection11 => '11. Conservación y eliminación de datos';

  @override
  String get privacySection11Paragraph1 =>
      'Statusly no mantiene una cuenta en un servidor que contenga tu información personal.';

  @override
  String get privacySection11Paragraph2 =>
      'Las preferencias locales de la aplicación permanecen en tu dispositivo mientras sean necesarias para la aplicación. Dependiendo de tu dispositivo Android y de su configuración, desinstalar Statusly o borrar los datos de la aplicación puede eliminar los datos almacenados localmente.';

  @override
  String get privacySection11Paragraph3 =>
      'Las fotos y videos que guardas son archivos almacenados en tu dispositivo. Puedes eliminar estos archivos mediante la galería de tu dispositivo, el administrador de archivos u otra función de eliminación disponible.';

  @override
  String get privacySection11Paragraph4 =>
      'Como Statusly no requiere cuentas de usuario en la versión actual, no existe una cuenta de Statusly cuya eliminación debas solicitar.';

  @override
  String get privacySection12 => '12. Privacidad de los menores';

  @override
  String get privacySection12Paragraph1 =>
      'Statusly no está diseñado específicamente para niños.';

  @override
  String get privacySection12Paragraph2 =>
      'No recopilamos conscientemente información personal de niños a través de la aplicación. Si crees que un menor nos ha proporcionado información personal, ponte en contacto con nosotros para que podamos revisar el caso.';

  @override
  String get privacySection13 =>
      '13. Descargo de responsabilidad sobre WhatsApp y Meta';

  @override
  String get privacySection13Paragraph1 =>
      'Statusly es una aplicación independiente y no está afiliada, respaldada, patrocinada ni conectada oficialmente con WhatsApp o Meta Platforms, Inc.';

  @override
  String get privacySection13Paragraph2 =>
      '\"WhatsApp\" y los nombres, marcas comerciales y logotipos relacionados pertenecen a sus respectivos propietarios.';

  @override
  String get privacySection13Paragraph3 =>
      'Statusly es una herramienta de terceros destinada a ayudar a los usuarios a gestionar y guardar archivos multimedia de estados a los que están autorizados a acceder y guardar.';

  @override
  String get privacySection14 =>
      '14. Tu responsabilidad con respecto al contenido guardado';

  @override
  String get privacySection14Paragraph1 =>
      'Statusly proporciona herramientas para guardar archivos multimedia que son accesibles para ti en tu dispositivo.';

  @override
  String get privacySection14Paragraph2 =>
      'Eres responsable de asegurarte de tener los derechos, permisos o autorizaciones correspondientes para guardar, copiar, compartir o utilizar de cualquier otra forma cualquier foto, video u otro contenido al que accedas mediante la aplicación.';

  @override
  String get privacySection14Paragraph3 =>
      'Debes respetar la privacidad, los derechos de autor, la propiedad intelectual y otros derechos legales de los creadores de contenido y de otras personas.';

  @override
  String get privacySection15 => '15. Cambios en esta Política de Privacidad';

  @override
  String get privacySection15Paragraph1 =>
      'Esta Política de Privacidad puede actualizarse periódicamente para reflejar cambios en Statusly, cambios en las leyes aplicables o cambios en las prácticas de datos.';

  @override
  String get privacySection15Paragraph2 =>
      'Cuando se realicen cambios, se actualizará la fecha de \"Última actualización\" que aparece en la parte superior de esta página.';

  @override
  String get privacySection15Paragraph3 =>
      'Te recomendamos revisar periódicamente esta Política de Privacidad para mantenerte informado sobre cómo Statusly gestiona la información.';

  @override
  String get privacySection16 => '16. Contacto';

  @override
  String get privacySection16Paragraph1 =>
      'Si tienes preguntas, inquietudes o solicitudes relacionadas con esta Política de Privacidad o con las prácticas de privacidad de Statusly, ponte en contacto con:';

  @override
  String get privacyCopyright =>
      '© 2026 Iszy_Man. Todos los derechos reservados.';

  @override
  String get privacyDisclaimer =>
      'Statusly es una aplicación independiente y no está afiliada a WhatsApp ni a Meta Platforms, Inc.';

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
  String get status => 'Estado';

  @override
  String get alreadySavedToGallery => 'Ya se ha guardado en tu galería.';

  @override
  String get savedToGallery => 'Guardado en tu galería.';

  @override
  String get unableToSaveStatus => 'No se pudo guardar el estado.';

  @override
  String unableToSaveStatusWithError(Object error) {
    return 'No se pudo guardar el estado: $error';
  }

  @override
  String get unableToShareStatus => 'No se pudo compartir el estado.';

  @override
  String unableToShareStatusWithError(Object error) {
    return 'No se pudo compartir el estado: $error';
  }

  @override
  String get videoFileDoesNotExist => 'El archivo de vídeo no existe.';

  @override
  String get videoFileIsEmpty => 'El archivo de vídeo está vacío.';

  @override
  String get unableToPlayVideo => 'No se pudo reproducir el vídeo.';

  @override
  String get saving => 'Guardando...';

  @override
  String get download => 'Descargar';

  @override
  String get sharing => 'Compartiendo...';

  @override
  String get share => 'Compartir';

  @override
  String saveSourceStatusTitle(Object sourceName) {
    return 'Guardar estados de $sourceName\nVídeos y fotos';
  }

  @override
  String get allowAccessToStatusesFolder =>
      'Permitir el acceso a la\ncarpeta \".Statuses\"';

  @override
  String get allowAccessButton => 'Permitir acceso 👈';
}
