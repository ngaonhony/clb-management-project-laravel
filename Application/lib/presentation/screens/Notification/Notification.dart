import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../data/models/notification_model.dart';
import '../../../services/NotificationService.dart';
import 'notification_card.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _MyAppState();
}

class _MyAppState extends State<NotificationScreen> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thông Báo',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: NotificationListScreen(toggleTheme: _toggleTheme),
    );
  }
}

class NotificationListScreen extends StatefulWidget {
  final Function toggleTheme;

  const NotificationListScreen({super.key, required this.toggleTheme});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _unreadNotifications = [];
  List<NotificationModel> _readNotifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final notifications = await _notificationService.getNotifications();

      // Convert notifications to models with error handling
      List<NotificationModel> unread = [];
      List<NotificationModel> read = [];

      try {
        // Handle unread notifications
        if (notifications['unread'] != null &&
            notifications['unread'] is List) {
          unread = (notifications['unread'] as List)
              .where((item) =>
                  item is Map<String, dynamic>) // Filter only valid maps
              .map((item) =>
                  _notificationFromJson(item as Map<String, dynamic>, false))
              .toList();
        }

        // Handle read notifications
        if (notifications['read'] != null && notifications['read'] is List) {
          read = (notifications['read'] as List)
              .where((item) =>
                  item is Map<String, dynamic>) // Filter only valid maps
              .map((item) =>
                  _notificationFromJson(item as Map<String, dynamic>, true))
              .toList();
        }

        print(
            'Processed ${unread.length} unread and ${read.length} read notifications');
      } catch (e) {
        print('Error processing notifications: $e');
        // Don't rethrow, just log and continue with empty lists
      }

      setState(() {
        _unreadNotifications = unread;
        _readNotifications = read;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        // Hiển thị thông báo lỗi thân thiện hơn, loại bỏ các chi tiết kỹ thuật
        String errorMessage = e.toString();
        if (errorMessage.contains('401')) {
          errorMessage =
              'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại để xem thông báo.';
        } else if (errorMessage.contains('Failed to load data')) {
          errorMessage =
              'Không thể tải thông báo. Vui lòng kiểm tra kết nối mạng và thử lại.';
        }
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  NotificationModel _notificationFromJson(
      Map<String, dynamic> json, bool isRead) {
    // Assign a color based on notification ID for visual variety
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
    ];

    // Parse the notification data with error handling
    try {
      final notificationModel = NotificationModel.fromJson(json);

      // Safely assign color based on ID
      final safeId = notificationModel.id % colors.length;
      notificationModel.color = colors[safeId];

      return notificationModel;
    } catch (e) {
      // Log error for debugging
      print('Error parsing notification: $e');
      print('Problematic JSON: $json');

      // Return fallback notification model
      return NotificationModel(
        id: 0,
        title: 'Thông báo hệ thống',
        content: 'Không thể hiển thị nội dung thông báo này',
        time: DateTime.now(),
        isRead: isRead,
        color: Colors.grey,
        rawData: {'error': 'Parsing failed', 'original_data': json},
      );
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId.toString());

      setState(() {
        // Find the notification
        final index =
            _unreadNotifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // Move from unread to read
          final notification = _unreadNotifications[index];
          _unreadNotifications.removeAt(index);
          _readNotifications.insert(0, notification);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đánh dấu đã đọc: ${e.toString()}')),
      );
    }
  }

  void _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();

      setState(() {
        // Move all unread to read
        _readNotifications.insertAll(0, _unreadNotifications);
        _unreadNotifications = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Không thể đánh dấu tất cả đã đọc: ${e.toString()}')),
      );
    }
  }

  void _deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId.toString());

      setState(() {
        // Remove from either list
        _unreadNotifications.removeWhere((n) => n.id == notificationId);
        _readNotifications.removeWhere((n) => n.id == notificationId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa thông báo')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa thông báo: ${e.toString()}')),
      );
    }
  }

  void _deleteAllNotifications() async {
    try {
      await _notificationService.deleteAllNotifications();

      setState(() {
        _unreadNotifications = [];
        _readNotifications = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa tất cả thông báo')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Không thể xóa tất cả thông báo: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<NotificationModel> allNotifications = [
      ..._unreadNotifications,
      ..._readNotifications,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông Báo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              } else if (value == 'delete_all') {
                _deleteAllNotifications();
              } else if (value == 'refresh') {
                _fetchNotifications();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 8),
                    Text('Đánh dấu tất cả đã đọc'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep),
                    SizedBox(width: 8),
                    Text('Xóa tất cả thông báo'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Làm mới'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Không thể tải thông báo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchNotifications,
                          child: const Text('Thử lại'),
                        ),
                        if (_error!.contains('đăng nhập'))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextButton(
                              onPressed: () {
                                // TODO: Navigate to login screen
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(builder: (context) => LoginScreen()),
                                // );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Điều hướng đến màn hình đăng nhập')),
                                );
                              },
                              child: const Text('Đăng nhập'),
                            ),
                          ),
                      ],
                    ),
                  )
                : allNotifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off,
                                size: 80, color: Colors.grey.withOpacity(0.7)),
                            const SizedBox(height: 16),
                            Text(
                              "Không có thông báo nào",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.withOpacity(0.9)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Kéo xuống để làm mới",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: allNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = allNotifications[index];
                          return Dismissible(
                            key: Key('notification_${notification.id}'),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _deleteNotification(notification.id);
                            },
                            child: NotificationCard(
                              notification: notification,
                              onTap: () {
                                if (!notification.isRead) {
                                  _markAsRead(notification.id);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetailScreen(
                                      notification: notification,
                                      onDelete: () =>
                                          _deleteNotification(notification.id),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
