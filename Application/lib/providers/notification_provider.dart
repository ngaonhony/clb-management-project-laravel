import 'dart:async';
import 'package:flutter/material.dart';
import '../services/NotificationService.dart';
import '../data/models/notification_model.dart';
import '../services/local_notification_service.dart';
import '../routes/app_routes.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int _unreadCount = 0;
  List<NotificationModel> _unreadNotifications = [];
  List<NotificationModel> _readNotifications = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  int _notificationId = 0;
  bool _isInitialized = false;

  // Getters
  int get unreadCount => _unreadCount;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  List<NotificationModel> get readNotifications => _readNotifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificationProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    // Khởi tạo local notification service
    final bool initialized = await LocalNotificationService.init();
    if (!initialized) {
      _error = 'Không thể khởi tạo dịch vụ thông báo';
      notifyListeners();
      return;
    }

    // Lắng nghe sự kiện click thông báo
    LocalNotificationService.onNotificationClick.stream
        .listen(_handleNotificationClick);

    // Fetch notifications ngay lập tức
    await fetchNotifications();

    // Thiết lập timer để refresh mỗi 30 giây
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchNotifications(silent: true);
    });

    _isInitialized = true;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  // Xử lý khi click vào thông báo
  void _handleNotificationClick(ReceivedNotification notification) {
    debugPrint(
        'Handling notification click: ${notification.type} - ${notification.targetId}');

    if (notification.type != null && notification.targetId != null) {
      _navigateToContent(notification.type!, notification.targetId!);
    }
  }

  // Điều hướng đến nội dung tương ứng
  void _navigateToContent(String type, int id) {
    debugPrint('Navigating to content: $type - $id');

    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('No valid context for navigation');
      return;
    }

    switch (type) {
      case 'event':
        Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: id);
        break;
      case 'blog':
        Navigator.pushNamed(context, AppRoutes.blogDetail, arguments: id);
        break;
      case 'notification':
        Navigator.pushNamed(context, AppRoutes.notificationDetail,
            arguments: id);
        break;
      default:
        debugPrint('Unknown notification type: $type');
    }
  }

  // Fetch notifications từ server
  Future<void> fetchNotifications({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final notifications = await _notificationService.getNotifications();
      List<NotificationModel> oldUnreadNotifications =
          List.from(_unreadNotifications);

      // Xử lý unread notifications
      if (notifications['unread'] != null && notifications['unread'] is List) {
        _unreadNotifications = (notifications['unread'] as List)
            .where((item) => item is Map<String, dynamic>)
            .map((item) =>
                NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      // Xử lý read notifications
      if (notifications['read'] != null && notifications['read'] is List) {
        _readNotifications = (notifications['read'] as List)
            .where((item) => item is Map<String, dynamic>)
            .map((item) =>
                NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      _unreadCount = _unreadNotifications.length;

      // Kiểm tra và hiển thị thông báo mới
      if (!silent &&
          oldUnreadNotifications.length < _unreadNotifications.length) {
        // Có thông báo mới
        List<NotificationModel> newNotifications = _unreadNotifications
            .where((notification) =>
                !oldUnreadNotifications.any((old) => old.id == notification.id))
            .toList();

        for (var notification in newNotifications) {
          _showSystemNotification(notification);
        }
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      if (!silent) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
      }
    }
  }

  // Hiển thị thông báo hệ thống
  Future<void> _showSystemNotification(NotificationModel notification) async {
    _notificationId++;

    String? imageUrl;
    if (notification.rawData.containsKey('image_url')) {
      imageUrl = notification.rawData['image_url'];
    }

    final bool success = await LocalNotificationService.showNotification(
      id: _notificationId,
      title: notification.title,
      body: notification.content,
      payload: '${notification.notificationType}:${notification.id}',
      imageUrl: imageUrl,
    );

    if (!success) {
      debugPrint('Failed to show system notification');
    }
  }

  // Đánh dấu notification đã đọc
  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId.toString());

      // Tìm notification trong danh sách chưa đọc
      final index =
          _unreadNotifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        // Di chuyển từ unread sang read
        final notification = _unreadNotifications[index];
        _unreadNotifications.removeAt(index);
        _readNotifications.insert(0, notification);
        _unreadCount = _unreadNotifications.length;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Đánh dấu tất cả đã đọc
  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();

      // Di chuyển tất cả từ unread sang read
      _readNotifications.insertAll(0, _unreadNotifications);
      _unreadNotifications.clear();
      _unreadCount = 0;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Xóa một thông báo
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId.toString());

      // Xóa khỏi cả hai danh sách
      _unreadNotifications.removeWhere((n) => n.id == notificationId);
      _readNotifications.removeWhere((n) => n.id == notificationId);
      _unreadCount = _unreadNotifications.length;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Xóa tất cả thông báo
  Future<void> deleteAllNotifications() async {
    try {
      await _notificationService.deleteAllNotifications();

      // Xóa tất cả
      _unreadNotifications.clear();
      _readNotifications.clear();
      _unreadCount = 0;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
