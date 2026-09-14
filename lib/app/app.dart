import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import 'app_startup_screen.dart';

class StatusSaverApp extends StatefulWidget {
  const StatusSaverApp({super.key});

  @override
  State<StatusSaverApp> createState() =>
      _StatusSaverAppState();
}

class _StatusSaverAppState
    extends State<StatusSaverApp> {
  Locale? _locale;

  Future<void> changeLanguage(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    try {
      const channel =
      MethodChannel('com.iszyman.statusly/status');

      await channel.invokeMethod(
        'setAppLanguage',
        {
          'language': locale.languageCode,
        },
      );
    } catch (e) {
      debugPrint(
        'Unable to synchronize app language with Android: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Status Saver',

      // ----------------------------------------------------------------------
      // THEME
      // ----------------------------------------------------------------------

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      // ----------------------------------------------------------------------
      // LOCALIZATION
      // ----------------------------------------------------------------------

      locale: _locale,

      localizationsDelegates:
      AppLocalizations.localizationsDelegates,

      supportedLocales:
      AppLocalizations.supportedLocales,

      // ----------------------------------------------------------------------
      // STARTUP
      // ----------------------------------------------------------------------

      home: AppStartupScreen(
        onLanguageSelected: changeLanguage,
      ),
    );
  }
}