import 'dart:convert';
import 'package:flutter/material.dart';

class NotificationModel {
  final int id;
  final String title;
  final String content;
  final DateTime time;
  final bool isRead;
  final String notificationType;
  final String? icon;
  final Map<String, dynamic> rawData;
  Color? color;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
    this.notificationType = 'unknown',
    this.icon,
    this.color,
    required this.rawData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Trích xuất dữ liệu thông báo với xử lý an toàn
    Map<String, dynamic> data = {};
    if (json['data'] is Map) {
      data = Map<String, dynamic>.from(json['data']);
    } else if (json['data'] is String) {
      try {
        data = jsonDecode(json['data']);
      } catch (e) {
        data = {'message': json['data']};
      }
    }

    // Xác định loại thông báo
    String notificationType = data['notification_type'] ?? 'unknown';

    // Xác định tiêu đề dựa trên loại thông báo
    String title = data['title'] ?? 'Thông báo';
    if (notificationType == 'new_event') {
      title = data['event_name'] ?? 'Sự kiện mới';
    } else if (notificationType == 'new_blog') {
      title = data['blog_title'] ?? 'Bài viết mới';
    }

    // Xác định nội dung
    String content = data['message'] ?? '';
    if (content.isEmpty) {
      if (notificationType == 'new_event') {
        content =
            'Sự kiện mới: "${data['event_name'] ?? ''}" sẽ diễn ra vào ${data['start_date'] ?? ''} tại ${data['location'] ?? ''}';
      } else if (notificationType == 'new_blog') {
        content =
            'Bài viết mới: "${data['blog_title'] ?? ''}" bởi ${data['author_name'] ?? ''}';
      }
    }

    // Xác định icon dựa trên loại thông báo
    String icon = '🔔';
    if (notificationType == 'new_event') {
      icon = '📅';
    } else if (notificationType == 'new_blog') {
      icon = '📝';
    }

    // Tạo ID an toàn
    int id = 0;
    try {
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0;
    } catch (e) {
      id = 0;
    }

    // Xử lý datetime an toàn
    DateTime time = DateTime.now();
    try {
      if (json['read_at'] != null) {
        time = DateTime.tryParse(json['read_at'].toString()) ?? DateTime.now();
      } else if (json['created_at'] != null) {
        time =
            DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
      }
    } catch (e) {
      time = DateTime.now();
    }

    // Xác định trạng thái đã đọc
    bool isRead = false;
    try {
      isRead = json['read_at'] != null;
    } catch (e) {
      isRead = false;
    }

    return NotificationModel(
      id: id,
      title: title,
      content: content,
      time: time,
      isRead: isRead,
      notificationType: notificationType,
      icon: icon,
      rawData: {...json, ...data},
    );
  }

  // Lấy các thông tin chi tiết theo loại thông báo
  Map<String, dynamic> getDetailsBasedOnType() {
    Map<String, dynamic> details = {};

    switch (notificationType) {
      case 'new_event':
        details = {
          'event_id': rawData['event_id'],
          'event_name': rawData['event_name'] ?? title,
          'start_date': rawData['start_date'] ?? '',
          'end_date': rawData['end_date'] ?? '',
          'location': rawData['location'] ?? '',
          'description': rawData['description'] ?? content,
        };
        break;

      case 'new_blog':
        details = {
          'blog_id': rawData['blog_id'],
          'blog_title': rawData['blog_title'] ?? title,
          'author_name': rawData['author_name'] ?? '',
          'publish_date': rawData['publish_date'] ?? '',
          'content': rawData['blog_content'] ?? content,
        };
        break;

      case 'promotion':
        details = {
          'promotion_id': rawData['promotion_id'],
          'promotion_title': rawData['promotion_title'] ?? title,
          'valid_until': rawData['valid_until'] ?? '',
          'description': rawData['description'] ?? content,
        };
        break;

      default:
        details = {
          'title': title,
          'content': content,
        };
    }

    return details;
  }

  // Kiểm tra xem có ID để điều hướng hay không
  bool hasNavigationId() {
    switch (notificationType) {
      case 'new_event':
        return rawData['event_id'] != null;
      case 'new_blog':
        return rawData['blog_id'] != null;
      default:
        return false;
    }
  }

  // Lấy ID của đối tượng liên quan (event_id, blog_id, v.v.)
  int? getTargetId() {
    switch (notificationType) {
      case 'new_event':
        return rawData['event_id'] is int
            ? rawData['event_id']
            : int.tryParse(rawData['event_id']?.toString() ?? '');
      case 'new_blog':
        return rawData['blog_id'] is int
            ? rawData['blog_id']
            : int.tryParse(rawData['blog_id']?.toString() ?? '');
      default:
        return null;
    }
  }
}

// Sample data for notifications - keeping for testing purposes
List<NotificationModel> dummyNotifications = [
  NotificationModel(
    id: 1,
    title: "Khuyến mãi đặc biệt",
    content:
        "Chúng tôi có chương trình khuyến mãi đặc biệt dành cho tất cả khách hàng trong tháng này.",
    time: DateTime.now().subtract(const Duration(hours: 2)),
    notificationType: "promotion",
    rawData: {
      'promotion_id': 123,
      'valid_until': '30/04/2024',
      'description': 'Giảm 50% cho tất cả sự kiện trong tháng 4/2024'
    },
  ),
  NotificationModel(
    id: 2,
    title: "Cập nhật hệ thống",
    content: "Hệ thống sẽ được nâng cấp vào ngày mai từ 22:00 đến 23:00.",
    time: DateTime.now().subtract(const Duration(days: 1)),
    notificationType: "system",
    rawData: {
      'message': 'Hệ thống sẽ được nâng cấp vào ngày mai từ 22:00 đến 23:00.'
    },
  ),
  NotificationModel(
    id: 3,
    title: "Sự kiện mới",
    content:
        "Hội thảo kỹ năng mềm sẽ diễn ra vào ngày 25/03/2024 tại Hội trường A1.",
    time: DateTime.now().subtract(const Duration(days: 3)),
    notificationType: "new_event",
    rawData: {
      'event_id': 456,
      'event_name': 'Hội thảo kỹ năng mềm',
      'start_date': '25/03/2024',
      'location': 'Hội trường A1',
      'description':
          'Hội thảo kỹ năng mềm giúp bạn phát triển kỹ năng giao tiếp và làm việc nhóm.'
    },
  ),
  NotificationModel(
    id: 4,
    title: "Bài viết mới",
    content:
        "Bài viết 'Kỹ năng giao tiếp hiệu quả' đã được đăng bởi Nguyễn Văn A.",
    time: DateTime.now().subtract(const Duration(days: 7)),
    notificationType: "new_blog",
    rawData: {
      'blog_id': 789,
      'blog_title': 'Kỹ năng giao tiếp hiệu quả',
      'author_name': 'Nguyễn Văn A',
      'blog_content':
          'Bài viết chi tiết về các kỹ năng giao tiếp hiệu quả trong môi trường làm việc.'
    },
  ),
];
