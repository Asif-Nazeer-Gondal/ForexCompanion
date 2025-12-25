// lib/state/providers/forex_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forexcompanion/core/network/network_info.dart'; // Assuming this exists

class ForexData {
  final String symbol;
  final double price;
  final DateTime timestamp;

  ForexData({required this.symbol, required this.price, required this.timestamp});
}

class ForexNotifier extends StateNotifier<AsyncValue<List<ForexData>>> {
  final NetworkInfo _networkInfo;

  ForexNotifier(this._networkInfo) : super(const AsyncValue.loading()) {
    _fetchForexData();
  }

  Future<void> _fetchForexData() async {
    state = const AsyncValue.loading();
    try {
      if (await _networkInfo.isConnected) {
        // Simulate fetching data from API
        await Future.delayed(const Duration(seconds: 2));
        final data = [
          ForexData(symbol: 'EURUSD', price: 1.0850, timestamp: DateTime.now()),
          ForexData(symbol: 'GBPUSD', price: 1.2710, timestamp: DateTime.now()),
        ];
        state = AsyncValue.data(data);
      } else {
        state = AsyncValue.error('No internet connection', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Method to simulate real-time updates (e.g., from WebSocket)
  void updateForexData(ForexData newData) {
    if (state.hasValue) {
      final currentData = state.value!;
      final existingIndex = currentData.indexWhere((f) => f.symbol == newData.symbol);
      if (existingIndex != -1) {
        currentData[existingIndex] = newData;
      } else {
        currentData.add(newData);
      }
      state = AsyncValue.data([...currentData]); // Create new list to trigger rebuild
    }
  }
}

final forexProvider = StateNotifierProvider<ForexNotifier, AsyncValue<List<ForexData>>>((ref) {
  final networkInfo = ref.read(networkInfoProvider); // Assuming networkInfoProvider exists
  return ForexNotifier(networkInfo);
});

// Assuming a networkInfoProvider exists in core/network/network_info.dart
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());
