import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer_manager.dart';


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
      appBar: CustomAppBar(),
      endDrawer: CustomDrawerManager(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Thanh tìm kiếm và bộ lọc
              BlogSearchBar(onOpenModal: openModal),
              SizedBox(height: 16),
              // Danh sách blog
              BlogListScreen(),
            ],
          ),
        ),
      ),
      // Hiển thị modal tạo blog nếu isModalOpen = true
      floatingActionButton: isModalOpen
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      hintText: 'Tìm kiếm Blog',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButton<String>(
                  value: 'Tất cả',
                  items: <String>['Tất cả'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                  icon: Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey[400]),
                  underline: SizedBox(),
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: IconButton(
                  icon: Icon(Icons.sort, size: 20),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: onOpenModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Tạo Blog', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Phần code của BlogListScreen
class BlogListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blog List
        _buildBlogList(context),
      ],
    );
  }

  // Blog List
  Widget _buildBlogList(BuildContext context) {
    return Column(
      children: blogs.map((blog) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              _buildBlogHeader(context, blog),
              // Content
              _buildBlogContent(blog),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Blog Header
  Widget _buildBlogHeader(BuildContext context, Blog blog) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200] ?? Colors.grey)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(blog.image),
            radius: 20,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLB Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '12 tháng 12 lúc 18:54',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.more_vert, size: 20),
            onPressed: () {
              _showDropdownMenu(context, blog);
            },
          ),
        ],
      ),
    );
  }

  // Blog Content
  Widget _buildBlogContent(Blog blog) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.title,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              blog.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // Show Dropdown Menu
  void _showDropdownMenu(BuildContext context, Blog blog) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, size: 20),
              title: Text('Chỉnh sửa Blog'),
              onTap: () {
                Navigator.pop(context);
                // Handle edit blog
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, size: 20, color: Colors.red),
              title: Text(
                'Xóa Blog',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle delete blog
              },
            ),
          ],
        );
      },
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Modal Header
              _buildModalHeader(),
              // Modal Body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Blog Input
                        _buildBlogInput(),
                        SizedBox(height: 16),
                        // Image Upload
                        _buildImageUpload(),
                        SizedBox(height: 16),
                        // Submit Button
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modal Header
  Widget _buildModalHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tạo Blog',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  // Blog Input
  Widget _buildBlogInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blog',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _blogController,
          decoration: InputDecoration(
            hintText: 'Blog...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  // Image Upload
  Widget _buildImageUpload() {
    return Column(
      children: [
        Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _image != null
              ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
                child: IconButton(
                  icon: Icon(Icons.close, size: 20, color: Colors.grey[600]),
                  onPressed: _removeImage,
                ),
              ),
            ],
          )
              : Center(
            child: TextButton(
              onPressed: _pickImage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 24, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text(
                    'Thêm ảnh',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
    return ElevatedButton(
      onPressed: () {
        // Handle submit
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.infinity, 48),
      ),
      child: Text(
        'Tạo',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
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