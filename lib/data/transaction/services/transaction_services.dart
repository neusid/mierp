import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

class TransactionServices extends GetxService {

  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionRepository transactionRepository;

  TransactionServices({required this.itemRepository, required this.itemStore, required this.transactionRepository});

  Future<void> payProductOrderServices(docId, prodId, totalQty) async {
    try {
      await itemRepository.getDetailDataStock(prodId);
      final stock = await itemStore.products.value!.quantity;

      if (totalQty >= stock) {
        throw Exception("Out of stock");
      }
      final now = DateTime.now();
      final dateParse = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await transactionRepository.payProductOrderInvoice(docId, prodId, totalQty, dateParse);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> paySalesOrderServices(docId, prodId, totalQty) async {
    try {
      await itemRepository.getDetailDataStock(prodId);
      final stock = await itemStore.products.value!.quantity;

      if (totalQty >= stock) {
        throw Exception("Out of stock");
      }
      final now = DateTime.now();
      final dateParse = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await transactionRepository.paySalesOrderInvoice(docId, prodId, totalQty, dateParse);
    } catch(e) {
      rethrow;
    }
  }
}