import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_manager.dart';

class BlogManagementPage extends StatefulWidget {
  @override
  _BlogManagementPageState createState() => _BlogManagementPageState();
}

class _BlogManagementPageState extends State<BlogManagementPage> {
  bool isModalOpen = false;

  void openModal() {
    setState(() {
      isModalOpen = true;
    });
  }

  void closeModal() {
    setState(() {
      isModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
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
                // Page title
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: Text(
                    'Quản lý Blog',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Thanh tìm kiếm và bộ lọc
                BlogSearchBar(onOpenModal: openModal),
                SizedBox(height: 16),
                // Danh sách blog
                BlogListScreen(),
              ],
            ),
          ),
        ),
      ),
      // Hiển thị modal tạo blog nếu isModalOpen = true
      floatingActionButton: FloatingActionButton(
        onPressed: openModal,
        backgroundColor: Colors.blue[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
      // Hiển thị modal tạo blog nếu isModalOpen = true
      bottomSheet: isModalOpen
          ? CreateBlogModal(isOpen: isModalOpen, onClose: closeModal)
          : null,
    );
  }
}

// Phần code của BlogSearchBar
class BlogSearchBar extends StatelessWidget {
  final Function() onOpenModal;

  const BlogSearchBar({Key? key, required this.onOpenModal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      children: [
        if (isSmallScreen)
          // Vertical layout for small screens
          _buildSmallScreenLayout(context)
        else
          // Horizontal layout for larger screens
          _buildLargeScreenLayout(context),
      ],
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
              hintText: 'Tìm kiếm Blog',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(height: 12),
        // Filter row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Tất cả',
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        size: 24, color: Colors.grey[600]),
                    items: <String>['Tất cả', 'Đã đăng', 'Bản nháp']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.sort, size: 20, color: Colors.grey[700]),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: onOpenModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, size: 18, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Tạo Blog',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Row(
      children: [
        // Search bar
        Expanded(
          flex: 2,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey[500], size: 20),
                hintText: 'Tìm kiếm Blog',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Filter dropdown
        Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'Tất cả',
              icon: Icon(Icons.arrow_drop_down,
                  size: 24, color: Colors.grey[600]),
              items:
                  <String>['Tất cả', 'Đã đăng', 'Bản nháp'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
        ),
        SizedBox(width: 12),
        // Sort button
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(Icons.sort, size: 20, color: Colors.grey[700]),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 12),
        // Create blog button
        ElevatedButton(
          onPressed: onOpenModal,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.add, size: 18, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Tạo Blog',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Phần code của BlogListScreen
class BlogListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            'Bài viết gần đây',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        // Blog List
        _buildBlogList(context),
      ],
    );
  }

  // Blog List
  Widget _buildBlogList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              _buildBlogHeader(context, blog),
              // Content
              _buildBlogContent(blog, context),
              // Footer with stats
              _buildBlogFooter(blog),
            ],
          ),
        );
      },
    );
  }

  // Blog Header
  Widget _buildBlogHeader(BuildContext context, Blog blog) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey[200] ?? Colors.grey)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(blog.image),
              radius: 20,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLB Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '12 tháng 12 lúc 18:54',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              constraints: BoxConstraints.tightFor(width: 36, height: 36),
              icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[700]),
              padding: EdgeInsets.zero,
              onPressed: () {
                _showDropdownMenu(context, blog);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Blog Content
  Widget _buildBlogContent(Blog blog, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                blog.image,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Blog Footer with stats
  Widget _buildBlogFooter(Blog blog) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.remove_red_eye_outlined, '${blog.id * 24}'),
          _buildStatItem(Icons.favorite_border, '${blog.id * 5}'),
          _buildStatItem(Icons.comment_outlined, '${blog.id * 2}'),
          _buildStatItem(Icons.share_outlined, '${blog.id}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Show Dropdown Menu
  void _showDropdownMenu(BuildContext context, Blog blog) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit, size: 20, color: Colors.blue[600]),
                ),
                title: Text(
                  'Chỉnh sửa Blog',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle edit blog
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete, size: 20, color: Colors.red[600]),
                ),
                title: Text(
                  'Xóa Blog',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle delete blog
                  _showDeleteConfirmation(context, blog);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, Blog blog) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Xóa Blog'),
        content: Text('Bạn có chắc chắn muốn xóa blog này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle delete
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// Phần code của CreateBlogModal
class CreateBlogModal extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;

  CreateBlogModal({required this.isOpen, required this.onClose});

  @override
  _CreateBlogModalState createState() => _CreateBlogModalState();
}

class _CreateBlogModalState extends State<CreateBlogModal> {
  File? _image;
  final TextEditingController _blogController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return Container();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      height: screenHeight * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Modal Header
          _buildModalHeader(),
          // Modal Body
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
                    _buildTitleInput(),
                    SizedBox(height: 16),
                    // Blog Input
                    _buildBlogInput(),
                    SizedBox(height: 20),
                    // Image Upload
                    _buildImageUpload(screenWidth),
                    SizedBox(height: 24),
                    // Submit Button
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modal Header
  Widget _buildModalHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tạo Blog Mới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              constraints: BoxConstraints.tightFor(width: 36, height: 36),
              icon: Icon(Icons.close, size: 20, color: Colors.grey[700]),
              padding: EdgeInsets.zero,
              onPressed: widget.onClose,
            ),
          ),
        ],
      ),
    );
  }

  // Title Input
  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiêu đề',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Nhập tiêu đề blog...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // Blog Input
  Widget _buildBlogInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nội dung',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _blogController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Viết nội dung blog của bạn...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // Image Upload
  Widget _buildImageUpload(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: Container(
            width: screenWidth * 0.8,
            height: screenWidth * 0.5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _image != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close,
                                size: 20, color: Colors.white),
                            onPressed: _removeImage,
                          ),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 32,
                            color: Colors.blue[600],
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Thêm ảnh cho bài viết',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Nhấn để chọn từ thư viện',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Submit Button
  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle save as draft
              widget.onClose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.grey[800],
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Lưu nháp',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle submit
              widget.onClose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Đăng bài',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Dữ liệu mẫu cho danh sách blog
class Blog {
  final int id;
  final String image;
  final String title;

  Blog({
    required this.id,
    required this.image,
    required this.title,
  });
}

final List<Blog> blogs = [
  Blog(
    id: 1,
    image: 'assets/1.webp',
    title: 'Lorem eget venenatis vestibulum odio egestas bibendum urna...',
  ),
  Blog(
    id: 2,
    image: 'assets/2.webp',
    title: 'Elementum dignissim tristique pellentesque eleifend posuere.',
  ),
  Blog(
    id: 3,
    image: 'assets/3.webp',
    title: 'Porta aliquet sed viverra fringilla.',
  ),
  Blog(
    id: 4,
    image: 'assets/4.webp',
    title: 'Non vitae tristique in sed aenean consectetur.',
  ),
  Blog(
    id: 5,
    image: 'assets/5.webp',
    title: 'Massa leo scelerisque bibendum eu commodo at vestibulum.',
  ),
];
