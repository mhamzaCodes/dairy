import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'dashboard/dashboard_screen.dart';
import 'encyclopedia/breed_encyclopedia_screen.dart';
import 'herd/my_herd_screen.dart';
import 'khata/customer_khata_screen.dart';

/// GetX Navigation Controller managing active tab index
class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

/// Main Application Shell integrating Bottom Navigation Bar
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(MainNavigationController());

    final List<Widget> pages = [
      const DashboardScreen(),
      const CustomerKhataScreen(),
      const MyHerdScreen(),
      const BreedEncyclopediaScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Obx(() => GNav(
                  rippleColor: AppColors.primaryLight,
                  hoverColor: AppColors.primaryLight,
                  gap: 6,
                  activeColor: AppColors.primaryDark,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  duration: const Duration(milliseconds: 300),
                  tabBackgroundColor: AppColors.primaryLight,
                  color: AppColors.textSecondary,
                  selectedIndex: navController.currentIndex.value,
                  onTabChange: (index) {
                    navController.changeTab(index);
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.dashboard_rounded,
                      text: AppStrings.navHome,
                    ),
                    GButton(
                      icon: Icons.menu_book_rounded,
                      text: AppStrings.navKhata,
                    ),
                    GButton(
                      icon: Icons.pets_rounded,
                      text: AppStrings.navHerd,
                    ),
                    GButton(
                      icon: Icons.auto_stories_rounded,
                      text: AppStrings.navBreeds,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
