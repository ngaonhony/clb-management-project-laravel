import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_manager.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      endDrawer: CustomDrawerManager(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile
                _buildHeader(),
                SizedBox(height: 16),

                // Welcome Message
                _buildWelcomeMessage(),
                SizedBox(height: 16),

                // Warning Banner
                _buildWarningBanner(),
                SizedBox(height: 20),

                // Action Cards - Responsive grid
                _buildActionCards(context, isSmallScreen),
                SizedBox(height: 20),

                // Main Sections
                _buildMainSections(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header with improved spacing
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.person, color: Colors.grey[500]),
        ),
      ],
    );
  }

  // Welcome Message with emoji spacing
  Widget _buildWelcomeMessage() {
    return Text(
      'Chào mừng, Khánh Nguyên 👋',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  // Warning Banner with improved layout
  Widget _buildWarningBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.orange[600], size: 20),
          ),
          SizedBox(width: 10),
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
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action Cards with responsive layout
  Widget _buildActionCards(BuildContext context, bool isSmallScreen) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 1 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isSmallScreen ? 2.5 : 1.3,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        final items = [
          {
            'title': 'Bổ sung Thông tin',
            'description': 'Thông tin cơ bản của Câu Lạc Bộ',
            'color': Colors.green[50]!,
            'icon': Icons.info_outline,
          },
          {
            'title': 'Tạo Trang đại diện',
            'description': 'Trang đại diện của CLB và công khai trang',
            'color': Colors.blue[50]!,
            'icon': Icons.web_outlined,
          },
          {
            'title': 'Thêm Thành viên',
            'description': 'Tạo phòng ban để quản lý thông tin thành viên',
            'color': Colors.purple[50]!,
            'icon': Icons.people_outline,
          },
        ];

        return _buildActionCard(
          title: items[index]['title'] as String,
          description: items[index]['description'] as String,
          color: items[index]['color'] as Color,
          icon: items[index]['icon'] as IconData,
          onPressed: () {
            // Navigate to respective screen
          },
        );
      },
    );
  }

  // Action Card Widget with icon and improved layout
  Widget _buildActionCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.black87),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style:
                TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.3),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 36),
              elevation: 0,
            ),
            child: Text(
              'Bắt đầu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
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

  // Events Section with improved empty state
  Widget _buildEventsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
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
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.event_note, size: 36, color: Colors.grey[500]),
                ),
                SizedBox(height: 12),
                Text(
                  'Chưa có sự kiện nào',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  'Tạo sự kiện để thu hút các nhà tài trợ',
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 12, height: 1.3),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to create event screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(180, 36),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Tạo Sự kiện',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
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

  // Members Section with improved layout
  Widget _buildMembersSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  constraints: BoxConstraints.tightFor(width: 36, height: 36),
                  onPressed: () {
                    // Navigate to add members screen
                  },
                  icon: Icon(Icons.add, size: 20, color: Colors.black87),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, color: Colors.grey[500], size: 22),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ngaonhony',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Chỗ cho thuê phòng đẹp 2',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
}
