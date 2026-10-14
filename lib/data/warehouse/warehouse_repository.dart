import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';

class WarehouseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Product?>> getBulkDataStock(String collection) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<OrderProduct>> getBulkDataOrder(String collection) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return OrderProduct.fromJson(doc.data(), docId: doc.id);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<SalesOrder>> getBulkDataSalesOrder(String collection) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return SalesOrder.fromJson(doc.data(), docId: doc.id);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<Product>> searchProducts(
      String collection, String searchKey) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot.docs
          .map((data) => Product.fromJson(data.data(), docId: data.id))
          .toList();

      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<OrderProduct>> searchOrder(
      String collection, String searchKey) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot.docs
          .map((data) => OrderProduct.fromJson(data.data(), docId: data.id))
          .toList();

      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<SalesOrder>> searchSalesOrder(
      String collection, String searchKey) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot = await query
          .where('product_name', isGreaterThanOrEqualTo: searchKey)
          .where('product_name', isLessThan: '${searchKey}z')
          .get();

      final result = snapshot.docs
          .map((data) => SalesOrder.fromJson(data.data(), docId: data.id))
          .toList();

      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<int> streamTotalProducts({String? adminId}) {
    Query<Map<String, dynamic>> query = firestore.collection("products");
    if (adminId != null && adminId.isNotEmpty) {
      query = query.where('admin_id', isEqualTo: adminId);
    }
    return query.snapshots().map((event) => event.docs.length);
  }

  Stream<int> streamGetQtyProduct({String? adminId}) {
    Query<Map<String, dynamic>> query = firestore.collection("products");
    if (adminId != null && adminId.isNotEmpty) {
      query = query.where('admin_id', isEqualTo: adminId);
    }
    return query.snapshots().map((snapshot) {
      int total = 0;
      for (var data in snapshot.docs) {
        total += (data['quantity']) as int;
      }
      return total;
    });
  }

  Stream<int> streamGetLowStock({String? adminId}) {
    Query<Map<String, dynamic>> query = firestore.collection("products");
    if (adminId != null && adminId.isNotEmpty) {
      query = query.where('admin_id', isEqualTo: adminId);
    }
    return query.snapshots().map((snapshot) {
      int total = 0;
      for (var data in snapshot.docs) {
        if (data['quantity'] <= 5) {
          total += 1;
        }
      }
      return total;
    });
  }

  Stream<int> streamGetUpcomingStock({String? adminId}) {
    Query<Map<String, dynamic>> query = firestore.collection("warehouse_orders");
    if (adminId != null && adminId.isNotEmpty) {
      query = query.where('admin_id', isEqualTo: adminId);
    }
    return query.snapshots().map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final isRejected = data['is_rejected'] == true;
        if (data['finance_approved'] == false && !isRejected) {
          total += 1;
        }
      }
      return total;
    });
  }

  Future<List<Product>> getLowStockProducts() async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection("products");
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot =
          await query.where('quantity', isLessThanOrEqualTo: 5).get();
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<OrderProduct>> getIncomingStockProducts() async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query =
          firestore.collection("warehouse_orders");
      if (adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }
      final snapshot =
          await query.where('finance_approved', isEqualTo: false).get();
      return snapshot.docs
          .map((doc) => OrderProduct.fromJson(doc.data(), docId: doc.id))
          .where((order) => order.isRejected != true)
          .toList();
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