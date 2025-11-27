import 'package:daftar/presentation/splash/splash_screen.dart';
import 'package:get/get.dart';
//import 'package:daftar/presentation/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
