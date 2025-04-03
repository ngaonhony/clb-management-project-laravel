import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../providers/notification_provider.dart';
import 'local_notification_service.dart';

class FirebaseMessagingService {
  static final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get onMessage =>
      _messageStreamController.stream;

  // Callback functions
  static Function(Map<String, dynamic>)? _onForegroundMessage;
  static NotificationProvider? _notificationProvider;

  // Notification Channels
  static const String EVENT_CHANNEL = 'event_notifications';
  static const String BLOG_CHANNEL = 'blog_notifications';
  static const String CLUB_CHANNEL = 'club_notifications';
  static const String PROMOTION_CHANNEL = 'promotion_notifications';
  static const String CHAT_CHANNEL = 'chat_notifications';
  static const String SYSTEM_CHANNEL = 'system_notifications';

  // Khởi tạo Firebase Messaging Service
  static Future<void> initialize({
    Function(Map<String, dynamic>)? onForegroundMessage,
    NotificationProvider? notificationProvider,
  }) async {
    debugPrint('Initializing Firebase Messaging Service');

    _onForegroundMessage = onForegroundMessage;
    _notificationProvider = notificationProvider;

    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // Set up notification channels for Android
    _setupNotificationChannels();

    // Set up listeners for various Firebase messaging events
    _setupMessagingListeners();

    debugPrint('Firebase Messaging Service initialized successfully');

    // Get and display the FCM token for debug purposes
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');

    return;
  }

