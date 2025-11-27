import 'package:daftar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLanguageChange;
  final VoidCallback onRefresh;

  const PrimaryAppBar({
    super.key,
    required this.title,
    required this.onLanguageChange,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: onLanguageChange,
          tooltip: 'change_language'.tr,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'refresh'.tr,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
