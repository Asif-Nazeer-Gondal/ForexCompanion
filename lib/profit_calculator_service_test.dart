import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/domain/services/profit_calculator_service.dart';

void main() {
  group('ProfitCalculatorService', () {
    late ProfitCalculatorService service;

    setUp(() {
      service = ProfitCalculatorService();
    });

    test('calculateProfit returns correct profit for Buy EUR/USD (Profit)', () {
      // Buy 1.0 Lot EUR/USD
      // Open: 1.0850, Close: 1.0900
      // Diff: 0.0050
      // Pips: 0.0050 / 0.0001 = 50
      // PipValue: 10.0
      // Profit: 50 * 10 * 1 = 500

      final result = service.calculateProfit(
        pair: 'EUR/USD',
        isBuy: true,
        openPrice: 1.0850,
        closePrice: 1.0900,
        lots: 1.0,
      );

      expect(result.pips, closeTo(50.0, 0.1));
      expect(result.profit, closeTo(500.0, 0.1));
    });

    test('calculateProfit returns correct loss for Buy EUR/USD (Loss)', () {
      // Buy 1.0 Lot EUR/USD
      // Open: 1.0900, Close: 1.0850
      // Diff: -0.0050
      // Pips: -50
      // Profit: -500

      final result = service.calculateProfit(
        pair: 'EUR/USD',
        isBuy: true,
        openPrice: 1.0900,
        closePrice: 1.0850,
        lots: 1.0,
      );

      expect(result.pips, closeTo(-50.0, 0.1));
      expect(result.profit, closeTo(-500.0, 0.1));
    });

    test('calculateProfit returns correct profit for Sell USD/JPY (JPY Pair)', () {
      // Sell 1.0 Lot USD/JPY
      // Open: 110.50, Close: 110.00
      // Diff: 0.50
      // PipSize: 0.01
      // Pips: 0.50 / 0.01 = 50
      // PipValue: 9.09 (from service map)
      // Profit: 50 * 9.09 * 1 = 454.5

      final result = service.calculateProfit(
        pair: 'USD/JPY',
        isBuy: false,
        openPrice: 110.50,
        closePrice: 110.00,
        lots: 1.0,
      );

      expect(result.pips, closeTo(50.0, 0.1));
      expect(result.profit, closeTo(454.5, 0.1));
    });

    test('calculateProfit scales with lots', () {
      // Buy 0.1 Lot EUR/USD (Mini Lot)
      // Open: 1.0000, Close: 1.0010 (10 pips)
      // Profit: 10 * 10 * 0.1 = 10

      final result = service.calculateProfit(
        pair: 'EUR/USD',
        isBuy: true,
        openPrice: 1.0000,
        closePrice: 1.0010,
        lots: 0.1,
      );

      expect(result.pips, closeTo(10.0, 0.1));
      expect(result.profit, closeTo(10.0, 0.1));
    });

    test('availablePairs returns non-empty list', () {
      expect(service.availablePairs, isNotEmpty);
      expect(service.availablePairs, contains('EUR/USD'));
      expect(service.availablePairs, contains('USD/JPY'));
    });
  });
}