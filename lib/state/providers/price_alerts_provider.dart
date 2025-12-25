// lib/state/providers/price_alerts_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/alerts/domain/models/price_alert.dart';

class PriceAlertsNotifier extends StateNotifier<List<PriceAlert>> {
  PriceAlertsNotifier() : super([]);

  void addAlert(String symbol, double targetPrice, bool isAbove) {
    final alert = PriceAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      targetPrice: targetPrice,
      isAbove: isAbove,
    );
    state = [...state, alert];
  }

  void removeAlert(String id) {
    state = state.where((alert) => alert.id != id).toList();
  }

  void toggleAlert(String id) {
    state = state.map((alert) {
      if (alert.id == id) {
        return PriceAlert(
          id: alert.id,
          symbol: alert.symbol,
          targetPrice: alert.targetPrice,
          isAbove: alert.isAbove,
          isActive: !alert.isActive,
        );
      }
      return alert;
    }).toList();
  }
}

final priceAlertsProvider = StateNotifierProvider<PriceAlertsNotifier, List<PriceAlert>>((ref) {
  return PriceAlertsNotifier();
});