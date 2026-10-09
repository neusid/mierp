import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

class WarehouseRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<List<Product?>> getBulkDataStock(String collection) async {
    try {
      final snapshot = await firestore.collection(collection).get();

      return snapshot.docs.map(
          (doc)=>Product.fromJson(doc.data(), docId: doc.id)
      ).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<OrderProduct>> getBulkDataOrder(String collection) async {
    try {
      final snapshot = await firestore.collection(collection).get();

      return snapshot.docs.map(
              (doc){
            return OrderProduct.fromJson(doc.data(), docId: doc.id);
          }
      ).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<SalesOrder>> getBulkDataSalesOrder(String collection) async {
    try {
      final snapshot = await firestore.collection(collection).get();

      return snapshot.docs.map(
              (doc){
            debugPrint("ini ${doc.data()}");
            return SalesOrder.fromJson(doc.data(), docId: doc.id);
          }
      ).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<Product>> searchProducts(String collection, String searchKey) async {
    try {
      // final snapshot = await firestore.collection(collection).get();

      final snapshot  = await firestore.collection(collection)
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot
          .docs.map((data)=>Product.fromJson(data.data(), docId: data.id))
          .toList();

      return result;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<OrderProduct>> searchOrder(String collection, String searchKey) async {
    try {
      final snapshot = await firestore.collection(collection)
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot.docs.map((data) => OrderProduct.fromJson(data.data(), docId: data.id)).toList();

      return result;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<SalesOrder>> searchSalesOrder(String collection, String searchKey) async {
    try {
      final snapshot = await firestore.collection(collection)
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot.docs.map((data) => SalesOrder.fromJson(data.data(),docId: data.id)).toList();

      return result;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<int> streamTotalProducts() {
    return firestore.collection("products").snapshots().map(
          (event) {
        int total = event.docs.length;
        return total;
      },
    );
  }


  Stream<int> streamGetQtyProduct() {
    return firestore.collection("products").snapshots().map(
        (snapshot) {
          int total = 0;
          for(var data in snapshot.docs) {
            total += (data['quantity']) as int;
          }
          return total;
        }
    );
  }

  Stream<int> streamGetLowStock() {
    return firestore.collection("products").snapshots().map(
        (snapshot) {
          int total = 0;

          for (var data in snapshot.docs) {
            if (data['quantity'] <= 5) {
              total += 1;
            }
          }

          return total;
        }
    );
  }

  Stream<int> streamGetUpcomingStock() {
    return firestore.collection("warehouse_orders").snapshots().map(
        (snapshot) {
          int total = 0;
          for (var data in snapshot.docs) {
            if (data['finance_approved'] == false) {
              total += 1;
            }
          }
          return total;
        }
    );
  }
  Future<List<Product>> getLowStockProducts() async {
    try {
      final snapshot = await firestore.collection("products").where('quantity', isLessThanOrEqualTo: 5).get();
      return snapshot.docs.map((doc) => Product.fromJson(doc.data(), docId: doc.id)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<OrderProduct>> getIncomingStockProducts() async {
    try {
      final snapshot = await firestore.collection("warehouse_orders").where('finance_approved', isEqualTo: false).get();
      return snapshot.docs.map((doc) => OrderProduct.fromJson(doc.data(), docId: doc.id)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  DateTime? parseDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}