import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import '../../../utils/image_utils.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onShare;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onMarkAsRead,
    this.onTap,
    this.onLike,
    this.onShare,
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
      case 'club':
        notificationColor = Colors.indigo;
        notificationIcon = Icons.people;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main notification content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left color indicator based on notification type
                Container(
                  width: 6,
                  height: notification.interactionCount != null ? 95 : 75,
                  color: notification.isRead
                      ? Colors.transparent
                      : notificationColor,
                ),

                // Notification icon or avatar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: notification.senderImageUrl != null &&
                          notification.senderImageUrl!.isNotEmpty
                      ? ImageUtils.buildCircleAvatar(
                          imageUrl: notification.senderImageUrl,
                          radius: 24,
                          backgroundColor: notificationColor.withOpacity(0.1),
                          placeholder: CircleAvatar(
                            radius: 24,
                            backgroundColor: notificationColor.withOpacity(0.1),
                            child: Icon(notificationIcon,
                                color: notificationColor),
                          ),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundColor: notificationColor.withOpacity(0.1),
                          child:
                              Icon(notificationIcon, color: notificationColor),
                        ),
                ),

                // Notification content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges row (New, Type)
                        Row(
                          children: [
                            if (!notification.isRead)
                              Container(
                                margin: const EdgeInsets.only(right: 4),
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

                            // Type badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: notificationColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getTypeDisplay(notification.notificationType),
                                style: TextStyle(
                                  color: notificationColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Facebook style content
                        _buildFacebookStyleContent(notification),

                        // Time display
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTime(notification.time),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            // Interaction count (likes/comments if available)
                            if (notification.interactionCount != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${notification.interactionCount}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                          ],
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

            // Interaction buttons
            if (notification.interactionCount != null ||
                notification.hasNavigationId())
              Padding(
                padding: const EdgeInsets.only(left: 72, right: 16, bottom: 8),
                child: Row(
                  children: [
                    _buildActionButton(
                      context,
                      notification.isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      'Thích',
                      notification.isLiked ? Colors.blue : Colors.grey[700]!,
                      onLike ?? () {},
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      context,
                      Icons.share_outlined,
                      'Chia sẻ',
                      Colors.grey[700]!,
                      onShare ?? () {},
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build Facebook style notification content
  Widget _buildFacebookStyleContent(NotificationModel notification) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[800],
          height: 1.3,
        ),
        children: [
          if (notification.senderName != null)
            TextSpan(
              text: notification.senderName! + ' ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          TextSpan(
            text: _getActionText(notification),
          ),
          if (notification.title.isNotEmpty)
            TextSpan(
              text: ' "${notification.title}"',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  String _getActionText(NotificationModel notification) {
    switch (notification.notificationType) {
      case 'new_event':
        return 'đã tạo sự kiện mới';
      case 'new_blog':
        return 'đã đăng bài viết mới';
      case 'club':
        return 'đã ${notification.rawData['action'] ?? 'cập nhật'} câu lạc bộ';
      case 'promotion':
        return 'đã gửi ưu đãi đặc biệt';
      case 'system':
        return 'thông báo:';
      default:
        return notification.content;
    }
  }

  String _getTypeDisplay(String type) {
    switch (type) {
      case 'new_event':
        return 'Sự kiện';
      case 'new_blog':
        return 'Bài viết';
      case 'club':
        return 'CLB';
      case 'promotion':
        return 'Ưu đãi';
      case 'system':
        return 'Hệ thống';
      default:
        return 'Thông báo';
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
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
