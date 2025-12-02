import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// Signup Controller
/// Manages signup screen state and business logic using GetX
/// Follows the same pattern as LoginController

class SignupController extends GetxController {
  final AuthRepository _authRepository;

  SignupController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final organizationController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final acceptTerms = false.obs;
  final passwordStrength = 0.obs;
  final currentUser = Rxn<UserModel>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _checkIfAlreadyAuthenticated();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    organizationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Check if user is already authenticated
  Future<void> _checkIfAlreadyAuthenticated() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        final user = await _authRepository.getCurrentUser();
        currentUser.value = user;
        navigateToDashboard();
      }
    } catch (e) {
      debugPrint("Auth check error: $e");
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Toggle accept terms
  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  /// Update password strength indicator
  void updatePasswordStrength() {
    final password = passwordController.text;
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

  /// Full Name validation
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return Get.locale?.languageCode == 'ar'
          ? 'الاسم الكامل مطلوب'
          : 'Full name is required';
    }
    if (value.trim().length < 3) {
      return Get.locale?.languageCode == 'ar'
          ? 'الاسم يجب أن يكون 3 أحرف على الأقل'
          : 'Name must be at least 3 characters';
    }
    return null;
  }

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

    if (value != passwordController.text) {
      return Get.locale?.languageCode == 'ar'
          ? 'كلمات المرور غير متطابقة'
          : 'Passwords do not match';
    }

    return null;
  }

  /// Google Signup
  Future<void> googleSignup() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? user = await googleSignIn.signIn();

      if (user == null) {
        isLoading.value = false;
        return; // User cancelled
      }

      final auth = await user.authentication;

      debugPrint("Google Access Token: ${auth.accessToken}");
      debugPrint("Google ID Token: ${auth.idToken}");

      // TODO: Send token to your backend for verification and registration
      // Example:
      // final response = await _authRepository.googleSignup(
      //   idToken: auth.idToken!,
      //   accessToken: auth.accessToken!,
      // );

      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'نجح' : 'Success',
        Get.locale?.languageCode == 'ar'
            ? 'تم التسجيل باستخدام Google'
            : 'Signed up with Google',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      // Navigate to dashboard after successful Google signup
      await Future.delayed(const Duration(milliseconds: 500));
      navigateToDashboard();
    } catch (e) {
      debugPrint("Google signup error: $e");
      
      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'خطأ' : 'Error',
        e.toString(),
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

  /// Perform signup
  Future<void> signup() async {
    // Reset messages
    errorMessage.value = '';
    successMessage.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check terms acceptance
    if (!acceptTerms.value) {
      errorMessage.value = Get.locale?.languageCode == 'ar'
          ? 'يجب الموافقة على الشروط والأحكام'
          : 'You must accept the Terms & Conditions';
      
      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'خطأ' : 'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Close keyboard safely
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    isLoading.value = true;

    try {
      debugPrint("Signing up...");

      final user = await _authRepository.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: fullNameController.text.trim(),
        organizationName: organizationController.text.trim().isEmpty
            ? null
            : organizationController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );

      currentUser.value = user;

      debugPrint("Signup success: ${user.email}");

      // Success feedback
      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'نجح التسجيل' : 'Signup Successful',
        Get.locale?.languageCode == 'ar'
            ? 'مرحباً ${user.fullName ?? user.email}'
            : 'Welcome ${user.fullName ?? user.email}!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to dashboard
      navigateToDashboard();
    } catch (e) {
      debugPrint("Signup failed: $e");

      errorMessage.value = e.toString().replaceAll("Exception: ", "");

      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'فشل التسجيل' : 'Signup Failed',
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

  /// Navigate to dashboard
  void navigateToDashboard() {
    Get.offAllNamed('/dashboard');
  }

  /// Navigate to login page
  void navigateToLogin() {
    Get.back();
    // or Get.offNamed('/login');
  }

  /// Show Terms and Conditions
  void showTermsAndConditions() {
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.dialog(
      AlertDialog(
        title: Text(
          isRTL ? 'الشروط والأحكام' : 'Terms & Conditions',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRTL
                    ? 'مرحباً بك في تطبيق دفتر. باستخدام خدماتنا، فإنك توافق على الشروط التالية:'
                    : 'Welcome to Daftar. By using our services, you agree to the following terms:',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildTermItem(
                isRTL ? '1. قبول الشروط' : '1. Acceptance of Terms',
                isRTL
                    ? 'باستخدام تطبيق دفتر، فإنك توافق على الالتزام بهذه الشروط والأحكام.'
                    : 'By using Daftar, you agree to be bound by these Terms and Conditions.',
              ),
              _buildTermItem(
                isRTL ? '2. استخدام الخدمة' : '2. Use of Service',
                isRTL
                    ? 'أنت توافق على استخدام الخدمة للأغراض القانونية فقط.'
                    : 'You agree to use the service for lawful purposes only.',
              ),
              _buildTermItem(
                isRTL ? '3. خصوصية البيانات' : '3. Data Privacy',
                isRTL
                    ? 'نحن نحترم خصوصيتك ونحمي بياناتك الشخصية وفقاً لسياسة الخصوصية.'
                    : 'We respect your privacy and protect your personal data according to our Privacy Policy.',
              ),
              _buildTermItem(
                isRTL ? '4. حقوق الملكية' : '4. Intellectual Property',
                isRTL
                    ? 'جميع المحتويات والشعارات محمية بحقوق الملكية الفكرية.'
                    : 'All content and logos are protected by intellectual property rights.',
              ),
              const SizedBox(height: 8),
              Text(
                isRTL
                    ? 'آخر تحديث: نوفمبر 2024'
                    : 'Last updated: November 2024',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(isRTL ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  /// Show Privacy Policy
  void showPrivacyPolicy() {
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.dialog(
      AlertDialog(
        title: Text(
          isRTL ? 'سياسة الخصوصية' : 'Privacy Policy',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRTL
                    ? 'نحن نقدر خصوصيتك ونلتزم بحماية معلوماتك الشخصية.'
                    : 'We value your privacy and are committed to protecting your personal information.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildTermItem(
                isRTL ? '1. المعلومات التي نجمعها' : '1. Information We Collect',
                isRTL
                    ? 'نجمع المعلومات التي تقدمها عند التسجيل مثل الاسم والبريد الإلكتروني.'
                    : 'We collect information you provide during registration such as name and email.',
              ),
              _buildTermItem(
                isRTL ? '2. كيف نستخدم المعلومات' : '2. How We Use Information',
                isRTL
                    ? 'نستخدم معلوماتك لتقديم وتحسين خدماتنا.'
                    : 'We use your information to provide and improve our services.',
              ),
              _buildTermItem(
                isRTL ? '3. حماية البيانات' : '3. Data Protection',
                isRTL
                    ? 'نستخدم تدابير أمنية لحماية بياناتك من الوصول غير المصرح به.'
                    : 'We use security measures to protect your data from unauthorized access.',
              ),
              _buildTermItem(
                isRTL ? '4. مشاركة المعلومات' : '4. Information Sharing',
                isRTL
                    ? 'لا نشارك معلوماتك الشخصية مع أطراف ثالثة بدون موافقتك.'
                    : 'We do not share your personal information with third parties without your consent.',
              ),
              const SizedBox(height: 8),
              Text(
                isRTL
                    ? 'آخر تحديث: نوفمبر 2024'
                    : 'Last updated: November 2024',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(isRTL ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Clear form
  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    organizationController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
    successMessage.value = '';
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    acceptTerms.value = false;
    passwordStrength.value = 0;
  }
}