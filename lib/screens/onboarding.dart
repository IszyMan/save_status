import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final ValueChanged<Locale> onLanguageSelected;
  final bool busy;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
    required this.onLanguageSelected,
    this.busy = false,
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

  String _languageName(String code) {
    switch (code) {
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
      default:
        return 'English';
    }
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    // Use the actual locales supported by your generated translations.
    // Show one entry per language.
    final languages = <String, Locale>{};

    // Put English first.
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == 'en') {
        languages.putIfAbsent('en', () => locale);
      }
    }

    // Add the remaining languages.
    for (final locale in AppLocalizations.supportedLocales) {
      languages.putIfAbsent(locale.languageCode, () => locale);
    }

    final selectedCode = languages.containsKey(
      currentLocale.languageCode,
    )
        ? currentLocale.languageCode
        : languages.keys.first;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              color: Color(0xFF075E54),
              size: 20,
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCode,
                dropdownColor: Colors.white,
                iconEnabledColor: const Color(0xFF075E54),
                iconDisabledColor: Colors.grey,
                borderRadius: BorderRadius.circular(14),
                style: const TextStyle(
                  color: Color(0xFF075E54),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                hint: Text(l10n.chooseLanguage),
                items: languages.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(_languageName(entry.key)),
                  );
                }).toList(),
                onChanged: busy
                    ? null
                    : (code) {
                  if (code == null) return;
                  onLanguageSelected(languages[code]!);
                },
              ),
            ),
          ],
        ),
      ),
    );
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

              const SizedBox(height: 12),

              _buildLanguageSelector(context),

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
                  onPressed: busy ? null : onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Text(
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