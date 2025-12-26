class RiskCalculationResult {
  final double riskAmount;
  final double positionSizeUnits;
  final double standardLots;
  final double miniLots;
  final double microLots;

  const RiskCalculationResult({
    required this.riskAmount,
    required this.positionSizeUnits,
    required this.standardLots,
    required this.miniLots,
    required this.microLots,
  });
}

class RiskCalculatorService {
  /// Calculates position size based on risk parameters.
  ///
  /// [accountBalance]: Total account equity.
  /// [riskPercentage]: Percentage of account to risk (e.g., 1.0 for 1%).
  /// [stopLossPips]: Distance to stop loss in pips.
  /// [pipValue]: Value of 1 pip for a standard lot (100,000 units). Defaults to $10 (approx for EUR/USD).
  RiskCalculationResult calculateRisk({
    required double accountBalance,
    required double riskPercentage,
    required double stopLossPips,
    double pipValue = 10.0,
  }) {
    if (stopLossPips <= 0) {
      return const RiskCalculationResult(
          riskAmount: 0, positionSizeUnits: 0, standardLots: 0, miniLots: 0, microLots: 0);
    }

    final riskAmount = accountBalance * (riskPercentage / 100);
    final positionSizeLots = riskAmount / (stopLossPips * pipValue);

    return RiskCalculationResult(
      riskAmount: riskAmount,
      positionSizeUnits: positionSizeLots * 100000,
      standardLots: positionSizeLots,
      miniLots: positionSizeLots * 10,
      microLots: positionSizeLots * 100,
    );
  }
}