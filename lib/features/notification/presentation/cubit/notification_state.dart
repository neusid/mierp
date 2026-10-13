import 'package:equatable/equatable.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String activeRole;
  final String? errorMessage;
  final NotificationModel? latestIncomingNotification;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.activeRole = '',
    this.errorMessage,
    this.latestIncomingNotification,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? activeRole,
    String? errorMessage,
    NotificationModel? latestIncomingNotification,
    bool clearLatestIncoming = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      activeRole: activeRole ?? this.activeRole,
      errorMessage: errorMessage ?? this.errorMessage,
      latestIncomingNotification: clearLatestIncoming
          ? null
          : (latestIncomingNotification ?? this.latestIncomingNotification),
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        unreadCount,
        isLoading,
        activeRole,
        errorMessage,
        latestIncomingNotification,
      ];
}
