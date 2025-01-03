import 'package:flutter/material.dart';
import 'package:nckh/routes.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần nội dung chính
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 20), // Khoảng cách trên cùng
                _buildMenuItem(
                  title: "Nhà tài trợ",
                  icon: Icons.arrow_drop_down,
                  showTrailing: true,
                ),
                _buildMenuItem(
                  title: "Quản lý câu lạc bộ",
                  icon: Icons.arrow_outward,
                  showTrailing: true,
                  onTap: () {
                    Navigator.pop(context); // Đóng Drawer
                    Navigator.pushNamed(
                      context,
                      AppRoutes.clubList,

                    );
                  },
                ),
                _buildMenuItem(
                  title: "Sự kiện",
                  icon: Icons.arrow_outward,
                  showTrailing: false,
                ),
                _buildMenuItem(
                  title: "Bài viết",
                  icon: Icons.arrow_outward,
                  showTrailing: false,
                ),
                Divider(
                  color: Colors.grey,
                  height: 40,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16,
                ),
              ],
            ),
          ),

          _buildBottomMenu(context),
        ],
      ),
    );
  }

  // Widget tạo các mục menu
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    bool showTrailing = false,
    VoidCallback? onTap, // Thêm tham số onTap
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        icon,
        size: 24,
        color: Colors.black,
      ),
      onTap: onTap, // Sử dụng onTap
    );
  }

  // Widget cho phần dưới cùng: Đăng ký và Đăng nhập
  Widget _buildBottomMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.app_registration, size: 20),
            title: Text(
              "Đăng ký",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context); // Đóng Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.login, size: 20),
            title: Text(
              "Đăng nhập",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

