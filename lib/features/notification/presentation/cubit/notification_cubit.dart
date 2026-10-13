import 'dart:async';
import 'dart:convert';
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

  void clearLatestIncoming() {
    emit(state.copyWith(clearLatestIncoming: true));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
