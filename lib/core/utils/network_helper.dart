import 'dart:io';
import 'package:flutter/foundation.dart';

/// Network Helper
/// Utility class to check network connectivity
class NetworkHelper {
  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('Network: Connected');
        return true;
      }
    } catch (e) {
      debugPrint('Network: Disconnected - $e');
    }

    return false;
  }

  /// Check connection to specific host
  static Future<bool> canReachHost(String host) async {
    try {
      final result = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      debugPrint('Cannot reach host $host: $e');
      return false;
    }
  }

  /// Check if Base44 API is reachable
  static Future<bool> canReachBase44Api() async {
    return await canReachHost('api.base44.com');
  }

  /// Get connection status message
  static Future<String> getConnectionStatus() async {
    final hasConnection = await hasInternetConnection();

    if (hasConnection) {
      return 'Connected';
    } else {
      return 'No internet connection';
    }
  }
}
