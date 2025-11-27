import 'package:flutter/foundation.dart';
import '../../core/services/base44_service.dart';
import '../models/transaction_model.dart';

/// Transaction Repository
/// Handles all transaction-related data operations.
/// Works with Base44Service REST API.
class TransactionRepository {
  final Base44Service _base44Service;

  TransactionRepository({Base44Service? base44Service})
      : _base44Service = base44Service ?? Base44Service();

  /// -------------------------------------------------------
  /// GET TRANSACTIONS
  /// -------------------------------------------------------
  /// Fetch transactions list with optional sorting and pagination
  ///
  /// Parameters:
  /// - sort: Sort field (e.g., "-date" for newest first, "date" for oldest first)
  /// - limit: Maximum number of transactions to fetch
  /// - skip: Number of transactions to skip (for pagination)
  ///
  /// Returns: List of TransactionModel objects
  Future<List<TransactionModel>> getTransactions({
    String? sort,
    int? limit,
    int? skip,
  }) async {
    debugPrint(
        "\n╔════════════════════════════════════════════════════════════════╗");
    debugPrint(
        "║         TRANSACTION REPOSITORY - GET TRANSACTIONS              ║");
    debugPrint(
        "╚════════════════════════════════════════════════════════════════╝");
    debugPrint("📡 [REPO] Fetching transactions from API...");
    debugPrint("   Parameters:");
    debugPrint("   - sort:  ${sort ?? 'not specified'}");
    debugPrint("   - limit: ${limit?.toString() ?? 'not specified'}");
    debugPrint("   - skip:  ${skip?.toString() ?? 'not specified'}");

    try {
      debugPrint("\n🔄 [REPO] Calling Base44Service.getTransactions()...");

      final response = await _base44Service.getTransactions(
        sort: sort ?? '-date', // Default to newest first
        limit: limit,
        skip: skip,
      );

      debugPrint("✅ [REPO] Received response from Base44Service");
      debugPrint("   Response type: ${response.runtimeType}");
      debugPrint("   Response length: ${response.length}");

      if (response.isEmpty) {
        debugPrint(
            "\n⚠️  [REPO] Empty response received - no transactions found");
        return [];
      }

      debugPrint("\n🔄 [REPO] Converting JSON to TransactionModel objects...");

      // Convert list of JSON to list of TransactionModel
      final transactions = <TransactionModel>[];
      for (var i = 0; i < response.length; i++) {
        try {
          final json = response[i] as Map<String, dynamic>;
          final transaction = TransactionModel.fromJson(json);
          transactions.add(transaction);

          // Log first 3 transactions in detail
          if (i < 3) {
            debugPrint("\n   Transaction ${i + 1}:");
            debugPrint("   - ID: ${transaction.id}");
            debugPrint("   - Type: ${transaction.type}");
            debugPrint("   - Amount: ${transaction.amount}");
            debugPrint("   - Date: ${transaction.date}");
            debugPrint("   - Category: ${transaction.category}");
            debugPrint("   - Description: ${transaction.description}");
          }
        } catch (e) {
          debugPrint("⚠️  [REPO] Error parsing transaction $i: $e");
        }
      }

      if (response.length > 3) {
        debugPrint(
            "\n   ... and ${response.length - 3} more transactions parsed successfully");
      }

      debugPrint("\n✅ [REPO] Transaction conversion complete");
      debugPrint(
          "   - Successfully parsed: ${transactions.length} transactions");
      debugPrint(
          "   - Failed to parse: ${response.length - transactions.length} transactions");

      return transactions;
    } catch (e) {
      debugPrint("\n❌ [REPO] ERROR in getTransactions: $e");
      debugPrint("   Error type: ${e.runtimeType}");
      debugPrint("   Clean error: ${_cleanError(e)}");
      throw Exception(_cleanError(e));
    }
  }

  /// -------------------------------------------------------
  /// GET RECENT TRANSACTIONS
  /// -------------------------------------------------------
  /// Fetch most recent transactions (default: 10)
  Future<List<TransactionModel>> getRecentTransactions({
    int limit = 10,
  }) async {
    debugPrint("\n📝 [REPO] Getting recent transactions (limit: $limit)");
    return getTransactions(
      sort: '-date',
      limit: limit,
    );
  }

