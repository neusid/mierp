import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

abstract class ItemRepository {

  Future<void> getBulkDataStock();
  Future<void> getBulkDataOrder();
  Future<void> getBulkDataSalesOrder();

  Future<Product> getDetailDataStock(String prodId);
  Future<OrderProduct> getDetailDataOrder(String id);
  Future<SalesOrder> getDetailDataSalesOrder(String prodId);

  Future<void> updateDetailDataStock(prodId, Product product);
  Future<void> deleteDetailDataStock(prodId);
}