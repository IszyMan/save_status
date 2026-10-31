import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/saved_folder_picker.dart';
import '../services/rewards_api_service.dart';

class StatusView extends StatefulWidget {
  final String filePath;
  final Map<String, dynamic> status;
  final bool isVideo;
  final bool isSavedItem;
  final VoidCallback? onSaved;
  final String source;

  const StatusView({
    super.key,
    required this.filePath,
    required this.status,
    required this.isVideo,
    this.isSavedItem = false,
    this.onSaved,
    required this.source,
  });

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  static const MethodChannel _channel = MethodChannel(
    'com.iszyman.statusly/status',
  );

  final GlobalKey<ScaffoldMessengerState> _viewerMessengerKey = GlobalKey<ScaffoldMessengerState>();

  VideoPlayerController? _videoController;

  bool _initializing = true;
  bool _saving = false;
  bool _sharing = false;
  bool _reposting = false;

  bool _deleting = false;

  String? _error;

  @override
  void initState() {
    super.initState();

    if (widget.isVideo) {
      _initializeVideo();
    } else {
      _initializing = false;
    }
  }



  Future<void> _recordSavedStatus(Map<String, dynamic> data) async {
    // Saved-library items must not count as new saves.
    if (widget.isSavedItem) return;

    final contentHash = data['contentHash']?.toString();
    final rawSize = data['sizeBytes'];
    final sizeBytes = rawSize is num ? rawSize.toInt() : 0;

    if (contentHash == null ||
        !RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(contentHash) ||
        sizeBytes <= 0 ||
        sizeBytes > 2147483647) {
      debugPrint('Statusly rewards: Invalid save metadata; tracking skipped.');
      return;
    }

    if (widget.source != 'whatsapp' && widget.source != 'business') {
      debugPrint('Statusly rewards: Invalid source; tracking skipped.');
      return;
    }

    try {
      final result = await RewardsApiService().recordSave(
        contentHash: contentHash,
        mediaType: widget.isVideo ? 'videos' : 'images',
        source: widget.source,
        sizeBytes: sizeBytes,
      );

      debugPrint('Statusly rewards save response: $result');
    } catch (error) {
      // A rewards API failure must never undo or interrupt a gallery save.
      debugPrint('Statusly rewards tracking failed: $error');
    }
  }

  // ==========================================================================
  // DOWNLOAD / SAVE
  // ==========================================================================

  Future<void> _saveStatus() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      final result = await _channel.invokeMethod('saveStatus', {
        'uri': widget.status['uri'],
        'name': widget.status['name'],
        'mimeType': widget.status['mimeType'],
      });

      final data = result is Map
          ? Map<String, dynamic>.from(result)
          : <String, dynamic>{};

      // Send reward tracking independently of the gallery-save result.
      // This also runs when Android reports alreadySaved: true.
      _recordSavedStatus(data);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final alreadySaved = data['alreadySaved'] == true;

      // Android returns the URI of the saved gallery copy.
      final savedUri = data['uri']?.toString();

      widget.onSaved?.call();

