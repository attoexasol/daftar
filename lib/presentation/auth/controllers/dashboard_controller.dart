import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Dashboard Controller
/// Manages dashboard state and business logic
class DashboardController extends GetxController {
  final AuthRepository _authRepository;
  final TransactionRepository _transactionRepository;

  DashboardController({
    AuthRepository? authRepository,
    TransactionRepository? transactionRepository,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _transactionRepository =
            transactionRepository ?? TransactionRepository();

  // Observables
  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;
  final selectedDateRange = 'month'.obs;

  // Transactions
  final transactions = <TransactionModel>[].obs;
  final recentTransactions = <TransactionModel>[].obs;

  // Stats
  final totalBalance = 0.0.obs;
  final monthIncome = 0.0.obs;
  final monthExpense = 0.0.obs;
  final monthProfit = 0.0.obs;

  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint(
        "\n╔════════════════════════════════════════════════════════════════╗");
    debugPrint(
        "║         DASHBOARD CONTROLLER INITIALIZED                       ║");
    debugPrint(
        "╚════════════════════════════════════════════════════════════════╝\n");

    _loadUserData();
    loadDashboardData();
  }

  /// ----------------------------------------------------------
  /// LOAD USER DATA (Base44 /auth/me)
  /// ----------------------------------------------------------
  Future<void> _loadUserData() async {
    debugPrint("\n📊 [DASHBOARD] Starting user data load...");
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;

      debugPrint("✅ [DASHBOARD] User loaded successfully: ${user.displayName}");
      debugPrint("   - Email: ${user.email}");
      debugPrint("   - Role: ${user.role}");
      debugPrint("   - Organization: ${user.organizationName ?? 'N/A'}");
    } catch (e) {
      debugPrint("❌ [DASHBOARD] User load error: $e");
      handleSessionExpired();
    }
  }

