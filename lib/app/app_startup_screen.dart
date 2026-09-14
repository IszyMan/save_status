import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/language_selection_screen.dart';
import '../../screens/onboarding.dart';
import '../../screens/splash_screen.dart';
import '../screens/status_home_page.dart';

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

class _AppStartupScreenState
    extends State<AppStartupScreen> {
  bool _checking = true;
  bool _languageSelected = false;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkStartupState();
  }

  // ==========================================================================
  // CHECK STARTUP STATE
  // ==========================================================================

  Future<void> _checkStartupState() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      final selectedLanguage =
      preferences.getString(
        'selected_language',
      );

      final completed =
          preferences.getBool(
            'onboarding_completed',
          ) ??
              false;

      if (!mounted) return;

      if (selectedLanguage != null &&
          selectedLanguage.isNotEmpty) {
        widget.onLanguageSelected(
          Locale(selectedLanguage),
        );
      }

      setState(() {
        _languageSelected =
            selectedLanguage != null &&
                selectedLanguage.isNotEmpty;

        _onboardingCompleted = completed;
        _checking = false;
      });
    } catch (e) {
      debugPrint(
        'Unable to check startup state: $e',
      );

      if (!mounted) return;

      setState(() {
        _languageSelected = false;
        _onboardingCompleted = false;
        _checking = false;
      });
    }
  }

  // ==========================================================================
  // LANGUAGE SELECTION
  // ==========================================================================

  void _completeLanguageSelection(
      Locale locale,
      ) {
    widget.onLanguageSelected(locale);

    if (!mounted) return;

    setState(() {
      _languageSelected = true;
    });
  }

  // ==========================================================================
  // ONBOARDING
  // ==========================================================================

  Future<void> _completeOnboarding() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      await preferences.setBool(
        'onboarding_completed',
        true,
      );
    } catch (e) {
      debugPrint(
        'Unable to save onboarding status: $e',
      );
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => StatusHomePage(
          onLanguageChanged:
          widget.onLanguageSelected,
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF075E54),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
              AlwaysStoppedAnimation<Color>(
                Color(0xFF25D366),
              ),
            ),
          ),
        ),
      );
    }

    // ------------------------------------------------------------------------
    // FIRST LAUNCH: LANGUAGE SELECTION
    // ------------------------------------------------------------------------

    if (!_languageSelected) {
      return LanguageSelectionScreen(
        onLanguageSelected:
        _completeLanguageSelection,
      );
    }

    // ------------------------------------------------------------------------
    // ONBOARDING
    // ------------------------------------------------------------------------

    if (!_onboardingCompleted) {
      return OnboardingScreen(
        onGetStarted: _completeOnboarding,
      );
    }

    // ------------------------------------------------------------------------
    // EXISTING USER
    // ------------------------------------------------------------------------

    return SplashScreen(
      nextScreen: StatusHomePage(
        onLanguageChanged:
        widget.onLanguageSelected,
      ),
    );
  }
}