import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/agents/presentation/portfolio_metrics.dart';
import 'package:forex_companion/features/agents/presentation/portfolio_screen.dart';

void main() {
  testWidgets('PortfolioScreen renders metrics and positions correctly', (WidgetTester tester) async {
    // Arrange
    final metrics = PortfolioMetrics(
      balance: 10000.0,
      equity: 10500.0,
      marginUsed: 1000.0,
      freeMargin: 9500.0,
      unrealizedPnl: 500.0,
      marginLevel: 1050.0,
      openPositions: [
        OpenPosition(
          symbol: 'EUR/USD',
          units: 1000,
          entryPrice: 1.1000,
          unrealizedPnl: 50.0,
        ),
        OpenPosition(
          symbol: 'GBP/USD',
          units: -500,
          entryPrice: 1.2500,
          unrealizedPnl: -20.0,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          portfolioMetricsProvider.overrideWith((ref) => Stream.value(metrics)),
        ],
        child: const MaterialApp(
          home: PortfolioScreen(),
        ),
      ),
    );

    // Wait for the stream to emit and UI to rebuild
    await tester.pumpAndSettle();

    // Assert Summary Card
    expect(find.text('Equity'), findsOneWidget);
    expect(find.text('\$10500.00'), findsOneWidget);
    
    expect(find.text('Unrealized P/L'), findsOneWidget);
    expect(find.text('+\$500.00'), findsOneWidget);

    expect(find.text('Balance'), findsOneWidget);
    expect(find.text('\$10000.00'), findsOneWidget);

    expect(find.text('Margin'), findsOneWidget);
    expect(find.text('\$1000.00'), findsOneWidget);

    expect(find.text('Free Margin'), findsOneWidget);
    expect(find.text('\$9500.00'), findsOneWidget);

    // Assert Positions List Header
    expect(find.text('Open Positions (2)'), findsOneWidget);

    // Assert Position 1 (EUR/USD)
    expect(find.text('EUR/USD'), findsOneWidget);
    expect(find.text('BUY'), findsOneWidget);
    expect(find.text('+\$50.00'), findsOneWidget);
    expect(find.text('Size: 1000.0'), findsOneWidget);
    expect(find.text('Entry: 1.10000'), findsOneWidget);

    // Assert Position 2 (GBP/USD)
    expect(find.text('GBP/USD'), findsOneWidget);
    expect(find.text('SELL'), findsOneWidget);
    expect(find.text('\$-20.00'), findsOneWidget);
    expect(find.text('Size: 500.0'), findsOneWidget);
    expect(find.text('Entry: 1.25000'), findsOneWidget);
  });
}