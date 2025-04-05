import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/notification_provider.dart';
import 'services/local_notification_service.dart';
import 'services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/NotificationService.dart';

// This function handles Firebase messages when the app is in the background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to initialize Firebase here
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");

  // You can handle the notification here, or let it display automatically
}

void main() async {
  // Catch all errors in main to prevent crashes
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Set up Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token for this device
    String? fcmToken = await messaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    // Listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
      // Here you could send the token to your server
    });

    // Khởi tạo dữ liệu locale cho định dạng ngày tháng
    await initializeDateFormatting('vi_VN', null);

    // Khởi tạo notification providers
    final notificationProvider = NotificationProvider();

    // Import NotificationService and send FCM token to server
    final notificationService = NotificationService();
    notificationService.setupFcmTokenRefreshListener();
    notificationService.sendFcmTokenToServer().then((success) {
      debugPrint('Result of sending FCM token to server: $success');
    });

    // Khôi phục token và đặt vào provider
    final String? token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      debugPrint('Found saved token, setting to notification provider');
      notificationProvider.setAuthToken(token);
    } else {
      debugPrint('No saved token found');
    }

    try {
      debugPrint('Initializing notification services...');

      // Khởi tạo local notification service
      final bool localNotificationInitialized =
          await LocalNotificationService.init(
        onNotificationTap: (String? payload) {
          // Validate payload before processing
          if (payload == null || payload.isEmpty) {
            debugPrint('Empty payload received from notification tap');
            return;
          }

          try {
            // Xử lý khi người dùng nhấp vào thông báo khi ứng dụng đã đóng
            notificationProvider.handleDeepLink(payload);
          } catch (e) {
            debugPrint('Error handling notification tap: $e');
          }
        },
      );

      if (!localNotificationInitialized) {
        debugPrint('Failed to initialize local notification service');
      } else {
        debugPrint('Local notification service initialized successfully');
      }

      // Handle Firebase messages when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
              'Message also contained a notification: ${message.notification}');

          // Display the notification using local notification plugin
          LocalNotificationService.showNotification(
            id: DateTime.now().millisecond,
            title: message.notification?.title ?? 'Thông báo mới',
            body: message.notification?.body ?? '',
            payload: message.data['type'] != null && message.data['id'] != null
                ? '${message.data['type']}:${message.data['id']}'
                : 'notification:0',
          );
        }
      });

      // Handle when a notification is tapped on and app was terminated
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          debugPrint('App opened from terminated state via notification');

          if (message.data['type'] != null && message.data['id'] != null) {
            final payload = '${message.data['type']}:${message.data['id']}';
            notificationProvider.handleDeepLink(payload);
          }
        }
      });

      // Handle when a notification is tapped on in the background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('App opened from background state via notification');

        if (message.data['type'] != null && message.data['id'] != null) {
          final payload = '${message.data['type']}:${message.data['id']}';
          notificationProvider.handleDeepLink(payload);
        }
      });
    } catch (e) {
      debugPrint('Error in notification setup: $e');
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: notificationProvider),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Fatal error in main: $e');
    // Show some UI to the user or attempt recovery
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Fatal error occurred: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return MaterialApp(
      navigatorKey: notificationProvider.navigatorKey,
      title: 'Club Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
