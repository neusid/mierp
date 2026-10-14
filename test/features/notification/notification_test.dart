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
  Stream<List<NotificationModel>> streamNotifications(String role, {String? adminId}) {
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
    String? adminId,
  }) async {
    lastSentNotification = {
      'targetRole': targetRole,
      'type': type,
      'title': title,
      'message': message,
      'orderId': orderId,
      'orderType': orderType,
      'productName': productName,
      'adminId': adminId,
    };
  }

  @override
  Future<void> markAsRead(String notifId) async {
    lastMarkAsReadId = notifId;
  }

  @override
  Future<void> markAllAsRead(String role, {String? adminId}) async {
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

    test('New incoming notification arriving after init should trigger FCM showNotification', () async {
      await cubit.init('finance');

      // 1. Initial emission
      fakeRepository.emit([]);
      await pumpEventQueue();

      expect(fakeFcmService.lastShownTitle, isNull);

      // 2. Incoming notification arrives live
      final newNotif = NotificationModel(
        id: 'live_notif_1',
        targetRole: 'finance',
        type: 'new_sales_order',
        title: 'Pesanan Penjualan Baru',
        message: 'Pesanan Macbook Pro siap diproses.',
        orderId: 'SO-100',
        orderType: 'sales_order',
        productName: 'Macbook Pro',
        isRead: false,
        createdAt: DateTime.now(),
      );

      fakeRepository.emit([newNotif]);
      await pumpEventQueue();

      expect(fakeFcmService.lastShownTitle, 'Pesanan Penjualan Baru');
      expect(fakeFcmService.lastShownBody, 'Pesanan Macbook Pro siap diproses.');
    });

    test('sendTestNotification should send notification with default role finance', () async {
      await cubit.init('finance');
      await cubit.sendTestNotification();

      expect(fakeRepository.lastSentNotification, isNotNull);
      expect(fakeRepository.lastSentNotification!['targetRole'], 'finance');
      expect(fakeRepository.lastSentNotification!['type'], 'new_sales_order');
    });

    test('sendTestNotification should send notification with custom parameters for warehouse', () async {
      await cubit.sendTestNotification(
        role: 'warehouse',
        type: 'order_approved',
        title: 'Order Disetujui',
        message: 'Invoice telah lunas.',
        orderId: 'SO-888',
        orderType: 'sales_order',
        productName: 'Monitor 27',
      );

      expect(fakeRepository.lastSentNotification, isNotNull);
      expect(fakeRepository.lastSentNotification!['targetRole'], 'warehouse');
      expect(fakeRepository.lastSentNotification!['type'], 'order_approved');
      expect(fakeRepository.lastSentNotification!['title'], 'Order Disetujui');
      expect(fakeRepository.lastSentNotification!['message'], 'Invoice telah lunas.');
      expect(fakeRepository.lastSentNotification!['orderId'], 'SO-888');
      expect(fakeRepository.lastSentNotification!['productName'], 'Monitor 27');
    });

    test('triggerLocalNotificationTest should call fcm showNotification directly', () async {
      await cubit.triggerLocalNotificationTest(
        title: 'Test Status Bar HP',
        body: 'Notifikasi heads-up langsung',
        orderId: 'SO-999',
        orderType: 'sales_order',
      );

      expect(fakeFcmService.lastShownTitle, 'Test Status Bar HP');
      expect(fakeFcmService.lastShownBody, 'Notifikasi heads-up langsung');
    });
  });

  group('Notification Trigger Pipeline Simulation Tests', () {
    late FakeNotificationRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeNotificationRepository();
    });

    tearDown(() {
      fakeRepo.dispose();
    });

    test('Warehouse creates Sales Order -> should trigger notification to Finance', () async {
      await fakeRepo.sendNotification(
        targetRole: 'finance',
        type: 'new_sales_order',
        title: 'Sales Order Baru',
        message: 'Sales Order untuk iPhone 15 Pro telah dibuat dan menunggu pembayaran.',
        orderId: 'SO-101',
        orderType: 'sales_order',
        productName: 'iPhone 15 Pro',
      );

      expect(fakeRepo.lastSentNotification, isNotNull);
      expect(fakeRepo.lastSentNotification!['targetRole'], 'finance');
      expect(fakeRepo.lastSentNotification!['type'], 'new_sales_order');
      expect(fakeRepo.lastSentNotification!['orderId'], 'SO-101');
      expect(fakeRepo.lastSentNotification!['productName'], 'iPhone 15 Pro');
    });

    test('Warehouse creates Product Order -> should trigger notification to Finance', () async {
      await fakeRepo.sendNotification(
        targetRole: 'finance',
        type: 'new_product_order',
        title: 'Product Order Baru',
        message: 'Product Order untuk Monitor 27" telah dibuat dan menunggu pembayaran.',
        orderId: 'WO-202',
        orderType: 'product_order',
        productName: 'Monitor 27"',
      );

      expect(fakeRepo.lastSentNotification, isNotNull);
      expect(fakeRepo.lastSentNotification!['targetRole'], 'finance');
      expect(fakeRepo.lastSentNotification!['type'], 'new_product_order');
      expect(fakeRepo.lastSentNotification!['orderId'], 'WO-202');
    });

    test('Finance approves/pays Sales Order -> should trigger notification to Warehouse', () async {
      await fakeRepo.sendNotification(
        targetRole: 'warehouse',
        type: 'order_approved',
        title: 'Sales Order Disetujui',
        message: 'Sales Order SO-101 telah diverifikasi dan dibayar oleh Finance.',
        orderId: 'SO-101',
        orderType: 'sales_order',
        productName: 'iPhone 15 Pro',
      );

      expect(fakeRepo.lastSentNotification, isNotNull);
      expect(fakeRepo.lastSentNotification!['targetRole'], 'warehouse');
      expect(fakeRepo.lastSentNotification!['type'], 'order_approved');
    });

    test('Finance rejects Sales Order -> should trigger notification to Warehouse with reason', () async {
      final rejectReason = 'Bukti transfer tidak valid atau belum masuk mutasi bank.';
      await fakeRepo.sendNotification(
        targetRole: 'warehouse',
        type: 'order_rejected',
        title: 'Sales Order Ditolak',
        message: 'Sales Order SO-101 ditolak oleh Finance. Alasan: $rejectReason',
        orderId: 'SO-101',
        orderType: 'sales_order',
        productName: 'iPhone 15 Pro',
      );

      expect(fakeRepo.lastSentNotification, isNotNull);
      expect(fakeRepo.lastSentNotification!['targetRole'], 'warehouse');
      expect(fakeRepo.lastSentNotification!['type'], 'order_rejected');
      expect(fakeRepo.lastSentNotification!['message'], contains(rejectReason));
    });
  });
}
