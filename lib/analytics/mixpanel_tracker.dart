// lib/analytics/mixpanel_tracker.dart
// This file will contain integration with Mixpanel for analytics.
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import '../core/utils/app_logger.dart';

class MixpanelTrackerService {
  Mixpanel? _mixpanel;

  /// Initialize Mixpanel with the project token
  Future<void> initialize(String token, {bool trackAutomaticEvents = true}) async {
    try {
      _mixpanel = await Mixpanel.init(token, trackAutomaticEvents: trackAutomaticEvents);
      AppLogger.info('Mixpanel initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Mixpanel', e, null, false);
    }
  }

  /// Track an event
  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    if (_mixpanel == null) {
      AppLogger.warning('Mixpanel not initialized. Cannot track event: $eventName');
      return;
    }
    try {
      _mixpanel!.track(eventName, properties: properties);
      AppLogger.info('Tracked Mixpanel event: $eventName');
    } catch (e) {
      AppLogger.error('Failed to track Mixpanel event: $eventName', e, null, false);
    }
  }

  /// Identify a user
  void identify(String userId) {
    if (_mixpanel == null) return;
    try {
      _mixpanel!.identify(userId);
      AppLogger.info('Identified Mixpanel user: $userId');
    } catch (e) {
      AppLogger.error('Failed to identify Mixpanel user', e, null, false);
    }
  }

  /// Set a user property
  void setUserProperty(String propertyName, dynamic value) {
    if (_mixpanel == null) return;
    try {
      _mixpanel!.getPeople().set(propertyName, value);
      AppLogger.info('Set Mixpanel user property: $propertyName = $value');
    } catch (e) {
      AppLogger.error('Failed to set Mixpanel user property', e, null, false);
    }
  }

  /// Reset the user (e.g., on logout)
  void reset() {
    if (_mixpanel == null) return;
    try {
      _mixpanel!.reset();
      AppLogger.info('Reset Mixpanel user');
    } catch (e) {
      AppLogger.error('Failed to reset Mixpanel user', e, null, false);
    }
  }
}
