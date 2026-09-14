import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
  });

  static const String privacyPolicyUrl =
      'https://iszyman.github.io/statusly-legal/privacy-policy.html';

  static const String termsUrl =
      'https://iszyman.github.io/statusly-legal/terms.html';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint('Could not open URL: $url');
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF075E54),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Column(
            children: [
              const Spacer(),

              // App Logo
              Container(
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38),
                  child: Image.asset(
                    'assets/images/statusly_icon.png',
                    width: 156,
                    height: 156,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 38),

              // App Name
              const Text(
                'Save Statusly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),

              const SizedBox(height: 14),

              // Description
              Text(
                l10n.onboardingDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Get Started
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    l10n.getStarted,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Legal notice
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    '${l10n.byContinuingYouAcknowledgeOur} ',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _openUrl(privacyPolicyUrl);
                    },
                    child: Text(
                      l10n.privacyPolicy,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),

                  Text(
                    ' ${l10n.and} ',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _openUrl(termsUrl);
                    },
                    child: Text(
                      l10n.termsAndConditions,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),

                  const Text(
                    '.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}