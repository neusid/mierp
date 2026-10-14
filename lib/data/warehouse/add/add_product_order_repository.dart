import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';
import 'package:mierp_apps/features/notification/data/repositories/notification_repository.dart';

class AddProductOrderRepository {
  final FirebaseFirestore firestore;
  final NotificationRepository notificationRepository;

  AddProductOrderRepository({
    FirebaseFirestore? firestore,
    NotificationRepository? notificationRepository,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        notificationRepository =
            notificationRepository ?? sl<NotificationRepository>();

  Future<void> addProductOrderToFireStore(OrderProduct order) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      final docRef = await firestore.collection("warehouse_orders").add({
        "admin_id": adminId,
        "finance_approved": order.financeApproved,
        "finance_approved_date": order.financeApprovedDate,
        "first_name": order.firstName,
        "order_date": order.orderDate,
        "product_code": order.productCode,
        "product_id": order.productId,
        "product_name": order.productName,
        "quantity": order.quantity,
        "total_cost": order.totalCost,
        "unit_price": order.unitPrice,
        "user_id": order.userId,
        "image_product": order.imageProduct,
      });

      // Best-effort live notification to Finance & Admin
      try {
        await notificationRepository.sendNotification(
          targetRole: "finance",
          type: "new_product_order",
          title: "Product Order Baru",
          message:
              "Pengadaan unit untuk ${order.productName} (Qty: ${order.quantity}) menunggu persetujuan Finance.",
          orderId: docRef.id,
          orderType: "product_order",
          productName: order.productName,
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
