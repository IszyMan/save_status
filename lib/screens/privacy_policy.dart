import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          l10n.privacyPolicyTitle,
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
            l10n.privacyPolicyHeading,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            l10n.lastUpdated,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 12),

          _paragraph(
            context,
            l10n.privacyPolicyIntro,
          ),

          _sectionTitle(
            context,
            l10n.privacySection1,
          ),

          _paragraph(
            context,
            l10n.privacySection1Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection1Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection1Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection2,
          ),

          _paragraph(
            context,
            l10n.privacySection2Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection2Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection2Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection3,
          ),

          _paragraph(
            context,
            l10n.privacySection3Paragraph1,
          ),

          _bullet(
            context,
            l10n.privacyBulletDisplayStatuses,
          ),

          _bullet(
            context,
            l10n.privacyBulletViewStatuses,
          ),

          _bullet(
            context,
            l10n.privacyBulletSaveStatuses,
          ),

          _bullet(
            context,
            l10n.privacyBulletViewSaved,
          ),

          _bullet(
            context,
            l10n.privacyBulletShareMedia,
          ),

          _paragraph(
            context,
            l10n.privacySection3Paragraph2,
          ),

          _sectionTitle(
            context,
            l10n.privacySection4,
          ),

          _paragraph(
            context,
            l10n.privacySection4Paragraph1,
          ),

          _bullet(context, l10n.privacyBulletName),
          _bullet(context, l10n.privacyBulletPhone),
          _bullet(context, l10n.privacyBulletEmail),
          _bullet(context, l10n.privacyBulletWhatsAppCredentials),
          _bullet(context, l10n.privacyBulletWhatsAppMessages),
          _bullet(context, l10n.privacyBulletWhatsAppContacts),
          _bullet(context, l10n.privacyBulletPasswords),
          _bullet(context, l10n.privacyBulletPayment),
          _bullet(context, l10n.privacyBulletLocation),

          _paragraph(
            context,
            l10n.privacySection4Paragraph2,
          ),

          _sectionTitle(
            context,
            l10n.privacySection5,
          ),

          _paragraph(
            context,
            l10n.privacySection5Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection5Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection5Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection6,
          ),

          _paragraph(
            context,
            l10n.privacySection6Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection6Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection6Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection7,
          ),

          _paragraph(
            context,
            l10n.privacySection7Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection7Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection7Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection8,
          ),

          _paragraph(
            context,
            l10n.privacySection8Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection8Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection8Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection9,
          ),

          _paragraph(
            context,
            l10n.privacySection9Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection9Paragraph2,
          ),

          _sectionTitle(
            context,
            l10n.privacySection10,
          ),

          _paragraph(
            context,
            l10n.privacySection10Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection10Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection10Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection11,
          ),

          _paragraph(
            context,
            l10n.privacySection11Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection11Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection11Paragraph3,
          ),

          _paragraph(
            context,
            l10n.privacySection11Paragraph4,
          ),

          _sectionTitle(
            context,
            l10n.privacySection12,
          ),

          _paragraph(
            context,
            l10n.privacySection12Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection12Paragraph2,
          ),

          _sectionTitle(
            context,
            l10n.privacySection13,
          ),

          _paragraph(
            context,
            l10n.privacySection13Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection13Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection13Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection14,
          ),

          _paragraph(
            context,
            l10n.privacySection14Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection14Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection14Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection15,
          ),

          _paragraph(
            context,
            l10n.privacySection15Paragraph1,
          ),

          _paragraph(
            context,
            l10n.privacySection15Paragraph2,
          ),

          _paragraph(
            context,
            l10n.privacySection15Paragraph3,
          ),

          _sectionTitle(
            context,
            l10n.privacySection16,
          ),

          _paragraph(
            context,
            l10n.privacySection16Paragraph1,
          ),

          Text(
            'Iszy_Man',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'iszifyaws@gmail.com',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          _paragraph(
            context,
            l10n.privacyCopyright,
          ),

          _paragraph(
            context,
            l10n.privacyDisclaimer,
          ),
        ],
      ),
    );
  }
}