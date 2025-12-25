// lib/state/providers/strategy_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/strategy/domain/models/custom_strategy.dart';

class StrategyNotifier extends StateNotifier<List<CustomStrategy>> {
  StrategyNotifier() : super([]);

  void addStrategy(CustomStrategy strategy) {
    state = [...state, strategy];
  }

  void removeStrategy(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

final strategyProvider = StateNotifierProvider<StrategyNotifier, List<CustomStrategy>>((ref) {
  return StrategyNotifier();
});