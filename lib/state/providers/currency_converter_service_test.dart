import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/domain/services/currency_converter_service.dart';

void main() {
  group('CurrencyConverterService', () {
    late CurrencyConverterService service;

    setUp(() {
      service = CurrencyConverterService();
    });

    test('convert returns correct value for USD to EUR', () {
      // 100 USD -> EUR (Rate 0.85)
      // 100 / 1.0 * 0.85 = 85.0
      final result = service.convert(100, 'USD', 'EUR');
      expect(result, closeTo(85.0, 0.001));
    });

    test('convert returns correct value for GBP to EUR', () {
      // 1 GBP (Rate 0.73) -> EUR (Rate 0.85)
      // 1 / 0.73 * 0.85 = 1.16438...
      final result = service.convert(1, 'GBP', 'EUR');
      expect(result, closeTo(1.164, 0.001));
    });

    test('availableCurrencies returns list of supported currencies', () {
      expect(service.availableCurrencies, containsAll(['USD', 'EUR', 'GBP', 'JPY']));
      expect(service.availableCurrencies.length, greaterThan(0));
    });
  });
}