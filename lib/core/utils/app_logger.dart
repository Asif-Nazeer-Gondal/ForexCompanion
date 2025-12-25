// lib/core/utils/app_logger.dart
import 'package:logger/logger.dart';
import '../../analytics/analytics_service.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static AnalyticsService? _analytics;

  static void _ensureAnalytics() {
    try {
      _analytics ??= AnalyticsService();
    } catch (_) {
      // AnalyticsService might not be ready or failed to initialize
    }
  }

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace, bool reportRemote = true]) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    if (reportRemote) {
      try {
        _ensureAnalytics();
        _analytics?.reportError(error ?? Exception(message), stackTrace);
      } catch (e) {
        print('Failed to report error to analytics: $e');
      }
    }
  }
}