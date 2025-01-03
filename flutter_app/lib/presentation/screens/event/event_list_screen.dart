import 'package:flutter/material.dart';
import 'package:nckh/routes.dart'; // Import file routes.dart
import 'event_detail_screen.dart';
import 'event_form_screen.dart';

class EventListScreen extends StatelessWidget {
  final List<String> events = ['Sự kiện A', 'Sự kiện B', 'Sự kiện C']; // Danh sách sự kiện mẫu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Danh sách Sự kiện'),
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
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index]),
            onTap: () {

              Navigator.pushNamed(
                context,
                AppRoutes.eventDetail,
                arguments: events[index], // Truyền eventId làm tham số
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến màn hình thêm/sửa sự kiện
          Navigator.pushNamed(context, AppRoutes.eventForm);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}