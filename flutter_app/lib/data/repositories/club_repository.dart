

import 'package:nckh/services/ClubService.dart';

class ClubRepository {
  final ClubService _clubService = ClubService();

  Future<List<Map<String, dynamic>>> getClubs() async {
    try {
      final clubs = await _clubService.getClubs();
      return clubs.map((club) {
        return {
          'id': club['id']?.toString() ?? '0',
          'title': club['name']?.toString() ?? 'No Title', // Map 'name' từ API thành 'title'
          'description': club['description']?.toString() ?? 'No Description',
          'location': club['province']?.toString() ?? 'Unknown Location', // Map 'province' thành 'location'
          'members': club['members']?.toString() ?? '0', // API không có 'members', đặt mặc định là 0
          'imageUrl': club['backgroundImages'] != null && club['backgroundImages'].isNotEmpty
              ? club['backgroundImages'][0]['url']?.toString() ?? 'assets/images/default.png'
              : 'assets/images/default.png', // Lấy URL từ backgroundImages nếu có
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get clubs: $e');
    }
  }

  Future<Map<String, dynamic>?> getClubById(String clubId) async {
    try {
      final club = await _clubService.getClub(clubId);
      if (club == null) return null;
      return {
        'id': club['id']?.toString() ?? '0',
        'title': club['name']?.toString() ?? 'No Title',
        'description': club['description']?.toString() ?? 'No Description',
        'location': club['province']?.toString() ?? 'Unknown Location',
        'members': club['members']?.toString() ?? '0',
        'imageUrl': club['backgroundImages'] != null && club['backgroundImages'].isNotEmpty
            ? club['backgroundImages'][0]['url']?.toString() ?? 'assets/images/default.png'
            : 'assets/images/default.png',
      };
    } catch (e) {
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
        'imageUrl': newClub['backgroundImages'] != null && newClub['backgroundImages'].isNotEmpty
            ? newClub['backgroundImages'][0]['url']?.toString() ?? 'assets/images/default.png'
            : 'assets/images/default.png',
      };
    } catch (e) {
      throw Exception('Failed to create club: $e');
    }
  }

  Future<Map<String, dynamic>> updateClub(String clubId, {
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
        'description': updatedClub['description']?.toString() ?? 'No Description',
        'location': updatedClub['province']?.toString() ?? 'Unknown Location',
        'members': updatedClub['members']?.toString() ?? '0',
        'imageUrl': updatedClub['backgroundImages'] != null && updatedClub['backgroundImages'].isNotEmpty
            ? updatedClub['backgroundImages'][0]['url']?.toString() ?? 'assets/images/default.png'
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