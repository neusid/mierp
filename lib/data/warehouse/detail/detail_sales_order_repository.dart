import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

class DetailSalesOrderRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<SalesOrder> getSingleSalesOrder(docId) async {
    try {
      final snapshot = await firestore.collection("sales_orders").doc(docId).get();
      SalesOrder orderSales = SalesOrder.fromJson(snapshot.data()!, docId: docId);
      return orderSales;
    } catch(e) {
      rethrow;
    }
  }

  Future<void> deleteSingleSalesOrder(docId) async {
    try {
      await firestore.collection("sales_orders").doc(docId).delete();
    } catch(e) {
      rethrow;
    }
  }

  Future<Product> getProduct(prodId) async {
    try {
      final snapshot = await firestore.collection("products").doc(prodId).get();
      Product product = Product.fromJson(snapshot.data()!, docId: prodId);
      return product;
    } catch(e) {
      rethrow;
    }
  }
  
  Future<void> payInvoiceOrder(docId, prodId, dateNow, totalQty) async {
    try {
      await firestore.collection("sales_orders").doc(docId).update(
        {
          'finance_approved': true,
          'finance_approved_date': dateNow,
        }
      );
      await firestore.collection("products").doc(prodId).update(
          {
            'quantity': FieldValue.increment(-totalQty),
          }
      );
    } catch(e) {
      rethrow;
    }
  }
}