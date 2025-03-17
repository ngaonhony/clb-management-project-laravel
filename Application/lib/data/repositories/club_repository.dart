import 'dart:convert';
import '../../services/ClubService.dart';

class ClubRepository {
  final ClubService _clubService = ClubService();

  // Lấy danh sách câu lạc bộ
  Future<List<Map<String, dynamic>>> getClubs({
    int page = 1,
    int limit = 10,
    String? categoryId, // Add support for category ID filtering
  }) async {
    try {
      // Gọi service để lấy dữ liệu từ API hoặc cache
      final Map<String, dynamic> params = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // Add category filter if provided
      if (categoryId != null) {
        params['category_id'] = categoryId;
      }

      final clubs = await _clubService.getClubs(params: params);

      // Nếu không có dữ liệu, trả về mảng rỗng
      if (clubs == null || clubs.isEmpty) {
        return [];
      }

      // Chuyển đổi dữ liệu thành định dạng phù hợp cho UI
      return clubs.map<Map<String, dynamic>>((club) {
        // Xác định tên danh mục dựa trên kiểu dữ liệu trả về
        String categoryName = 'Không xác định';
        if (club['category'] != null) {
          if (club['category'] is Map) {
            categoryName = club['category']['name'] ?? 'Không xác định';
          } else if (club['category'] is String) {
            categoryName = club['category'];
          }
        }

        // Tính toán số lượng sự kiện
        var eventsCount = 0;
        if (club['events'] != null) {
          if (club['events'] is List) {
            eventsCount = club['events'].length;
          } else if (club['events'] is int) {
            eventsCount = club['events'];
          } else if (club['events_count'] != null &&
              club['events_count'] is int) {
            eventsCount = club['events_count'];
          }
        }

        // Ensure the member count is handled consistently
        var memberCount = '0';
        if (club['members_count'] != null) {
          memberCount = club['members_count'].toString();
        } else if (club['member_count'] != null) {
          memberCount = club['member_count'].toString();
        } else if (club['members'] != null) {
          memberCount = club['members'].toString();
        }

        return {
          'id': club['id'],
          'name': club['name'] ?? 'Không có tên',
          'title': club['name'] ?? 'Không có tên',
          'description': club['description'] ?? 'Không có mô tả',
          'logo': club['logo'] ?? 'assets/images/club_placeholder.png',
          'imageUrl': club['logo'] ?? 'assets/images/club_placeholder.png',
          'category': categoryName,
          'members_count': memberCount,
          'members': memberCount,
          'member_count': memberCount,
          'location':
              club['province'] ?? club['contact_address'] ?? 'Chưa cập nhật',
          'events_count': eventsCount.toString(),
          'is_featured': club['is_featured'] ?? false,
        };
      }).toList();
    } catch (e) {
      print('Lỗi trong getClubs: $e');
      throw Exception('Không thể lấy danh sách câu lạc bộ: $e');
    }
  }

  // Hàm hỗ trợ để lấy URL hình ảnh từ dữ liệu trả về
  String _getImageUrl(dynamic club) {
    if (club['backgroundImages'] != null &&
        club['backgroundImages'].isNotEmpty) {
      for (var image in club['backgroundImages']) {
        if (image['is_logo'] == 1) {
          return image['image_url'] ?? '';
        }
      }
      // Nếu không tìm thấy logo, trả về ảnh đầu tiên
      return club['backgroundImages'][0]['image_url'] ?? '';
    }
    return 'assets/images/default.png';
  }

  Future<Map<String, dynamic>?> getClubById(String clubId) async {
    try {
      final club = await _clubService.getClub(clubId);
      if (club == null) return null;

      // Xử lý trường hợp category là một đối tượng
      String categoryName = 'Chưa phân loại';
      if (club['category'] != null) {
        if (club['category'] is Map) {
          categoryName =
              club['category']['name']?.toString() ?? 'Chưa phân loại';
        } else {
          categoryName = club['category'].toString();
        }
      }

      // Tính toán số sự kiện một cách an toàn
      String eventsCount = '0';
      if (club['events'] != null) {
        if (club['events'] is List) {
          eventsCount = (club['events'] as List).length.toString();
        } else if (club['events'] is int) {
          eventsCount = club['events'].toString();
        }
      }

      // Trả về dữ liệu đã được biến đổi
      return {
        'id': club['id']?.toString() ?? '0',
        'title': club['name']?.toString() ?? 'No Title',
        'description': club['description']?.toString() ?? 'No Description',
        'category': categoryName,
        'location': club['province']?.toString() ??
            club['contact_address']?.toString() ??
            'Unknown Location',
        'members': club['member_count']?.toString() ?? '0',
        'events': club['events'] ?? [],
        'events_count': eventsCount,
        'imageUrl': _getImageUrl(club),
      };
    } catch (e) {
      print('Lỗi chi tiết khi lấy thông tin CLB: $e');
      throw Exception('Failed to get club details: $e');
    }
  }

  Future<Map<String, dynamic>> createClub({
    required int userId,
    required int categoryId,
    required String name,
    String? contactEmail,
  }) async {
    try {
      final newClub = await _clubService.createClub(
        userId: userId,
        categoryId: categoryId,
        name: name,
        contactEmail: contactEmail,
      );
      return {
        'id': newClub['id']?.toString() ?? '0',
        'title': newClub['name']?.toString() ?? 'No Title',
        'description': newClub['description']?.toString() ?? 'No Description',
        'location': newClub['province']?.toString() ?? 'Unknown Location',
        'members': newClub['members']?.toString() ?? '0',
        'imageUrl': newClub['backgroundImages'] != null &&
                newClub['backgroundImages'].isNotEmpty
            ? newClub['backgroundImages'][0]['url']?.toString() ??
                'assets/images/default.png'
            : 'assets/images/default.png',
      };
    } catch (e) {
      throw Exception('Failed to create club: $e');
    }
  }

  Future<Map<String, dynamic>> updateClub(
    String clubId, {
    int? userId,
    int? categoryId,
    String? name,
    String? description,
    String? contactEmail,
  }) async {
    try {
      final updatedClub = await _clubService.updateClub(
        clubId,
        userId: userId,
        categoryId: categoryId,
        name: name,
        description: description,
        contactEmail: contactEmail,
      );
      return {
        'id': updatedClub['id']?.toString() ?? '0',
        'title': updatedClub['name']?.toString() ?? 'No Title',
        'description':
            updatedClub['description']?.toString() ?? 'No Description',
        'location': updatedClub['province']?.toString() ?? 'Unknown Location',
        'members': updatedClub['members']?.toString() ?? '0',
        'imageUrl': updatedClub['backgroundImages'] != null &&
                updatedClub['backgroundImages'].isNotEmpty
            ? updatedClub['backgroundImages'][0]['url']?.toString() ??
                'assets/images/default.png'
            : 'assets/images/default.png',
      };
    } catch (e) {
      throw Exception('Failed to update club: $e');
    }
  }

  Future<void> deleteClub(String clubId) async {
    try {
      await _clubService.deleteClub(clubId);
    } catch (e) {
      throw Exception('Failed to delete club: $e');
    }
  }
}
