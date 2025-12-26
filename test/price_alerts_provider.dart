import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_companion/core/services/notification_service.dart';
import 'package:forex_companion/services/websocket_service.dart';
import '../../domain/models/price_alert.dart';
import '../../domain/services/price_alerts_service.dart';

final priceAlertsServiceProvider = Provider<PriceAlertsService>((ref) {
  return PriceAlertsService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final priceAlertsProvider = StateNotifierProvider<PriceAlertsNotifier, AsyncValue<List<PriceAlert>>>((ref) {
  final service = ref.watch(priceAlertsServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return PriceAlertsNotifier(service, wsService, notificationService);
});

class PriceAlertsNotifier extends StateNotifier<AsyncValue<List<PriceAlert>>> {
  final PriceAlertsService _service;
  final WebSocketService _wsService;
  final NotificationService _notificationService;
  StreamSubscription? _priceSubscription;

  PriceAlertsNotifier(this._service, this._wsService, this._notificationService)
      : super(const AsyncValue.loading()) {
    _loadAlerts();
    _monitorPrices();
  }

  Future<void> _loadAlerts() async {
    try {
      final alerts = await _service.getAlerts();
      state = AsyncValue.data(alerts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _monitorPrices() {
    _priceSubscription = _wsService.stream.listen((data) {
      if (state.value == null) return;

      try {
        // Assuming data is JSON: {"symbol": "EUR/USD", "price": 1.0500}
        final Map<String, dynamic> update = jsonDecode(data as String);
        final String symbol = update['symbol'];
        final double currentPrice = update['price'];

        final alerts = state.value!;
        for (final alert in alerts) {
          if (!alert.isActive || alert.symbol != symbol) continue;

          bool triggered = false;
          if (alert.condition == AlertCondition.above &&
              currentPrice >= alert.targetPrice) {
            triggered = true;
          } else if (alert.condition == AlertCondition.below &&
              currentPrice <= alert.targetPrice) {
            triggered = true;
          }

          if (triggered) {
            _notificationService.showPriceAlert(
              symbol: symbol,
              price: currentPrice,
              condition: alert.condition == AlertCondition.above ? 'above' : 'below',
            );
            // Deactivate alert after trigger to prevent spamming
            toggleAlert(alert.id);
          }
        }
      } catch (e) {
        // Handle parsing error or ignore non-price messages
      }
    });
  }

  Future<void> addAlert(PriceAlert alert) async {
    try {
      await _service.addAlert(alert);
      await _loadAlerts();
    } catch (e) {
      // Handle error appropriately in a real app
    }
  }

  Future<void> deleteAlert(String id) async {
    try {
      await _service.deleteAlert(id);
      await _loadAlerts();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleAlert(String id) async {
    try {
      await _service.toggleAlert(id);
      await _loadAlerts();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateAlert(PriceAlert alert) async {
    try {
      await _service.updateAlert(alert);
      await _loadAlerts();
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _priceSubscription?.cancel();
    super.dispose();
  }
}