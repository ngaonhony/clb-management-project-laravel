import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Map<String, String> profile = {
    'image': 'https://via.placeholder.com/150', // Ảnh mặc định
    'username': 'Nguyen Van A',
    'studentId': 'MSV123456',
    'email': 'example@example.com',
    'phone': '0123-456-789',
    'description': 'Sinh viên năm 3 ngành CNTT.',
  };

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Lấy thông tin user từ SharedPreferences
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        profile = {
          'image': userData['avatar'] ?? 'https://via.placeholder.com/150',
          'username': userData['username'] ?? 'Nguyen Van A',
          'studentId': userData['studentId'] ?? 'MSV123456',
          'email': userData['email'] ?? 'example@example.com',
          'phone': userData['phone'] ?? '0123-456-789',
          'description':
              userData['description'] ?? 'Sinh viên năm 3 ngành CNTT.',
        };
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _editField(String field) {
    TextEditingController controller =
        TextEditingController(text: profile[field]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nhập giá trị mới'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  profile[field] = controller.text;
                });

                // Lưu thông tin mới vào SharedPreferences
                final userData = {
                  'avatar': profile['image'],
                  'username': profile['username'],
                  'studentId': profile['studentId'],
                  'email': profile['email'],
                  'phone': profile['phone'],
                  'description': profile['description'],
                };
                await prefs.setString('user', jsonEncode(userData));

                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawerManager(),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : NetworkImage(profile['image']!) as ImageProvider,
                      child: _image == null
                          ? Icon(Icons.person, size: 64, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Name and Student ID
              Text(
                profile['username']!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                profile['studentId']!,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              // Email
              _buildProfileField('Email', profile['email']!),
              // Phone
              _buildEditableField('Số điện thoại', profile['phone']!,
                  () => _editField('phone')),
              // Description
              _buildEditableField('Mô tả', profile['description']!,
                  () => _editField('description')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, String value, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.indigo),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
