import 'package:flutter/material.dart';
import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer_manager.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      endDrawer: CustomDrawerManager(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 20),
              // Welcome Message
              _buildWelcomeMessage(),
              SizedBox(height: 20),
              // Warning Banner
              _buildWarningBanner(),
              SizedBox(height: 20),
              // Action Cards
              _buildActionCards(context),
              SizedBox(height: 20),
              // Main Sections
              _buildMainSections(),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // Welcome Message
  Widget _buildWelcomeMessage() {
    return Text(
      'Chào mừng, Khánh Nguyên 👋',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Warning Banner
  Widget _buildWarningBanner() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[500], size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hồ sơ CLB còn thiếu (0/3 hoàn tất)',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hoàn thiện các bước cuối cùng bên dưới để Câu Lạc Bộ của bạn đi vào hoạt động',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action Cards
  Widget _buildActionCards(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2, // Giảm số cột để phù hợp với màn hình nhỏ
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2, // Tỉ lệ chiều rộng/chiều cao của mỗi card
      children: [
        _buildActionCard(
          title: 'Bổ sung Thông tin',
          description: 'Thông tin cơ bản của Câu Lạc Bộ',
          color: Colors.green[50]!,
          onPressed: () {
            // Navigate to update info screen
          },
        ),
        _buildActionCard(
          title: 'Tạo Trang đại diện',
          description: 'Trang đại diện của CLB và công khai trang',
          color: Colors.blue[50]!,
          onPressed: () {
            // Navigate to create page screen
          },
        ),
        _buildActionCard(
          title: 'Thêm Thành viên',
          description: 'Tạo phòng ban để quản lý thông tin thành viên',
          color: Colors.purple[50]!,
          onPressed: () {
            // Navigate to add members screen
          },
        ),
      ],
    );
  }

  // Action Card Widget
  Widget _buildActionCard({
    required String title,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 36), // Chiều cao tối thiểu
            ),
            child: Text(
              'Bắt đầu',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Main Sections
  Widget _buildMainSections() {
    return Column(
      children: [
        // Events Section
        _buildEventsSection(),
        SizedBox(height: 16),
        // Members Section
        _buildMembersSection(),
      ],
    );
  }

  // Events Section
  Widget _buildEventsSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sự kiện',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event, size: 40, color: Colors.grey[400]),
              SizedBox(height: 8),
              Text(
                'Chưa có sự kiện nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Tạo sự kiện để thu hút các nhà tài trợ',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Navigate to create event screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 36), // Chiều cao tối thiểu
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Tạo Sự kiện',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Members Section
  Widget _buildMembersSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thành viên',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to add members screen
                },
                icon: Icon(Icons.add, size: 20),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ngaonhony',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Chỗ cho thuê phòng đẹp 2',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}