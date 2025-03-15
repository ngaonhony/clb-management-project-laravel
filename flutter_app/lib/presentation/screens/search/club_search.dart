import 'package:flutter/material.dart';
import 'package:nckh/data/repositories/club_repository.dart';
import 'package:nckh/presentation/UI/footer.dart';
import 'package:nckh/presentation/widgets/custom_app_bar.dart';
import 'package:nckh/presentation/widgets/custom_drawer.dart';
import 'package:nckh/routes.dart';

/// IMPORT 2 FILE DƯỚI ĐÂY:
import 'club_card.dart';
import 'club_filter_bottom_sheet.dart';

class ClubSearch extends StatefulWidget {
  @override
  _ClubSearchState createState() => _ClubSearchState();
}

class _ClubSearchState extends State<ClubSearch> {
  final ClubRepository _clubRepository = ClubRepository();

  // Trạng thái bộ lọc
  String _selectedCategory = 'Tất cả';

  // Danh sách CLB từ API
  List<Map<String, dynamic>> _clubs = [];

  // Loading indicator
  bool _isLoading = true;

  // Biến tìm kiếm
  String _searchQuery = '';

  // Controller cho ListView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoading = true);
    try {
      final clubs = await _clubRepository.getClubs();
      setState(() {
        _clubs = clubs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách câu lạc bộ: $e'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Lọc theo danh mục và từ khóa
  List<Map<String, dynamic>> get _filteredClubs {
    return _clubs.where((club) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' || club['category'] == _selectedCategory;
      final matchesSearch = club['title']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          club['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(theme),
            _buildCategoryChips(theme),
            Expanded(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              )
                  : _filteredClubs.isEmpty
                  ? _buildEmptyState(theme)
                  : RefreshIndicator(
                color: theme.primaryColor,
                onRefresh: _loadClubs,
                child: _buildClubList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        backgroundColor: theme.primaryColor,
        elevation: 4,
        child: Icon(Icons.filter_list, color: Colors.white),
        tooltip: 'Lọc câu lạc bộ',
      ),
      bottomNavigationBar: buildFooter(context),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy câu lạc bộ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy thử tìm kiếm với từ khóa khác',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm câu lạc bộ...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: theme.primaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[400]),
            onPressed: () => setState(() => _searchQuery = ''),
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(ThemeData theme) {
    final categories = ['Tất cả', 'Âm nhạc', 'Nghệ thuật', 'Học thuật', 'Thể thao'];

    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) =>
            _buildCategoryChip(categories[index], theme),
      ),
    );
  }

  Widget _buildCategoryChip(String category, ThemeData theme) {
    final isSelected = _selectedCategory == category;

    return Container(
      margin: EdgeInsets.only(right: 12),
      child: Material(
        color: isSelected ? theme.primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
        ),
        elevation: isSelected ? 2 : 0,
        child: InkWell(
          onTap: () => setState(() => _selectedCategory = category),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClubList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _filteredClubs.length,
      itemBuilder: (context, index) {
        // Sử dụng widget ClubCard (file club_card.dart)
        return ClubCard(
          club: _filteredClubs[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.homeManager,
              arguments: _filteredClubs[index]['id'],
            );
          },
        );
      },
    );
  }

  // Mở bottom sheet lọc
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClubFilterBottomSheet(
          selectedCategory: _selectedCategory,
          onCategorySelected: (String category) {
            setState(() => _selectedCategory = category);
          },
        );
      },
    );
  }
}
