import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/core/services/notification_service.dart';
import 'package:forex_companion/features/alerts/domain/models/price_alert.dart';
import 'package:forex_companion/features/alerts/domain/services/price_alerts_service.dart';
import 'package:forex_companion/features/alerts/presentation/price_alerts_screen.dart';
import 'package:forex_companion/features/alerts/presentation/providers/price_alerts_provider.dart';
import 'package:forex_companion/services/websocket_service.dart';

class MockWebSocketService extends Fake implements WebSocketService {
  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  @override
  Stream<dynamic> get stream => _controller.stream;
}

class MockNotificationService extends Fake implements NotificationService {
  @override
  Future<void> showPriceAlert(
      {required String symbol,
      required double price,
      required String condition}) async {}
}

class MockPriceAlertsService extends Fake implements PriceAlertsService {
  final List<PriceAlert> _alerts = [
    const PriceAlert(
      id: '1',
      symbol: 'EUR/USD',
      targetPrice: 1.1000,
      condition: AlertCondition.above,
      isActive: true,
    ),
    const PriceAlert(
      id: '2',
      symbol: 'GBP/USD',
      targetPrice: 1.2500,
      condition: AlertCondition.below,
      isActive: false,
    ),
  ];

  @override
  Future<List<PriceAlert>> getAlerts() async => List.from(_alerts);

  @override
  Future<void> addAlert(PriceAlert alert) async => _alerts.add(alert);

  @override
  Future<void> deleteAlert(String id) async =>
      _alerts.removeWhere((a) => a.id == id);
}

void main() {
  group('PriceAlertsScreen', () {
    late MockWebSocketService mockWebSocketService;
    late MockNotificationService mockNotificationService;
    late MockPriceAlertsService mockPriceAlertsService;

    setUp(() {
      mockWebSocketService = MockWebSocketService();
      mockNotificationService = MockNotificationService();
      mockPriceAlertsService = MockPriceAlertsService();
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the mock service delay to finish
      await tester.pumpAndSettle();
    });

    testWidgets('displays alerts after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Verify mock data is displayed (EUR/USD and GBP/USD are in the mock service)
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);
      
      // Verify price formatting (service uses toStringAsFixed(5))
      expect(find.textContaining('1.10000'), findsOneWidget);
    });

    testWidgets('can add a new alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap FAB to open dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.text('New Price Alert'), findsOneWidget);

      // Enter target price
      await tester.enterText(find.widgetWithText(TextField, 'Target Price'), '1.0800');

      // Tap Create button
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify new alert is displayed
      // Default condition is 'Above', so we look for 'Above 1.08000'
      expect(find.textContaining('1.08000'), findsOneWidget);
    });

    testWidgets('can delete an alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Find the delete button for the first alert (EUR/USD 1.1000)
      final deleteButton = find.byIcon(Icons.delete_outline).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify the alert is removed
      expect(find.textContaining('1.10000'), findsNothing);
    });

    testWidgets('filters alerts by active status', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state: All alerts (Active EUR/USD and Inactive GBP/USD)
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);

      // Filter: Active
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Active Only'));
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsNothing);

      // Filter: Inactive
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inactive Only'));
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsNothing);
      expect(find.text('GBP/USD'), findsOneWidget);
    });

    testWidgets('searches alerts by symbol', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state: Both alerts visible
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter 'EUR'
      await tester.enterText(find.byType(TextField), 'EUR');
      await tester.pumpAndSettle();

      // Verify filtering
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsNothing);

      // Close search
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify all alerts visible again
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);
    });

    testWidgets('shows confirmation dialog on swipe to delete', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Find the first dismissible widget (EUR/USD)
      final dismissibleFinder = find.byType(Dismissible).first;

      // Swipe left to trigger deletion
      await tester.drag(dismissibleFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Confirm Delete'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify alert is still present
      expect(find.text('EUR/USD'), findsOneWidget);

      // Swipe again
      await tester.drag(dismissibleFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Tap Delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify alert is removed
      expect(find.text('EUR/USD'), findsNothing);
    });

    testWidgets('shares alert details', (WidgetTester tester) async {
      const MethodChannel channel =
          MethodChannel('dev.fluttercommunity.plus/share/share');
      final List<MethodCall> log = <MethodCall>[];

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          log.add(methodCall);
          return null;
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            priceAlertsProvider.overrideWith((ref) => PriceAlertsNotifier(
                  mockPriceAlertsService,
                  mockWebSocketService,
                  mockNotificationService,
                )),
          ],
          child: const MaterialApp(home: PriceAlertsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.share).first);
      await tester.pump();

      expect(log, hasLength(1));
      expect(log.first.method, 'share');
      expect(log.first.arguments['text'],
          'Forex Alert: EUR/USD target above 1.1');
    });
  });
}