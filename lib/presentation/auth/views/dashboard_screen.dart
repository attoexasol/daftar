import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_drawer.dart';
import '../../../core/services/language_service.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/models/transaction_model.dart';

/// Dashboard Screen
/// EXACT match with React Dashboard implementation
/// Uses DashboardController for real API data
class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: LanguageService.instance.toggleLanguage,
          ),
        ],
      ),
      drawer:  AppDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 768 ? 32 : 16,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(isRTL),
                const SizedBox(height: 32),

                // Stats Cards (matching React StatCard.jsx)
                _buildStatsGrid(isRTL),
                const SizedBox(height: 32),

                // Recent Transactions (matching React RecentTransactions.jsx)
                _buildRecentTransactions(isRTL),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Header matching React
  Widget _buildHeader(bool isRTL) {
    return Obx(() {
      final greeting = controller.getGreeting();
      final userName = controller.currentUser.value?.fullName ?? 'User';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRTL ? 'لوحة التحكم المالية' : 'Financial Dashboard',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$greeting, $userName!',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      );
    });
  }

  /// Stats Grid - EXACT match with React StatCard
  Widget _buildStatsGrid(bool isRTL) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 1024) crossAxisCount = 2;
        if (constraints.maxWidth < 640) crossAxisCount = 1;

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
                  trendValue: _formatCurrency(
                      controller.totalBalance.value.abs(), isRTL),
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
      },
    );
  }

  /// Stat Card - EXACT match with React StatCard.jsx
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required String color,
    required String trend,
    required String trendValue,
  }) {
    // Color mappings from React
    final colorGradients = {
      'blue': [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
      'green': [const Color(0xFF10B981), const Color(0xFF059669)],
      'red': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
      'purple': [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      'orange': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      'teal': [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
    };

    final gradientColors = colorGradients[color] ?? colorGradients['blue']!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
            // Top gradient line (matching React 1px height, full width)
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
                children: [
                  // Title and Icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors
                                .map((c) => c.withOpacity(0.1))
                                .toList(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          size: 24,
                          color: gradientColors[0],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Trend indicator
                  if (trend.isNotEmpty && trendValue.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          trend == 'up'
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 16,
                          color: trend == 'up'
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trendValue,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: trend == 'up'
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Transactions - EXACT match with React RecentTransactions.jsx
  Widget _buildRecentTransactions(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 20, color: Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                Text(
                  isRTL ? 'آخر المعاملات' : 'Recent Transactions',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: controller.navigateToTransactions,
              child: Text(isRTL ? 'عرض الكل' : 'View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Transactions Card
        Obx(() {
          final transactions = controller.recentTransactions;

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
              children: [
                // Card Header with gradient background
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF9FAFB), Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 20, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      Text(
                        isRTL ? 'آخر المعاملات' : 'Recent Transactions',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
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
                        isRTL
                            ? 'لا توجد معاملات حالياً'
                            : 'No transactions yet',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
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
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionItem(transaction, isRTL);
                    },
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Transaction Item - EXACT match with React
  Widget _buildTransactionItem(TransactionModel transaction, bool isRTL) {
    final isIncome = transaction.isIncome;
    final iconColor =
        isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final amountColor =
        isIncome ? const Color(0xFF059669) : const Color(0xFFDC2626);
    final bgColor =
        isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);

    return InkWell(
      onTap: () {
        // Transaction tap action
      },
      hoverColor: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon circle (matching React)
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
                      color: Color(0xFF111827),
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
                      color: Color(0xFF6B7280),
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
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    transaction.getCategoryDisplay(locale: isRTL ? 'ar' : 'en'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
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

  /// Format currency matching React: "${formatted} د.إ"
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
}
