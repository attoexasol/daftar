import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../app/theme/app_colors.dart';

/// Forgot Password Screen
/// Request password reset email implementation
///
/// Design: 100% matches LoginScreen & SignupScreen
/// - Same background gradient
/// - Same card styling
/// - Same input fields
/// - Same button design
/// - Same language switcher
/// - Full RTL support

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

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
                        //_buildHeader(),
                        const SizedBox(height: 40),
                        _buildForgotPasswordCard(context, isRTL),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildLanguageSwitcher(isRTL),
                //_buildBackButton(isRTL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // /// Back Button (Top Left/Right)
  // Widget _buildBackButton(bool isRTL) {
  //   return Positioned(
  //     top: 16,
  //     left: isRTL ? null : 16,
  //     right: isRTL ? 16 : null,
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: () => Get.back(),
  //         borderRadius: BorderRadius.circular(12),
  //         child: Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.9),
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.1),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Icon(
  //             isRTL ? Icons.arrow_forward : Icons.arrow_back,
  //             size: 20,
  //             color: AppColors.textPrimary,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
  // Widget _buildHeader() {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 40,
  //         backgroundImage: AssetImage("assets/icons/daftar_logo.png"),
  //       ),
  //       const SizedBox(height: 16),
  //       Text(
  //         'app_name'.tr,
  //         style: const TextStyle(
  //           fontSize: 32,
  //           fontWeight: FontWeight.bold,
  //           color: AppColors.textPrimary,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  /// Main Forgot Password Card
  Widget _buildForgotPasswordCard(BuildContext context, bool isRTL) {
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
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: AppColors.primary.withOpacity(0.1),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Icon(
              //     Icons.lock_reset,
              //     size: 48,
              //     color: AppColors.primary,
              //   ),
              // ),
              // const SizedBox(height: 24),

              // Title
              _buildBackToLoginLink(isRTL),
              const SizedBox(height: 24),

              Text(
                isRTL ? 'إعادة تعيين كلمة المرور' : 'Reset Your Password',
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
                    ? 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.'
                    : 'Enter your email and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Success Message
              _buildSuccessMessage(isRTL),

              // Error Message
              _buildErrorMessage(),
              const SizedBox(height: 16),

              // Email Field
              _buildEmailField(context, isRTL),
              const SizedBox(height: 24),

              // Reset Button
              _buildResetButton(isRTL),
              const SizedBox(height: 24),

              // Back to Login Link
            ],
          ),
        ),
      ),
    );
  }

  /// Success Message Display
  Widget _buildSuccessMessage(bool isRTL) {
    return Obx(() {
      if (controller.successMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withOpacity(.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRTL ? 'تم الإرسال بنجاح!' : 'Email Sent!',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.successMessage.value,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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

  /// Email Field
  Widget _buildEmailField(BuildContext context, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'email'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.ltr,
          validator: controller.validateEmail,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
            controller.requestReset();
          },
          decoration: InputDecoration(
            hintText: 'email_hint'.tr,
            prefixIcon: const Icon(Icons.email_outlined),
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
      ],
    );
  }

  /// Reset Button
  Widget _buildResetButton(bool isRTL) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.requestReset,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Color(0xff1E293B),
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
                  // const Icon(Icons.send, size: 20),
                  // const SizedBox(width: 8),
                  Text(
                    isRTL ? 'إرسال رابط إعادة التعيين' : 'Send reset link',
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.arrow_back,
          size: 16,
          color: AppColors.textSecondary,
        ),
        TextButton(
          onPressed: controller.navigateToLogin,
          child: Text(
            isRTL ? 'العودة إلى تسجيل الدخول' : 'Back to Sign In',
            style: const TextStyle(
              color: AppColors.gray500,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
