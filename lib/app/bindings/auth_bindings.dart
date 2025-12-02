import 'package:daftar/presentation/auth/controllers/forgot_password_controller.dart';
import 'package:daftar/presentation/auth/controllers/signup_controller.dart';
import 'package:get/get.dart';
import '../../presentation/auth/controllers/login_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/base44_service_FIXED.dart';

/// Auth Binding
/// Manages dependency injection for authentication-related controllers
/// Follows GetX pattern for lazy loading dependencies
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Base44 API service
    Get.lazyPut<Base44Service>(
      () => Base44Service(),
      fenix: true,
    );

    // Auth repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        base44Service: Get.find<Base44Service>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<LoginController>(
      () => LoginController(
        authRepository: Get.find<AuthRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SignupController>(
      () => SignupController(
        authRepository: Get.find<AuthRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        authRepository: Get.find<AuthRepository>(),
      ),
      fenix: true,
    );
  }
}
