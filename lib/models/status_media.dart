import 'media_type.dart';

class StatusMedia {
  final String id;
  final String uri;
  final String fileName;
  final MediaType type;
  final int size;
  final DateTime dateAdded;

  const StatusMedia({
    required this.id,
    required this.uri,
    required this.fileName,
    required this.type,
    required this.size,
    required this.dateAdded,
  });
}