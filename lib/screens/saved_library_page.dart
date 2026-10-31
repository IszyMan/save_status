import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/saved_folder_store.dart';
import '../services/status_service.dart';
import '../widgets/saved_folder_picker.dart';
import '../widgets/status_thumbnail.dart';
import 'status_view.dart';

class SavedLibraryPage extends StatefulWidget {
  final String filter;
  final String? folderId;
  final bool unfiled;
  final Future<void> Function()? onMediaChanged;

  const SavedLibraryPage({
    super.key,
    required this.filter,
    this.folderId,
    this.unfiled = false,
    this.onMediaChanged,
  });

  static final _refreshers = <VoidCallback>{};
  static final _dismissers = <bool Function()>{};

  static void refreshMedia() {
    for (final refresh in _refreshers.toList()) {
      refresh();
    }
  }

  static bool dismissSelection() {
    var dismissed = false;

    for (final callback in _dismissers.toList()) {
      if (callback()) {
        dismissed = true;
      }
    }

    return dismissed;
  }

  @override
  State<SavedLibraryPage> createState() => _SavedLibraryPageState();
}

class _SavedLibraryPageState extends State<SavedLibraryPage>
    with WidgetsBindingObserver {
  final _service = StatusService();
  final _store = SavedFolderStore.instance;

  final _selected = <String>{};
  final _thumbnails = <String, Uint8List>{};

  List<Map<String, dynamic>> _items = [];

  bool _loading = true;
  bool _selecting = false;
  bool _busy = false;

  String? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _store.addListener(_foldersChanged);

    SavedLibraryPage._dismissers.add(_dismissSelection);
    SavedLibraryPage._refreshers.add(_refreshMedia);

    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _store.removeListener(_foldersChanged);

    SavedLibraryPage._dismissers.remove(_dismissSelection);
    SavedLibraryPage._refreshers.remove(_refreshMedia);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    }
  }

  void _refreshMedia() {
    if (mounted) {
      _load();
    }
  }

  bool _dismissSelection() {
    if (!_selecting || !mounted) return false;

    _clearSelection();
    return true;
  }

  void _foldersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;

    try {
      await _store.initialize();

      final items = await _service.getSavedStatuses();

      items.sort((a, b) {
        final aTime = int.tryParse(a['lastModified']?.toString() ?? '') ?? 0;

        final bTime = int.tryParse(b['lastModified']?.toString() ?? '') ?? 0;

        return bTime.compareTo(aTime);
      });

      if (!mounted || generation != _generation) return;

      setState(() {
        _items = items;

        final existing = items.map(_uri).toSet();

        _selected.removeWhere((uri) => !existing.contains(uri));

        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted || generation != _generation) return;

      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)!.folderLoadFailed;
      });
    }
  }

  String _uri(Map<String, dynamic> item) {
    return item['uri']?.toString() ?? '';
  }

  bool _isVideo(Map<String, dynamic> item) {
    final mime = item['mimeType']?.toString().toLowerCase();

    if (mime?.startsWith('video/') == true) {
      return true;
    }

    return RegExp(
      r'\.(mp4|3gp|mkv|webm|mov)$',
      caseSensitive: false,
    ).hasMatch(item['name']?.toString() ?? '');
  }

  List<Map<String, dynamic>> get _visibleItems {
    return _items.where((item) {
      final folderId = _store.folderFor(_uri(item));

      if (widget.folderId != null && folderId != widget.folderId) {
        return false;
      }

      if (widget.unfiled && folderId != null) {
        return false;
      }

      if (widget.filter == 'images') {
        return !_isVideo(item);
      }

      if (widget.filter == 'videos') {
        return _isVideo(item);
      }

      return true;
    }).toList();
  }

  void _toggleSelection(String uri) {
    if (uri.isEmpty || _busy) return;

    setState(() {
      _selecting = true;

      if (!_selected.add(uri)) {
        _selected.remove(uri);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selected.clear();
      _selecting = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openItem(Map<String, dynamic> item) async {
    if (_selecting) {
      _toggleSelection(_uri(item));
      return;
    }

    try {
      final path = await _service.prepareStatus(
        uri: _uri(item),
        name: item['name']?.toString() ?? 'status',
      );

      if (!mounted) return;

      if (path == null || path.isEmpty) {
        throw StateError('Unable to prepare saved media.');
      }

      final deleted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => StatusView(
            filePath: path,
            status: item,
            isVideo: _isVideo(item),
            isSavedItem: true,
            source: 'whatsapp',
          ),
        ),
      );

      if (deleted == true) {
        await _store.forget(_uri(item));
      }

      await _load();
      await widget.onMediaChanged?.call();
    } catch (_) {
      if (!mounted) return;

      _showMessage(AppLocalizations.of(context)!.folderOpenFailed);
    }
  }

  Future<void> _moveItems(List<String> uris) async {
    if (_busy || uris.isEmpty) return;

    setState(() {
      _busy = true;
    });

    try {
      final folderName = await showSavedFolderPicker(
        context,
        uris: uris,
        savedItems: _items,
      );

      if (!mounted) return;

      if (folderName != null) {
        _clearSelection();

        _showMessage(
          AppLocalizations.of(context)!.folderMovedSuccess(
            uris.length,
            folderName,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _createFolder() async {
    await showFolderNameDialog(context);
  }

  Future<void> _manageFolder(SavedFolder folder, String action) async {
    final l10n = AppLocalizations.of(context)!;

    if (action == 'rename') {
      await showFolderNameDialog(context, folder: folder);

      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.folderDeleteTitle(folder.name)),
          content: Text(l10n.folderDeleteExplanation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                l10n.delete,
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _store.delete(folder.id);
    } catch (_) {
      if (!mounted) return;

      _showMessage(l10n.folderOperationFailed);
    }
  }

  Future<void> _openFolder({SavedFolder? folder, bool unfiled = false}) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (routeContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                folder?.name ??
                    AppLocalizations.of(routeContext)!.folderNoFolder,
              ),
            ),
            body: SavedLibraryPage(
              filter: 'all',
              folderId: folder?.id,
              unfiled: unfiled,
              onMediaChanged: widget.onMediaChanged,
            ),
          );
        },
      ),
    );

    await _load();
  }

  Widget _buildMediaTile(Map<String, dynamic> item) {
    final uri = _uri(item);
    final selected = _selected.contains(uri);

    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      selected: selected,
      label:
          '${_isVideo(item) ? l10n.videos : l10n.images}: '
          '${item['name']}',
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openItem(item),
          onLongPress: () => _toggleSelection(uri),
          child: Stack(
            fit: StackFit.expand,
            children: [
              StatusThumbnail(
                status: item,
                cachedBytes: _thumbnails[uri],
                statusService: _service,
                onLoaded: (bytes) {
                  if (_thumbnails.length >= 80) {
                    _thumbnails.remove(_thumbnails.keys.first);
                  }

                  _thumbnails[uri] = bytes;
                },
              ),
              if (_isVideo(item))
                const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                ),
              if (_selecting)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? colors.primary : Colors.white,
                    shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              if (!_selecting)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: PopupMenuButton<String>(
                      tooltip: l10n.folderOptions,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (action) {
                        if (action == 'move') {
                          _moveItems([uri]);
                        } else {
                          _toggleSelection(uri);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'move',
                          child: Text(l10n.folderMoveTo),
                        ),
                        PopupMenuItem(
                          value: 'select',
                          child: Text(l10n.folderSelect),
                        ),
                      ],
                    ),
                  ),
                ),
              if (selected)
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.primary, width: 4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolderCard(SavedFolder folder) {
    final l10n = AppLocalizations.of(context)!;

    final count = _items.where((item) {
      return _store.folderFor(_uri(item)) == folder.id;
    }).length;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFolder(folder: folder),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.folder_rounded,
                    size: 42,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    tooltip: l10n.folderOptions,
                    onSelected: (action) {
                      _manageFolder(folder, action);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Text(l10n.folderRename),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.folderDelete),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                folder.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.folderItemCount(count),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolders() {
    final l10n = AppLocalizations.of(context)!;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final newFolderColor = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF075E54);

    final unfiledCount = _items.where((item) {
      return _store.folderFor(_uri(item)) == null;
    }).length;

    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: _createFolder,
                    icon: const Icon(
                      Icons.create_new_folder_outlined,
                    ),
                    label: Text(l10n.folderNew),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: newFolderColor,
                      backgroundColor: newFolderColor.withValues(
                        alpha: 0.06,
                      ),
                      side: BorderSide(
                        color: newFolderColor.withValues(alpha: 0.45),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_store.folders.isEmpty)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.photo_library_outlined,
                      ),
                      title: Text(l10n.folderNoFolder),
                      subtitle: Text(
                        l10n.folderItemCount(unfiledCount),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () => _openFolder(unfiled: true),
                    ),
                  if (_store.folders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        l10n.folderEmptyList,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisExtent: 166,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildFolderCard(_store.folders[index]);
              }, childCount: _store.folders.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBar(List<Map<String, dynamic>> items) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            tooltip: l10n.cancel,
            onPressed: _busy ? null : _clearSelection,
            icon: const Icon(Icons.close),
          ),
          Text(l10n.folderSelectedCount(_selected.length)),
          TextButton(
            onPressed: _busy
                ? null
                : () {
                    setState(() {
                      _selected.addAll(
                        items.map(_uri).where((uri) => uri.isNotEmpty),
                      );
                    });
                  },
            child: Text(l10n.folderSelectAll),
          ),
          FilledButton.icon(
            onPressed: _busy || _selected.isEmpty
                ? null
                : () => _moveItems(_selected.toList()),
            icon: const Icon(Icons.drive_file_move_outline),
            label: Text(l10n.folderMove),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<Map<String, dynamic>> items) {
    final l10n = AppLocalizations.of(context)!;

    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          const Icon(Icons.photo_library_outlined, size: 56),
          const SizedBox(height: 16),
          Text(l10n.folderNoItems, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            widget.folderId != null || widget.unfiled
                ? l10n.folderAddHint
                : l10n.folderSaveHint,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return KeyedSubtree(
          key: ValueKey(_uri(item)),
          child: _buildMediaTile(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: Text(l10n.folderRetry)),
            ],
          ),
        ),
      );
    }

    if (widget.filter == 'folders') {
      return _buildFolders();
    }

    final items = _visibleItems;

    return PopScope(
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selecting) {
          _clearSelection();
        }
      },
      child: Column(
        children: [
          if (_selecting)
            _buildSelectionBar(items)
          else if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.folderItemCount(items.length))),
                  if (items.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selecting = true;
                        });
                      },
                      icon: const Icon(Icons.checklist),
                      label: Text(l10n.folderSelect),
                    ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: _buildMediaGrid(items),
            ),
          ),
        ],
      ),
    );
  }
}
