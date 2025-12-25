// lib/state/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/settings_service.dart';
import 'settings_provider.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SettingsService _settingsService;

  ThemeNotifier(this._settingsService) : super(_settingsService.getThemeMode());

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settingsService.setThemeMode(mode);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return ThemeNotifier(settingsService);
});