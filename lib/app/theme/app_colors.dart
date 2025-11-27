import 'package:flutter/material.dart';

/// App Colors
/// Defines the color palette matching the React application
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark = Color(0xFF2563EB); // Blue-600
  static const Color primaryLight = Color(0xFF60A5FA); // Blue-400

  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6); // Purple-500
  static const Color secondaryDark = Color(0xFF7C3AED); // Purple-600
  static const Color secondaryLight = Color(0xFFA78BFA); // Purple-400

  // Success Colors
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color successDark = Color(0xFF059669); // Green-600
  static const Color successLight = Color(0xFF34D399); // Green-400

  // Error Colors
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorDark = Color(0xFFDC2626); // Red-600
  static const Color errorLight = Color(0xFFF87171); // Red-400

  // Warning Colors
  static const Color warning = Color(0xFFF59E0B); // Orange-500
  static const Color warningDark = Color(0xFFD97706); // Orange-600
  static const Color warningLight = Color(0xFFFBBF24); // Orange-400

  // Info Colors
  static const Color info = Color(0xFF06B6D4); // Cyan-500
  static const Color infoDark = Color(0xFF0891B2); // Cyan-600
  static const Color infoLight = Color(0xFF22D3EE); // Cyan-400

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Background Colors
  static const Color background = Color(0xFFF9FAFB); // gray-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6); // gray-100

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textTertiary = Color(0xFF9CA3AF); // gray-400
  static const Color textDisabled = Color(0xFFD1D5DB); // gray-300

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)], // blue to purple
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFEFF6FF), // blue-50
      Color(0xFFFAF5FF), // purple-50
      Color(0xFFFCE7F3), // pink-50
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadow = Color(0x1A000000); // black with 10% opacity
  static const Color shadowLight = Color(0x0D000000); // black with 5% opacity
  static const Color shadowDark = Color(0x33000000); // black with 20% opacity

  // Border Colors
  static const Color border = Color(0xFFE5E7EB); // gray-200
  static const Color borderLight = Color(0xFFF3F4F6); // gray-100
  static const Color borderDark = Color(0xFFD1D5DB); // gray-300

  // Input Colors
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE5E7EB); // gray-200
  static const Color inputFocusBorder = Color(0xFF3B82F6); // primary
  static const Color inputErrorBorder = Color(0xFFEF4444); // error
  static const Color inputDisabledBackground = Color(0xFFF9FAFB); // gray-50

  // Status Colors
  static const Color statusDraft = Color(0xFF9CA3AF); // gray-400
  static const Color statusPending = Color(0xFFF59E0B); // warning
  static const Color statusApproved = Color(0xFF10B981); // success
  static const Color statusRejected = Color(0xFFEF4444); // error
  static const Color statusPaid = Color(0xFF10B981); // success
  static const Color statusOverdue = Color(0xFFEF4444); // error

  // Special Colors
  static const Color income = Color(0xFF10B981); // green-500
  static const Color expense = Color(0xFFEF4444); // red-500
  static const Color profit = Color(0xFF8B5CF6); // purple-500
}