  /// -------------------------------------------------------
  /// GET INCOME TRANSACTIONS
  /// -------------------------------------------------------
  /// Fetch only income transactions
  Future<List<TransactionModel>> getIncomeTransactions({
    String? sort,
    int? limit,
  }) async {
    debugPrint("\n💰 [REPO] Getting income transactions");

    final transactions = await getTransactions(
      sort: sort ?? '-date',
      limit: limit,
    );

    final income = transactions.where((t) => t.isIncome).toList();
    debugPrint("   Found ${income.length} income transactions");
    return income;
  }

  /// -------------------------------------------------------
  /// GET EXPENSE TRANSACTIONS
  /// -------------------------------------------------------
  /// Fetch only expense transactions
  Future<List<TransactionModel>> getExpenseTransactions({
    String? sort,
    int? limit,
  }) async {
    debugPrint("\n💸 [REPO] Getting expense transactions");

    final transactions = await getTransactions(
      sort: sort ?? '-date',
      limit: limit,
    );

    final expense = transactions.where((t) => t.isExpense).toList();
    debugPrint("   Found ${expense.length} expense transactions");
    return expense;
  }

  /// -------------------------------------------------------
  /// CALCULATE STATISTICS
  /// -------------------------------------------------------
  /// Calculate income, expense, and profit from transactions
  Map<String, double> calculateStatistics(List<TransactionModel> transactions) {
    debugPrint(
        "\n📊 [REPO] Calculating statistics for ${transactions.length} transactions");

    double totalIncome = 0.0;
    double totalExpense = 0.0;
    int incomeCount = 0;
    int expenseCount = 0;

    for (var transaction in transactions) {
      if (transaction.amount != null) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount!;
          incomeCount++;
        } else if (transaction.isExpense) {
          totalExpense += transaction.amount!;
          expenseCount++;
        }
      }
    }

    final profit = totalIncome - totalExpense;

    debugPrint("   Results:");
    debugPrint("   - Income:  $totalIncome ($incomeCount transactions)");
    debugPrint("   - Expense: $totalExpense ($expenseCount transactions)");
    debugPrint("   - Profit:  $profit");

    return {
      'income': totalIncome,
      'expense': totalExpense,
      'profit': profit,
    };
  }

  /// -------------------------------------------------------
  /// FILTER BY DATE RANGE
  /// -------------------------------------------------------
  /// Filter transactions by date range
  List<TransactionModel> filterByDateRange(
    List<TransactionModel> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    debugPrint("\n📅 [REPO] Filtering transactions by date range");
    debugPrint("   Start: $startDate");
    debugPrint("   End: $endDate");
    debugPrint("   Total transactions to filter: ${transactions.length}");

    final filtered = transactions.where((t) {
      if (t.date == null) return false;
      return t.date!.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date!.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    debugPrint("   Filtered result: ${filtered.length} transactions");
    return filtered;
  }

  /// -------------------------------------------------------
  /// GET MONTH TRANSACTIONS
  /// -------------------------------------------------------
  /// Get transactions for current month
  Future<List<TransactionModel>> getMonthTransactions() async {
    debugPrint("\n📆 [REPO] Getting current month transactions");

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    debugPrint("   Month: ${now.year}-${now.month}");
    debugPrint("   Start: $startOfMonth");
    debugPrint("   End: $endOfMonth");

    final transactions = await getTransactions(sort: '-date');
    return filterByDateRange(transactions, startOfMonth, endOfMonth);
  }

  /// -------------------------------------------------------
  /// GET TODAY TRANSACTIONS
  /// -------------------------------------------------------
  /// Get transactions for today
  Future<List<TransactionModel>> getTodayTransactions() async {
    debugPrint("\n📆 [REPO] Getting today's transactions");

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    debugPrint("   Date: ${now.year}-${now.month}-${now.day}");
    debugPrint("   Start: $startOfDay");
    debugPrint("   End: $endOfDay");

    final transactions = await getTransactions(sort: '-date');
    return filterByDateRange(transactions, startOfDay, endOfDay);
  }

  /// -------------------------------------------------------
  /// PRIVATE HELPERS
  /// -------------------------------------------------------

  /// Clean error message for UI display
  String _cleanError(dynamic e) {
    return e.toString().replaceAll('Exception: ', '').trim();
  }
}
