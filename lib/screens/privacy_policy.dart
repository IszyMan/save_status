import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          const Text(
            'Statusly Privacy Policy',
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
            'Statusly is designed to help you view and save photos and videos '
                'from WhatsApp statuses on your Android device.',
          ),

          _sectionTitle('1. Introduction'),

          _paragraph(
            'This Privacy Policy explains how Statusly handles information '
                'when you use the Statusly mobile application ("Statusly", '
                '"the App", or "our App").',
          ),

          _paragraph(
            'Statusly is designed with a local-first approach. The App does '
                'not require you to create an account and the current version '
                'does not operate a server that stores your WhatsApp status '
                'photos or videos.',
          ),

          _paragraph(
            'This Privacy Policy explains what information Statusly accesses, '
                'how that information is used, whether it is shared with third '
                'parties, and how information is retained or deleted.',
          ),

          _sectionTitle('2. Information Statusly Accesses'),

          _paragraph(
            'Statusly may access photos and videos stored in supported '
                'WhatsApp status media locations on your Android device when '
                'you give the App the necessary access or select the relevant '
                'folder through Android\'s file or folder selection system.',
          ),

          _paragraph(
            'This access is necessary for Statusly\'s main functionality: '
                'displaying available WhatsApp status media so that you can '
                'view and save content to your device.',
          ),

          _paragraph(
            'Depending on your device, Android version, and installed '
                'WhatsApp applications, Statusly may support WhatsApp and '
                'WhatsApp Business status folders.',
          ),

          _sectionTitle('3. How Statusly Uses Accessed Media'),

          _paragraph(
            'Statusly uses the status photos and videos it accesses to '
                'provide the App\'s features, including:',
          ),

          _bullet('Displaying available status photos and videos.'),
          _bullet('Allowing you to view status media.'),
          _bullet('Allowing you to save selected status media.'),
          _bullet('Allowing you to view media saved through the App.'),
          _bullet(
            'Allowing you to use supported sharing or opening functions '
                'on your device.',
          ),

          _paragraph(
            'The current version of Statusly processes supported status '
                'media locally on your device. Statusly does not need to upload '
                'your WhatsApp status photos or videos to a Statusly server to '
                'provide these core features.',
          ),

          _sectionTitle('4. Information We Do Not Collect'),

          _paragraph(
            'The current version of Statusly does not require you to create '
                'an account and does not intentionally collect personal '
                'information such as:',
          ),

          _bullet('Your name.'),
          _bullet('Your phone number.'),
          _bullet('Your email address through the App.'),
          _bullet('Your WhatsApp account credentials.'),
          _bullet('Your WhatsApp messages.'),
          _bullet('Your WhatsApp contacts.'),
          _bullet('Your passwords.'),
          _bullet('Your payment information.'),
          _bullet('Your precise location.'),

          _paragraph(
            'Statusly also does not require a username or password to use '
                'its core functionality.',
          ),

          _sectionTitle('5. Local Storage and App Preferences'),

          _paragraph(
            'Statusly may store certain application preferences locally on '
                'your device. These may include information such as whether you '
                'have completed the onboarding process or which supported status '
                'source you last selected.',
          ),

          _paragraph(
            'This information is stored locally on your device and is used '
                'to make the App function properly and remember your preferences.',
          ),

          _paragraph(
            'This local preference information is not used by Statusly to '
                'identify you personally.',
          ),

          _sectionTitle('6. Saved Photos and Videos'),

          _paragraph(
            'When you choose to save a photo or video using Statusly, the '
                'resulting file is stored on your device according to the App\'s '
                'saving functionality and Android\'s storage system.',
          ),

          _paragraph(
            'Statusly does not maintain a server-side copy of your saved '
                'status media as part of the App\'s normal operation.',
          ),

          _paragraph(
            'Files saved by you remain on your device until you choose to '
                'delete them using the available device, gallery, '
                'file-management, or App functionality.',
          ),

          _sectionTitle('7. Sharing Information With Third Parties'),

          _paragraph(
            'Statusly does not sell, rent, or trade your personal information.',
          ),

          _paragraph(
            'In the current version of the App, Statusly does not '
                'intentionally send your WhatsApp status photos or videos to '
                'third-party servers for storage or advertising purposes.',
          ),

          _paragraph(
            'If you choose to use Android\'s sharing, opening, or other '
                'third-party functionality, the information or media you choose '
                'to share may be handled by the application or service you select. '
                'That handling is governed by the privacy policy and terms of '
                'the third party involved.',
          ),

          _sectionTitle('8. Third-Party Services and Software'),

          _paragraph(
            'Statusly may use third-party software libraries that are '
                'necessary to provide certain technical functions of the App.',
          ),

          _paragraph(
            'Third-party software may process information according to its '
                'own technical operation and applicable policies.',
          ),

          _paragraph(
            'If future versions of Statusly introduce analytics, advertising, '
                'crash reporting, cloud services, or other third-party services '
                'that collect or transmit user data, this Privacy Policy will be '
                'updated to explain the applicable data practices.',
          ),

          _sectionTitle('9. Advertising'),

          _paragraph(
            'The current version of Statusly does not use advertising '
                'services as part of its core functionality.',
          ),

          _paragraph(
            'If advertising services are introduced in a future version, '
                'this Privacy Policy will be updated to explain the applicable '
                'advertising technology, data practices, and third-party services.',
          ),

          _sectionTitle('10. Data Security'),

          _paragraph(
            'Reasonable measures are taken to protect information handled '
                'by Statusly and to limit access to information to what is '
                'necessary for the App\'s functionality.',
          ),

          _paragraph(
            'Because Statusly primarily processes supported status media '
                'locally on your Android device, your status media is not '
                'normally transmitted to a Statusly server for storage.',
          ),

          _paragraph(
            'However, no electronic storage system or method of transmission '
                'can be guaranteed to be completely secure. You should also use '
                'the security features provided by your Android device to '
                'protect your files and information.',
          ),

          _sectionTitle('11. Data Retention and Deletion'),

          _paragraph(
            'Statusly does not maintain a server-side account containing '
                'your personal information.',
          ),

          _paragraph(
            'Local application preferences remain on your device while they '
                'are needed by the App. Depending on your Android device and '
                'settings, uninstalling Statusly or clearing the App\'s data can '
                'remove locally stored application data.',
          ),

          _paragraph(
            'Photos and videos that you save are files stored on your device. '
                'You can delete those files using your device\'s gallery, '
                'file-management application, or other available deletion '
                'functionality.',
          ),

          _paragraph(
            'Because Statusly does not require user accounts in the current '
                'version, there is no Statusly account that you need to request '
                'deletion of.',
          ),

          _sectionTitle('12. Children\'s Privacy'),

          _paragraph(
            'Statusly is not specifically designed for children.',
          ),

          _paragraph(
            'We do not knowingly collect personal information from children '
                'through the App. If you believe that a child has provided '
                'personal information to us, please contact us so that the '
                'matter can be reviewed.',
          ),

          _sectionTitle('13. WhatsApp and Meta Disclaimer'),

          _paragraph(
            'Statusly is an independent application and is not affiliated '
                'with, endorsed by, sponsored by, or officially connected with '
                'WhatsApp or Meta Platforms, Inc.',
          ),

          _paragraph(
            '"WhatsApp" and related names, trademarks, and logos belong to '
                'their respective owners.',
          ),

          _paragraph(
            'Statusly is a third-party utility intended to help users '
                'manage and save status media that they are authorized to access '
                'and save.',
          ),

          _sectionTitle('14. Your Responsibility Regarding Saved Content'),

          _paragraph(
            'Statusly provides tools for saving media that is accessible to '
                'you on your device.',
          ),

          _paragraph(
            'You are responsible for ensuring that you have the appropriate '
                'rights, permissions, or authorization to save, copy, share, or '
                'otherwise use any photo, video, or other content you access '
                'through the App.',
          ),

          _paragraph(
            'You should respect the privacy, copyright, intellectual property, '
                'and other legal rights of content creators and other individuals.',
          ),

          _sectionTitle('15. Changes to This Privacy Policy'),

          _paragraph(
            'This Privacy Policy may be updated from time to time to reflect '
                'changes to Statusly, changes in applicable laws, or changes in '
                'data practices.',
          ),

          _paragraph(
            'When changes are made, the "Last updated" date at the top of '
                'this page will be updated.',
          ),

          _paragraph(
            'You are encouraged to review this Privacy Policy periodically '
                'to stay informed about how Statusly handles information.',
          ),

          _sectionTitle('16. Contact'),

          _paragraph(
            'If you have questions, concerns, or requests regarding this '
                'Privacy Policy or Statusly\'s privacy practices, please contact:',
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