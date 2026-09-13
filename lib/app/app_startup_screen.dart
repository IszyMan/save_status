import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/onboarding.dart';
import '../../screens/splash_screen.dart';
import '../screens/status_home_page.dart';

class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  bool _checking = true;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();

    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      final completed =
          preferences.getBool('onboarding_completed') ?? false;

      if (!mounted) return;

      setState(() {
        _onboardingCompleted = completed;
        _checking = false;
      });
    } catch (e) {
      debugPrint(
        'Unable to check onboarding status: $e',
      );

      if (!mounted) return;

      setState(() {
        _onboardingCompleted = false;
        _checking = false;
      });
    }
  }

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
        builder: (_) => const StatusHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Still checking SharedPreferences.
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF075E54),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF25D366),
              ),
            ),
          ),
        ),
      );
    }

    // First launch:
    // Show onboarding directly.
    //
    // IMPORTANT:
    // Do NOT put onboarding inside SplashScreen.
    if (!_onboardingCompleted) {
      return OnboardingScreen(
        onGetStarted: _completeOnboarding,
      );
    }

    // Returning user:
    // Show splash, then go to StatusHomePage.
    return const SplashScreen(
      nextScreen: StatusHomePage(),
    );
  }
}