/// ⚠️ IMPORTANT: transaction_getx.dart IS REDUNDANT
///
/// This file is UNNECESSARY because you already have:
/// - lib/presentation/auth/controllers/transactions_controller.dart
///
/// The existing TransactionsController already has ALL the functionality
/// that this file was trying to provide, and it's properly integrated
/// with your app architecture.
///
/// RECOMMENDED ACTION: DELETE transaction_getx.dart
///
/// If you want to keep it for reference, here's a fixed version that
/// matches your architecture, but it should NOT be used in your app.

import 'package:daftar/data/models/transaction_model.dart';
import 'package:daftar/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ✅ FIXED TransactionController
///
/// NOTE: This is a DUPLICATE of the existing TransactionsController
/// in lib/presentation/auth/controllers/transactions_controller.dart
///
/// You should use the existing one, not this!
class TransactionController extends GetxController {
  final TransactionRepository _repository;

  TransactionController({
    TransactionRepository? repository,
  }) : _repository = repository ?? TransactionRepository();

  // Observables
  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  // Computed getters
  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

  double get totalExpense => transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

  double get netBalance => totalIncome - totalExpense;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  /// Load transactions from API
  Future<void> loadTransactions({String sort = '-date'}) async {
    isLoading.value = true;
    error.value = null;

    try {
      final list = await _repository.getTransactions(sort: sort);
      transactions.assignAll(list);
      debugPrint(
          '✅ [TransactionController] Loaded ${list.length} transactions');
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ [TransactionController] Error loading transactions: $e');

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

  /// Create transaction
  // Future<void> createTransaction(TransactionModel transaction) async {
  //   try {
  //     final created = await _repository.createTransaction(transaction.toJson());
  //     transactions.insert(0, created);

  //     Get.snackbar(
  //       'Success',
  //       'Transaction created',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     error.value = e.toString();
  //     debugPrint('❌ [TransactionController] Error creating transaction: $e');

  //     Get.snackbar(
  //       'Error',
  //       'Failed to create transaction',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     rethrow;
  //   }
  // }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      transactions.removeWhere((t) => t.id == id);

      Get.snackbar(
        'Success',
        'Transaction deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ [TransactionController] Error deleting transaction: $e');

      Get.snackbar(
        'Error',
        'Failed to delete transaction',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Filter by type
  List<TransactionModel> filterByType(String type) {
    return transactions.where((t) => t.type == type).toList();
  }

  /// Filter by category
  List<TransactionModel> filterByCategory(String category) {
    return transactions.where((t) => t.category == category).toList();
  }

  /// Filter by date range
  List<TransactionModel> filterByDateRange(DateTime start, DateTime end) {
    return transactions.where((t) {
      final transactionDate = t.dateTime;
      if (transactionDate == null) return false;

      return transactionDate.isAfter(start) &&
          transactionDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}

/// RECOMMENDED ACTION:
/// 
/// 1. DELETE this file (transaction_getx.dart) from your project
/// 2. Use the existing TransactionsController at:
///    lib/presentation/auth/controllers/transactions_controller.dart
/// 3. It already has all the features you need!