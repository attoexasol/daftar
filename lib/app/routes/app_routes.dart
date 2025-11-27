import 'package:daftar/app/bindings/splash_binding.dart';
import 'package:daftar/presentation/auth/views/forgot_password_screen.dart';
import 'package:daftar/presentation/auth/views/owner_screen.dart';
import 'package:daftar/presentation/auth/views/reset_password_screen.dart';
import 'package:daftar/presentation/auth/views/signup_screen.dart';
import 'package:daftar/presentation/auth/views/subscription_screen.dart';
import 'package:daftar/presentation/auth/views/technical_doc_screen.dart';
import 'package:get/get.dart';

import '../../presentation/auth/views/login_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/auth/views/dashboard_screen.dart';

import '../bindings/auth_bindings.dart';
import '../bindings/dashboard_bindings.dart';
import '../middlewares/auth_middleware.dart';

/// Splash Binding
/// Initializes dependencies for splash screen

/// App Routes
/// Central routing configuration for the application
class AppRoutes {
  // Route names
  static const String initial = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  //static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String invoices = '/invoices';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String customers = '/customers';
  static const String suppliers = '/suppliers';
  static const technicalDoc = '/technical-doc';
  static const subscription = '/subscription';
  static const owner = '/owner';
  static const forgotPassword = '/forgot-password';


  // Routes list
  static final routes = [
    // Splash Screen
    // ✔ CORRECT
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
      binding: SplashBinding(), // ✔ correct
    ),

    // Login Screen
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      middlewares: [GuestMiddleware()], // Prevent logged-in users
    ),

    // Dashboard Screen (Protected Route)
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      //middlewares: [AsyncAuthMiddleware()], // Require authentication
    ),

    GetPage(
      name: AppRoutes.technicalDoc,
      page: () => const TechnicalDocScreen(),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
    ),
    GetPage(
      name: AppRoutes.owner,
      page: () => const OwnerScreen(),
    ),

    // TODO: Add more routes as screens are implemented

    // Register Screen
    // lib/app/routes/app_routes.dart
    GetPage(
      name: '/register',
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),

    // lib/app/routes/app_routes.dart
GetPage(
  name: '/forgot-password',
  page: () => const ForgotPasswordScreen(),
  binding: AuthBinding(),
),
GetPage(
  name: '/reset-password',
  page: () => const ResetPasswordScreen(),
  binding: AuthBinding(),
),

    // Transactions Screen
    // GetPage(
    //   name: transactions,
    //   page: () => const TransactionsScreen(),
    //   binding: TransactionsBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AsyncAuthMiddleware()],
    // ),

    // Invoices Screen
    // GetPage(
    //   name: invoices,
    //   page: () => const InvoicesScreen(),
    //   binding: InvoicesBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AsyncAuthMiddleware()],
    // ),

    // Reports Screen
    // GetPage(
    //   name: reports,
    //   page: () => const ReportsScreen(),
    //   binding: ReportsBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AsyncAuthMiddleware()],
    // ),

    // Settings Screen
    // GetPage(
    //   name: settings,
    //   page: () => const SettingsScreen(),
    //   binding: SettingsBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AsyncAuthMiddleware()],
    // ),

    // Profile Screen
    // GetPage(
    //   name: profile,
    //   page: () => const ProfileScreen(),
    //   binding: ProfileBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AsyncAuthMiddleware()],
    // ),

    // Admin-only routes
    // GetPage(
    //   name: '/admin/users',
    //   page: () => const UsersScreen(),
    //   binding: UsersBinding(),
    //   transition: Transition.fadeIn,
    //   middlewares: [AdminMiddleware()],
    // ),
  ];
}
