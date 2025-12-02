import 'package:intl/intl.dart';

/// ✅ FIXED TransactionModel - Proper date handling
///
/// Key improvements:
/// - Flexible date field handling (String or DateTime)
/// - Robust date parsing with error handling
/// - All getters work with both date formats
/// - Added nullable fields where appropriate
class TransactionModel {
  final String? id;
  final dynamic date; // Can be String or DateTime
  final String? type;
  final double? amount;
  final String? category;
  final String? paymentMethod;
  final String? customerSupplier;
  final String? description;
  final String? receiptUrl;
  final String? branchId;
  final String? organizationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TransactionModel({
    this.id,
    required this.date,
    this.type,
    this.amount,
    this.category,
    this.paymentMethod,
    this.customerSupplier,
    this.description,
    this.receiptUrl,
    this.branchId,
    this.organizationId,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON (from API response)
  /// Handles various API response formats flexibly
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      date: json['date'], // Keep as-is (String or DateTime)
      type: json['type']?.toString(),
      amount: json['amount'] != null
          ? (json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0)
          : 0.0,
      category: json['category']?.toString(),
      paymentMethod: json['payment_method']?.toString() ??
          json['paymentMethod']?.toString(),
      customerSupplier: json['customer_supplier']?.toString() ??
          json['customerSupplier']?.toString(),
      description: json['description']?.toString(),
      receiptUrl:
          json['receipt_url']?.toString() ?? json['receiptUrl']?.toString(),
      branchId: json['branch_id']?.toString() ?? json['branchId']?.toString(),
      organizationId: json['organization_id']?.toString() ??
          json['organizationId']?.toString(),
      createdAt: json['created_at'] != null
          ? _parseDateTime(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? _parseDateTime(json['updated_at'])
          : null,
    );
  }

  /// Convert to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date is DateTime
          ? (date as DateTime).toIso8601String()
          : date.toString(),
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (customerSupplier != null) 'customer_supplier': customerSupplier,
      if (description != null) 'description': description,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
      if (branchId != null) 'branch_id': branchId,
      if (organizationId != null) 'organization_id': organizationId,
    };
  }

  /// CopyWith method for updating specific fields
  TransactionModel copyWith({
    String? id,
    dynamic date,
    String? type,
    double? amount,
    String? category,
    String? paymentMethod,
    String? customerSupplier,
    String? description,
    String? receiptUrl,
    String? branchId,
    String? organizationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerSupplier: customerSupplier ?? this.customerSupplier,
      description: description ?? this.description,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      branchId: branchId ?? this.branchId,
      organizationId: organizationId ?? this.organizationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// ✅ Parse the date field to DateTime regardless of its current type
  DateTime? get dateTime {
    if (date == null) return null;

    if (date is DateTime) {
      return date as DateTime;
    }

    if (date is String) {
      try {
        return DateTime.parse(date as String);
      } catch (e) {
        print('⚠️  Error parsing date: $date, error: $e');
        return null;
      }
    }

    return null;
  }

  /// Formatted amount with currency symbol
  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: 'AED ', decimalDigits: 2);
    return formatter.format(amount ?? 0.0);
  }

  /// Formatted date for display
  String get formattedDate {
    final dt = dateTime;
    if (dt == null) return 'N/A';

    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dt);
  }

  /// Check if transaction is income
  bool get isIncome => type?.toLowerCase() == 'income';

  /// Check if transaction is expense
  bool get isExpense => type?.toLowerCase() == 'expense';

  @override
  String toString() {
    return 'TransactionModel(id: $id, date: $date, type: $type, amount: $amount)';
  }

  /// ✅ Helper: Parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('⚠️  Error parsing datetime: $value, error: $e');
        return null;
      }
    }

    return null;
  }
}

/// Transaction categories constants
class TransactionCategory {
  // Income categories
  static const String sales = 'sales';
  static const String services = 'services';
  static const String otherIncome = 'other_income';

  // Expense categories
  static const String salaries = 'salaries';
  static const String rent = 'rent';
  static const String utilities = 'utilities';
  static const String purchases = 'purchases';
  static const String marketing = 'marketing';
  static const String transportation = 'transportation';
  static const String maintenance = 'maintenance';
  static const String taxes = 'taxes';
  static const String otherExpense = 'other_expense';

  static List<String> get incomeCategories => [
        sales,
        services,
        otherIncome,
      ];

  static List<String> get expenseCategories => [
        salaries,
        rent,
        utilities,
        purchases,
        marketing,
        transportation,
        maintenance,
        taxes,
        otherExpense,
      ];

  static List<String> get allCategories => [
        ...incomeCategories,
        ...expenseCategories,
      ];
}

/// Payment method constants
class PaymentMethod {
  static const String cash = 'cash';
  static const String bankTransfer = 'bank_transfer';
  static const String creditCard = 'credit_card';
  static const String cheque = 'cheque';

  static List<String> get all => [
        cash,
        bankTransfer,
        creditCard,
        cheque,
      ];
}
