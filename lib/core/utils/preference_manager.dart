import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class PreferenceManager {
  static const String _keySelectedLanguage = 'selected_language';
  static const String _keyUser = 'cached_user';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyActiveListId = 'active_list_id';
  static const String _keyLanguageChosen = 'language_chosen';

  static Future<void> setSelectedLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedLanguage, lang);
    await prefs.setBool(_keyLanguageChosen, true);
  }

  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedLanguage) ?? 'en';
  }

  static Future<bool> isLanguageChosen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLanguageChosen) ?? false;
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_keyUser);
    if (userStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userStr));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setActiveListId(String listId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveListId, listId);
  }

  static Future<String?> getActiveListId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveListId);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyActiveListId);
  }
}

