import '../../core/services/base44_service_FIXED.dart';
import '../models/user_model.dart';

/// Auth Repository
/// Handles all authentication-related data operations.
/// Works with Base44Service REST API.
class AuthRepository {
  final Base44Service _base44Service;

  AuthRepository({Base44Service? base44Service})
      : _base44Service = base44Service ?? Base44Service();

  /// -------------------------------------------------------
  /// LOGIN
  /// -------------------------------------------------------
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _base44Service.login(
        email: email,
        password: password,
      );

      final userData = _extractUser(response);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// REGISTER
  /// -------------------------------------------------------
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? organizationName,
    String? phone,
  }) async {
    try {
      final response = await _base44Service.register(
        email: email,
        password: password,
        fullName: fullName,
        organizationName: organizationName,
        phone: phone,
      );

      final userData = _extractUser(response);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// CURRENT USER
  /// -------------------------------------------------------
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _base44Service.getCurrentUser();

      final userData = _extractUser(response);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// GET SAVED USER (LOCAL)
  /// -------------------------------------------------------
  Future<UserModel?> getSavedUser() async {
    try {
      final Map<String, dynamic>? data =
          await _base44Service.getSavedUserData();
      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// -------------------------------------------------------
  /// LOGOUT
  /// -------------------------------------------------------
  Future<void> logout() async {
    try {
      await _base44Service.logout();
    } catch (_) {
      // always clear token even if API fails
      await _base44Service.clearAuthToken();
    }
  }

  /// -------------------------------------------------------
  /// PROFILE UPDATE
  /// -------------------------------------------------------
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? avatar,
  }) async {
    try {
      final response = await _base44Service.updateProfile(
        fullName: fullName,
        phone: phone,
        avatar: avatar,
      );

      final userData = _extractUser(response);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// AUTH STATUS
  /// -------------------------------------------------------
  Future<bool> isAuthenticated() async {
    try {
      return await _base44Service.isAuthenticated();
    } catch (_) {
      return false;
    }
  }

  Future<String?> getAuthToken() async {
    return await _base44Service.getAuthToken();
  }

  /// -------------------------------------------------------
  /// PASSWORD RESET
  /// -------------------------------------------------------
  Future<void> requestPasswordReset(String email) async {
    try {
      await _base44Service.requestPasswordReset(email);
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _base44Service.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// CHANGE PASSWORD
  /// -------------------------------------------------------
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _base44Service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// REFRESH TOKEN
  /// -------------------------------------------------------
  Future<bool> refreshToken() async {
    final newToken = await _base44Service.refreshToken();
    return newToken != null;
  }

  /// -------------------------------------------------------
  /// PRIVATE HELPERS
  /// -------------------------------------------------------

  /// Extract user JSON from ANY Base44 response shape
  Map<String, dynamic> _extractUser(Map<String, dynamic> response) {
    if (response['user'] != null) {
      return response['user'] as Map<String, dynamic>;
    }

    if (response['data'] != null &&
        response['data'] is Map &&
        response['data']['user'] != null) {
      return response['data']['user'] as Map<String, dynamic>;
    }

    if (response['data'] != null && response['data'] is Map) {
      return response['data'] as Map<String, dynamic>;
    }

    return response; // fallback
  }

  /// Clean error message for UI display
  String _cleanError(dynamic e) {
    return e.toString().replaceAll('Exception: ', '').trim();
  }

  Future<UserModel> googleLogin({
  required String idToken,
  required String accessToken,
}) async {
  final data = await _base44Service.googleLogin(
    idToken: idToken,
    accessToken: accessToken,
  );

  final user = data["user"] ?? data["data"]?["user"] ?? data["data"];
  if (user == null) {
    throw Exception("Google login returned no user");
  }

  return UserModel.fromJson(user);
}


}
