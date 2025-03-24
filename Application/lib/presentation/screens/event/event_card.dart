import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Since we don't have the models.dart file yet, define Event class directly here
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
          id: json['category_id'] ??
              (json['category'] != null ? json['category']['id'] ?? 0 : 0),
          name: json['category'] != null
              ? json['category']['name'] ?? 'Không có danh mục'
              : 'Không có danh mục',
          subtext: json['category'] != null
              ? json['category']['description'] ?? ''
              : '',
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
        category: Category(id: 0, name: 'N/A', subtext: '', icon: Icons.error),
        club: Club(name: 'N/A', logoUrl: 'https://via.placeholder.com/50'),
        backgroundImages: [],
        attendees: 0,
      );
    }
  }
}

class Category {
  final int? id;
  final String name;
  final String subtext;
  final IconData icon;

  Category(
      {required this.id,
      required this.name,
      required this.subtext,
      this.icon = Icons.event});
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

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({Key? key, required this.event, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventHeader(context),
            _buildEventDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          if (event.backgroundImages.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                event.backgroundImages[0].imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            child: _buildCategoryChip(),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  DateFormat('MMM yyyy').format(event.startDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.access_time, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(event.startDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.lime[600]!.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        event.category.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(event.club.logoUrl),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.club.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${event.attendees} người tham gia",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (event.description.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
