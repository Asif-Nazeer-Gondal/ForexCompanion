// lib/features/forex/domain/models/forex_rate.dart (FIXED)

class ForexRate {
  final String currencyPair; // e.g., "USD/GBP"
  final double rate;
  final DateTime timestamp;

  ForexRate({
    required this.currencyPair,
    required this.rate,
    required this.timestamp,
  });

  // 🌟 FIX: Add getters to safely extract base and target currencies
  String get baseCurrency {
    return currencyPair.split('/').first;
  }

  String get targetCurrency {
    return currencyPair.split('/').last;
  }
}