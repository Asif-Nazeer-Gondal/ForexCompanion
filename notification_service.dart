// lib/core/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/app_logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin
  Future<void> initialize() async {
    try {
      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          AppLogger.info('Notification tapped: ${details.payload}');
          // TODO: Handle navigation based on payload
        },
      );

      // Request permissions for Android 13+
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      AppLogger.info('NotificationService initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize NotificationService', e);
    }
  }

  /// Show a trade alert notification
  Future<void> showTradeAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'trade_alerts_channel',
      'Trade Alerts',
      channelDescription: 'Notifications for trade signals and executions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, // Unique ID based on time
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Show a price alert notification
  Future<void> showPriceAlert({
    required String symbol,
    required double price,
    required String condition,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'price_alerts_channel',
      'Price Alerts',
      channelDescription: 'Notifications when price targets are hit',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      'Price Alert: $symbol',
      '$symbol is now $condition $price',
      platformDetails,
    );
  }
}