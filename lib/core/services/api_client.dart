import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Base44Client - Main API client for communicating with Base44 backend
/// Handles authentication, interceptors, and error handling
class Base44Client {
  static const String appId = '6901b3b0dd8eccff9db4c33d';
  static const String baseUrl = 'https://api.base44.com';

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _accessToken;

  Base44Client() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'X-App-Id': appId,
        'Content-Type': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  /// Setup request/response interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add access token if available
        if (_accessToken == null) {
          _accessToken = await _storage.read(key: 'access_token');
        }

        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }

        print('🔵 REQUEST[${options.method}] => ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('❌ ERROR[${e.response?.statusCode}] => ${e.message}');

        // Handle 401 Unauthorized - token expired
        if (e.response?.statusCode == 401) {
          await _handleTokenExpiry();
        }

        return handler.next(e);
      },
    ));
  }

  /// Set the access token for authenticated requests
  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    await _storage.write(key: 'access_token', value: token);
  }

  /// Clear the access token (logout)
  Future<void> clearAccessToken() async {
    _accessToken = null;
    await _storage.delete(key: 'access_token');
  }

  /// Get the current access token
  Future<String?> getAccessToken() async {
    if (_accessToken == null) {
      _accessToken = await _storage.read(key: 'access_token');
    }
    return _accessToken;
  }

  /// Handle token expiry (redirect to login or refresh token)
  Future<void> _handleTokenExpiry() async {
    await clearAccessToken();
    // TODO: Navigate to login screen
    // Get.offAllNamed(AppRoutes.login);
  }

  /// Get the Dio instance for making requests
  Dio get dio => _dio;
}