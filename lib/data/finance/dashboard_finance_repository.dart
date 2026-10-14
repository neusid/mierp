
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';

class DashboardFinanceRepository {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<OrderProduct>> getProduct() async {
    final snapshot = await firestore.collection("products").get();
    return snapshot.docs.map((e) => OrderProduct.fromJson(e.data(), docId: e.id),).toList();
  }

  Stream<int> getTotalProducts() {
    return firestore.collection("products").snapshots().map(
          (event) {
        int total = event.docs.length;
        return total;
      },
    );
  }

  Stream<int> getTotalQty() {
    return firestore.collection("products").snapshots().map(
      (event) {
        int total = 0;
        for (var data in event.docs) {
          total += (data['quantity']) as int;
        }
        return total;
      },
    );
  }

  Stream<int> getLowStock() {
    return firestore.collection("products").snapshots().map(
      (event) {
        int total = 0;
        for (var data in event.docs) {
          if(data['quantity'] <= 5) {
            total +=1;
          }
        }
        return total;
      },
    );
  }

  Stream<int> getUpcomingStock() {
    return firestore.collection('warehouse_orders').snapshots().map(
          (event) {
        int total = 0;
        for (var doc in event.docs) {
          final data = doc.data();
          final isRejected = data['is_rejected'] == true;
          if (data['finance_approved'] == false && !isRejected) total += 1;
        }
        return total;
      },
    );
  }

  Stream<int> getProductItems() {
    return firestore.collection('products').snapshots().map(
      (event) {
        int total = 0;
        for (var data in event.docs) {
          total += (data['unit_price'] as int);
        }
        return total;
      },
    );
  }
  
  Stream<int> getSettledItems() {
    return firestore.collection('warehouse_orders').snapshots().map(
      (event) {
        int total = 0;
        for (var data in event.docs) {
          if (data['finance_approved'] == true)  total += (data['total_cost'] as int);
        }
        return total;
      },
    );
  }

  Stream<int> getAccountPayables() {
    return firestore.collection('warehouse_orders').snapshots().map(
      (event) {
        int total = 0;
        for (var doc in event.docs) {
          final data = doc.data();
          final isRejected = data['is_rejected'] == true;
          if (data['finance_approved'] == false && !isRejected) total += (data['total_cost'] as int);
        }
        return total;
      },
    );
  }

  Stream<int> getAccountReceivables() {
    return firestore.collection('sales_orders').snapshots().map(
      (event) {
        int total = 0;
        for (var doc in event.docs) {
          final data = doc.data();
          final isRejected = data['is_rejected'] == true;
          if (data['finance_approved'] == false && !isRejected) total += (data['total_price'] as int);
        }
        return total;
      },
    );
  }

  Future<List<Product?>> getAllDataStock() async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection('products');
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

  Future<List<OrderProduct>> getAllDataOrder() async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection('warehouse_orders');
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

  Future<List<SalesOrder>> getAllDataSalesOrder() async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      Query<Map<String, dynamic>> query = firestore.collection('sales_orders');
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

