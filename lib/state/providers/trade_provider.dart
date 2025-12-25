// lib/state/providers/trade_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/trading/domain/models/trade_order.dart';

class TradeState {
  final bool isLoading;
  final String? error;
  final List<TradeOrder> orders;

  TradeState({this.isLoading = false, this.error, this.orders = const []});
}

class TradeNotifier extends StateNotifier<TradeState> {
  TradeNotifier() : super(TradeState());

  Future<void> executeTrade({
    required String symbol,
    required TradeType type,
    required double amount,
    required double price,
  }) async {
    state = TradeState(isLoading: true, orders: state.orders);
    try {
      // Simulate network delay and processing
      await Future.delayed(const Duration(seconds: 1));

      final order = TradeOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        symbol: symbol,
        type: type,
        amount: amount,
        price: price,
        timestamp: DateTime.now(),
      );

      state = TradeState(
        isLoading: false,
        orders: [...state.orders, order],
      );
    } catch (e) {
      state = TradeState(isLoading: false, error: e.toString(), orders: state.orders);
    }
  }
}

final tradeProvider = StateNotifierProvider<TradeNotifier, TradeState>((ref) {
  return TradeNotifier();
});