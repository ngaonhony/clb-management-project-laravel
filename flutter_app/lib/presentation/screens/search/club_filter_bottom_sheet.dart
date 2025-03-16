import 'package:flutter/material.dart';

class ClubFilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const ClubFilterBottomSheet({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<ClubFilterBottomSheet> createState() => _ClubFilterBottomSheetState();
}

class _ClubFilterBottomSheetState extends State<ClubFilterBottomSheet> {
  late String _currentCategory;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo trên cùng
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Tiêu đề & nút Đặt lại
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lọc câu lạc bộ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _currentCategory = 'Tất cả');
                  },
                  child: Text(
                    'Đặt lại',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Danh mục
          Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),

          // Danh sách chip
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Tất cả',
                'Âm nhạc',
                'Nghệ thuật',
                'Học thuật',
                'Thể thao',
                'Công nghệ',
                'Ngoại ngữ',
                'Tình nguyện',
              ].map((category) => _buildFilterChip(category, theme)).toList(),
            ),
          ),

          // Nút Áp dụng
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ElevatedButton(
              onPressed: () {
                widget.onCategorySelected(_currentCategory);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Áp dụng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category, ThemeData theme) {
    final isSelected = _currentCategory == category;

    return Material(
      color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          setState(() => _currentCategory = category);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? theme.primaryColor : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? theme.primaryColor : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
