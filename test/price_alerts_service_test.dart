import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/alerts/domain/models/price_alert.dart';
import 'package:forex_companion/features/alerts/domain/services/price_alerts_service.dart';

void main() {
  group('PriceAlertsService', () {
    late PriceAlertsService service;

    setUp(() {
      service = PriceAlertsService();
    });

    test('updateAlert updates an existing alert correctly', () async {
      // Arrange
      final alerts = await service.getAlerts();
      final originalAlert = alerts.firstWhere((a) => a.id == '1');

      final updatedAlert = PriceAlert(
        id: originalAlert.id,
        symbol: originalAlert.symbol,
        targetPrice: 1.1500, // Changed from 1.1000
        condition: AlertCondition.below, // Changed from above
        isActive: false, // Changed from true
      );

      // Act
      await service.updateAlert(updatedAlert);
      final updatedAlerts = await service.getAlerts();
      final resultAlert = updatedAlerts.firstWhere((a) => a.id == '1');

      // Assert
      expect(resultAlert.targetPrice, 1.1500);
      expect(resultAlert.condition, AlertCondition.below);
      expect(resultAlert.isActive, false);
      // Ensure other fields remain if we kept them (symbol)
      expect(resultAlert.symbol, 'EUR/USD');
    });

    test('updateAlert does not modify list if alert id not found', () async {
      // Arrange
      final initialAlerts = await service.getAlerts();
      final initialCount = initialAlerts.length;

      final nonExistentAlert = const PriceAlert(
        id: '999',
        symbol: 'USD/CAD',
        targetPrice: 1.3500,
        condition: AlertCondition.above,
      );

      // Act
      await service.updateAlert(nonExistentAlert);
      final currentAlerts = await service.getAlerts();

      // Assert
      expect(currentAlerts.length, initialCount);
      expect(currentAlerts.any((a) => a.id == '999'), isFalse);
    });
  });
}