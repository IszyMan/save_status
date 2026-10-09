import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:status_saver/screens/status_view.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/status_service.dart';
import '../theme/app_theme.dart';
import '../widgets/media_filter_bar.dart';
import '../widgets/status_icon.dart';
import '../widgets/status_thumbnail.dart';
import '../screens/settings.dart';
import '../widgets/status_access_setup.dart';
import 'status_source_setup_screen.dart';

// ============================================================================
// STATUS HOME PAGE
// ============================================================================

class StatusHomePage extends StatefulWidget {
  final ValueChanged<Locale> onLanguageChanged;

  const StatusHomePage({
    super.key,
    required this.onLanguageChanged,
  });

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


  bool _loadingAppState = true;

  // 0 = Statuses
  // 1 = Saved
  // 2 = Settings
  int _currentTab = 0;
  final PageController _pageController = PageController();



  // Five swipe pages:
  // 0: Status photos
  // 1: Status videos
  // 2: Saved photos
  // 3: Saved videos
  // 4: Settings
  int _currentPage = 0;

  // Only two filters.
  // Images is the default.
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
        _whatsappInstalled =
            data['whatsappInstalled'] == true;

        _businessInstalled =
            data['businessInstalled'] == true;

        _whatsappConfigured =
            data['whatsappConfigured'] == true;

        _businessConfigured =
            data['businessConfigured'] == true;

