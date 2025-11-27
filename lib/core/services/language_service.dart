import 'package:daftar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageService extends GetxService {
  static LanguageService get instance => Get.find<LanguageService>();

  /// Toggle language between Arabic & English
  Future<LanguageService> init() async {
    // Any future setup can be done here
    return this;
  }

  void toggleLanguage() {
    final currentLang = Get.locale?.languageCode ?? 'ar';

    if (currentLang == 'ar') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'AE'));
    }

    _showLanguageChangedSnackbar();
  }

  /// Snackbar for feedback
  void _showLanguageChangedSnackbar() {
    Get.snackbar(
      'language_changed'.tr,
      'language_changed_message'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
