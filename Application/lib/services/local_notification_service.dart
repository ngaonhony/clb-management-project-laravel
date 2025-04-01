import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

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
  static Function(String?)? _onNotificationTap;

  // Khởi tạo notification
  static Future<bool> init({Function(String?)? onNotificationTap}) async {
    try {
      _onNotificationTap = onNotificationTap;

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

    // Call the tap callback if provided
    if (_onNotificationTap != null && notificationResponse.payload != null) {
      _onNotificationTap!(notificationResponse.payload);
    }

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
    if (payload == null || payload.isEmpty) return {};

    try {
      // First check if it's valid JSON
      try {
        return jsonDecode(payload) as Map<String, dynamic>;
      } catch (_) {
        // If not JSON, try type:id format
        final parts = payload.split(':');
        if (parts.length == 2) {
          final typeStr = parts[0].trim();
          final idStr = parts[1].trim();

          // Validate type and id
          if (typeStr.isEmpty) {
            debugPrint('Empty notification type in payload');
            return {};
          }

          final id = int.tryParse(idStr);
          if (id == null || id <= 0) {
            debugPrint('Invalid ID in payload: $idStr');
            return {};
          }

          return {
            'type': typeStr,
            'id': id,
          };
        }
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
    String channelId = 'high_importance_channel',
  }) async {
    try {
      // Validate inputs
      if (title.isEmpty && body.isEmpty) {
        debugPrint('Cannot show notification with empty title and body');
        return false;
      }

      // Sanitize inputs
      final sanitizedTitle = _sanitizeText(title);
      final sanitizedBody = _sanitizeText(body);
      final sanitizedPayload = _sanitizePayload(payload);

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

      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Validate image URL
        if (!_isValidImagePath(imageUrl)) {
          debugPrint('Invalid image path: $imageUrl');
          imageUrl = null;
        }

        if (imageUrl != null) {
          // Notification with image
          final BigPictureStyleInformation bigPictureStyleInformation =
              BigPictureStyleInformation(
            FilePathAndroidBitmap(imageUrl),
            contentTitle: sanitizedTitle,
            htmlFormatContentTitle: true,
            summaryText: sanitizedBody,
            htmlFormatSummaryText: true,
          );

          final AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            channelId,
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
          // Fall back to simple notification if image is invalid
          notificationDetails = _getDefaultNotificationDetails(channelId);
        }
      } else {
        // Simple notification
        notificationDetails = _getDefaultNotificationDetails(channelId);
      }

      // Hiển thị thông báo
      await _notificationsPlugin.show(
        id,
        sanitizedTitle,
        sanitizedBody,
        notificationDetails,
        payload: sanitizedPayload,
      );

      debugPrint('Notification shown successfully');
      return true;
    } catch (e) {
      debugPrint('Error showing notification: $e');
      return false;
    }
  }

  // Get default notification details
  static NotificationDetails _getDefaultNotificationDetails(String channelId) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
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

  // Sanitize text to prevent injection
  static String _sanitizeText(String text) {
    // Remove any potentially harmful HTML/script tags
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Sanitize payload
  static String? _sanitizePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    // If it's in the type:id format, validate it
    if (payload.contains(':')) {
      final parts = payload.split(':');
      if (parts.length == 2) {
        final type = _sanitizeText(parts[0]);
        final id = parts[1];

        // Ensure ID is numeric
        if (int.tryParse(id) != null) {
          return '$type:$id';
        }
        return null;
      }
    }

    // If it's JSON, sanitize it
    try {
      final json = jsonDecode(payload);
      if (json is Map) {
        // Only allow certain fields
        final sanitized = <String, dynamic>{};
        final allowedFields = ['type', 'id', 'action'];

        for (final key in allowedFields) {
          if (json.containsKey(key)) {
            sanitized[key] = json[key];
          }
        }

        return jsonEncode(sanitized);
      }
    } catch (_) {
      // Not valid JSON, continue
    }

    // If we can't parse it safely, don't use it
    return null;
  }

  // Validate image path
  static bool _isValidImagePath(String path) {
    // Check for common image extensions
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final hasValidExtension =
        validExtensions.any((ext) => path.toLowerCase().endsWith(ext));

    // Check if it's a file path or URL
    final isFilePath =
        path.startsWith('/') || path.startsWith('./') || path.contains('\\');
    final isUrl = path.startsWith('http://') || path.startsWith('https://');

    return (isFilePath || isUrl) && hasValidExtension;
  }

  // Hủy tất cả thông báo
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Hủy một thông báo cụ thể
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Xử lý thông báo từ Firebase
  static Future<bool> showNotificationFromFirebaseMessage(
    Map<String, dynamic> message,
  ) async {
    try {
      final notification = message['notification'];
      final data = message['data'];

      if (notification == null) {
        return false;
      }

      final title = notification['title'] ?? 'Thông báo mới';
      final body = notification['body'] ?? '';
      String? imageUrl = data?['image_url'];

      // Xây dựng payload từ dữ liệu
      String type = data?['type'] ?? 'notification';
      String idStr = data?['id'] ?? '0';
      int id = int.tryParse(idStr) ?? 0;

      // Tạo định dạng payload
      String payload = '$type:$id';

      return await showNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        payload: payload,
        imageUrl: imageUrl,
      );
    } catch (e) {
      debugPrint('Error showing notification from Firebase message: $e');
      return false;
    }
  }

  // Thiết lập kênh thông báo mới
  static Future<void> setupChannel({
    required String id,
    required String name,
    required String description,
    String importance = 'default',
    bool enableVibration = true,
    bool enableSound = true,
    bool showBadge = true,
  }) async {
    if (!Platform.isAndroid) return;

    try {
      final importanceLevel = _getImportanceLevel(importance);

      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        id,
        name,
        description: description,
        importance: importanceLevel,
        playSound: enableSound,
        enableVibration: enableVibration,
        enableLights: true,
        showBadge: showBadge,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      debugPrint('Created notification channel: $id');
    } catch (e) {
      debugPrint('Error creating notification channel: $e');
    }
  }

  // Lấy mức độ quan trọng từ chuỗi
  static Importance _getImportanceLevel(String importance) {
    switch (importance.toLowerCase()) {
      case 'max':
        return Importance.max;
      case 'high':
        return Importance.high;
      case 'low':
        return Importance.low;
      case 'min':
        return Importance.min;
      case 'none':
        return Importance.none;
      case 'default':
      default:
        return Importance.defaultImportance;
    }
  }
}
