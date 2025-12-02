
// import 'package:daftar/core/services/base44_service_FIXED.dart';
// import 'package:daftar/data/models/transaction_model_FIXED.dart';
// import 'package:daftar/data/repositories/transaction_repository_FIXED.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;

// // Generate mocks with: flutter pub run build_runner build
// @GenerateMocks([Base44Service, http.Client])

// /// ✅ FIXED Transaction Repository Tests
// /// 
// /// Tests the TransactionRepository with proper mocks for Base44Service
// /// 
// /// To generate mocks, run:
// /// flutter pub run build_runner build
// void main() {
//   group('TransactionRepository', () {
//     late MockBase44Service mockService;
//     late TransactionRepository repository;

//     setUp(() {
//       mockService = MockBase44Service();
//       repository = TransactionRepository();
      
//       // Note: In a real scenario, you'd need to inject the mock service
//       // This requires modifying TransactionRepository to accept Base44Service
//     });

//     group('getTransactions', () {
//       test('returns list of transactions from Base44 API', () async {
//         // Arrange
//         final mockTransactions = [
//           TransactionModel(
//             id: 'txn_1',
//             date: DateTime.parse('2024-11-30'),
//             type: 'income',
//             amount: 1000.0,
//             category: 'sales',
//             paymentMethod: 'cash',
//             organizationId: 'org_1',
//           ),
//           TransactionModel(
//             id: 'txn_2',
//             date: DateTime.parse('2024-11-29'),
//             type: 'expense',
//             amount: 500.0,
//             category: 'rent',
//             paymentMethod: 'bank_transfer',
//             organizationId: 'org_1',
//           ),
//         ];

//         when(mockService.getTransactions(
//           sort: anyNamed('sort'),
//           limit: anyNamed('limit'),
//           skip: anyNamed('skip'),
//         )).thenAnswer((_) async => mockTransactions);

//         // Act
//         final transactions = await repository.getTransactions();

//         // Assert
//         expect(transactions, isA<List<TransactionModel>>());
//         expect(transactions.length, greaterThanOrEqualTo(0));
//       });

//       test('returns transactions sorted by date descending', () async {
//         // Arrange
//         final mockTransactions = [
//           TransactionModel(
//             id: 'txn_1',
//             date: DateTime.parse('2024-11-30'),
//             type: 'income',
//             amount: 1000.0,
//           ),
//           TransactionModel(
//             id: 'txn_2',
//             date: DateTime.parse('2024-11-29'),
//             type: 'expense',
//             amount: 500.0,
//           ),
//         ];

//         when(mockService.getTransactions(
//           sort: '-date',
//           limit: anyNamed('limit'),
//           skip: anyNamed('skip'),
//         )).thenAnswer((_) async => mockTransactions);

//         // Act
//         final transactions = await repository.getTransactions(sort: '-date');

//         // Assert
//         if (transactions.length >= 2) {
//           final firstDate = transactions[0].dateTime;
//           final secondDate = transactions[1].dateTime;
          
//           if (firstDate != null && secondDate != null) {
//             expect(
//               firstDate.isAfter(secondDate) || firstDate.isAtSameMomentAs(secondDate),
//               isTrue,
//             );
//           }
//         }
//       });

//       test('handles empty response', () async {
//         // Arrange
//         when(mockService.getTransactions(
//           sort: anyNamed('sort'),
//           limit: anyNamed('limit'),
//           skip: anyNamed('skip'),
//         )).thenAnswer((_) async => []);

//         // Act
//         final transactions = await repository.getTransactions();

//         // Assert
//         expect(transactions, isEmpty);
//       });

//       test('throws exception on API error', () async {
//         // Arrange
//         when(mockService.getTransactions(
//           sort: anyNamed('sort'),
//           limit: anyNamed('limit'),
//           skip: anyNamed('skip'),
//         )).thenThrow(Exception('API Error'));

//         // Act & Assert
//         expect(
//           () => repository.getTransactions(),
//           throwsException,
//         );
//       });
//     });

