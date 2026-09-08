import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/status_repository.dart';
import '../services/fake_status_service.dart';
import '../services/status_service.dart';

final statusServiceProvider = Provider<StatusService>((ref) {
  return FakeStatusService();
});

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  final statusService = ref.watch(statusServiceProvider);

  return StatusRepository(
    statusService: statusService,
  );
});