        _lastSelectedSource =
            data['lastSelectedSource']?.toString();
      });

      await _selectInitialSource();
    } catch (e) {
      debugPrint('Unable to load app state: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingAppState = false;
        });
      }
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

    if (_whatsappInstalled && _whatsappConfigured) {
      sources.add('whatsapp');
    }

    if (_businessInstalled && _businessConfigured) {
      sources.add('business');
    }

    return sources;
  }

  // ==========================================================================
  // OPEN WHATSAPP
  // ==========================================================================

  Future<void> _openWhatsApp() async {
    final l10n = AppLocalizations.of(context)!;

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
              l10n.sourceNotInstalled(
                _sourceName(source),
              ),
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
        SnackBar(
          content: Text(
            l10n.unableToOpenWhatsApp,
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
    final l10n = AppLocalizations.of(context)!;

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
              l10n.sourceStatusAccessReady(
                _sourceName(source),
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.pleaseSelectStatusesFolder,
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
            l10n.unableToSetUpStatusAccess(
              e.toString(),
            ),
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

  Future<void> _goToPage(int page) async {
    if (!mounted || !_pageController.hasClients) return;
    if (page < 0 || page > 4) return;

    final actualPage =
        _pageController.page ?? _currentPage.toDouble();

    if ((actualPage - page).abs() < 0.01) return;

    if ((actualPage - page).abs() > 1.01) {
      _pageController.jumpToPage(page);
    } else {
      await _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onSwipePageChanged(int page) {
    if (!mounted) return;

    setState(() {
      _currentPage = page;

      if (page <= 1) {
        _currentTab = 0;
        _statusFilter = page == 0 ? 'images' : 'videos';
      } else if (page <= 3) {
        _currentTab = 1;
        _savedFilter = page == 2 ? 'images' : 'videos';
      } else {
        _currentTab = 2;
      }
    });
  }

  Future<void> _changeTab(int index) async {
    switch (index) {
      case 0:
        await _goToPage(
          _statusFilter == 'videos' ? 1 : 0,
        );
        break;

      case 1:
        await _goToPage(
          _savedFilter == 'videos' ? 3 : 2,
        );
        break;

      case 2:
        await _goToPage(4);
        break;
    }
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
      Map<String, dynamic> status,{
        bool isSavedItem = false,
    }) async {
    final l10n = AppLocalizations.of(context)!;

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
            isSavedItem: isSavedItem,
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
            l10n.unableToOpenStatus(
              e.toString(),
            ),
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
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: FilledButton.icon(
        icon: const Icon(Icons.folder_open),
        label: Text(l10n.setUpStatusAccess),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (setupContext) =>
                  StatusSourceSetupScreen(
                    onComplete: () {
                      Navigator.of(setupContext).pop();
                    },
                  ),
            ),
          );

          if (!mounted) return;

          await _loadAppState();
        },
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

    // Only one source is configured.
    if (configuredSources.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 4,
        ),
        child: Center(
          child: Text(
            source == 'business' ? 'Business' : 'WhatsApp',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // Both WhatsApp and WhatsApp Business are configured.
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
                        item == 'business' ? 'Business' : 'WhatsApp',
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
            color: Colors.white.withValues(
              alpha: 0.18,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                source == 'business' ? 'Business' : 'WhatsApp',
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



  Widget _buildRefreshButton() {
    final source = _selectedSource;

    if (source == null ||
        !_isConfigured(source)) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: _loadingStatuses
          ? null
          : () {
        _loadStatuses(source);
      },
      icon: _loadingStatuses
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor:
          AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      )
          : const Icon(
        Icons.refresh,
        color: Colors.white,
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
    bool isSavedItem = false,
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
              isSavedItem: isSavedItem,
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
        bool isSavedItem = false,
      }) {
    final uri =
        status['uri']?.toString() ?? '';

    final isVideo = _isVideo(status);

    return GestureDetector(
      onTap: () {
        _openStatus(
          status,
          isSavedItem: isSavedItem,
        );
      },
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
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
                      _openStatus(
                        status,
                        isSavedItem: isSavedItem,
                      );
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
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                    l10n.howToSaveAStatus,
                    style: const TextStyle(
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
                    title: l10n.viewAStatusOn(
                      whatsappName,
                    ),
                    description:l10n.openSourceAndViewStatus(
                      whatsappName,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildInstructionStep(
                    number: '2',
                    title: l10n.openSaveStatusly,
                    description:
                    l10n.returnToSaveStatuslyAfterViewing,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildInstructionStep(
                    number: '3',
                    title: l10n.saveOrDownloadTheStatus,
                    description:
                    l10n.viewedStatusWillAppearHere,
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
                  l10n.openSource(
                    whatsappName,
                  ),
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

  Widget _buildStatusesTab(String filter) {
    final l10n = AppLocalizations.of(context)!;

    if (_loadingAppState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final source = _selectedSource;

    if (source == null || !_isConfigured(source)) {
      return _buildSetupContent();
    }

    final showingVideos = filter == 'videos';

    return _buildMediaGrid(
      items: _filterMedia(_statuses, filter),
      loading: _loadingStatuses,
      onRefresh: () => _loadStatuses(source),
      emptyTitle: showingVideos
          ? l10n.noVideosFound
          : l10n.noImagesFound,
      emptyMessage: showingVideos
          ? l10n.videoStatusesWillAppearHere
          : l10n.imageStatusesWillAppearHere,
      showStatusInstructions: true,
    );
  }

  // ==========================================================================
  // SAVED TAB
  // ==========================================================================

  Widget _buildSavedTab(String filter) {
    final l10n = AppLocalizations.of(context)!;
    final showingVideos = filter == 'videos';

    return _buildMediaGrid(
      items: _filterMedia(_savedStatuses, filter),
      loading: _loadingSaved,
      onRefresh: _loadSavedStatuses,
      emptyTitle: showingVideos
          ? l10n.noSavedVideos
          : l10n.noSavedImages,
      emptyMessage: showingVideos
          ? l10n.videosYouSaveWillAppearHere
          : l10n.imagesYouSaveWillAppearHere,
      showDownloadButton: false,
      isSavedItem: true,
    );
  }

  // ==========================================================================
  // CONFIRM EXIT
  // ==========================================================================

  Future<bool> _confirmExit() async {
    final l10n = AppLocalizations.of(context)!;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.exitStatusly,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            l10n.areYouSureYouWantToCloseTheApp,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                l10n.cancel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                l10n.exit,
              ),
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
    final l10n = AppLocalizations.of(context)!;

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

        final shouldExit =
        await _confirmExit();

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
                ? l10n.saved
                : l10n.settings,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            if (showingStatuses) ...[
              _buildSourceSelector(),

              _buildRefreshButton(),
            ],

            IconButton(
              tooltip: l10n.openWhatsAppTooltip,
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

        body: Column(
          children: [
            // Fixed Photos / Videos tabs.
            // Hidden on Settings and while Statuses needs setup.
            if (
            _currentTab == 1 ||
                (
                    _currentTab == 0 &&
                        !_loadingAppState &&
                        _selectedSource != null &&
                        _isConfigured(_selectedSource!)
                )
            ) ...[
              const SizedBox(height: 8),

              MediaFilterBar(
                selectedFilter: _currentTab == 0
                    ? _statusFilter
                    : _savedFilter,
                onChanged: (value) {
                  final showingVideos = value == 'videos';

                  if (_currentTab == 0) {
                    _goToPage(showingVideos ? 1 : 0);
                  } else {
                    _goToPage(showingVideos ? 3 : 2);
                  }
                },
                imagesCount: _currentTab == 0
                    ? _filterMedia(
                  _statuses.where(_isStatusNew).toList(),
                  'images',
                ).length
                    : _filterMedia(
                  _savedStatuses,
                  'images',
                ).length,
                videosCount: _currentTab == 0
                    ? _filterMedia(
                  _statuses.where(_isStatusNew).toList(),
                  'videos',
                ).length
                    : _filterMedia(
                  _savedStatuses,
                  'videos',
                ).length,
              ),

              const SizedBox(height: 4),
            ],

            // Only the content below the tabs moves horizontally.
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const PageScrollPhysics(),
                onPageChanged: _onSwipePageChanged,
                children: [
                  _buildStatusesTab('images'),
                  _buildStatusesTab('videos'),

                  _buildSavedTab('images'),
                  _buildSavedTab('videos'),

                  SettingsScreen(
                    statusService: _statusService,
                    whatsappInstalled: _whatsappInstalled,
                    businessInstalled: _businessInstalled,
                    whatsappConfigured: _whatsappConfigured,
                    businessConfigured: _businessConfigured,
                    onSelectSource: _handleSettingsSource,
                    onOpenWhatsApp: _openWhatsApp,
                    onLanguageChanged: widget.onLanguageChanged,
                  ),
                ],
              ),
            ),
          ],
        ),

        // ======================================================================
        // BOTTOM NAVIGATION
        // ======================================================================

        bottomNavigationBar:
        NavigationBar(
          selectedIndex: _currentTab,
          onDestinationSelected:
          _changeTab,
          destinations: [
            NavigationDestination(
              icon: const StatusIcon(),
              selectedIcon: const StatusIcon(
                selected: true,
              ),
              label: l10n.statuses,
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
              label: l10n.saved,
            ),

            NavigationDestination(
              icon: const Icon(
                Icons.settings_outlined,
              ),
              selectedIcon: const Icon(
                Icons.settings,
              ),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}