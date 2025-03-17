import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer_manager.dart';
import 'create/createInformation.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  bool isModalOpen = false;
  final _formKey = GlobalKey<FormState>();

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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      SizedBox(height: 24),
                      _buildFormContent(),
                    ]),
                  ),
                ),
              ],
            ),
            if (isModalOpen)
              CreateModal(
                isOpen: isModalOpen,
                onClose: closeModal,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thông Tin CLB',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ElevatedButton.icon(
          onPressed: openModal,
          icon: Icon(Icons.add, size: 18),
          label: Text('Tạo trang đại diện'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Thông tin cơ bản'),
          SizedBox(height: 16),
          _buildBasicInformation(),
          SizedBox(height: 32),
          _buildSectionTitle('Mô tả / Giới thiệu Câu Lạc Bộ'),
          SizedBox(height: 16),
          _buildDescription(),
          SizedBox(height: 32),
          _buildSectionTitle('Thông tin liên hệ'),
          SizedBox(height: 16),
          _buildContactInformation(),
          SizedBox(height: 32),
          _buildFormActions(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: _buildImageUpload('Logo Câu Lạc Bộ *', '100x100px')),
            SizedBox(width: 16),
            Expanded(
                child: _buildImageUpload('Ảnh bìa Câu Lạc Bộ *', '1440x900px')),
          ],
        ),
        SizedBox(height: 16),
        _buildTextField('Tên CLB *', 'Chỗ cho thuê phòng đẹp 2'),
        SizedBox(height: 16),
        _buildDropdownField('Lĩnh vực hoạt động *', ['Học thuật, Chuyên môn']),
        SizedBox(height: 16),
        _buildDateField('Ngày thành lập *'),
        SizedBox(height: 16),
        _buildNumberField('Số lượng thành viên *'),
      ],
    );
  }

  Widget _buildImageUpload(String label, String recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, size: 32, color: Colors.blue[300]),
                SizedBox(height: 8),
                Text('Tải ảnh lên', style: TextStyle(color: Colors.blue[300])),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          '* Khuyến khích sử dụng ảnh $recommendation để hiển thị tốt nhất.',
          style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Chọn ngày',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          // Handle the picked date
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn $label';
        }
        return null;
      },
    );
  }

  Widget _buildNumberField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Nhập số lượng thành viên',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        if (int.tryParse(value) == null) {
          return 'Vui lòng nhập một số hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildDescription() {
    return _buildTextField(
        'Giới thiệu CLB *', 'Nhập mô tả hoạt động và giới thiệu về CLB');
  }

  Widget _buildContactInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Email liên hệ *', 'nguyengiakhanhqqq@gmail.com'),
        SizedBox(height: 16),
        _buildTextField('Hotline *', 'Nhập số Hotline'),
        SizedBox(height: 16),
        _buildTextField('Địa chỉ liên hệ *', 'Nhập địa chỉ cụ thể'),
        SizedBox(height: 16),
        _buildDropdownField('Tỉnh / Thành *', ['Chọn Tỉnh thành']),
        SizedBox(height: 24),
        Text('Mạng xã hội',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        _buildSocialMediaInput('Facebook',
            'https://th.bing.com/th/id/R.83e3cc297106767114f2c060f7f5fcbb?rik=FkFOcs3CThcCJQ&pid=ImgRaw&r=0'),
        SizedBox(height: 16),
        _buildSocialMediaInput('Zalo',
            'https://th.bing.com/th/id/OIP.-kImg-7dr-QEfCzb17cbEAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7'),
      ],
    );
  }

  Widget _buildSocialMediaInput(String name, String iconUrl) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(iconUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Nhập link $name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            // Navigate to dashboard
          },
          icon: Icon(Icons.arrow_back, size: 18),
          label: Text('Về Dashboard'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Save information
            }
          },
          icon: Icon(Icons.save, size: 18),
          label: Text('Lưu thông tin'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class CreateModal extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  CreateModal({required this.isOpen, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tạo trang đại diện',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your form fields here
              ElevatedButton(
                onPressed: onClose,
                child: Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
