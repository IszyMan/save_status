import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  // ===========================================================================
  // STEP
  // ===========================================================================

  Widget _step({
    required BuildContext context,
    required int number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.primaryDark,
                size: 21,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. $title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TIP
  // ===========================================================================

  Widget _tip(
      BuildContext context,
      String text,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            size: 20,
            color: AppColors.primaryDark,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How to Use Statusly',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          32,
        ),
        children: [
          // ===================================================================
          // PAGE TITLE
          // ===================================================================

          Text(
            'How to Use Statusly',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Save photos and videos from WhatsApp statuses directly '
                'to your device.',
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 28),

          // ===================================================================
          // STEP 1
          // ===================================================================

          _step(
            context: context,
            number: 1,
            icon: Icons.chat_rounded,
            title: 'Choose WhatsApp',
            description:
            'Select WhatsApp or WhatsApp Business depending on the '
                'status source you want to use.',
          ),

          // ===================================================================
          // STEP 2
          // ===================================================================

          _step(
            context: context,
            number: 2,
            icon: Icons.folder_open_rounded,
            title: 'Allow Statusly to access statuses',
            description:
            'Android will ask you to allow Statusly to access the '
                'selected WhatsApp status folder. Follow the Android prompt '
                'and confirm the folder selection.',
          ),

          // ===================================================================
          // STEP 3
          // ===================================================================

          _step(
            context: context,
            number: 3,
            icon: Icons.photo_library_rounded,
            title: 'View available statuses',
            description:
            'Once access is configured, Statusly will display available '
                'status photos and videos in the Statuses tab.',
          ),

          // ===================================================================
          // STEP 4
          // ===================================================================

          _step(
            context: context,
            number: 4,
            icon: Icons.play_circle_outline_rounded,
            title: 'Open a status',
            description:
            'Tap a photo or video to view it. Videos can be played '
                'directly inside Statusly.',
          ),

          // ===================================================================
          // STEP 5
          // ===================================================================

          _step(
            context: context,
            number: 5,
            icon: Icons.download_rounded,
            title: 'Save a status',
            description:
            'Use the save option when viewing a status to save the '
                'selected photo or video to your device.',
          ),

          // ===================================================================
          // STEP 6
          // ===================================================================

          _step(
            context: context,
            number: 6,
            icon: Icons.photo_library_outlined,
            title: 'Find your saved media',
            description:
            'Saved photos and videos are available in the Saved tab '
                'inside Statusly. They are also stored on your device.',
          ),

          // ===================================================================
          // STEP 7
          // ===================================================================

          _step(
            context: context,
            number: 7,
            icon: Icons.share_rounded,
            title: 'Share a status',
            description:
            'Use the share option to send supported media through '
                'other apps installed on your device.',
          ),

          const SizedBox(height: 8),

          // ===================================================================
          // USEFUL TIPS
          // ===================================================================

          Text(
            'Useful Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          _tip(
            context,
            'If you use both WhatsApp and WhatsApp Business, configure '
                'each source separately from Settings.',
          ),

          _tip(
            context,
            'Statusly does not upload your status photos or videos to a '
                'Statusly server. Supported status media is processed locally '
                'on your device.',
          ),

          _tip(
            context,
            'If a new status does not appear immediately, return to the '
                'Statuses tab and refresh the list.',
          ),

          _tip(
            context,
            'Only save or share status media that you have permission or '
                'authorization to use.',
          ),

          const SizedBox(height: 12),

          // ===================================================================
          // NEED HELP
          // ===================================================================

          Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'If you experience a problem while using Statusly, contact '
                'support from the Settings screen.',
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}