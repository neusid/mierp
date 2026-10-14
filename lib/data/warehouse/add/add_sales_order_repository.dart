import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';
import 'package:mierp_apps/features/notification/data/repositories/notification_repository.dart';

class AddSalesOrderRepository {
  final FirebaseFirestore firestore;
  final NotificationRepository notificationRepository;

  AddSalesOrderRepository({
    FirebaseFirestore? firestore,
    NotificationRepository? notificationRepository,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        notificationRepository =
            notificationRepository ?? sl<NotificationRepository>();

  Future<void> addSalesOrderToFireStore(SalesOrder salesOrder) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      final docRef = await firestore.collection("sales_orders").add({
        "admin_id": adminId,
        "company_name": salesOrder.companyName,
        "finance_approved": salesOrder.financeApproved,
        "finance_approved_date": salesOrder.financeApprovedDate,
        "first_name": salesOrder.firstName,
        "payment_status": salesOrder.paymentStatus,
        "product_code": salesOrder.productCode,
        "product_id": salesOrder.productId,
        "product_name": salesOrder.productName,
        "purchased_date": salesOrder.purchasedDate,
        "quantity": salesOrder.quantity,
        "total_price": salesOrder.totalPrice,
        "unit_price": salesOrder.unitPrice,
        "user_id": salesOrder.userId,
        "image_product": salesOrder.imageProduct,
      });

      // Best-effort live notification to Finance & Admin
      try {
        await notificationRepository.sendNotification(
          targetRole: "finance",
          type: "new_sales_order",
          title: "Sales Order Baru",
          message:
              "Pesanan penjualan untuk ${salesOrder.productName} (Qty: ${salesOrder.quantity}) siap diproses Finance.",
          orderId: docRef.id,
          orderType: "sales_order",
          productName: salesOrder.productName,
          adminId: adminId,
        );
      } catch (notifErr) {
        debugPrint("Notice: Failed to dispatch live notification: $notifErr");
      }
    } catch (e) {
      rethrow;
    }
  }
}
