import 'package:flutter/material.dart';

import '../services/status_service.dart';
import '../theme/app_theme.dart';

class StatusAccessSetup {
  // ==========================================================================
  // SHOW ACCESS SETUP
  // ==========================================================================

  static Future<bool> show({
    required BuildContext context,
    required StatusService statusService,
    required String source,
  }) async {
    if (!context.mounted) {
      return false;
    }

    final sourceName =
    source == 'business' ? 'WhatsApp Business' : 'WhatsApp';

    // ------------------------------------------------------------------------
    // DIALOG 1
    // ------------------------------------------------------------------------

    final continueToDialogTwo = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return _AccessDialog(
          title: 'View $sourceName\nStatuses',
          message: 'Allow Access to\n".Statuses" Folder',
          buttonText: 'Use This Folder',
          actionText: 'Continue 👈',
          onAction: () {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );

    if (continueToDialogTwo != true) {
      return false;
    }

    if (!context.mounted) {
      return false;
    }

    // ------------------------------------------------------------------------
    // DIALOG 2
    // ------------------------------------------------------------------------

    final startAndroidAccess = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return _AccessDialog(
          title: 'To Get All Status',
          message: 'Allow access to\n".Statuses" folder.',
          buttonText: 'Allow Access 👈',
          onAction: () async {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );

    if (startAndroidAccess != true) {
      return false;
    }

    // ------------------------------------------------------------------------
    // OPEN THE REAL ANDROID SAF PICKER
    // ------------------------------------------------------------------------

    try {
      final success =
      await statusService.selectStatusFolder(source);

      return success;
    } catch (e) {
      debugPrint(
        'STATUS ACCESS SETUP ERROR [$source]: $e',
      );

      return false;
    }
  }
}

// ============================================================================
// ACCESS DIALOG
// ============================================================================

class _AccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final String actionText;
  final VoidCallback onAction;

  const _AccessDialog({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onAction,
    this.actionText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          24,
          28,
          24,
          24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------------------------------
            // ICON
            // ----------------------------------------------------------------

            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_rounded,
                size: 34,
                color: AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------------
            // TITLE
            // ----------------------------------------------------------------

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 14),

            // ----------------------------------------------------------------
            // MESSAGE
            // ----------------------------------------------------------------

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------------------
            // VISUAL "USE THIS FOLDER" BUTTON
            // ----------------------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    size: 20,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------------------
            // ACTION BUTTON
            // ----------------------------------------------------------------

            if (actionText.isNotEmpty) ...[
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}