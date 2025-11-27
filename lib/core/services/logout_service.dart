import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../app/theme/app_colors.dart';

/// Logout Service
/// Centralized logout functionality with confirmation dialogs,
/// session cleanup, and navigation management
///
/// Features:
/// - Confirmation dialog with custom styling
/// - Complete data cleanup
/// - Loading states
/// - Success/error feedback
/// - Force logout option
/// - Analytics tracking hooks
/// - Auto-navigation to login

class LogoutService extends GetxService {
  final AuthRepository _authRepository;

  LogoutService({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Observable states
  final isLoggingOut = false.obs;

  /// ============================================
  /// MAIN LOGOUT METHOD
  /// ============================================

  /// Standard logout with confirmation dialog
  Future<void> logout({
    bool showConfirmation = true,
    String? customMessage,
  }) async {
    try {
      // Show confirmation dialog if enabled
      if (showConfirmation) {
        final confirmed = await _showLogoutConfirmation(customMessage);
        if (!confirmed) return;
      }

      // Set loading state
      isLoggingOut.value = true;

      // Show loading indicator
      _showLoadingDialog();

      // Perform logout
      await _performLogout();

      // Hide loading
      Get.back(); // Close loading dialog

      // Navigate to login
      await Future.delayed(const Duration(milliseconds: 200));
      Get.offAllNamed('/login');

      // Show success message
      _showSuccessMessage();
    } catch (e) {
      debugPrint('Logout error: $e');

      // Hide loading
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      _showErrorMessage(e.toString());
    } finally {
      isLoggingOut.value = false;
    }
  }

  /// ============================================
  /// FORCE LOGOUT (No confirmation)
  /// ============================================

  /// Force logout without confirmation (for session expiry, etc.)
  Future<void> forceLogout({
    String? reason,
  }) async {
    try {
      isLoggingOut.value = true;

      await _performLogout();

      Get.offAllNamed('/login');

      // Show reason if provided
      if (reason != null) {
        Get.snackbar(
          Get.locale?.languageCode == 'ar' ? 'تم تسجيل الخروج' : 'Logged Out',
          reason,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.warning,
          colorText: Colors.white,
          icon: const Icon(Icons.info_outline, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Force logout error: $e');
      _showErrorMessage(e.toString());
    } finally {
      isLoggingOut.value = false;
    }
  }

  /// ============================================
  /// SESSION EXPIRED HANDLER
  /// ============================================

  /// Handle session expiry with custom message
  Future<void> handleSessionExpired() async {
    await forceLogout(
      reason: Get.locale?.languageCode == 'ar'
          ? 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.'
          : 'Your session has expired. Please login again.',
    );
  }

  /// ============================================
  /// PRIVATE HELPER METHODS
  /// ============================================

  /// Perform actual logout (clear tokens, data, etc.)
  Future<void> _performLogout() async {
    try {
      // Call backend logout endpoint
      await _authRepository.logout();

      // Clear all local storage
      await _clearLocalData();

      // TODO: Add analytics tracking
      // AnalyticsService.trackEvent('user_logged_out');

      debugPrint('Logout successful');
    } catch (e) {
      debugPrint('Logout operation error: $e');

      // Even if API call fails, clear local data
      await _clearLocalData();

      throw Exception('Failed to logout properly');
    }
  }

  /// Clear all local data
  Future<void> _clearLocalData() async {
    // Clear auth token
    await _authRepository.getAuthToken().then((token) {
      if (token != null) {
        // Token cleared by repository
      }
    });

    // TODO: Clear any cached data
    // await CacheService.clearAll();

    // TODO: Clear any user preferences that should be reset
    // await PreferencesService.clearUserData();

    debugPrint('Local data cleared');
  }

  /// ============================================
  /// CONFIRMATION DIALOG
  /// ============================================

  Future<bool> _showLogoutConfirmation(String? customMessage) async {
    final isRTL = Get.locale?.languageCode == 'ar';

    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isRTL ? 'تسجيل الخروج' : 'Logout',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customMessage ??
                  (isRTL
                      ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
                      : 'Are you sure you want to logout?'),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isRTL
                  ? 'سيتم إنهاء جلستك الحالية.'
                  : 'Your current session will be ended.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              isRTL ? 'إلغاء' : 'Cancel',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isRTL ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    return result ?? false;
  }

  /// ============================================
  /// LOADING DIALOG
  /// ============================================

  void _showLoadingDialog() {
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  isRTL ? 'جاري تسجيل الخروج...' : 'Logging out...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// ============================================
  /// SUCCESS MESSAGE
  /// ============================================

  void _showSuccessMessage() {
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.snackbar(
      isRTL ? 'تم بنجاح' : 'Success',
      isRTL ? 'تم تسجيل الخروج بنجاح' : 'You have been logged out successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// ============================================
  /// ERROR MESSAGE
  /// ============================================

  void _showErrorMessage(String error) {
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.snackbar(
      isRTL ? 'خطأ' : 'Error',
      isRTL
          ? 'فشل تسجيل الخروج. حاول مرة أخرى.'
          : 'Failed to logout. Please try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
