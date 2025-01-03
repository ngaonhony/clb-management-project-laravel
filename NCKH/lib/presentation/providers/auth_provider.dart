import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/auth_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  AuthModel? _authModel;
  bool _isAuthenticated = false;

  AuthProvider(this.authRepository);

  bool get isAuthenticated => _isAuthenticated;
  AuthModel? get authModel => _authModel;

  Future<void> login(String email, String password) async {
    try {
      _authModel = await authRepository.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      _authModel = await authRepository.register(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }
  void logout() {
    _authModel = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}