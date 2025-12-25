// lib/state/notifiers/connection_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionNotifier extends StateNotifier<bool> {
  ConnectionNotifier() : super(true); // Assume connected initially

  void updateConnectionStatus(bool isConnected) {
    state = isConnected;
  }
}

final connectionNotifierProvider = StateNotifierProvider<ConnectionNotifier, bool>((ref) {
  return ConnectionNotifier();
});
