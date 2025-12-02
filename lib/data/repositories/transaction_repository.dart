import 'package:daftar/core/services/base44_service.dart';

import 'package:daftar/data/models/transaction_model.dart';

/// TransactionRepository
/// Handles all transaction-related API operations
///
/// ✅ FIXED VERSION - Now includes:
/// - Proper Base44Service integration (like AuthRepository)
/// - filterByDateRange() method
/// - calculateStatistics() method
/// - Correct API endpoint usage
class TransactionRepository {
  final Base44Service _base44Service;

  TransactionRepository({Base44Service? base44Service})
      : _base44Service = base44Service ?? Base44Service();

  /// =========================================================================
  /// API METHODS - FETCH TRANSACTIONS
  /// =========================================================================

  /// Get all transactions (aliased for controller compatibility)
  /// This is the main method called by DashboardController
  Future<List<TransactionModel>> getTransactions({
    String sort = '-date',
    int? limit,
    int? offset,
  }) async {
    try {
      print(
          '\n📡 [TransactionRepository] Fetching transactions from Base44...');
      print('   Parameters: sort=$sort, limit=$limit, offset=$offset');

      // Call Base44Service to get transactions
      final rawTransactions = await _base44Service.getTransactions(
        sort: sort,
        limit: limit,
        skip: offset,
      );

      print(
          '✅ [TransactionRepository] Received ${rawTransactions.length} transactions');

      // Convert raw JSON to TransactionModel objects
      final transactions = rawTransactions
          .map(
              (json) => TransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print(
          '✅ [TransactionRepository] Converted to ${transactions.length} TransactionModel objects');

      return transactions;
    } catch (e) {
      print('❌ [TransactionRepository] Error fetching transactions: $e');
      rethrow;
    }
  }

  /// Create a new transaction
  Future<TransactionModel> createTransaction(
      TransactionModel transaction) async {
    try {
      print('\n📤 [TransactionRepository] Creating new transaction...');

      // Use Base44Service to create transaction
      final response =
          await _base44Service.createTransaction(transaction.toJson());

      print('✅ [TransactionRepository] Transaction created successfully');

      // Parse response to TransactionModel
      final createdTransaction = TransactionModel.fromJson(response);
      return createdTransaction;
    } catch (e) {
      print('❌ [TransactionRepository] Error creating transaction: $e');
      throw Exception(_cleanError(e));
    }
  }

  /// Update an existing transaction
  Future<TransactionModel> updateTransaction(
    String id,
    TransactionModel transaction,
  ) async {
    try {
      print('\n📝 [TransactionRepository] Updating transaction $id...');

      final response = await _base44Service.updateTransaction(
        id,
        transaction.toJson(),
      );

      print('✅ [TransactionRepository] Transaction updated successfully');

      return TransactionModel.fromJson(response);
    } catch (e) {
      print('❌ [TransactionRepository] Error updating transaction: $e');
      throw Exception(_cleanError(e));
    }
  }

  /// Delete a transaction by ID
  Future<void> deleteTransaction(String id) async {
    try {
      print('\n🗑️ [TransactionRepository] Deleting transaction $id...');

      await _base44Service.deleteTransaction(id);

      print('✅ [TransactionRepository] Transaction deleted successfully');
    } catch (e) {
      print('❌ [TransactionRepository] Error deleting transaction: $e');
      throw Exception(_cleanError(e));
    }
  }

  /// Get a single transaction by ID
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      print('\n🔍 [TransactionRepository] Fetching transaction $id...');

      final response = await _base44Service.getTransactionById(id);

      print('✅ [TransactionRepository] Transaction fetched successfully');

      return TransactionModel.fromJson(response);
    } catch (e) {
      print('❌ [TransactionRepository] Error fetching transaction: $e');
      throw Exception(_cleanError(e));
    }
  }

  /// =========================================================================
  /// LOCAL FILTERING & CALCULATION METHODS
  /// =========================================================================

  /// ✅ NEW METHOD: Filter transactions by date range
  /// Used by DashboardController to filter transactions for statistics
  List<TransactionModel> filterByDateRange(
    List<TransactionModel> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    print(
        '\n🔍 [TransactionRepository] Filtering transactions by date range...');
    print('   Start: $startDate');
    print('   End: $endDate');
    print('   Total transactions to filter: ${transactions.length}');

    final filtered = transactions.where((transaction) {
      // ✔ SAFE date parsing
      final dt = transaction.dateTime;

      // ✔ Prevent null crash
      if (dt == null) {
        print('⚠️  [TransactionRepository] Invalid date for ${transaction.id}');
        return false;
      }

      // ✔ SAFE comparison
      final isInRange =
          dt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
              dt.isBefore(endDate.add(const Duration(seconds: 1)));

      return isInRange;
    }).toList();

    print(
        '✅ [TransactionRepository] Filtered to ${filtered.length} transactions');

    return filtered;
  }

  /// ✅ NEW METHOD: Calculate statistics from transactions
  /// Returns a map with income, expense, and profit totals
  Map<String, double> calculateStatistics(List<TransactionModel> transactions) {
    print('\n📊 [TransactionRepository] Calculating statistics...');
    print('   Total transactions: ${transactions.length}');

    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (final transaction in transactions) {
      final amount = transaction.amount ?? 0.0;

      if (transaction.isIncome) {
        totalIncome += amount;
      } else if (transaction.isExpense) {
        totalExpense += amount;
      }
    }

    final profit = totalIncome - totalExpense;

    print('   💰 Income:  $totalIncome');
    print('   💸 Expense: $totalExpense');
    print('   📈 Profit:  $profit');

    return {
      'income': totalIncome,
      'expense': totalExpense,
      'profit': profit,
    };
  }

  /// =========================================================================
  /// HELPER METHODS
  /// =========================================================================

  /// Clean error message for UI display
  String _cleanError(dynamic e) {
    return e.toString().replaceAll('Exception: ', '').trim();
  }
}
