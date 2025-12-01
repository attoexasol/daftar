import 'package:daftar/presentation/auth/views/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/transaction_repository.dart';
import '../../../data/models/transaction_model.dart';

/// Transactions Controller
/// Manages transactions state and business logic
/// FIXED: Proper observable implementation
class TransactionsController extends GetxController {
  final TransactionRepository _repository;

  TransactionsController({
    TransactionRepository? repository,
  }) : _repository = repository ?? TransactionRepository();

  // Observables
  final isLoading = false.obs;
  final transactions = <TransactionModel>[].obs;
  final searchTerm = ''.obs;
  final filterType = 'all'.obs;

  // Search controller
  final searchController = TextEditingController();

  // FIXED: Use RxDouble for computed totals
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;

  // Computed filtered transactions
  List<TransactionModel> get filteredTransactions {
    var filtered = transactions.toList();

    // Apply filter type
    if (filterType.value == 'income') {
      filtered = filtered.where((t) => t.isIncome).toList();
    } else if (filterType.value == 'expense') {
      filtered = filtered.where((t) => t.isExpense).toList();
    }

    // Apply search
    if (searchTerm.value.isNotEmpty) {
      final search = searchTerm.value.toLowerCase();
      filtered = filtered.where((t) {
        return (t.description?.toLowerCase().contains(search) ?? false) ||
            (t.customerSupplier?.toLowerCase().contains(search) ?? false) ||
            (t.category?.toLowerCase().contains(search) ?? false);
      }).toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadTransactions();

    // Listen to search changes
    searchController.addListener(() {
      searchTerm.value = searchController.text;
    });

    // Listen to transactions changes and recalculate totals
    ever(transactions, (_) => _calculateTotals());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Calculate totals - FIXED
  void _calculateTotals() {
    double income = 0.0;
    double expense = 0.0;

    for (var transaction in transactions) {
      if (transaction.isIncome) {
        income += transaction.amount ?? 0;
      } else {
        expense += transaction.amount ?? 0;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
  }

  /// Load transactions from API
  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      final data = await _repository.getTransactions(sort: '-date');
      transactions.value = data;
      _calculateTotals(); // Calculate totals after loading
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      Get.snackbar(
        'Error',
        'Failed to load transactions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh transactions
  Future<void> refreshTransactions() async {
    await loadTransactions();
  }

  /// Open new transaction dialog
  Future<void> openNewTransactionDialog() async {
    final result = await Get.dialog<TransactionModel>(
      const NewTransactionDialog(),
      barrierDismissible: false,
    );

    if (result != null) {
      await _createTransaction(result);
    }
  }

  /// Create new transaction
  Future<void> _createTransaction(TransactionModel transaction) async {
    try {
      // TODO: Implement API call to create transaction
      // final created = await _repository.createTransaction(transaction);

      // For now, just add to local list with a temporary ID
      final newTransaction = transaction.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      transactions.insert(0, newTransaction);

      Get.snackbar(
        'Success',
        Get.locale?.languageCode == 'ar'
            ? 'تم إضافة المعاملة بنجاح'
            : 'Transaction created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Reload transactions to get fresh data from API
      await loadTransactions();
    } catch (e) {
      debugPrint('Error creating transaction: $e');
      Get.snackbar(
        'Error',
        Get.locale?.languageCode == 'ar'
            ? 'فشل في إضافة المعاملة'
            : 'Failed to create transaction',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// View transaction details
  void viewTransaction(TransactionModel transaction) {
    // TODO: Implement view dialog
    Get.snackbar(
      'Transaction Details',
      'ID: ${transaction.id}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(Get.locale?.languageCode == 'ar'
            ? 'حذف المعاملة'
            : 'Delete Transaction'),
        content: Text(Get.locale?.languageCode == 'ar'
            ? 'هل أنت متأكد من حذف هذه المعاملة؟'
            : 'Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(Get.locale?.languageCode == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(Get.locale?.languageCode == 'ar' ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Implement delete API call
        // await _repository.deleteTransaction(id);

        transactions.removeWhere((t) => t.id == id);

        Get.snackbar(
          'Success',
          Get.locale?.languageCode == 'ar'
              ? 'تم حذف المعاملة بنجاح'
              : 'Transaction deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          Get.locale?.languageCode == 'ar'
              ? 'فشل في حذف المعاملة'
              : 'Failed to delete transaction',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Export to CSV
  void exportToCSV() {
    // TODO: Implement CSV export
    Get.snackbar(
      'Coming Soon',
      Get.locale?.languageCode == 'ar'
          ? 'سيتم تنفيذ التصدير قريباً'
          : 'CSV export will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
