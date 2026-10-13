import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:mierp_apps/core/routing/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Background FCM Firebase init skipped or failed: $e");
  }
}

class FcmNotificationService {
  final FirebaseMessaging? _customFcm;
  final FlutterLocalNotificationsPlugin? _customLocalNotifications;

  FirebaseMessaging get _fcm => _customFcm ?? FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin get _localNotifications =>
      _customLocalNotifications ?? FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'mierp_channel',
    'MiERP Notifications',
    description: 'Kanal notifikasi transaksi MiERP',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  FcmNotificationService({
    FirebaseMessaging? fcm,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _customFcm = fcm,
        _customLocalNotifications = localNotifications;

  Future<void> init() async {
    try {
      // 1. Request notification permission (Required for Android 13+ & iOS)
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint("FCM Notification Permission status: ${settings.authorizationStatus}");

      // Log FCM device token for direct testing via Firebase Console
      try {
        final token = await _fcm.getToken();
        debugPrint("🔑 [FCM Token]: $token");
      } catch (tokenErr) {
        debugPrint("Could not retrieve FCM token: $tokenErr");
      }

      // 2. Setup Android notification channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 3. Initialize local notification plugin
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          _handleNotificationTap(response.payload);
        },
      );

      // 4. Foreground presentation options on iOS
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Handle foreground FCM message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        final data = message.data;

        final title = notification?.title ?? data['title'] ?? 'MiERP Notification';
        final body = notification?.body ?? data['message'] ?? data['body'] ?? '';

        final payload = jsonEncode({
          'order_id': data['order_id'] ?? '',
          'order_type': data['order_type'] ?? '',
        });

        showNotification(
          title: title,
          body: body,
          payload: payload,
        );
      });

      // 6. Handle notification click from background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final data = message.data;
        final orderId = data['order_id']?.toString() ?? '';
        final orderType = data['order_type']?.toString() ?? '';
        _navigateToOrder(orderType, orderId);
      });

      // 7. Check if app was opened from terminated state by a notification
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        final data = initialMessage.data;
        final orderId = data['order_id']?.toString() ?? '';
        final orderType = data['order_type']?.toString() ?? '';
        _navigateToOrder(orderType, orderId);
      }
    } catch (e) {
      debugPrint("Error initializing FcmNotificationService: $e");
    }
  }

  Future<void> subscribeToRoleTopic(String role) async {
    final norm = role.trim().toLowerCase();
    try {
      if (norm == 'finance') {
        await _fcm.subscribeToTopic('finance');
        await _fcm.unsubscribeFromTopic('warehouse');
        debugPrint("FCM: Subscribed to topic 'finance'");
      } else if (norm == 'warehouse') {
        await _fcm.subscribeToTopic('warehouse');
        await _fcm.unsubscribeFromTopic('finance');
        debugPrint("FCM: Subscribed to topic 'warehouse'");
      }
    } catch (e) {
      debugPrint("Error updating FCM topic subscription: $e");
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        id: id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint("Error showing system notification bar popup: $e");
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      final orderId = decoded['order_id']?.toString() ?? '';
      final orderType = decoded['order_type']?.toString() ?? '';
      _navigateToOrder(orderType, orderId);
    } catch (e) {
      debugPrint("Error parsing notification tap payload: $e");
    }
  }

  void _navigateToOrder(String orderType, String orderId) {
    if (orderId.isEmpty) return;
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    if (orderType == 'sales_order') {
      context.push('/detail_sales_order/$orderId');
    } else if (orderType == 'product_order') {
      context.push('/detail_product_order/$orderId');
    }
  }
}
