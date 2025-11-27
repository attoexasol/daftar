import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';

/// Auth Middleware
/// Protects routes that require authentication
/// Redirects unauthenticated users to login screen
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1; // Higher priority = executes first

  @override
  RouteSettings? redirect(String? route) {
    // Simple synchronous redirect based on route
    // For full async check, use AsyncAuthMiddleware
    return null;
  }
}

/// Async Auth Middleware
/// Use this for routes that need async authentication check
class AsyncAuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final authRepository = AuthRepository();

    // Async check if user is authenticated
    final isAuthenticated = await authRepository.isAuthenticated();

    if (!isAuthenticated) {
      // Redirect to login with return URL
      return GetNavConfig.fromRoute('/login');
    }

    // User is authenticated, allow access
    return null;
  }
}

/// Role-Based Auth Middleware
/// Protects routes based on user role
class RoleAuthMiddleware extends GetMiddleware {
  final List<String> allowedRoles;

  RoleAuthMiddleware({required this.allowedRoles});

  @override
  int? get priority => 2; // After auth check

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final authRepository = AuthRepository();

    // Check if authenticated
    final isAuthenticated = await authRepository.isAuthenticated();
    if (!isAuthenticated) {
      return GetNavConfig.fromRoute('/login');
    }

    // Get current user
    try {
      final user = await authRepository.getCurrentUser();

      // Check if user has required role
      if (user.role != null && allowedRoles.contains(user.role)) {
        return null; // Allow access
      }

      // User doesn't have required role
      Get.snackbar(
        'Access Denied',
        'You do not have permission to access this page',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return GetNavConfig.fromRoute('/dashboard'); // Redirect to dashboard

    } catch (e) {
      // Error getting user, redirect to login
      return GetNavConfig.fromRoute('/login');
    }
  }
}

/// Admin Only Middleware
/// Shortcut for admin-only routes
class AdminMiddleware extends RoleAuthMiddleware {
  AdminMiddleware() : super(allowedRoles: ['admin', 'super_admin']);
}

/// Super Admin Only Middleware
/// Shortcut for super admin-only routes
class SuperAdminMiddleware extends RoleAuthMiddleware {
  SuperAdminMiddleware() : super(allowedRoles: ['super_admin']);
}

/// Guest Middleware
/// Prevents authenticated users from accessing guest-only routes (like login)
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final authRepository = AuthRepository();

    // Check if user is already authenticated
    final isAuthenticated = await authRepository.isAuthenticated();

    if (isAuthenticated) {
      // User is logged in, redirect to dashboard
      return GetNavConfig.fromRoute('/dashboard');
    }

    // User is not authenticated, allow access to guest route
    return null;
  }
}