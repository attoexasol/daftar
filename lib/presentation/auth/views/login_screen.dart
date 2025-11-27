import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../app/theme/app_colors.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  void _handleGoogleLogin() {
    controller.googleLogin(); // call controller method
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
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildLoginCard(context, isRTL),
                        const SizedBox(height: 24),
                        //_buildFooter(),
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
                Icon(Icons.language, size: 20, color: AppColors.primary),
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

  Widget _buildLoginCard(BuildContext context, bool isRTL) {
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
                'login_subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildGoogleButton(),
              const SizedBox(height: 30),
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
              _buildErrorMessage(),
              const SizedBox(height: 10),
              _buildEmailField(context, isRTL),
              const SizedBox(height: 30),
              _buildPasswordField(context, isRTL),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildForgotPasswordRow(isRTL),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Obx(
      () => OutlinedButton(
        onPressed: controller.isLoading.value ? null : _handleGoogleLogin,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                    "Continue with Google",
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
            Icon(Icons.error_outline, color: AppColors.error),
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

  Widget _buildEmailField(BuildContext context, bool isRTL) {
    return Builder(
      builder: (ctx) => Column(
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
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            validator: controller.validateEmail,
            onFieldSubmitted: (_) {
              FocusScope.of(ctx).nextFocus();
            },
            decoration: InputDecoration(
              hintText: 'email_hint'.tr,
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, bool isRTL) {
    return Builder(
      builder: (ctx) => Column(
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
              textInputAction: TextInputAction.done,
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              validator: controller.validatePassword,
              onFieldSubmitted: (_) {
                FocusScope.of(ctx).unfocus();
              },
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordRow(bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Row(
            children: [
              Checkbox(
                value: controller.rememberMe.value,
                onChanged: (_) => controller.toggleRememberMe(),
              ),
              Text('remember_me'.tr,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
        TextButton(
          onPressed: controller.navigateToForgotPassword,
          child: Text(
            'forgot_password'.tr,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.black,
          foregroundColor: Colors.white,
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
                  const Icon(Icons.login, size: 20),
                  const SizedBox(width: 8),
                  Text('login'.tr),
                ],
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Need an account?'.tr,
            style: const TextStyle(color: AppColors.textSecondary)),
        TextButton(
          onPressed: controller.navigateToRegister,
          child: Text(
            'Sign up'.tr,
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


  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              )),
        ],
      ),
    );
  }
}