  // Set up notification channels for Android
  static void _setupNotificationChannels() {
    // Kênh sự kiện
    LocalNotificationService.setupChannel(
      id: EVENT_CHANNEL,
      name: 'Thông báo sự kiện',
      description: 'Thông báo về các sự kiện mới và cập nhật',
      importance: 'high',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    // Kênh bài viết
    LocalNotificationService.setupChannel(
      id: BLOG_CHANNEL,
      name: 'Thông báo bài viết',
      description: 'Thông báo về các bài viết mới',
      importance: 'high',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    // Kênh câu lạc bộ
    LocalNotificationService.setupChannel(
      id: CLUB_CHANNEL,
      name: 'Thông báo CLB',
      description: 'Thông báo về hoạt động câu lạc bộ',
      importance: 'high',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    // Kênh khuyến mãi
    LocalNotificationService.setupChannel(
      id: PROMOTION_CHANNEL,
      name: 'Thông báo ưu đãi',
      description: 'Thông báo về ưu đãi và khuyến mãi',
      importance: 'default',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    // Kênh tin nhắn
    LocalNotificationService.setupChannel(
      id: CHAT_CHANNEL,
      name: 'Tin nhắn',
      description: 'Thông báo tin nhắn mới',
      importance: 'high',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    // Kênh hệ thống
    LocalNotificationService.setupChannel(
      id: SYSTEM_CHANNEL,
      name: 'Thông báo hệ thống',
      description: 'Thông báo hệ thống và cập nhật quan trọng',
      importance: 'default',
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );
  }

  // Set up message listeners for Firebase Messaging
  static void _setupMessagingListeners() {
    debugPrint('Setting up Firebase messaging listeners');

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.messageId}');

      // Convert RemoteMessage to Map<String, dynamic>
      final Map<String, dynamic> messageData = {
        'notification': message.notification != null
            ? {
                'title': message.notification?.title,
                'body': message.notification?.body,
              }
            : null,
        'data': message.data,
      };

      // Add to stream for other parts of the app to consume
      _messageStreamController.add(messageData);

      // Call callback if provided
      if (_onForegroundMessage != null) {
        _onForegroundMessage!(messageData);
      }

      // Show local notification
      _processNotification(messageData);
    });

    // Handle message open events when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened app: ${message.messageId}');

      // Notify provider for handling navigation
      if (_notificationProvider != null) {
        _notificationProvider!.handleFirebaseMessage(message.data);
      }
    });

    // Handle initial message (app was terminated)
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state by notification');

        // Notify provider for handling navigation
        if (_notificationProvider != null) {
          _notificationProvider!.handleFirebaseMessage(message.data);
        }
      }
    });
  }

  // Process notification and determine which channel to use
  static void _processNotification(Map<String, dynamic> message) {
    try {
      // Validate message structure before processing
      if (!_isValidMessageFormat(message)) {
        debugPrint('Invalid message format, skipping notification display');
        return;
      }

      // Determine channel based on message type
      String channelId = _getChannelForNotification(message);

      // Show local notification with appropriate channel
      _showNotificationWithAppropriateChannel(message, channelId);
    } catch (e) {
      debugPrint('Error processing notification: $e');
    }
  }

  // Validate message format to ensure it contains required fields
  static bool _isValidMessageFormat(Map<String, dynamic> message) {
    // Must have either notification or data
    if (!message.containsKey('notification') && !message.containsKey('data')) {
      return false;
    }

    // If notification exists, it should have title and/or body
    if (message.containsKey('notification')) {
      final notification = message['notification'];
      if (notification == null || notification is! Map) {
        return false;
      }

      if (!notification.containsKey('title') &&
          !notification.containsKey('body')) {
        return false;
      }
    }

    return true;
  }

  // Register device token with your server
  static Future<void> registerDeviceToken() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        debugPrint(
            'Registering FCM token with server: ${token.substring(0, 5)}...');

        // Here you would send the token to your server with proper error handling
        try {
          final response = await http.post(
            Uri.parse('https://example.com/api/register-device'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': '1.0.0', // Add app version for tracking
            },
            body: jsonEncode({
              'token': token,
              'device_type': Platform.isAndroid ? 'android' : 'ios',
              'app_version': '1.0.0',
              'registration_time': DateTime.now().toIso8601String(),
            }),
          );

          if (response.statusCode >= 200 && response.statusCode < 300) {
            debugPrint('Token registration successful: ${response.statusCode}');
          } else {
            debugPrint('Token registration failed: ${response.statusCode}');
          }
        } catch (error) {
          debugPrint('Error sending token to server: $error');
          // Implement retry logic here if needed
        }
      } else {
        debugPrint('Failed to get valid FCM token');
      }
    } catch (e) {
      debugPrint('Error registering device token: $e');
    }
  }

  // Subscribe to a specific topic for targeted notifications
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  // Determine which notification channel to use based on message content
  static String _getChannelForNotification(Map<String, dynamic> message) {
    // Get notification type from data
    String type = '';
    if (message.containsKey('data') && message['data'] is Map) {
      final data = message['data'];
      if (data is Map && data.containsKey('type') && data['type'] is String) {
        type = data['type'] as String;
      }
    }

    // Normalize type for consistent handling
    type = type.toLowerCase().trim();

    // Determine appropriate channel
    switch (type) {
      case 'event':
      case 'new_event':
        return EVENT_CHANNEL;
      case 'blog':
      case 'new_blog':
        return BLOG_CHANNEL;
      case 'club':
        return CLUB_CHANNEL;
      case 'promotion':
        return PROMOTION_CHANNEL;
      case 'chat':
      case 'message':
        return CHAT_CHANNEL;
      case 'system':
      default:
        return SYSTEM_CHANNEL;
    }
  }

  // Show a notification with the appropriate channel
  static Future<bool> _showNotificationWithAppropriateChannel(
    Map<String, dynamic> message,
    String channelId,
  ) async {
    try {
      final notification = message['notification'];
      final data = message['data'];

      if (notification == null || !(notification is Map)) {
        return false;
      }

      // Extract with null safety
      final title = notification['title']?.toString() ?? 'Thông báo mới';
      final body = notification['body']?.toString() ?? '';

      // Safely extract data values
      String? imageUrl;
      String type = 'notification';
      String idStr = '0';
      bool useFacebookStyle = false;
      String? senderName;
      String? actionText;

      if (data is Map) {
        imageUrl = data['image_url']?.toString();
        type = data['type']?.toString() ?? 'notification';
        idStr = data['id']?.toString() ?? '0';

        // Parse boolean safely
        final fbStyleStr = data['facebook_style']?.toString() ?? 'false';
        useFacebookStyle = fbStyleStr.toLowerCase() == 'true';

        senderName = data['sender_name']?.toString();
        actionText = data['action_text']?.toString();
      }

      // Validate ID
      int id;
      try {
        id = int.parse(idStr);
      } catch (e) {
        id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      }

      // Format payload
      String payload = '$type:$id';

      // Create Facebook-style content if requested
      String displayBody = body;
      if (useFacebookStyle && senderName != null && actionText != null) {
        displayBody = '$senderName đã $actionText';
      }

      // Generate random notification ID if needed
      final notificationId =
          id > 0 ? id : DateTime.now().millisecondsSinceEpoch.remainder(100000);

      return await LocalNotificationService.showNotification(
        id: notificationId,
        title: title,
        body: displayBody,
        payload: payload,
        imageUrl: imageUrl,
        channelId: channelId,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
      return false;
    }
  }

  // Process Firebase notification for display
  static Future<bool> showNotificationFromFirebaseMessage(
    Map<String, dynamic> message,
  ) async {
    try {
      // Get notification channel
      String channelId = _getChannelForNotification(message);

      // Process and show notification
      return await _showNotificationWithAppropriateChannel(message, channelId);
    } catch (e) {
      debugPrint('Error showing notification from Firebase message: $e');
      return false;
    }
  }

  // Send a test notification for development purposes
  static Future<void> sendTestNotification({
    String title = 'Test Notification',
    String body = 'This is a test notification',
    String type = 'notification',
    String id = '999',
    String? imageUrl,
    String? senderName,
    String? actionText,
    bool facebookStyle = false,
  }) async {
    debugPrint('Sending test notification to FCM topic');

    try {
      // In a real app, you would send this to your server
      // which would then use FCM Admin SDK to send the notification

      // For testing, we simulate receiving the notification locally
      final Map<String, dynamic> testMessage = {
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'type': type,
          'id': id,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'image_url': imageUrl,
          'sender_name': senderName,
          'action_text': actionText,
          'facebook_style': facebookStyle ? 'true' : 'false',
        }
      };

      // Process notification as if received from FCM
      _processNotification(testMessage);

      // Notify provider
      if (_notificationProvider != null) {
        _notificationProvider!.handleFirebaseMessage(testMessage);
      }
    } catch (e) {
      debugPrint('Error sending test notification: $e');
    }
  }

  // Send a Facebook-style test notification
  static Future<void> sendFacebookStyleNotification({
    required String senderName,
    required String actionText,
    required String targetName,
    required String type,
    required String id,
    String? imageUrl,
  }) async {
    final String title = '$senderName';
    final String body = '$actionText $targetName';

    await sendTestNotification(
      title: title,
      body: body,
      type: type,
      id: id,
      imageUrl: imageUrl,
      senderName: senderName,
      actionText: actionText,
      facebookStyle: true,
    );
  }
}
