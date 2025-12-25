// lib/state/providers/portfolio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PortfolioData {
  final double currentValue;
  final double totalProfitLoss;
  final Map<String, double> assetAllocation;

  PortfolioData({
    required this.currentValue,
    required this.totalProfitLoss,
    required this.assetAllocation,
  });
}

class PortfolioNotifier extends StateNotifier<AsyncValue<PortfolioData>> {
  PortfolioNotifier() : super(const AsyncValue.loading()) {
    _fetchPortfolioData();
  }

  Future<void> _fetchPortfolioData() async {
    state = const AsyncValue.loading();
    try {
      // Simulate fetching data from backend
      await Future.delayed(const Duration(seconds: 1));
      final data = PortfolioData(
        currentValue: 100000.00,
        totalProfitLoss: 1500.00,
        assetAllocation: {'EURUSD': 0.6, 'GBPUSD': 0.4},
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updatePortfolio(PortfolioData newData) {
    state = AsyncValue.data(newData);
  }
}

final portfolioProvider = StateNotifierProvider<PortfolioNotifier, AsyncValue<PortfolioData>>((ref) {
  return PortfolioNotifier();
});

