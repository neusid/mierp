import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> streamNotifications(String role, {String? adminId});
  Future<void> sendNotification({
    required String targetRole,
    required String type,
    required String title,
    required String message,
    required String orderId,
    required String orderType,
    required String productName,
    String? adminId,
  });
  Future<void> markAsRead(String notifId);
  Future<void> markAllAsRead(String role, {String? adminId});
  Future<void> deleteNotification(String notifId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore firestore;

  NotificationRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<NotificationModel>> streamNotifications(String role, {String? adminId}) {
    final normalizedRole = role.trim().toLowerCase();

    Query<Map<String, dynamic>> query = firestore.collection('notifications');

    if (adminId != null && adminId.isNotEmpty) {
      query = query.where('admin_id', isEqualTo: adminId);
    }

    if (normalizedRole.isNotEmpty && normalizedRole != 'admin') {
      final List<String> targetRoles = [normalizedRole, 'all'];
      query = query.where('target_role', whereIn: targetRoles);
    }

    return query.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();

      // In-memory sort by createdAt descending to avoid composite index requirement
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  @override
  Future<void> sendNotification({
    required String targetRole,
    required String type,
    required String title,
    required String message,
    required String orderId,
    required String orderType,
    required String productName,
    String? adminId,
  }) async {
    try {
      await firestore.collection('notifications').add({
        'admin_id': adminId ?? '',
        'target_role': targetRole.trim().toLowerCase(),
        'type': type,
        'title': title,
        'message': message,
        'order_id': orderId,
        'order_type': orderType,
        'product_name': productName,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error sending notification to Firestore: $e");
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String notifId) async {
    try {
      await firestore.collection('notifications').doc(notifId).update({
        'is_read': true,
      });
    } catch (e) {
      debugPrint("Error marking notification $notifId as read: $e");
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead(String role, {String? adminId}) async {
    try {
      final normalizedRole = role.trim().toLowerCase();

      Query<Map<String, dynamic>> query = firestore
          .collection('notifications')
          .where('is_read', isEqualTo: false);

      if (adminId != null && adminId.isNotEmpty) {
        query = query.where('admin_id', isEqualTo: adminId);
      }

      if (normalizedRole.isNotEmpty && normalizedRole != 'admin') {
        final List<String> targetRoles = [normalizedRole, 'all'];
        query = query.where('target_role', whereIn: targetRoles);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) return;

      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Error marking all notifications as read for role $role: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String notifId) async {
    try {
      await firestore.collection('notifications').doc(notifId).delete();
    } catch (e) {
      debugPrint("Error deleting notification $notifId: $e");
      rethrow;
    }
  }
}
