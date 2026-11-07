import 'package:flutter/material.dart';
import '../core/utils/preference_manager.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<void> initAuth() async {
    _currentUser = await PreferenceManager.getUser();
    notifyListeners();
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.register(
        username: username,
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      _currentUser = user;
      await PreferenceManager.saveUser(user);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendOtp(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.sendOtp(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final success = await _authRepository.verifyOtp(email: email, otp: otp);
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await PreferenceManager.clearSession();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}

