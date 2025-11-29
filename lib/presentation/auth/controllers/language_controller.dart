// class LanguageController extends GetxController {
//   var selectedLang = 'en'.obs;

//   @override
//   void onInit() {
//     selectedLang.value = Get.locale?.languageCode ?? "en";
//     super.onInit();
//   }

//   Future<void> changeLanguage(String code) async {
//     selectedLang.value = code;
//     Get.updateLocale(Locale(code));

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("app_lang", code);
//   }
// }
