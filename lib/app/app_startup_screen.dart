import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/language_selection_screen.dart';
import '../screens/onboarding.dart';
import '../screens/splash_screen.dart';
import '../screens/status_home_page.dart';
import '../screens/status_source_setup_screen.dart';

class AppStartupScreen extends StatefulWidget {
  final ValueChanged<Locale> onLanguageSelected;

  const AppStartupScreen({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  State<AppStartupScreen> createState() =>
      _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  bool _checking = true;
  bool _languageSelected = false;
  bool _onboardingCompleted = false;
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _checkStartupState();
  }

  Future<void> _checkStartupState() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      final language =
      preferences.getString('selected_language');

      final completed =
          preferences.getBool('onboarding_completed') ??
              false;

      if (!mounted) return;

      if (language != null && language.isNotEmpty) {
        widget.onLanguageSelected(Locale(language));
      }

      setState(() {
        _languageSelected =
            language != null && language.isNotEmpty;

        _onboardingCompleted = completed;
        _checking = false;
      });
    } catch (e) {
      debugPrint('Unable to check startup state: $e');

      if (!mounted) return;

      setState(() {
        _checking = false;
      });
    }
  }

  void _completeLanguageSelection(Locale locale) {
    widget.onLanguageSelected(locale);

    if (!mounted) return;

    setState(() {
      _languageSelected = true;
    });
  }

  Future<void> _completeOnboarding() async {
    if (_completing) return;

    _completing = true;

    try {
      final preferences =
      await SharedPreferences.getInstance();

      await preferences.setBool(
        'onboarding_completed',
        true,
      );
    } catch (e) {
      debugPrint('Unable to save onboarding status: $e');
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => _StartupAccessGate(
          onLanguageChanged: widget.onLanguageSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_languageSelected) {
      return LanguageSelectionScreen(
        onLanguageSelected: _completeLanguageSelection,
      );
    }

    if (!_onboardingCompleted) {
      return OnboardingScreen(
        onGetStarted: _completeOnboarding,
      );
    }

    return SplashScreen(
      nextScreen: _StartupAccessGate(
        onLanguageChanged: widget.onLanguageSelected,
      ),
    );
  }
}

// Checks existing native folder access before entering home.
class _StartupAccessGate extends StatelessWidget {
  final ValueChanged<Locale> onLanguageChanged;

  const _StartupAccessGate({
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StatusSourceSetupScreen(
      onComplete: () {
        if (!context.mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => StatusHomePage(
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        );
      },
    );
  }
}