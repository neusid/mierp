import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

class PayProductOrderServices {
  TransactionRepository transactionRepository;
  ItemStore itemStore;

  PayProductOrderServices(this.transactionRepository, this.itemStore);

  Future<void> payInvoice(docId, prodId, totalQty) async {
    try {

      // if (totalQty >= product!.quantity) {
      //   throw Exception("Out of stock");
      // }
      // final now = DateTime.now();
      // final dateParse = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      // transactionRepository.payProductOrderInvoice(prodId, totalQty, dateParse);
    } catch(e) {
      rethrow;
    }
  }
}