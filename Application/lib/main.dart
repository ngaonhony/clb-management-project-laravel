import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'core/api/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/notification_provider.dart';
import 'services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo dữ liệu locale cho định dạng ngày tháng
  await initializeDateFormatting('vi_VN', null);
  // Hoặc sử dụng locale của ứng dụng:
  // await initializeDateFormatting(Localizations.localeOf(context).toString(), null);

  try {
    debugPrint('Initializing notification service...');
    // Khởi tạo local notification service
    final bool notificationInitialized = await LocalNotificationService.init();

    if (!notificationInitialized) {
      debugPrint('Failed to initialize notification service');
    } else {
      debugPrint('Notification service initialized successfully');

      // Test thông báo sau khi khởi động 5 giây
      await Future.delayed(const Duration(seconds: 5));
      debugPrint('Attempting to send test notification...');

      final bool success = await LocalNotificationService.showNotification(
        id: 0,
        title: 'Thông báo Test',
        body:
            'Nếu bạn thấy thông báo này, hệ thống đang hoạt động bình thường!',
        payload: 'test',
      );

      if (success) {
        debugPrint('Test notification sent successfully');
      } else {
        debugPrint('Failed to send test notification');
      }
    }
  } catch (e) {
    debugPrint('Error in notification setup: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepository(
              ApiService(ApiClient()),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return MaterialApp(
      navigatorKey: notificationProvider.navigatorKey,
      title: 'Club Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.home, // Sử dụng route từ AppRoutes
      onGenerateRoute: AppRoutes.generateRoute, // Sử dụng hàm generateRoute
    );
  }
}
