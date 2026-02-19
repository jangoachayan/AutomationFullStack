import 'package:flutter/material.dart';
import 'app_colors.dart';

class GlobalThemeProvider extends ChangeNotifier {
  // Default to Manara as requested
  bool _isManara = true;

  ThemeData get themeData {
    return _isManara ? _manaraTheme : _atsTheme;
  }

  String get logoPath => _isManara 
      ? 'assets/branding/manara_logo.svg' 
      : 'assets/branding/ats_logo.svg';

  ThemeData get _manaraTheme => ThemeData(
    primaryColor: AppColors.manaraPrimary,
    scaffoldBackgroundColor: AppColors.manaraBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.manaraPrimary,
      primary: AppColors.manaraPrimary,
      surface: AppColors.manaraSurface,
      background: AppColors.manaraBackground,
    ),
    useMaterial3: true,
  );

  ThemeData get _atsTheme => ThemeData(
    primaryColor: AppColors.atsPrimary,
    useMaterial3: true,
  );
  
  void toggleTheme() {
    _isManara = !_isManara;
    notifyListeners();
  }
}
