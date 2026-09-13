import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:status_saver/screens/status_view.dart';

import '../services/status_service.dart';
import '../theme/app_theme.dart';
import '../widgets/media_filter_bar.dart';
import '../widgets/status_icon.dart';
import '../widgets/status_thumbnail.dart';
import '../screens/settings.dart';
import '../widgets/status_access_setup.dart';


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
  // Images is the default .
  String _statusFilter = 'images';
  String _savedFilter = 'images';

  List<Map<String, dynamic>> _statuses = [];
  List<Map<String, dynamic>> _savedStatuses = [];

  bool _loadingStatuses = false;
  bool _loadingSaved = false;

  final Map<String, Uint8List> _thumbnailCache = {};

  // Statuses that the user has already opened inside Statusly.
  final Set<String> _openedStatusUris = {};

  // Statuses that have already been downloaded/saved.
  final Set<String> _downloadedStatusUris = {};

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
      final success = await StatusAccessSetup.show(
        context: context,
        statusService: _statusService,
        source: source,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        await _loadAppState();

        if (!mounted) {
          return;
        }

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
      if (!mounted) {
        return;
      }

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

      final downloadedUris =
      await _statusService.getDownloadedStatusUris(
        source,
      );

      if (!mounted) return;

      setState(() {
        _statuses = statuses;

        _openedStatusUris
          ..clear()
          ..addAll(openedUris);

        _downloadedStatusUris
          ..clear()
          ..addAll(downloadedUris);
      });
    } catch (e) {
      debugPrint(
        'Unable to load statuses: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingStatuses = false;
        });
      }
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
      if (mounted) {
        setState(() {
          _loadingSaved = false;
        });
      }
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
  // STATUS DOWNLOADED CHECK
  // ==========================================================================

  bool _isStatusDownloaded(
      Map<String, dynamic> status,
      ) {
    final uri =
        status['uri']?.toString() ?? '';

    if (uri.isEmpty) {
      return false;
    }

    return _downloadedStatusUris.contains(uri);
  }

  // ==========================================================================
  // MARK STATUS DOWNLOADED
  // ==========================================================================

  Future<void> _markStatusDownloaded(
      Map<String, dynamic> status,
      ) async {
    final source = _selectedSource;

    final uri =
        status['uri']?.toString() ?? '';

    if (source == null || uri.isEmpty) {
      return;
    }

    await _statusService.markStatusDownloaded(
      source: source,
      uri: uri,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _downloadedStatusUris.add(uri);
    });
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
            onSaved: () {
              _markStatusDownloaded(status);
            },
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
                          .withValues(alpha: 0.12),
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
                      .withValues(alpha: 0.10),
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
            color: Colors.white.withValues(alpha: 0.18),
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
    bool showStatusInstructions = false,
    bool showDownloadButton = true,
  }) {
    if (items.isEmpty) {
      if (loading) {
        return const SizedBox.expand();
      }

      return _buildEmptyMediaState(
        onRefresh: onRefresh,
        title: emptyTitle,
        message: emptyMessage,
        showStatusInstructions:
        showStatusInstructions,
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
            child: _buildMediaTile(
              status,
              showDownloadButton: showDownloadButton,
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // MEDIA TILE
  // ==========================================================================

  Widget _buildMediaTile(
      Map<String, dynamic> status, {
        bool showDownloadButton = true,
      }) {
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
                        .withValues(alpha: 0.55),
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
            // DOWNLOAD ARROW and check mark
            //
            // IMPORTANT:
            // This does NOT download the status.
            // It only opens the same StatusView as tapping the preview.
            // --------------------------------------------------------------

            if (showDownloadButton)
              Positioned(
                bottom: 10,
                right: 10,
                child: Material(
                  color: _isStatusDownloaded(status)
                      ? AppColors.primary
                      : AppColors.primaryDark,
                  shape: const CircleBorder(),
                  elevation: 3,
                  shadowColor: Colors.black.withValues(
                    alpha: 0.25,
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      _openStatus(status);
                    },
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(
                        _isStatusDownloaded(status)
                            ? Icons.check_rounded
                            : Icons.download_rounded,
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
    bool showStatusInstructions = false,
  }) {
    final isBusiness =
        _selectedSource == 'business';

    final whatsappName =
    isBusiness
        ? 'WhatsApp Business'
        : 'WhatsApp';

    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 32,
        ),
        children: [
          const SizedBox(
            height: 20,
          ),

          Icon(
            Icons.photo_library_outlined,
            size: 58,
            color: AppColors.primary,
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

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          if (showStatusInstructions) ...[
            const SizedBox(
              height: 28,
            ),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.divider,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to save a status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildInstructionStep(
                    number: '1',
                    title:
                    'View a status on $whatsappName',
                    description:
                    'Open $whatsappName and view the photo or video status you want to save.',
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildInstructionStep(
                    number: '2',
                    title:
                    'Open Save Statusly',
                    description:
                    'Return to Save Statusly after viewing the status.',
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildInstructionStep(
                    number: '3',
                    title:
                    'Save or download the status',
                    description:
                    'The viewed status will appear here. Open it and tap the Save or Download button.',
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(
                  Icons.open_in_new,
                ),
                label: Text(
                  'Open $whatsappName',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildInstructionStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
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
              return _loadStatuses(source);
            },
            emptyTitle: showingVideos
                ? 'No videos found'
                : 'No images found',
            emptyMessage: showingVideos
                ? 'Video statuses will appear here.'
                : 'Image statuses will appear here.',
            showStatusInstructions: true,
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
            showDownloadButton: false,
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
                size: 37,
              ),
              selectedIcon: const Icon(
                Icons.download,
                size: 37,
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