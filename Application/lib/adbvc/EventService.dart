import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EventApiService {
  // Base URL của API
  static const String baseUrl = 'http://127.0.0.1:8000/api/events';

  // Cache keys
  static const String EVENTS_CACHE_KEY = 'events_cache';
  static const String EVENT_DETAIL_CACHE_PREFIX = 'event_detail_';
  static const String CLUB_EVENTS_CACHE_PREFIX = 'club_events_';

  // Kiểm tra kết nối internet
  static Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Xác thực cache còn hạn dùng hay không (24 giờ)
  static bool _isCacheValid(String timestamp) {
    if (timestamp.isEmpty) return false;

    DateTime cacheTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();

    // Cache có hiệu lực trong 24 giờ
    return now.difference(cacheTime).inHours < 24;
  }

  // Lưu dữ liệu vào cache
  static Future<void> _saveToCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString(key, jsonEncode(cacheData));
  }

  // Lấy dữ liệu từ cache
  static Future<dynamic> _getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(key);

    if (cachedData != null) {
      final decodedData = jsonDecode(cachedData);
      if (_isCacheValid(decodedData['timestamp'])) {
        return decodedData['data'];
      }
    }
    return null;
  }

  // Lấy danh sách sự kiện với cache
  static Future<List<dynamic>> getEvents({bool forceRefresh = false}) async {
    // Kiểm tra cache trước nếu không bắt buộc làm mới
    if (!forceRefresh) {
      final cachedData = await _getFromCache(EVENTS_CACHE_KEY);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      // Nếu không có internet và không có cache, trả về lỗi
      final cachedData = await _getFromCache(EVENTS_CACHE_KEY);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Không có kết nối internet và không có dữ liệu đã lưu');
    }

    // Gọi API
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(EVENTS_CACHE_KEY, data);
        return data;
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi khi gọi API, thử dùng cache
      final cachedData = await _getFromCache(EVENTS_CACHE_KEY);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to load events: $e');
    }
  }

  // Tạo sự kiện mới
  static Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Không có kết nối internet. Không thể tạo sự kiện mới.');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Làm mới cache danh sách sự kiện
      await _clearCache(EVENTS_CACHE_KEY);
      return data;
    } else {
      throw Exception('Failed to create event: ${response.statusCode}');
    }
  }

  // Lấy chi tiết sự kiện với cache
  static Future<dynamic> getEventById(int id,
      {bool forceRefresh = false}) async {
    final cacheKey = EVENT_DETAIL_CACHE_PREFIX + id.toString();

    // Kiểm tra cache trước nếu không bắt buộc làm mới
    if (!forceRefresh) {
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      // Nếu không có internet và không có cache, trả về lỗi
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Không có kết nối internet và không có dữ liệu đã lưu');
    }

    // Gọi API
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(cacheKey, data);
        return data;
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi khi gọi API, thử dùng cache
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to load event details: $e');
    }
  }

  // Lấy danh sách sự kiện theo câu lạc bộ
  static Future<List<dynamic>> getClubEvents(int clubId,
      {bool forceRefresh = false}) async {
    final cacheKey = CLUB_EVENTS_CACHE_PREFIX + clubId.toString();

    // Kiểm tra cache trước nếu không bắt buộc làm mới
    if (!forceRefresh) {
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      // Nếu không có internet và không có cache, trả về lỗi
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Không có kết nối internet và không có dữ liệu đã lưu');
    }

    // Gọi API
    try {
      final response = await http.get(Uri.parse('$baseUrl/club/$clubId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Lưu vào cache
        await _saveToCache(cacheKey, data);
        return data;
      } else if (response.statusCode == 404) {
        // Trường hợp không có sự kiện nào
        await _saveToCache(cacheKey, []);
        return [];
      } else {
        throw Exception('Failed to load club events: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi khi gọi API, thử dùng cache
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to load club events: $e');
    }
  }

  // Cập nhật sự kiện
  static Future<dynamic> updateEvent(
      int id, Map<String, dynamic> eventData) async {
    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Không có kết nối internet. Không thể cập nhật sự kiện.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Làm mới cache
      await _clearCache(EVENT_DETAIL_CACHE_PREFIX + id.toString());
      await _clearCache(EVENTS_CACHE_KEY);
      return data;
    } else {
      throw Exception('Failed to update event: ${response.statusCode}');
    }
  }

  // Xóa sự kiện
  static Future<void> deleteEvent(int id) async {
    // Kiểm tra kết nối internet
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      throw Exception('Không có kết nối internet. Không thể xóa sự kiện.');
    }

    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete event: ${response.statusCode}');
    } else {
      // Làm mới cache
      await _clearCache(EVENT_DETAIL_CACHE_PREFIX + id.toString());
      await _clearCache(EVENTS_CACHE_KEY);
    }
  }

  // Xóa cache
  static Future<void> _clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Xóa tất cả cache liên quan đến sự kiện
  static Future<void> clearAllEventCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key == EVENTS_CACHE_KEY ||
          key.startsWith(EVENT_DETAIL_CACHE_PREFIX) ||
          key.startsWith(CLUB_EVENTS_CACHE_PREFIX)) {
        await prefs.remove(key);
      }
    }
  }
}
