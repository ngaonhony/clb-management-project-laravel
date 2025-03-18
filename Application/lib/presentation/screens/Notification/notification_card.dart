import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định màu sắc và icon dựa vào loại thông báo
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
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left color indicator based on notification type
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.transparent
                        : notificationColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),

                // Icon column
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: notificationColor.withOpacity(0.1),
                        radius: 20,
                        child: Icon(notificationIcon, color: notificationColor),
                      ),
                    ],
                  ),
                ),

                // Content column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title with indicator for unread
                            Expanded(
                              child: Row(
                                children: [
                                  if (!notification.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: notificationColor,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
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
                                  ),
                                ],
                              ),
                            ),

                            // Type badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: notificationColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getTypeName(notification.notificationType),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: notificationColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Notification content
                        Text(
                          notification.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Footer with time and action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Time info
                            Text(
                              _getTimeFormat(notification.time),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),

                            // View details button
                            Row(
                              children: [
                                Text(
                                  'Xem chi tiết',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: notificationColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: notificationColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Chuyển đổi notification_type thành tên hiển thị
  String _getTypeName(String type) {
    switch (type) {
      case 'new_event':
        return 'Sự kiện';
      case 'new_blog':
        return 'Bài viết';
      case 'promotion':
        return 'Ưu đãi';
      case 'system':
        return 'Hệ thống';
      default:
        return 'Thông báo';
    }
  }

  String _getTimeFormat(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    // Less than a day
    if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(time);
    }
    // Less than a week
    else if (difference.inDays < 7) {
      return '${difference.inDays}d trước';
    }
    // Otherwise show date
    else {
      return DateFormat('dd/MM').format(time);
    }
  }
}
