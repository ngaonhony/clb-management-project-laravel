import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../services/ClubService.dart';
import '../../../services/EventService.dart';

class ClubDetailScreen extends StatefulWidget {
  final String clubId;

  const ClubDetailScreen({Key? key, required this.clubId}) : super(key: key);

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  Map<String, dynamic>? clubDetails;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadClubDetails();
  }

  Future<void> _loadClubDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Kiểm tra kết nối internet
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('Không có kết nối internet. Vui lòng thử lại sau.');
      }

      // Kiểm tra ID hợp lệ
      if (widget.clubId.isEmpty) {
        throw Exception('ID câu lạc bộ không hợp lệ');
      }

      // Gọi API để lấy thông tin chi tiết câu lạc bộ
      final clubData = await ClubService().getClub(widget.clubId);

      if (clubData == null) {
        throw Exception('Không tìm thấy thông tin câu lạc bộ');
      }

      setState(() {
        clubDetails = clubData;
        isLoading = false;
      });
    } on SocketException {
      setState(() {
        error =
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi tải thông tin CLB: $e");
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          children: [
            Text('Lỗi: $error'),
            ElevatedButton(
              onPressed: _loadClubDetails,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (clubDetails == null) {
      return const Center(
        child: Text('Không có thông tin câu lạc bộ'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(clubDetails!['name'] ?? 'Chi tiết Câu Lạc Bộ'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAboutSection(),
            _buildPastEvents(),
            _buildManagementTeam(),
            _buildContactForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.groups_rounded,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  clubDetails!['name'] ?? 'Câu Lạc Bộ Của Bạn',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getCategoryName(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatistic(_getMemberCount(), 'Thành viên'),
                      _buildVerticalDivider(),
                      _buildStatistic(_getEventCount(), 'Sự kiện'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chúng tôi là ai',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getDescription(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastEvents() {
    // Implement similar to Vue component
    return Container(); // Placeholder
  }

  Widget _buildManagementTeam() {
    // Implement similar to Vue component
    return Container(); // Placeholder
  }

  Widget _buildContactForm() {
    // Implement similar to Vue component
    return Container(); // Placeholder
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildStatistic(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    try {
      if (clubDetails!['category'] == null) {
        return 'Học thuật, Chuyên môn';
      }

      if (clubDetails!['category'] is Map) {
        return (clubDetails!['category'] as Map)['name']?.toString() ??
            'Học thuật, Chuyên môn';
      }

      return clubDetails!['category'].toString();
    } catch (e) {
      return 'Học thuật, Chuyên môn';
    }
  }

  String _getMemberCount() {
    try {
      return (clubDetails!['member_count'] ?? '0').toString();
    } catch (e) {
      return '0';
    }
  }

  String _getEventCount() {
    try {
      if (clubDetails!['events'] != null && clubDetails!['events'] is List) {
        return (clubDetails!['events'] as List).length.toString();
      }
      return '0';
    } catch (e) {
      return '0';
    }
  }

  // Hàm để lấy mô tả an toàn
  String _getDescription() {
    try {
      if (clubDetails!['description'] == null)
        return 'Chưa có mô tả cho câu lạc bộ này.';
      return clubDetails!['description'].toString();
    } catch (e) {
      return 'Chưa có mô tả cho câu lạc bộ này.';
    }
  }
}
