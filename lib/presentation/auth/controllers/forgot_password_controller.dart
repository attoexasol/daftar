import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

/// Forgot Password Controller
/// Manages forgot password and reset password flows
///
/// Features:
/// - Request password reset email
/// - Validate email
/// - Reset password with token
/// - Password strength calculation
/// - Form validation
/// - Error handling
/// - Success feedback

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository;

  ForgotPasswordController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Text editing controllers
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Form keys
  final formKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmNewPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final passwordStrength = 0.obs;
  final resetToken = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  /// ============================================
  /// STEP 1: REQUEST PASSWORD RESET
  /// ============================================

  /// Request password reset email
  Future<void> requestReset() async {
    // Reset messages
    errorMessage.value = '';
    successMessage.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Close keyboard safely
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    isLoading.value = true;

    try {
      debugPrint("Requesting password reset for: ${emailController.text}");

      await _authRepository.requestPasswordReset(emailController.text.trim());

      debugPrint("Password reset email sent successfully");

      // Show success message
      final isRTL = Get.locale?.languageCode == 'ar';
      successMessage.value = isRTL
          ? 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد الخاص بك.'
          : 'Password reset link has been sent to your email. Please check your inbox.';

      Get.snackbar(
        isRTL ? 'تم الإرسال بنجاح' : 'Email Sent',
        successMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 5),
      );

      // Clear email field
      emailController.clear();
    } catch (e) {
      debugPrint("Request reset failed: $e");

      errorMessage.value = e.toString().replaceAll("Exception: ", "");

      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'خطأ' : 'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ============================================
  /// STEP 2: RESET PASSWORD WITH TOKEN
  /// ============================================

  /// Set reset token (from email link or route arguments)
  void setResetToken(String token) {
    resetToken.value = token;
    debugPrint("Reset token set: $token");
  }

  /// Reset password with token
  Future<void> resetPassword() async {
    // Reset messages
    errorMessage.value = '';

    // Validate form
    if (!resetFormKey.currentState!.validate()) {
      return;
    }

    // Check token
    if (resetToken.value.isEmpty) {
      errorMessage.value = Get.locale?.languageCode == 'ar'
          ? 'رمز إعادة التعيين غير صالح'
          : 'Invalid reset token';
      return;
    }

    // Close keyboard safely
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    isLoading.value = true;

    try {
      debugPrint("Resetting password with token: ${resetToken.value}");

      await _authRepository.resetPassword(
        token: resetToken.value,
        newPassword: newPasswordController.text,
      );

      debugPrint("Password reset successfully");

      // Show success message
      final isRTL = Get.locale?.languageCode == 'ar';

      Get.snackbar(
        isRTL ? 'نجح' : 'Success',
        isRTL
            ? 'تم إعادة تعيين كلمة المرور بنجاح! يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.'
            : 'Password reset successfully! You can now login with your new password.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 4),
      );

      // Wait a bit, then navigate to login
      await Future.delayed(const Duration(milliseconds: 500));
      navigateToLogin();
    } catch (e) {
      debugPrint("Password reset failed: $e");

      errorMessage.value = e.toString().replaceAll("Exception: ", "");

      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'خطأ' : 'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ============================================
  /// VALIDATION METHODS
  /// ============================================

  /// Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'email_invalid'.tr;
    }
    return null;
  }

  /// Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;

    if (value.length < 8) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
          : 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمة المرور يجب أن تحتوي على حرف كبير'
          : 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمة المرور يجب أن تحتوي على حرف صغير'
          : 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمة المرور يجب أن تحتوي على رقم'
          : 'Password must contain at least one number';
    }

    return null;
  }

  /// Confirm Password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.locale?.languageCode == 'ar'
          ? 'تأكيد كلمة المرور مطلوب'
          : 'Confirm password is required';
    }

    if (value != newPasswordController.text) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمات المرور غير متطابقة'
          : 'Passwords do not match';
    }

    return null;
  }

  /// ============================================
  /// PASSWORD STRENGTH
  /// ============================================

  /// Update password strength indicator
  void updatePasswordStrength() {
    final password = newPasswordController.text;
    if (password.isEmpty) {
      passwordStrength.value = 0;
      return;
    }

    int strength = 0;

    // Length check
    if (password.length >= 8) strength += 20;
    if (password.length >= 12) strength += 10;

    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength += 15;

    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength += 15;

    // Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) strength += 20;

    // Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 20;

    passwordStrength.value = strength.clamp(0, 100);
  }

  /// ============================================
  /// TOGGLE METHODS
  /// ============================================

  /// Toggle new password visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  /// Toggle confirm new password visibility
  void toggleConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  /// ============================================
  /// NAVIGATION
  /// ============================================

  /// Navigate to login page
  void navigateToLogin() {
    Get.offAllNamed('/login');
  }

  /// Navigate to forgot password (from login)
  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  /// ============================================
  /// HELPER METHODS
  /// ============================================

  /// Clear all forms
  void clearForms() {
    emailController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    errorMessage.value = '';
    successMessage.value = '';
    passwordStrength.value = 0;
    resetToken.value = '';
  }

  /// Check if email is valid format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Resend reset email
  Future<void> resendResetEmail() async {
    if (emailController.text.isNotEmpty) {
      await requestReset();
    } else {
      errorMessage.value = Get.locale?.languageCode == 'ar'
          ? 'يرجى إدخال بريدك الإلكتروني'
          : 'Please enter your email';
    }
  }
}
