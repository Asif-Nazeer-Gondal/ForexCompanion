// lib/state/notifiers/trading_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradingNotifier extends StateNotifier<String> {
  TradingNotifier() : super('Initial Trading State');

  void updateTradingState(String newState) {
    state = newState;
  }
}

final tradingNotifierProvider = StateNotifierProvider<TradingNotifier, String>((ref) {
  return TradingNotifier();
});
