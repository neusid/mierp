
import 'package:get/get.dart';
import 'package:mierp_apps/data/finance/services/detail_product_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';
import 'package:mierp_apps/state/item_store.dart';

class DetailProductBinding extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies

    final id = Get.parameters['id'];
    Get.put(DetailProductViewModel(id: id, itemRepository: Get.find<ItemRepository>(), itemStore: Get.find<ItemStore>(), detailProductServices: Get.find<DetailProductServices>()));
  }
}