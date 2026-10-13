import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';
import 'package:mierp_apps/features/notification/data/repositories/notification_repository.dart';
import 'package:mierp_apps/core/services/fcm_notification_service.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';

// --- FAKE REPOSITORY FOR UNIT TESTING ---
class FakeNotificationRepository implements NotificationRepository {
  final StreamController<List<NotificationModel>> _controller =
      StreamController<List<NotificationModel>>.broadcast();

  String? lastMarkAsReadId;
  String? lastMarkAllAsReadRole;
  String? lastDeletedId;
  Map<String, dynamic>? lastSentNotification;

  void emit(List<NotificationModel> list) {
    _controller.add(list);
  }

  @override
  Stream<List<NotificationModel>> streamNotifications(String role) {
    return _controller.stream;
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
  }) async {
    lastSentNotification = {
      'targetRole': targetRole,
      'type': type,
      'title': title,
      'message': message,
      'orderId': orderId,
      'orderType': orderType,
      'productName': productName,
    };
  }

  @override
  Future<void> markAsRead(String notifId) async {
    lastMarkAsReadId = notifId;
  }

  @override
  Future<void> markAllAsRead(String role) async {
    lastMarkAllAsReadRole = role;
  }

  @override
  Future<void> deleteNotification(String notifId) async {
    lastDeletedId = notifId;
  }

  void dispose() {
    _controller.close();
  }
}

// --- FAKE USER DATA CONTROLLER FOR UNIT TESTING ---
class FakeUserDataController extends UserDataController {
  final UserModel _mockUser;

  FakeUserDataController(this._mockUser);

  @override
  Future<UserModel> getDataUser() async {
    return _mockUser;
  }
}

// --- FAKE FCM NOTIFICATION SERVICE FOR UNIT TESTING ---
class FakeFcmNotificationService extends FcmNotificationService {
  String? subscribedRole;
  String? lastShownTitle;
  String? lastShownBody;

  @override
  Future<void> init() async {}

  @override
  Future<void> subscribeToRoleTopic(String role) async {
    subscribedRole = role;
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    lastShownTitle = title;
    lastShownBody = body;
  }
}

