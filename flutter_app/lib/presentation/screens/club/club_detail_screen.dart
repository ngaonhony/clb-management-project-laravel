import 'package:flutter/material.dart';

class ClubDetailScreen extends StatelessWidget {
  final String clubId;

  const ClubDetailScreen({Key? key, required this.clubId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
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
        title: const Text('Chi tiết Câu Lạc Bộ'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(),

            // Content with consistent padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Mission Section
                  _buildMissionSection(),
                  const SizedBox(height: 24),

                  // Featured Event
                  _buildFeaturedEvent(),
                  const SizedBox(height: 24),

                  // Management Team
                  _buildManagementTeam(management),
                  const SizedBox(height: 24),

                  // Members Section
                  _buildMembersSection(members),
                  const SizedBox(height: 24),

                  // Similar Clubs
                  _buildSimilarClubs(similarClubs),
                  const SizedBox(height: 32),

                  // Contact Form (moved to bottom as it's a call to action)
                  _buildContactForm(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hero Section with cover image and club info
  Widget _buildHeroSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Cover image
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

          // Club info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Câu Lạc Bộ Của Bạn',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Học thuật, Chuyên môn',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatistic('10', 'Năm phát triển'),
                      _buildVerticalDivider(),
                      _buildStatistic('15', 'Chương trình'),
                      _buildVerticalDivider(),
                      _buildStatistic('50', 'Thành viên'),
                      _buildVerticalDivider(),
                      _buildStatistic('20', 'Nhà tài trợ'),
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

  // Vertical divider for statistics
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  // Statistic Item
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

  // Mission Section
  Widget _buildMissionSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
                const SizedBox(width: 8),
                const Text(
                  'Sứ mệnh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Chúng tôi là ai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '– Học thuật, Chuyên môn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Đâu là ô dùng để nhập nội dung giới thiệu về CLB của bạn. Bạn hãy tạo một đoạn giới thiệu ngắn gọn, rõ ràng và hấp dẫn, cung cấp thông tin tổng quan về câu lạc bộ của bạn.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút "Liên hệ tài trợ"
              },
              icon: const Icon(Icons.handshake),
              label: const Text('Liên hệ tài trợ'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Featured Event
  Widget _buildFeaturedEvent() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Event badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SỰ KIỆN NỔI BẬT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Event title
              const Text(
                'MUSIC EST',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Âm nhạc, Tiệc tùng',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[100],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Dưới đây là đoạn mô tả sự kiện Âm nhạc, bạn có thể điền đoạn mô tả event của mình ở ô này',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[50],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Event statistics
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _buildEventStatistic('10', 'Đội tham dự'),
                  _buildEventStatistic('5', 'Tiếng'),
                  _buildEventStatistic('10.000', 'Khán giả'),
                  _buildEventStatistic('2.000.000', 'Số tiền gây quỹ'),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Xử lý khi nhấn nút
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Xem chi tiết sự kiện'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event Statistic Item
  Widget _buildEventStatistic(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[100],
            ),
          ),
        ],
      ),
    );
  }

  // Management Team
  Widget _buildManagementTeam(List<Map<String, String>> management) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text(
              'Ban quản trị Câu Lạc Bộ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Đây là phần giới thiệu về Ban quản trị của CLB. Bạn có thể nhập một đoạn giới thiệu ngắn về ban quản trị ở ô này.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Management grid with horizontal scrolling for better mobile experience
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: management.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 16),
                child: _buildManagementMember(management[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // Management Member Item
  Widget _buildManagementMember(Map<String, String> member) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/120?text=${member['name']}'),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          member['name']!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          member['position']!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Members Section
  Widget _buildMembersSection(List<Map<String, String>> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.forum, color: Colors.green[700]),
            const SizedBox(width: 8),
            const Text(
              'Thành viên chia sẻ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Đây là phần thông tin chia sẻ từ thành viên tham gia hoạt động cho câu lạc bộ. Bạn có thể tổng hợp một số chia sẻ nổi bật của các thành viên để giúp người dung hiểu hơn về hoạt động câu lạc bộ của bạn.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Member testimonials
        ...members
            .map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMemberCard(member),
                ))
            .toList(),

        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Xử lý khi nhấn nút "Đăng ký thành viên"
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Đăng ký thành viên'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // Member Card
  Widget _buildMemberCard(Map<String, String> member) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/48?text=${member['name']}'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        member['position']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.format_quote,
                  color: Colors.grey[300],
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              member['testimonial']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Similar Clubs
  Widget _buildSimilarClubs(List<Map<String, String>> similarClubs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.explore, color: Colors.purple[700]),
            const SizedBox(width: 8),
            const Text(
              'Các Câu Lạc Bộ tương tự',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Similar clubs list
        ...similarClubs
            .map((club) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSimilarClubCard(club),
                ))
            .toList(),

        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Xử lý khi nhấn nút "Tất cả Câu Lạc Bộ"
            },
            icon: const Icon(Icons.apps),
            label: const Text('Xem tất cả Câu Lạc Bộ'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  // Similar Club Card
  Widget _buildSimilarClubCard(Map<String, String> club) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  club['shortName']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club['name']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club['category']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        club['location']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.people,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${club['members']} thành viên',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (club['events'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${club['events']} sự kiện',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // Contact Form
  Widget _buildContactForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail, color: Colors.red[700]),
                const SizedBox(width: 8),
                const Text(
                  'Liên hệ tài trợ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Đây là nội dung mô tả cho phần thông tin CLB. Bạn có thể chỉnh sửa nội dung này nhằm kêu gọi liên hệ từ sinh viên và các doanh nghiệp muốn tài trợ cho câu lạc bộ.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Contact info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'contact@loremipsum.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '0123.456.789',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form fields
            _buildFormField('Tên cá nhân/tổ chức', Icons.person),
            const SizedBox(height: 12),
            _buildFormField('Số điện thoại', Icons.phone),
            const SizedBox(height: 12),
            _buildFormField('Email', Icons.email),
            const SizedBox(height: 12),
            _buildFormField('Nội dung', Icons.message, maxLines: 4),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút "Gửi"
              },
              icon: const Icon(Icons.send),
              label: const Text('Gửi thông tin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form field with icon
  Widget _buildFormField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
