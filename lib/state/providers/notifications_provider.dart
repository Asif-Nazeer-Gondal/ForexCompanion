// lib/state/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/settings_service.dart';
import 'settings_provider.dart';

class NotificationsNotifier extends StateNotifier<bool> {
  final SettingsService _settingsService;

  NotificationsNotifier(this._settingsService) : super(_settingsService.notificationsEnabled);

  Future<void> toggleNotifications(bool enabled) async {
    state = enabled;
    await _settingsService.setNotificationsEnabled(enabled);
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return NotificationsNotifier(settingsService);
});