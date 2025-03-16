import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/auth';

  // Hàm gọi API đăng ký
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String password_confirmation,
    required String phone,
    String? username,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'password_confirmation' : password_confirmation,
        'phone': phone,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      // Nếu thành công, trả về dữ liệu JSON
      return jsonDecode(response.body);
    } else {
      // Nếu có lỗi, ném ra một exception
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> verify({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/verify-email'); // Endpoint xác thực

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      // Nếu thành công, trả về dữ liệu JSON
      return jsonDecode(response.body);
    } else {
      // Nếu có lỗi, ném ra một exception
      throw Exception('Failed to verify OTP: ${response.statusCode}');
    }
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Đăng nhập và trả về dữ liệu từ server
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      // Decode phản hồi từ server
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Đăng nhập thành công
        return responseData;
      } else {
        // Xử lý lỗi từ server (401, 403, v.v.)
        throw Exception(responseData['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      // Xử lý lỗi mạng hoặc ngoại lệ khác
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Lưu thông tin user và token (giả định dùng SharedPreferences)
  static Future<void> saveUserData(String token, dynamic user) async {
    // TODO: Implement SharedPreferences để lưu token và user data
    // Ví dụ:
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString('user', jsonEncode(user));
    print('Token saved: $token');
    print('User saved: $user');
  }

  // Lấy token đã lưu
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }


  // Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user');
  }


  Future<Map<String, dynamic>> sendResetLink(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgotpass'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': responseData['message'] ?? 'Có lỗi xảy ra',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể kết nối đến server: $e',
        'statusCode': 500,
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        }),
      );

      final responseData = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': responseData['message'] ?? 'Có lỗi xảy ra',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể kết nối đến server: $e',
        'statusCode': 500,
      };
    }
  }
}