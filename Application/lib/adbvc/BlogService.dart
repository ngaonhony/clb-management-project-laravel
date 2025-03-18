import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogApi {
  static const String baseUrl = "http://127.0.0.1:8000/api/blogs";

  // Lấy danh sách blog
  static Future<List<dynamic>> fetchBlogs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load blogs");
    }
  }

  // Lấy chi tiết blog
  static Future<Map<String, dynamic>> getBlog(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load blog");
    }
  }

  // Tạo blog mới
  static Future<void> createBlog(Map<String, dynamic> blogData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(blogData),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create blog");
    }
  }

  // Cập nhật blog
  static Future<void> updateBlog(int id, Map<String, dynamic> blogData) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(blogData),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update blog");
    }
  }

  // Xóa blog
  static Future<void> deleteBlog(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete blog");
    }
  }
}
