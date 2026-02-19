import 'package:flutter/material.dart';

class GlobalThemeProvider extends ChangeNotifier {
  // Placeholder for theme logic
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void updateTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
