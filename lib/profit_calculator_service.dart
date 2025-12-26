class ProfitCalculationResult {
  final double profit;
  final double pips;

  const ProfitCalculationResult({
    required this.profit,
    required this.pips,
  });
}

class ProfitCalculatorService {
  // Mock pip values for Standard Lot ($100k)
  // In a real app, these would be dynamic based on current exchange rates
  final Map<String, double> _pipValues = {
    'EUR/USD': 10.0,
    'GBP/USD': 10.0,
    'AUD/USD': 10.0,
    'NZD/USD': 10.0,
    'USD/JPY': 9.09,
    'USD/CAD': 7.40,
    'USD/CHF': 10.86,
    'EUR/GBP': 12.80,
  };

  List<String> get availablePairs => _pipValues.keys.toList();

  ProfitCalculationResult calculateProfit({
    required String pair,
    required bool isBuy,
    required double openPrice,
    required double closePrice,
    required double lots,
  }) {
    double priceDiff = isBuy ? (closePrice - openPrice) : (openPrice - closePrice);

    // Determine pip multiplier (0.01 for JPY pairs, 0.0001 for others)
    double pipSize = pair.contains('JPY') ? 0.01 : 0.0001;

    double pips = priceDiff / pipSize;

    // Profit = Pips * PipValue * Lots
    double pipValue = _pipValues[pair] ?? 10.0;
    double profit = pips * pipValue * lots;

    return ProfitCalculationResult(profit: profit, pips: pips);
  }
}