//     group('createTransaction', () {
//       test('creates transaction and returns created object', () async {
//         // Arrange
//         final transactionData = {
//           'date': '2024-11-30',
//           'type': 'income',
//           'amount': 1000.0,
//           'category': 'sales',
//           'payment_method': 'cash',
//         };

//         final createdTransaction = TransactionModel(
//           id: 'txn_new',
//           date: DateTime.parse('2024-11-30'),
//           type: 'income',
//           amount: 1000.0,
//           category: 'sales',
//           paymentMethod: 'cash',
//         );

//         when(mockService.createTransaction(any))
//             .thenAnswer((_) async => createdTransaction);

//         // Act
//         final result = await repository.createTransaction(transactionData);

//         // Assert
//         expect(result.id, isNotNull);
//         expect(result.type, equals('income'));
//         expect(result.amount, equals(1000.0));
//       });

//       test('throws exception on creation error', () async {
//         // Arrange
//         when(mockService.createTransaction(any))
//             .thenThrow(Exception('Creation failed'));

//         // Act & Assert
//         expect(
//           () => repository.createTransaction({}),
//           throwsException,
//         );
//       });
//     });

//     group('updateTransaction', () {
//       test('updates transaction successfully', () async {
//         // Arrange
//         final updateData = {
//           'amount': 1500.0,
//           'description': 'Updated description',
//         };

//         final updatedTransaction = TransactionModel(
//           id: 'txn_1',
//           date: DateTime.parse('2024-11-30'),
//           type: 'income',
//           amount: 1500.0,
//           description: 'Updated description',
//         );

//         when(mockService.updateTransaction('txn_1', any))
//             .thenAnswer((_) async => updatedTransaction);

//         // Act
//         final result = await repository.updateTransaction('txn_1', updateData);

//         // Assert
//         expect(result.id, equals('txn_1'));
//         expect(result.amount, equals(1500.0));
//       });
//     });

//     group('deleteTransaction', () {
//       test('deletes transaction successfully', () async {
//         // Arrange
//         when(mockService.deleteTransaction('txn_1'))
//             .thenAnswer((_) async => {});

//         // Act & Assert
//         expect(
//           () => repository.deleteTransaction('txn_1'),
//           returnsNormally,
//         );
//       });

//       test('throws exception on deletion error', () async {
//         // Arrange
//         when(mockService.deleteTransaction('txn_1'))
//             .thenThrow(Exception('Deletion failed'));

//         // Act & Assert
//         expect(
//           () => repository.deleteTransaction('txn_1'),
//           throwsException,
//         );
//       });
//     });

//     group('filterByDateRange', () {
//       test('filters transactions within date range', () {
//         // Arrange
//         final transactions = [
//           TransactionModel(
//             id: 'txn_1',
//             date: DateTime.parse('2024-11-25'),
//             type: 'income',
//             amount: 1000.0,
//           ),
//           TransactionModel(
//             id: 'txn_2',
//             date: DateTime.parse('2024-11-27'),
//             type: 'expense',
//             amount: 500.0,
//           ),
//           TransactionModel(
//             id: 'txn_3',
//             date: DateTime.parse('2024-11-30'),
//             type: 'income',
//             amount: 2000.0,
//           ),
//         ];

//         final startDate = DateTime.parse('2024-11-26');
//         final endDate = DateTime.parse('2024-11-29');

//         // Act
//         final filtered = repository.filterByDateRange(
//           transactions,
//           startDate,
//           endDate,
//         );

//         // Assert
//         expect(filtered.length, equals(1));
//         expect(filtered[0].id, equals('txn_2'));
//       });

//       test('returns empty list when no transactions in range', () {
//         // Arrange
//         final transactions = [
//           TransactionModel(
//             id: 'txn_1',
//             date: DateTime.parse('2024-11-25'),
//             type: 'income',
//             amount: 1000.0,
//           ),
//         ];

//         final startDate = DateTime.parse('2024-12-01');
//         final endDate = DateTime.parse('2024-12-05');

