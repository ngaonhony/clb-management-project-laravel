import 'package:flutter/material.dart';
import '../../../models/event_model.dart';
import '../../../services/JoinRequestService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/user_model.dart';
import 'package:intl/intl.dart';

class JoinedEventsScreen extends StatefulWidget {
  const JoinedEventsScreen({Key? key}) : super(key: key);

  @override
  State<JoinedEventsScreen> createState() => _JoinedEventsScreenState();
}

class _JoinedEventsScreenState extends State<JoinedEventsScreen> {
  final JoinRequestService _joinRequestService = JoinRequestService();
  bool _isLoading = true;
  List<Event> _events = [];
  User? _currentUser;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');

      print(
          'DEBUG HistoryEvent: User data from SharedPreferences: $userString');

      if (userString != null && userString.isNotEmpty) {
        try {
          final userData = json.decode(userString);
          _currentUser = User.fromJson(userData);
          print('DEBUG HistoryEvent: User ID loaded: ${_currentUser?.id}');
          await _loadJoinedEvents();
        } catch (e) {
          print('DEBUG HistoryEvent: Error parsing user data: $e');
          setState(() {
            _error = 'Định dạng dữ liệu người dùng không hợp lệ';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Vui lòng đăng nhập để xem sự kiện của bạn';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG HistoryEvent: Error loading user: $e');
      setState(() {
        _error = 'Không thể tải thông tin người dùng: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJoinedEvents() async {
    if (_currentUser == null) {
      print('DEBUG HistoryEvent: Cannot load events - user is null');
      return;
    }

    try {
      print(
          'DEBUG HistoryEvent: Loading events for user ID: ${_currentUser!.id}');
      final events = await _joinRequestService.getUserEvents(_currentUser!.id);
      print('DEBUG HistoryEvent: Loaded ${events.length} events');
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG HistoryEvent: Error loading events: $e');
      setState(() {
        _error = 'Không thể tải danh sách sự kiện: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Chưa xác định';
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String _getEventStatusText(String status) {
    switch (status) {
      case 'upcoming':
        return 'Sắp diễn ra';
      case 'ongoing':
        return 'Đang diễn ra';
      case 'completed':
        return 'Đã kết thúc';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color _getEventStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventStatusIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.event_note;
      case 'ongoing':
        return Icons.event_available;
      case 'completed':
        return Icons.event_busy;
      case 'cancelled':
        return Icons.event_busy;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện của tôi'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadJoinedEvents();
            },
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 64),
                      SizedBox(height: 16),
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadCurrentUser,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _events.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bạn chưa tham gia sự kiện nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Quay lại'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadJoinedEvents,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Điều hướng đến trang chi tiết sự kiện
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => EventDetailScreen(event: event),
                                //   ),
                                // );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header hình ảnh
                                  Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          image: (event.backgroundImages !=
                                                      null &&
                                                  event.backgroundImages!
                                                      .isNotEmpty &&
                                                  event.backgroundImages![0] !=
                                                      null)
                                              ? DecorationImage(
                                                  image: NetworkImage(event
                                                      .backgroundImages![0]
                                                      .toString()),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          color: Colors.grey[300],
                                        ),
                                        child: (event
                                                        .backgroundImages ==
                                                    null ||
                                                event.backgroundImages!
                                                    .isEmpty ||
                                                event.backgroundImages![0] ==
                                                    null)
                                            ? const Center(
                                                child: Icon(Icons.event,
                                                    size: 50,
                                                    color: Colors.grey),
                                              )
                                            : null,
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getEventStatusColor(
                                                    event.status)
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getEventStatusIcon(
                                                    event.status),
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                _getEventStatusText(
                                                    event.status),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Tên sự kiện
                                        Text(
                                          event.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 12),
                                        // Tên câu lạc bộ tổ chức
                                        if (event.club != null)
                                          Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.indigo
                                                      .withOpacity(0.3)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.group,
                                                    size: 16,
                                                    color: Colors.indigo),
                                                const SizedBox(width: 8),
                                                Text(
                                                  event.club!.name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.indigo[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        const Divider(height: 20),

                                        // Thời gian sự kiện
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(Icons.access_time,
                                                    size: 16,
                                                    color: Colors.blue),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Bắt đầu: ${_formatDateTime(event.startDate)}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                    Icons.access_time_filled,
                                                    size: 16,
                                                    color: Colors.red[400]),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Kết thúc: ${_formatDateTime(event.endDate)}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Địa điểm sự kiện
                                        if (event.location != null &&
                                            event.location!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(Icons.location_on,
                                                      size: 16,
                                                      color: Colors.green),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    event.location!,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        // Mô tả ngắn
                                        if (event.shortDescription != null &&
                                            event.shortDescription!
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Mô tả:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  event.shortDescription!,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
