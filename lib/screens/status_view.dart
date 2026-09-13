import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class StatusView extends StatefulWidget {
  final String filePath;
  final Map<String, dynamic> status;
  final bool isVideo;
  final VoidCallback? onSaved;

  const StatusView({
    super.key,
    required this.filePath,
    required this.status,
    required this.isVideo,
    this.onSaved,
  });

  @override
  State<StatusView> createState() =>
      _StatusViewState();
}

class _StatusViewState
    extends State<StatusView> {
  static const MethodChannel
  _channel =
  MethodChannel(
    'com.iszyman.statusly/status',
  );

  VideoPlayerController?
  _videoController;

  bool _initializing = true;
  bool _saving = false;
  bool _sharing = false;

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

  // ==========================================================================
  // DOWNLOAD / SAVE
  // ==========================================================================

  Future<void> _saveStatus() async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final result =
      await _channel.invokeMethod(
        'saveStatus',
        {
          'uri':
          widget.status['uri'],
          'name':
          widget.status['name'],
          'mimeType':
          widget.status['mimeType'],
        },
      );

      if (!mounted) return;

      final data =
      result is Map
          ? Map<String, dynamic>.from(
        result,
      )
          : <String, dynamic>{};

      final alreadySaved =
          data['alreadySaved'] == true;

      // The status is considered downloaded if Android reports
      // that it was saved now OR that it was already saved.
      widget.onSaved?.call();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            alreadySaved
                ? 'Already saved to your gallery.'
                : 'Saved to your gallery.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Unable to save status.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save status: $e',
          ),
          behavior:
          SnackBarBehavior.floating,
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
      await _channel.invokeMethod(
        'shareStatus',
        {
          'uri':
          widget.status['uri'],
          'name':
          widget.status['name'],
          'mimeType':
          widget.status['mimeType'],
          'filePath':
          widget.filePath,
        },
      );
    } on PlatformException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Unable to share status.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to share status: $e',
          ),
          behavior:
          SnackBarBehavior.floating,
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

  // ==========================================================================
  // VIDEO INITIALIZATION
  // ==========================================================================

  Future<void> _initializeVideo() async {
    try {
      final file =
      File(widget.filePath);

      if (!await file.exists()) {
        throw Exception(
          'Video file does not exist.',
        );
      }

      final size =
      await file.length();

      if (size <= 0) {
        throw Exception(
          'Video file is empty.',
        );
      }

      final controller =
      VideoPlayerController.file(
        file,
      );

      _videoController =
          controller;

      await controller.initialize();

      await controller.setLooping(
        true,
      );

      await controller.play();

      if (!mounted) return;

      setState(() {
        _initializing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _initializing = false;
        _error = e.toString();
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
      final file =
      File(widget.filePath);

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
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      Colors.black,

      appBar: AppBar(
        backgroundColor:
        Colors.black,
        foregroundColor:
        Colors.white,
        title: Text(
          widget.status['name']
              ?.toString() ??
              'Status',
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child:
                _buildContent(),
              ),
            ),

            if (!_initializing &&
                _error == null)
              _buildActionBar(),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // DOWNLOAD + SHARE BUTTONS
  // ==========================================================================

  Widget _buildActionBar() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white
                .withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed:
                _saving
                    ? null
                    : _saveStatus,
                icon: _saving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    Colors.white,
                  ),
                )
                    : const Icon(
                  Icons
                      .download_rounded,
                ),
                label: Text(
                  _saving
                      ? 'Saving...'
                      : 'Download',
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: SizedBox(
              height: 50,
              child:
              OutlinedButton.icon(
                onPressed:
                _sharing
                    ? null
                    : _shareStatus,
                style:
                OutlinedButton.styleFrom(
                  foregroundColor:
                  Colors.white,
                  side: BorderSide(
                    color: Colors.white
                        .withValues(alpha: 0.55),
                  ),
                ),
                icon: _sharing
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    Colors.white,
                  ),
                )
                    : const Icon(
                  Icons
                      .share_rounded,
                ),
                label: Text(
                  _sharing
                      ? 'Sharing...'
                      : 'Share',
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
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    if (_error != null) {
      return Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color:
              Colors.white70,
              size: 48,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              _error!,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (widget.isVideo) {
      final controller =
          _videoController;

      if (controller == null) {
        return const Text(
          'Unable to play video.',
          style: TextStyle(
            color: Colors.white,
          ),
        );
      }

      return GestureDetector(
        onTap: () {
          if (controller
              .value
              .isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }

          if (mounted) {
            setState(() {});
          }
        },
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width =
                controller
                    .value
                    .size
                    .width;

            final height =
                controller
                    .value
                    .size
                    .height;

            if (width <= 0 ||
                height <= 0) {
              return const SizedBox
                  .shrink();
            }

            return Center(
              child: AspectRatio(
                aspectRatio:
                width / height,
                child: VideoPlayer(
                  controller,
                ),
              ),
            );
          },
        ),
      );
    }

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4.0,
      child: Image.file(
        File(widget.filePath),
        fit: BoxFit.contain,
      ),
    );
  }
}