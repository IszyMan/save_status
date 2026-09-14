import 'package:flutter/material.dart';

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

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Save Statusly',

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