import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/notification_model.dart';
import '../../../providers/notification_provider.dart';
import '../../../services/local_notification_service.dart';
import 'notification_card.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: _testLocalNotification,
            tooltip: 'Test thông báo',
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc')),
              );
            },
            tooltip: 'Đánh dấu tất cả đã đọc',
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã xảy ra lỗi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(notificationProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      notificationProvider.fetchNotifications();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final unreadNotifications = notificationProvider.unreadNotifications;
          final readNotifications = notificationProvider.readNotifications;

          if (unreadNotifications.isEmpty && readNotifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Không có thông báo nào',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notificationProvider.fetchNotifications(),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                // Phần thông báo chưa đọc
                if (unreadNotifications.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Chưa đọc',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...unreadNotifications.map((notification) =>
                      _buildNotificationCard(
                          notification, notificationProvider)),
                  const Divider(thickness: 1),
                ],

                // Phần thông báo đã đọc
                if (readNotifications.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Đã đọc',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...readNotifications.map((notification) =>
                      _buildNotificationCard(
                          notification, notificationProvider)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      NotificationModel notification, NotificationProvider provider) {
    return NotificationCard(
      notification: notification,
      onMarkAsRead: () {
        provider.markAsRead(notification.id);
      },
      onTap: () {
        // Nếu thông báo chưa đọc, đánh dấu đã đọc
        if (!notification.isRead) {
          provider.markAsRead(notification.id);
        }

        // Điều hướng đến màn hình chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetailScreen(
              notification: notification,
              onNavigate: _handleNavigateFromNotification,
            ),
          ),
        );
      },
    );
  }

  void _handleNavigateFromNotification(String type, int id) {
    // Xử lý điều hướng dựa trên loại thông báo và id
    switch (type) {
      case 'new_event':
        // Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: id);
        break;
      case 'new_blog':
        // Navigator.pushNamed(context, AppRoutes.blogDetail, arguments: id);
        break;
      default:
        break;
    }
  }

  void _testLocalNotification() async {
    // Hiển thị thông báo đơn giản
    await LocalNotificationService.showNotification(
      id: 0,
      title: 'Thông báo test',
      body: 'Đây là thông báo test từ ứng dụng',
      payload: 'notification:0',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi thông báo test')),
    );
  }
}
