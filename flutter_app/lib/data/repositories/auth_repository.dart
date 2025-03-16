import 'package:dio/dio.dart';
import '../../core/api/api_service.dart';
import '../../core/errors/api_exceptions.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await apiService.login(email, password);
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(message: 'Failed to login: ${e.message}');
    }
  }

  Future<AuthModel> register(String email, String password) async {
    try {
      final response = await apiService.register(email, password);
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(message: 'Failed to register: ${e.message}');
    }
  }
}
