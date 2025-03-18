import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/ApiService.dart';

class BlogApi {
  static const String _resource = '/blogs';
  static String get baseUrl =>
      ApiService.BASE_HOST + ApiService.API_PREFIX + _resource;

  // Lấy danh sách blog
  static Future<List<dynamic>> fetchBlogs() async {
    print('Fetching URL: $baseUrl');
    return await ApiService.getWithCache(baseUrl);
  }

  // Lấy chi tiết blog
  static Future<Map<String, dynamic>> getBlog(int id) async {
    print('Fetching URL: $baseUrl/$id');
    return await ApiService.getWithCache("$baseUrl/$id");
  }

  // Tạo blog mới
  static Future<void> createBlog(Map<String, dynamic> blogData) async {
    await ApiService.post(
      baseUrl,
      body: blogData,
      cacheKeyToInvalidate: baseUrl,
    );
  }

  // Cập nhật blog
  static Future<void> updateBlog(int id, Map<String, dynamic> blogData) async {
    await ApiService.patch(
      "$baseUrl/$id",
      body: blogData,
      cacheKeyToInvalidate: baseUrl,
    );
  }

  // Xóa blog
  static Future<void> deleteBlog(int id) async {
    await ApiService.delete(
      "$baseUrl/$id",
      cacheKeyToInvalidate: baseUrl,
    );
  }
}
