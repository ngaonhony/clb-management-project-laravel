import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

class ClubService {
  // Base URL của API (thay đổi theo domain của bạn)
  static const String baseUrl = 'http://127.0.0.1:8000/api/clubs';

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
      // Tạo URI với parameters
      final uri = Uri.parse(baseUrl).replace(
        queryParameters:
        params?.map((key, value) => MapEntry(key, value.toString())),
      );

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(cacheKey, data);
        return data;
      } else {
        throw Exception('Failed to load clubs: ${response.statusCode}');
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
      throw Exception('Error fetching clubs: $e');
    }
  }

  // Lấy chi tiết club với caching
  Future<dynamic> getClub(String clubId, {bool forceRefresh = false}) async {
    final cacheKey = '$CLUB_DETAIL_PREFIX$clubId';

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
        Uri.parse('$baseUrl/$clubId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(cacheKey, data);
        return data;
      } else {
        throw Exception('Failed to load club: ${response.statusCode}');
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
    // Kiểm tra kết nối internet
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Cần kết nối internet để tạo câu lạc bộ mới');
    }

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
        final data = jsonDecode(response.body);
        // Cập nhật cache danh sách clubs
        _refreshClubsCache();
        return data;
      } else {
        throw Exception('Failed to create club: ${response.statusCode}');
      }
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
    // Kiểm tra kết nối internet
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Cần kết nối internet để cập nhật câu lạc bộ');
    }

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
        final data = jsonDecode(response.body);
        // Cập nhật cache
        final cacheKey = '$CLUB_DETAIL_PREFIX$clubId';
        await _saveToCache(cacheKey, data);
        _refreshClubsCache();
        return data;
      } else {
        throw Exception('Failed to update club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating club: $e');
    }
  }

  // Xóa club
  Future<void> deleteClub(String clubId) async {
    // Kiểm tra kết nối internet
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Cần kết nối internet để xóa câu lạc bộ');
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$clubId'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        // Xóa cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('$CLUB_DETAIL_PREFIX$clubId');
        await prefs.remove('$CACHE_TIMESTAMP_PREFIX$CLUB_DETAIL_PREFIX$clubId');

        // Cập nhật cache danh sách clubs
        _refreshClubsCache();
      } else {
        throw Exception('Failed to delete club: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting club: $e');
    }
  }

  // Làm mới cache danh sách clubs
  Future<void> _refreshClubsCache() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToCache(CLUBS_CACHE_KEY, data);
      }
    } catch (e) {
      // Bỏ qua lỗi khi làm mới cache
      print('Error refreshing clubs cache: $e');
    }
  }

  // Xóa toàn bộ cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (var key in keys) {
        if (key.startsWith(CLUB_DETAIL_PREFIX) ||
            key.startsWith(CACHE_TIMESTAMP_PREFIX) ||
            key == CLUBS_CACHE_KEY) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
