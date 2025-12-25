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
      final now = DateTime.now();
      DateTime startDate;

      // Calculate start date based on timeframe
      // Note: Frankfurter API provides daily reference rates.
      switch (state.timeframe) {
        case '1W':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case '1M':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case '3M':
          startDate = now.subtract(const Duration(days: 90));
          break;
        case '1Y':
          startDate = now.subtract(const Duration(days: 365));
          break;
        case '1D':
        default:
          // For 1D, we might want intraday data which Frankfurter doesn't provide for free.
          // We'll fallback to 1 week of data to show some trend or just last few days.
          startDate = now.subtract(const Duration(days: 7));
          break;
      }

      final rates = await _forexService.fetchHistoricalRates(
        currency: state.symbol,
        startDate: startDate,
        endDate: now,
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