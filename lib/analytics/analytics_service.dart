// lib/analytics/analytics_service.dart

import 'firebase_analytics.dart';
import 'mixpanel_tracker.dart';
import 'sentry_crash_reporter.dart';

class AnalyticsService {
  final FirebaseAnalyticsService _firebase;
  final MixpanelTrackerService _mixpanel;
  final SentryCrashReporterService _sentry;

  // Singleton instance
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal()
      : _firebase = FirebaseAnalyticsService(),
        _mixpanel = MixpanelTrackerService(),
        _sentry = SentryCrashReporterService();

  /// Initialize all analytics services
  Future<void> initialize({
    required String mixpanelToken,
    required String sentryDsn,
    bool debug = false,
  }) async {
    await Future.wait([
      _mixpanel.initialize(mixpanelToken),
      _sentry.initialize(dsn: sentryDsn, debug: debug),
    ]);
  }

  /// Log a standard event across all platforms
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await _firebase.logEvent(name, parameters: parameters);
    _mixpanel.trackEvent(name, properties: parameters);
  }

  /// Log a screen view
  Future<void> setCurrentScreen(String screenName) async {
    await _firebase.setCurrentScreen(screenName);
    _mixpanel.trackEvent('Screen_View', properties: {'screen_name': screenName});
  }

  /// Identify user across all platforms
  Future<void> setUserId(String userId, {String? email}) async {
    await _firebase.setUserId(userId);
    _mixpanel.identify(userId);
    if (email != null) {
      _mixpanel.setUserProperty('\$email', email);
    }
    await _sentry.setUserContext(userId: userId, email: email);
  }

  /// Set user properties
  Future<void> setUserProperty(String name, dynamic value) async {
    await _firebase.setUserProperty(name: name, value: value?.toString());
    _mixpanel.setUserProperty(name, value);
  }

  /// Report error to crash reporting services
  Future<void> reportError(dynamic error, StackTrace? stackTrace) async {
    await _sentry.reportError(error, stackTrace);
    // Also log as a non-fatal event in analytics
    await logEvent('app_error', parameters: {
      'error': error.toString(),
    });
  }

  /// Reset user data (e.g. on logout)
  Future<void> resetUser() async {
    await _firebase.setUserId(null);
    _mixpanel.reset();
  }
}