import 'package:flutter/material.dart';
import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer.dart';
import 'package:nckh/presentation/widgets/custom_search.dart';
import '../../routes.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../data/repositories/club_repository.dart'; // Import ClubRepository

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final clubRepository = ClubRepository(); // Khởi tạo ClubRepository

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: _buildBody(context, clubRepository),
      bottomNavigationBar: _buildFooter(context), // Truyền context vào _buildFooter
    );
  }

  // Xây dựng phần body của màn hình
  Widget _buildBody(BuildContext context, ClubRepository clubRepository) {
    final clubs = clubRepository.getClubs(); // Lấy danh sách các CLB

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final club = clubs[index];
        return _buildClubCard(context, club);
      },
    );
  }

  // Xây dựng một card hiển thị thông tin CLB
  Widget _buildClubCard(BuildContext context, Map<String, dynamic> club) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16), // Khoảng cách giữa các card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                club['imageUrl'], // Sử dụng Image.asset để hiển thị ảnh từ assets
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Tiêu đề
            Text(
              club['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Mô tả
            Text(
              club['description'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            // Địa điểm và số thành viên
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  club['location'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${club['members']} thành viên',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Nút "Chi tiết"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Điều hướng đến màn hình chi tiết CLB
                  Navigator.pushNamed(
                    context, // Sử dụng context từ tham số
                    AppRoutes.clubDetail,
                    arguments: club['id'], // Truyền clubId làm tham số
                  );
                },
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xây dựng thanh footer
  Widget _buildFooter(BuildContext context) {
    return BottomAppBar(
      height: 80,
      color: Colors.blue, // Màu nền của footer
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Các nút cách đều nhau
        children: [
          _buildFooterButton(Icons.home, 'Home', () {
            // Xử lý khi nhấn nút Home
          }),
          _buildFooterButton(Icons.search, 'Search', () {
            // Xử lý khi nhấn nút Search
          }),
          _buildFooterButton(Icons.notifications, 'Notifications', () {
            // Xử lý khi nhấn nút Notifications
          }),
          _buildFooterButton(Icons.person, 'Profile', () {
            // Điều hướng đến màn hình Profile
            Navigator.pushNamed(context, AppRoutes.profile);
          }),
        ],
      ),
    );
  }

  // Xây dựng một nút trong footer
  Widget _buildFooterButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white), // Icon của nút
          Text(
            label,
            style: const TextStyle(color: Colors.white), // Màu chữ của nút
          ),
        ],
      ),
    );
  }
}