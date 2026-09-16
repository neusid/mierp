import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';

class DetailProductOrderRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<OrderProduct> getSingleProductOrder(docId) async {
    try {
      final snapshot = await firestore.collection("warehouse_orders").doc(docId).get();
      OrderProduct orderProduct = OrderProduct.fromJson(snapshot.data()!, docId: docId);
      return orderProduct;
    } catch(e) {
      rethrow;
    }
  }

  Future<Product> getProduct(docId) async {
    try {
      final snapshot = await firestore.collection("products").doc(docId).get();
      if (!snapshot.exists || snapshot.data() == null) {
        throw Exception("PRODUCT_NOT_FOUND");
      }
      Product product = Product.fromJson(snapshot.data()!, docId: docId);
      return product;
    } catch(e) {
      rethrow;
    }
  }

  Future<void> payInvoiceProduct(docId, prodId, dateNow, totalQty) async {
    try {
      await firestore.runTransaction((transaction) async {
        transaction.update(
          firestore.collection("warehouse_orders").doc(docId),
          {
            "finance_approved": true,
            "finance_approved_date": dateNow
          },
        );
        transaction.update(
          firestore.collection("products").doc(prodId),
          {
            "quantity": FieldValue.increment(totalQty)
          }
        );
      },);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> deleteSingleProduct(docId) async {
    try {
      await firestore.collection("warehouse_orders").doc(docId).delete();
    } catch(e) {
      rethrow;
    }
  }
}