// lib/features/alerts/domain/models/price_alert.dart
class PriceAlert {
  final String id;
  final String symbol;
  final double targetPrice;
  final bool isAbove; // Trigger when price goes above target
  final bool isActive;

  PriceAlert({
    required this.id,
    required this.symbol,
    required this.targetPrice,
    required this.isAbove,
    this.isActive = true,
  });
}