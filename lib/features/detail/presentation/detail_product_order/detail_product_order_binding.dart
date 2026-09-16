
import 'package:get/get.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product_order/detail_product_order_view_model.dart';
import 'package:mierp_apps/state/item_store.dart';

class DetailProductOrderBinding extends Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    final id = Get.parameters['id'];
    Get.put(DetailProductOrderViewModel(id: id, itemRepository: Get.find<ItemRepository>(), itemStore: Get.find<ItemStore>(), transactionServices: Get.find<TransactionServices>()));
  }
}