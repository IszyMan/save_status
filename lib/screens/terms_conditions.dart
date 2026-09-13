import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
            'Statusly Terms & Conditions',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Last updated: September 11, 2026',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 12),

          _paragraph(
            context,
            'Please read these Terms & Conditions carefully before using Statusly.',
          ),

          _sectionTitle(context, '1. Acceptance of These Terms'),

          _paragraph(
            context,
            'These Terms & Conditions ("Terms") govern your use of the '
                'Statusly mobile application ("Statusly", "the App", or '
                '"our App").',
          ),

          _paragraph(
            context,
            'By downloading, installing, accessing, or using Statusly, you '
                'agree to be bound by these Terms.',
          ),

          _paragraph(
            context,
            'If you do not agree with these Terms, you should not use the App.',
          ),

          _sectionTitle(context, '2. Description of the App'),

          _paragraph(
            context,
            'Statusly is a utility application designed to help users view '
                'and save photos and videos from supported WhatsApp status media '
                'that they can access on their Android device.',
          ),

          _paragraph(
            context,
            'The App does not provide WhatsApp accounts, WhatsApp messaging '
                'services, or WhatsApp account management services.',
          ),

          _sectionTitle(context, '3. Eligibility'),

          _paragraph(
            context,
            'You are responsible for ensuring that your use of Statusly is '
                'permitted under the laws and regulations applicable to you.',
          ),

          _paragraph(
            context,
            'If you are not legally permitted to use an application of this '
                'type in your location, you must not use Statusly.',
          ),

          _sectionTitle(context, '4. Proper Use of Statusly'),

          _paragraph(
            context,
            'You agree to use Statusly only for lawful purposes and in '
                'accordance with these Terms.',
          ),

          _paragraph(
            context,
            'You must not use Statusly to:',
          ),

          _bullet(
            context,
            'Violate any applicable law or regulation.',
          ),

          _bullet(
            context,
            'Infringe the copyright, trademark, privacy, publicity, '
                'intellectual property, or other rights of another person.',
          ),

          _bullet(
            context,
            'Save, copy, distribute, or use content without appropriate '
                'authorization where authorization is required.',
          ),

          _bullet(
            context,
            'Harass, threaten, impersonate, or harm another person.',
          ),

          _bullet(
            context,
            'Attempt to interfere with, damage, reverse engineer, or '
                'disrupt the App or its supporting systems, except where such '
                'activity is expressly permitted by applicable law.',
          ),

          _bullet(
            context,
            'Use the App for fraudulent, abusive, or unlawful activities.',
          ),

          _sectionTitle(context, '5. Responsibility for Saved Content'),

          _paragraph(
            context,
            'Statusly does not determine whether you have permission to save, '
                'copy, share, publish, or otherwise use a particular photo or video.',
          ),

          _paragraph(
            context,
            'You are responsible for determining whether you have the '
                'necessary rights or permission to use content accessed through Statusly.',
          ),

          _paragraph(
            context,
            'You are also responsible for how you use any content saved '
                'using the App.',
          ),

          _paragraph(
            context,
            'You should respect the rights and wishes of content creators, '
                'owners, and other individuals represented in the content.',
          ),

          _sectionTitle(context, '6. WhatsApp and Meta Disclaimer'),

          _paragraph(
            context,
            'Statusly is an independent third-party application.',
          ),

          _paragraph(
            context,
            'Statusly is not affiliated with, endorsed by, sponsored by, '
                'or officially connected with WhatsApp or Meta Platforms, Inc.',
          ),

          _paragraph(
            context,
            'WhatsApp, Meta, and their respective names, trademarks, logos, '
                'and related intellectual property belong to their respective owners.',
          ),

          _paragraph(
            context,
            'Statusly does not claim ownership of WhatsApp or Meta\'s '
                'trademarks or intellectual property.',
          ),

          _sectionTitle(context, '7. Privacy'),

          _paragraph(
            context,
            'Your use of Statusly is also subject to our Privacy Policy.',
          ),

          _paragraph(
            context,
            'The Privacy Policy explains how Statusly handles information '
                'and the permissions required for the App\'s functionality.',
          ),

          _sectionTitle(context, '8. App Permissions'),

          _paragraph(
            context,
            'Statusly may request access to files, folders, photos, videos, '
                'or other device resources that are necessary for the App\'s '
                'status-saving functionality.',
          ),

          _paragraph(
            context,
            'You control whether to grant requested permissions or folder '
                'access through the Android operating system.',
          ),

          _paragraph(
            context,
            'If you do not grant access required for a particular feature, '
                'that feature may not function correctly.',
          ),

          _sectionTitle(context, '9. Saved Files'),

          _paragraph(
            context,
            'When you use Statusly to save media, the saved files are stored '
                'on your device.',
          ),

          _paragraph(
            context,
            'You are responsible for managing, protecting, backing up, and '
                'deleting files saved through the App.',
          ),

          _paragraph(
            context,
            'We are not responsible for files that you delete, move, '
                'overwrite, lose, or otherwise make inaccessible on your device.',
          ),

          _sectionTitle(context, '10. Availability of the App'),

          _paragraph(
            context,
            'We aim to keep Statusly available and functional, but we do not '
                'guarantee that the App will always operate without interruption, '
                'errors, delays, or compatibility problems.',
          ),

          _paragraph(
            context,
            'Statusly\'s functionality may be affected by factors outside '
                'our control, including Android updates, device configuration, '
                'storage limitations, file-system changes, WhatsApp changes, '
                'operating-system restrictions, or other third-party changes.',
          ),

          _sectionTitle(context, '11. Changes to the App'),

          _paragraph(
            context,
            'Statusly may be modified, updated, improved, restricted, '
                'suspended, or discontinued in whole or in part at any time.',
          ),

          _paragraph(
            context,
            'Updates may change how certain features work or introduce '
                'new functionality.',
          ),

          _sectionTitle(context, '12. Third-Party Services'),

          _paragraph(
            context,
            'Statusly may interact with or rely on functionality provided '
                'by third-party applications or services, including Android '
                'system functionality.',
          ),

          _paragraph(
            context,
            'Third-party applications and services are governed by their '
                'own terms and policies. Statusly is not responsible for the '
                'availability, content, policies, or practices of third-party services.',
          ),

          _sectionTitle(context, '13. Intellectual Property'),

          _paragraph(
            context,
            'Unless otherwise stated, the original software, design, '
                'branding, interface, graphics, text, and other original '
                'materials that make up Statusly are protected by applicable '
                'intellectual property laws.',
          ),

          _paragraph(
            context,
            'You may not reproduce, modify, distribute, sell, sublicense, '
                'or commercially exploit the App or its original components '
                'except where expressly permitted by applicable law or by the '
                'applicable rights holder.',
          ),

          _sectionTitle(context, '14. No Warranty'),

          _paragraph(
            context,
            'To the maximum extent permitted by applicable law, Statusly '
                'is provided on an "as is" and "as available" basis.',
          ),

          _paragraph(
            context,
            'We do not guarantee that the App will always be available, '
                'error-free, secure, compatible with every Android device, or '
                'capable of accessing every type of WhatsApp status media.',
          ),

          _paragraph(
            context,
            'We do not guarantee that every status photo or video will be '
                'successfully detected, displayed, previewed, or saved.',
          ),

          _sectionTitle(context, '15. Limitation of Liability'),

          _paragraph(
            context,
            'To the maximum extent permitted by applicable law, we shall '
                'not be responsible for indirect, incidental, special, '
                'consequential, or punitive damages arising from or related '
                'to your use of Statusly.',
          ),

          _paragraph(
            context,
            'This may include, where permitted by law, loss of files, '
                'loss of data, device issues, loss of profits, interruption '
                'of service, or problems caused by third-party applications '
                'or services.',
          ),

          _paragraph(
            context,
            'Nothing in these Terms is intended to exclude or limit '
                'liability that cannot lawfully be excluded or limited under '
                'applicable law.',
          ),

          _sectionTitle(context, '16. Termination'),

          _paragraph(
            context,
            'You may stop using Statusly at any time by uninstalling the '
                'App from your device.',
          ),

          _paragraph(
            context,
            'Access to the App or particular features may also be restricted '
                'or discontinued where necessary for security, legal, technical, '
                'or operational reasons.',
          ),

          _sectionTitle(context, '17. Changes to These Terms'),

          _paragraph(
            context,
            'These Terms may be updated from time to time.',
          ),

          _paragraph(
            context,
            'When changes are made, the "Last updated" date at the top of '
                'this page will be updated.',
          ),

          _paragraph(
            context,
            'Your continued use of Statusly after updated Terms become '
                'available means that you accept the updated Terms to the extent '
                'permitted by applicable law.',
          ),

          _sectionTitle(context, '18. Governing Law'),

          _paragraph(
            context,
            'These Terms shall be governed by and interpreted in accordance '
                'with applicable law, without regard to conflict-of-law principles, '
                'except where applicable law requires otherwise.',
          ),

          _paragraph(
            context,
            'Nothing in these Terms removes or limits any rights that you '
                'may have under mandatory consumer protection laws applicable to you.',
          ),

          _sectionTitle(context, '19. Contact'),

          _paragraph(
            context,
            'If you have questions about these Terms & Conditions or '
                'Statusly, please contact:',
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
            '© 2026 Iszy_Man. All rights reserved.',
          ),

          _paragraph(
            context,
            'Statusly is an independent application and is not affiliated '
                'with WhatsApp or Meta Platforms, Inc.',
          ),
        ],
      ),
    );
  }
}