import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/agents/presentation/portfolio_metrics.dart';
import 'package:forex_companion/features/agents/presentation/portfolio_screen.dart';
import 'package:forex_companion/features/agents/presentation/portfolio_websocket_service.dart';

void main() {
  group('PortfolioScreen Filtering', () {
    testWidgets('filters open positions by symbol', (WidgetTester tester) async {
      // Mock data
      final mockMetrics = PortfolioMetrics(
        balance: 10000.0,
        equity: 10500.0,
        marginUsed: 1000.0,
        freeMargin: 9500.0,
        unrealizedPnl: 500.0,
        marginLevel: 1050.0,
        openPositions: [
          const OpenPosition(
            symbol: 'EUR/USD',
            units: 1000,
            unrealizedPnl: 50.0,
          ),
          const OpenPosition(
            symbol: 'GBP/USD',
            units: -500,
            unrealizedPnl: -20.0,
          ),
          const OpenPosition(
            symbol: 'USD/JPY',
            units: 2000,
            unrealizedPnl: 100.0,
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            portfolioMetricsProvider.overrideWith((ref) => Stream.value(mockMetrics)),
          ],
          child: const MaterialApp(home: PortfolioScreen()),
        ),
      );

      // Wait for the stream to emit
      await tester.pumpAndSettle();

      // Verify initial state (all visible)
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);
      expect(find.text('USD/JPY'), findsOneWidget);

      // Find search field
      final searchField = find.widgetWithText(TextField, 'Filter by Symbol');
      expect(searchField, findsOneWidget);

      // Filter by 'EUR'
      await tester.enterText(searchField, 'EUR');
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsNothing);
      expect(find.text('USD/JPY'), findsNothing);

      // Filter by 'JPY'
      await tester.enterText(searchField, 'JPY');
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsNothing);
      expect(find.text('GBP/USD'), findsNothing);
      expect(find.text('USD/JPY'), findsOneWidget);

      // Filter by non-existent symbol
      await tester.enterText(searchField, 'XYZ');
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsNothing);
      expect(find.text('GBP/USD'), findsNothing);
      expect(find.text('USD/JPY'), findsNothing);
      expect(find.text('No positions match your filter'), findsOneWidget);

      // Clear filter
      await tester.enterText(searchField, '');
      await tester.pumpAndSettle();

      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('GBP/USD'), findsOneWidget);
      expect(find.text('USD/JPY'), findsOneWidget);
    });
  });
}