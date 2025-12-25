// lib/analytics/sentry_crash_reporter.dart
// This file will contain integration with Sentry for crash reporting.
import 'package:sentry_flutter/sentry_flutter.dart';
import '../core/utils/app_logger.dart';

class SentryCrashReporterService {
  /// Initialize Sentry with the provided DSN
  Future<void> initialize({required String dsn, bool debug = false}) async {
    try {
      await SentryFlutter.init(
        (options) {
          options.dsn = dsn;
          options.debug = debug;
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          options.tracesSampleRate = 1.0;
        },
      );
      AppLogger.info('Sentry initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Sentry', e, null, false);
    }
  }

  /// Report an error to Sentry
  Future<void> reportError(dynamic error, StackTrace? stackTrace) async {
    try {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      AppLogger.error('Reported error to Sentry', error, stackTrace, false);
    } catch (e) {
      AppLogger.error('Failed to report error to Sentry', e, null, false);
    }
  }

  /// Set user context for better error tracking
  Future<void> setUserContext({required String userId, String? email}) async {
    await Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: userId, email: email));
    });
  }
}
