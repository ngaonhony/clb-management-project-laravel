import 'package:flutter/material.dart';
import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer_manager.dart';
import 'create/createInformation.dart'; // Import CreateModal

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  bool isModalOpen = false; // Trạng thái để kiểm soát việc mở/đóng modal

  // Hàm mở modal
  void openModal() {
    setState(() {
      isModalOpen = true;
    });
  }

  // Hàm đóng modal
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
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  // Form Content
                  _buildFormContent(),
                ],
              ),
            ),
          ),
          // Hiển thị CreateModal nếu isModalOpen = true
          if (isModalOpen)
            CreateModal(
              isOpen: isModalOpen,
              onClose: closeModal,
            ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thông Tin CLB',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: openModal, // Gọi hàm mở modal khi nhấn nút
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            'Tạo trang đại diện',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Form Content
  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information
          _buildBasicInformation(),
          SizedBox(height: 24),
          // Description
          _buildDescription(),
          SizedBox(height: 24),
          // Contact Information
          _buildContactInformation(),
          SizedBox(height: 24),
          // Form Actions
          _buildFormActions(),
        ],
      ),
    );
  }

  // Basic Information
  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin cơ bản',
          style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        // Logo and Cover Image
        Row(
          children: [
            Expanded(
              child: _buildImageUpload('Logo Câu Lạc Bộ *', '100x100px'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildImageUpload('Ảnh bìa Câu Lạc Bộ *', '1440x900px'),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Club Name and Field
        _buildTextField('Tên CLB *', 'Chỗ cho thuê phòng đẹp 2'),
        SizedBox(height: 16),
        _buildDropdownField('Lĩnh vực hoạt động *', ['Học thuật, Chuyên môn']),
        SizedBox(height: 16),
        // Founded Date and Member Count
        _buildDateField('Ngày thành lập *'),
        SizedBox(height: 16),
        _buildNumberField('Số lượng thành viên *'),
      ],
    );
  }

  // Image Upload Widget
  Widget _buildImageUpload(String label, String recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload, size: 32, color: Colors.grey[400]),
                SizedBox(height: 8),
                Text(
                  'Tải ảnh lên',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          '* Khuyến khích sử dụng ảnh $recommendation để hiển thị tốt nhất.',
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }

  // Text Field Widget
  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
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

  // Dropdown Field Widget
  Widget _buildDropdownField(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
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

  // Date Field Widget
  Widget _buildDateField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Chọn ngày',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
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

  // Number Field Widget
  Widget _buildNumberField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Nhập số lượng thành viên',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
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

  // Description
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả / Giới thiệu Câu Lạc Bộ',
          style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        _buildTextField('Giới thiệu CLB *', 'Nhập mô tả hoạt động và giới thiệu về CLB'),
      ],
    );
  }

  // Contact Information
  Widget _buildContactInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin liên hệ',
          style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        _buildTextField('Email liên hệ *', 'nguyengiakhanhqqq@gmail.com'),
        SizedBox(height: 16),
        _buildTextField('Hotline *', 'Nhập số Hotline'),
        SizedBox(height: 16),
        _buildTextField('Địa chỉ liên hệ *', 'Nhập địa chỉ cụ thể'),
        SizedBox(height: 16),
        _buildDropdownField('Tỉnh / Thành *', ['Chọn Tỉnh thành']),
        SizedBox(height: 16),
        // Social Media
        Text(
          'Mạng xã hội',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        _buildSocialMediaInput('Facebook', 'https://th.bing.com/th/id/R.83e3cc297106767114f2c060f7f5fcbb?rik=FkFOcs3CThcCJQ&pid=ImgRaw&r=0'),
        SizedBox(height: 16),
        _buildSocialMediaInput('Zalo', 'https://th.bing.com/th/id/OIP.-kImg-7dr-QEfCzb17cbEAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7'),
      ],
    );
  }

  // Social Media Input Widget
  Widget _buildSocialMediaInput(String name, String iconUrl) {
    return Row(
      children: [
        Image.network(iconUrl, width: 32, height: 32),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Nhập link $name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Form Actions
  Widget _buildFormActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // Navigate to dashboard
          },
          child: Text(
            'Về Dashboard',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Save information
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Lưu thông tin',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}