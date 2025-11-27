import 'package:daftar/core/services/language_service.dart';
import 'package:daftar/core/services/logout_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_routes.dart';
import 'core/localization/app_translations.dart';

Future<void> main() async {
  Get.config(logWriterCallback: (text, {bool? isError}) {
    // Custom minimal logging
  });
  await Get.putAsync(() => LanguageService().init());
  runApp(const MyApp());

  Get.put(LogoutService(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daftar',

      // Translations
      translations: AppTranslations(),
      locale: const Locale('ar', 'AE'), // Default: Arabic
      fallbackLocale: const Locale('en', 'US'),

      // Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // Or your preferred Arabic font
      ),

      //home: DashboardScreen(),
      // Routes
      initialRoute: AppRoutes.initial, // '/splash'
      getPages: AppRoutes.routes,

      // Debugging
      debugShowCheckedModeBanner: false,
    );
  }
}
