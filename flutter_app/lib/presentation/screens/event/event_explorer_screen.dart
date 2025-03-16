import 'package:flutter/material.dart';
import '../../UI/footer.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../../services/EventService.dart'; // Import service
import 'event_list.dart';
import 'package:intl/intl.dart';

class EventExplorerScreen extends StatefulWidget {
  @override
  _EventExplorerScreenState createState() => _EventExplorerScreenState();
}

class _EventExplorerScreenState extends State<EventExplorerScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<Event> events = [];
  String selectedCategory = "Tất cả";
  final TextEditingController searchController = TextEditingController();

  List<Category> categories = [
    Category(name: "Tất cả", subtext: "Sự kiện", icon: Icons.explore),
    Category(name: "Workshop", subtext: "Học tập", icon: Icons.book),
    Category(name: "Âm nhạc", subtext: "Tiết tấu", icon: Icons.music_note),
    Category(name: "Ẩm thực", subtext: "Trải nghiệm", icon: Icons.restaurant),
    Category(name: "Thể thao", subtext: "Sức khỏe", icon: Icons.favorite),
    Category(name: "Sở thích", subtext: "Giải trí", icon: Icons.games),
    Category(name: "Hoạt động", subtext: "Cộng đồng", icon: Icons.people),
    Category(name: "Văn hóa", subtext: "Lễ hội", icon: Icons.calendar_today),
    Category(name: "Nghề nghiệp", subtext: "Định hướng", icon: Icons.work),
  ];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final data = await EventApiService.getEvents();
      setState(() {
        events = data.map((event) => Event.fromJson(event)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print('Error fetching events: $e');
    }
  }

  List<Event> get filteredEvents {
    if (selectedCategory == "Tất cả") {
      return events;
    }
    return events
        .where((event) => event.category.name == selectedCategory)
        .toList();
  }

  void refreshData() {
    fetchEvents();
  }

  void goToEventDetail(int id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đang mở chi tiết sự kiện #$id"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: buildFooter(context),
      body: RefreshIndicator(
        onRefresh: fetchEvents,
        color: Colors.lime[600],
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeroSection()),
            SliverToBoxAdapter(child: _buildSearchSection()),
            SliverToBoxAdapter(child: _buildCategorySection()),
            EventList(
              isLoading: isLoading,
              hasError: hasError,
              filteredEvents: filteredEvents,
              onRefresh: refreshData,
              onEventTap: goToEventDetail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Khám phá sự kiện hấp dẫn",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900]),
          ),
          SizedBox(height: 8),
          Text(
            "${events.length} sự kiện đang chờ bạn khám phá",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Tìm kiếm sự kiện...",
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            "Danh mục",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) =>
                _buildCategoryItem(categories[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Category category) {
    final bool isSelected = selectedCategory == category.name;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category.name),
      child: Container(
        width: 72,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? Colors.lime[500] : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.lime[600]! : Colors.lime[200]!,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Colors.lime[200]!,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ]
                    : null,
              ),
              child: Icon(
                category.icon,
                color: isSelected ? Colors.white : Colors.lime[500],
                size: 22,
              ),
            ),
            SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.lime[700] : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Lớp Event
class Event {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final Category category;
  final Club club;
  final List<BackgroundImage> backgroundImages;
  final int attendees;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.club,
    required this.backgroundImages,
    required this.attendees,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      DateTime parseDate(String? dateStr) {
        if (dateStr == null) return DateTime.now();
        try {
          return DateTime.parse(dateStr); // Thử parse ISO 8601
        } catch (e) {
          return DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(dateStr); // Laravel format
        }
      }

      return Event(
        id: json['id'] ?? 0,
        name: json['name'] ?? 'Không có tên',
        description: json['content'] ?? 'Không có mô tả',
        startDate: parseDate(json['start_date']),
        endDate: parseDate(json['end_date']),
        location: json['location'] ?? 'Không có địa điểm',
        category: Category(
          name: json['category'] != null
              ? json['category']['name'] ?? 'Không có danh mục'
              : 'Không có danh mục',
          subtext:
              json['category'] != null ? json['category']['subtext'] ?? '' : '',
          icon: Icons.event,
        ),
        club: Club(
          name: json['club'] != null
              ? json['club']['name'] ?? 'Không có CLB'
              : 'Không có CLB',
          logoUrl: json['club'] != null
              ? json['club']['logo_url'] ?? 'https://via.placeholder.com/50'
              : 'https://via.placeholder.com/50',
        ),
        backgroundImages: json['background_images'] != null
            ? (json['background_images'] as List)
                .map((image) =>
                    BackgroundImage(imageUrl: image['image_url'] ?? ''))
                .toList()
            : [],
        attendees: json['registered_participants'] ?? 0,
      );
    } catch (e) {
      print('Error parsing JSON: $e, JSON: $json');
      return Event(
        id: 0,
        name: 'Lỗi dữ liệu',
        description: 'Không thể phân tích',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        location: 'N/A',
        category: Category(name: 'N/A', subtext: '', icon: Icons.error),
        club: Club(name: 'N/A', logoUrl: 'https://via.placeholder.com/50'),
        backgroundImages: [],
        attendees: 0,
      );
    }
  }
}

class Category {
  final String name;
  final String subtext;
  final IconData icon;

  Category({required this.name, required this.subtext, required this.icon});
}

class Club {
  final String name;
  final String logoUrl;

  Club({required this.name, required this.logoUrl});
}

class BackgroundImage {
  final String imageUrl;

  BackgroundImage({required this.imageUrl});
}
