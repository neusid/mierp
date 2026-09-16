import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/data/item/repositories/item_repository_impl.dart';

class ItemStore extends GetxController {

  RxList<Product?> listProduct = <Product>[].obs;
  RxList<OrderProduct?> listOrder = <OrderProduct>[].obs;
  RxList<SalesOrder?> listSalesOrder = <SalesOrder>[].obs;
  RxList<AllSummary?> listAllSummary = <AllSummary?>[].obs;

  Rxn<Product> products = Rxn();
  Rxn<OrderProduct> orderProducts = Rxn();
  Rxn<SalesOrder> salesOrders = Rxn();

  void _combineAllSummary() {

    if(listProduct.isEmpty&&listOrder.isEmpty&&listSalesOrder.isEmpty){
      return;
    }

    final combined = <AllSummary>[];

    combined.addAll(
        listProduct.map((e) => AllSummary(summaryType: SummaryType.product, data: e, createdOn: e!.createdOn),)
    );
    combined.addAll(
        listOrder.map((e) => AllSummary(summaryType: SummaryType.order, data: e, createdOn: e!.orderDate!),)
    );
    combined.addAll(
        listSalesOrder.map((e) => AllSummary(summaryType: SummaryType.salesOrder, data: e, createdOn: e!.purchasedDate),)
    );
    combined.sort((a, b) => b.createdOn.compareTo(a.createdOn),);

    listAllSummary.assignAll(combined);
  }

  void setProductsList(List<Product> product) {
    listProduct.assignAll(product);
    listProduct.sort((a, b) => b!.createdOn.compareTo(a!.createdOn),);
  }

  void setSalesOrderList(List<SalesOrder> salesOrder) {
    listSalesOrder.assignAll(salesOrder);
    listSalesOrder.sort((a, b) => b!.purchasedDate.compareTo(a!.purchasedDate),);
    _combineAllSummary();
  }

  void setOrderProductList(List<OrderProduct> orderProduct) {
    listOrder.assignAll(orderProduct);
    listOrder.sort((a, b) => b!.orderDate!.compareTo(a!.orderDate!),);
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