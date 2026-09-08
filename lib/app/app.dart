import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StatusSaverApp extends StatefulWidget {
  const StatusSaverApp({super.key});

  @override
  State<StatusSaverApp> createState() => _StatusSaverAppState();
}

class _StatusSaverAppState extends State<StatusSaverApp> {
  static const MethodChannel _channel = MethodChannel(
    'com.example.status_saver/status',
  );

  List<Map<String, dynamic>> _statuses = [];

  bool _loading = false;

  Future<void> _selectStatusFolder() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'selectStatusFolder',
      );

      if (result == true) {
        await _loadStatuses();
      }
    } on PlatformException catch (e) {
      debugPrint('Platform error: ${e.message}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _loadStatuses() async {
    setState(() {
      _loading = true;
    });

    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getStatuses',
      );

      final statuses = (result ?? [])
          .map(
            (item) => Map<String, dynamic>.from(
          item as Map,
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _statuses = statuses;
      });
    } on PlatformException catch (e) {
      debugPrint(
        'Platform error loading statuses: ${e.message}',
      );
    } catch (e) {
      debugPrint(
        'Error loading statuses: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<Uint8List?> _readStatus(String uri) async {
    try {
      final result = await _channel.invokeMethod<Uint8List>(
        'readStatus',
        {
          'uri': uri,
        },
      );

      return result;
    } on PlatformException catch (e) {
      debugPrint(
        'Unable to read status: ${e.message}',
      );
      return null;
    } catch (e) {
      debugPrint(
        'Error reading status: $e',
      );
      return null;
    }
  }

  void _openStatus(
      Map<String, dynamic> status,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusViewer(
          status: status,
          readStatus: _readStatus,
        ),
      ),
    );
  }

  Widget _buildStatusItem(
      Map<String, dynamic> status,
      ) {
    final String name =
        status['name'] ?? '';

    final String mimeType =
        status['mimeType'] ?? '';

    final bool isVideo =
    mimeType.startsWith('video/');

    return GestureDetector(
      onTap: () => _openStatus(status),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [

            Container(
              color: Colors.black12,
              child: Center(
                child: Icon(
                  isVideo
                      ? Icons.play_circle_fill
                      : Icons.image,
                  size: 55,
                ),
              ),
            ),

            if (isVideo)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 28,
                ),
              ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
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

  @override
  void initState() {
    super.initState();

    _loadStatuses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Status',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Save Status',
          ),

          actions: [
            IconButton(
              onPressed: _loadStatuses,
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),

        body: _loading

            ? const Center(
          child: CircularProgressIndicator(),
        )

            : _statuses.isEmpty

            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(
                Icons.photo_library_outlined,
                size: 70,
              ),

              const SizedBox(
                height: 16,
              ),

              const Text(
                'No statuses found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Select your WhatsApp Status folder',
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton.icon(
                onPressed:
                _selectStatusFolder,
                icon: const Icon(
                  Icons.folder_open,
                ),
                label: const Text(
                  'Select WhatsApp Status Folder',
                ),
              ),
            ],
          ),
        )

            : Padding(
          padding: const EdgeInsets.all(8),

          child: GridView.builder(
            itemCount: _statuses.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),

            itemBuilder: (
                context,
                index,
                ) {
              return _buildStatusItem(
                _statuses[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class StatusViewer extends StatefulWidget {
  final Map<String, dynamic> status;

  final Future<Uint8List?> Function(
      String uri,
      ) readStatus;

  const StatusViewer({
    super.key,
    required this.status,
    required this.readStatus,
  });

  @override
  State<StatusViewer> createState() =>
      _StatusViewerState();
}

class _StatusViewerState
    extends State<StatusViewer> {

  VideoPlayerController? _videoController;

  Uint8List? _imageBytes;

  bool _loading = true;

  bool _isVideo = false;

  @override
  void initState() {
    super.initState();

    _isVideo =
        (widget.status['mimeType'] ?? '')
            .toString()
            .startsWith('video/');

    _loadStatus();
  }

  Future<void> _loadStatus() async {

    final uri =
    widget.status['uri'].toString();

    if (_isVideo) {

      final bytes =
      await widget.readStatus(uri);

      if (bytes == null) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }

        return;
      }

      final tempFile =
      await _createTemporaryVideo(bytes);

      if (tempFile == null) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }

        return;
      }

      final controller =
      VideoPlayerController.file(
        tempFile,
      );

      await controller.initialize();

      await controller.setLooping(true);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        _loading = false;
      });

      await controller.play();

    } else {

      final bytes =
      await widget.readStatus(uri);

      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _loading = false;
      });
    }
  }

  Future<File?> _createTemporaryVideo(
      Uint8List bytes,
      ) async {
    try {
      final directory =
      await getTemporaryDirectory();

      final file = File(
        '${directory.path}/status_video.mp4',
      );

      await file.writeAsBytes(
        bytes,
        flush: true,
      );

      return file;
    } catch (e) {
      debugPrint(
        'Error creating temporary video: $e',
      );

      return null;
    }
  }

  @override
  void dispose() {

    _videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.status['name'] ?? 'Status',
        ),
      ),

      body: Center(
        child: _loading

            ? const CircularProgressIndicator(
          color: Colors.white,
        )

            : _isVideo

            ? _videoController != null
            ? AspectRatio(
          aspectRatio:
          _videoController!
              .value
              .aspectRatio,

          child: VideoPlayer(
            _videoController!,
          ),
        )

            : const Text(
          'Unable to play video',
          style: TextStyle(
            color: Colors.white,
          ),
        )

            : _imageBytes != null
            ? InteractiveViewer(
          child: Image.memory(
            _imageBytes!,
            fit: BoxFit.contain,
          ),
        )

            : const Text(
          'Unable to load image',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}