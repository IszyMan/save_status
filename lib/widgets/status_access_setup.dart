import 'package:flutter/material.dart';

import '../services/status_service.dart';

class StatusAccessSetup {
  static Future<bool> show({
    required BuildContext context,
    required StatusService statusService,
    required String source,
  }) async {
    if (!context.mounted) return false;

    try {
      // Opens the Android folder picker.
      // MainActivity still displays the native instruction guide.
      return await statusService.selectStatusFolder(source);
    } catch (e) {
      debugPrint(
        'STATUS ACCESS SETUP ERROR [$source]: $e',
      );

      return false;
    }
  }
}