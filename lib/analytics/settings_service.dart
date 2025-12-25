// lib/core/services/settings_service.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/app_logger.dart';

class SettingsService {
  static const String _boxName = 'settings';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLocale = 'locale';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyFirstRun = 'is_first_run';

  late Box _box;

  // Singleton instance
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  /// Initialize Hive and open the settings box
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      AppLogger.info('SettingsService initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize SettingsService', e, null, false);
    }
  }

  /// Get the saved ThemeMode
  ThemeMode getThemeMode() {
    final savedMode = _box.get(_keyThemeMode);
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  /// Save ThemeMode
  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
      default:
        value = 'system';
        break;
    }
    await _box.put(_keyThemeMode, value);
    AppLogger.info('Theme mode set to $value');
  }

  /// Get saved Locale
  Locale? getLocale() {
    final languageCode = _box.get(_keyLocale);
    if (languageCode != null && languageCode is String) {
      return Locale(languageCode);
    }
    return null;
  }

  /// Save Locale
  Future<void> setLocale(Locale locale) async {
    await _box.put(_keyLocale, locale.languageCode);
    AppLogger.info('Locale set to ${locale.languageCode}');
  }

  /// Check if notifications are enabled
  bool get notificationsEnabled => _box.get(_keyNotifications, defaultValue: true);

  /// Set notification preference
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _box.put(_keyNotifications, enabled);
    AppLogger.info('Notifications enabled: $enabled');
  }

  /// Check if it's the first run
  bool get isFirstRun => _box.get(_keyFirstRun, defaultValue: true);

  /// Set first run completed
  Future<void> setFirstRunCompleted() async {
    await _box.put(_keyFirstRun, false);
  }
}