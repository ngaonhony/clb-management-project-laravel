import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  Future<Response> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    }
  }

  Future<Response> register(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    }
  }
}