import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/notification_provider.dart';
import 'services/local_notification_service.dart';
import 'services/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Avoid debug prints in VM entry points as they may cause issues
  try {
    // Initialize Firebase if not already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // Validate the message data before processing
    if (message.data.isEmpty && message.notification == null) {
      return; // Skip processing for invalid messages
    }

    // Display notification in system tray
    await LocalNotificationService.showNotificationFromFirebaseMessage(
        message.data);
  } catch (e) {
    // We can't use debugPrint in background handlers as it may cause issues
    // Instead, log to a file or use a crash reporting service if available
  }
}

void main() async {
  // Catch all errors in main to prevent crashes
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    try {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
      // Continue execution - app can still function without Firebase
    }

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Khởi tạo dữ liệu locale cho định dạng ngày tháng
    await initializeDateFormatting('vi_VN', null);

    // Khởi tạo notification providers
    final notificationProvider = NotificationProvider();

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

      // Khởi tạo Firebase Messaging Service if Firebase is available
      if (Firebase.apps.isNotEmpty) {
        await FirebaseMessagingService.initialize(
          onForegroundMessage: (Map<String, dynamic> message) {
            // Validate message before processing
            if (message.isEmpty) {
              debugPrint('Empty message received from foreground handler');
              return;
            }

            try {
              // Xử lý thông báo khi ứng dụng đang mở
              notificationProvider.handleFirebaseMessage(message);
            } catch (e) {
              debugPrint('Error handling foreground message: $e');
            }
          },
          notificationProvider: notificationProvider,
        );

        // Request notification permissions
        try {
          final notificationSettings =
              await FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

          debugPrint(
              'User granted permission: ${notificationSettings.authorizationStatus}');

          // Subscribe to topics only if authorized
          if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized) {
            await FirebaseMessaging.instance.subscribeToTopic('all_users');
            debugPrint('Subscribed to all_users topic');
          }
        } catch (e) {
          debugPrint('Error requesting notification permissions: $e');
        }

        // Foreground message handler with validation
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');

          try {
            // Validate message data before logging sensitive information
            final safeData = Map<String, dynamic>.from(message.data);
            // Remove any sensitive fields from logs
            safeData.remove('token');
            safeData.remove('auth');

            debugPrint('Message data: $safeData');

            if (message.notification != null) {
              debugPrint(
                  'Message also contained a notification: ${message.notification?.title}');
              notificationProvider.handleFirebaseMessage(message.data);
            }
          } catch (e) {
            debugPrint('Error processing foreground message: $e');
          }
        });

        // Initialize token with server, catching any errors
        try {
          FirebaseMessaging.instance.getToken().then((token) {
            if (token != null && token.isNotEmpty) {
              // Log only a portion of the token for security
              final maskedToken =
                  '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
              debugPrint('FCM Token: $maskedToken');
              // Here you would typically send this token to your server
            }
          });
        } catch (e) {
          debugPrint('Error getting FCM token: $e');
        }
      } else {
        debugPrint(
            'Firebase not initialized, skipping Firebase messaging setup');
      }
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
