import 'dart:typed_data';

import 'package:flutter/services.dart';

class StatusService {
  static const MethodChannel _channel =
  MethodChannel('com.example.status_saver/status');

  Future<Map<String, dynamic>?> getAppState() async {
    final result = await _channel.invokeMethod('getAppState');

    if (result == null) {
      return null;
    }

    return Map<String, dynamic>.from(result);
  }

  Future<bool> selectStatusFolder(String source) async {
    final result = await _channel.invokeMethod<bool>(
      'selectStatusFolder',
      {
        'source': source,
      },
    );

    return result == true;
  }

  Future<List<Map<String, dynamic>>> getStatuses(
      String source,
      ) async {
    final result = await _channel.invokeMethod(
      'getStatuses',
      {
        'source': source,
      },
    );

    if (result is! List) {
      return [];
    }

    return result
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getSavedStatuses() async {
    final result = await _channel.invokeMethod('getSavedStatuses');

    if (result is! List) {
      return [];
    }

    return result
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> setLastSelectedSource(String source) async {
    await _channel.invokeMethod(
      'setLastSelectedSource',
      {
        'source': source,
      },
    );
  }

  Future<String?> prepareStatus({
    required String uri,
    required String name,
  }) async {
    return _channel.invokeMethod<String>(
      'prepareStatus',
      {
        'uri': uri,
        'name': name,
      },
    );
  }

  Future<Uint8List?> getThumbnail(String uri) async {
    return _channel.invokeMethod<Uint8List>(
      'getThumbnail',
      {
        'uri': uri,
      },
    );
  }

  Future<bool> openWhatsApp(String source) async {
    final result = await _channel.invokeMethod<bool>(
      'openWhatsApp',
      {
        'source': source,
      },
    );

    return result == true;
  }
}