void main() {
  group('NotificationModel & Entity Tests', () {
    test('NotificationModel should serialize to Firestore map correctly', () {
      final now = DateTime.parse('2026-10-13T14:00:00.000Z');
      final notif = NotificationModel(
        id: 'notif_123',
        targetRole: 'finance',
        type: 'new_sales_order',
        title: 'Sales Order Baru',
        message: 'Pesanan untuk Macbook Pro siap diproses.',
        orderId: 'SO-999',
        orderType: 'sales_order',
        productName: 'Macbook Pro',
        isRead: false,
        createdAt: now,
      );

      final map = notif.toFirestore();

      expect(map['target_role'], 'finance');
      expect(map['type'], 'new_sales_order');
      expect(map['title'], 'Sales Order Baru');
      expect(map['message'], 'Pesanan untuk Macbook Pro siap diproses.');
      expect(map['order_id'], 'SO-999');
      expect(map['order_type'], 'sales_order');
      expect(map['product_name'], 'Macbook Pro');
      expect(map['is_read'], false);
      expect(map['created_at'], '2026-10-13T14:00:00.000Z');
    });

    test('NotificationModel copyWith should update fields and preserve immutability', () {
      final now = DateTime.now();
      final notif = NotificationModel(
        id: 'notif_1',
        targetRole: 'warehouse',
        type: 'order_approved',
        title: 'Order Disetujui',
        message: 'Disetujui',
        orderId: 'WO-1',
        orderType: 'product_order',
        productName: 'Item A',
        isRead: false,
        createdAt: now,
      );

      final updated = notif.copyWith(isRead: true);

      expect(updated.isRead, true);
      expect(notif.isRead, false); // Original remains unchanged
      expect(updated.id, notif.id);
      expect(updated.title, notif.title);
    });
  });

  group('NotificationCubit Unit Tests', () {
    late FakeNotificationRepository fakeRepository;
    late FakeUserDataController fakeUserDataController;
    late FakeFcmNotificationService fakeFcmService;
    late NotificationCubit cubit;

    setUp(() {
      fakeRepository = FakeNotificationRepository();
      fakeFcmService = FakeFcmNotificationService();
      fakeUserDataController = FakeUserDataController(
        UserModel(
          uid: 'uid_test',
          email: 'finance@mierp.com',
          firstName: 'Budi',
          lastName: 'Finance',
          role: 'finance',
          allowGoogleLogin: false,
        ),
      );
      cubit = NotificationCubit(
        notificationRepository: fakeRepository,
        userDataController: fakeUserDataController,
        fcmNotificationService: fakeFcmService,
      );
    });

    tearDown(() {
      fakeRepository.dispose();
      cubit.close();
    });

    test('Initial state should have empty notifications and 0 unreadCount', () {
      expect(cubit.state.notifications, isEmpty);
      expect(cubit.state.unreadCount, 0);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.latestIncomingNotification, isNull);
    });

    test('init() should subscribe to repository stream and update unreadCount', () async {
      await cubit.init('finance');

      expect(cubit.state.activeRole, 'finance');

      final item1 = NotificationModel(
        id: '1',
        targetRole: 'finance',
        type: 'new_sales_order',
        title: 'Order 1',
        message: 'Msg 1',
        orderId: 'SO-1',
        orderType: 'sales_order',
        productName: 'Laptop',
        isRead: false,
        createdAt: DateTime.now(),
      );
      final item2 = NotificationModel(
        id: '2',
        targetRole: 'finance',
        type: 'new_product_order',
        title: 'Order 2',
        message: 'Msg 2',
        orderId: 'WO-1',
        orderType: 'product_order',
        productName: 'Mouse',
        isRead: true,
        createdAt: DateTime.now(),
      );

      // Emit initial batch of notifications
      fakeRepository.emit([item1, item2]);
      await pumpEventQueue();

      expect(cubit.state.notifications.length, 2);
      expect(cubit.state.unreadCount, 1); // Only item1 is unread
      expect(cubit.state.latestIncomingNotification, isNull); // Initial load doesn't trigger popup
    });

    test('New incoming notification arriving after init should set latestIncomingNotification', () async {
      await cubit.init('warehouse');

      final item1 = NotificationModel(
        id: '1',
        targetRole: 'warehouse',
        type: 'order_approved',
        title: 'Order Disetujui',
        message: 'Approved',
        orderId: 'SO-1',
        orderType: 'sales_order',
        productName: 'Laptop',
        isRead: true,
        createdAt: DateTime.now(),
      );

      // 1. Initial emission
      fakeRepository.emit([item1]);
      await pumpEventQueue();

      expect(cubit.state.notifications.length, 1);
      expect(cubit.state.unreadCount, 0);

      // 2. Subsequent live emission containing a brand new unread notification
      final item2 = NotificationModel(
        id: '2',
        targetRole: 'warehouse',
        type: 'order_rejected',
        title: 'Order Ditolak',
        message: 'Alasan: Stok habis',
        orderId: 'SO-2',
        orderType: 'sales_order',
        productName: 'Keyboard',
        isRead: false,
        createdAt: DateTime.now(),
      );

      fakeRepository.emit([item2, item1]);
      await pumpEventQueue();

      expect(cubit.state.notifications.length, 2);
      expect(cubit.state.unreadCount, 1);
      expect(cubit.state.latestIncomingNotification, isNotNull);
      expect(cubit.state.latestIncomingNotification!.id, '2');
      expect(cubit.state.latestIncomingNotification!.title, 'Order Ditolak');

      // 3. Clear latest incoming
      cubit.clearLatestIncoming();
      expect(cubit.state.latestIncomingNotification, isNull);
    });

    test('markAsRead should delegate to repository', () async {
      await cubit.markAsRead('notif_abc');
      expect(fakeRepository.lastMarkAsReadId, 'notif_abc');
    });

    test('markAllAsRead should delegate to repository with activeRole', () async {
      await cubit.init('finance');
      await cubit.markAllAsRead();
      expect(fakeRepository.lastMarkAllAsReadRole, 'finance');
    });

    test('deleteNotification should delegate to repository', () async {
      await cubit.deleteNotification('notif_xyz');
      expect(fakeRepository.lastDeletedId, 'notif_xyz');
    });
  });
}