  // ===========================================================================
  // 🏦 FINANCIAL MUTATIONS REPOSITORY METHODS (BANK LEDGER COLLECTION)
  // ===========================================================================
  Future<void> syncAndBackfillExistingSettledOrders() async {
    try {
      final ordersSnap = await firestore.collection('warehouse_orders')
          .where('finance_approved', isEqualTo: true)
          .get();

      for (var doc in ordersSnap.docs) {
        final docId = doc.id;
        final data = doc.data();
        final mutationRef = firestore.collection("financial_mutations").doc("mut_po_$docId");
        final existingSnap = await mutationRef.get();
        if (!existingSnap.exists) {
          final approvedDateStr = data['finance_approved_date']?.toString() ?? data['order_date']?.toString() ?? '';
          final dt = DateTime.tryParse(approvedDateStr) ?? DateTime.now();
          final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
          await mutationRef.set({
            'id': "mut_po_$docId",
            'reference_id': docId,
            'reference_type': 'product_order',
            'flow': 'outflow',
            'amount': data['total_cost'] ?? 
                ((num.tryParse(data['unit_price']?.toString() ?? '0') ?? 0) * (num.tryParse(data['quantity']?.toString() ?? '0') ?? 0)),
            'party_name': (data['first_name'] != null && data['first_name'].toString().isNotEmpty)
                ? data['first_name']
                : 'Pengadaan Unit',
            'product_name': data['product_name'] ?? '',
            'quantity': num.tryParse(data['quantity']?.toString() ?? '0') ?? 0,
            'unit_price': data['unit_price'] ?? 0,
            'discount_percent': data['discount_percent'],
            'discount_max': data['discount_max'],
            'image_product': data['image_product'],
            'status': 'settled',
            'approved_date': approvedDateStr.isNotEmpty ? approvedDateStr : dt.toIso8601String(),
            'timestamp': Timestamp.fromDate(dt),
            'period': period,
            'year': dt.year,
            'month': dt.month,
            'day': dt.day,
          });
        }
      }

      final salesSnap = await firestore.collection('sales_orders')
          .where('finance_approved', isEqualTo: true)
          .get();

      for (var doc in salesSnap.docs) {
        final docId = doc.id;
        final data = doc.data();
        final mutationRef = firestore.collection("financial_mutations").doc("mut_so_$docId");
        final existingSnap = await mutationRef.get();
        if (!existingSnap.exists) {
          final approvedDateStr = data['finance_approved_date']?.toString() ?? data['purchased_date']?.toString() ?? '';
          final dt = DateTime.tryParse(approvedDateStr) ?? DateTime.now();
          final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
          await mutationRef.set({
            'id': "mut_so_$docId",
            'reference_id': docId,
            'reference_type': 'sales_order',
            'flow': 'inflow',
            'amount': data['total_price'] ?? 
                ((num.tryParse(data['unit_price']?.toString() ?? '0') ?? 0) * (num.tryParse(data['quantity']?.toString() ?? '0') ?? 0)),
            'party_name': (data['company_name'] != null && data['company_name'].toString().isNotEmpty)
                ? data['company_name']
                : (data['first_name'] ?? 'Customer'),
            'product_name': data['product_name'] ?? '',
            'quantity': num.tryParse(data['quantity']?.toString() ?? '0') ?? 0,
            'unit_price': data['unit_price'] ?? 0,
            'discount_percent': data['discount_percent'],
            'discount_max': data['discount_max'],
            'image_product': data['image_product'],
            'status': 'settled',
            'approved_date': approvedDateStr.isNotEmpty ? approvedDateStr : dt.toIso8601String(),
            'timestamp': Timestamp.fromDate(dt),
            'period': period,
            'year': dt.year,
            'month': dt.month,
            'day': dt.day,
          });
        }
      }
    } catch (e) {
      debugPrint("Error in syncAndBackfillExistingSettledOrders: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFinancialMutations({String? period}) async {
    try {
      Query query = firestore.collection("financial_mutations");
      if (period != null && period.isNotEmpty && period != "all") {
        query = query.where("period", isEqualTo: period);
      }
      final snapshot = await query.get();
      final list = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      
      list.sort((a, b) {
        final dtA = DateTime.tryParse(a['approved_date']?.toString() ?? '') ?? 
            (a['timestamp'] is Timestamp ? (a['timestamp'] as Timestamp).toDate() : DateTime(2000));
        final dtB = DateTime.tryParse(b['approved_date']?.toString() ?? '') ?? 
            (b['timestamp'] is Timestamp ? (b['timestamp'] as Timestamp).toDate() : DateTime(2000));
        return dtB.compareTo(dtA);
      });
      return list;
    } catch (e) {
      debugPrint("Error in getFinancialMutations: $e");
      return [];
    }
  }

  Future<List<String>> getAvailableMutationPeriods() async {
    try {
      final snapshot = await firestore.collection("financial_mutations").get();
      final Set<String> periods = {};
      for (var doc in snapshot.docs) {
        final p = doc.data()['period']?.toString();
        if (p != null && p.isNotEmpty) {
          periods.add(p);
        }
      }
      final sorted = periods.toList()..sort((a, b) => b.compareTo(a));
      return sorted;
    } catch (e) {
      debugPrint("Error in getAvailableMutationPeriods: $e");
      return [];
    }
  }

  Stream<int> getNetCashBalanceStream() {
    return firestore.collection('financial_mutations').snapshots().map((event) {
      int balance = 0;
      for (var doc in event.docs) {
        final data = doc.data();
        final flow = data['flow']?.toString();
        final amount = (data['amount'] as num?)?.toInt() ?? 0;
        if (flow == 'inflow') {
          balance += amount;
        } else if (flow == 'outflow') {
          balance -= amount;
        }
      }
      return balance;
    });
  }
}