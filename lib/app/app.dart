import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view.dart';

class StatusSaverApp extends StatelessWidget {
  const StatusSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Status',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const StatusHomePage(),
    );
  }
}

// ============================================================================
// STATUS HOME PAGE
// ============================================================================

class StatusHomePage extends StatefulWidget {
  const StatusHomePage({super.key});

  @override
  State<StatusHomePage> createState() =>
      _StatusHomePageState();
}

class _StatusHomePageState
    extends State<StatusHomePage> {
  static const MethodChannel _channel =
  MethodChannel(
    'com.example.status_saver/status',
  );

  // ==========================================================================
  // APP STATE
  // ==========================================================================

  bool _loading = true;

  bool _whatsappInstalled = false;
  bool _businessInstalled = false;

  bool _whatsappConfigured = false;
  bool _businessConfigured = false;

  String? _lastSelectedSource;
  String? _selectedSource;

  // 0 = Statuses
  // 1 = Saved
  int _currentTab = 0;

  String _statusFilter = 'all';
  String _savedFilter = 'all';

  List<Map<String, dynamic>> _statuses = [];

  List<Map<String, dynamic>> _savedStatuses = [];

  bool _loadingStatuses = false;
  bool _loadingSaved = false;

  final Map<String, Uint8List> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();

    _loadAppState();
    _loadSavedStatuses();
  }

  // ==========================================================================
  // LOAD APP STATE
  // ==========================================================================

  Future<void> _loadAppState() async {
    try {
      final result =
      await _channel.invokeMethod(
        'getAppState',
      );

      if (result == null) {
        return;
      }

      final data =
      Map<String, dynamic>.from(result);

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
        data['lastSelectedSource'];
      });

      _selectInitialSource();
    } catch (e) {
      debugPrint(
        'Unable to load app state: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ==========================================================================
  // SELECT INITIAL SOURCE
  // ==========================================================================

  void _selectInitialSource() {
    final installedSources =
        _installedSources;

    if (installedSources.isEmpty) {
      if (mounted) {
        setState(() {
          _selectedSource = null;
        });
      }

      return;
    }

    if (_lastSelectedSource != null &&
        installedSources.contains(
          _lastSelectedSource,
        ) &&
        _isConfigured(
          _lastSelectedSource!,
        )) {
      if (mounted) {
        setState(() {
          _selectedSource =
              _lastSelectedSource;
        });
      }

      _loadStatuses(
        _lastSelectedSource!,
      );

      return;
    }

    for (final source
    in installedSources) {
      if (_isConfigured(source)) {
        if (mounted) {
          setState(() {
            _selectedSource = source;
          });
        }

        _loadStatuses(source);

        return;
      }
    }

    if (mounted) {
      setState(() {
        _selectedSource =
            installedSources.first;
      });
    }
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

  bool _isConfigured(
      String source,
      ) {
    if (source == 'business') {
      return _businessConfigured;
    }

    return _whatsappConfigured;
  }

  String _sourceName(
      String source,
      ) {
    if (source == 'business') {
      return 'WhatsApp Business';
    }

    return 'WhatsApp';
  }

  // ==========================================================================
  // SETUP SOURCE
  // ==========================================================================

  Future<void> _setupSource(
      String source,
      ) async {
    try {
      final success =
      await _channel.invokeMethod<bool>(
        'selectStatusFolder',
        {
          'source': source,
        },
      );

      if (success == true) {
        await _loadAppState();

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                '${_sourceName(source)} status access is ready.',
              ),
              behavior:
              SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select the .Statuses folder.',
              ),
              behavior:
              SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to set up status access: $e',
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ==========================================================================
  // LOAD DETECTED STATUSES
  // ==========================================================================

  Future<void> _loadStatuses(
      String source,
      ) async {
    if (!_isConfigured(source)) {
      return;
    }

    if (mounted) {
      setState(() {
        _loadingStatuses = true;
      });
    }

    try {
      final result =
      await _channel.invokeMethod(
        'getStatuses',
        {
          'source': source,
        },
      );

      final statuses =
      <Map<String, dynamic>>[];

      if (result is List) {
        for (final item in result) {
          statuses.add(
            Map<String, dynamic>.from(
              item,
            ),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _statuses = statuses;
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
      final result =
      await _channel.invokeMethod(
        'getSavedStatuses',
      );

      final saved =
      <Map<String, dynamic>>[];

      if (result is List) {
        for (final item in result) {
          saved.add(
            Map<String, dynamic>.from(
              item,
            ),
          );
        }
      }

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

  Future<void> _selectSource(
      String source,
      ) async {
    if (!_isConfigured(source)) {
      await _setupSource(source);
      return;
    }

    if (mounted) {
      setState(() {
        _selectedSource = source;
        _statusFilter = 'all';
      });
    }

    try {
      await _channel.invokeMethod(
        'setLastSelectedSource',
        {
          'source': source,
        },
      );
    } catch (e) {
      debugPrint(
        'Unable to save selected source: $e',
      );
    }

    await _loadStatuses(source);
  }

  // ==========================================================================
  // BOTTOM NAVIGATION
  // ==========================================================================

  void _changeTab(
      int index,
      ) {
    if (!mounted) return;

    setState(() {
      _currentTab = index;
    });

    if (index == 0) {
      if (_selectedSource != null &&
          _isConfigured(
            _selectedSource!,
          )) {
        _loadStatuses(
          _selectedSource!,
        );
      }
    } else {
      _loadSavedStatuses();
    }
  }

  // ==========================================================================
  // FILTER
  // ==========================================================================

  List<Map<String, dynamic>>
  _filterMedia(
      List<Map<String, dynamic>> items,
      String filter,
      ) {
    if (filter == 'all') {
      return items;
    }

    return items.where((status) {
      final mime =
      (status['mimeType'] ?? '')
          .toString()
          .toLowerCase();

      if (filter == 'photos') {
        return mime.startsWith('image/');
      }

      if (filter == 'videos') {
        return mime.startsWith('video/');
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>>
  get _filteredStatuses {
    return _filterMedia(
      _statuses,
      _statusFilter,
    );
  }

  List<Map<String, dynamic>>
  get _filteredSavedStatuses {
    return _filterMedia(
      _savedStatuses,
      _savedFilter,
    );
  }

  // ==========================================================================
  // VIDEO CHECK
  // ==========================================================================

  bool _isVideo(
      Map<String, dynamic> status,
      ) {
    final mime =
    (status['mimeType'] ?? '')
        .toString()
        .toLowerCase();

    if (mime.startsWith('video/')) {
      return true;
    }

    final name =
    (status['name'] ?? '')
        .toString()
        .toLowerCase();

    return name.endsWith('.mp4') ||
        name.endsWith('.3gp') ||
        name.endsWith('.mkv') ||
        name.endsWith('.webm') ||
        name.endsWith('.mov');
  }

  // ==========================================================================
  // OPEN STATUS
  // ==========================================================================

  Future<void> _openStatus(
      Map<String, dynamic> status,
      ) async {
    try {
      final path =
      await _channel.invokeMethod<String>(
        'prepareStatus',
        {
          'uri': status['uri'],
          'name': status['name'],
        },
      );

      if (path == null ||
          path.isEmpty) {
        throw Exception(
          'Unable to prepare status',
        );
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

      // Refresh saved media after returning.
      await _loadSavedStatuses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to open status: $e',
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ==========================================================================
  // THUMBNAIL CACHE
  // ==========================================================================

  void _cacheThumbnail(
      String uri,
      Uint8List bytes,
      ) {
    if (_thumbnailCache.length >= 100) {
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
    final installed =
        _installedSources;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
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
                    decoration:
                    BoxDecoration(
                      color: Colors.green
                          .withOpacity(0.12),
                      shape:
                      BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .download_rounded,
                      size: 36,
                      color:
                      Colors.green,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Save Status',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(
                  'Save photos and videos from your WhatsApp statuses.',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color:
                    Colors.black54,
                  ),
                ),

                const SizedBox(
                  height: 36,
                ),

                if (installed.isEmpty)
                  _buildNoWhatsAppCard(),

                for (final source
                in installed)
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                      bottom: 14,
                    ),
                    child:
                    _buildSetupCard(
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

  Widget _buildSetupCard(
      String source,
      ) {
    final configured =
    _isConfigured(source);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
        side: BorderSide(
          color:
          Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),
        onTap: () {
          if (configured) {
            _selectSource(source);
          } else {
            _setupSource(source);
          }
        },
        child: Padding(
          padding:
          const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                BoxDecoration(
                  color: Colors.green
                      .withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  color:
                  Colors.green,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      _sourceName(
                        source,
                      ),
                      style:
                      const TextStyle(
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
                            ? Colors.green
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                configured
                    ? Icons
                    .check_circle
                    : Icons
                    .chevron_right,
                color: configured
                    ? Colors.green
                    : Colors.black45,
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
        padding:
        const EdgeInsets.all(24),
        child: Column(
          children: const [
            Icon(
              Icons
                  .chat_bubble_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'WhatsApp not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Install WhatsApp or WhatsApp Business to use Status Saver.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                Colors.black54,
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
    final source =
        _selectedSource;

    if (source == null) {
      return const SizedBox.shrink();
    }

    if (_installedSources.length ==
        1) {
      return Padding(
        padding:
        const EdgeInsets.only(
          right: 12,
        ),
        child: Center(
          child: Text(
            _sourceName(source),
            style:
            const TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding:
      const EdgeInsets.only(
        right: 8,
      ),
      child:
      PopupMenuButton<String>(
        onSelected:
        _selectSource,
        itemBuilder: (context) {
          return _installedSources
              .map(
                (item) {
              final configured =
              _isConfigured(item);

              final selected =
                  item ==
                      _selectedSource;

              return PopupMenuItem<
                  String>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      configured
                          ? Icons
                          .chat_rounded
                          : Icons
                          .settings_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        _sourceName(
                          item,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check,
                        size: 20,
                        color:
                        Colors.green,
                      ),
                  ],
                ),
              );
            },
          ).toList();
        },
        child: Container(
          padding:
          const EdgeInsets
              .symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration:
          BoxDecoration(
            borderRadius:
            BorderRadius.circular(
              10,
            ),
            color:
            Colors.grey.shade100,
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Text(
                _sourceName(source),
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(
                Icons
                    .keyboard_arrow_down,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // FILTER BAR
  // ==========================================================================

  Widget _buildFilterBar({
    required String selectedFilter,
    required ValueChanged<String>
    onChanged,
  }) {
    final filters = [
      ('all', 'All'),
      ('photos', 'Photos'),
      ('videos', 'Videos'),
    ];

    return SingleChildScrollView(
      scrollDirection:
      Axis.horizontal,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: filters.map(
              (item) {
            final selected =
                selectedFilter ==
                    item.$1;

            return Padding(
              padding:
              const EdgeInsets
                  .only(
                right: 8,
              ),
              child: ChoiceChip(
                label:
                Text(item.$2),
                selected:
                selected,
                onSelected: (_) {
                  onChanged(
                    item.$1,
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ==========================================================================
  // MEDIA GRID
  // ==========================================================================

  Widget _buildMediaGrid({
    required List<
        Map<String, dynamic>>
    items,
    required bool loading,
    required Future<void>
    Function() onRefresh,
    required String emptyTitle,
    required String emptyMessage,
  }) {
    if (loading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    if (items.isEmpty) {
      return _buildEmptyMediaState(
        onRefresh: onRefresh,
        title: emptyTitle,
        message: emptyMessage,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding:
        const EdgeInsets.fromLTRB(
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
          childAspectRatio: 0.78,
        ),
        itemCount: items.length,
        itemBuilder:
            (context, index) {
          final status =
          items[index];

          final uri =
              status['uri']
                  ?.toString() ??
                  'status_$index';

          return KeyedSubtree(
            key: ValueKey(uri),
            child:
            _buildMediaTile(
              status,
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
      Map<String, dynamic> status,
      ) {
    final uri =
        status['uri']
            ?.toString() ??
            '';

    final isVideo =
    _isVideo(status);

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
            StatusThumbnail(
              status: status,
              cachedBytes:
              _thumbnailCache[uri],
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
                        .withOpacity(
                      0.55,
                    ),
                    shape:
                    BoxShape.circle,
                  ),
                  child:
                  const Icon(
                    Icons.play_arrow,
                    color:
                    Colors.white,
                    size: 30,
                  ),
                ),
              ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets
                    .fromLTRB(
                  10,
                  22,
                  10,
                  10,
                ),
                decoration:
                const BoxDecoration(
                  gradient:
                  LinearGradient(
                    begin:
                    Alignment
                        .topCenter,
                    end:
                    Alignment
                        .bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
                child: Text(
                  status['name']
                      ?.toString() ??
                      'Status',
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontSize: 12,
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
    required Future<void>
    Function() onRefresh,
    required String title,
    required String message,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
            MediaQuery.of(context)
                .size
                .height *
                0.28,
          ),
          Icon(
            Icons
                .photo_library_outlined,
            size: 60,
            color:
            Colors.grey.shade400,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              fontSize: 19,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding:
            const EdgeInsets
                .symmetric(
              horizontal: 40,
            ),
            child: Text(
              message,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                color:
                Colors.black54,
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
    final source =
        _selectedSource;

    if (source == null ||
        !_isConfigured(source)) {
      return _buildSetupContent();
    }

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),

        _buildFilterBar(
          selectedFilter:
          _statusFilter,
          onChanged: (value) {
            setState(() {
              _statusFilter =
                  value;
            });
          },
        ),

        const SizedBox(
          height: 4,
        ),

        Expanded(
          child:
          _buildMediaGrid(
            items:
            _filteredStatuses,
            loading:
            _loadingStatuses,
            onRefresh: () {
              if (_selectedSource ==
                  null) {
                return Future.value();
              }

              return _loadStatuses(
                _selectedSource!,
              );
            },
            emptyTitle:
            _statusFilter ==
                'photos'
                ? 'No photos found'
                : _statusFilter ==
                'videos'
                ? 'No videos found'
                : 'No statuses found',
            emptyMessage:
            _statusFilter ==
                'photos'
                ? 'Photo statuses will appear here.'
                : _statusFilter ==
                'videos'
                ? 'Video statuses will appear here.'
                : 'When someone posts a photo or video status, it will appear here.',
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SAVED TAB
  // ==========================================================================

  Widget _buildSavedTab() {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),

        _buildFilterBar(
          selectedFilter:
          _savedFilter,
          onChanged: (value) {
            setState(() {
              _savedFilter =
                  value;
            });
          },
        ),

        const SizedBox(
          height: 4,
        ),

        Expanded(
          child:
          _buildMediaGrid(
            items:
            _filteredSavedStatuses,
            loading:
            _loadingSaved,
            onRefresh:
            _loadSavedStatuses,
            emptyTitle:
            _savedFilter ==
                'photos'
                ? 'No saved photos'
                : _savedFilter ==
                'videos'
                ? 'No saved videos'
                : 'No saved statuses',
            emptyMessage:
            _savedFilter ==
                'photos'
                ? 'Photos you save will appear here.'
                : _savedFilter ==
                'videos'
                ? 'Videos you save will appear here.'
                : 'Statuses you download will appear here.',
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    final showingStatuses =
        _currentTab == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          showingStatuses
              ? 'Statuses'
              : 'Saved',
          style:
          const TextStyle(
            fontWeight:
            FontWeight.w700,
          ),
        ),
        actions: [
          if (showingStatuses)
            _buildSourceSelector(),
        ],
      ),

      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildStatusesTab(),
          _buildSavedTab(),
        ],
      ),

      bottomNavigationBar:
      NavigationBar(
        selectedIndex:
        _currentTab,
        onDestinationSelected:
        _changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons
                  .photo_library_outlined,
            ),
            selectedIcon: Icon(
              Icons.photo_library,
            ),
            label: 'Statuses',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.download_outlined,
            ),
            selectedIcon: Icon(
              Icons.download,
            ),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STATUS THUMBNAIL
// ============================================================================

class StatusThumbnail
    extends StatefulWidget {
  final Map<String, dynamic> status;
  final Uint8List? cachedBytes;
  final ValueChanged<Uint8List>
  onLoaded;

  const StatusThumbnail({
    super.key,
    required this.status,
    required this.cachedBytes,
    required this.onLoaded,
  });

  @override
  State<StatusThumbnail>
  createState() =>
      _StatusThumbnailState();
}

class _StatusThumbnailState
    extends State<StatusThumbnail> {
  static const MethodChannel
  _channel =
  MethodChannel(
    'com.example.status_saver/status',
  );

  Uint8List? _thumbnail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _thumbnail =
        widget.cachedBytes;

    if (_thumbnail != null) {
      _loading = false;
    } else {
      _loadThumbnail();
    }
  }

  @override
  void didUpdateWidget(
      covariant StatusThumbnail
      oldWidget,
      ) {
    super.didUpdateWidget(
      oldWidget,
    );

    final oldUri =
    oldWidget.status['uri']
        ?.toString();

    final newUri =
    widget.status['uri']
        ?.toString();

    if (oldUri != newUri) {
      _thumbnail =
          widget.cachedBytes;

      _loading =
          _thumbnail == null;

      if (_thumbnail == null) {
        _loadThumbnail();
      }
    }
  }

  Future<void>
  _loadThumbnail() async {
    try {
      final bytes =
      await _channel
          .invokeMethod<
          Uint8List>(
        'getThumbnail',
        {
          'uri':
          widget.status['uri'],
        },
      );

      if (!mounted) return;

      if (bytes != null) {
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

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    if (_thumbnail != null) {
      return Image.memory(
        _thumbnail!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: _loading
            ? const SizedBox(
          width: 28,
          height: 28,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : Icon(
          Icons
              .broken_image_outlined,
          color:
          Colors.grey.shade500,
          size: 36,
        ),
      ),
    );
  }
}