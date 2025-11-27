import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../app/theme/app_colors.dart';

/// Reset Password Screen
/// Enter new password with reset token
/// 
/// Design: 100% matches LoginScreen & SignupScreen
/// - Same background gradient
/// - Same card styling
/// - Same input fields
/// - Same button design
/// - Password strength indicator
/// - Full RTL support

class ResetPasswordScreen extends GetView<ForgotPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    // Get token from route arguments
    final token = Get.arguments as String?;
    if (token != null) {
      controller.setResetToken(token);
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildResetPasswordCard(context, isRTL),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildLanguageSwitcher(isRTL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Language Switcher Button (Top Right/Left)
  Widget _buildLanguageSwitcher(bool isRTL) {
    return Positioned(
      top: 16,
      right: isRTL ? null : 16,
      left: isRTL ? 16 : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _changeLanguage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  Get.locale?.languageCode == 'ar' ? 'English' : 'العربية',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeLanguage() {
    final current = Get.locale?.languageCode ?? 'ar';
    Get.updateLocale(
      current == 'ar' ? const Locale('en', 'US') : const Locale('ar', 'AE'),
    );

    Get.snackbar(
      'language_changed'.tr,
      'language_changed_message'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: Colors.white,
    );
  }

  /// Header with Logo and App Name
  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/icons/daftar_logo.png"),
        ),
        const SizedBox(height: 16),
        Text(
          'app_name'.tr,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Main Reset Password Card
  Widget _buildResetPasswordCard(BuildContext context, bool isRTL) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: controller.resetFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_open,
                  size: 48,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                isRTL ? 'إعادة تعيين كلمة المرور' : 'Reset Password',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                isRTL
                    ? 'أدخل كلمة المرور الجديدة الخاصة بك.'
                    : 'Enter your new password below.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Error Message
              _buildErrorMessage(),
              const SizedBox(height: 16),

              // New Password Field
              _buildNewPasswordField(context, isRTL),
              const SizedBox(height: 8),

              // Password Strength Indicator
              _buildPasswordStrengthIndicator(isRTL),
              const SizedBox(height: 20),

              // Confirm Password Field
              _buildConfirmPasswordField(context, isRTL),
              const SizedBox(height: 24),

              // Reset Button
              _buildResetButton(isRTL),
              const SizedBox(height: 24),

              // Back to Login Link
              _buildBackToLoginLink(isRTL),
            ],
          ),
        ),
      ),
    );
  }

  /// Error Message Display
  Widget _buildErrorMessage() {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.error.withOpacity(.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: AppColors.error,
              onPressed: () => controller.errorMessage.value = '',
            ),
          ],
        ),
      );
    });
  }

  /// New Password Field
  Widget _buildNewPasswordField(BuildContext context, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRTL ? 'كلمة المرور الجديدة' : 'New Password',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.newPasswordController,
            obscureText: !controller.isNewPasswordVisible.value,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            validator: controller.validatePassword,
            onChanged: (_) => controller.updatePasswordStrength(),
            decoration: InputDecoration(
              hintText: isRTL ? 'أدخل كلمة المرور الجديدة' : 'Enter new password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isNewPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: controller.toggleNewPasswordVisibility,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Password Strength Indicator
  Widget _buildPasswordStrengthIndicator(bool isRTL) {
    return Obx(() {
      final strength = controller.passwordStrength.value;
      if (strength == 0) return const SizedBox.shrink();

      Color strengthColor;
      String strengthText;

      if (strength < 30) {
        strengthColor = AppColors.error;
        strengthText = isRTL ? 'ضعيفة' : 'Weak';
      } else if (strength < 60) {
        strengthColor = AppColors.warning;
        strengthText = isRTL ? 'متوسطة' : 'Medium';
      } else {
        strengthColor = AppColors.success;
        strengthText = isRTL ? 'قوية' : 'Strong';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: strength / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                strengthText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: strengthColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  /// Confirm Password Field
  Widget _buildConfirmPasswordField(BuildContext context, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRTL ? 'تأكيد كلمة المرور' : 'Confirm Password',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.confirmNewPasswordController,
            obscureText: !controller.isConfirmNewPasswordVisible.value,
            textInputAction: TextInputAction.done,
            textDirection: TextDirection.ltr,
            validator: controller.validateConfirmPassword,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
              controller.resetPassword();
            },
            decoration: InputDecoration(
              hintText: isRTL ? 'أعد إدخال كلمة المرور' : 'Re-enter password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmNewPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: controller.toggleConfirmNewPasswordVisibility,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Reset Button
  Widget _buildResetButton(bool isRTL) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.resetPassword,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isRTL ? 'إعادة تعيين كلمة المرور' : 'Reset Password',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Back to Login Link
  Widget _buildBackToLoginLink(bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.arrow_back,
          size: 16,
          color: AppColors.textSecondary,
        ),
        TextButton(
          onPressed: controller.navigateToLogin,
          child: Text(
            isRTL ? 'العودة إلى تسجيل الدخول' : 'Back to Login',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}