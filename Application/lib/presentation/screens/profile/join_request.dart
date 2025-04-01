import 'package:flutter/material.dart';
import '../../../models/join_request_model.dart';
import '../../../services/JoinRequestService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/user_model.dart';

class JoinRequestListScreen extends StatefulWidget {
  const JoinRequestListScreen({Key? key}) : super(key: key);

  @override
  State<JoinRequestListScreen> createState() => _JoinRequestListScreenState();
}

class _JoinRequestListScreenState extends State<JoinRequestListScreen> {
  final JoinRequestService _joinRequestService = JoinRequestService();
  bool _isLoading = true;
  List<JoinRequest> _joinRequests = [];
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
          'DEBUG join_request: User data from SharedPreferences: $userString');

      if (userString != null && userString.isNotEmpty) {
        try {
          final userData = json.decode(userString);
          _currentUser = User.fromJson(userData);
          print('DEBUG join_request: User ID loaded: ${_currentUser?.id}');
          await _loadJoinRequests();
        } catch (e) {
          print('DEBUG join_request: Error parsing user data: $e');
          setState(() {
            _error = 'Định dạng dữ liệu người dùng không hợp lệ';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Vui lòng đăng nhập để xem yêu cầu tham gia của bạn';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG join_request: Error loading user: $e');
      setState(() {
        _error = 'Không thể tải thông tin người dùng: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJoinRequests() async {
    if (_currentUser == null) {
      print('DEBUG join_request: Cannot load requests - user is null');
      return;
    }

    try {
      print(
          'DEBUG join_request: Loading requests for user ID: ${_currentUser!.id}');
      final requests =
          await _joinRequestService.getUserRequests(_currentUser!.id);
      print('DEBUG join_request: Loaded ${requests.length} requests');
      setState(() {
        _joinRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG join_request: Error loading requests: $e');
      setState(() {
        _error = 'Không thể tải danh sách yêu cầu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelJoinRequest(JoinRequest request) async {
    try {
      final result = await _joinRequestService.deleteJoinRequest(request.id);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã hủy yêu cầu thành công')),
        );
        await _loadJoinRequests();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể hủy yêu cầu: $e')),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Đang chờ';
      case 'approved':
        return 'Đã chấp nhận';
      case 'rejected':
        return 'Bị từ chối';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu cầu tham gia của tôi'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child:
                      Text(_error, style: const TextStyle(color: Colors.red)))
              : _joinRequests.isEmpty
                  ? const Center(
                      child: Text('Bạn chưa gửi yêu cầu tham gia nào'))
                  : RefreshIndicator(
                      onRefresh: _loadJoinRequests,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _joinRequests.length,
                        itemBuilder: (context, index) {
                          final request = _joinRequests[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.type == 'club'
                                              ? request.club?.name ??
                                                  'Câu lạc bộ không xác định'
                                              : request.event?.name ??
                                                  'Sự kiện không xác định',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(request.status),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _getStatusText(request.status),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Loại: ${request.type == 'club' ? 'Câu lạc bộ' : 'Sự kiện'}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  if (request.message != null &&
                                      request.message!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Lời nhắn: ${request.message}',
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                  if (request.responseMessage != null &&
                                      request.responseMessage!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Phản hồi: ${request.responseMessage}',
                                      style: TextStyle(
                                        color: request.status == 'rejected'
                                            ? Colors.red
                                            : Colors.green,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Text(
                                    'Gửi vào: ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                  if (request.status == 'pending')
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            _cancelJoinRequest(request),
                                        icon: const Icon(Icons.cancel,
                                            color: Colors.red),
                                        label: const Text('Hủy yêu cầu',
                                            style:
                                                TextStyle(color: Colors.red)),
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