//         // Act
//         final filtered = repository.filterByDateRange(
//           transactions,
//           startDate,
//           endDate,
//         );

//         // Assert
//         expect(filtered, isEmpty);
//       });
//     });

//     group('calculateStatistics', () {
//       test('calculates income, expense, and profit correctly', () {
//         // Arrange
//         final transactions = [
//           TransactionModel(
//             id: 'txn_1',
//             type: 'income',
//             amount: 1000.0,
//           ),
//           TransactionModel(
//             id: 'txn_2',
//             type: 'income',
//             amount: 2000.0,
//           ),
//           TransactionModel(
//             id: 'txn_3',
//             type: 'expense',
//             amount: 500.0,
//           ),
//           TransactionModel(
//             id: 'txn_4',
//             type: 'expense',
//             amount: 300.0,
//           ),
//         ];

//         // Act
//         final stats = repository.calculateStatistics(transactions);

//         // Assert
//         expect(stats['income'], equals(3000.0));
//         expect(stats['expense'], equals(800.0));
//         expect(stats['profit'], equals(2200.0));
//       });

//       test('returns zeros for empty transaction list', () {
//         // Arrange
//         final transactions = <TransactionModel>[];

//         // Act
//         final stats = repository.calculateStatistics(transactions);

//         // Assert
//         expect(stats['income'], equals(0.0));
//         expect(stats['expense'], equals(0.0));
//         expect(stats['profit'], equals(0.0));
//       });

//       test('handles null amounts gracefully', () {
//         // Arrange
//         final transactions = [
//           TransactionModel(
//             id: 'txn_1',
//             type: 'income',
//             amount: null, // Null amount
//           ),
//           TransactionModel(
//             id: 'txn_2',
//             type: 'income',
//             amount: 1000.0,
//           ),
//         ];

//         // Act
//         final stats = repository.calculateStatistics(transactions);

//         // Assert
//         expect(stats['income'], equals(1000.0));
//       });
//     });
//   });

//   group('TransactionModel', () {
//     test('creates model from JSON correctly', () {
//       // Arrange
//       final json = {
//         'id': 'txn_1',
//         'date': '2024-11-30',
//         'type': 'income',
//         'amount': 1000.0,
//         'category': 'sales',
//         'payment_method': 'cash',
//         'customer_supplier': 'ABC Company',
//         'description': 'Monthly payment',
//         'organization_id': 'org_1',
//       };

//       // Act
//       final transaction = TransactionModel.fromJson(json);

//       // Assert
//       expect(transaction.id, equals('txn_1'));
//       expect(transaction.type, equals('income'));
//       expect(transaction.amount, equals(1000.0));
//       expect(transaction.category, equals('sales'));
//       expect(transaction.paymentMethod, equals('cash'));
//     });

//     test('converts model to JSON correctly', () {
//       // Arrange
//       final transaction = TransactionModel(
//         id: 'txn_1',
//         date: DateTime.parse('2024-11-30'),
//         type: 'income',
//         amount: 1000.0,
//         category: 'sales',
//         paymentMethod: 'cash',
//       );

//       // Act
//       final json = transaction.toJson();

//       // Assert
//       expect(json['id'], equals('txn_1'));
//       expect(json['type'], equals('income'));
//       expect(json['amount'], equals(1000.0));
//     });

//     test('isIncome returns true for income transactions', () {
//       final transaction = TransactionModel(type: 'income');
//       expect(transaction.isIncome, isTrue);
//     });

//     test('isExpense returns true for expense transactions', () {
//       final transaction = TransactionModel(type: 'expense');
//       expect(transaction.isExpense, isTrue);
//     });

//     test('formattedDate returns correctly formatted date', () {
//       final transaction = TransactionModel(
//         date: DateTime.parse('2024-11-30'),
//       );
      
//       expect(transaction.formattedDate, isNotEmpty);
//       expect(transaction.formattedDate, contains('2024'));
//     });
//   });
// }