import '../models/status_media.dart';

abstract class StatusService {
  Future<List<StatusMedia>> getStatuses();

  Future<void> refresh();
}