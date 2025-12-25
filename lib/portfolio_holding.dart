// lib/features/portfolio/domain/models/portfolio_holding.dart
class PortfolioHolding {
  final String symbol;
  final double amount;
  final double averagePrice;
  final double currentPrice;

  PortfolioHolding({
    required this.symbol,
    required this.amount,
    required this.averagePrice,
    required this.currentPrice,
  });

  double get currentValue => amount * currentPrice;
  double get profitLoss => (currentPrice - averagePrice) * amount;
  double get profitLossPercent => averagePrice == 0 ? 0 : (currentPrice - averagePrice) / averagePrice * 100;
}