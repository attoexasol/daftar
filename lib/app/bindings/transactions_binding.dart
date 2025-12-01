import 'package:daftar/presentation/auth/controllers/transactions_controller.dart';
import 'package:get/get.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Transactions Binding
/// Initializes dependencies for transactions screen
class TransactionsBinding extends Bindings {
  @override
  void dependencies() {
    // Put repository
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(),
    );

    // Put controller
    Get.lazyPut<TransactionsController>(
      () => TransactionsController(
        repository: Get.find<TransactionRepository>(),
      ),
    );
  }
}
