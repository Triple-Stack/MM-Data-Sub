import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  static const String _themeKey = 'themeMode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPreferences();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _saveThemeToPreferences(mode);
  }

  void _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeString = prefs.getString(_themeKey) ?? 'system';
    themeMode.value = _themeModeFromString(themeString);
  }

  void _saveThemeToPreferences(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_themeKey, _themeModeToString(mode));
  }

  ThemeMode _themeModeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
