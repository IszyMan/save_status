import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/status_service.dart';
import '../theme/app_theme.dart';

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