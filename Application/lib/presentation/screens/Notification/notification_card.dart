import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onMarkAsRead,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color notificationColor;
    IconData notificationIcon;

    switch (notification.notificationType) {
      case 'new_event':
        notificationColor = Colors.blue;
        notificationIcon = Icons.event;
        break;
      case 'new_blog':
        notificationColor = Colors.green;
        notificationIcon = Icons.article;
        break;
      case 'promotion':
        notificationColor = Colors.orange;
        notificationIcon = Icons.local_offer;
        break;
      case 'system':
        notificationColor = Colors.purple;
        notificationIcon = Icons.settings;
        break;
      default:
        notificationColor = Colors.grey;
        notificationIcon = Icons.notifications;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: notification.isRead
              ? Colors.transparent
              : notificationColor.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            // Left color indicator based on notification type
            Container(
              width: 6,
              height: 75,
              color:
                  notification.isRead ? Colors.transparent : notificationColor,
            ),
            // Notification icon
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: notificationColor.withOpacity(0.1),
                child: Icon(notificationIcon, color: notificationColor),
              ),
            ),
            // Notification content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!notification.isRead)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: notificationColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Mới',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.content,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.time),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action buttons
            if (!notification.isRead)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: notificationColor,
                onPressed: onMarkAsRead,
                tooltip: 'Đánh dấu đã đọc',
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
