import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {

  FirebaseFirestore firestore;

  TransactionRepositoryImpl({required this.firestore});

  @override
  Future<void> payProductOrderInvoice(docId, prodId, totalQty, date) async {
    try {
      await firestore.runTransaction(
        (transaction) async {
          // 1. ALL READS FIRST (Firestore requires all reads before any writes)
          final orderRef = firestore.collection("warehouse_orders").doc(docId.toString());
          final orderSnap = await transaction.get(orderRef);

          DocumentReference? prodRef;
          DocumentSnapshot? prodSnap;
          if (prodId != null && prodId.toString().isNotEmpty) {
            prodRef = firestore.collection("products").doc(prodId.toString());
            prodSnap = await transaction.get(prodRef);
          }

          // 2. ALL WRITES AFTER READS
          final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
          final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";

          if (orderSnap.exists) {
            transaction.update(orderRef, {
              'finance_approved': true,
              'finance_approved_date': date,
              'period': period,
            });
          }

          if (prodRef != null && prodSnap != null && prodSnap.exists) {
            final num qtyNum = totalQty is num ? totalQty : (num.tryParse(totalQty.toString()) ?? 0);
            transaction.update(prodRef, {
              "quantity": FieldValue.increment(qtyNum),
            });
          }
        },
      );

      // Best-effort atomic ledger recording in dedicated collection
      try {
        final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
        final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
        final orderSnap = await firestore.collection("warehouse_orders").doc(docId.toString()).get();
        final orderData = orderSnap.data() ?? {};
        final mutationRef = firestore.collection("financial_mutations").doc("mut_po_$docId");
        await mutationRef.set({
          'id': "mut_po_$docId",
          'reference_id': docId.toString(),
          'reference_type': 'product_order',
          'flow': 'outflow',
          'amount': orderData['total_cost'] ?? 
              ((num.tryParse(orderData['unit_price']?.toString() ?? '0') ?? 0) * (num.tryParse(totalQty.toString()) ?? 0)),
          'party_name': (orderData['first_name'] != null && orderData['first_name'].toString().isNotEmpty)
              ? orderData['first_name']
              : 'Pengadaan Unit',
          'product_name': orderData['product_name'] ?? '',
          'quantity': num.tryParse(totalQty.toString()) ?? 0,
          'unit_price': orderData['unit_price'] ?? 0,
          'discount_percent': orderData['discount_percent'],
          'discount_max': orderData['discount_max'],
          'image_product': orderData['image_product'],
          'status': 'settled',
          'approved_date': date.toString(),
          'timestamp': FieldValue.serverTimestamp(),
          'period': period,
          'year': dt.year,
          'month': dt.month,
          'day': dt.day,
        });
      } catch (e) {
        debugPrint("Notice: Ledger write to financial_mutations skipped: $e");
      }
    } catch (e) {
      debugPrint("Found Error in payProductOrderInvoice: $e");
      rethrow;
    }
  }

  @override
  Future<void> paySalesOrderInvoice(docId, prodId, totalQty, date) async {
    try {
      await firestore.runTransaction(
        (transaction) async {
          // 1. ALL READS FIRST
          final salesRef = firestore.collection("sales_orders").doc(docId.toString());
          final salesSnap = await transaction.get(salesRef);

          DocumentReference? prodRef;
          DocumentSnapshot? prodSnap;
          if (prodId != null && prodId.toString().isNotEmpty) {
            prodRef = firestore.collection("products").doc(prodId.toString());
            prodSnap = await transaction.get(prodRef);
          }

          // 2. ALL WRITES AFTER READS
          final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
          final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";

          if (salesSnap.exists) {
            transaction.update(salesRef, {
              'finance_approved': true,
              'payment_status': true,
              'finance_approved_date': date,
              'period': period,
            });
          }

          if (prodRef != null && prodSnap != null && prodSnap.exists) {
            final num qtyNum = totalQty is num ? totalQty : (num.tryParse(totalQty.toString()) ?? 0);
            transaction.update(prodRef, {
              "quantity": FieldValue.increment(-qtyNum),
            });
          }
        },
      );

      // Best-effort atomic ledger recording in dedicated collection
      try {
        final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
        final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
        final salesSnap = await firestore.collection("sales_orders").doc(docId.toString()).get();
        final salesData = salesSnap.data() ?? {};
        final mutationRef = firestore.collection("financial_mutations").doc("mut_so_$docId");
        await mutationRef.set({
          'id': "mut_so_$docId",
          'reference_id': docId.toString(),
          'reference_type': 'sales_order',
          'flow': 'inflow',
          'amount': salesData['total_price'] ?? 
              ((num.tryParse(salesData['unit_price']?.toString() ?? '0') ?? 0) * (num.tryParse(totalQty.toString()) ?? 0)),
          'party_name': (salesData['company_name'] != null && salesData['company_name'].toString().isNotEmpty)
              ? salesData['company_name']
              : (salesData['first_name'] ?? 'Customer'),
          'product_name': salesData['product_name'] ?? '',
          'quantity': num.tryParse(totalQty.toString()) ?? 0,
          'unit_price': salesData['unit_price'] ?? 0,
          'discount_percent': salesData['discount_percent'],
          'discount_max': salesData['discount_max'],
          'image_product': salesData['image_product'],
          'status': 'settled',
          'approved_date': date.toString(),
          'timestamp': FieldValue.serverTimestamp(),
          'period': period,
          'year': dt.year,
          'month': dt.month,
          'day': dt.day,
        });
      } catch (e) {
        debugPrint("Notice: Ledger write to financial_mutations skipped: $e");
      }
    } catch (e) {
      debugPrint("Found Error in paySalesOrderInvoice: $e");
      rethrow;
    }
  }
}