import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/services/fcm_notification_service.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';
import 'package:mierp_apps/features/notification/data/repositories/notification_repository.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  final UserDataController _userDataController;
  final FcmNotificationService _fcmNotificationService;
  StreamSubscription<List<NotificationModel>>? _subscription;
  Set<String> _knownIds = {};
  bool _isFirstEmission = true;

  NotificationCubit({
    NotificationRepository? notificationRepository,
    UserDataController? userDataController,
    FcmNotificationService? fcmNotificationService,
  })  : _notificationRepository =
            notificationRepository ?? sl<NotificationRepository>(),
        _userDataController =
            userDataController ?? sl<UserDataController>(),
        _fcmNotificationService =
            fcmNotificationService ?? sl<FcmNotificationService>(),
        super(const NotificationState());

  Future<void> init([String? roleOverride]) async {
    emit(state.copyWith(isLoading: true));
    try {
      String role = roleOverride ?? '';
      if (role.isEmpty) {
        try {
          final user = await _userDataController.getDataUser();
          role = user.role ?? '';
        } catch (_) {
          role = '';
        }
      }

      final normalizedRole = role.trim().toLowerCase();
      emit(state.copyWith(activeRole: normalizedRole));

      // Subscribe to role topic on FCM for push notification routing
      await _fcmNotificationService.subscribeToRoleTopic(normalizedRole);

      await _subscription?.cancel();
      _isFirstEmission = true;
      _knownIds.clear();

      _subscription = _notificationRepository
          .streamNotifications(normalizedRole)
          .listen(
        (notifications) async {
          final unreadCount =
              notifications.where((item) => !item.isRead).length;

          NotificationModel? newIncoming;
          if (!_isFirstEmission) {
            // Check for brand new unread notifications that just arrived
            for (final notif in notifications) {
              if (!_knownIds.contains(notif.id) && !notif.isRead) {
                newIncoming = notif;
                break;
              }
            }
          }

          _knownIds = notifications.map((n) => n.id).toSet();
          _isFirstEmission = false;

          // Trigger native notification in the Android status bar / notification tray
          if (newIncoming != null) {
            await _fcmNotificationService.showNotification(
              title: newIncoming.title,
              body: newIncoming.message,
              payload: jsonEncode({
                'order_id': newIncoming.orderId,
                'order_type': newIncoming.orderType,
              }),
            );
          }

          emit(state.copyWith(
            notifications: notifications,
            unreadCount: unreadCount,
            isLoading: false,
            latestIncomingNotification: newIncoming,
          ));
        },
        onError: (error) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> markAsRead(String notifId) async {
    try {
      await _notificationRepository.markAsRead(notifId);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationRepository.markAllAsRead(state.activeRole);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteNotification(String notifId) async {
    try {
      await _notificationRepository.deleteNotification(notifId);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Mengirimkan notifikasi uji coba ke Firestore yang akan ditangkap oleh listener realtime
  Future<bool> sendTestNotification({
    String? role,
    String? type,
    String? title,
    String? message,
    String? orderId,
    String? orderType,
    String? productName,
  }) async {
    try {
      final target = (role != null && role.isNotEmpty)
          ? role.trim().toLowerCase()
          : (state.activeRole.isNotEmpty ? state.activeRole : 'finance');

      String resolvedOrderType = orderType ?? 'sales_order';
      String resolvedOrderId = orderId ?? '';
      String resolvedProductName = productName ?? '';

      // Otomatis ambil dokumen pesanan ASLI dari Firestore jika ada, agar saat di-tap benar-benar membuka detail order nyata!
      if (resolvedOrderId.isEmpty ||
          resolvedOrderId.startsWith('TEST-') ||
          resolvedOrderId == 'SO-SELF') {
        try {
          final collectionName = resolvedOrderType == 'sales_order'
              ? 'sales_orders'
              : 'warehouse_orders';
          final realOrderSnap = await FirebaseFirestore.instance
              .collection(collectionName)
              .limit(1)
              .get();
          if (realOrderSnap.docs.isNotEmpty) {
            final realDoc = realOrderSnap.docs.first;
            resolvedOrderId = realDoc.id;
            final realData = realDoc.data();
            resolvedProductName = realData['product_name']?.toString() ??
                realData['name']?.toString() ??
                'Produk MiERP';
          }
        } catch (_) {}
      }

      if (resolvedOrderId.isEmpty) {
        resolvedOrderId =
            'TEST-${DateTime.now().millisecondsSinceEpoch % 10000}';
      }
      if (resolvedProductName.isEmpty) {
        resolvedProductName = 'Produk Sampel';
      }

      final defaultType =
          target == 'finance' ? 'new_sales_order' : 'order_approved';
      final defaultTitle = target == 'finance'
          ? 'Sales Order Baru ($resolvedProductName)'
          : 'Order Disetujui ($resolvedProductName)';
      final defaultMessage = target == 'finance'
          ? 'Pesanan penjualan untuk $resolvedProductName siap diproses dan menunggu persetujuan.'
          : 'Pesanan untuk $resolvedProductName telah disetujui & diverifikasi oleh Finance.';

      await _notificationRepository.sendNotification(
        targetRole: target,
        type: type ?? defaultType,
        title: title ?? defaultTitle,
        message: message ?? defaultMessage,
        orderId: resolvedOrderId,
        orderType: resolvedOrderType,
        productName: resolvedProductName,
      );
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return false;
    }
  }

  /// Menembak notifikasi lokal ke bar notifikasi HP secara langsung untuk uji coba instan
  Future<void> triggerLocalNotificationTest({
    String? title,
    String? body,
    String? orderId,
    String? orderType,
  }) async {
    try {
      String resolvedOrderId = orderId ?? '';
      String resolvedOrderType = orderType ?? 'sales_order';

      if (resolvedOrderId.isEmpty || resolvedOrderId.startsWith('TEST-')) {
        try {
          final realOrderSnap = await FirebaseFirestore.instance
              .collection('sales_orders')
              .limit(1)
              .get();
          if (realOrderSnap.docs.isNotEmpty) {
            resolvedOrderId = realOrderSnap.docs.first.id;
          }
        } catch (_) {}
      }

      if (resolvedOrderId.isEmpty) {
        resolvedOrderId = 'TEST-999';
      }

      await _fcmNotificationService.showNotification(
        title: title ?? '🔔 Uji Coba Status Bar MiERP',
        body: body ??
            'Notifikasi FCM Status Bar & Heads-up Banner berhasil diterima!',
        payload: jsonEncode({
          'order_id': resolvedOrderId,
          'order_type': resolvedOrderType,
        }),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearLatestIncoming() {
    emit(state.copyWith(clearLatestIncoming: true));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
