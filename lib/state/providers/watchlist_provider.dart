// lib/state/providers/watchlist_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/forex/domain/models/forex_rate.dart';
import '../../features/forex/domain/repositories/forex_repository.dart';
import '../../features/forex/domain/repositories/forex_repository_impl.dart';
import 'forex_provider.dart';
import 'news_provider.dart'; // for networkInfoProvider

final forexRepositoryProvider = Provider<ForexRepository>((ref) {
  return ForexRepositoryImpl(
    forexService: ref.watch(forexServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

class WatchlistState {
  final List<String> symbols;
  final AsyncValue<List<ForexRate>> rates;

  WatchlistState({required this.symbols, required this.rates});

  WatchlistState copyWith({
    List<String>? symbols,
    AsyncValue<List<ForexRate>>? rates,
  }) {
    return WatchlistState(
      symbols: symbols ?? this.symbols,
      rates: rates ?? this.rates,
    );
  }
}

class WatchlistNotifier extends StateNotifier<WatchlistState> {
  final ForexRepository _repository;

  WatchlistNotifier(this._repository)
      : super(WatchlistState(
          symbols: ['EUR/USD', 'GBP/USD', 'USD/JPY', 'AUD/USD', 'USD/CAD'],
          rates: const AsyncValue.loading(),
        )) {
    fetchRates();
  }

  Future<void> fetchRates() async {
    // We don't set loading state here to avoid UI flickering on refresh
    // Instead we just update the data when it arrives
    
    final List<ForexRate> loadedRates = [];

    for (final symbol in state.symbols) {
      final parts = symbol.split('/');
      if (parts.length != 2) continue;

      final result = await _repository.getSpecificRate(
        fromCurrency: parts[0],
        toCurrency: parts[1],
      );

      result.fold(
        (failure) => null, // Skip failed fetches
        (rate) => loadedRates.add(rate),
      );
    }

    state = state.copyWith(rates: AsyncValue.data(loadedRates));
  }

  void addSymbol(String symbol) {
    if (!state.symbols.contains(symbol)) {
      state = state.copyWith(symbols: [...state.symbols, symbol]);
      fetchRates();
    }
  }

  void removeSymbol(String symbol) {
    final newSymbols = state.symbols.where((s) => s != symbol).toList();
    state = state.copyWith(symbols: newSymbols);
    fetchRates(); // Refresh to update the list of rates
  }
}

final watchlistProvider = StateNotifierProvider<WatchlistNotifier, WatchlistState>((ref) {
  final repository = ref.watch(forexRepositoryProvider);
  return WatchlistNotifier(repository);
});