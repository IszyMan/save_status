import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedFolder {
  final String id;
  final String name;

  const SavedFolder(this.id, this.name);
}

/// Stores folders and their saved-media membership locally.
///
/// Gallery files are not moved, copied, or deleted.
class SavedFolderStore extends ChangeNotifier {
  SavedFolderStore._();

  static final instance = SavedFolderStore._();

  static const _storageKey = 'statusly_saved_folders_v1';

  List<SavedFolder> _folders = [];
  Map<String, String> _membership = {};

  Future<void>? _initializing;
  Future<void> _pendingWrite = Future<void>.value();

  List<SavedFolder> get folders => List.unmodifiable(_folders);

  String? folderFor(String uri) => _membership[uri];

  Future<void> initialize() {
    return _initializing ??= _read().catchError((Object error) {
      _initializing = null;
      throw error;
    });
  }

  Future<void> _read() async {
    final preferences = await SharedPreferences.getInstance();

    final raw = preferences.getString(_storageKey);

    if (raw == null) return;

    final data = jsonDecode(raw) as Map<String, dynamic>;

    final folders = (data['folders'] as List).map((value) {
      final row = Map<String, dynamic>.from(value as Map);

      return SavedFolder(row['id'] as String, row['name'] as String);
    }).toList();

    final membership = Map<String, String>.from(data['membership'] as Map);

    _folders = folders;
    _membership = membership;

    notifyListeners();
  }

  /// Serializes writes so simultaneous operations do not overwrite each other.
  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _pendingWrite.then((_) async {
      await initialize();
      return operation();
    });

    _pendingWrite = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return result;
  }

  Future<void> _commit(
    List<SavedFolder> folders,
    Map<String, String> membership,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final success = await preferences.setString(
      _storageKey,
      jsonEncode({
        'folders': folders.map((folder) {
          return {'id': folder.id, 'name': folder.name};
        }).toList(),
        'membership': membership,
      }),
    );

    if (!success) {
      throw StateError('Could not save folder changes.');
    }

    _folders = folders;
    _membership = membership;

    notifyListeners();
  }

  String _validateName(String value, {String? exceptId}) {
    final name = value.trim();

    if (name.isEmpty || name.runes.length > 40) {
      throw ArgumentError('invalid_name');
    }

    final duplicate = _folders.any((folder) {
      return folder.id != exceptId &&
          folder.name.toLowerCase() == name.toLowerCase();
    });

    if (duplicate) {
      throw ArgumentError('duplicate_name');
    }

    return name;
  }

  Future<SavedFolder> create(String value) {
    return _serialize(() async {
      final name = _validateName(value);

      final random = Random.secure();

      final id =
          '${DateTime.now().microsecondsSinceEpoch}_'
          '${random.nextInt(1 << 30)}';

      final folder = SavedFolder(id, name);

      await _commit([..._folders, folder], {..._membership});

      return folder;
    });
  }

  Future<void> rename(String id, String value) {
    return _serialize(() async {
      final name = _validateName(value, exceptId: id);

      if (!_folders.any((folder) => folder.id == id)) {
        throw StateError('Folder no longer exists.');
      }

      final updated = _folders.map((folder) {
        return folder.id == id ? SavedFolder(id, name) : folder;
      }).toList();

      await _commit(updated, {..._membership});
    });
  }

  Future<void> delete(String id) {
    return _serialize(() async {
      final membership = {..._membership}
        ..removeWhere((uri, folderId) => folderId == id);

      await _commit(
        _folders.where((folder) => folder.id != id).toList(),
        membership,
      );
    });
  }

  Future<void> move(Iterable<String> uris, String? folderId) {
    return _serialize(() async {
      if (folderId != null &&
          !_folders.any((folder) => folder.id == folderId)) {
        throw StateError('Folder no longer exists.');
      }

      final membership = {..._membership};

      for (final uri in uris.where((uri) => uri.isNotEmpty)) {
        if (folderId == null) {
          membership.remove(uri);
        } else {
          membership[uri] = folderId;
        }
      }

      await _commit([..._folders], membership);
    });
  }

  /// Call after Android confirms that a saved file was deleted.
  Future<void> forget(String uri) {
    return move([uri], null);
  }
}
