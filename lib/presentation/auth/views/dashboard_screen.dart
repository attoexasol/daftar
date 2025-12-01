import 'package:daftar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/widgets/app_drawer.dart';
import '../../../core/services/language_service.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/models/transaction_model.dart';

/// Dashboard Screen
/// 100% EXACT match with React Dashboard.jsx implementation
/// Includes all charts: Bar Chart, Pie Chart, Line Chart
class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: LanguageService.instance.toggleLanguage,
          ),
        ],
      ),
      drawer: AppDrawer(),
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF9FAFB), // gray-50
                Color(0xFFEFF6FF), // blue-50
              ],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 768 ? 32 : 16,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(isRTL),
                  const SizedBox(height: 32),

                  // Stats Cards
                  _buildStatsGrid(isRTL, screenWidth),
                  const SizedBox(height: 32),

                  // Charts Section
                  _buildChartsSection(isRTL, screenWidth),
                  const SizedBox(height: 32),

                  // Profit Trend Line Chart
                  _buildProfitTrendChart(isRTL),
                  const SizedBox(height: 32),

                  // Recent Transactions
                  _buildRecentTransactions(isRTL),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Header - EXACT match with React
  Widget _buildHeader(bool isRTL) {
    final now = DateTime.now();
    final greeting = controller.getGreeting();
    final userName = controller.currentUser.value?.fullName ?? 'User';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRTL ? 'لوحة التحكم المالية' : 'Financial Dashboard',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(now, isRTL),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed('/transactions'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isRTL ? 'معاملة جديدة' : 'New Transaction',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Stats Grid - EXACT match with React StatCard
  Widget _buildStatsGrid(bool isRTL, double screenWidth) {
    int crossAxisCount = 4;
    if (screenWidth < 1024) crossAxisCount = 2;
    if (screenWidth < 640) crossAxisCount = 1;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: crossAxisCount == 1 ? 2.5 : 1.8,
      children: [
        // Total Balance
        Obx(() => _buildStatCard(
              title: isRTL ? 'الرصيد الإجمالي' : 'Total Balance',
              value: _formatCurrency(controller.totalBalance.value, isRTL),
              subtitle: isRTL ? 'إجمالي الأموال' : 'Total Money',
              icon: Icons.account_balance_wallet,
              color: 'blue',
              trend: controller.totalBalance.value >= 0 ? 'up' : 'down',
              trendValue:
                  _formatCurrency(controller.totalBalance.value.abs(), isRTL),
            )),

        // Month Income
        Obx(() => _buildStatCard(
              title: isRTL ? 'إيرادات الشهر' : 'Month Income',
              value: _formatCurrency(controller.monthIncome.value, isRTL),
              subtitle: _getMonthName(DateTime.now(), isRTL),
              icon: Icons.trending_up,
              color: 'green',
              trend: 'up',
              trendValue:
                  '${controller.getIncomeTransactions().length} ${isRTL ? 'معاملة' : 'transactions'}',
            )),

        // Month Expense
        Obx(() => _buildStatCard(
              title: isRTL ? 'مصروفات الشهر' : 'Month Expense',
              value: _formatCurrency(controller.monthExpense.value, isRTL),
              subtitle: _getMonthName(DateTime.now(), isRTL),
              icon: Icons.trending_down,
              color: 'red',
              trend: 'down',
              trendValue:
                  '${controller.getExpenseTransactions().length} ${isRTL ? 'معاملة' : 'transactions'}',
            )),

        // Net Profit
        Obx(() => _buildStatCard(
              title: isRTL ? 'صافي الربح' : 'Net Profit',
              value: _formatCurrency(controller.monthProfit.value, isRTL),
              subtitle: isRTL ? 'الشهر الحالي' : 'Current Month',
              icon: Icons.analytics,
              color: controller.monthProfit.value >= 0 ? 'teal' : 'orange',
              trend: controller.monthProfit.value >= 0 ? 'up' : 'down',
              trendValue: controller.monthIncome.value > 0
                  ? '${((controller.monthProfit.value / controller.monthIncome.value) * 100).toStringAsFixed(1)}%'
                  : '0%',
            )),
      ],
    );
  }

  /// Stat Card Widget - EXACT match with React
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required String color,
    required String trend,
    required String trendValue,
  }) {
    final colorGradients = {
      'blue': [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
      'green': [const Color(0xFF10B981), const Color(0xFF059669)],
      'red': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
      'purple': [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      'orange': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      'teal': [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
    };

    final gradientColors = colorGradients[color] ?? colorGradients['blue']!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top gradient line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((c) => c.withOpacity(0.1))
                              .toList(),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: gradientColors[0],
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Value
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle and Trend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          trend == 'up'
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 14,
                          color: trend == 'up'
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trendValue,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: trend == 'up'
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Charts Section - Bar Chart and Pie Chart
  Widget _buildChartsSection(bool isRTL, double screenWidth) {
    final isDesktop = screenWidth > 1024;

    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRevenueExpenseChart(isRTL),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildExpenseDistributionChart(isRTL),
              ),
            ],
          )
        : Column(
            children: [
              _buildRevenueExpenseChart(isRTL),
              const SizedBox(height: 24),
              _buildExpenseDistributionChart(isRTL),
            ],
          );
  }

  /// Revenue and Expenses Bar Chart - EXACT match with React
  Widget _buildRevenueExpenseChart(bool isRTL) {
    final monthlyData = _getMonthlyData(isRTL);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Colors.white],
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              isRTL
                  ? 'الإيرادات والمصروفات (آخر 6 أشهر)'
                  : 'Revenue and Expenses (Last 6 Months)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Chart
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(monthlyData) * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: AppColors.gray800,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final month = monthlyData[groupIndex]['month'];
                        final value = rod.toY;
                        return BarTooltipItem(
                          '$month\n${_formatCurrency(value, isRTL)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= monthlyData.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyData[value.toInt()]['month'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatShortCurrency(value),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getMaxValue(monthlyData) * 0.2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.gray200,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    monthlyData.length,
                    (index) {
                      final data = monthlyData[index];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data['income'],
                            color: const Color(0xFF10B981),
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          BarChartRodData(
                            toY: data['expense'],
                            color: const Color(0xFFEF4444),
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  isRTL ? 'الإيرادات' : 'Revenue',
                  const Color(0xFF10B981),
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  isRTL ? 'المصروفات' : 'Expenses',
                  const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expense Distribution Pie Chart - EXACT match with React
  Widget _buildExpenseDistributionChart(bool isRTL) {
    final categoryData = _getCategoryData(isRTL);
    final currentMonth = _getMonthName(DateTime.now(), isRTL);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Colors.white],
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.pie_chart,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${isRTL ? 'توزيع المصروفات' : 'Expense Distribution'} - $currentMonth',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chart
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300,
              child: categoryData.isEmpty
                  ? Center(
                      child: Text(
                        isRTL
                            ? 'لا توجد مصروفات هذا الشهر'
                            : 'No expenses this month',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: List.generate(
                          categoryData.length,
                          (index) {
                            final data = categoryData[index];
                            final total = categoryData.fold<double>(
                              0,
                              (sum, item) => sum + item['value'],
                            );
                            final percentage = (data['value'] / total) * 100;

                            final colors = [
                              const Color(0xFF3B82F6),
                              const Color(0xFF10B981),
                              const Color(0xFFF59E0B),
                              const Color(0xFFEF4444),
                              const Color(0xFF8B5CF6),
                              const Color(0xFFEC4899),
                            ];

                            return PieChartSectionData(
                              color: colors[index % colors.length],
                              value: data['value'],
                              title: '${percentage.toStringAsFixed(0)}%',
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              badgeWidget: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  data['name'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              badgePositionPercentageOffset: 1.3,
                            );
                          },
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {},
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profit Trend Line Chart - EXACT match with React
  Widget _buildProfitTrendChart(bool isRTL) {
    final monthlyData = _getMonthlyData(isRTL);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Colors.white],
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              isRTL ? 'تطور الأرباح' : 'Profit Trend',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Chart
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getMaxProfit(monthlyData) * 0.25,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.gray200,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= monthlyData.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyData[value.toInt()]['month'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatShortCurrency(value),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: _getMinProfit(monthlyData),
                  maxY: _getMaxProfit(monthlyData) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        monthlyData.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          monthlyData[index]['profit'],
                        ),
                      ),
                      isCurved: true,
                      color: const Color(0xFF3B82F6),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: const Color(0xFF3B82F6),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: AppColors.gray800,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final month = monthlyData[spot.x.toInt()]['month'];
                          return LineTooltipItem(
                            '$month\n${_formatCurrency(spot.y, isRTL)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Center(
              child: _buildLegendItem(
                isRTL ? 'الربح' : 'Profit',
                const Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Recent Transactions - EXACT match with React
  Widget _buildRecentTransactions(bool isRTL) {
    return Obx(() {
      final transactions = controller.recentTransactions.take(10).toList();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9FAFB), Colors.white],
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    isRTL ? 'آخر المعاملات' : 'Latest Transactions',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Transactions List or Empty State
            if (transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    isRTL ? 'لا توجد معاملات حالياً' : 'No transactions yet',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppColors.gray200,
                ),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _buildTransactionItem(transaction, isRTL);
                },
              ),
          ],
        ),
      );
    });
  }

  /// Transaction Item - EXACT match with React
  Widget _buildTransactionItem(TransactionModel transaction, bool isRTL) {
    final isIncome = transaction.isIncome;
    final iconColor = isIncome ? AppColors.success : AppColors.error;
    final amountColor = isIncome ? AppColors.successDark : AppColors.errorDark;
    final bgColor =
        isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);

    return InkWell(
      onTap: () {
        // Transaction tap action
      },
      hoverColor: AppColors.gray50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon circle
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: iconColor,
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    transaction.description ??
                        (isIncome ? 'Income' : 'Expense'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Date
                  Text(
                    _formatTransactionDate(transaction.date, isRTL),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Amount and category
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Amount with +/- prefix
                Text(
                  '${isIncome ? '+' : '-'}${_formatCurrency(transaction.amount ?? 0, isRTL)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.gray300),
                  ),
                  child: Text(
                    transaction.getCategoryDisplay(locale: isRTL ? 'en' : 'ar'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Legend Item Widget
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // HELPER METHODS - Data Processing
  // ============================================================================

  /// Get monthly data for last 6 months
  List<Map<String, dynamic>> _getMonthlyData(bool isRTL) {
    final data = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthStart = DateTime(monthDate.year, monthDate.month, 1);
      final monthEnd = DateTime(monthDate.year, monthDate.month + 1, 0);

      // Get month name
      final monthName = isRTL
          ? _getArabicMonthShort(monthDate.month)
          : DateFormat('MMM').format(monthDate);

      // Filter transactions for this month
      final monthTransactions = controller.transactions.where((t) {
        if (t.date == null) return false;
        return t.date!.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            t.date!.isBefore(monthEnd.add(const Duration(days: 1)));
      }).toList();

      // Calculate income and expense
      double income = 0.0;
      double expense = 0.0;

      for (var t in monthTransactions) {
        if (t.amount != null) {
          if (t.isIncome) {
            income += t.amount!;
          } else if (t.isExpense) {
            expense += t.amount!;
          }
        }
      }

      data.add({
        'month': monthName,
        'income': income,
        'expense': expense,
        'profit': income - expense,
      });
    }

    return data;
  }

  /// Get category data for current month
  List<Map<String, dynamic>> _getCategoryData(bool isRTL) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    // Filter month transactions
    final monthTransactions = controller.transactions.where((t) {
      if (t.date == null) return false;
      return t.date!.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          t.date!.isBefore(monthEnd.add(const Duration(days: 1)));
    }).toList();

    // Group by category (only expenses)
    final categoryTotals = <String, double>{};

    for (var t in monthTransactions) {
      if (t.isExpense && t.category != null && t.amount != null) {
        categoryTotals[t.category!] =
            (categoryTotals[t.category!] ?? 0) + t.amount!;
      }
    }

    // Convert to list with localized names
    final categoryLabels = isRTL
        ? {
            'salaries': 'رواتب',
            'rent': 'إيجار',
            'utilities': 'مرافق',
            'purchases': 'مشتريات',
            'marketing': 'تسويق',
            'transportation': 'مواصلات',
            'maintenance': 'صيانة',
            'taxes': 'ضرائب',
            'other_expense': 'أخرى',
          }
        : {
            'salaries': 'Salaries',
            'rent': 'Rent',
            'utilities': 'Utilities',
            'purchases': 'Purchases',
            'marketing': 'Marketing',
            'transportation': 'Transportation',
            'maintenance': 'Maintenance',
            'taxes': 'Taxes',
            'other_expense': 'Other',
          };

    return categoryTotals.entries.map((entry) {
      return {
        'name': categoryLabels[entry.key] ?? entry.key,
        'value': entry.value,
      };
    }).toList();
  }

  // ============================================================================
  // HELPER METHODS - Formatting & Calculations
  // ============================================================================

  /// Format currency matching React
  String _formatCurrency(double amount, bool isRTL) {
    final formatted =
        amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final result = parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
    return '$result ${isRTL ? 'د.إ' : 'AED'}';
  }

  /// Format short currency for charts
  String _formatShortCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Format transaction date
  String _formatTransactionDate(DateTime? date, bool isRTL) {
    if (date == null) return '';

    if (isRTL) {
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format full date
  String _formatDate(DateTime date, bool isRTL) {
    if (isRTL) {
      final days = [
        'الأحد',
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت'
      ];
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${days[date.weekday % 7]}، ${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  /// Get month name
  String _getMonthName(DateTime date, bool isRTL) {
    if (isRTL) {
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return months[date.month - 1];
    }

    return DateFormat('MMMM').format(date);
  }

  /// Get Arabic month abbreviation
  String _getArabicMonthShort(int month) {
    const months = [
      'ينا',
      'فبر',
      'مار',
      'أبر',
      'ماي',
      'يون',
      'يول',
      'أغس',
      'سبت',
      'أكت',
      'نوف',
      'ديس'
    ];
    return months[month - 1];
  }

  /// Get max value from monthly data for chart scaling
  double _getMaxValue(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var item in data) {
      if (item['income'] > max) max = item['income'];
      if (item['expense'] > max) max = item['expense'];
    }
    return max > 0 ? max : 1000;
  }

  /// Get max profit for chart scaling
  double _getMaxProfit(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var item in data) {
      if (item['profit'] > max) max = item['profit'];
    }
    return max > 0 ? max : 1000;
  }

  /// Get min profit for chart scaling
  double _getMinProfit(List<Map<String, dynamic>> data) {
    double min = 0;
    for (var item in data) {
      if (item['profit'] < min) min = item['profit'];
    }
    return min < 0 ? min * 1.2 : 0;
  }
}
