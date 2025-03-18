import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../providers/notification_provider.dart';
import '../../services/local_notification_service.dart';
import 'Notification/Notification.dart';
import 'home_screen.dart';
import 'event/event_explorer_screen.dart';
import 'blog/blog_explorer.dart';
import 'profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    EventExplorerScreen(),
    BlogExplorer(),
    const NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Refresh notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });

    // Lắng nghe khi người dùng nhấp vào thông báo
    listenToNotifications();
  }

  void listenToNotifications() {
    LocalNotificationService.onNotifications.listen((payload) {
      if (payload != null && payload.isNotEmpty) {
        handleNotificationTap(payload);
      }
    });
  }

  void handleNotificationTap(String payload) {
    // Xử lý các loại payload khác nhau
    if (payload.startsWith('event:')) {
      // Xử lý sự kiện
      final eventId = int.tryParse(payload.split(':')[1]);
      if (eventId != null) {
        setState(() {
          _currentIndex = 1; // Chuyển đến tab Sự kiện
        });

        // TODO: Điều hướng đến chi tiết sự kiện
        // Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: eventId);
      }
    } else if (payload.startsWith('blog:')) {
      // Xử lý bài viết
      final blogId = int.tryParse(payload.split(':')[1]);
      if (blogId != null) {
        setState(() {
          _currentIndex = 2; // Chuyển đến tab Bài viết
        });

        // TODO: Điều hướng đến chi tiết bài viết
        // Navigator.pushNamed(context, AppRoutes.blogDetail, arguments: blogId);
      }
    } else if (payload.startsWith('notification:')) {
      // Xử lý thông báo thông thường - mở màn hình thông báo
      setState(() {
        _currentIndex = 3; // Chuyển đến tab Thông báo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;

            // Nếu người dùng chuyển đến tab thông báo, cập nhật lại dữ liệu
            if (index == 3) {
              Provider.of<NotificationProvider>(context, listen: false)
                  .fetchNotifications();
            }
          });
        },
      ),
    );
  }
}
