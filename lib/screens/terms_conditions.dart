import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  Widget _sectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.55,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.termsConditionsTitle,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            l10n.termsConditionsDocumentTitle,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            l10n.termsConditionsLastUpdated,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 12),

          _paragraph(
            context,
            l10n.termsConditionsIntro,
          ),

          // 1. Acceptance of These Terms
          _sectionTitle(
            context,
            '1. ${l10n.termsConditionsSection1Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection1Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection1Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection1Paragraph3,
          ),

          // 2. Description of the App
          _sectionTitle(
            context,
            '2. ${l10n.termsConditionsSection2Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection2Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection2Paragraph2,
          ),

          // 3. Eligibility
          _sectionTitle(
            context,
            '3. ${l10n.termsConditionsSection3Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection3Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection3Paragraph2,
          ),

          // 4. Proper Use of Statusly
          _sectionTitle(
            context,
            '4. ${l10n.termsConditionsSection4Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection4Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection4Paragraph2,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet1,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet2,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet3,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet4,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet5,
          ),

          _bullet(
            context,
            l10n.termsConditionsSection4Bullet6,
          ),

          // 5. Responsibility for Saved Content
          _sectionTitle(
            context,
            '5. ${l10n.termsConditionsSection5Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection5Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection5Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection5Paragraph3,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection5Paragraph4,
          ),

          // 6. WhatsApp and Meta Disclaimer
          _sectionTitle(
            context,
            '6. ${l10n.termsConditionsSection6Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection6Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection6Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection6Paragraph3,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection6Paragraph4,
          ),

          // 7. Privacy
          _sectionTitle(
            context,
            '7. ${l10n.termsConditionsSection7Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection7Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection7Paragraph2,
          ),

          // 8. App Permissions
          _sectionTitle(
            context,
            '8. ${l10n.termsConditionsSection8Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection8Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection8Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection8Paragraph3,
          ),

          // 9. Saved Files
          _sectionTitle(
            context,
            '9. ${l10n.termsConditionsSection9Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection9Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection9Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection9Paragraph3,
          ),

          // 10. Availability of the App
          _sectionTitle(
            context,
            '10. ${l10n.termsConditionsSection10Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection10Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection10Paragraph2,
          ),

          // 11. Changes to the App
          _sectionTitle(
            context,
            '11. ${l10n.termsConditionsSection11Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection11Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection11Paragraph2,
          ),

          // 12. Third-Party Services
          _sectionTitle(
            context,
            '12. ${l10n.termsConditionsSection12Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection12Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection12Paragraph2,
          ),

          // 13. Intellectual Property
          _sectionTitle(
            context,
            '13. ${l10n.termsConditionsSection13Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection13Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection13Paragraph2,
          ),

          // 14. No Warranty
          _sectionTitle(
            context,
            '14. ${l10n.termsConditionsSection14Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection14Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection14Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection14Paragraph3,
          ),

          // 15. Limitation of Liability
          _sectionTitle(
            context,
            '15. ${l10n.termsConditionsSection15Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection15Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection15Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection15Paragraph3,
          ),

          // 16. Termination
          _sectionTitle(
            context,
            '16. ${l10n.termsConditionsSection16Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection16Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection16Paragraph2,
          ),

          // 17. Changes to These Terms
          _sectionTitle(
            context,
            '17. ${l10n.termsConditionsSection17Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection17Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection17Paragraph2,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection17Paragraph3,
          ),

          // 18. Governing Law
          _sectionTitle(
            context,
            '18. ${l10n.termsConditionsSection18Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection18Paragraph1,
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection18Paragraph2,
          ),

          // 19. Contact
          _sectionTitle(
            context,
            '19. ${l10n.termsConditionsSection19Title}',
          ),

          _paragraph(
            context,
            l10n.termsConditionsSection19Paragraph1,
          ),

          Text(
            l10n.termsConditionsContactName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            l10n.termsConditionsContactEmail,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          _paragraph(
            context,
            l10n.termsConditionsCopyright,
          ),

          _paragraph(
            context,
            l10n.termsConditionsFooterDisclaimer,
          ),
        ],
      ),
    );
  }
}