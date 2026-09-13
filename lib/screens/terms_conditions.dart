import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          const Text(
            'Statusly Terms & Conditions',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Last updated: September 11, 2026',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          _paragraph(
            'Please read these Terms & Conditions carefully before using Statusly.',
          ),

          _sectionTitle('1. Acceptance of These Terms'),

          _paragraph(
            'These Terms & Conditions ("Terms") govern your use of the '
                'Statusly mobile application ("Statusly", "the App", or '
                '"our App").',
          ),

          _paragraph(
            'By downloading, installing, accessing, or using Statusly, you '
                'agree to be bound by these Terms.',
          ),

          _paragraph(
            'If you do not agree with these Terms, you should not use the App.',
          ),

          _sectionTitle('2. Description of the App'),

          _paragraph(
            'Statusly is a utility application designed to help users view '
                'and save photos and videos from supported WhatsApp status media '
                'that they can access on their Android device.',
          ),

          _paragraph(
            'The App does not provide WhatsApp accounts, WhatsApp messaging '
                'services, or WhatsApp account management services.',
          ),

          _sectionTitle('3. Eligibility'),

          _paragraph(
            'You are responsible for ensuring that your use of Statusly is '
                'permitted under the laws and regulations applicable to you.',
          ),

          _paragraph(
            'If you are not legally permitted to use an application of this '
                'type in your location, you must not use Statusly.',
          ),

          _sectionTitle('4. Proper Use of Statusly'),

          _paragraph(
            'You agree to use Statusly only for lawful purposes and in '
                'accordance with these Terms.',
          ),

          _paragraph(
            'You must not use Statusly to:',
          ),

          _bullet('Violate any applicable law or regulation.'),
          _bullet(
            'Infringe the copyright, trademark, privacy, publicity, '
                'intellectual property, or other rights of another person.',
          ),
          _bullet(
            'Save, copy, distribute, or use content without appropriate '
                'authorization where authorization is required.',
          ),
          _bullet(
            'Harass, threaten, impersonate, or harm another person.',
          ),
          _bullet(
            'Attempt to interfere with, damage, reverse engineer, or '
                'disrupt the App or its supporting systems, except where such '
                'activity is expressly permitted by applicable law.',
          ),
          _bullet(
            'Use the App for fraudulent, abusive, or unlawful activities.',
          ),

          _sectionTitle('5. Responsibility for Saved Content'),

          _paragraph(
            'Statusly does not determine whether you have permission to save, '
                'copy, share, publish, or otherwise use a particular photo or video.',
          ),

          _paragraph(
            'You are responsible for determining whether you have the '
                'necessary rights or permission to use content accessed through Statusly.',
          ),

          _paragraph(
            'You are also responsible for how you use any content saved '
                'using the App.',
          ),

          _paragraph(
            'You should respect the rights and wishes of content creators, '
                'owners, and other individuals represented in the content.',
          ),

          _sectionTitle('6. WhatsApp and Meta Disclaimer'),

          _paragraph(
            'Statusly is an independent third-party application.',
          ),

          _paragraph(
            'Statusly is not affiliated with, endorsed by, sponsored by, '
                'or officially connected with WhatsApp or Meta Platforms, Inc.',
          ),

          _paragraph(
            'WhatsApp, Meta, and their respective names, trademarks, logos, '
                'and related intellectual property belong to their respective owners.',
          ),

          _paragraph(
            'Statusly does not claim ownership of WhatsApp or Meta\'s '
                'trademarks or intellectual property.',
          ),

          _sectionTitle('7. Privacy'),

          _paragraph(
            'Your use of Statusly is also subject to our Privacy Policy.',
          ),

          _paragraph(
            'The Privacy Policy explains how Statusly handles information '
                'and the permissions required for the App\'s functionality.',
          ),

          _sectionTitle('8. App Permissions'),

          _paragraph(
            'Statusly may request access to files, folders, photos, videos, '
                'or other device resources that are necessary for the App\'s '
                'status-saving functionality.',
          ),

          _paragraph(
            'You control whether to grant requested permissions or folder '
                'access through the Android operating system.',
          ),

          _paragraph(
            'If you do not grant access required for a particular feature, '
                'that feature may not function correctly.',
          ),

          _sectionTitle('9. Saved Files'),

          _paragraph(
            'When you use Statusly to save media, the saved files are stored '
                'on your device.',
          ),

          _paragraph(
            'You are responsible for managing, protecting, backing up, and '
                'deleting files saved through the App.',
          ),

          _paragraph(
            'We are not responsible for files that you delete, move, '
                'overwrite, lose, or otherwise make inaccessible on your device.',
          ),

          _sectionTitle('10. Availability of the App'),

          _paragraph(
            'We aim to keep Statusly available and functional, but we do not '
                'guarantee that the App will always operate without interruption, '
                'errors, delays, or compatibility problems.',
          ),

          _paragraph(
            'Statusly\'s functionality may be affected by factors outside '
                'our control, including Android updates, device configuration, '
                'storage limitations, file-system changes, WhatsApp changes, '
                'operating-system restrictions, or other third-party changes.',
          ),

          _sectionTitle('11. Changes to the App'),

          _paragraph(
            'Statusly may be modified, updated, improved, restricted, '
                'suspended, or discontinued in whole or in part at any time.',
          ),

          _paragraph(
            'Updates may change how certain features work or introduce '
                'new functionality.',
          ),

          _sectionTitle('12. Third-Party Services'),

          _paragraph(
            'Statusly may interact with or rely on functionality provided '
                'by third-party applications or services, including Android '
                'system functionality.',
          ),

          _paragraph(
            'Third-party applications and services are governed by their '
                'own terms and policies. Statusly is not responsible for the '
                'availability, content, policies, or practices of third-party services.',
          ),

          _sectionTitle('13. Intellectual Property'),

          _paragraph(
            'Unless otherwise stated, the original software, design, '
                'branding, interface, graphics, text, and other original '
                'materials that make up Statusly are protected by applicable '
                'intellectual property laws.',
          ),

          _paragraph(
            'You may not reproduce, modify, distribute, sell, sublicense, '
                'or commercially exploit the App or its original components '
                'except where expressly permitted by applicable law or by the '
                'applicable rights holder.',
          ),

          _sectionTitle('14. No Warranty'),

          _paragraph(
            'To the maximum extent permitted by applicable law, Statusly '
                'is provided on an "as is" and "as available" basis.',
          ),

          _paragraph(
            'We do not guarantee that the App will always be available, '
                'error-free, secure, compatible with every Android device, or '
                'capable of accessing every type of WhatsApp status media.',
          ),

          _paragraph(
            'We do not guarantee that every status photo or video will be '
                'successfully detected, displayed, previewed, or saved.',
          ),

          _sectionTitle('15. Limitation of Liability'),

          _paragraph(
            'To the maximum extent permitted by applicable law, we shall '
                'not be responsible for indirect, incidental, special, '
                'consequential, or punitive damages arising from or related '
                'to your use of Statusly.',
          ),

          _paragraph(
            'This may include, where permitted by law, loss of files, '
                'loss of data, device issues, loss of profits, interruption '
                'of service, or problems caused by third-party applications '
                'or services.',
          ),

          _paragraph(
            'Nothing in these Terms is intended to exclude or limit '
                'liability that cannot lawfully be excluded or limited under '
                'applicable law.',
          ),

          _sectionTitle('16. Termination'),

          _paragraph(
            'You may stop using Statusly at any time by uninstalling the '
                'App from your device.',
          ),

          _paragraph(
            'Access to the App or particular features may also be restricted '
                'or discontinued where necessary for security, legal, technical, '
                'or operational reasons.',
          ),

          _sectionTitle('17. Changes to These Terms'),

          _paragraph(
            'These Terms may be updated from time to time.',
          ),

          _paragraph(
            'When changes are made, the "Last updated" date at the top of '
                'this page will be updated.',
          ),

          _paragraph(
            'Your continued use of Statusly after updated Terms become '
                'available means that you accept the updated Terms to the extent '
                'permitted by applicable law.',
          ),

          _sectionTitle('18. Governing Law'),

          _paragraph(
            'These Terms shall be governed by and interpreted in accordance '
                'with applicable law, without regard to conflict-of-law principles, '
                'except where applicable law requires otherwise.',
          ),

          _paragraph(
            'Nothing in these Terms removes or limits any rights that you '
                'may have under mandatory consumer protection laws applicable to you.',
          ),

          _sectionTitle('19. Contact'),

          _paragraph(
            'If you have questions about these Terms & Conditions or '
                'Statusly, please contact:',
          ),

          const Text(
            'Iszy_Man',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'iszifyaws@gmail.com',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 16),

          _paragraph(
            '© 2026 Iszy_Man. All rights reserved.',
          ),

          _paragraph(
            'Statusly is an independent application and is not affiliated '
                'with WhatsApp or Meta Platforms, Inc.',
          ),
        ],
      ),
    );
  }
}