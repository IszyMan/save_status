import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/status_service.dart';
import '../../theme/app_theme.dart';
import 'how_to_use.dart';
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

  const SettingsScreen({
    super.key,
    required this.statusService,
    required this.whatsappInstalled,
    required this.businessInstalled,
    required this.whatsappConfigured,
    required this.businessConfigured,
    required this.onSelectSource,
    required this.onOpenWhatsApp,
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
  // CONTACT SUPPORT
  // ==========================================================================

  Future<void> _contactSupport(BuildContext context) async {
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
          const SnackBar(
            content: Text(
              'No email app was found on this device.',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open your email app.',
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),

        const Text(
          'General Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Manage your WhatsApp status sources.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 24),

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
            title: const Text(
              'Open WhatsApp',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: const Text(
              'Return directly to WhatsApp',
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
                title: const Text(
                  'How to Use Statusly',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Learn how to view and save statuses',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HowToUseScreen(),
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
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Learn how Statusly handles your information',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
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
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Read the terms for using Statusly',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TermsConditionsScreen(),
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
                title: const Text(
                  'Contact Support',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Get help with Statusly',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _contactSupport(context),
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
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
            ? 'Status access is configured'
            : 'Status folder needs to be configured',
      ),
      trailing: Icon(
        configured ? Icons.check_circle : Icons.chevron_right,
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