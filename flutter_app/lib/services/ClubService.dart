import 'dart:convert';
import 'package:http/http.dart' as http;

class ClubService {
  // Base URL của API (thay đổi theo domain của bạn)
  static const String baseUrl = 'http://127.0.0.1:8000/api/clubs';

  // Headers mặc định (có thể thêm authentication token nếu cần)
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Lấy danh sách clubs
  Future<List<dynamic>> getClubs() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load clubs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clubs: $e');
    }
  }

  // Tạo club mới
  Future<dynamic> createClub({
    required int userId,
    required int categoryId,
    required String name,
    String? contactEmail,
  }) async {
    try {
      final body = jsonEncode({
        'user_id': userId,
        'category_id': categoryId,
        'name': name,
        if (contactEmail != null) 'contact_email': contactEmail,
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating club: $e');
    }
  }

  // Lấy chi tiết club
  Future<dynamic> getClub(String clubId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$clubId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching club: $e');
    }
  }

  // Cập nhật club
  Future<dynamic> updateClub(String clubId, {
    int? userId,
    int? categoryId,
    String? name,
    String? description,
    String? contactEmail,
    String? contactPhone,
    String? contactAddress,
    String? province,
    String? facebookLink,
    String? zaloLink,
    String? status,
  }) async {
    try {
      final body = jsonEncode({
        if (userId != null) 'user_id': userId,
        if (categoryId != null) 'category_id': categoryId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (contactEmail != null) 'contact_email': contactEmail,
        if (contactPhone != null) 'contact_phone': contactPhone,
        if (contactAddress != null) 'contact_address': contactAddress,
        if (province != null) 'province': province,
        if (facebookLink != null) 'facebook_link': facebookLink,
        if (zaloLink != null) 'zalo_link': zaloLink,
        if (status != null) 'status': status,
      });

      final response = await http.patch(
        Uri.parse('$baseUrl/$clubId'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating club: $e');
    }
  }

  // Xóa club
  Future<void> deleteClub(String clubId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$clubId'),
        headers: headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting club: $e');
    }
  }
}

