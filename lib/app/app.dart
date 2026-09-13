import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_startup_screen.dart';

class StatusSaverApp extends StatelessWidget {
  const StatusSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Statusly',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AppStartupScreen(),
    );
  }
}




