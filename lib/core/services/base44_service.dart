import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Base44Service {
  //static const String _baseUrl = 'https://app.base44.com/api';
  static const String _baseUrl =
      'https://app.base44.com/api/apps/6901b3b0dd8eccff9db4c33d';
  static const String _loginBaseUrl =
      'https://base44.app/api/apps/6901b3b0dd8eccff9db4c33d';

  static const String _appId = '6901b3b0dd8eccff9db4c33d';

  static const String _tokenKey = 'base44_auth_token';
  static const String _userKey = 'base44_user_data';

  String? _authToken;

  // ---------------------------
  // TOKEN MANAGEMENT
  // ---------------------------

  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_tokenKey);
    return _authToken;
  }

  // ---------------------------
  // TOKEN REFRESH
  // ---------------------------
  Future<String?> refreshToken() async {
    try {
      final url = Uri.parse("$_baseUrl/auth/refresh");

      final res = await http
          .post(
            url,
            headers: _headers(auth: true),
          )
          .timeout(const Duration(seconds: 30));

      final data = _handle(res, "POST /auth/refresh");

      final newToken =
          data["token"] ?? data["access_token"] ?? data["data"]?["token"];

      if (newToken != null) {
        await saveAuthToken(newToken);
        return newToken;
      }

      return null;
    } catch (e) {
      debugPrint("[Base44] âŒ Token refresh failed: $e");
      return null;
    }
  }

  // ---------------------------
  // PASSWORD RESET
  // ---------------------------

  /// Step 1: Request reset email (Reset link / OTP)
  Future<void> requestPasswordReset(String email) async {
    try {
      final url = Uri.parse("$_baseUrl/auth/password/reset-request");

      final body = {
        "email": email.trim().toLowerCase(),
      };

      final res = await http
          .post(url, headers: _headers(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      _handle(res, "POST /auth/password/reset-request");
    } catch (e) {
      throw _net(e);
    }
  }

  /// Step 2: Submit reset with token + new password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/auth/password/reset");

      final body = {
        "token": token,
        "password": newPassword,
      };

      final res = await http
          .post(url, headers: _headers(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      _handle(res, "POST /auth/password/reset");
    } catch (e) {
      throw _net(e);
    }
  }

  /// Step 3: Change password while logged in
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/auth/password/change");

      final body = {
        "current_password": currentPassword,
        "new_password": newPassword,
      };

      final res = await http
          .post(url, headers: _headers(auth: true), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      _handle(res, "POST /auth/password/change");
    } catch (e) {
      throw _net(e);
    }
  }

  // ---------------------------
  // UPDATE PROFILE
  // ---------------------------
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? avatar,
  }) async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception("Not logged in");

      final url = Uri.parse("$_baseUrl/auth/update-profile");

      final body = <String, dynamic>{};

      if (fullName != null) body["full_name"] = fullName;
      if (phone != null) body["phone"] = phone;
      if (avatar != null) body["avatar"] = avatar; // URL or Base64 string

      final res = await http
          .post(
            url,
            headers: _headers(auth: true),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = _handle(res, "POST /auth/update-profile");

      // If server returns new user object, save it
      final user = data["user"] ?? data["data"];
      if (user != null) {
        await saveUserData(user);
      }

      return data;
    } catch (e) {
      throw _net(e);
    }
  }

  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // ---------------------------
  // USER DATA STORAGE
  // ---------------------------

  Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  // ---------------------------
  // HEADERS - WEB COMPATIBLE
  // ---------------------------

  Map<String, String> _headers({
    bool auth = false,
    bool webCompatible = false,
  }) {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "x-app-id": _appId,
    };

    if (webCompatible) {
      // Mimic web browser headers
      headers["Accept"] = "application/json, text/plain, */*";
      headers["Origin"] = "https://app.base44.com";
      headers["Referer"] = "https://app.base44.com/";
      headers["User-Agent"] =
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36";
    } else {
      headers["User-Agent"] = "Daftar-Mobile/1.0";
    }

    if (auth && _authToken != null) {
      headers["Authorization"] = "Bearer $_authToken";
    }

    return headers;
  }

  // ---------------------------
  // ERROR HANDLING
  // ---------------------------

  Map<String, dynamic> _handle(http.Response res, String endpoint) {
    debugPrint("Base44 [$endpoint] ${res.statusCode} â†’ ${res.body}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }

    try {
      final error = jsonDecode(res.body);
      throw Exception(error["message"] ?? "Error ${res.statusCode}");
    } catch (_) {
      throw Exception("Error ${res.statusCode}");
    }
  }

  Exception _net(error) {
    if (error is SocketException) return Exception("No Internet connection.");
    if (error is TimeoutException) return Exception("Request timeout.");
    return Exception(error.toString());
  }

  // ----------------------------------------------------------
  // LOGIN METHODS - MULTIPLE STRATEGIES
  // ----------------------------------------------------------

  /// Strategy 1: Web-compatible login (NO app_id in body)
  /// This mimics exactly what the web app sends
  Future<Map<String, dynamic>> loginWebCompatible({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[Base44] ðŸŒ Trying WEB-COMPATIBLE login');

      final url = Uri.parse("$_loginBaseUrl/auth/login");

      // Web app typically sends ONLY email and password
      final bodyMap = {
        "email": email.trim().toLowerCase(),
        "password": password,
      };

      debugPrint('[Base44] POST ${url.toString()}');
      debugPrint('[Base44] Body: ${jsonEncode(bodyMap)}');
      debugPrint('[Base44] Using web-compatible headers');

      final res = await http
          .post(
            url,
            headers: _headers(webCompatible: true), // Web headers
            body: jsonEncode(bodyMap),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[Base44] Response (${res.statusCode}): ${res.body}');

      final data = _handle(res, "POST /auth/login [WEB]");

      // Save token and user
      final token =
          data["token"] ?? data["access_token"] ?? data["data"]?["token"];
      if (token != null) await saveAuthToken(token);

      final user = data["user"] ?? data["data"]?["user"] ?? data["data"];
      if (user != null) await saveUserData(user);

      return data;
    } catch (e) {
      debugPrint('[Base44] âŒ Web-compatible login failed: $e');
      throw _net(e);
    }
  }

  /// Strategy 2: Original login (WITH app_id in body)
  Future<Map<String, dynamic>> loginOriginal({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[Base44] ðŸ“± Trying ORIGINAL login (with app_id in body)');

      final url = Uri.parse("$_loginBaseUrl/auth/login");

      final bodyMap = {
        "email": email.trim().toLowerCase(),
        "password": password,
        "app_id": _appId,
      };

      debugPrint('[Base44] POST ${url.toString()}');
      debugPrint('[Base44] Body: ${jsonEncode(bodyMap)}');

      final res = await http
          .post(
            url,
            headers: _headers(),
            body: jsonEncode(bodyMap),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[Base44] Response (${res.statusCode}): ${res.body}');

      final data = _handle(res, "POST /auth/login [ORIGINAL]");

      final token =
          data["token"] ?? data["access_token"] ?? data["data"]?["token"];
      if (token != null) await saveAuthToken(token);

      final user = data["user"] ?? data["data"]?["user"] ?? data["data"];
      if (user != null) await saveUserData(user);

      return data;
    } catch (e) {
      debugPrint('[Base44] âŒ Original login failed: $e');
      throw _net(e);
    }
  }

  /// Strategy 3: Try /auth/sign-in endpoint
  Future<Map<String, dynamic>> loginSignIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[Base44] ðŸ” Trying SIGN-IN endpoint');

      final url = Uri.parse("$_baseUrl/auth/sign-in");

      final bodyMap = {
        "email": email.trim().toLowerCase(),
        "password": password,
      };

      debugPrint('[Base44] POST ${url.toString()}');
      debugPrint('[Base44] Body: ${jsonEncode(bodyMap)}');

      final res = await http
          .post(
            url,
            headers: _headers(webCompatible: true),
            body: jsonEncode(bodyMap),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[Base44] Response (${res.statusCode}): ${res.body}');

      final data = _handle(res, "POST /auth/sign-in");

      final token =
          data["token"] ?? data["access_token"] ?? data["data"]?["token"];
      if (token != null) await saveAuthToken(token);

      final user = data["user"] ?? data["data"]?["user"] ?? data["data"];
      if (user != null) await saveUserData(user);

      return data;
    } catch (e) {
      debugPrint('[Base44] âŒ Sign-in endpoint failed: $e');
      throw _net(e);
    }
  }

  /// Main login method - tries all strategies
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    debugPrint(
        '\nâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•');
    debugPrint('ðŸ”‘ BASE44 LOGIN - TRYING ALL STRATEGIES');
    debugPrint(
        'â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•\n');

    // Strategy 1: Web-compatible (MOST LIKELY TO WORK)
    try {
      return await loginWebCompatible(
        email: email,
        password: password,
      );
    } catch (e1) {
      debugPrint('Strategy 1 (Web-compatible) failed\n');

      // Strategy 2: Original with app_id in body
      try {
        return await loginOriginal(
          email: email,
          password: password,
        );
      } catch (e2) {
        debugPrint('Strategy 2 (Original) failed\n');

        // Strategy 3: Sign-in endpoint
        try {
          return await loginSignIn(
            email: email,
            password: password,
          );
        } catch (e3) {
          debugPrint('Strategy 3 (Sign-in) failed\n');

          // All strategies failed
          debugPrint(
              'â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•');
          debugPrint('âŒ ALL LOGIN STRATEGIES FAILED');
          debugPrint(
              'â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•\n');

          // Throw the most relevant error (from strategy 1)
          throw Exception(
            "Login failed. Please check:\n"
            "1. Email and password are correct\n"
            "2. Account is active\n"
            "3. Internet connection\n\n"
            "Error: ${e1.toString().replaceAll('Exception: ', '')}",
          );
        }
      }
    }
  }

  // ----------------------------------------------------------
  // OTHER METHODS (kept for compatibility)
  // ----------------------------------------------------------

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? organizationName,
    String? phone,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/auth/register");

      final body = {
        "email": email,
        "password": password,
        "full_name": fullName,
      };

      if (organizationName != null)
        body["organization_name"] = organizationName;
      if (phone != null) body["phone"] = phone;

      final res = await http
          .post(url, headers: _headers(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      final data = _handle(res, "POST /auth/register");

      final token = data["token"] ?? data["access_token"];
      if (token != null) await saveAuthToken(token);

      if (data["user"] != null) {
        await saveUserData(data["user"]);
      }

      return data;
    } catch (e) {
      throw _net(e);
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception("Not logged in");

      final url = Uri.parse("$_baseUrl/entities/User/me");

      final res = await http
          .get(url, headers: _headers(auth: true))
          .timeout(const Duration(seconds: 30));

      final data = _handle(res, "GET /entities/User/me");

      final user = data["user"] ?? data["data"] ?? data;
      await saveUserData(user);

      return data;
    } catch (e) {
      throw _net(e);
    }
  }

  Future<void> logout() async {
    try {
      final url = Uri.parse("$_baseUrl/auth/logout");
      await http
          .post(url, headers: _headers(auth: true))
          .timeout(const Duration(seconds: 30));
    } catch (_) {}

    await clearAuthToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    if (token == null) return false;

    try {
      await getCurrentUser();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> googleLogin({
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final url = Uri.parse(
        "$_loginBaseUrl/auth/google-login",
      );

      final body = {
        "id_token": idToken,
        "access_token": accessToken,
        "app_id": _appId,
      };

      debugPrint("[Base44] POST $url");
      debugPrint("[Base44] Body: ${jsonEncode(body)}");

      final res = await http
          .post(
            url,
            headers: _headers(),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = _handle(res, "POST /auth/google-login");

      // Save token if backend returns it
      final token = data["token"] ?? data["access_token"];
      if (token != null) {
        await saveAuthToken(token);
      }

      // Save user if returned
      final user = data["user"] ?? data["data"]?["user"] ?? data["data"];
      if (user != null) {
        await saveUserData(user);
      }

      return data;
    } catch (e) {
      debugPrint("[Base44] âŒ Google login failed: $e");
      throw _net(e);
    }
  }

  // ---------------------------
  // TRANSACTIONS
  // ---------------------------

  /// Get transactions list with optional sorting
  /// Default sort: -date (newest first)
  Future<List<dynamic>> getTransactions({
    String? sort,
    int? limit,
    int? skip,
  }) async {
    debugPrint(
        "\n╔════════════════════════════════════════════════════════════════╗");
    debugPrint(
        "║         BASE44 SERVICE - GET TRANSACTIONS                      ║");
    debugPrint(
        "╚════════════════════════════════════════════════════════════════╝");

    try {
      debugPrint("🔐 [Base44] Step 1: Getting auth token...");
      final token = await getAuthToken();
      if (token == null) {
        debugPrint("❌ [Base44] No auth token found!");
        throw Exception("Not logged in");
      }
      debugPrint("✅ [Base44] Auth token found: ${token.substring(0, 20)}...");

      // Build query parameters
      final queryParams = <String, String>{};
      if (sort != null) queryParams['sort'] = sort;
      if (limit != null) queryParams['limit'] = limit.toString();
      if (skip != null) queryParams['skip'] = skip.toString();

      final uri = Uri.parse("$_baseUrl/entities/Transaction")
          .replace(queryParameters: queryParams);

      debugPrint("\n📡 [Base44] Step 2: Making HTTP GET request...");
      debugPrint("   URL: $uri");
      debugPrint("   Method: GET");
      debugPrint("   Query Parameters:");
      queryParams.forEach((key, value) {
        debugPrint("   - $key: $value");
      });

      final headers = _headers(auth: true);
      debugPrint("   Headers:");
      headers.forEach((key, value) {
        if (key == 'Authorization') {
          debugPrint("   - $key: Bearer ${value.substring(7, 27)}...");
        } else {
          debugPrint("   - $key: $value");
        }
      });

      debugPrint("\n⏳ [Base44] Waiting for response (timeout: 30s)...");
      final res = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      debugPrint("\n✅ [Base44] Response received!");
      debugPrint("   Status Code: ${res.statusCode}");
      debugPrint("   Body Length: ${res.body.length} characters");

      // Log first 500 chars of response for debugging
      if (res.body.length > 500) {
        debugPrint("   Body Preview: ${res.body.substring(0, 500)}...");
      } else {
        debugPrint("   Full Body: ${res.body}");
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        debugPrint("\n✅ [Base44] Success response (${res.statusCode})");

        if (res.body.isEmpty) {
          debugPrint("⚠️  [Base44] Response body is empty");
          return [];
        }

        debugPrint("🔄 [Base44] Parsing JSON response...");
        final decoded = jsonDecode(res.body);
        debugPrint("   Decoded type: ${decoded.runtimeType}");

        // Handle different response formats
        if (decoded is List) {
          debugPrint("✅ [Base44] Response is a List");
          debugPrint("   Items count: ${decoded.length}");
          return decoded;
        } else if (decoded is Map) {
          debugPrint("✅ [Base44] Response is a Map");
          debugPrint("   Keys: ${decoded.keys.join(', ')}");

          // Check for data array in response
          if (decoded['data'] != null && decoded['data'] is List) {
            debugPrint(
                "   Found 'data' array with ${decoded['data'].length} items");
            return decoded['data'] as List;
          } else if (decoded['transactions'] != null &&
              decoded['transactions'] is List) {
            debugPrint(
                "   Found 'transactions' array with ${decoded['transactions'].length} items");
            return decoded['transactions'] as List;
          }

          debugPrint("⚠️  [Base44] No expected array found in response");
        }

        debugPrint(
            "⚠️  [Base44] Unexpected response format, returning empty list");
        return [];
      }

      debugPrint("\n❌ [Base44] Error response (${res.statusCode})");
      try {
        final error = jsonDecode(res.body);
        debugPrint("   Error message: ${error["message"]}");
        throw Exception(error["message"] ?? "Error ${res.statusCode}");
      } catch (_) {
        debugPrint("   Could not parse error message");
        throw Exception("Error ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("\n❌ [Base44] Get transactions failed!");
      debugPrint("   Error: $e");
      debugPrint("   Error type: ${e.runtimeType}");
      throw _net(e);
    }
  }
}
