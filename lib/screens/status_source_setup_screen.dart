import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/status_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_access_setup.dart';

class StatusSourceSetupScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const StatusSourceSetupScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<StatusSourceSetupScreen> createState() =>
      _StatusSourceSetupScreenState();
}

class _StatusSourceSetupScreenState
    extends State<StatusSourceSetupScreen> {
  final StatusService _statusService = StatusService();

  bool _loading = true;
  bool _busy = false;
  bool _failed = false;

  bool _whatsappInstalled = false;
  bool _businessInstalled = false;

  bool _whatsappConfigured = false;
  bool _businessConfigured = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  List<String> get _installedSources => [
    if (_whatsappInstalled) 'whatsapp',
    if (_businessInstalled) 'business',
  ];

  bool _isConfigured(String source) {
    return source == 'business'
        ? _businessConfigured
        : _whatsappConfigured;
  }

  String _sourceName(String source) {
    return source == 'business'
        ? 'WhatsApp Business'
        : 'WhatsApp';
  }

  Future<void> _loadState() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _failed = false;
      });
    }

    try {
      final data = await _statusService.getAppState();

      if (data == null) {
        throw StateError('No app state returned');
      }

      if (!mounted) return;

      _whatsappInstalled =
          data['whatsappInstalled'] == true;

      _businessInstalled =
          data['businessInstalled'] == true;

      _whatsappConfigured =
          data['whatsappConfigured'] == true;

      _businessConfigured =
          data['businessConfigured'] == true;

      final hasConfiguredSource =
          (_whatsappInstalled && _whatsappConfigured) ||
              (_businessInstalled && _businessConfigured);

      if (hasConfiguredSource) {
        widget.onComplete();
        return;
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      debugPrint('Status setup state error: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  Future<void> _setupSource(String source) async {
    if (_busy) return;

    setState(() {
      _busy = true;
    });

    try {
      final success = await StatusAccessSetup.show(
        context: context,
        statusService: _statusService,
        source: source,
      );

      if (!mounted) return;

      if (success) {
        await _loadState();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .pleaseSelectStatusesFolder,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .unableToSetUpStatusAccess(e.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setUpStatusAccess),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _failed
          ? Center(
        child: FilledButton.icon(
          onPressed: _loadState,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.setUpStatusAccess),
        ),
      )
          : Column(
        children: [
          if (_busy)
            const LinearProgressIndicator(),

          Expanded(
            child: _buildSetupContent(),
          ),

          if (!_busy && _installedSources.isEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  onPressed: _loadState,
                  tooltip: l10n.setUpStatusAccess,
                  icon: const Icon(Icons.refresh),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSetupContent() {
    final l10n = AppLocalizations.of(context)!;
    final installed = _installedSources;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download_rounded,
                      size: 36,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.saveStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  l10n.savePhotosAndVideosFromWhatsAppStatuses,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 36),

                if (installed.isEmpty)
                  _buildNoWhatsAppCard(),

                for (final source in installed)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _buildSetupCard(source),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetupCard(String source) {
    final l10n = AppLocalizations.of(context)!;
    final configured = _isConfigured(source);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: AppColors.divider,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _busy
            ? null
            : () {
          if (configured) {
            widget.onComplete();
          } else {
            _setupSource(source);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  color: AppColors.primaryDark,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sourceName(source),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      configured
                          ? l10n.statusAccessIsReady
                          : l10n.setUpStatusAccess,
                      style: TextStyle(
                        color: configured
                            ? AppColors.primaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                configured
                    ? Icons.check_circle
                    : Icons.chevron_right,
                color: configured
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoWhatsAppCard() {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.textSecondary,
            ),

            const SizedBox(height: 16),

            Text(
              l10n.whatsappNotFound,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.installWhatsAppOrBusinessToUseStatusly,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}