import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../services/ApiService.dart';

class ClubService {
  // Base URL và cache keys
  static const String _resource = '/clubs';
  static String get baseUrl =>
      ApiService.BASE_HOST + ApiService.API_PREFIX + _resource;

  // Keys cho cache
  static const String CLUBS_CACHE_KEY = 'clubs_cache';
  static const String CLUB_DETAIL_PREFIX = 'club_detail_';
  static const String CACHE_TIMESTAMP_PREFIX = 'cache_timestamp_';
  static const int CACHE_DURATION_HOURS = 24;

  // Headers mặc định (có thể thêm authentication token nếu cần)
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Kiểm tra kết nối internet
  Future<bool> _hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Kiểm tra cache có còn hiệu lực
  Future<bool> _isCacheValid(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('$CACHE_TIMESTAMP_PREFIX$key');
    if (timestamp == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheDuration = Duration(hours: CACHE_DURATION_HOURS).inMilliseconds;
    return (now - timestamp) < cacheDuration;
  }

  // Lưu dữ liệu vào cache
  Future<void> _saveToCache(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(data));
      await prefs.setInt(
          '$CACHE_TIMESTAMP_PREFIX$key', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  // Lấy dữ liệu từ cache
  Future<dynamic> _getFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(key);

      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      return null;
    } catch (e) {
      print('Error getting from cache: $e');
      return null;
    }
  }

  // Lấy danh sách clubs với caching
  Future<List<dynamic>> getClubs({
    bool forceRefresh = false,
    Map<String, dynamic>? params,
  }) async {
    // Tạo cache key riêng cho các bộ lọc khác nhau
    String cacheKey = CLUBS_CACHE_KEY;
    if (params != null && params.isNotEmpty) {
      final paramString =
          params.entries.map((e) => '${e.key}=${e.value}').join('_');
      cacheKey = '${CLUBS_CACHE_KEY}_$paramString';
    }

    try {
      return await ApiService.getWithCache(
        baseUrl,
        cacheKey: cacheKey,
        forceRefresh: forceRefresh,
        queryParams: params,
      );
    } catch (e) {
      throw Exception('Error fetching clubs: $e');
    }
  }

  // Lấy chi tiết club với caching
  Future<dynamic> getClub(String clubId, {bool forceRefresh = false}) async {
    final cacheKey = '$CLUB_DETAIL_PREFIX$clubId';

    try {
      return await ApiService.getWithCache(
        '$baseUrl/$clubId',
        cacheKey: cacheKey,
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      throw Exception('Error fetching club: $e');
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
      final body = {
        'user_id': userId,
        'category_id': categoryId,
        'name': name,
        if (contactEmail != null) 'contact_email': contactEmail,
      };

      final response = await ApiService.post(
        baseUrl,
        body: body,
        cacheKeyToInvalidate: CLUBS_CACHE_KEY,
      );

      return response;
    } catch (e) {
      throw Exception('Error creating club: $e');
    }
  }

  // Cập nhật club
  Future<dynamic> updateClub(
    String clubId, {
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
      final body = {
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
      };

      final response = await ApiService.patch(
        '$baseUrl/$clubId',
        body: body,
        cacheKeyToInvalidate: CLUBS_CACHE_KEY,
      );

      // Also invalidate the specific club cache
      await ApiService.clearCache('$CLUB_DETAIL_PREFIX$clubId');

      return response;
    } catch (e) {
      throw Exception('Error updating club: $e');
    }
  }

  // Xóa club
  Future<void> deleteClub(String clubId) async {
    try {
      await ApiService.delete(
        '$baseUrl/$clubId',
        cacheKeyToInvalidate: CLUBS_CACHE_KEY,
      );

      // Also clear specific club cache
      await ApiService.clearCache('$CLUB_DETAIL_PREFIX$clubId');
    } catch (e) {
      throw Exception('Error deleting club: $e');
    }
  }

  // Xóa toàn bộ cache
  Future<void> clearCache() async {
    await ApiService.clearCache(CLUBS_CACHE_KEY);
    await ApiService.clearCache(CLUB_DETAIL_PREFIX);
  }
}
