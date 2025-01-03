import 'package:flutter/material.dart';

class ClubDetailScreen extends StatelessWidget {
  final String clubId;

  const ClubDetailScreen({required this.clubId});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final management = [
      {'name': 'Long', 'position': 'Chủ tịch CLB'},
      {'name': 'Lan', 'position': 'Trưởng ban Truyền thông'},
      {'name': 'Ngân', 'position': 'Trưởng ban Vận hành'},
      {'name': 'Tuấn', 'position': 'Trưởng ban Đối ngoại'},
      {'name': 'Mai', 'position': 'Trưởng ban Dự án'},
    ];

    final members = [
      {
        'name': 'Hoa',
        'position': 'Mar-Com Team Lead 2023',
        'testimonial':
        'Đây là đoạn điền thông tin, chia sẻ, cảm nghĩ của thành viên trong quá trình tham gia câu lạc bộ'
      },
      {
        'name': 'Thành',
        'position': 'Thành viên mới 2024',
        'testimonial':
        'Đây là đoạn điền thông tin, chia sẻ, cảm nghĩ của thành viên khi mới tham gia câu lạc bộ'
      },
      {
        'name': 'Hoàng',
        'position': 'Trưởng BTC Event',
        'testimonial':
        'Chia sẻ từ các thành viên về môi trường, văn hóa câu lạc bộ hiện tại'
      },
    ];

    final similarClubs = [
      {
        'name': 'Trường Làng Trong Phố',
        'shortName': 'TLTP',
        'category': 'Nghệ thuật, Sáng tạo',
        'location': 'Hà Nội',
        'members': '6'
      },
      {
        'name': 'PIC - Phan Dinh Phung Instrument Club',
        'shortName': 'PIC',
        'category': 'Nghệ thuật, Sáng tạo',
        'location': 'Hà Nội',
        'members': '98',
        'events': '10'
      },
      {
        'name': 'Southern Universities Debating Companionship',
        'shortName': 'SUDC',
        'category': 'Học thuật, Chuyên môn',
        'location': 'Hồ Chí Minh',
        'members': '30',
        'events': '1'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Chi tiết Câu Lạc Bộ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(),
            // Mission Section
            _buildMissionSection(),
            // Featured Event
            _buildFeaturedEvent(),
            // Management Team
            _buildManagementTeam(management),
            // Contact Form
            _buildContactForm(),
            // Members Section
            _buildMembersSection(members),
            // Similar Clubs
            _buildSimilarClubs(similarClubs),
          ],
        ),
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Text(
            'Câu Lạc Bộ Của Bạn',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2,
            children: [
              _buildStatistic('10', 'Năm phát triển'),
              _buildStatistic('15', 'Chương trình'),
              _buildStatistic('50', 'Thành viên'),
              _buildStatistic('20', 'Nhà tài trợ'),
            ],
          ),
        ],
      ),
    );
  }

  // Statistic Item
  Widget _buildStatistic(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Mission Section
  Widget _buildMissionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sứ mệnh',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Chúng tôi là ai',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            '– Học thuật, Chuyên môn',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Đâu là ô dùng để nhập nội dung giới thiệu về CLB của bạn. Bạn hãy tạo một đoạn giới thiệu ngắn gọn, rõ ràng và hấp dẫn, cung cấp thông tin tổng quan về câu lạc bộ của bạn.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn nút "Liên hệ tài trợ"
            },
            child: Text('Liên hệ tài trợ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Featured Event
  Widget _buildFeaturedEvent() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'MUSIC EST',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Âm nhạc, Tiệc tùng',
            style: TextStyle(fontSize: 16, color: Colors.blue[100]),
          ),
          SizedBox(height: 16),
          Text(
            'Music Event',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Dưới đây là đoạn mô tả sự kiện Âm nhạc, bạn có thể điền đoạn mô tả event của mình ở ô này',
            style: TextStyle(fontSize: 14, color: Colors.blue[100]),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2,
            children: [
              _buildEventStatistic('10', 'Đội tham dự'),
              _buildEventStatistic('5', 'Tiếng'),
              _buildEventStatistic('10.000', 'Khán giả'),
              _buildEventStatistic('2.000.000', 'Số tiền gây quỹ'),
            ],
          ),
        ],
      ),
    );
  }

  // Event Statistic Item
  Widget _buildEventStatistic(String value, String label) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.blue[100]),
          ),
        ],
      ),
    );
  }

  // Management Team
  Widget _buildManagementTeam(List<Map<String, String>> management) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ban quản trị Câu Lạc Bộ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Đây là phần giới thiệu về Ban quản trị của CLB. Bạn có thể nhập một đoạn giới thiệu ngắn về ban quản trị ở ô này.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: management.map((member) => _buildManagementMember(member)).toList(),
          ),
        ],
      ),
    );
  }

  // Management Member Item
  Widget _buildManagementMember(Map<String, String> member) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage('https://via.placeholder.com/120?text=${member['name']}'),
        ),
        SizedBox(height: 8),
        Text(
          member['name']!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          member['position']!,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Contact Form
  Widget _buildContactForm() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Liên hệ tài trợ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Đây là nội dung mô tả cho phần thông tin CLB. Bạn có thể chỉnh sửa nội dung này nhằm kêu gọi liên hệ từ sinh viên và các doanh nghiệp muốn tài trợ cho câu lạc bộ.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'contact@loremipsum.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            '0123.456.789',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Tên cá nhân/tổ chức',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Số điện thoại',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Nội dung',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn nút "Gửi"
            },
            child: Text('Gửi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  // Members Section
  Widget _buildMembersSection(List<Map<String, String>> members) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thành viên Câu Lạc Bộ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Đây là phần thông tin chia sẻ từ thành viên tham gia hoạt động cho câu lạc bộ. Bạn có thể tổng hợp một số chia sẻ nổi bật của các thành viên để giúp người dung hiểu hơn về hoạt động câu lạc bộ của bạn.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 16),
          Column(
            children: members.map((member) => _buildMemberCard(member)).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn nút "Đăng ký thành viên"
            },
            child: Text('Đăng ký thành viên'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  // Member Card
  Widget _buildMemberCard(Map<String, String> member) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://via.placeholder.com/48?text=${member['name']}'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member['name']!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member['position']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              member['testimonial']!,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Similar Clubs
  Widget _buildSimilarClubs(List<Map<String, String>> similarClubs) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các Câu Lạc Bộ tương tự',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: similarClubs.map((club) => _buildSimilarClubCard(club)).toList(),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Xử lý khi nhấn nút "Tất cả Câu Lạc Bộ"
            },
            child: Text(
              'Tất cả Câu Lạc Bộ →',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // Similar Club Card
  Widget _buildSimilarClubCard(Map<String, String> club) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://via.placeholder.com/64?text=${club['shortName']}',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club['name']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    club['category']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '${club['location']} • ${club['members']} thành viên',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (club['events'] != null)
                    Text(
                      'Đã tổ chức ${club['events']} sự kiện',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}