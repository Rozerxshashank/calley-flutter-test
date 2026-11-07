import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/preference_manager.dart';

class AppStateProvider extends ChangeNotifier {
  String _selectedLanguage = 'en';
  bool _isLanguageSet = false;
  int _bottomNavIndex = 0;

  String get selectedLanguage => _selectedLanguage;
  bool get isLanguageSet => _isLanguageSet;
  int get bottomNavIndex => _bottomNavIndex;

  LanguageOption get currentLanguageOption {
    return kAppLanguages.firstWhere(
      (lang) => lang.id == _selectedLanguage,
      orElse: () => kAppLanguages.first,
    );
  }

  Future<void> init() async {
    _isLanguageSet = await PreferenceManager.isLanguageChosen();
    _selectedLanguage = await PreferenceManager.getSelectedLanguage();
    AppStrings.setLanguage(_selectedLanguage);
    notifyListeners();
  }

  Future<void> setLanguage(String langId) async {
    _selectedLanguage = langId;
    _isLanguageSet = true;
    AppStrings.setLanguage(langId);
    await PreferenceManager.setSelectedLanguage(langId);
    notifyListeners();
  }

  void setBottomNavIndex(int index) {
    _bottomNavIndex = index;
    notifyListeners();
  }
}

