// Path: lib/providers/theme_provider.dart

import 'package:flutter/material.dart';
// FIXED: Add the Riverpod import
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider will hold the current theme mode (light or dark)
final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // Default to system theme
});
