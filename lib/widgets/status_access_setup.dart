import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/status_service.dart';

class StatusAccessSetup {
  static Future<bool> show({
    required BuildContext context,
    required StatusService statusService,
    required String source,
  }) async {
    if (!context.mounted) return false;

    final l10n = AppLocalizations.of(context)!;

    final sourceName = source == 'business'
        ? 'WhatsApp Business'
        : 'WhatsApp';

    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return _AccessDialog(
          title: l10n.saveSourceStatusTitle(sourceName),
          message: l10n.allowAccessToStatusesFolder,
          onAction: () {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );

    if (proceed != true || !context.mounted) {
      return false;
    }

    try {
      // Opens Android's real folder picker.
      // The native instruction guide still appears above it.
      return await statusService.selectStatusFolder(source);
    } catch (e) {
      debugPrint(
        'STATUS ACCESS SETUP ERROR [$source]: $e',
      );

      return false;
    }
  }
}

class _AccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAction;

  const _AccessDialog({
    required this.title,
    required this.message,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF333333),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            28,
            16,
            12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Color(0xFFD0D0D0),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFA8C7FA),
                    minimumSize: const Size(88, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  child: Text(
                    l10n.allowAccessButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}