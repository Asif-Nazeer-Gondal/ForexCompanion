import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/domain/services/risk_calculator_service.dart';

void main() {
  group('RiskCalculatorService', () {
    late RiskCalculatorService service;

    setUp(() {
      service = RiskCalculatorService();
    });

    test('calculateRisk returns correct values for standard input', () {
      // Scenario:
      // Account Balance: $10,000
      // Risk: 1% ($100)
      // Stop Loss: 50 pips
      // Pip Value: $10 (default for Standard Lot EUR/USD)
      //
      // Calculation:
      // Risk Amount = 10000 * 0.01 = 100
      // Position Size (Lots) = 100 / (50 * 10) = 100 / 500 = 0.2

      final result = service.calculateRisk(
        accountBalance: 10000,
        riskPercentage: 1.0,
        stopLossPips: 50,
      );

      expect(result.riskAmount, 100.0);
      expect(result.standardLots, 0.2);
      expect(result.miniLots, 2.0); // 0.2 * 10
      expect(result.microLots, 20.0); // 0.2 * 100
      expect(result.positionSizeUnits, 20000.0); // 0.2 * 100,000
    });

    test('calculateRisk handles custom pip value correctly', () {
      // Scenario with different pip value (e.g., JPY pair or different lot size)
      final result = service.calculateRisk(
        accountBalance: 5000,
        riskPercentage: 2.0, // $100 risk
        stopLossPips: 20,
        pipValue: 5.0,
      );

      // Position Size = 100 / (20 * 5) = 100 / 100 = 1.0 lot
      expect(result.riskAmount, 100.0);
      expect(result.standardLots, 1.0);
    });

    test('calculateRisk returns zeros when stop loss is zero or negative', () {
      final result = service.calculateRisk(
        accountBalance: 10000,
        riskPercentage: 1.0,
        stopLossPips: 0,
      );

      expect(result.riskAmount, 0.0);
      expect(result.standardLots, 0.0);
      expect(result.positionSizeUnits, 0.0);
    });

    test('calculateRisk handles zero balance', () {
      final result = service.calculateRisk(
        accountBalance: 0,
        riskPercentage: 1.0,
        stopLossPips: 50,
      );

      expect(result.riskAmount, 0.0);
      expect(result.standardLots, 0.0);
    });
  });
}