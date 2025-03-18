import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CategoryService {
  // Base URL của API
  static const String baseUrl = 'http://127.0.0.1:8000/api/categories';

  // Keys cho cache
  static const String CATEGORIES_CACHE_KEY = 'categories_cache';
  static const String CATEGORY_DETAIL_PREFIX = 'category_detail_';
  static const String CACHE_TIMESTAMP_PREFIX = 'cache_timestamp_';
  static const int CACHE_DURATION_HOURS = 48; // Thời gian cache hợp lệ (48 giờ)

  // Headers mặc định
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
      print('Error saving categories to cache: $e');
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
      print('Error getting categories from cache: $e');
      return null;
    }
  }

  // Lấy danh sách categories với caching
  Future<List<dynamic>> getCategories({bool forceRefresh = false}) async {
    // Kiểm tra xem có cần làm mới cache
    if (!forceRefresh) {
      // Kiểm tra cache còn hiệu lực không
      final isCacheValid = await _isCacheValid(CATEGORIES_CACHE_KEY);

      if (isCacheValid) {
        final cachedData = await _getFromCache(CATEGORIES_CACHE_KEY);
        if (cachedData != null) {
          return cachedData;
        }
      }
    }

    // Kiểm tra kết nối mạng
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      // Nếu không có internet, sử dụng cache (nếu có), dù hết hạn
      final cachedData = await _getFromCache(CATEGORIES_CACHE_KEY);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception(
          'Không có kết nối internet và không tìm thấy dữ liệu cache');
    }

    // Nếu có internet, thực hiện API call
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(CATEGORIES_CACHE_KEY, data);
        return data;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on SocketException {
      // Nếu mất kết nối trong quá trình gọi API, thử lấy từ cache
      final cachedData = await _getFromCache(CATEGORIES_CACHE_KEY);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception(
          'Không thể kết nối đến máy chủ và không tìm thấy dữ liệu cache');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Lấy chi tiết category theo ID
  Future<dynamic> getCategory(String categoryId,
      {bool forceRefresh = false}) async {
    final cacheKey = '$CATEGORY_DETAIL_PREFIX$categoryId';

    // Kiểm tra xem có cần làm mới cache
    if (!forceRefresh) {
      // Kiểm tra cache còn hiệu lực không
      final isCacheValid = await _isCacheValid(cacheKey);

      if (isCacheValid) {
        final cachedData = await _getFromCache(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
      }
    }

    // Kiểm tra kết nối mạng
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      // Nếu không có internet, sử dụng cache (nếu có), dù hết hạn
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception(
          'Không có kết nối internet và không tìm thấy dữ liệu cache');
    }

    // Nếu có internet, thực hiện API call
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$categoryId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(cacheKey, data);
        return data;
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } on SocketException {
      // Nếu mất kết nối trong quá trình gọi API, thử lấy từ cache
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception(
          'Không thể kết nối đến máy chủ và không tìm thấy dữ liệu cache');
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  // Xóa toàn bộ cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (var key in keys) {
        if (key.startsWith(CATEGORY_DETAIL_PREFIX) ||
            key.startsWith(CACHE_TIMESTAMP_PREFIX) ||
            key == CATEGORIES_CACHE_KEY) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing categories cache: $e');
    }
  }
}
