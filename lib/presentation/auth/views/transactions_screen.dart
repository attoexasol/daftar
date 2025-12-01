import 'package:daftar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/language_service.dart';
import '../controllers/transactions_controller.dart';
import '../../../data/models/transaction_model.dart';

/// Transactions Screen
/// 100% EXACT match with React Transactions.jsx implementation
/// FIXED: All GetX/Obx errors resolved
class TransactionsScreen extends GetView<TransactionsController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(isRTL ? 'المعاملات المالية' : 'Financial Transactions'),
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
      backgroundColor: const Color(0xFFF9FAFB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTransactions,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 768 ? 32 : 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with New Transaction Button
                _buildHeader(isRTL, screenWidth),
                const SizedBox(height: 24),

                // Summary Cards (3 cards)
                _buildSummaryCards(isRTL, screenWidth),
                const SizedBox(height: 24),

                // Filters and Search
                _buildFiltersCard(isRTL, screenWidth),
                const SizedBox(height: 24),

                // Transactions Table
                _buildTransactionsTable(isRTL),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Header - EXACT match with React
  Widget _buildHeader(bool isRTL, double screenWidth) {
    final isDesktop = screenWidth > 768;

    return isDesktop
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderTitle(isRTL),
              _buildNewTransactionButton(isRTL),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTitle(isRTL),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _buildNewTransactionButton(isRTL),
              ),
            ],
          );
  }

  Widget _buildHeaderTitle(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRTL ? 'المعاملات المالية' : 'Financial Transactions',
          style: const TextStyle(
            fontSize: 30, // text-3xl
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827), // text-gray-900
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isRTL ? 'إدارة الإيرادات والمصروفات' : 'Manage Income and Expenses',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280), // text-gray-600
          ),
        ),
      ],
    );
  }

  Widget _buildNewTransactionButton(bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF2563EB)
          ], // blue-500 to blue-600
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
          onTap: () => controller.openNewTransactionDialog(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 20),
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
    );
  }

  /// Summary Cards - EXACT match with React (3 cards)
  /// FIXED: Proper Obx usage with .value access
  Widget _buildSummaryCards(bool isRTL, double screenWidth) {
    final isDesktop = screenWidth > 768;

    return Obx(() {
      // FIXED: Access .value for each observable
      final totalIncome = controller.totalIncome.value;
      final totalExpense = controller.totalExpense.value;
      final netProfit = totalIncome - totalExpense;

      return isDesktop
          ? Row(
              children: [
                Expanded(
                    child: _buildSummaryCard(
                  title: isRTL ? 'إجمالي الإيرادات' : 'Total Income',
                  value: totalIncome,
                  icon: Icons.arrow_upward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0FDF4), Colors.white], // from-green-50
                  ),
                  valueColor: const Color(0xFF059669), // text-green-600
                  iconBgColor: const Color(0xFFD1FAE5), // bg-green-100
                  iconColor: const Color(0xFF059669), // text-green-600
                  isRTL: isRTL,
                )),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildSummaryCard(
                  title: isRTL ? 'إجمالي المصروفات' : 'Total Expenses',
                  value: totalExpense,
                  icon: Icons.arrow_downward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEF2F2), Colors.white], // from-red-50
                  ),
                  valueColor: const Color(0xFFDC2626), // text-red-600
                  iconBgColor: const Color(0xFFFEE2E2), // bg-red-100
                  iconColor: const Color(0xFFDC2626), // text-red-600
                  isRTL: isRTL,
                )),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildSummaryCard(
                  title: isRTL ? 'صافي الربح' : 'Net Profit',
                  value: netProfit,
                  icon: Icons.arrow_upward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFF6FF), Colors.white], // from-blue-50
                  ),
                  valueColor: netProfit >= 0
                      ? const Color(0xFF2563EB) // text-blue-600
                      : const Color(0xFFEA580C), // text-orange-600
                  iconBgColor: const Color(0xFFDBEAFE), // bg-blue-100
                  iconColor: const Color(0xFF2563EB), // text-blue-600
                  isRTL: isRTL,
                )),
              ],
            )
          : Column(
              children: [
                _buildSummaryCard(
                  title: isRTL ? 'إجمالي الإيرادات' : 'Total Income',
                  value: totalIncome,
                  icon: Icons.arrow_upward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0FDF4), Colors.white],
                  ),
                  valueColor: const Color(0xFF059669),
                  iconBgColor: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                  isRTL: isRTL,
                ),
                const SizedBox(height: 24),
                _buildSummaryCard(
                  title: isRTL ? 'إجمالي المصروفات' : 'Total Expenses',
                  value: totalExpense,
                  icon: Icons.arrow_downward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEF2F2), Colors.white],
                  ),
                  valueColor: const Color(0xFFDC2626),
                  iconBgColor: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626),
                  isRTL: isRTL,
                ),
                const SizedBox(height: 24),
                _buildSummaryCard(
                  title: isRTL ? 'صافي الربح' : 'Net Profit',
                  value: netProfit,
                  icon: Icons.arrow_upward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFF6FF), Colors.white],
                  ),
                  valueColor: netProfit >= 0
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFEA580C),
                  iconBgColor: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                  isRTL: isRTL,
                ),
              ],
            );
    });
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
    required LinearGradient gradient,
    required Color valueColor,
    required Color iconBgColor,
    required Color iconColor,
    required bool isRTL,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14, // text-sm
                      color: Color(0xFF6B7280), // text-gray-600
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(value, isRTL),
                    style: TextStyle(
                      fontSize: 30, // text-3xl
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),

            // Right side: Icon
            Container(
              padding: const EdgeInsets.all(16), // p-4
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12), // rounded-xl
              ),
              child: Icon(
                icon,
                size: 32, // w-8 h-8
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Filters Card - EXACT match with React
  /// FIXED: Proper Obx usage
  Widget _buildFiltersCard(bool isRTL, double screenWidth) {
    final isDesktop = screenWidth > 768;

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isDesktop
            ? Row(
                children: [
                  // Search field
                  Expanded(
                    child: _buildSearchField(isRTL),
                  ),
                  const SizedBox(width: 16),

                  // Filter dropdown
                  SizedBox(
                    width: 200,
                    child: _buildFilterDropdown(isRTL),
                  ),
                  const SizedBox(width: 16),

                  // Export button
                  _buildExportButton(isRTL),
                ],
              )
            : Column(
                children: [
                  _buildSearchField(isRTL),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildFilterDropdown(isRTL)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildExportButton(isRTL)),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchField(bool isRTL) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: isRTL ? 'البحث في المعاملات...' : 'Search transactions...',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) => controller.searchTerm.value = value,
    );
  }

  Widget _buildFilterDropdown(bool isRTL) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.filterType.value,
              isExpanded: true,
              icon: const Icon(Icons.filter_list, size: 16),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text(isRTL ? 'جميع المعاملات' : 'All Transactions'),
                ),
                DropdownMenuItem(
                  value: 'income',
                  child: Text(isRTL ? 'الإيرادات فقط' : 'Income Only'),
                ),
                DropdownMenuItem(
                  value: 'expense',
                  child: Text(isRTL ? 'المصروفات فقط' : 'Expenses Only'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.filterType.value = value;
                }
              },
            ),
          ),
        ));
  }

  Widget _buildExportButton(bool isRTL) {
    return OutlinedButton(
      onPressed: () => controller.exportToCSV(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.download, size: 16, color: Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Text(
            isRTL ? 'تصدير Excel' : 'Export Excel',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Transactions Table - EXACT match with React
  /// FIXED: Proper Obx usage for filtered transactions
  Widget _buildTransactionsTable(bool isRTL) {
    return Obx(() {
      // FIXED: Access filteredTransactions as a getter
      final transactions = controller.filteredTransactions;

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
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                '${isRTL ? 'سجل المعاملات' : 'Transaction History'} (${transactions.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            // Table
            if (transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(64),
                child: Center(
                  child: Text(
                    isRTL ? 'لا توجد معاملات' : 'No transactions',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 20,
                  columns: [
                    DataColumn(label: Text(isRTL ? 'التاريخ' : 'Date')),
                    DataColumn(label: Text(isRTL ? 'النوع' : 'Type')),
                    DataColumn(label: Text(isRTL ? 'التصنيف' : 'Category')),
                    DataColumn(
                        label: Text(
                            isRTL ? 'العميل/المورد' : 'Customer/Supplier')),
                    DataColumn(label: Text(isRTL ? 'المبلغ' : 'Amount')),
                    DataColumn(
                        label: Text(isRTL ? 'طريقة الدفع' : 'Payment Method')),
                    DataColumn(label: Text(isRTL ? 'الإجراءات' : 'Actions')),
                  ],
                  rows: transactions.map((transaction) {
                    return DataRow(
                      cells: [
                        DataCell(Text(_formatDate(transaction.date, isRTL))),
                        DataCell(_buildTypeBadge(transaction.isIncome, isRTL)),
                        DataCell(Text(
                            _getCategoryLabel(transaction.category, isRTL))),
                        DataCell(Text(transaction.customerSupplier ?? '-')),
                        DataCell(Text(
                          '${transaction.isIncome ? '+' : '-'}${_formatCurrency(transaction.amount ?? 0, isRTL)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction.isIncome
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                          ),
                        )),
                        DataCell(Text(_getPaymentMethodLabel(
                            transaction.paymentMethod, isRTL))),
                        DataCell(_buildActionButtons(transaction)),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTypeBadge(bool isIncome, bool isRTL) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isIncome ? (isRTL ? 'إيراد' : 'Income') : (isRTL ? 'مصروف' : 'Expense'),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isIncome ? const Color(0xFF059669) : const Color(0xFFDC2626),
        ),
      ),
    );
  }

  Widget _buildActionButtons(TransactionModel transaction) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, size: 18),
          onPressed: () => controller.viewTransaction(transaction),
          tooltip: 'View',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          onPressed: () => controller.deleteTransaction(transaction.id!),
          tooltip: 'Delete',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

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

  String _formatDate(DateTime? date, bool isRTL) {
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

    return DateFormat('d MMM yyyy').format(date);
  }

  String _getCategoryLabel(String? category, bool isRTL) {
    final labels = isRTL
        ? {
            'sales': 'مبيعات',
            'services': 'خدمات',
            'other_income': 'دخل آخر',
            'salaries': 'رواتب',
            'rent': 'إيجار',
            'utilities': 'مرافق',
            'purchases': 'مشتريات',
            'marketing': 'تسويق',
            'transportation': 'مواصلات',
            'maintenance': 'صيانة',
            'taxes': 'ضرائب',
            'other_expense': 'مصروف آخر',
          }
        : {
            'sales': 'Sales',
            'services': 'Services',
            'other_income': 'Other Income',
            'salaries': 'Salaries',
            'rent': 'Rent',
            'utilities': 'Utilities',
            'purchases': 'Purchases',
            'marketing': 'Marketing',
            'transportation': 'Transportation',
            'maintenance': 'Maintenance',
            'taxes': 'Taxes',
            'other_expense': 'Other Expense',
          };

    return labels[category] ?? category ?? '';
  }

  String _getPaymentMethodLabel(String? method, bool isRTL) {
    final labels = isRTL
        ? {
            'cash': 'نقداً',
            'bank_transfer': 'تحويل بنكي',
            'credit_card': 'بطاقة ائتمان',
            'cheque': 'شيك',
          }
        : {
            'cash': 'Cash',
            'bank_transfer': 'Bank Transfer',
            'credit_card': 'Credit Card',
            'cheque': 'Cheque',
          };

    return labels[method] ?? method ?? '';
  }
}
