import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../app/theme/app_colors.dart';

/// Signup Screen
/// Complete registration implementation matching LoginScreen design
/// 
/// Features:
/// - Email & Password registration
/// - Google Sign Up integration
/// - Full name, organization, phone fields
/// - Password strength indicator
/// - Confirm password validation
/// - Terms & conditions acceptance
/// - Full RTL support
/// - Responsive design
/// - Error handling
/// - Loading states
/// 
/// Follows exact design patterns from LoginScreen

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  void _handleGoogleSignup() {
    controller.googleSignup();
  }

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
                        const SizedBox(height: 40),
                        _buildSignupCard(context, isRTL),
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


  /// Main Signup Card
  Widget _buildSignupCard(BuildContext context, bool isRTL) {
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
              Text(
                isRTL ? 'إنشاء حساب جديد' : 'Create New Account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isRTL
                    ? 'انضم إلينا وابدأ إدارة حساباتك بسهولة'
                    : 'Join us and start managing your accounts easily',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Google Signup Button
              _buildGoogleButton(isRTL),
              const SizedBox(height: 24),

              // Divider with "OR"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR'.tr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 8),

              // Error Message
              _buildErrorMessage(),
              const SizedBox(height: 10),

              // Email Field
              _buildEmailField(context, isRTL),
              const SizedBox(height: 20),

              // Password Field
              _buildPasswordField(context, isRTL),
              const SizedBox(height: 8),

              // Password Strength Indicator
              _buildPasswordStrengthIndicator(isRTL),
              const SizedBox(height: 20),

              // Confirm Password Field
              _buildConfirmPasswordField(context, isRTL),
              const SizedBox(height: 20),

              // Terms & Conditions Checkbox
              _buildTermsCheckbox(isRTL),
              const SizedBox(height: 24),

              // Signup Button
              _buildSignupButton(isRTL),
              const SizedBox(height: 24),

              // Login Link
              _buildLoginLink(isRTL),
            ],
          ),
        ),
      ),
    );
  }

  /// Google Signup Button
  Widget _buildGoogleButton(bool isRTL) {
    return Obx(
      () => OutlinedButton(
        onPressed: controller.isLoading.value ? null : _handleGoogleSignup,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/google.png",
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isRTL ? 'التسجيل باستخدام Google' : 'Sign up with Google',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.ltr,
          validator: controller.validateEmail,
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


  /// Password Field
  Widget _buildPasswordField(BuildContext context, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'password'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            validator: controller.validatePassword,
            onChanged: (_) => controller.updatePasswordStrength(),
            decoration: InputDecoration(
              hintText: 'password_hint'.tr,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: controller.togglePasswordVisibility,
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
            controller: controller.confirmPasswordController,
            obscureText: !controller.isConfirmPasswordVisible.value,
            textInputAction: TextInputAction.done,
            textDirection: TextDirection.ltr,
            validator: controller.validateConfirmPassword,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
              if (controller.acceptTerms.value) {
                controller.signup();
              }
            },
            decoration: InputDecoration(
              hintText: isRTL ? 'أعد إدخال كلمة المرور' : 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: controller.toggleConfirmPasswordVisibility,
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

  /// Terms & Conditions Checkbox
  Widget _buildTermsCheckbox(bool isRTL) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: controller.acceptTerms.value,
              onChanged: (_) => controller.toggleAcceptTerms(),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  isRTL ? 'أوافق على ' : 'I agree to the ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: controller.showTermsAndConditions,
                  child: Text(
                    isRTL ? 'الشروط والأحكام' : 'Terms & Conditions',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  isRTL ? ' و' : ' and ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: controller.showPrivacyPolicy,
                  child: Text(
                    isRTL ? 'سياسة الخصوصية' : 'Privacy Policy',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Signup Button
  Widget _buildSignupButton(bool isRTL) {
    return Obx(
      () => ElevatedButton(
        onPressed: (controller.isLoading.value || !controller.acceptTerms.value)
            ? null
            : controller.signup,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.black,
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
                  const Icon(Icons.person_add, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isRTL ? 'إنشاء حساب' : 'Create Account',
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

  /// Login Link
  Widget _buildLoginLink(bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isRTL ? 'لديك حساب بالفعل؟' : 'Already have an account?',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: controller.navigateToLogin,
          child: Text(
            isRTL ? 'تسجيل الدخول' : 'Sign In',
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