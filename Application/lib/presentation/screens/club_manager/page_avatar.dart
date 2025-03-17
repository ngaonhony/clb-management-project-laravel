import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_manager.dart';

class PageAvatar extends StatelessWidget {
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
            children: [
              // Header
              _buildHeader(context),
              SizedBox(height: 16),
              // Hero Section
              _buildHeroSection(),
              SizedBox(height: 16),
              // About Section
              _buildAboutSection(),
              SizedBox(height: 16),
              // Past Events
              _buildPastEvents(),
              SizedBox(height: 16),
              // Management Team
              _buildManagementTeam(),
              SizedBox(height: 16),
              // Contact Form
              _buildContactForm(),
              SizedBox(height: 16),
              // Club Members
              _buildClubMembers(),
              SizedBox(height: 16),
              // Club Photos
              _buildClubPhotos(),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quản lý Trang đại diện',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description, size: 16),
                  SizedBox(width: 8),
                  Text('Xem bản nháp'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Open modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tạo Trang đại diện',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Tên Câu Lạc Bộ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatistic('10+', 'Năm phát triển'),
              SizedBox(width: 16),
              _buildStatistic('15', 'Chương trình'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatistic('50+', 'Thành viên'),
              SizedBox(width: 16),
              _buildStatistic('5', 'Giảng viên cố vấn'),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: List.generate(6, (index) {
              return Image.asset(
                'assets/1.webp',
                fit: BoxFit.cover,
              );
            }),
          ),
        ],
      ),
    );
  }

  // Statistic Widget
  Widget _buildStatistic(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // About Section
  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chúng tôi là ai',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.palette, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Văn hoá, Nghệ thuật'),
                  ],
                ),
                backgroundColor: Colors.blue[50],
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Với tầm nhìn phát triển CLB trở thành một CLB nghệ thuật lớn mạnh cả trong và ngoài phạm vi trường đại học...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Past Events
  Widget _buildPastEvents() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sự kiện đã tổ chức',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/1.webp',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sự kiện Talkshow',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Liveshow Ngồi Ngắm Ngày Thơ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Một buổi liveshow âm nhạc và thơ ca đặc sắc...',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Management Team
  Widget _buildManagementTeam() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ban quản trị Câu Lạc Bộ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(5, (index) {
              return Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/placeholder.png'),
                    radius: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nguyễn Văn A',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Trưởng ban',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Contact Form
  Widget _buildContactForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liên hệ tài trợ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Hãy để lại thông tin để chúng tôi có thể liên hệ với bạn',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'nguyengiakhanhqqq@gmail.com',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                '0338365247',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 16),
              Icon(
                Icons.facebook,
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Khánh Nguyễn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '0334567890',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '21520147@gm.uit.edu.vn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nội dung',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(
                    'Gửi',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Club Members
  Widget _buildClubMembers() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Thành viên Câu Lạc Bộ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Cùng lắng nghe họ nói gì về CLB',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Đăng ký thành viên',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                    '"',
                    style: TextStyle(fontSize: 48, color: Colors.grey[200]),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/placeholder.png'),
                    radius: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'CLB đã giúp tôi phát triển rất nhiều kỹ năng.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nguyễn Văn A',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Thành viên',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Club Photos
  Widget _buildClubPhotos() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hình ảnh hoạt động CLB',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(6, (index) {
              return Image.asset(
                'assets/1.webp',
                fit: BoxFit.cover,
              );
            }),
          ),
        ],
      ),
    );
  }
}
