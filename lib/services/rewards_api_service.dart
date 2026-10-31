
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RewardsApiService {
  // Keep the existing USB-connected Laravel API configuration.
  static const String _baseUrl = 'http://127.0.0.1:8000/api';

  static const MethodChannel _channel =
  MethodChannel('com.iszyman.statusly/status');

  static const FlutterSecureStorage _secureStorage =
  FlutterSecureStorage();

  static const String _tokenKey = 'rewards_device_token';

  /// Gets the stable Android ID through the native MethodChannel.
  Future<String> _getAndroidId() async {
    final androidId =
    await _channel.invokeMethod<String>('getRewardsAndroidId');

    if (androidId == null || androidId.isEmpty) {
      throw Exception('Could not retrieve the Android device ID.');
    }

    return androidId;
  }

  /// Registers the device and securely stores its bearer token.
  Future<Map<String, dynamic>> _registerDevice() async {
    final androidId = await _getAndroidId();

    final response = await http.post(
      Uri.parse('$_baseUrl/rewards/devices/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'android_id': androidId,
      }),
    );

    final data = _decodeResponse(response);
    final token = data['token'];

    if (token is! String || token.isEmpty) {
      throw Exception('The rewards API did not return a device token.');
    }

    await _secureStorage.write(
      key: _tokenKey,
      value: token,
    );

    return data;
  }

  /// Gets a valid token, registering the device if necessary.
  Future<String> _getValidToken() async {
    var token = await _secureStorage.read(key: _tokenKey);

    if (token == null || token.isEmpty) {
      await _registerDevice();
      token = await _secureStorage.read(key: _tokenKey);
    }

    if (token == null || token.isEmpty) {
      throw Exception('Could not obtain a rewards authentication token.');
    }

    return token;
  }

  /// Makes an authenticated request and retries once after a 401 response.
  Future<http.Response> _authenticatedRequest(
      Future<http.Response> Function(String token) request,
      ) async {
    var token = await _getValidToken();
    var response = await request(token);

    if (response.statusCode == 401) {
      await _registerDevice();
      token = await _getValidToken();
      response = await request(token);
    }

    return response;
  }

  /// Retrieves the authenticated device profile.
  Future<Map<String, dynamic>> getDeviceProfile() async {
    final response = await _authenticatedRequest(
          (token) => http.get(
        Uri.parse('$_baseUrl/rewards/device'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return _decodeResponse(response);
  }

  /// Loads active campaigns published by the Laravel admin.
  Future<Map<String, dynamic>> getCampaigns() async {
    final response = await _authenticatedRequest(
          (token) => http.get(
        Uri.parse('$_baseUrl/rewards/campaigns'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return _decodeResponse(response);
  }

  /// Loads campaigns this device has joined and their task progress.
  Future<Map<String, dynamic>> getEnrolments() async {
    final response = await _authenticatedRequest(
          (token) => http.get(
        Uri.parse('$_baseUrl/rewards/enrolments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return _decodeResponse(response);
  }

  /// Joins a campaign using its code and the authenticated device.
  Future<Map<String, dynamic>> joinCampaign(String campaignCode) async {
    final encodedCode = Uri.encodeComponent(campaignCode);

    final response = await _authenticatedRequest(
          (token) => http.post(
        Uri.parse('$_baseUrl/rewards/campaigns/$encodedCode/join'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return _decodeResponse(response);
  }

  /// Records a successfully saved status for rewards progress.
  /// Laravel handles duplicate hashes, so repeat requests won't earn twice.
  Future<Map<String, dynamic>> recordSave({
    required String contentHash,
    required String mediaType,
    required String source,
    required int sizeBytes,
  }) async {
    final response = await _authenticatedRequest(
          (token) => http.post(
        Uri.parse('$_baseUrl/rewards/saves'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content_hash': contentHash,
          'media_type': mediaType,
          'source': source,
          'size_bytes': sizeBytes,
        }),
      ).timeout(const Duration(seconds: 15)),
    );

    return _decodeResponse(response);
  }



  /// Submits a reward redemption request.
  Future<Map<String, dynamic>> redeemReward({
    required String rewardId,
    required String network,
    required String phone,
  }) async {
    final encodedRewardId = Uri.encodeComponent(rewardId);

    final response = await _authenticatedRequest(
          (token) => http.post(
        Uri.parse(
          '$_baseUrl/rewards/rewards/$encodedRewardId/redeem',
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'network': network,
          'phone': phone,
        }),
      ).timeout(const Duration(seconds: 30)),
    );

    return _decodeResponse(response);
  }

  /// Checks the status of an existing reward redemption.
  Future<Map<String, dynamic>> checkRewardRedemption({
    required String rewardId,
  }) async {
    final encodedRewardId = Uri.encodeComponent(rewardId);

    final response = await _authenticatedRequest(
          (token) => http.post(
        Uri.parse(
          '$_baseUrl/rewards/rewards/$encodedRewardId/check',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30)),
    );

    return _decodeResponse(response);
  }


  /// Decodes successful JSON responses and reports API errors.
  Map<String, dynamic> _decodeResponse(http.Response response) {
    final dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'The rewards API returned an invalid response '
            '(HTTP ${response.statusCode}).',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : null;

      throw Exception(
        message ??
            'Rewards API request failed (HTTP ${response.statusCode}).',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('The rewards API returned an unexpected response.');
    }

    return decoded;
  }
}
