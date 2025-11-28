import 'package:daftar/app/routes/app_routes.dart';
import 'package:daftar/core/widgets/logout_widgets.dart';
import 'package:daftar/presentation/auth/controllers/drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final DrawerMenuController controller = Get.find<DrawerMenuController>();

  void _onMenuTap(int index, BuildContext context) {
    controller.selectedIndex.value = index;
    Navigator.pop(context);

    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.technicalDoc);
        break;
      case 1:
        Get.toNamed(AppRoutes.subscription);
        break;
      case 2:
        Get.toNamed(AppRoutes.owner);
        break;
      case 3:
        Get.toNamed(AppRoutes.dashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildMenuItems(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const Divider(height: 5),
          _buildLanguageSelector(),
          const SizedBox(height: 20),
          _buildUserSection(context),
          const SizedBox(height: 20),
          _buildFooter(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // 1. HEADER (Logo + Text)
  // ------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xff407BFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.trending_up, color: Colors.white),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daftar - Smart\nAccounting\nSystem",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Comprehensive Financial\nManagement with AI",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // 2. MAIN MENU
  // ------------------------------------------------------
  Widget _buildMenuItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            "MAIN MENU",
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),

        // index 0 - Technical Documentation
        _menuItem(
          index: 0,
          icon: Icons.menu_book,
          title: "Technical Documentation",
          badge: "PDF",
          badgeColor: Colors.purple,
          badgeTextColor: Colors.white,
        ),

        // index 1 - Subscription Plans
        _menuItem(
          index: 1,
          icon: Icons.payments_outlined,
          title: "Subscription Plans",
          badge: "New",
          badgeColor: Colors.deepPurpleAccent,
          badgeTextColor: Colors.white,
        ),

        // index 2 - Owner
        _menuItem(
          index: 2,
          icon: Icons.person_outline,
          title: "Owner",
          badge: "Start\nHere",
          badgeColor: Colors.blue,
          badgeTextColor: Colors.white,
          multiLineBadge: true,
        ),

        // index 3 - Dashboard
        _menuItem(
          index: 3,
          icon: Icons.dashboard_outlined,
          title: "Dashboard",
        ),
      ],
    );
  }

  // menu item widget with animation + active highlight
  Widget _menuItem({
    required int index,
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
    bool multiLineBadge = false,
  }) {
    return Obx(() {
      final bool isActive = controller.selectedIndex.value == index;

      final Color bgColor =
          isActive ? const Color(0xffe9f1ff) : Colors.transparent;

      final Color iconColor =
          isActive ? const Color(0xff407BFF) : Colors.black87;
      final Color textColor =
          isActive ? const Color(0xff407BFF) : Colors.black87;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onMenuTap(index, Get.context!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: bgColor,
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 15, color: textColor),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: multiLineBadge ? 8 : 10,
                      vertical: multiLineBadge ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: badgeTextColor,
                        height: multiLineBadge ? 1.1 : 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ------------------------------------------------------
  // 3. LANGUAGE SECTION (BOTTOM)
  // ------------------------------------------------------
  Widget _buildLanguageSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.language, size: 18),
                SizedBox(width: 6),
                Text("English"),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "GB EN",
              style: TextStyle(fontSize: 11),
            ),
          )
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // 4. USER INFO SECTION (BOTTOM)
  // ------------------------------------------------------
  Widget _buildUserSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue,
            child: Text("D", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Demo User",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "demo@example.com",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // 5. FOOTER (BOTTOM)
  // ------------------------------------------------------
  Widget _buildFooter() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        SizedBox(height: 4),
        Text(
          "Terms of Service",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        SizedBox(height: 20),
        LogoutMenuItem(),
      ],
    );
  }
}
