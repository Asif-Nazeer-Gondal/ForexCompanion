// lib/analytics/firebase_analytics.dart
// This file will contain integration with Firebase Analytics.
import 'package:firebase_analytics/firebase_analytics.dart';
import '../core/utils/app_logger.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Log a custom event
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      AppLogger.info('Logged Firebase event: $name');
    } catch (e) {
      AppLogger.error('Failed to log Firebase event: $name', e, null, false);
    }
  }

  /// Log a screen view
  Future<void> setCurrentScreen(String screenName, {String? screenClassOverride}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClassOverride ?? 'Flutter',
      );
      AppLogger.info('Set current screen: $screenName');
    } catch (e) {
      AppLogger.error('Failed to set current screen: $screenName', e, null, false);
    }
  }

  /// Set the user ID
  Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
      AppLogger.info('Set user ID: $id');
    } catch (e) {
      AppLogger.error('Failed to set user ID', e, null, false);
    }
  }

  /// Set a user property
  Future<void> setUserProperty({required String name, required String? value}) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      AppLogger.info('Set user property: $name = $value');
    } catch (e) {
      AppLogger.error('Failed to set user property: $name', e, null, false);
    }
  }
}
