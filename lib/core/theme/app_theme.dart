import 'package:flutter/material.dart';

final primaryColor = const Color(0xFF00796B);
final secondaryColor = const Color(0xFFFFC107);

// Color Scheme Definitions (Removed deprecated background/onBackground)
final lightColorScheme = ColorScheme.light(
  primary: primaryColor,
  onPrimary: Colors.white,
  secondary: secondaryColor,
  onSecondary: Colors.black,
  error: const Color(0xFFB00020),
  onError: Colors.white,
  surface: Colors.white, // Replaces background
  onSurface: Colors.black, // Replaces onBackground
  // Note: background and onBackground fields are now omitted/set to surface/onSurface internally
);

final darkColorScheme = ColorScheme.dark(
  primary: const Color(0xFF80CBC4),
  onPrimary: Colors.black,
  secondary: const Color(0xFFFFE082),
  onSecondary: Colors.black,
  error: const Color(0xFFCF6679),
  onError: Colors.black,
  surface: const Color(0xFF1E1E1E), // Replaces background
  onSurface: Colors.white70,        // Replaces onBackground
  // Note: background and onBackground fields are now omitted/set to surface/onSurface internally
);

// Helper function to create CardThemeData safely (resolves the runtime type error)
CardThemeData _buildCardThemeData(ColorScheme colorScheme) {
  // We use the CardThemeData constructor which is the exact type the ThemeData parameter expects,
  // resolving the type cast failure.
  return CardThemeData(
    color: colorScheme.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: 1,
      ),
      // FIX: Use the helper function that returns CardThemeData
      cardTheme: _buildCardThemeData(lightColorScheme),

      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 1,
      ),
      // FIX: Use the helper function that returns CardThemeData
      cardTheme: _buildCardThemeData(darkColorScheme),

      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}