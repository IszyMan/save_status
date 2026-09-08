import '../models/status_media.dart';
import '../services/status_service.dart';

class StatusRepository {
  final StatusService _statusService;

  StatusRepository({
    required StatusService statusService,
  }) : _statusService = statusService;

  Future<List<StatusMedia>> getStatuses() {
    return _statusService.getStatuses();
  }

  Future<void> refresh() {
    return _statusService.refresh();
  }
}