import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.howToUseStatusly,
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
            l10n.howToUseStatusly,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            l10n.howToUseDescription,
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
            title: l10n.howToUseStep1Title,
            description: l10n.howToUseStep1Description,
          ),

          // ===================================================================
          // STEP 2
          // ===================================================================

          _step(
            context: context,
            number: 2,
            icon: Icons.folder_open_rounded,
            title: l10n.howToUseStep2Title,
            description: l10n.howToUseStep2Description,
          ),

          // ===================================================================
          // STEP 3
          // ===================================================================

          _step(
            context: context,
            number: 3,
            icon: Icons.photo_library_rounded,
            title: l10n.howToUseStep3Title,
            description: l10n.howToUseStep3Description,
          ),

          // ===================================================================
          // STEP 4
          // ===================================================================

          _step(
            context: context,
            number: 4,
            icon: Icons.play_circle_outline_rounded,
            title: l10n.howToUseStep4Title,
            description: l10n.howToUseStep4Description,
          ),

          // ===================================================================
          // STEP 5
          // ===================================================================

          _step(
            context: context,
            number: 5,
            icon: Icons.download_rounded,
            title: l10n.howToUseStep5Title,
            description: l10n.howToUseStep5Description,
          ),

          // ===================================================================
          // STEP 6
          // ===================================================================

          _step(
            context: context,
            number: 6,
            icon: Icons.photo_library_outlined,
            title: l10n.howToUseStep6Title,
            description: l10n.howToUseStep6Description,
          ),

          // ===================================================================
          // STEP 7
          // ===================================================================

          _step(
            context: context,
            number: 7,
            icon: Icons.share_rounded,
            title: l10n.howToUseStep7Title,
            description: l10n.howToUseStep7Description,
          ),

          const SizedBox(height: 8),

          // ===================================================================
          // USEFUL TIPS
          // ===================================================================

          Text(
            l10n.howToUseUsefulTips,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          _tip(
            context,
            l10n.howToUseTip1,
          ),

          _tip(
            context,
            l10n.howToUseTip2,
          ),

          _tip(
            context,
            l10n.howToUseTip3,
          ),

          _tip(
            context,
            l10n.howToUseTip4,
          ),

          const SizedBox(height: 12),

          // ===================================================================
          // NEED HELP
          // ===================================================================

          Text(
            l10n.howToUseNeedHelp,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            l10n.howToUseHelpDescription,
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