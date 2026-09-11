import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/onboarding.dart';
import '../screens/settings.dart';
import '../screens/splash_screen.dart';
import '../services/status_service.dart';
import '../theme/app_theme.dart';
import '../widgets/media_filter_bar.dart';
import 'view.dart';
import 'package:flutter/services.dart';

class StatusSaverApp extends StatelessWidget {
  const StatusSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Statusly',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const AppStartupScreen(),
    );
  }
}

// ============================================================================
// APP STARTUP
// ============================================================================


class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  bool _checking = true;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();

    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      final completed =
          preferences.getBool('onboarding_completed') ?? false;

      if (!mounted) return;

      setState(() {
        _onboardingCompleted = completed;
        _checking = false;
      });
    } catch (e) {
      debugPrint(
        'Unable to check onboarding status: $e',
      );

      if (!mounted) return;

      setState(() {
        _onboardingCompleted = false;
        _checking = false;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      await preferences.setBool(
        'onboarding_completed',
        true,
      );
    } catch (e) {
      debugPrint(
        'Unable to save onboarding status: $e',
      );
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const StatusHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Still checking SharedPreferences.
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF075E54),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF25D366),
              ),
            ),
          ),
        ),
      );
    }

    // First launch:
    // Show onboarding directly.
    //
    // IMPORTANT:
    // Do NOT put onboarding inside SplashScreen.
    if (!_onboardingCompleted) {
      return OnboardingScreen(
        onGetStarted: _completeOnboarding,
      );
    }

    // Returning user:
    // Show splash, then go to StatusHomePage.
    return const SplashScreen(
      nextScreen: StatusHomePage(),
    );
  }
}

// ============================================================================
// STATUS HOME PAGE
// ============================================================================

class StatusHomePage extends StatefulWidget {
  const StatusHomePage({super.key});

  @override
  State<StatusHomePage> createState() => _StatusHomePageState();
}

class _StatusHomePageState extends State<StatusHomePage> {
  final StatusService _statusService = StatusService();

  // ==========================================================================
  // APP STATE
  // ==========================================================================

  bool _whatsappInstalled = false;
  bool _businessInstalled = false;

  bool _whatsappConfigured = false;
  bool _businessConfigured = false;

  String? _lastSelectedSource;
  String? _selectedSource;

  // 0 = Statuses
  // 1 = Saved
  // 2 = Settings
  int _currentTab = 0;
  final PageController _pageController = PageController();

  // Only two filters.
  // Videos is the default because "All" has been removed.
  String _statusFilter = 'images';
  String _savedFilter = 'images';

  List<Map<String, dynamic>> _statuses = [];
  List<Map<String, dynamic>> _savedStatuses = [];

  bool _loadingStatuses = false;
  bool _loadingSaved = false;

  final Map<String, Uint8List> _thumbnailCache = {};

  // Statuses that the user has already opened inside Statusly.
  final Set<String> _openedStatusUris = {};

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _loadAppState();
    _loadSavedStatuses();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // LOAD APP STATE
  // ==========================================================================

