import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/transaction_model.dart';

/// New Transaction Dialog
/// 100% EXACT match with React Dialog implementation
class NewTransactionDialog extends StatefulWidget {
  final Function(TransactionModel)? onSubmit;

  const NewTransactionDialog({
    super.key,
    this.onSubmit,
  });

  @override
  State<NewTransactionDialog> createState() => _NewTransactionDialogState();
}

class _NewTransactionDialogState extends State<NewTransactionDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form fields - matching React formData
  final dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  String transactionType = 'income';
  final amountController = TextEditingController();
  String? category;
  String paymentMethod = 'cash';
  final customerSupplierController = TextEditingController();
  final descriptionController = TextEditingController();
  String? receiptUrl;
  bool isUploadingReceipt = false;
  bool isSaving = false;

  @override
  void dispose() {
    dateController.dispose();
    amountController.dispose();
    customerSupplierController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 672), // max-w-2xl (672px)
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Directionality(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog Header
                  _buildHeader(isRTL),
                  const SizedBox(height: 24), // mt-4 (16px) + space

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Grid: Date + Type (2 columns)
                        _buildTwoColumnRow([
                          _buildDateField(isRTL),
                          _buildTypeField(isRTL),
                        ]),
                        const SizedBox(height: 16),

                        // Grid: Amount + Category (2 columns)
                        _buildTwoColumnRow([
                          _buildAmountField(isRTL),
                          _buildCategoryField(isRTL),
                        ]),
                        const SizedBox(height: 16),

                        // Grid: Payment Method + Customer/Supplier (2 columns)
                        _buildTwoColumnRow([
                          _buildPaymentMethodField(isRTL),
                          _buildCustomerSupplierField(isRTL),
                        ]),
                        const SizedBox(height: 16),

                        // Description (full width)
                        _buildDescriptionField(isRTL),
                        const SizedBox(height: 16),

                        // Receipt Upload (full width)
                        _buildReceiptUpload(isRTL),
                        const SizedBox(height: 24), // pt-4

                        // Action Buttons
                        _buildActionButtons(isRTL),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header - EXACT match with DialogHeader
  Widget _buildHeader(bool isRTL) {
    return Row(
      children: [
        Expanded(
          child: Text(
            isRTL ? 'إضافة معاملة جديدة' : 'Add New Transaction',
            style: const TextStyle(
              fontSize: 24, // text-2xl
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827), // text-gray-900
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// Two Column Row for responsive grid
  Widget _buildTwoColumnRow(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 640;

        if (isMobile) {
          return Column(
            children: [
              children[0],
              const SizedBox(height: 16),
              children[1],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 16), // gap-4
            Expanded(child: children[1]),
          ],
        );
      },
    );
  }

  /// Date Field
  Widget _buildDateField(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'التاريخ' : 'Date'),
        const SizedBox(height: 8), // space-y-2
        TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: _buildInputDecoration(''),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              dateController.text = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isRTL ? 'مطلوب' : 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Type Field (Income/Expense)
  Widget _buildTypeField(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'نوع المعاملة' : 'Transaction Type'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: transactionType,
          decoration: _buildInputDecoration(''),
          items: [
            DropdownMenuItem(
              value: 'income',
              child: Text(isRTL ? 'إيراد' : 'Income'),
            ),
            DropdownMenuItem(
              value: 'expense',
              child: Text(isRTL ? 'مصروف' : 'Expense'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              transactionType = value!;
              category = null; // Reset category when type changes
            });
          },
        ),
      ],
    );
  }

  /// Amount Field
  Widget _buildAmountField(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'المبلغ (د.إ)' : 'Amount (AED)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _buildInputDecoration('0.00'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isRTL ? 'مطلوب' : 'Required';
            }
            if (double.tryParse(value) == null) {
              return isRTL ? 'رقم غير صالح' : 'Invalid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Category Field (Dynamic based on type)
  Widget _buildCategoryField(bool isRTL) {
    final incomeCategories = [
      {'value': 'sales', 'label': isRTL ? 'مبيعات' : 'Sales'},
      {'value': 'services', 'label': isRTL ? 'خدمات' : 'Services'},
      {'value': 'other_income', 'label': isRTL ? 'دخل آخر' : 'Other Income'},
    ];

    final expenseCategories = [
      {'value': 'salaries', 'label': isRTL ? 'رواتب' : 'Salaries'},
      {'value': 'rent', 'label': isRTL ? 'إيجار' : 'Rent'},
      {'value': 'utilities', 'label': isRTL ? 'مرافق' : 'Utilities'},
      {'value': 'purchases', 'label': isRTL ? 'مشتريات' : 'Purchases'},
      {'value': 'marketing', 'label': isRTL ? 'تسويق' : 'Marketing'},
      {
        'value': 'transportation',
        'label': isRTL ? 'مواصلات' : 'Transportation'
      },
      {'value': 'maintenance', 'label': isRTL ? 'صيانة' : 'Maintenance'},
      {'value': 'taxes', 'label': isRTL ? 'ضرائب' : 'Taxes'},
      {
        'value': 'other_expense',
        'label': isRTL ? 'مصروف آخر' : 'Other Expense'
      },
    ];

    final categories =
        transactionType == 'income' ? incomeCategories : expenseCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'التصنيف' : 'Category'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: category,
          decoration:
              _buildInputDecoration(isRTL ? 'اختر التصنيف' : 'Select Category'),
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat['value'],
              child: Text(cat['label']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              category = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isRTL ? 'مطلوب' : 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Payment Method Field
  Widget _buildPaymentMethodField(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'طريقة الدفع' : 'Payment Method'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: paymentMethod,
          decoration: _buildInputDecoration(''),
          items: [
            DropdownMenuItem(
              value: 'cash',
              child: Text(isRTL ? 'نقداً' : 'Cash'),
            ),
            DropdownMenuItem(
              value: 'bank_transfer',
              child: Text(isRTL ? 'تحويل بنكي' : 'Bank Transfer'),
            ),
            DropdownMenuItem(
              value: 'credit_card',
              child: Text(isRTL ? 'بطاقة ائتمان' : 'Credit Card'),
            ),
            DropdownMenuItem(
              value: 'cheque',
              child: Text(isRTL ? 'شيك' : 'Cheque'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              paymentMethod = value!;
            });
          },
        ),
      ],
    );
  }

  /// Customer/Supplier Field (label changes based on type)
  Widget _buildCustomerSupplierField(bool isRTL) {
    final label = transactionType == 'income'
        ? (isRTL ? 'اسم العميل' : 'Customer Name')
        : (isRTL ? 'اسم المورد' : 'Supplier Name');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: customerSupplierController,
          decoration: _buildInputDecoration(isRTL ? 'اختياري' : 'Optional'),
        ),
      ],
    );
  }

  /// Description Field (full width, 3 rows)
  Widget _buildDescriptionField(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'الوصف' : 'Description'),
        const SizedBox(height: 8),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: _buildInputDecoration(
            isRTL ? 'تفاصيل المعاملة...' : 'Transaction details...',
          ),
        ),
      ],
    );
  }

  /// Receipt Upload Field
  Widget _buildReceiptUpload(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(isRTL ? 'إرفاق إيصال' : 'Attach Receipt'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isUploadingReceipt ? null : _handleReceiptUpload,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_file, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      isRTL ? 'اختر ملف' : 'Choose File',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            if (isUploadingReceipt) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
            if (receiptUrl != null) ...[
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  // TODO: Open receipt URL
                },
                child: Text(
                  isRTL ? 'عرض' : 'View',
                  style: const TextStyle(color: Color(0xFF3B82F6)),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Action Buttons (Cancel + Save)
  Widget _buildActionButtons(bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel Button
        OutlinedButton(
          onPressed: isSaving ? null : () => Get.back(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isRTL ? 'إلغاء' : 'Cancel',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const SizedBox(width: 12), // gap-3

        // Save Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF2563EB)
              ], // blue-500 to blue-600
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isSaving ? null : _handleSubmit,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSaving) ...[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      isSaving
                          ? (isRTL ? 'جاري الحفظ...' : 'Saving...')
                          : (isRTL ? 'حفظ المعاملة' : 'Save Transaction'),
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
        ),
      ],
    );
  }

  /// Helper: Build Label Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151), // text-gray-700
      ),
    );
  }

  /// Helper: Build Input Decoration
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  /// Handle Receipt Upload
  void _handleReceiptUpload() {
    // TODO: Implement file picker and upload
    setState(() {
      isUploadingReceipt = true;
    });

    // Simulate upload
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isUploadingReceipt = false;
        receiptUrl = 'https://example.com/receipt.pdf';
      });
    });
  }

  /// Handle Form Submit
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });

      // Create transaction model
      final transaction = TransactionModel(
        date: DateTime.parse(dateController.text),
        type: transactionType,
        amount: double.parse(amountController.text),
        category: category,
        paymentMethod: paymentMethod,
        customerSupplier: customerSupplierController.text.isEmpty
            ? null
            : customerSupplierController.text,
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        receiptUrl: receiptUrl,
      );

      // Call onSubmit callback
      if (widget.onSubmit != null) {
        widget.onSubmit!(transaction);
      }

      // Close dialog
      Get.back(result: transaction);
    }
  }
}
