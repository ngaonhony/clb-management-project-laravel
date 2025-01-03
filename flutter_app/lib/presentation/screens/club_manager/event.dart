import 'package:flutter/material.dart';
import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer_manager.dart';
import '../../../data/repositories/event_repository.dart';
import 'create/createEven.dart';

class EventManagementScreen extends StatefulWidget {
  @override
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  bool isModalOpen = false; // Trạng thái để kiểm soát việc mở/đóng modal

  // Hàm mở modal
  void openModal() {
    setState(() {
      isModalOpen = true;
    });
  }

  // Hàm đóng modal
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  SizedBox(height: 16),
                  // Search and Filters
                  _buildSearchAndFilters(),
                  SizedBox(height: 16),
                  // Event List
                  _buildEventList(context),
                ],
              ),
            ),
          ),
          // Hiển thị CreateEventModal nếu isModalOpen = true
          if (isModalOpen)
            CreateEventModal(
              isOpen: isModalOpen,
              onClose: closeModal,
            ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quản lý Sự kiện',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),

      ],
    );
  }

  // Search and Filters with Create Event Button
  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        // Search Bar
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sự kiện',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        SizedBox(width: 8), // Khoảng cách giữa thanh tìm kiếm và nút
        // Filter Button
        IconButton(
          icon: Icon(Icons.filter_list, size: 24),
          onPressed: () {
            // Handle filter button press
          },
        ),
        SizedBox(width: 8), // Khoảng cách giữa nút lọc và nút tạo sự kiện
        // Create Event Button
        ElevatedButton(
          onPressed: openModal, // Gọi hàm mở modal khi nhấn nút
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Row(
            children: [
              Icon(Icons.add, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Tạo sự kiện',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Event List
  Widget _buildEventList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image and Title
                Row(
                  children: [
                    Image.asset(
                      event.image,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            event.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Time
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      '${event.time} - ${event.date}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Proposal
                Row(
                  children: [
                    Icon(Icons.description, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    event.proposal
                        ? Text(
                      'Có Proposal',
                      style: TextStyle(color: Colors.blue),
                    )
                        : Text(
                      'Không có Proposal',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Status
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: _getStatusColor(event.status)),
                    SizedBox(width: 8),
                    Text(
                      event.status,
                      style: TextStyle(
                        color: _getStatusTextColor(event.status),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Actions
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.more_vert, size: 20),
                    onPressed: () {
                      _showDropdownMenu(context, event);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Get Status Color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang diễn ra':
        return Colors.green;
      case 'Sắp diễn ra':
        return Colors.orange;
      case 'Bản nháp':
        return Colors.purple;
      case 'Đã kết thúc':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Get Status Text Color
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Đang diễn ra':
        return Colors.green[800]!;
      case 'Sắp diễn ra':
        return Colors.orange[800]!;
      case 'Bản nháp':
        return Colors.purple[800]!;
      case 'Đã kết thúc':
        return Colors.grey[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  // Show Dropdown Menu
  void _showDropdownMenu(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.remove_red_eye),
              title: Text('Xem Sự kiện'),
              onTap: () {
                Navigator.pop(context);
                // Handle view event
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Danh sách đăng ký'),
              onTap: () {
                Navigator.pop(context);
                // Handle registration list
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Chỉnh sửa sự kiện'),
              onTap: () {
                Navigator.pop(context);
                // Handle edit event
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa sự kiện', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Handle delete event
              },
            ),
          ],
        );
      },
    );
  }
}