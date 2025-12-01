/// Transaction Model
/// Represents transaction data from Base44 API
/// Handles income and expense transactions with proper type safety
class TransactionModel {
  final String? id;
  final String? organizationId;
  final String? branchId;
  final DateTime? date;
  final String? type; // 'income' or 'expense'
  final double? amount;
  final String? category;
  final String? paymentMethod;
  final String? customerSupplier;
  final String? description;
  final String? receiptUrl;
  final String? invoiceNumber;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? createdById;
  final String? createdBy;
  final bool? isSample;

  TransactionModel({
    this.id,
    this.organizationId,
    this.branchId,
    this.date,
    this.type,
    this.amount,
    this.category,
    this.paymentMethod,
    this.customerSupplier,
    this.description,
    this.receiptUrl,
    this.invoiceNumber,
    this.createdDate,
    this.updatedDate,
    this.createdById,
    this.createdBy,
    this.isSample,
  });

  /// Create TransactionModel from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? json['_id'] as String?,
      organizationId: json['organization_id'] as String? ??
          json['organizationId'] as String?,
      branchId: json['branch_id'] as String? ?? json['branchId'] as String?,
      date: _parseDate(json['date']),
      type: json['type'] as String?,
      amount: _parseAmount(json['amount']),
      category: json['category'] as String?,
      paymentMethod:
          json['payment_method'] as String? ?? json['paymentMethod'] as String?,
      customerSupplier: json['customer_supplier'] as String? ??
          json['customerSupplier'] as String?,
      description: json['description'] as String?,
      receiptUrl:
          json['receipt_url'] as String? ?? json['receiptUrl'] as String?,
      invoiceNumber:
          json['invoice_number'] as String? ?? json['invoiceNumber'] as String?,
      createdDate: _parseDateTime(
          json['created_date'] ?? json['createdDate'] ?? json['created_at']),
      updatedDate: _parseDateTime(
          json['updated_date'] ?? json['updatedDate'] ?? json['updated_at']),
      createdById:
          json['created_by_id'] as String? ?? json['createdById'] as String?,
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String?,
      isSample:
          json['is_sample'] as bool? ?? json['isSample'] as bool? ?? false,
    );
  }

  /// Parse date from string (format: "2025-11-01")
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        // Unix timestamp
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Parse amount to double
  static double? _parseAmount(dynamic value) {
    if (value == null) return null;

    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Convert TransactionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'branch_id': branchId,
      'date': date?.toIso8601String().split('T')[0], // Format: "2025-11-01"
      'type': type,
      'amount': amount,
      'category': category,
      'payment_method': paymentMethod,
      'customer_supplier': customerSupplier,
      'description': description,
      'receipt_url': receiptUrl,
      'invoice_number': invoiceNumber,
      'created_date': createdDate?.toIso8601String(),
      'updated_date': updatedDate?.toIso8601String(),
      'created_by_id': createdById,
      'created_by': createdBy,
      'is_sample': isSample,
    };
  }

  /// Create copy with modified fields
  TransactionModel copyWith({
    String? id,
    String? organizationId,
    String? branchId,
    DateTime? date,
    String? type,
    double? amount,
    String? category,
    String? paymentMethod,
    String? customerSupplier,
    String? description,
    String? receiptUrl,
    String? invoiceNumber,
    DateTime? createdDate,
    DateTime? updatedDate,
    String? createdById,
    String? createdBy,
    bool? isSample,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      branchId: branchId ?? this.branchId,
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerSupplier: customerSupplier ?? this.customerSupplier,
      description: description ?? this.description,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      createdById: createdById ?? this.createdById,
      createdBy: createdBy ?? this.createdBy,
      isSample: isSample ?? this.isSample,
    );
  }

  /// Check if transaction is income
  bool get isIncome => type?.toLowerCase() == 'income';

  /// Check if transaction is expense
  bool get isExpense => type?.toLowerCase() == 'expense';

  /// Get formatted date (e.g., "Nov 1, 2025" or "١ نوفمبر ٢٠٢٥")
  String getFormattedDate({String locale = 'en'}) {
    if (date == null) return '';

    final months = locale == 'ar'
        ? [
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
          ]
        : [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];

    final month = months[date!.month - 1];
    return '$month ${date!.day}, ${date!.year}';
  }

  /// Get payment method display name
  String getPaymentMethodDisplay({String locale = 'en'}) {
    if (paymentMethod == null) return '';

    final methodMap = locale == 'ar'
        ? {
            'cash': 'نقداً',
            'credit_card': 'بطاقة ائتمان',
            'debit_card': 'بطاقة خصم',
            'bank_transfer': 'تحويل بنكي',
            'cheque': 'شيك',
            'other': 'أخرى',
          }
        : {
            'cash': 'Cash',
            'credit_card': 'Credit Card',
            'debit_card': 'Debit Card',
            'bank_transfer': 'Bank Transfer',
            'cheque': 'Cheque',
            'other': 'Other',
          };

    return methodMap[paymentMethod] ?? paymentMethod!;
  }

  /// Get category display name
  String getCategoryDisplay({String locale = 'en'}) {
    if (category == null) return '';

    final categoryMap = locale == 'ar'
        ? {
            'sales': 'مبيعات',
            'purchases': 'مشتريات',
            'salaries': 'رواتب',
            'rent': 'إيجار',
            'utilities': 'خدمات',
            'marketing': 'تسويق',
            'other': 'أخرى',
          }
        : {
            'sales': 'Sales',
            'purchases': 'Purchases',
            'salaries': 'Salaries',
            'rent': 'Rent',
            'utilities': 'Utilities',
            'marketing': 'Marketing',
            'other': 'Other',
          };

    return categoryMap[category] ?? category!;
  }

  /// Check if transaction is valid
  bool get isValid {
    return id != null && type != null && amount != null && amount! > 0;
  }

  @override
  /// Always show English description for dashboard
String get descriptionEn {
  // If API already sends English, use it directly
  if (description != null && description!.contains(RegExp(r'[a-zA-Z]'))) {
    return description!;
  }

  // Fallback mapping based on category
  switch (category) {
    case 'sales':
      return 'Daily Sales';
    case 'salaries':
      return 'Salaries';
    case 'purchases':
      return 'Purchases';
    case 'rent':
      return 'Rent';
    case 'utilities':
      return 'Utilities';
    case 'marketing':
      return 'Marketing';
    default:
      return 'Transaction';
  }
}

  @override
  String toString() {
    return 'TransactionModel(id: $id, type: $type, amount: $amount, date: $date, category: $category)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
