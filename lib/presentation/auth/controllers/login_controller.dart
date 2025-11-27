import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// Login Controller
/// Manages login screen state and business logic using GetX
class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  final currentUser = Rxn<UserModel>();
  final rememberMe = false.obs;

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
    _checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Load saved user (local) if exists
  Future<void> _loadSavedCredentials() async {
    try {
      final savedUser = await _authRepository.getSavedUser();
      if (savedUser != null) {
        currentUser.value = savedUser;
      }
    } catch (e) {
      debugPrint('Error loading saved user: $e');
    }
  }

  /// Check if already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final ok = await _authRepository.isAuthenticated();
      if (ok) {
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

  /// Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
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
    if (value.length < 6) return 'password_min_length'.tr;
    return null;
  }

  //google signin
// GOOGLE SIGN-IN (FINAL IMPLEMENTATION)
Future<void> googleLogin() async {
  try {
    isLoading.value = true;
    errorMessage.value = "";

    final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "791926115955-qs91rdmdfprs3qnaqlpu113eqes22t00.apps.googleusercontent.com",
  scopes: ['email', 'profile'],
);

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      isLoading.value = false;
      return;
    }

    final googleAuth = await googleUser.authentication;

    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null || accessToken == null) {
      errorMessage.value = "Missing Google tokens";
      isLoading.value = false;
      return;
    }

    final user = await _authRepository.googleLogin(
      idToken: idToken,
      accessToken: accessToken,
    );

    currentUser.value = user;

    Get.snackbar(
      "Success",
      "Logged in with Google",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    navigateToDashboard();

  } catch (e) {
    errorMessage.value = e.toString().replaceAll("Exception: ", "");
    Get.snackbar(
      "Google Login Failed",
      errorMessage.value,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  } finally {
    isLoading.value = false;
  }
}



  /// Perform login
  Future<void> login() async {
    // Reset error
    errorMessage.value = '';

    if (!formKey.currentState!.validate()) return;

    // Close keyboard safely
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    isLoading.value = true;

    try {
      debugPrint("Logging in...");

      final user = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      currentUser.value = user;

      debugPrint("Login success: ${user.email}");

      // User feedback
      Get.snackbar(
        'login_success'.tr,
        'welcome_back'.trParams({'name': user.fullName ?? user.email ?? ''}),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      navigateToDashboard();
    } catch (e) {
      debugPrint("Login failed: $e");

      errorMessage.value = e.toString().replaceAll("Exception: ", "");

      Get.snackbar(
        'login_failed'.tr,
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

  /// Navigate to registration page
  void navigateToRegister() {
    Get.toNamed('/register');
  }

  /// Navigate to forgot password page
  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }


  /// Demo Login (optional)
  Future<void> demoLogin() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text('demo_mode'.tr),
        content: Text('demo_mode_description'.tr),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Get.back(result: false),
          ),
          ElevatedButton(
            child: Text('continue'.tr),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      emailController.text = "demo@daftar.com";
      passwordController.text = "demo123456";
      await login();
    }
  }

  /// Quick login for internal testing
  Future<void> quickLogin(String email, String password) async {
    emailController.text = email;
    passwordController.text = password;
    await login();
  }

  /// Refresh user data from backend
  Future<void> refreshUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      debugPrint("Refresh user error: $e");
    }
  }

  /// Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = '';
    isPasswordVisible.value = false;
  }
}
