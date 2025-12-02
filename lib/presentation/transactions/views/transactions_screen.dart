import 'package:daftar/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/transactions_controller.dart';
import 'transaction_dialog.dart';

/// ✅ FIXED TransactionsScreen - Complete GetX Implementation
/// 
/// Key Features:
/// - GetX state management (NO Provider!)
/// - Search and filter functionality
/// - Pull-to-refresh
/// - Bilingual support (Arabic/English)
/// - Beautiful gradient UI matching app theme
/// - Swipe-to-delete transactions
/// - Comprehensive error handling
/// - Loading states
class TransactionsScreen extends GetView<TransactionsController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      // Gradient Background matching app theme
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(isArabic),

              // Search and Filter Row
              _buildSearchAndFilter(isArabic),

              // Stats Summary Card
              _buildStatsSummary(isArabic),

              // Transaction List
              Expanded(
                child: _buildTransactionsList(isArabic),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openNewTransactionDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          isArabic ? 'Ø¥Ø¶Ø§ÙØ© Ù…Ø¹Ø§Ù…Ù„Ø©' : 'Add Transaction',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Custom App Bar with gradient
  Widget _buildAppBar(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),

          // Title
          Expanded(
            child: Text(
              isArabic ? 'Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª' : 'Transactions',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),

          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshTransactions,
          ),

          // Export Button
          IconButton(
            icon: const Icon(Icons.file_download, color: Colors.white),
            onPressed: controller.exportToCSV,
          ),
        ],
      ),
    );
  }

  /// Search and Filter Row
  Widget _buildSearchAndFilter(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: isArabic ? 'Ø§Ø¨Ø­Ø« ÙÙŠ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª...' : 'Search transactions...',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              suffixIcon: Obx(() {
                if (controller.searchTerm.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () => controller.searchController.clear(),
                );
              }),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    isArabic ? 'Ø§Ù„ÙƒÙ„' : 'All',
                    'all',
                    Icons.list,
                    controller.filterType.value == 'all',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    isArabic ? 'Ø§Ù„Ø¥ÙŠØ±Ø§Ø¯Ø§Øª' : 'Income',
                    'income',
                    Icons.arrow_downward,
                    controller.filterType.value == 'income',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    isArabic ? 'Ø§Ù„Ù…ØµØ±ÙˆÙØ§Øª' : 'Expenses',
                    'expense',
                    Icons.arrow_upward,
                    controller.filterType.value == 'expense',
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Filter Chip Widget
  Widget _buildFilterChip(String label, String value, IconData icon, bool isSelected) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => controller.filterType.value = value,
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
      elevation: isSelected ? 4 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  /// Stats Summary Card
  Widget _buildStatsSummary(bool isArabic) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Title
            Text(
              isArabic ? 'Ù…Ù„Ø®Øµ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª' : 'Transaction Summary',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Stats Row
            Row(
              children: [
                // Income
                Expanded(
                  child: _buildStatItem(
                    isArabic ? 'Ø§Ù„Ø¥ÙŠØ±Ø§Ø¯Ø§Øª' : 'Income',
                    controller.totalIncome.value,
                    Icons.trending_up,
                    Colors.greenAccent,
                    isArabic,
                  ),
                ),

                // Divider
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white30,
                ),

                // Expense
                Expanded(
                  child: _buildStatItem(
                    isArabic ? 'Ø§Ù„Ù…ØµØ±ÙˆÙØ§Øª' : 'Expenses',
                    controller.totalExpense.value,
                    Icons.trending_down,
                    Colors.redAccent,
                    isArabic,
                  ),
                ),

                // Divider
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white30,
                ),

                // Net Balance
                Expanded(
                  child: _buildStatItem(
                    isArabic ? 'Ø§Ù„ØµØ§ÙÙŠ' : 'Net',
                    controller.totalIncome.value - controller.totalExpense.value,
                    Icons.account_balance_wallet,
                    (controller.totalIncome.value - controller.totalExpense.value) >= 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    isArabic,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Single Stat Item
  Widget _buildStatItem(
    String label,
    double amount,
    IconData icon,
    Color iconColor,
    bool isArabic,
  ) {
    final formatter = NumberFormat.currency(
      locale: isArabic ? 'ar_AE' : 'en_US',
      symbol: isArabic ? 'Ø¯.Ø¥' : 'AED',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(amount.abs()),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Transactions List with RefreshIndicator
  Widget _buildTransactionsList(bool isArabic) {
    return Obx(() {
      // Loading State
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'Ø¬Ø§Ø±ÙŠ ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª...' : 'Loading transactions...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      final filtered = controller.filteredTransactions;

      // Empty State
      if (filtered.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                controller.searchTerm.value.isNotEmpty
                    ? (isArabic
                        ? 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ø¹Ø§Ù…Ù„Ø§Øª Ù…Ø·Ø§Ø¨Ù‚Ø©'
                        : 'No matching transactions')
                    : (isArabic
                        ? 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ø¹Ø§Ù…Ù„Ø§Øª'
                        : 'No transactions yet'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'Ø§Ø¨Ø¯Ø£ Ø¨Ø¥Ø¶Ø§ÙØ© Ù…Ø¹Ø§Ù…Ù„Ø© Ø¬Ø¯ÙŠØ¯Ø©'
                    : 'Start by adding a new transaction',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      // Transaction List with Pull-to-Refresh
      return RefreshIndicator(
        onRefresh: controller.refreshTransactions,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final transaction = filtered[index];
            return _buildTransactionCard(transaction, isArabic);
          },
        ),
      );
    });
  }

  /// Transaction Card with Swipe-to-Delete
  Widget _buildTransactionCard(TransactionModel transaction, bool isArabic) {
    final isIncome = transaction.isIncome;
    final formatter = NumberFormat.currency(
      locale: isArabic ? 'ar_AE' : 'en_US',
      symbol: isArabic ? 'Ø¯.Ø¥' : 'AED',
      decimalDigits: 2,
    );

    return Dismissible(
      key: Key(transaction.id ?? DateTime.now().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await Get.dialog<bool>(
          AlertDialog(
            title: Text(isArabic ? 'Ø­Ø°Ù Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø©' : 'Delete Transaction'),
            content: Text(
              isArabic
                  ? 'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù Ù‡Ø°Ù‡ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø©ØŸ'
                  : 'Are you sure you want to delete this transaction?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(isArabic ? 'Ø¥Ù„ØºØ§Ø¡' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(isArabic ? 'Ø­Ø°Ù' : 'Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        if (transaction.id != null) {
          controller.deleteTransaction(transaction.id!);
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => controller.viewTransaction(transaction),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description or Category
                      Text(
                        transaction.description?.isNotEmpty == true
                            ? transaction.description!
                            : _getCategoryLabel(transaction.category, isArabic),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Date and Payment Method
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            transaction.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.payment,
                              size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _getPaymentMethodLabel(
                                transaction.paymentMethod, isArabic),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      // Customer/Supplier if exists
                      if (transaction.customerSupplier?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                transaction.customerSupplier!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(transaction.amount ?? 0),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isIncome
                            ? (isArabic ? 'Ø¥ÙŠØ±Ø§Ø¯' : 'Income')
                            : (isArabic ? 'Ù…ØµØ±ÙˆÙ' : 'Expense'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get category label in current language
  String _getCategoryLabel(String? category, bool isArabic) {
    if (category == null) return isArabic ? 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯' : 'Uncategorized';

    final categories = {
      'sales': isArabic ? 'Ù…Ø¨ÙŠØ¹Ø§Øª' : 'Sales',
      'services': isArabic ? 'Ø®Ø¯Ù…Ø§Øª' : 'Services',
      'other_income': isArabic ? 'Ø¥ÙŠØ±Ø§Ø¯Ø§Øª Ø£Ø®Ø±Ù‰' : 'Other Income',
      'salaries': isArabic ? 'Ø±ÙˆØ§ØªØ¨' : 'Salaries',
      'rent': isArabic ? 'Ø¥ÙŠØ¬Ø§Ø±' : 'Rent',
      'utilities': isArabic ? 'Ù…Ø±Ø§ÙÙ‚' : 'Utilities',
      'purchases': isArabic ? 'Ù…Ø´ØªØ±ÙŠØ§Øª' : 'Purchases',
      'marketing': isArabic ? 'ØªØ³ÙˆÙŠÙ‚' : 'Marketing',
      'transportation': isArabic ? 'Ù†Ù‚Ù„' : 'Transportation',
      'maintenance': isArabic ? 'ØµÙŠØ§Ù†Ø©' : 'Maintenance',
      'taxes': isArabic ? 'Ø¶Ø±Ø§Ø¦Ø¨' : 'Taxes',
      'other_expense': isArabic ? 'Ù…ØµØ±ÙˆÙØ§Øª Ø£Ø®Ø±Ù‰' : 'Other Expenses',
    };

    return categories[category] ?? category;
  }

  /// Get payment method label in current language
  String _getPaymentMethodLabel(String? method, bool isArabic) {
    if (method == null) return isArabic ? 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯' : 'Not specified';

    final methods = {
      'cash': isArabic ? 'Ù†Ù‚Ø¯ÙŠ' : 'Cash',
      'bank_transfer': isArabic ? 'ØªØ­ÙˆÙŠÙ„ Ø¨Ù†ÙƒÙŠ' : 'Bank Transfer',
      'credit_card': isArabic ? 'Ø¨Ø·Ø§Ù‚Ø© Ø§Ø¦ØªÙ…Ø§Ù†' : 'Credit Card',
      'cheque': isArabic ? 'Ø´ÙŠÙƒ' : 'Cheque',
    };

    return methods[method] ?? method;
  }
}