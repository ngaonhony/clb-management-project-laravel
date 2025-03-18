import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:io';

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final String? type;
  final int? targetId;

  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
    this.type,
    this.targetId,
  });
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static final onNotificationClick = BehaviorSubject<ReceivedNotification>();

  // Khởi tạo notification
  static Future<bool> init() async {
    try {
      // Request permission first
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        final bool? granted =
            await androidImplementation?.requestNotificationsPermission();
        debugPrint('Android notification permissions granted: $granted');

        if (granted != true) {
          debugPrint('Android notification permissions not granted');
          return false;
        }
      }

      if (Platform.isIOS) {
        final bool? iosGranted = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
              critical: true,
            );
        debugPrint('iOS notification permissions granted: $iosGranted');

        if (iosGranted != true) {
          debugPrint('iOS notification permissions not granted');
          return false;
        }
      }

      // Thiết lập cho Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Thiết lập cho iOS
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        notificationCategories: [],
      );

      // Thiết lập cho tất cả nền tảng
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Khởi tạo plugin với thiết lập
      final bool? initializationResult = await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );

      debugPrint('Notifications initialization result: $initializationResult');

      // Tạo notification channel cho Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
        debugPrint('Notification channel created');
      }

      // Khởi tạo timezone
      tz.initializeTimeZones();
      debugPrint('Timezones initialized');

      return true;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      return false;
    }
  }

  // Tạo notification channel cho Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Xử lý khi nhận được thông báo iOS
  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    debugPrint(
        'Received iOS notification: id=$id, title=$title, body=$body, payload=$payload');

    Map<String, dynamic> payloadData = _parsePayload(payload);

    onNotificationClick.add(ReceivedNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      type: payloadData['type'],
      targetId: payloadData['id'],
    ));
  }

  // Xử lý khi người dùng nhấp vào thông báo
  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    debugPrint('Notification clicked: ${notificationResponse.payload}');

    Map<String, dynamic> payloadData =
        _parsePayload(notificationResponse.payload);

    onNotificationClick.add(ReceivedNotification(
      id: notificationResponse.id ?? 0,
      payload: notificationResponse.payload,
      type: payloadData['type'],
      targetId: payloadData['id'],
    ));
  }

  // Xử lý notification trong background
  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) {
    debugPrint(
        'Background notification clicked: ${notificationResponse.payload}');

    Map<String, dynamic> payloadData =
        _parsePayload(notificationResponse.payload);

    onNotificationClick.add(ReceivedNotification(
      id: notificationResponse.id ?? 0,
      payload: notificationResponse.payload,
      type: payloadData['type'],
      targetId: payloadData['id'],
    ));
  }

  // Parse payload string to map
  static Map<String, dynamic> _parsePayload(String? payload) {
    if (payload == null) return {};

    try {
      final parts = payload.split(':');
      if (parts.length == 2) {
        return {
          'type': parts[0],
          'id': int.tryParse(parts[1]) ?? 0,
        };
      }
    } catch (e) {
      debugPrint('Error parsing payload: $e');
    }
    return {};
  }

  // Hiển thị thông báo đơn giản
  static Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    try {
      // Kiểm tra quyền thông báo trước khi hiển thị
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final bool? granted =
            await androidImplementation?.areNotificationsEnabled();

        if (granted != true) {
          debugPrint('Notification permissions not granted');
          return false;
        }
      }

      NotificationDetails notificationDetails;

      if (imageUrl != null) {
        // Notification with image
        final BigPictureStyleInformation bigPictureStyleInformation =
            BigPictureStyleInformation(
          FilePathAndroidBitmap(imageUrl),
          contentTitle: title,
          htmlFormatContentTitle: true,
          summaryText: body,
          htmlFormatSummaryText: true,
        );

        final AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );

        notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
      } else {
        // Simple notification
        notificationDetails = NotificationDetails(
          android: const AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
      }

      // Hiển thị thông báo
      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      debugPrint('Notification shown successfully');
      return true;
    } catch (e) {
      debugPrint('Error showing notification: $e');
      return false;
    }
  }

  // Hủy tất cả thông báo
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Hủy một thông báo cụ thể
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
