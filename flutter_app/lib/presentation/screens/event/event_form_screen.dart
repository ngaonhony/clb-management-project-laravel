import 'package:flutter/material.dart';

class EventFormScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Thêm/Sửa Sự kiện')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên Sự kiện'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Ngày diễn ra'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý lưu thông tin sự kiện
                final name = _nameController.text;
                final date = _dateController.text;
                print('Tên Sự kiện: $name, Ngày diễn ra: $date');
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}