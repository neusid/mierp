import 'package:mierp_apps/core/models/product.dart';

abstract class ItemRepository {

  Future<void> getBulkDataStock();
  Future<void> getBulkDataOrder();
  Future<void> getBulkDataSalesOrder();

  Future<void> getDetailDataStock(prodId);
  Future<void> getDetailDataOrder(id);
  Future<void> getDetailDataSalesOrder(prodId);

  Future<void> updateDetailDataStock(prodId, Product product);
  Future<void> deleteDetailDataStock(prodId);
}