  /// ----------------------------------------------------------
  /// LOAD DASHBOARD DATA (Real transactions from API)
  /// ----------------------------------------------------------
  Future<void> loadDashboardData() async {
    debugPrint(
        "\n╔════════════════════════════════════════════════════════════════╗");
    debugPrint(
        "║         LOADING DASHBOARD DATA FROM API                        ║");
    debugPrint(
        "╚════════════════════════════════════════════════════════════════╝\n");

    isLoading.value = true;

    try {
      // Fetch transactions from API
      debugPrint("🔄 [DASHBOARD] Step 1: Calling _loadTransactions()...");
      await _loadTransactions();

      // Calculate statistics based on date range
      debugPrint("🔄 [DASHBOARD] Step 2: Calculating statistics...");
      _calculateStatistics();

      debugPrint("\n✅ [DASHBOARD] Dashboard loaded successfully!");
      debugPrint("   - Total transactions: ${transactions.length}");
      debugPrint("   - Recent transactions: ${recentTransactions.length}");
      debugPrint("   - Month Income: ${formatCurrency(monthIncome.value)}");
      debugPrint("   - Month Expense: ${formatCurrency(monthExpense.value)}");
      debugPrint("   - Month Profit: ${formatCurrency(monthProfit.value)}");
      debugPrint("   - Total Balance: ${formatCurrency(totalBalance.value)}");
    } catch (e) {
      debugPrint("\n❌ [DASHBOARD] Dashboard load error: $e");
      debugPrint("   Error type: ${e.runtimeType}");
      debugPrint("   Stack trace: ${StackTrace.current}");

      Get.snackbar(
        "error_occurred".tr,
        "failed_to_load_dashboard".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint("\n[DASHBOARD] Loading complete. isLoading = false\n");
    }
  }

  /// ----------------------------------------------------------
  /// LOAD TRANSACTIONS FROM API
  /// ----------------------------------------------------------
  Future<void> _loadTransactions() async {
    debugPrint(
        "\n┌─────────────────────────────────────────────────────────────┐");
    debugPrint(
        "│  LOADING TRANSACTIONS FROM API                              │");
    debugPrint(
        "└─────────────────────────────────────────────────────────────┘");

    try {
      debugPrint(
          "📡 [TRANSACTIONS] Calling TransactionRepository.getTransactions()...");
      debugPrint("   Parameters: sort=-date");

      // Fetch all transactions sorted by date (newest first)
      final allTransactions = await _transactionRepository.getTransactions(
        sort: '-date',
      );

      debugPrint("✅ [TRANSACTIONS] API call successful!");
      debugPrint(
          "   - Received ${allTransactions.length} transactions from API");

      transactions.value = allTransactions;

      // Get recent 10 transactions for display
      recentTransactions.value = allTransactions.take(10).toList();

      debugPrint("   - Set ${recentTransactions.length} recent transactions");

      // Print first 3 transactions for debugging
      if (allTransactions.isNotEmpty) {
        debugPrint("\n📝 [TRANSACTIONS] Sample of loaded transactions:");
        for (var i = 0; i < allTransactions.length && i < 3; i++) {
          final t = allTransactions[i];
          debugPrint(
              "   ${i + 1}. ${t.type?.toUpperCase()} - ${formatCurrency(t.amount ?? 0)}");
          debugPrint("      Date: ${t.date?.toString().split(' ')[0]}");
          debugPrint("      Category: ${t.category}");
          debugPrint("      Description: ${t.description}");
        }
        if (allTransactions.length > 3) {
          debugPrint(
              "   ... and ${allTransactions.length - 3} more transactions");
        }
      } else {
        debugPrint("\n⚠️  [TRANSACTIONS] No transactions received from API");
      }

      debugPrint("\n✅ [TRANSACTIONS] Transaction loading complete");
    } catch (e) {
      debugPrint("\n❌ [TRANSACTIONS] Error loading transactions: $e");
      debugPrint("   Error type: ${e.runtimeType}");

      transactions.value = [];
      recentTransactions.value = [];
      rethrow;
    }
  }

  /// ----------------------------------------------------------
  /// CALCULATE STATISTICS
  /// ----------------------------------------------------------
  void _calculateStatistics() {
    debugPrint(
        "\n┌─────────────────────────────────────────────────────────────┐");
    debugPrint(
        "│  CALCULATING STATISTICS                                     │");
    debugPrint(
        "└─────────────────────────────────────────────────────────────┘");

    final now = DateTime.now();
    List<TransactionModel> filteredTransactions;

    debugPrint("📊 [STATS] Selected date range: ${selectedDateRange.value}");

    // Filter transactions based on selected date range
    switch (selectedDateRange.value) {
      case 'today':
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        debugPrint("   Filtering for today: $startOfDay to $endOfDay");
        filteredTransactions = _transactionRepository.filterByDateRange(
          transactions,
          startOfDay,
          endOfDay,
        );
        break;

      case 'week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        debugPrint("   Filtering for this week: $startOfWeek to $endOfWeek");
        filteredTransactions = _transactionRepository.filterByDateRange(
          transactions,
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
        );
        break;

      case 'year':
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
        debugPrint("   Filtering for this year: $startOfYear to $endOfYear");
        filteredTransactions = _transactionRepository.filterByDateRange(
          transactions,
          startOfYear,
          endOfYear,
        );
        break;

      case 'month':
      default:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        debugPrint("   Filtering for this month: $startOfMonth to $endOfMonth");
        filteredTransactions = _transactionRepository.filterByDateRange(
          transactions,
          startOfMonth,
          endOfMonth,
        );
        break;
    }

    debugPrint(
        "   Filtered transactions count: ${filteredTransactions.length}");

    // Calculate statistics
    final stats =
        _transactionRepository.calculateStatistics(filteredTransactions);

    monthIncome.value = stats['income'] ?? 0.0;
    monthExpense.value = stats['expense'] ?? 0.0;
    monthProfit.value = stats['profit'] ?? 0.0;

    debugPrint("\n📈 [STATS] Statistics for ${selectedDateRange.value}:");
    debugPrint("   - Income:  ${formatCurrency(monthIncome.value)}");
    debugPrint("   - Expense: ${formatCurrency(monthExpense.value)}");
    debugPrint("   - Profit:  ${formatCurrency(monthProfit.value)}");

    // Calculate total balance (all-time)
    final allTimeStats =
        _transactionRepository.calculateStatistics(transactions);
    totalBalance.value = allTimeStats['profit'] ?? 0.0;

    debugPrint(
        "   - Total Balance (all-time): ${formatCurrency(totalBalance.value)}");

    debugPrint("\n✅ [STATS] Statistics calculation complete");
  }

  /// ----------------------------------------------------------
  /// PULL-TO-REFRESH
  /// ----------------------------------------------------------
  Future<void> refreshDashboard() async {
    debugPrint("\n🔄 [DASHBOARD] Refresh triggered by user");

    await _loadUserData();
    await loadDashboardData();

    Get.snackbar(
      "refreshed".tr,
      "dashboard_updated".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// ----------------------------------------------------------
  /// DATE RANGE CHANGE
  /// ----------------------------------------------------------
  void changeDateRange(String range) {
    debugPrint(
        "\n📅 [DASHBOARD] Date range changed: ${selectedDateRange.value} → $range");

    selectedDateRange.value = range;
    _calculateStatistics(); // Recalculate with new range
  }

  /// ----------------------------------------------------------
  /// GET TRANSACTIONS BY TYPE
  /// ----------------------------------------------------------
  List<TransactionModel> getIncomeTransactions() {
    final income = transactions.where((t) => t.isIncome).toList();
    debugPrint("💰 [DASHBOARD] Income transactions: ${income.length}");
    return income;
  }

  List<TransactionModel> getExpenseTransactions() {
    final expense = transactions.where((t) => t.isExpense).toList();
    debugPrint("💸 [DASHBOARD] Expense transactions: ${expense.length}");
    return expense;
  }

  /// ----------------------------------------------------------
  /// FORMATTERS
  /// ----------------------------------------------------------
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: Get.locale?.languageCode == "ar" ? "ar_AE" : "en_US",
      symbol: Get.locale?.languageCode == "ar" ? "د.إ" : "AED",
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String formatNumber(double number) {
    final formatter = NumberFormat.decimalPattern(
      Get.locale?.languageCode == "ar" ? "ar_AE" : "en_US",
    );
    return formatter.format(number);
  }

  /// ----------------------------------------------------------
  /// GREETING MESSAGE
  /// ----------------------------------------------------------
  String getGreeting() {
    final hour = DateTime.now().hour;
    final isArabic = Get.locale?.languageCode == "ar";

    if (hour < 12) {
      return isArabic ? "صباح الخير" : "Good Morning";
    } else if (hour < 18) {
      return isArabic ? "مساء الخير" : "Good Afternoon";
    } else {
      return isArabic ? "مساء الخير" : "Good Evening";
    }
  }

  /// ----------------------------------------------------------
  /// LOGOUT
  /// ----------------------------------------------------------
  Future<void> logout() async {
    try {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: Text("logout".tr),
          content: Text("logout_confirmation".tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text("cancel".tr),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("logout".tr),
            ),
          ],
        ),
      );

      if (confirm == true) {
        isLoading.value = true;

        await _authRepository.logout();

        Get.offAllNamed("/login");

        Get.snackbar(
          "logged_out".tr,
          "logout_success".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Logout error: $e");

      Get.snackbar(
        "error_occurred".tr,
        "logout_failed".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ----------------------------------------------------------
  /// SESSION EXPIRED
  /// ----------------------------------------------------------
  void handleSessionExpired() {
    Get.snackbar(
      "session_expired".tr,
      "please_login_again".tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[600],
      colorText: Colors.white,
    );
    Get.offAllNamed("/login");
  }

  /// ----------------------------------------------------------
  /// FEATURE PLACEHOLDER BUTTONS
  /// ----------------------------------------------------------
  void navigateToTransactions() {
    Get.snackbar(
      "coming_soon".tr,
      "feature_coming_soon".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
    );
  }

  void navigateToInvoices() {
    Get.snackbar(
      "coming_soon".tr,
      "feature_coming_soon".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
    );
  }

  void navigateToReports() {
    Get.snackbar(
      "coming_soon".tr,
      "feature_coming_soon".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
    );
  }

  void navigateToSettings() {
    Get.snackbar(
      "coming_soon".tr,
      "feature_coming_soon".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
    );
  }
}
