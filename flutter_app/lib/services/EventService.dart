  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  class EventApiService {
    // Base URL của API
    static const String baseUrl = 'http://127.0.0.1:8000/api/events';

    // Lấy danh sách sự kiện
    static Future<List<dynamic>> getEvents() async {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Parse dữ liệu JSON thành danh sách
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load events');
      }
    }

    // Tạo sự kiện mới
    static Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create event');
      }
    }

    // Lấy chi tiết sự kiện
    static Future<dynamic> getEventById(int id) async {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load event details');
      }
    }

    // Cập nhật sự kiện
    static Future<dynamic> updateEvent(int id, Map<String, dynamic> eventData) async {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update event');
      }
    }

    // Xóa sự kiện
    static Future<void> deleteEvent(int id) async {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete event');
      }
    }
  }