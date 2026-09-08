import '../models/status_media.dart';
import 'status_service.dart';

class FakeStatusService implements StatusService {
  @override
  Future<List<StatusMedia>> getStatuses() async {
    return [];
  }

  @override
  Future<void> refresh() async {}
}