import 'package:daftar/presentation/auth/controllers/forgot_password_controller.dart';
import 'package:daftar/presentation/auth/controllers/signup_controller.dart';
import 'package:get/get.dart';
import '../../presentation/auth/controllers/login_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/base44_service.dart';

/// Auth Binding
/// Manages dependency injection for authentication-related controllers
/// Follows GetX pattern for lazy loading dependencies
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register Base44 Service
    Get.lazyPut<Base44Service>(
      () => Base44Service(),
      fenix: true,
    );

    // Register Auth Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        base44Service: Get.find<Base44Service>(),
      ),
      fenix: true,
    );

    // Register Login Controller
    Get.lazyPut<LoginController>(
      () => LoginController(
        authRepository: Get.find<AuthRepository>(),
      ),
    );

    Get.lazyPut<SignupController>(() => SignupController());

    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
