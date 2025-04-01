import 'dart:async';
import 'dart:convert';
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

  // Categorization
  Map<String, List<NotificationModel>> _categorizedNotifications = {};
  List<String> _activeCategories = [];
  String _currentFilter = 'all';

  // Settings
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Getters
  int get unreadCount => _unreadCount;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  List<NotificationModel> get readNotifications => _readNotifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<NotificationModel>> get categorizedNotifications =>
      _categorizedNotifications;
  List<String> get activeCategories => _activeCategories;
  String get currentFilter => _currentFilter;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  NotificationProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    // Khởi tạo local notification service
    final bool initialized = await LocalNotificationService.init(
      onNotificationTap: (String? payload) {
        if (payload != null) {
          handleDeepLink(payload);
        }
      },
    );

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

    // Thiết lập timer để refresh mỗi 15 giây - giảm thời gian để nhận thông báo nhanh hơn
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      fetchNotifications(silent: true);
    });

    // Khởi tạo categories
    _initializeCategories();

    _isInitialized = true;
  }

  // Khởi tạo danh mục thông báo
  void _initializeCategories() {
    _activeCategories = ['all', 'event', 'blog', 'club', 'system', 'promotion'];
    _currentFilter = 'all';
  }

  // Lọc thông báo theo danh mục
  void filterByCategory(String category) {
    _currentFilter = category;
    notifyListeners();
  }

  // Lấy thông báo theo danh mục hiện tại
  List<NotificationModel> getFilteredNotifications() {
    if (_currentFilter == 'all') {
      return [..._unreadNotifications, ..._readNotifications];
    }

    return [..._unreadNotifications, ..._readNotifications]
        .where((notification) {
      String type = notification.notificationType;
      if (type == 'new_event') type = 'event';
      if (type == 'new_blog') type = 'blog';
      return type == _currentFilter;
    }).toList();
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

  // Xử lý Deep Link từ thông báo
  void handleDeepLink(String payload) {
    debugPrint('Processing deep link: $payload');
    try {
      // Validate payload format
      if (payload.isEmpty) {
        debugPrint('Empty payload received');
        return;
      }

      final parts = payload.split(':');
      if (parts.length != 2) {
        debugPrint('Invalid payload format: $payload');
        return;
      }

      final String type = parts[0].trim();

      // Validate notification type
      final List<String> validTypes = [
        'event',
        'blog',
        'club',
        'notification',
        'new_event',
        'new_blog'
      ];
      if (!validTypes.contains(type)) {
        debugPrint('Invalid notification type in payload: $type');
        return;
      }

      // Safely parse ID
      final int? id = int.tryParse(parts[1]);
      if (id == null || id <= 0) {
        debugPrint('Invalid ID in payload: ${parts[1]}');
        return;
      }

      // Log and navigate
      debugPrint('Navigating from valid deep link: $type - $id');
      _navigateToContent(type, id);
    } catch (e) {
      debugPrint('Error processing deep link: $e');
    }
  }

  // Xử lý thông báo Firebase
  void handleFirebaseMessage(dynamic message) {
    debugPrint('Handling Firebase message');
    try {
      if (message == null) {
        debugPrint('Null message received');
        return;
      }

      // Xử lý dữ liệu thông báo và thêm vào danh sách
      fetchNotifications(silent: true);

      // Nếu có dữ liệu notification trong message
      if (message is Map) {
        // Validate message structure
        if (!message.containsKey('data') &&
            !message.containsKey('notification')) {
          debugPrint('Invalid message format: missing data and notification');
          return;
        }

        // Chuyển đổi message thành Map<String, dynamic>
        Map<String, dynamic> messageData = Map<String, dynamic>.from(message);

        // Sanitize messageData to prevent injection attacks
        messageData = _sanitizeMessageData(messageData);

        if (messageData.containsKey('notification')) {
          // Hiển thị thông báo ngay lập tức nếu ứng dụng đang mở
          LocalNotificationService.showNotificationFromFirebaseMessage(
              messageData);
        }
      }
    } catch (e) {
      debugPrint('Error handling Firebase message: $e');
    }
  }

  // Sanitize incoming message data to prevent security issues
  Map<String, dynamic> _sanitizeMessageData(Map<String, dynamic> messageData) {
    final result = <String, dynamic>{};

    // Copy notification
    if (messageData.containsKey('notification') &&
        messageData['notification'] is Map) {
      final notification = <String, dynamic>{};
      final sourceNotification = messageData['notification'] as Map;

      // Only copy allowed fields with proper types
      if (sourceNotification.containsKey('title') &&
          sourceNotification['title'] is String) {
        notification['title'] = sourceNotification['title'];
      }

      if (sourceNotification.containsKey('body') &&
          sourceNotification['body'] is String) {
        notification['body'] = sourceNotification['body'];
      }

      result['notification'] = notification;
    }

    // Copy data
    if (messageData.containsKey('data') && messageData['data'] is Map) {
      final data = <String, dynamic>{};
      final sourceData = messageData['data'] as Map;

      // Only copy allowed fields with proper validation
      final allowedFields = [
        'type',
        'id',
        'image_url',
        'sender_name',
        'action_text',
        'facebook_style',
        'click_action'
      ];

      for (final field in allowedFields) {
        if (sourceData.containsKey(field) && sourceData[field] is String) {
          // Extra validation for IDs to ensure they're numeric
          if (field == 'id') {
            final idVal = sourceData[field] as String;
            if (int.tryParse(idVal) != null) {
              data[field] = idVal;
            }
          } else {
            data[field] = sourceData[field];
          }
        }
      }

      result['data'] = data;
    }

    return result;
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
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.eventDetail, (route) => false,
            arguments: id.toString());
        break;
      case 'blog':
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.blogDetail, (route) => false,
            arguments: id.toString());
        break;
      case 'club':
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.clubDetail, (route) => false,
            arguments: id.toString());
        break;
      case 'notification':
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.notificationDetail, (route) => false,
            arguments: id.toString());
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

      // Phân loại thông báo
      _categorizeNotifications();

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

  // Phân loại thông báo theo loại
  void _categorizeNotifications() {
    _categorizedNotifications = {};

    // Khởi tạo các danh mục
    for (var category in _activeCategories) {
      _categorizedNotifications[category] = [];
    }

    // Thêm tất cả thông báo vào danh mục 'all'
    _categorizedNotifications['all'] = [
      ..._unreadNotifications,
      ..._readNotifications
    ];

    // Phân loại thông báo theo loại
    for (var notification in [..._unreadNotifications, ..._readNotifications]) {
      String type = notification.notificationType;

      // Ánh xạ loại thông báo
      if (type == 'new_event') type = 'event';
      if (type == 'new_blog') type = 'blog';

      // Nếu danh mục tồn tại, thêm thông báo vào
      if (_categorizedNotifications.containsKey(type)) {
        _categorizedNotifications[type]!.add(notification);
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

    // Xác định loại thông báo và ID
    String notificationType = notification.notificationType;
    if (notificationType == 'new_event') notificationType = 'event';
    if (notificationType == 'new_blog') notificationType = 'blog';

    // Xác định ID mục tiêu
    int targetId = notification.getTargetId() ?? notification.id;

    // Tạo payload
    String payload = '$notificationType:$targetId';

    // Chỉ hiển thị thông báo nếu đã bật
    if (_notificationsEnabled) {
      final bool success = await LocalNotificationService.showNotification(
        id: _notificationId,
        title: notification.title,
        body: notification.content,
        payload: payload,
        imageUrl: imageUrl,
      );

      if (!success) {
        debugPrint('Failed to show system notification');
      }
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

        // Cập nhật phân loại
        _categorizeNotifications();

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

      // Cập nhật phân loại
      _categorizeNotifications();

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

      // Cập nhật phân loại
      _categorizeNotifications();

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

      // Cập nhật phân loại
      _categorizeNotifications();

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Cập nhật cài đặt thông báo
  void updateNotificationSettings({
    bool? enabled,
    bool? sound,
    bool? vibration,
  }) {
    if (enabled != null) _notificationsEnabled = enabled;
    if (sound != null) _soundEnabled = sound;
    if (vibration != null) _vibrationEnabled = vibration;
    notifyListeners();
  }
}
