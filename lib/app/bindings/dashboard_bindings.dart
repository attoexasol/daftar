import 'package:daftar/presentation/auth/controllers/dashboard_controller.dart';
import 'package:daftar/presentation/auth/controllers/drawer_controller.dart';
import 'package:get/get.dart';

/// Dashboard Binding
/// Handles dependency injection for Dashboard screen
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );

    Get.lazyPut(() => DrawerMenuController());

  }
}
