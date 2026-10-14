import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String? adminId;
  final String targetRole; // 'finance', 'warehouse', 'all'
  final String type; // 'new_sales_order', 'new_product_order', 'order_approved', 'order_rejected'
  final String title;
  final String message;
  final String orderId;
  final String orderType; // 'sales_order', 'product_order'
  final String productName;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    this.adminId,
    required this.targetRole,
    required this.type,
    required this.title,
    required this.message,
    required this.orderId,
    required this.orderType,
    required this.productName,
    required this.isRead,
    required this.createdAt,
  });

  NotificationItem copyWith({
    String? id,
    String? adminId,
    String? targetRole,
    String? type,
    String? title,
    String? message,
    String? orderId,
    String? orderType,
    String? productName,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      targetRole: targetRole ?? this.targetRole,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      orderId: orderId ?? this.orderId,
      orderType: orderType ?? this.orderType,
      productName: productName ?? this.productName,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        adminId,
        targetRole,
        type,
        title,
        message,
        orderId,
        orderType,
        productName,
        isRead,
        createdAt,
      ];
}
