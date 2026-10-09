import 'package:flutter/material.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';

class ItemStore extends ChangeNotifier {

  List<Product?> listProduct = <Product>[];
  List<OrderProduct?> listOrder = <OrderProduct>[];
  List<SalesOrder?> listSalesOrder = <SalesOrder>[];
  List<AllSummary?> listAllSummary = <AllSummary?>[];

  ValueNotifier<Product?> products = ValueNotifier(null);
  ValueNotifier<OrderProduct?> orderProducts = ValueNotifier(null);
  ValueNotifier<SalesOrder?> salesOrders = ValueNotifier(null);

  void _combineAllSummary() {
    if (listProduct.isEmpty && listOrder.isEmpty && listSalesOrder.isEmpty) {
      return;
    }

    final combined = <AllSummary>[];

    combined.addAll(
      listProduct.map((e) => AllSummary(summaryType: SummaryType.product, data: e, createdOn: e!.createdOn))
    );
    combined.addAll(
      listOrder.map((e) => AllSummary(summaryType: SummaryType.order, data: e, createdOn: e!.orderDate!))
    );
    combined.addAll(
      listSalesOrder.map((e) => AllSummary(summaryType: SummaryType.salesOrder, data: e, createdOn: e!.purchasedDate))
    );
    
    combined.sort((a, b) => b.createdOn.compareTo(a.createdOn));

    listAllSummary = combined;
    notifyListeners();
  }

  void setProductsList(List<Product> product) {
    listProduct = List.from(product);
    listProduct.sort((a, b) => b!.createdOn.compareTo(a!.createdOn));
    notifyListeners();
  }

  void setSalesOrderList(List<SalesOrder> salesOrder) {
    listSalesOrder = List.from(salesOrder);
    listSalesOrder.sort((a, b) => b!.purchasedDate.compareTo(a!.purchasedDate));
    _combineAllSummary();
  }

  void setOrderProductList(List<OrderProduct> orderProduct) {
    listOrder = List.from(orderProduct);
    listOrder.sort((a, b) => b!.orderDate!.compareTo(a!.orderDate!));
    notifyListeners();
  }

  void setProducts(Product product) {
    products.value = product;
  }

  void setSalesOrder(SalesOrder salesOrder) {
    salesOrders.value = salesOrder;
  }

  void setOrderProduct(OrderProduct orderProduct) {
    orderProducts.value = orderProduct;
  }

  void clearDetailProduct() {
    products.value = null;
    orderProducts.value = null;
    salesOrders.value = null;
  }
}