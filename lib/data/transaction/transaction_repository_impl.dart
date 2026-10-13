import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';
import 'package:mierp_apps/features/notification/data/repositories/notification_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore firestore;
  final NotificationRepository notificationRepository;

  TransactionRepositoryImpl({
    required this.firestore,
    NotificationRepository? notificationRepository,
  }) : notificationRepository =
            notificationRepository ?? sl<NotificationRepository>();

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
      String productName = '';
      try {
        final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
        final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
        final orderSnap = await firestore.collection("warehouse_orders").doc(docId.toString()).get();
        final orderData = orderSnap.data() ?? {};
        productName = orderData['product_name']?.toString() ?? '';
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
          'product_name': productName,
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

      // Best-effort live notification to Warehouse
      try {
        await notificationRepository.sendNotification(
          targetRole: "warehouse",
          type: "order_approved",
          title: "Product Order Disetujui",
          message: "Pesanan unit #${docId.toString()}${productName.isNotEmpty ? ' ($productName)' : ''} telah disetujui & dibayar oleh Finance.",
          orderId: docId.toString(),
          orderType: "product_order",
          productName: productName,
        );
      } catch (notifErr) {
        debugPrint("Notice: Failed to dispatch live notification: $notifErr");
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
      String productName = '';
      try {
        final dt = DateTime.tryParse(date.toString()) ?? DateTime.now();
        final period = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
        final salesSnap = await firestore.collection("sales_orders").doc(docId.toString()).get();
        final salesData = salesSnap.data() ?? {};
        productName = salesData['product_name']?.toString() ?? '';
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
          'product_name': productName,
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

      // Best-effort live notification to Warehouse
      try {
        await notificationRepository.sendNotification(
          targetRole: "warehouse",
          type: "order_approved",
          title: "Sales Order Disetujui",
          message: "Sales Order #${docId.toString()}${productName.isNotEmpty ? ' ($productName)' : ''} telah disetujui & dibayar oleh Finance.",
          orderId: docId.toString(),
          orderType: "sales_order",
          productName: productName,
        );
      } catch (notifErr) {
        debugPrint("Notice: Failed to dispatch live notification: $notifErr");
      }
    } catch (e) {
      debugPrint("Found Error in paySalesOrderInvoice: $e");
      rethrow;
    }
  }

  @override
  Future<void> rejectProductOrderInvoice(String docId, String reason, String date) async {
    try {
      final orderRef = firestore.collection("warehouse_orders").doc(docId);
      await orderRef.update({
        'is_rejected': true,
        'rejection_reason': reason,
        'rejected_date': date,
        'finance_approved': false,
      });

      // Best-effort live notification to Warehouse
      try {
        final orderSnap = await orderRef.get();
        final orderData = orderSnap.data() ?? {};
        final productName = orderData['product_name']?.toString() ?? '';
        await notificationRepository.sendNotification(
          targetRole: "warehouse",
          type: "order_rejected",
          title: "Product Order Ditolak",
          message: "Pesanan unit #$docId${productName.isNotEmpty ? ' ($productName)' : ''} ditolak oleh Finance. Alasan: $reason",
          orderId: docId,
          orderType: "product_order",
          productName: productName,
        );
      } catch (notifErr) {
        debugPrint("Notice: Failed to dispatch live notification: $notifErr");
      }
    } catch (e) {
      debugPrint("Found Error in rejectProductOrderInvoice: $e");
      rethrow;
    }
  }

  @override
  Future<void> rejectSalesOrderInvoice(String docId, String reason, String date) async {
    try {
      final salesRef = firestore.collection("sales_orders").doc(docId);
      await salesRef.update({
        'is_rejected': true,
        'rejection_reason': reason,
        'rejected_date': date,
        'finance_approved': false,
      });

      // Best-effort live notification to Warehouse
      try {
        final salesSnap = await salesRef.get();
        final salesData = salesSnap.data() ?? {};
        final productName = salesData['product_name']?.toString() ?? '';
        await notificationRepository.sendNotification(
          targetRole: "warehouse",
          type: "order_rejected",
          title: "Sales Order Ditolak",
          message: "Sales Order #$docId${productName.isNotEmpty ? ' ($productName)' : ''} ditolak oleh Finance. Alasan: $reason",
          orderId: docId,
          orderType: "sales_order",
          productName: productName,
        );
      } catch (notifErr) {
        debugPrint("Notice: Failed to dispatch live notification: $notifErr");
      }
    } catch (e) {
      debugPrint("Found Error in rejectSalesOrderInvoice: $e");
      rethrow;
    }
  }
}