  Future<void> _loadAppState() async {
    try {
      final data = await _statusService.getAppState();

      if (data == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _whatsappInstalled = data['whatsappInstalled'] == true;
        _businessInstalled = data['businessInstalled'] == true;

        _whatsappConfigured = data['whatsappConfigured'] == true;
        _businessConfigured = data['businessConfigured'] == true;

        _lastSelectedSource =
            data['lastSelectedSource']?.toString();
      });

      await _selectInitialSource();
    } catch (e) {
      debugPrint(
        'Unable to load app state: $e',
      );
    }
  }

  // ==========================================================================
  // SELECT INITIAL SOURCE
  // ==========================================================================

  Future<void> _selectInitialSource() async {
    final configuredSources = _configuredSources;

    if (configuredSources.isEmpty) {
      if (!mounted) return;

      setState(() {
        _selectedSource = null;
      });

      return;
    }

    // Prefer the source the user selected last,
    // but only if it is still installed and configured.
    if (_lastSelectedSource != null &&
        configuredSources.contains(_lastSelectedSource)) {
      if (!mounted) return;

      setState(() {
        _selectedSource = _lastSelectedSource;
      });

      await _loadStatuses(
        _lastSelectedSource!,
      );

      return;
    }

    // Otherwise use the first configured source.
    final source = configuredSources.first;

    if (!mounted) return;

    setState(() {
      _selectedSource = source;
    });

    await _loadStatuses(source);
  }

  // ==========================================================================
  // INSTALLED SOURCES
  // ==========================================================================

  List<String> get _installedSources {
    final sources = <String>[];

    if (_whatsappInstalled) {
      sources.add('whatsapp');
    }

    if (_businessInstalled) {
      sources.add('business');
    }

    return sources;
  }

  bool _isConfigured(String source) {
    if (source == 'business') {
      return _businessConfigured;
    }

    return _whatsappConfigured;
  }

  String _sourceName(String source) {
    if (source == 'business') {
      return 'WhatsApp Business';
    }

    return 'WhatsApp';
  }


  List<String> get _configuredSources {
    final sources = <String>[];

    if (_whatsappInstalled &&
        _whatsappConfigured) {
      sources.add('whatsapp');
    }

    if (_businessInstalled &&
        _businessConfigured) {
      sources.add('business');
    }

    return sources;
  }

  // ==========================================================================
  // OPEN WHATSAPP
  // ==========================================================================

  Future<void> _openWhatsApp() async {
    final source = _selectedSource;

    if (source == null) {
      return;
    }

    try {
      final opened = await _statusService.openWhatsApp(
        source,
      );

      if (!mounted) return;

      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_sourceName(source)} is not installed.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint(
        'Unable to open WhatsApp: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open WhatsApp.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================================
  // SETUP SOURCE
  // ==========================================================================

  Future<void> _setupSource(String source) async {
    try {
      final success =
      await _statusService.selectStatusFolder(
        source,
      );

      if (!mounted) return;

      if (success == true) {
        await _loadAppState();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_sourceName(source)} status access is ready.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select the .Statuses folder.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint(
        'Unable to set up status access: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to set up status access: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================================
  // LOAD STATUSES
  // ==========================================================================

  Future<void> _loadStatuses(String source) async {
    if (!_isConfigured(source)) {
      return;
    }

    if (mounted) {
      setState(() {
        _loadingStatuses = true;
      });
    }

    try {
      final statuses =
      await _statusService.getStatuses(
        source,
      );

      statuses.sort(
            (a, b) {
          final aTime = int.tryParse(
            a['lastModified']?.toString() ?? '',
          ) ??
              0;

          final bTime = int.tryParse(
            b['lastModified']?.toString() ?? '',
          ) ??
              0;

          return bTime.compareTo(aTime);
        },
      );

      final openedUris =
      await _statusService.getOpenedStatusUris(
        source,
      );

      if (!mounted) return;

      setState(() {
        _statuses = statuses;

        _openedStatusUris
          ..clear()
          ..addAll(openedUris);
      });
    } catch (e) {
      debugPrint(
        'Unable to load statuses: $e',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _loadingStatuses = false;
      });
    }
  }

  // ==========================================================================
  // LOAD SAVED STATUSES
  // ==========================================================================

  Future<void> _loadSavedStatuses() async {
    if (mounted) {
      setState(() {
        _loadingSaved = true;
      });
    }

    try {
      final saved =
      await _statusService.getSavedStatuses();

      if (!mounted) return;

      setState(() {
        _savedStatuses = saved;
      });
    } catch (e) {
      debugPrint(
        'Unable to load saved statuses: $e',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _loadingSaved = false;
      });
    }
  }

  // ==========================================================================
  // SELECT SOURCE
  // ==========================================================================

  Future<void> _selectSource(String source) async {
    if (!_configuredSources.contains(source)) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _selectedSource = source;
      _statusFilter = 'images';
    });

    try {
      await _statusService.setLastSelectedSource(
        source,
      );
    } catch (e) {
      debugPrint(
        'Unable to save selected source: $e',
      );
    }

    await _loadStatuses(source);
  }


  Future<void> _handleSettingsSource(String source) async {
    if (_isConfigured(source)) {
      await _selectSource(source);
      return;
    }

    await _setupSource(source);
  }

  // ==========================================================================
  // BOTTOM NAVIGATION
  // ==========================================================================

  Future<void> _changeTab(int index) async {
    if (index == _currentTab) {
      return;
    }

    await _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 420,
      ),
      curve: Curves.easeInOutCubic,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _currentTab = index;
    });
  }

  // ==========================================================================
  // FILTER
  // ==========================================================================

  List<Map<String, dynamic>> _filterMedia(
      List<Map<String, dynamic>> items,
      String filter,
      ) {
    return items.where(
          (status) {
        final mime = (status['mimeType'] ?? '')
            .toString()
            .toLowerCase();

        if (filter == 'videos') {
          return mime.startsWith('video/') ||
              _isVideo(status);
        }

        if (filter == 'images') {
          return mime.startsWith('image/');
        }

        return false;
      },
    ).toList();
  }

  List<Map<String, dynamic>> get _filteredStatuses {
    return _filterMedia(
      _statuses,
      _statusFilter,
    );
  }

  List<Map<String, dynamic>> get _filteredSavedStatuses {
    return _filterMedia(
      _savedStatuses,
      _savedFilter,
    );
  }

  // ==========================================================================
  // VIDEO CHECK
  // ==========================================================================

  bool _isVideo(Map<String, dynamic> status) {
    final mime = (status['mimeType'] ?? '')
        .toString()
        .toLowerCase();

    if (mime.startsWith('video/')) {
      return true;
    }

    final name = (status['name'] ?? '')
        .toString()
        .toLowerCase();

    return name.endsWith('.mp4') ||
        name.endsWith('.3gp') ||
        name.endsWith('.mkv') ||
        name.endsWith('.webm') ||
        name.endsWith('.mov');
  }


  // ==========================================================================
  // STATUS OPENED CHECK
  // ==========================================================================

  bool _isStatusNew(
      Map<String, dynamic> status,
      ) {
    final uri =
        status['uri']?.toString() ?? '';

    if (uri.isEmpty) {
      return false;
    }

    return !_openedStatusUris.contains(uri);
  }

  // ==========================================================================
  // OPEN STATUS
  // ==========================================================================

  Future<void> _openStatus(
      Map<String, dynamic> status,
      ) async {
    try {
      final path =
      await _statusService.prepareStatus(
        uri: status['uri'],
        name: status['name'],
      );

      if (path == null || path.isEmpty) {
        throw Exception(
          'Unable to prepare status',
        );
      }

      final source = _selectedSource;

      if (source == null) {
        throw Exception(
          'No WhatsApp source selected',
        );
      }

      final uri =
          status['uri']?.toString() ?? '';

      if (uri.isNotEmpty) {
        await _statusService.markStatusOpened(
          source: source,
          uri: uri,
        );

        if (mounted) {
          setState(() {
            _openedStatusUris.add(uri);
          });
        }
      }

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StatusView(
            filePath: path,
            status: status,
            isVideo: _isVideo(status),
          ),
        ),
      );

      await _loadSavedStatuses();
    } catch (e) {
      debugPrint(
        'Unable to open status: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open status: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================================
  // THUMBNAIL CACHE
  // ==========================================================================

  void _cacheThumbnail(
      String uri,
      Uint8List bytes,
      ) {
    if (_thumbnailCache.length >= 100 &&
        !_thumbnailCache.containsKey(uri)) {
      _thumbnailCache.remove(
        _thumbnailCache.keys.first,
      );
    }

    _thumbnailCache[uri] = bytes;
  }

  // ==========================================================================
  // SETUP CONTENT
  // ==========================================================================

  Widget _buildSetupContent() {
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
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),

                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary
                          .withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download_rounded,
                      size: 36,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Save Status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(
                  'Save photos and videos from your WhatsApp statuses.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(
                  height: 36,
                ),

                if (installed.isEmpty)
                  _buildNoWhatsAppCard(),

                for (final source in installed)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _buildSetupCard(
                      source,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SETUP CARD
  // ==========================================================================

  Widget _buildSetupCard(String source) {
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
        onTap: () {
          if (configured) {
            _selectSource(source);
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
                  color: AppColors.primary
                      .withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  color: AppColors.primaryDark,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sourceName(source),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      configured
                          ? 'Status access is ready'
                          : 'Set up status access',
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

  // ==========================================================================
  // NO WHATSAPP
  // ==========================================================================

  Widget _buildNoWhatsAppCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.textSecondary,
            ),

            SizedBox(
              height: 16,
            ),

            Text(
              'WhatsApp not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 8,
            ),

            Text(
              'Install WhatsApp or WhatsApp Business to use Status Saver.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SOURCE SELECTOR
  // ==========================================================================

  Widget _buildSourceSelector() {
    final source = _selectedSource;
    final configuredSources = _configuredSources;

    if (source == null ||
        !configuredSources.contains(source)) {
      return const SizedBox.shrink();
    }

    // Only one configured source.
    // Show its name without a dropdown.
    if (configuredSources.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 4,
        ),
        child: Center(
          child: Text(
            _sourceName(source),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // Two configured sources.
    // Show the dropdown.
    return Padding(
      padding: const EdgeInsets.only(
        right: 4,
      ),
      child: PopupMenuButton<String>(
        onSelected: _selectSource,
        itemBuilder: (context) {
          return configuredSources.map(
                (item) {
              final selected =
                  item == _selectedSource;

              return PopupMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      size: 20,
                      color: AppColors.primaryDark,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        _sourceName(item),
                      ),
                    ),

                    if (selected)
                      const Icon(
                        Icons.check,
                        size: 20,
                        color: AppColors.primaryDark,
                      ),
                  ],
                ),
              );
            },
          ).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _sourceName(source),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(
                width: 3,
              ),

              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }



  // ==========================================================================
  // MEDIA GRID
  // ==========================================================================

  Widget _buildMediaGrid({
    required List<Map<String, dynamic>> items,
    required bool loading,
    required Future<void> Function() onRefresh,
    required String emptyTitle,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
      if (loading) {
        return const SizedBox.expand();
      }

      return _buildEmptyMediaState(
        onRefresh: onRefresh,
        title: emptyTitle,
        message: emptyMessage,
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: GridView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        cacheExtent: 800,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.05,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final status = items[index];

          final uri =
              status['uri']?.toString() ??
                  'status_$index';

          return KeyedSubtree(
            key: ValueKey(uri),
            child: _buildMediaTile(status),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // MEDIA TILE
  // ==========================================================================

  Widget _buildMediaTile(
      Map<String, dynamic> status,
      ) {
    final uri =
        status['uri']?.toString() ?? '';

    final isVideo = _isVideo(status);

    return GestureDetector(
      onTap: () {
        _openStatus(status);
      },
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --------------------------------------------------------------
            // THUMBNAIL
            // --------------------------------------------------------------

            StatusThumbnail(
              status: status,
              cachedBytes:
              _thumbnailCache[uri],
              statusService:
              _statusService,
              onLoaded: (bytes) {
                _cacheThumbnail(
                  uri,
                  bytes,
                );
              },
            ),

            // --------------------------------------------------------------
            // VIDEO PLAY ICON
            // --------------------------------------------------------------

            if (isVideo)
              Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration:
                  BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

            // --------------------------------------------------------------
            // DOWNLOAD ARROW
            //
            // IMPORTANT:
            // This does NOT download the status.
            // It only opens the same StatusView as tapping the preview.
            // --------------------------------------------------------------

            Positioned(
              bottom: 10,
              right: 10,
              child: Material(
                color: AppColors.primaryDark,
                shape: const CircleBorder(),
                elevation: 3,
                shadowColor:
                Colors.black.withOpacity(
                  0.25,
                ),
                child: InkWell(
                  customBorder:
                  const CircleBorder(),
                  onTap: () {
                    _openStatus(status);
                  },
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPTY STATE
  // ==========================================================================

  Widget _buildEmptyMediaState({
    required Future<void> Function() onRefresh,
    required String title,
    required String message,
  }) {
    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
            MediaQuery.of(context).size.height *
                0.28,
          ),

          const Icon(
            Icons.photo_library_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // STATUSES TAB
  // ==========================================================================

  Widget _buildStatusesTab() {
    final source = _selectedSource;

    if (source == null ||
        !_isConfigured(source)) {
      return _buildSetupContent();
    }

    final showingVideos =
        _statusFilter == 'videos';

    final newStatuses =
    _statuses.where(_isStatusNew).toList();

    final imagesCount =
        _filterMedia(
          newStatuses,
          'images',
        ).length;

    final videosCount =
        _filterMedia(
          newStatuses,
          'videos',
        ).length;

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),

        MediaFilterBar(
          selectedFilter: _statusFilter,
          onChanged: (value) {
            setState(() {
              _statusFilter = value;
            });
          },
          imagesCount: imagesCount,
          videosCount: videosCount,
        ),

        const SizedBox(
          height: 4,
        ),

        Expanded(
          child: _buildMediaGrid(
            items: _filteredStatuses,
            loading: _loadingStatuses,
            onRefresh: () {
              return _loadStatuses(
                source,
              );
            },
            emptyTitle: showingVideos
                ? 'No videos found'
                : 'No images found',
            emptyMessage: showingVideos
                ? 'Video statuses will appear here.'
                : 'Image statuses will appear here.',
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SAVED TAB
  // ==========================================================================

  Widget _buildSavedTab() {
    final showingVideos =
        _savedFilter == 'videos';

    final imagesCount =
        _filterMedia(_savedStatuses, 'images').length;

    final videosCount =
        _filterMedia(_savedStatuses, 'videos').length;

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),

        MediaFilterBar(
          selectedFilter: _savedFilter,
          onChanged: (value) {
            setState(() {
              _savedFilter = value;
            });
          },
          imagesCount: imagesCount,
          videosCount: videosCount,
        ),

        const SizedBox(
          height: 4,
        ),

        Expanded(
          child: _buildMediaGrid(
            items: _filteredSavedStatuses,
            loading: _loadingSaved,
            onRefresh: _loadSavedStatuses,
            emptyTitle: showingVideos
                ? 'No saved videos'
                : 'No saved images',
            emptyMessage: showingVideos
                ? 'Videos you save will appear here.'
                : 'Images you save will appear here.',
          ),
        ),
      ],
    );
  }


  Future<bool> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Exit Statusly?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to close the app?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {


    final showingStatuses =
        _currentTab == 0;

    final showingSaved =
        _currentTab == 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldExit = await _confirmExit();

        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        // ======================================================================
        // APP BAR
        // ======================================================================

        appBar: AppBar(
          title: Text(
            showingStatuses
                ? 'Statusly'
                : showingSaved
                ? 'Saved'
                : 'Settings',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            if (showingStatuses)
              _buildSourceSelector(),

            IconButton(
              tooltip: 'Open WhatsApp',
              onPressed: _openWhatsApp,
              icon: const Icon(
                Icons.mark_chat_unread,
              ),
            ),

            const SizedBox(
              width: 4,
            ),
          ],
        ),

        // ======================================================================
        // BODY
        // ======================================================================

        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            if (_currentTab != index) {
              setState(() {
                _currentTab = index;
              });
            }
          },
          children: [
            _buildStatusesTab(),

            _buildSavedTab(),

            SettingsScreen(
              statusService: _statusService,
              whatsappInstalled: _whatsappInstalled,
              businessInstalled: _businessInstalled,
              whatsappConfigured: _whatsappConfigured,
              businessConfigured: _businessConfigured,
              onSelectSource: _handleSettingsSource,
              onOpenWhatsApp: _openWhatsApp,
            ),
          ],
        ),

        // ======================================================================
        // BOTTOM NAVIGATION
        // ======================================================================

        bottomNavigationBar:
        NavigationBar(
          selectedIndex: _currentTab,
          onDestinationSelected: _changeTab,
          destinations: [
            NavigationDestination(
              icon: const StatusIcon(),
              selectedIcon: const StatusIcon(
                selected: true,
              ),
              label: 'Statuses',
            ),

            NavigationDestination(
              icon: const Icon(
                Icons.download_outlined,
              ),
              selectedIcon: const Icon(
                Icons.download,
              ),
              label: 'Saved',
            ),

            NavigationDestination(
              icon: const Icon(
                Icons.settings_outlined,
              ),
              selectedIcon: const Icon(
                Icons.settings,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}


class StatusIcon extends StatelessWidget {
  final bool selected;

  const StatusIcon({
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _StatusIconPainter(),
      ),
    );
  }
}

class _StatusIconPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    // ========================================================
    // OUTER BROKEN CHAT CIRCLE
    // ========================================================

    final outerRadius =
        size.width * 0.40;

    final outerRect = Rect.fromCircle(
      center: center,
      radius: outerRadius,
    );

    // Top section
    canvas.drawArc(
      outerRect,
      -2.75,
      1.35,
      false,
      paint,
    );

    // Right section
    canvas.drawArc(
      outerRect,
      -1.05,
      1.30,
      false,
      paint,
    );

    // Bottom section
    canvas.drawArc(
      outerRect,
      0.65,
      1.35,
      false,
      paint,
    );

    // Left section
    canvas.drawArc(
      outerRect,
      2.35,
      1.20,
      false,
      paint,
    );

    // ========================================================
    // INNER NORMAL CIRCLE
    // ========================================================

    final innerRadius =
        size.width * 0.19;

    canvas.drawCircle(
      center,
      innerRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _StatusIconPainter oldDelegate,
      ) {
    return false;
  }
}

// ============================================================================
// STATUS THUMBNAIL
// ============================================================================

class StatusThumbnail extends StatefulWidget {
  final Map<String, dynamic> status;

  final Uint8List? cachedBytes;

  final ValueChanged<Uint8List> onLoaded;

  final StatusService statusService;

  const StatusThumbnail({
    super.key,
    required this.status,
    required this.cachedBytes,
    required this.onLoaded,
    required this.statusService,
  });

  @override
  State<StatusThumbnail> createState() =>
      _StatusThumbnailState();
}

class _StatusThumbnailState
    extends State<StatusThumbnail> {
  Uint8List? _thumbnail;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _thumbnail = widget.cachedBytes;

    if (_thumbnail != null) {
      _loading = false;
    } else {
      _loadThumbnail();
    }
  }

  @override
  void didUpdateWidget(
      covariant StatusThumbnail oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    final oldUri =
    oldWidget.status['uri']?.toString();

    final newUri =
    widget.status['uri']?.toString();

    if (oldUri != newUri) {
      _thumbnail = widget.cachedBytes;

      _loading = _thumbnail == null;

      if (_thumbnail == null) {
        _loadThumbnail();
      }
    } else if (widget.cachedBytes != null &&
        widget.cachedBytes != _thumbnail) {
      setState(() {
        _thumbnail = widget.cachedBytes;
        _loading = false;
      });
    }
  }

  Future<void> _loadThumbnail() async {
    try {
      final uri =
      widget.status['uri']?.toString();

      if (uri == null || uri.isEmpty) {
        if (!mounted) return;

        setState(() {
          _loading = false;
        });

        return;
      }

      final bytes =
      await widget.statusService.getThumbnail(uri);

      if (!mounted) return;

      if (bytes != null && bytes.isNotEmpty) {
        widget.onLoaded(bytes);

        setState(() {
          _thumbnail = bytes;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(
        'Thumbnail error: $e',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnail != null) {
      return Image.memory(
        _thumbnail!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    if (_loading) {
      return Container(
        color: AppColors.surface,
      );
    }

    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.textSecondary,
          size: 36,
        ),
      ),
    );
  }
}