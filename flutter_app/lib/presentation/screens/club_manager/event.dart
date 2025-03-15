import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_manager.dart';
import '../../../data/repositories/event_repository.dart';
import 'create/createEven.dart';

class EventManagementScreen extends StatefulWidget {
  @override
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  bool isModalOpen = false;
  String selectedFilter = 'Tất cả';

  void openModal() {
    setState(() {
      isModalOpen = true;
    });
  }

  void closeModal() {
    setState(() {
      isModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      endDrawer: CustomDrawerManager(),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      SizedBox(height: 16),
                      _buildSearchAndFilters(),
                      SizedBox(height: 16),
                      _buildFilterChips(),
                      SizedBox(height: 16),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: _buildEventList(context),
                ),
              ],
            ),
            if (isModalOpen)
              CreateEventModal(
                isOpen: isModalOpen,
                onClose: closeModal,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openModal,
        backgroundColor: Colors.blue[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Quản lý Sự kiện',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sự kiện',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list, color: Colors.grey[600]),
            onPressed: () {
              // Handle filter button press
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    List<String> filters = [
      'Tất cả',
      'Đang diễn ra',
      'Sắp diễn ra',
      'Đã kết thúc',
      'Bản nháp'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: selectedFilter == filter,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[100],
              labelStyle: TextStyle(
                color: selectedFilter == filter
                    ? Colors.blue[800]
                    : Colors.black87,
                fontWeight: selectedFilter == filter
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final event = events[index];
          return _buildEventCard(context, event);
        },
        childCount: events.length,
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              event.image,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(event.status),
                  ],
                ),
                SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, event.location),
                SizedBox(height: 4),
                _buildInfoRow(
                    Icons.access_time, '${event.time} - ${event.date}'),
                SizedBox(height: 4),
                _buildInfoRow(
                  Icons.description,
                  event.proposal ? 'Có Proposal' : 'Không có Proposal',
                  color: event.proposal ? Colors.blue : Colors.grey[600],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Handle view event
                      },
                      icon: Icon(Icons.visibility, size: 18),
                      label: Text('Xem'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                      onPressed: () => _showDropdownMenu(context, event),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang diễn ra':
        return Colors.green[700]!;
      case 'Sắp diễn ra':
        return Colors.orange[700]!;
      case 'Bản nháp':
        return Colors.purple[700]!;
      case 'Đã kết thúc':
        return Colors.grey[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  void _showDropdownMenu(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildActionTile(
                icon: Icons.people,
                title: 'Danh sách đăng ký',
                onTap: () {
                  Navigator.pop(context);
                  // Handle registration list
                },
              ),
              _buildActionTile(
                icon: Icons.edit,
                title: 'Chỉnh sửa sự kiện',
                onTap: () {
                  Navigator.pop(context);
                  // Handle edit event
                },
              ),
              _buildActionTile(
                icon: Icons.delete,
                title: 'Xóa sự kiện',
                color: Colors.red[700],
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, event);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa sự kiện'),
        content:
            Text('Bạn có chắc chắn muốn xóa sự kiện "${event.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle delete event
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class CreateEventModal extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  CreateEventModal({required this.isOpen, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tạo sự kiện mới',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your form fields here
              ElevatedButton(
                onPressed: onClose,
                child: Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String location;
  final String time;
  final String date;
  final bool proposal;
  final String status;
  final String image;

  Event({
    required this.title,
    required this.location,
    required this.time,
    required this.date,
    required this.proposal,
    required this.status,
    required this.image,
  });
}

final List<Event> events = [
  Event(
    title: 'Hội thảo Công nghệ AI',
    location: 'Hội trường A1, Đại học ABC',
    time: '09:00',
    date: '15/07/2023',
    proposal: true,
    status: 'Sắp diễn ra',
    image: 'assets/event1.jpg',
  ),
  Event(
    title: 'Triển lãm Nghệ thuật Đương đại',
    location: 'Bảo tàng Mỹ thuật TP.HCM',
    time: '10:00',
    date: '20/07/2023',
    proposal: false,
    status: 'Đang diễn ra',
    image: 'assets/event2.jpg',
  ),
  // Add more events as needed
];
