enum AlertCondition { above, below }

class PriceAlert {
  final String id;
  final String symbol;
  final double targetPrice;
  final AlertCondition condition;
  final bool isActive;

  const PriceAlert({
    required this.id,
    required this.symbol,
    required this.targetPrice,
    required this.condition,
    this.isActive = true,
  });
}