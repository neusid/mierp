import 'package:get/get.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';

class DetailProductServices extends GetxService {
  final ItemRepository itemRepository;
  DetailProductServices({required this.itemRepository});

  Future<void> updateDataProduct(prodId, Product product) async {
    try {
      await itemRepository.updateDetailDataStock(prodId, product);
      await itemRepository.getDetailDataStock(prodId);
      await itemRepository.getBulkDataStock();
    } catch(e) {
      print("$e");
      rethrow;
    }
  }

  Future<void> deleteDataProduct(prodId) async {
    try {
      await itemRepository.deleteDetailDataStock(prodId);
      await itemRepository.getBulkDataStock();
    } catch(e) {
      print("$e");
      rethrow;
    }
  }
}