      final messenger = _viewerMessengerKey.currentState;
      if (messenger == null) return;

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            alreadySaved ? l10n.alreadySavedToGallery : l10n.folderStatusSaved,
          ),
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
          action: savedUri == null || savedUri.isEmpty
              ? null
              : SnackBarAction(
                  label: l10n.folderAddTo,
                  onPressed: () async {
                    await _videoController?.pause();

                    if (!mounted) return;

                    await organizeSavedStatus(context, savedUri);
                  },
                ),
        ),
      );
    } on PlatformException catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? l10n.unableToSaveStatus),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.unableToSaveStatusWithError(error.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _repostStatus() async {
    if (_reposting || _sharing || _saving) return;

    setState(() {
      _reposting = true;
    });

    try {
      await _videoController?.pause();

      await _channel.invokeMethod('repostStatus', {
        'uri': widget.status['uri'],
        'mimeType': widget.status['mimeType'],
      });
    } catch (e) {
      if (!mounted) return;

      final message = e is PlatformException
          ? e.message ?? 'Unable to repost this status.'
          : 'Unable to repost this status. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) {
        setState(() {
          _reposting = false;
        });
      }
    }
  }

  // ==========================================================================
  // SHARE
  // ==========================================================================

  Future<void> _shareStatus() async {
    if (_sharing) {
      return;
    }

    setState(() {
      _sharing = true;
    });

    try {
      await _channel.invokeMethod('shareStatus', {
        'uri': widget.status['uri'],
        'name': widget.status['name'],
        'mimeType': widget.status['mimeType'],
        'filePath': widget.filePath,
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? l10n.unableToShareStatus),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.unableToShareStatusWithError(e.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sharing = false;
        });
      }
    }
  }

  Future<void> _deleteStatus() async {
    if (!widget.isSavedItem || _deleting || _saving || _sharing || _reposting) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete saved item?'),
          content: Text(
            'This will permanently remove this '
            '${widget.isVideo ? 'video' : 'photo'} '
            'from Saved and your phone’s gallery.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _deleting = true;
    });

    try {
      await _videoController?.pause();

      final deleted = await _channel.invokeMethod<bool>('deleteSavedStatus', {
        'uri': widget.status['uri'],
      });

      if (!mounted) return;

      if (deleted == true) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;

      final message = e is PlatformException
          ? e.message ?? 'Unable to delete this item.'
          : 'Unable to delete this item. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  // ==========================================================================
  // VIDEO INITIALIZATION
  // ==========================================================================

  Future<void> _initializeVideo() async {
    try {
      final file = File(widget.filePath);

      if (!await file.exists()) {
        throw Exception('VIDEO_FILE_NOT_FOUND');
      }

      final size = await file.length();

      if (size <= 0) {
        throw Exception('VIDEO_FILE_EMPTY');
      }

      final controller = VideoPlayerController.file(file);

      _videoController = controller;

      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();

      if (!mounted) {
        return;
      }

      setState(() {
        _initializing = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _initializing = false;

        if (e.toString().contains('VIDEO_FILE_NOT_FOUND')) {
          _error = 'VIDEO_FILE_NOT_FOUND';
        } else if (e.toString().contains('VIDEO_FILE_EMPTY')) {
          _error = 'VIDEO_FILE_EMPTY';
        } else {
          _error = e.toString();
        }
      });
    }
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _videoController?.dispose();

    try {
      final file = File(widget.filePath);

      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}

    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _viewerMessengerKey.currentState
              ?.removeCurrentSnackBar();
        }
      },
      child: ScaffoldMessenger(
        key: _viewerMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(
              widget.isVideo ? 'Video' : 'Photo',
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: _buildContent(),
                  ),
                ),
                if (!_initializing && _error == null)
                  _buildActionBar(
                    context,
                    colorScheme,
                    l10n,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // DOWNLOAD + SHARE BUTTONS
  // ==========================================================================

  Widget _buildActionBar(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final busy = _reposting || _sharing || _saving || _deleting;

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 36),
      child: Row(
        children: [
          Expanded(
            child: _buildViewerAction(
              label: l10n.repost,
              icon: Icons.reply_all_rounded,
              loading: _reposting,
              onPressed: busy ? null : _repostStatus,
            ),
          ),

          Expanded(
            child: _buildViewerAction(
              label: l10n.share,
              icon: Icons.share_outlined,
              loading: _sharing,
              onPressed: busy ? null : _shareStatus,
            ),
          ),

          Expanded(
            child: _buildViewerAction(
              label: widget.isSavedItem ? l10n.delete : l10n.save,
              icon: widget.isSavedItem
                  ? Icons.delete_outline_rounded
                  : Icons.file_download_outlined,
              loading: widget.isSavedItem ? _deleting : _saving,
              onPressed: busy
                  ? null
                  : widget.isSavedItem
                  ? _deleteStatus
                  : _saveStatus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewerAction({
    required String label,
    required IconData icon,
    required bool loading,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white38,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(0, 72),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(2),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, size: 28),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MEDIA CONTENT
  // ==========================================================================

  Widget _buildContent() {
    if (_initializing) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (widget.isVideo) {
      final controller = _videoController;

      if (controller == null) {
        final l10n = AppLocalizations.of(context)!;

        return Text(
          l10n.unableToPlayVideo,
          style: const TextStyle(color: Colors.white),
        );
      }

      return GestureDetector(
        onTap: () {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }

          if (mounted) {
            setState(() {});
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = controller.value.size.width;
            final height = controller.value.size.height;

            if (width <= 0 || height <= 0) {
              return const SizedBox.shrink();
            }

            return Center(
              child: AspectRatio(
                aspectRatio: width / height,
                child: VideoPlayer(controller),
              ),
            );
          },
        ),
      );
    }

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4.0,
      child: Image.file(File(widget.filePath), fit: BoxFit.contain),
    );
  }
}
