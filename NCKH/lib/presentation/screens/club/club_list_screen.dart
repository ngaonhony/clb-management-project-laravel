import 'package:flutter/material.dart';
import 'package:nckh/routes.dart'; // Import file routes.dart
import 'club_info_box.dart'; // Import widget ClubInfoBox

class ClubListScreen extends StatelessWidget {
  // Danh sách các CLB mẫu
  final List<Map<String, dynamic>> clubs = [
    {
      'id': '1', // Thêm ID của CLB
      'title': 'Minishow Len',
      'description': '"LEN" - hành trình cảm xúc qua những thanh âm du dương.',
      'location': 'Hà Nội',
      'members': 15,
      'imageUrl': 'https://via.placeholder.com/400x200',
    },
    {
      'id': '2', // Thêm ID của CLB
      'title': 'CLB Nghệ thuật',
      'description': 'Khám phá và sáng tạo nghệ thuật đa dạng.',
      'location': 'TP. Hồ Chí Minh',
      'members': 20,
      'imageUrl': 'https://via.placeholder.com/400x200', // URL hình ảnh mẫu
    },
    // Thêm các CLB khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Club'),
        automaticallyImplyLeading: false, // Ẩn nút "Trở lại" mặc định
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Điều hướng đến màn hình HomeScreen
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return ClubInfoBox(
            title: club['title'],
            description: club['description'],
            location: club['location'],
            members: club['members'],
            imageUrl: club['imageUrl'],
            onDetailsPressed: () {
              // Điều hướng đến màn hình chi tiết CLB với tham số clubId
              Navigator.pushNamed(
                context,
                AppRoutes.homeManager,

              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến màn hình thêm/sửa club
          Navigator.pushNamed(context, AppRoutes.clubForm);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}