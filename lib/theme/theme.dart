import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme with ChangeNotifier {
  static bool isDark = false;

  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme(SharedPreferences prefs) {
    isDark = !isDark;
    notifyListeners();
    prefs.setBool('isDark', isDark);
  }
}
