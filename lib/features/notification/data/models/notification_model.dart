import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/features/notification/domain/entities/notification_item.dart';

class NotificationModel extends NotificationItem {
  const NotificationModel({
    required super.id,
    required super.targetRole,
    required super.type,
    required super.title,
    required super.message,
    required super.orderId,
    required super.orderType,
    required super.productName,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};

    DateTime parsedDate;
    final rawDate = data['created_at'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return NotificationModel(
      id: doc.id,
      targetRole: (data['target_role'] ?? '').toString().toLowerCase(),
      type: (data['type'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      message: (data['message'] ?? '').toString(),
      orderId: (data['order_id'] ?? '').toString(),
      orderType: (data['order_type'] ?? '').toString(),
      productName: (data['product_name'] ?? '').toString(),
      isRead: data['is_read'] == true,
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'target_role': targetRole.toLowerCase(),
      'type': type,
      'title': title,
      'message': message,
      'order_id': orderId,
      'order_type': orderType,
      'product_name': productName,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationItem toDomain() => this;
}
