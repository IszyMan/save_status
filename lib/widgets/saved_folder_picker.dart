import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/saved_folder_store.dart';
import '../services/status_service.dart';
import 'media_filter_bar.dart';

Future<SavedFolder?> showFolderNameDialog(
  BuildContext context, {
  SavedFolder? folder,
}) {
  return showDialog<SavedFolder>(
    context: context,
    builder: (_) => _FolderNameDialog(folder: folder),
  );
}

class _FolderNameDialog extends StatefulWidget {
  final SavedFolder? folder;

  const _FolderNameDialog({this.folder});

  @override
  State<_FolderNameDialog> createState() => _FolderNameDialogState();
}

class _FolderNameDialogState extends State<_FolderNameDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.folder?.name,
  );

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final store = SavedFolderStore.instance;
      final existing = widget.folder;

      SavedFolder result;

      if (existing == null) {
        result = await store.create(_nameController.text);
      } else {
        await store.rename(existing.id, _nameController.text);

        result = SavedFolder(existing.id, _nameController.text.trim());
      }

      if (!mounted) return;

      Navigator.of(context).pop(result);
    } on ArgumentError catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.message == 'duplicate_name'
            ? l10n.folderDuplicateName
            : l10n.folderNameInvalid;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = l10n.folderOperationFailed;
      });
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

    return PopScope(
      canPop: !_busy,
      child: AlertDialog(
        title: Text(widget.folder == null ? l10n.folderNew : l10n.folderRename),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          enabled: !_busy,
          maxLength: 40,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: l10n.folderName,
            errorText: _error,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(
              widget.folder == null ? l10n.folderCreate : l10n.folderRename,
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> showSavedFolderPicker(
    BuildContext context, {
      required List<String> uris,
      required List<Map<String, dynamic>> savedItems,
    }) async {
  if (uris.isEmpty || uris.any((uri) => uri.isEmpty)) {
    return null;
  }

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: true,
    builder: (_) => _FolderPicker(
      uris: uris,
      savedItems: savedItems,
    ),
  );
}

class _FolderPicker extends StatefulWidget {
  final List<String> uris;
  final List<Map<String, dynamic>> savedItems;

  const _FolderPicker({required this.uris, required this.savedItems});

  @override
  State<_FolderPicker> createState() => _FolderPickerState();
}

class _FolderPickerState extends State<_FolderPicker> {
  final _store = SavedFolderStore.instance;

  bool _loading = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await _store.initialize();

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)!.folderOperationFailed;
      });
    }
  }

  Future<void> _choose(String? folderId) async {
    if (_busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final folderName = folderId == null
          ? AppLocalizations.of(context)!.folderNoFolder
          : _store.folders
          .firstWhere((folder) => folder.id == folderId)
          .name;

      await _store.move(widget.uris, folderId);

      if (!mounted) return;

      Navigator.of(context).pop(folderName);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = AppLocalizations.of(context)!
            .folderOperationFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _create() async {
    if (_busy) return;

    final folder = await showFolderNameDialog(context);

    if (!mounted || folder == null) return;

    // The new folder is automatically selected.
    await _choose(folder.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_busy,
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.65,
          child: AbsorbPointer(
            absorbing: _busy,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.folderMoveTo,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.cancel,
                        onPressed: _busy
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (_busy) const LinearProgressIndicator(),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_error!, style: TextStyle(color: colors.error)),
                  ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.create_new_folder_outlined,
                              ),
                              title: Text(l10n.folderNew),
                              onTap: _create,
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library_outlined),
                              title: Text(l10n.folderNoFolder),
                              subtitle: Text(l10n.folderKeepInAll),
                              onTap: () => _choose(null),
                            ),
                            ..._store.folders.map((folder) {
                              final count = widget.savedItems.where((item) {
                                return _store.folderFor(
                                      item['uri'].toString(),
                                    ) ==
                                    folder.id;
                              }).length;

                              final selected = widget.uris.every(
                                (uri) => _store.folderFor(uri) == folder.id,
                              );

                              return ListTile(
                                leading: Icon(
                                  Icons.folder_outlined,
                                  color: colors.primary,
                                ),
                                title: Text(folder.name),
                                subtitle: Text(l10n.folderItemCount(count)),
                                trailing: selected
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () => _choose(folder.id),
                              );
                            }),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Organizes the saved gallery copy, not the original WhatsApp file.
Future<void> organizeSavedStatus(
    BuildContext context,
    String savedUri,
    ) async {
  try {
    final items = await StatusService().getSavedStatuses();

    if (!context.mounted) return;

    final exists = items.any(
          (item) => item['uri']?.toString() == savedUri,
    );

    if (!exists) {
      throw StateError('Saved file is unavailable.');
    }

    final folderName = await showSavedFolderPicker(
      context,
      uris: [savedUri],
      savedItems: items,
    );

    if (!context.mounted || folderName == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.folderMovedSuccess(
            1,
            folderName,
          ),
        ),
      ),
    );
  } catch (_) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!
              .folderOperationFailed,
        ),
      ),
    );
  }
}

class SavedFilterBar extends StatelessWidget {
  final int selected;
  final int imagesCount;
  final int videosCount;
  final ValueChanged<int> onChanged;

  const SavedFilterBar({
    super.key,
    required this.selected,
    required this.imagesCount,
    required this.videosCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SavedFolderStore.instance,
      builder: (context, _) {
        final selectedFilter = selected == 2
            ? 'folders'
            : selected == 1
            ? 'videos'
            : 'images';

        return Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 4,
          ),
          child: MediaFilterBar(
            selectedFilter: selectedFilter,
            imagesCount: imagesCount,
            videosCount: videosCount,
            showFolders: true,
            foldersCount:
            SavedFolderStore.instance.folders.length,
            onChanged: (value) {
              final index = value == 'folders'
                  ? 2
                  : value == 'videos'
                  ? 1
                  : 0;

              onChanged(index);
            },
          ),
        );
      },
    );
  }
}
