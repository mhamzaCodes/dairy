import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/milk_entry_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../main_navigation_screen.dart';
import '../milk/add_milk_entry_screen.dart';

/// Executive Dashboard View for Dairy Khata.
/// Displays greeting, summary metrics, weekly `fl_chart` BarChart, and quick action triggers.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller instances
    final authController = Get.find<AuthController>();
    final milkController = Get.find<MilkEntryController>();

    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final farmName = authController.userModel.value?.farmName ?? AppStrings.appName;
                    return Text(
                      farmName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: AppStrings.logout,
            onPressed: () => _confirmLogout(context, authController),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Greeting Header
            Obx(() {
              final name = authController.userModel.value?.name ?? 'Farmer';
              return Text(
                '${AppStrings.dashboardGreeting} $name 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              );
            }),
            const SizedBox(height: 16),

            // Comprehensive Production vs Sales Dashboard
            const Text(
              'Milk Breakdown (Today)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildComprehensiveBreakdown(milkController)),
            const SizedBox(height: 24),

            // Weekly Production Chart Section (fl_chart)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.weeklyOverview,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Last 7 Days',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Obx(() => _buildWeeklyBarChart(milkController)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Title
            const Text(
              AppStrings.quickActions,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Prominent Quick Action Grid Buttons (Large Touch Targets)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildActionButton(
                  title: AppStrings.addMilkEntry,
                  icon: Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                  onTap: () => Get.to(() => const AddMilkEntryScreen()),
                ),
                _buildActionButton(
                  title: AppStrings.navKhata,
                  icon: Icons.menu_book_rounded,
                  color: AppColors.secondaryDark,
                  onTap: () {
                    // Navigate to Khata Tab via bottom bar index 1
                    Get.find<MainNavigationController>().changeTab(1);
                  },
                ),
                _buildActionButton(
                  title: AppStrings.navHerd,
                  icon: Icons.pets_rounded,
                  color: AppColors.primaryDark,
                  onTap: () {
                    // Navigate to Herd Tab via bottom bar index 2
                    Get.find<MainNavigationController>().changeTab(2);
                  },
                ),
                _buildActionButton(
                  title: AppStrings.navBreeds,
                  icon: Icons.auto_stories_rounded,
                  color: AppColors.info,
                  onTap: () {
                    // Navigate to Encyclopedia Tab via bottom bar index 3
                    Get.find<MainNavigationController>().changeTab(3);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Activity Section
            const Text(
              AppStrings.recentTransactions,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            Obx(() {
              final entries = milkController.todayEntries;
              if (entries.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.note_add_outlined, size: 36, color: AppColors.textMuted),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.noDataYet,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = entries[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.shift == 'Morning'
                              ? AppColors.warningBg
                              : AppColors.infoBg,
                          child: Icon(
                            item.shift == 'Morning'
                                ? Icons.wb_sunny_rounded
                                : Icons.nightlight_round,
                            color: item.shift == 'Morning'
                                ? AppColors.warning
                                : AppColors.info,
                          ),
                        ),
                        title: Text(
                          '${item.shift} Shift - ${item.quantityLiters} L',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Rate: Rs. ${item.pricePerLiter.toStringAsFixed(0)}/L ${item.fatPercentage > 0 ? "| Fat: ${item.fatPercentage}%" : ""}',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Text(
                          'Rs. ${item.totalRevenue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds the new comprehensive milk breakdown grid
  Widget _buildComprehensiveBreakdown(MilkEntryController mc) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Row
          _buildBreakdownRow(
            title: 'TOTAL (Today)',
            produced: mc.todayTotalLiters,
            sold: mc.todayTotalSoldLiters,
            remaining: mc.todayTotalRemaining,
            bgColor: AppColors.primaryLight.withValues(alpha: 0.3),
            isBold: true,
          ),
          const Divider(height: 1, color: AppColors.border),
          // Morning Row
          _buildBreakdownRow(
            title: 'Morning ☀️',
            produced: mc.todayMorningLiters,
            sold: mc.todayMorningSoldLiters,
            remaining: mc.todayMorningRemaining,
            bgColor: AppColors.surface,
          ),
          const Divider(height: 1, color: AppColors.border),
          // Evening Row
          _buildBreakdownRow(
            title: 'Evening 🌙',
            produced: mc.todayEveningLiters,
            sold: mc.todayEveningSoldLiters,
            remaining: mc.todayEveningRemaining,
            bgColor: AppColors.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow({
    required String title,
    required double produced,
    required double sold,
    required double remaining,
    required Color bgColor,
    bool isBold = false,
  }) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: AppColors.textPrimary,
                fontSize: isBold ? 15 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildMetricMini('Produced', produced, AppColors.info, isBold),
          ),
          Expanded(
            flex: 2,
            child: _buildMetricMini('Sold', sold, AppColors.warning, isBold),
          ),
          Expanded(
            flex: 2,
            child: _buildMetricMini('Remain', remaining, remaining < 0 ? AppColors.error : AppColors.success, isBold),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricMini(String label, double val, Color color, bool isBold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${val.toStringAsFixed(1)}L',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
            fontSize: isBold ? 14 : 13,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds 7-day fl_chart BarChart for weekly milk volume
  Widget _buildWeeklyBarChart(MilkEntryController controller) {
    final dailyTotals = controller.weeklyLitersByDay;
    final now = DateTime.now();

    // Past 7 days day labels
    final dayLabels = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateFormat('E').format(date); // Mon, Tue, etc.
    });

    double maxVal = dailyTotals.fold(0.0, (max, v) => v > max ? v : max);
    if (maxVal < 10) maxVal = 50;

    return BarChart(
      BarChartData(
        maxY: maxVal * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${dayLabels[groupIndex]}\n${rod.toY.toStringAsFixed(1)} L',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == maxVal) return const SizedBox.shrink();
                return Text(
                  '${value.toInt()}L',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dayLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      dayLabels[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: AppColors.divider,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: dailyTotals[index],
                color: index == 6 ? AppColors.primary : AppColors.primaryAccent,
                width: 18,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Builds large touch action button
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthController authController) {
    Get.defaultDialog(
      title: AppStrings.logout,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      middleText: 'Are you sure you want to sign out?',
      textConfirm: AppStrings.confirm,
      textCancel: AppStrings.cancel,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        authController.logout();
      },
    );
  }
}
