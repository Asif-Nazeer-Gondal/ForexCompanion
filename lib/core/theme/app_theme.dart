// Path: lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart'; // FIXED: Use a direct relative path

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      // Add other theme properties here
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.black,
      // Add other theme properties here
    );
  }
}
