// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // ============================================
  // PRIMARY COLORS (Navy + Gold)
  // ============================================
  static const Color primaryNavy = Color(0xFF3B38A0);
  static const Color primaryNavyLight = Color(0xFF5854C7);
  static const Color primaryNavyDark = Color(0xFF2A2873);

  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentGoldLight = Color(0xFFFFE55C);
  static const Color accentGoldDark = Color(0xFFB8960A);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFF34D399);
  static const Color successGreenDark = Color(0xFF059669);

  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedLight = Color(0xFFF87171);
  static const Color errorRedDark = Color(0xFFDC2626);

  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningOrangeLight = Color(0xFFFBBF24);
  static const Color warningOrangeDark = Color(0xFFD97706);

  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color infoBlueLight = Color(0xFF2196F3);
  static const Color infoBlueDark = Color(0xFF2563EB);

  // ============================================
  // CHART COLORS
  // ============================================
  static const Color chartBullish = Color(0xFF10B981);
  static const Color chartBearish = Color(0xFFEF4444);
  static const Color chartNeutral = Color(0xFF6B7280);

  static const List<Color> chartGradient = [
  Color(0xFF3B38A0),
  Color(0xFF5854C7),
  Color(0xFFFFD700),
  ];

  // ============================================
  // LIGHT THEME COLORS
  // ============================================
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);

  // ============================================
  // DARK THEME COLORS
  // ============================================
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);

  static const Color dividerDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);

  // ============================================
  // GLASSMORPHISM
  // ============================================
  static Color glassLight = const Color.fromRGBO(255, 255, 255, 0.7);
  static Color glassDark = Colors.black.withOpacity(0.3);
  static Color glassBlur = Colors.white.withOpacity(0.1);

  // ============================================
  // GRADIENT DEFINITIONS
  // ============================================
  static const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryNavy, primaryNavyLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
  colors: [accentGoldDark, accentGold, accentGoldLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
  colors: [successGreenDark, successGreen, successGreenLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
  colors: [errorRedDark, errorRed, errorRedLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  );

  // ============================================
  // SHADOW COLORS
  // ============================================
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.25);

  static List<BoxShadow> cardShadowLight = [
  BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 10,
  offset: const Offset(0, 4),
  ),
  ];

  static List<BoxShadow> cardShadowDark = [
  BoxShadow(
  color: Colors.black.withOpacity(0.3),
  blurRadius: 15,
  offset: const Offset(0, 8),
  ),
  ];

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get color based on profit/loss
  static Color getProfitLossColor(double value) {
  if (value > 0) return successGreen;
  if (value < 0) return errorRed;
  return chartNeutral;
  }

  /// Get color based on impact level
  static Color getImpactColor(String impact) {
  switch (impact.toLowerCase()) {
  case 'high':
  return errorRed;
  case 'medium':
  return warningOrange;
  case 'low':
  return successGreen;
  default:
  return chartNeutral;
  }
  }

  /// Get gradient based on theme brightness
  static LinearGradient getBackgroundGradient(bool isDark) {
  if (isDark) {
  return LinearGradient(
  colors: [darkBackground, darkSurface],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  );
  } else {
  return LinearGradient(
  colors: [lightBackground, lightSurface],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  );
  }
  }
}