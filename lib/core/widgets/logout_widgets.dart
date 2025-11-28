import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/logout_service.dart';

/// Logout UI Components
/// Ready-to-use logout buttons, menu items, and widgets
///
/// Components:
/// - LogoutButton: Standard logout button
/// - LogoutIconButton: Icon-only logout button
/// - LogoutMenuItem: Drawer/menu list item
/// - LogoutAppBarAction: AppBar action button
/// - LogoutFloatingButton: Floating action button
/// - LogoutListTile: Settings page list tile

/// ============================================
/// 1. STANDARD LOGOUT BUTTON
/// ============================================

class LogoutButton extends StatelessWidget {
  final bool showIcon;
  final String? customText;
  final VoidCallback? onLogoutComplete;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? width;

  const LogoutButton({
    super.key,
    this.showIcon = true,
    this.customText,
    this.onLogoutComplete,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    return Obx(
      () => SizedBox(
        width: width ?? double.infinity,
        child: ElevatedButton(
          onPressed: logoutService.isLoggingOut.value
              ? null
              : () async {
                  await logoutService.logout();
                  onLogoutComplete?.call();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.error,
            foregroundColor: textColor ?? Colors.white,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: logoutService.isLoggingOut.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showIcon) ...[
                      const Icon(Icons.logout, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      customText ?? (isRTL ? 'تسجيل الخروج' : 'Logout'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// ============================================
/// 2. ICON-ONLY LOGOUT BUTTON
/// ============================================

class LogoutIconButton extends StatelessWidget {
  final Color? iconColor;
  final double? iconSize;
  final String? tooltip;
  final VoidCallback? onLogoutComplete;

  const LogoutIconButton({
    super.key,
    this.iconColor,
    this.iconSize,
    this.tooltip,
    this.onLogoutComplete,
  });

  @override
  Widget build(BuildContext context) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    return Obx(
      () => IconButton(
        onPressed: logoutService.isLoggingOut.value
            ? null
            : () async {
                await logoutService.logout();
                onLogoutComplete?.call();
              },
        icon: logoutService.isLoggingOut.value
            ? SizedBox(
                width: iconSize ?? 24,
                height: iconSize ?? 24,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.logout,
                color: iconColor ?? AppColors.error,
                size: iconSize ?? 24,
              ),
        tooltip: tooltip ?? (isRTL ? 'تسجيل الخروج' : 'Logout'),
      ),
    );
  }
}

/// ============================================
/// 3. DRAWER/MENU LIST ITEM
/// ============================================

class LogoutMenuItem extends StatelessWidget {
  final bool showDividerAbove;
  final VoidCallback? onLogoutComplete;
  final EdgeInsets? padding;

  const LogoutMenuItem({
    super.key,
    this.showDividerAbove = true,
    this.onLogoutComplete,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    return Column(
      children: [
        if (showDividerAbove) const Divider(),
        Obx(
          () => ListTile(
            enabled: !logoutService.isLoggingOut.value,
            contentPadding:
                padding ?? const EdgeInsets.symmetric(horizontal: 16),
            leading: logoutService.isLoggingOut.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
            title: Text(
              isRTL ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            subtitle: logoutService.isLoggingOut.value
                ? Text(
                    isRTL ? 'جاري تسجيل الخروج...' : 'Logging out...',
                    style: const TextStyle(fontSize: 12),
                  )
                : null,
            onTap: logoutService.isLoggingOut.value
                ? null
                : () async {
                    await logoutService.logout();
                    onLogoutComplete?.call();
                  },
          ),
        ),
      ],
    );
  }
}

/// ============================================
/// 4. APPBAR ACTION BUTTON
/// ============================================

class LogoutAppBarAction extends StatelessWidget {
  final VoidCallback? onLogoutComplete;

  const LogoutAppBarAction({
    super.key,
    this.onLogoutComplete,
  });

  @override
  Widget build(BuildContext context) {
    return LogoutIconButton(
      iconColor: AppColors.textPrimary,
      tooltip: Get.locale?.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout',
      onLogoutComplete: onLogoutComplete,
    );
  }
}

/// ============================================
/// 5. FLOATING ACTION BUTTON
/// ============================================

class LogoutFloatingButton extends StatelessWidget {
  final VoidCallback? onLogoutComplete;
  final String? label;
  final Color? backgroundColor;

  const LogoutFloatingButton({
    super.key,
    this.onLogoutComplete,
    this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    return Obx(
      () => FloatingActionButton.extended(
        onPressed: logoutService.isLoggingOut.value
            ? null
            : () async {
                await logoutService.logout();
                onLogoutComplete?.call();
              },
        backgroundColor: backgroundColor ??
            (logoutService.isLoggingOut.value ? Colors.grey : AppColors.error),
        icon: logoutService.isLoggingOut.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.logout),
        label: Text(
          label ?? (isRTL ? 'تسجيل الخروج' : 'Logout'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// ============================================
/// 6. SETTINGS PAGE LIST TILE
/// ============================================

class LogoutListTile extends StatelessWidget {
  final VoidCallback? onLogoutComplete;

  const LogoutListTile({
    super.key,
    this.onLogoutComplete,
  });

  @override
  Widget build(BuildContext context) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          enabled: !logoutService.isLoggingOut.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: logoutService.isLoggingOut.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.error,
                  ),
                )
              : const Icon(
                  Icons.logout,
                  color: AppColors.error,
                ),
          title: Text(
            isRTL ? 'تسجيل الخروج' : 'Logout',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          subtitle: Text(
            isRTL ? 'إنهاء جلستك الحالية' : 'End your current session',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.error.withOpacity(0.7),
            ),
          ),
          trailing: Icon(
            isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
            color: AppColors.error,
            size: 16,
          ),
          onTap: logoutService.isLoggingOut.value
              ? null
              : () async {
                  await logoutService.logout();
                  onLogoutComplete?.call();
                },
        ),
      ),
    );
  }
}

/// ============================================
/// 7. DANGER ZONE CARD
/// ============================================

class LogoutDangerZone extends StatelessWidget {
  final VoidCallback? onLogoutComplete;

  const LogoutDangerZone({
    super.key,
    this.onLogoutComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                const SizedBox(width: 12),
                Text(
                  isRTL ? 'منطقة الخطر' : 'Danger Zone',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRTL ? 'تسجيل الخروج من حسابك' : 'Logout from your account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isRTL
                      ? 'سيؤدي هذا إلى إنهاء جلستك الحالية وسيتعين عليك تسجيل الدخول مرة أخرى.'
                      : 'This will end your current session and you will need to login again.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                LogoutButton(
                  onLogoutComplete: onLogoutComplete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================
/// 8. BOTTOM SHEET LOGOUT
/// ============================================

class LogoutBottomSheet {
  static void show({VoidCallback? onLogoutComplete}) {
    final logoutService = Get.find<LogoutService>();
    final isRTL = Get.locale?.languageCode == 'ar';

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isRTL ? 'تسجيل الخروج؟' : 'Logout?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              isRTL
                  ? 'هل أنت متأكد أنك تريد إنهاء جلستك؟'
                  : 'Are you sure you want to end your session?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isRTL ? 'إلغاء' : 'Cancel',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back(); // Close bottom sheet
                      await logoutService.logout(showConfirmation: false);
                      onLogoutComplete?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isRTL ? 'تسجيل الخروج' : 'Logout',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
