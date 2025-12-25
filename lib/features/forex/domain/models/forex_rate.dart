// lib/features/forex/domain/models/forex_rate.dart
class ForexRate {
  final String baseCurrency;
  final String quoteCurrency;
  final double rate;
  final DateTime timestamp;
  final double? change;
  final double? changePercent;

  const ForexRate({
    required this.baseCurrency,
    required this.quoteCurrency,
    required this.rate,
    required this.timestamp,
    this.change,
    this.changePercent,
  });
}