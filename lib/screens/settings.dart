import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/status_service.dart';
import '../../theme/app_theme.dart';
import 'how_to_use.dart';
import 'language_selection_screen.dart';
import 'privacy_policy.dart';
import 'terms_conditions.dart';

class SettingsScreen extends StatelessWidget {
  final StatusService statusService;

  final bool whatsappInstalled;
  final bool businessInstalled;

  final bool whatsappConfigured;
  final bool businessConfigured;

  final Future<void> Function(String source) onSelectSource;
  final Future<void> Function() onOpenWhatsApp;

  // Called when the user selects a language.
  final ValueChanged<Locale> onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.statusService,
    required this.whatsappInstalled,
    required this.businessInstalled,
    required this.whatsappConfigured,
    required this.businessConfigured,
    required this.onSelectSource,
    required this.onOpenWhatsApp,
    required this.onLanguageChanged,
  });

  // ==========================================================================
  // SOURCE NAME
  // ==========================================================================

  String _sourceName(String source) {
    if (source == 'business') {
      return 'WhatsApp Business';
    }

    return 'WhatsApp';
  }

  // ==========================================================================
  // CURRENT LANGUAGE NAME
  // ==========================================================================

  Future<String> _getCurrentLanguageName() async {
    final preferences =
    await SharedPreferences.getInstance();

    final languageCode =
        preferences.getString('selected_language') ?? 'en';

    switch (languageCode) {
      case 'es':
        return 'Español';

      case 'fr':
        return 'Français';

      case 'de':
        return 'Deutsch';

      case 'pt':
        return 'Português';

      case 'en':
      default:
        return 'English';
    }
  }

  // ==========================================================================
  // LANGUAGE
  // ==========================================================================

  Future<void> _openLanguageSelection(
      BuildContext context,
      ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LanguageSelectionScreen(
          onLanguageSelected: (locale) {
            onLanguageChanged(locale);
          },
          onCompleted: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // CONTACT SUPPORT
  // ==========================================================================

  Future<void> _contactSupport(
      BuildContext context,
      ) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'iszifyaws@gmail.com',
      queryParameters: {
        'subject': 'Statusly Support',
      },
    );

    try {
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .noEmailAppFound,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .unableToOpenEmail,
            ),
          ),
        );
      }
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),

        // ====================================================================
        // GENERAL SETTINGS
        // ====================================================================

        Text(
          l10n.generalSettings,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          l10n.manageWhatsAppStatusSources,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 24),

        // ====================================================================
        // LANGUAGE
        // ====================================================================

        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0x14128C7E),
              child: Icon(
                Icons.language_rounded,
                color: AppColors.primaryDark,
              ),
            ),
            title: Text(
              l10n.language,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: FutureBuilder<String>(
              future: _getCurrentLanguageName(),
              builder: (
                  context,
                  snapshot,
                  ) {
                return Text(
                  snapshot.data ?? 'English',
                );
              },
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () => _openLanguageSelection(
              context,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // WHATSAPP SOURCES
        // ====================================================================

        Card(
          child: Column(
            children: [
              if (whatsappInstalled)
                _buildSourceTile(
                  context,
                  source: 'whatsapp',
                  configured: whatsappConfigured,
                  icon: Icons.chat_rounded,
                ),

              if (businessInstalled)
                _buildSourceTile(
                  context,
                  source: 'business',
                  configured: businessConfigured,
                  icon: Icons.business,
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // OPEN WHATSAPP
        // ====================================================================

        Card(
          child: ListTile(
            leading: const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.primaryDark,
            ),
            title: Text(
              l10n.openWhatsApp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              l10n.returnDirectlyToWhatsApp,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: onOpenWhatsApp,
          ),
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // HELP & INFORMATION
        // ====================================================================

        Card(
          child: Column(
            children: [
              // ==============================================================
              // HOW TO USE
              // ==============================================================

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x14128C7E),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primaryDark,
                  ),
                ),
                title: Text(
                  l10n.howToUseStatusly,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  l10n.learnHowToViewAndSaveStatuses,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                      const HowToUseScreen(),
                    ),
                  );
                },
              ),

              const Divider(
                height: 1,
                indent: 72,
              ),

              // ==============================================================
              // PRIVACY POLICY
              // ==============================================================

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x14128C7E),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.primaryDark,
                  ),
                ),
                title: Text(
                  l10n.privacyPolicy,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  l10n.learnHowStatuslyHandlesInformation,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                      const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),

              const Divider(
                height: 1,
                indent: 72,
              ),

              // ==============================================================
              // TERMS & CONDITIONS
              // ==============================================================

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x14128C7E),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryDark,
                  ),
                ),
                title: Text(
                  l10n.termsAndConditions,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  l10n.readTermsForUsingStatusly,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                      const TermsConditionsScreen(),
                    ),
                  );
                },
              ),

              const Divider(
                height: 1,
                indent: 72,
              ),

              // ==============================================================
              // CONTACT SUPPORT
              // ==============================================================

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x14128C7E),
                  child: Icon(
                    Icons.email_outlined,
                    color: AppColors.primaryDark,
                  ),
                ),
                title: Text(
                  l10n.contactSupport,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  l10n.getHelpWithStatusly,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _contactSupport(
                  context,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // ==========================================================================
  // SOURCE TILE
  // ==========================================================================

  Widget _buildSourceTile(
      BuildContext context, {
        required String source,
        required bool configured,
        required IconData icon,
      }) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
        AppColors.primary.withValues(alpha: 0.12),
        child: Icon(
          icon,
          color: AppColors.primaryDark,
        ),
      ),
      title: Text(
        _sourceName(source),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        configured
            ? l10n.statusAccessIsConfigured
            : l10n.statusFolderNeedsConfiguration,
      ),
      trailing: Icon(
        configured
            ? Icons.check_circle
            : Icons.chevron_right,
        color: configured
            ? AppColors.primaryDark
            : AppColors.textSecondary,
      ),
      onTap: () {
        onSelectSource(source);
      },
    );
  }
}