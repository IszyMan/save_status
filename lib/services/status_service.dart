import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusService {
  static const MethodChannel _channel =
  MethodChannel('com.iszyman.statusly/status');

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


  Future<Set<String>> getOpenedStatusUris(
      String source,
      ) async {
    final preferences =
    await SharedPreferences.getInstance();

    final key =
    source == 'business'
        ? 'opened_statuses_business'
        : 'opened_statuses_whatsapp';

    final values =
        preferences.getStringList(key) ?? [];

    return values.toSet();
  }

  Future<void> markStatusOpened({
    required String source,
    required String uri,
  }) async {
    final preferences =
    await SharedPreferences.getInstance();

    final key =
    source == 'business'
        ? 'opened_statuses_business'
        : 'opened_statuses_whatsapp';

    final values =
        preferences.getStringList(key) ?? [];

    if (!values.contains(uri)) {
      values.add(uri);

      await preferences.setStringList(
        key,
        values,
      );
    }
  }
}