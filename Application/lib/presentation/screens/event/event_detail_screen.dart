import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/EventService.dart';
import '../../../utils/date_formatter.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../UI/footer.dart';
import '../../../routes.dart';
import 'dart:developer' as developer;

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _eventData = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final eventData =
          await EventApiService.getEventById(int.parse(widget.eventId));

      setState(() {
        _eventData = eventData;
        _isLoading = false;
      });

      developer.log('Event data loaded: ${_eventData['name']}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Không thể tải thông tin sự kiện. Vui lòng thử lại sau.\nLỗi: $e';
      });
      developer.log('Error loading event details: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_eventData['name'] ?? 'Sự kiện không có tên'),
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoadingView(theme)
          : _errorMessage.isNotEmpty
              ? _buildErrorView(theme)
              : _buildEventDetailView(theme),
    );
  }

  Widget _buildLoadingView(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Đang tải thông tin sự kiện...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadEventDetails,
              icon: Icon(Icons.refresh),
              label: Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Quay lại'),
              style: TextButton.styleFrom(
                foregroundColor: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailView(ThemeData theme) {
    // Extract event data
    final String eventName = _eventData['name'] ?? 'Sự kiện không có tên';
    final String clubName =
        _eventData['club']?['name'] ?? 'Câu lạc bộ không xác định';
    final String categoryName =
        _eventData['category']?['name'] ?? 'Không có danh mục';
    final String location = _eventData['location'] ?? 'Chưa có địa điểm';
    final String content = _eventData['content'] ?? 'Không có mô tả chi tiết';

    // Parse dates
    DateTime? startDate, endDate;
    try {
      startDate = _eventData['start_date'] != null
          ? DateTime.parse(_eventData['start_date'])
          : null;
      endDate = _eventData['end_date'] != null
          ? DateTime.parse(_eventData['end_date'])
          : null;
    } catch (e) {
      developer.log('Error parsing dates: $e');
    }

    // Format dates
    final String formattedStartDate = startDate != null
        ? DateFormatter.formatDateTime(startDate)
        : 'Chưa có ngày bắt đầu';
    final String formattedEndDate = endDate != null
        ? DateFormatter.formatDateTime(endDate)
        : 'Chưa có ngày kết thúc';

    // Participants
    final int maxParticipants =
        int.tryParse(_eventData['max_participants']?.toString() ?? '0') ?? 0;
    final int registeredParticipants = int.tryParse(
            _eventData['registered_participants']?.toString() ?? '0') ??
        0;

    // Background images
    final List<dynamic> backgroundImages =
        _eventData['background_images'] ?? [];
    final String? firstImageUrl = backgroundImages.isNotEmpty
        ? backgroundImages.first['image_url']
        : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image or banner
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              image: firstImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(firstImageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: firstImageUrl == null
                ? Center(
                    child: Icon(
                      Icons.event,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  )
                : null,
          ),

          // Event header section
          Container(
            padding: EdgeInsets.all(16),
            color: theme.primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 8),

                // Club name
                Row(
                  children: [
                    Icon(Icons.group, size: 18, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      clubName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Category
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.category, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Event details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time section
                _buildInfoSection(
                  theme,
                  title: 'Thời gian',
                  icon: Icons.schedule,
                  children: [
                    _buildInfoRow(
                      icon: Icons.play_arrow,
                      text: 'Bắt đầu: $formattedStartDate',
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.stop,
                      text: 'Kết thúc: $formattedEndDate',
                    ),
                  ],
                ),

                Divider(height: 32),

                // Location section
                _buildInfoSection(
                  theme,
                  title: 'Địa điểm',
                  icon: Icons.location_on,
                  children: [
                    _buildInfoRow(
                      text: location,
                    ),
                  ],
                ),

                Divider(height: 32),

                // Participants section
                _buildInfoSection(
                  theme,
                  title: 'Số lượng người tham gia',
                  icon: Icons.people,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$registeredParticipants / ${maxParticipants > 0 ? maxParticipants : '∞'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        if (maxParticipants > 0)
                          LinearProgressIndicator(
                            value: registeredParticipants / maxParticipants,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              registeredParticipants >= maxParticipants
                                  ? Colors.red
                                  : theme.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                Divider(height: 32),

                // Content section
                _buildInfoSection(
                  theme,
                  title: 'Nội dung chi tiết',
                  icon: Icons.description,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Register button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: maxParticipants > 0 &&
                        registeredParticipants >= maxParticipants
                    ? null // Disable if full
                    : () {
                        // TODO: Implement registration logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Chức năng đăng ký tham gia đang được phát triển'),
                            backgroundColor: theme.primaryColor,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  maxParticipants > 0 &&
                          registeredParticipants >= maxParticipants
                      ? 'Đã đủ số lượng tham gia'
                      : 'Đăng ký tham gia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.primaryColor),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow({IconData? icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
