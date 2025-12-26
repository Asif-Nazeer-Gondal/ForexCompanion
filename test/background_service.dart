import 'package:workmanager/workmanager.dart';
import 'package:forex_companion/core/services/notification_service.dart';
import 'package:forex_companion/features/alerts/domain/models/price_alert.dart';
import 'package:forex_companion/features/alerts/domain/services/price_alerts_service.dart';

const String priceCheckTask = "priceCheckTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case priceCheckTask:
        final notificationService = NotificationService();
        await notificationService.initialize();

        final alertsService = PriceAlertsService();
        final alerts = await alertsService.getAlerts();

        // Mock current prices for background check
        // In a real app, fetch these from an API
        final Map<String, double> currentPrices = {
          'EUR/USD': 1.1050,
          'GBP/USD': 1.2450,
          'USD/JPY': 110.50,
        };

        for (final alert in alerts) {
          if (!alert.isActive) continue;

          final currentPrice = currentPrices[alert.symbol];
          if (currentPrice == null) continue;

          bool triggered = false;
          if (alert.condition == AlertCondition.above &&
              currentPrice >= alert.targetPrice) {
            triggered = true;
          } else if (alert.condition == AlertCondition.below &&
              currentPrice <= alert.targetPrice) {
            triggered = true;
          }

          if (triggered) {
            await notificationService.showPriceAlert(
              symbol: alert.symbol,
              price: currentPrice,
              condition:
                  alert.condition == AlertCondition.above ? 'above' : 'below',
            );
          }
        }
        break;
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  void registerPeriodicPriceCheck({Duration frequency = const Duration(minutes: 15)}) {
    Workmanager().registerPeriodicTask(
      "price_check_periodic",
      priceCheckTask,
      frequency: frequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  void cancelAll() {
    Workmanager().cancelAll();
  }
}