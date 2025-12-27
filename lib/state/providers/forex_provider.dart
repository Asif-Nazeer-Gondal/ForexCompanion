// lib/state/providers/forex_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../features/forex/data/forex_service.dart';
import '../../features/forex/domain/models/forex_rate.dart';

// Provider for ForexService
final forexServiceProvider = Provider<ForexService>((ref) {
  return ForexService(client: http.Client());
});

// State class for the chart
class ForexChartState {
  final String symbol;
  final String timeframe;
  final AsyncValue<List<ForexRate>> rates;

  ForexChartState({
    required this.symbol,
    required this.timeframe,
    required this.rates,
  });

  ForexChartState copyWith({
    String? symbol,
    String? timeframe,
    AsyncValue<List<ForexRate>>? rates,
  }) {
    return ForexChartState(
      symbol: symbol ?? this.symbol,
      timeframe: timeframe ?? this.timeframe,
      rates: rates ?? this.rates,
    );
  }
}

class ForexChartNotifier extends StateNotifier<ForexChartState> {
  final ForexService _forexService;

  ForexChartNotifier(this._forexService)
      : super(ForexChartState(
          symbol: 'EUR/USD',
          timeframe: '1M',
          rates: const AsyncValue.loading(),
        )) {
    fetchData();
  }

  Future<void> fetchData() async {
    state = state.copyWith(rates: const AsyncValue.loading());

    try {
      final rates = await _forexService.getHistoricalRates(
        state.symbol,
        state.timeframe,
      );

      state = state.copyWith(rates: AsyncValue.data(rates));
    } catch (e, st) {
      state = state.copyWith(rates: AsyncValue.error(e, st));
    }
  }

  void setSymbol(String symbol) {
    if (state.symbol == symbol) return;
    state = state.copyWith(symbol: symbol);
    fetchData();
  }

  void setTimeframe(String timeframe) {
    if (state.timeframe == timeframe) return;
    state = state.copyWith(timeframe: timeframe);
    fetchData();
  }

  void refresh() {
    fetchData();
  }
}

final forexChartProvider = StateNotifierProvider<ForexChartNotifier, ForexChartState>((ref) {
  final forexService = ref.watch(forexServiceProvider);
  return ForexChartNotifier(forexService);
});