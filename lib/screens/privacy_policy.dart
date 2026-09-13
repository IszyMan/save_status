import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
            'Statusly Privacy Policy',
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
            'Statusly is designed to help you view and save photos and videos '
                'from WhatsApp statuses on your Android device.',
          ),

          _sectionTitle(context, '1. Introduction'),

          _paragraph(
            context,
            'This Privacy Policy explains how Statusly handles information '
                'when you use the Statusly mobile application ("Statusly", '
                '"the App", or "our App").',
          ),

          _paragraph(
            context,
            'Statusly is designed with a local-first approach. The App does '
                'not require you to create an account and the current version '
                'does not operate a server that stores your WhatsApp status '
                'photos or videos.',
          ),

          _paragraph(
            context,
            'This Privacy Policy explains what information Statusly accesses, '
                'how that information is used, whether it is shared with third '
                'parties, and how information is retained or deleted.',
          ),

          _sectionTitle(context, '2. Information Statusly Accesses'),

          _paragraph(
            context,
            'Statusly may access photos and videos stored in supported '
                'WhatsApp status media locations on your Android device when '
                'you give the App the necessary access or select the relevant '
                'folder through Android\'s file or folder selection system.',
          ),

          _paragraph(
            context,
            'This access is necessary for Statusly\'s main functionality: '
                'displaying available WhatsApp status media so that you can '
                'view and save content to your device.',
          ),

          _paragraph(
            context,
            'Depending on your device, Android version, and installed '
                'WhatsApp applications, Statusly may support WhatsApp and '
                'WhatsApp Business status folders.',
          ),

          _sectionTitle(context, '3. How Statusly Uses Accessed Media'),

          _paragraph(
            context,
            'Statusly uses the status photos and videos it accesses to '
                'provide the App\'s features, including:',
          ),

          _bullet(
            context,
            'Displaying available status photos and videos.',
          ),
          _bullet(
            context,
            'Allowing you to view status media.',
          ),
          _bullet(
            context,
            'Allowing you to save selected status media.',
          ),
          _bullet(
            context,
            'Allowing you to view media saved through the App.',
          ),
          _bullet(
            context,
            'Allowing you to use supported sharing or opening functions '
                'on your device.',
          ),

          _paragraph(
            context,
            'The current version of Statusly processes supported status '
                'media locally on your device. Statusly does not need to upload '
                'your WhatsApp status photos or videos to a Statusly server to '
                'provide these core features.',
          ),

          _sectionTitle(context, '4. Information We Do Not Collect'),

          _paragraph(
            context,
            'The current version of Statusly does not require you to create '
                'an account and does not intentionally collect personal '
                'information such as:',
          ),

          _bullet(context, 'Your name.'),
          _bullet(context, 'Your phone number.'),
          _bullet(context, 'Your email address through the App.'),
          _bullet(context, 'Your WhatsApp account credentials.'),
          _bullet(context, 'Your WhatsApp messages.'),
          _bullet(context, 'Your WhatsApp contacts.'),
          _bullet(context, 'Your passwords.'),
          _bullet(context, 'Your payment information.'),
          _bullet(context, 'Your precise location.'),

          _paragraph(
            context,
            'Statusly also does not require a username or password to use '
                'its core functionality.',
          ),

          _sectionTitle(context, '5. Local Storage and App Preferences'),

          _paragraph(
            context,
            'Statusly may store certain application preferences locally on '
                'your device. These may include information such as whether you '
                'have completed the onboarding process or which supported status '
                'source you last selected.',
          ),

          _paragraph(
            context,
            'This information is stored locally on your device and is used '
                'to make the App function properly and remember your preferences.',
          ),

          _paragraph(
            context,
            'This local preference information is not used by Statusly to '
                'identify you personally.',
          ),

          _sectionTitle(context, '6. Saved Photos and Videos'),

          _paragraph(
            context,
            'When you choose to save a photo or video using Statusly, the '
                'resulting file is stored on your device according to the App\'s '
                'saving functionality and Android\'s storage system.',
          ),

          _paragraph(
            context,
            'Statusly does not maintain a server-side copy of your saved '
                'status media as part of the App\'s normal operation.',
          ),

          _paragraph(
            context,
            'Files saved by you remain on your device until you choose to '
                'delete them using the available device, gallery, '
                'file-management, or App functionality.',
          ),

          _sectionTitle(context, '7. Sharing Information With Third Parties'),

          _paragraph(
            context,
            'Statusly does not sell, rent, or trade your personal information.',
          ),

          _paragraph(
            context,
            'In the current version of the App, Statusly does not '
                'intentionally send your WhatsApp status photos or videos to '
                'third-party servers for storage or advertising purposes.',
          ),

          _paragraph(
            context,
            'If you choose to use Android\'s sharing, opening, or other '
                'third-party functionality, the information or media you choose '
                'to share may be handled by the application or service you select. '
                'That handling is governed by the privacy policy and terms of '
                'the third party involved.',
          ),

          _sectionTitle(context, '8. Third-Party Services and Software'),

          _paragraph(
            context,
            'Statusly may use third-party software libraries that are '
                'necessary to provide certain technical functions of the App.',
          ),

          _paragraph(
            context,
            'Third-party software may process information according to its '
                'own technical operation and applicable policies.',
          ),

          _paragraph(
            context,
            'If future versions of Statusly introduce analytics, advertising, '
                'crash reporting, cloud services, or other third-party services '
                'that collect or transmit user data, this Privacy Policy will be '
                'updated to explain the applicable data practices.',
          ),

          _sectionTitle(context, '9. Advertising'),

          _paragraph(
            context,
            'The current version of Statusly does not use advertising '
                'services as part of its core functionality.',
          ),

          _paragraph(
            context,
            'If advertising services are introduced in a future version, '
                'this Privacy Policy will be updated to explain the applicable '
                'advertising technology, data practices, and third-party services.',
          ),

          _sectionTitle(context, '10. Data Security'),

          _paragraph(
            context,
            'Reasonable measures are taken to protect information handled '
                'by Statusly and to limit access to information to what is '
                'necessary for the App\'s functionality.',
          ),

          _paragraph(
            context,
            'Because Statusly primarily processes supported status media '
                'locally on your Android device, your status media is not '
                'normally transmitted to a Statusly server for storage.',
          ),

          _paragraph(
            context,
            'However, no electronic storage system or method of transmission '
                'can be guaranteed to be completely secure. You should also use '
                'the security features provided by your Android device to '
                'protect your files and information.',
          ),

          _sectionTitle(context, '11. Data Retention and Deletion'),

          _paragraph(
            context,
            'Statusly does not maintain a server-side account containing '
                'your personal information.',
          ),

          _paragraph(
            context,
            'Local application preferences remain on your device while they '
                'are needed by the App. Depending on your Android device and '
                'settings, uninstalling Statusly or clearing the App\'s data can '
                'remove locally stored application data.',
          ),

          _paragraph(
            context,
            'Photos and videos that you save are files stored on your device. '
                'You can delete those files using your device\'s gallery, '
                'file-management application, or other available deletion '
                'functionality.',
          ),

          _paragraph(
            context,
            'Because Statusly does not require user accounts in the current '
                'version, there is no Statusly account that you need to request '
                'deletion of.',
          ),

          _sectionTitle(context, '12. Children\'s Privacy'),

          _paragraph(
            context,
            'Statusly is not specifically designed for children.',
          ),

          _paragraph(
            context,
            'We do not knowingly collect personal information from children '
                'through the App. If you believe that a child has provided '
                'personal information to us, please contact us so that the '
                'matter can be reviewed.',
          ),

          _sectionTitle(context, '13. WhatsApp and Meta Disclaimer'),

          _paragraph(
            context,
            'Statusly is an independent application and is not affiliated '
                'with, endorsed by, sponsored by, or officially connected with '
                'WhatsApp or Meta Platforms, Inc.',
          ),

          _paragraph(
            context,
            '"WhatsApp" and related names, trademarks, and logos belong to '
                'their respective owners.',
          ),

          _paragraph(
            context,
            'Statusly is a third-party utility intended to help users '
                'manage and save status media that they are authorized to access '
                'and save.',
          ),

          _sectionTitle(context, '14. Your Responsibility Regarding Saved Content'),

          _paragraph(
            context,
            'Statusly provides tools for saving media that is accessible to '
                'you on your device.',
          ),

          _paragraph(
            context,
            'You are responsible for ensuring that you have the appropriate '
                'rights, permissions, or authorization to save, copy, share, or '
                'otherwise use any photo, video, or other content you access '
                'through the App.',
          ),

          _paragraph(
            context,
            'You should respect the privacy, copyright, intellectual property, '
                'and other legal rights of content creators and other individuals.',
          ),

          _sectionTitle(context, '15. Changes to This Privacy Policy'),

          _paragraph(
            context,
            'This Privacy Policy may be updated from time to time to reflect '
                'changes to Statusly, changes in applicable laws, or changes in '
                'data practices.',
          ),

          _paragraph(
            context,
            'When changes are made, the "Last updated" date at the top of '
                'this page will be updated.',
          ),

          _paragraph(
            context,
            'You are encouraged to review this Privacy Policy periodically '
                'to stay informed about how Statusly handles information.',
          ),

          _sectionTitle(context, '16. Contact'),

          _paragraph(
            context,
            'If you have questions, concerns, or requests regarding this '
                'Privacy Policy or Statusly\'s privacy practices, please contact:',
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