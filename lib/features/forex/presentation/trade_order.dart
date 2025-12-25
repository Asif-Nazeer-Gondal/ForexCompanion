// lib/features/trading/domain/models/trade_order.dart
enum TradeType { buy, sell }

class TradeOrder {
  final String id;
  final String symbol;
  final TradeType type;
  final double amount;
  final double price;
  final DateTime timestamp;

  TradeOrder({
    required this.id,
    required this.symbol,
    required this.type,
    required this.amount,
    required this.price,
    required this.timestamp,
  });
}