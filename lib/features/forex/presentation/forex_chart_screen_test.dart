import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/forex/data/forex_service.dart';
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart';
import 'package:forex_companion/features/forex/presentation/forex_chart_screen.dart';
import 'package:forex_companion/state/providers/forex_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forex_chart_screen_test.mocks.dart';

@GenerateMocks([ForexService])
void main() {
  late MockForexService mockForexService;

  setUp(() {
    mockForexService = MockForexService();
  });

  testWidgets('ForexChartScreen shows loading indicator initially', (WidgetTester tester) async {
    // Arrange: Delay the response to simulate loading
    when(mockForexService.getHistoricalRates(any, any))
        .thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          return [];
        });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          forexServiceProvider.overrideWithValue(mockForexService),
        ],
        child: const MaterialApp(
          home: ForexChartScreen(symbol: 'EUR/USD'),
        ),
      ),
    );

    // Act: Initial build triggers loading state
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Finish the pending timer to avoid pending timers exception
    await tester.pump(const Duration(seconds: 1)); 
  });

  testWidgets('ForexChartScreen shows chart and data when loaded', (WidgetTester tester) async {
    // Arrange
    final rates = [
      ForexRate(
          baseCurrency: 'USD',
          quoteCurrency: 'EUR',
          rate: 1.1000,
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
      ForexRate(
          baseCurrency: 'USD',
          quoteCurrency: 'EUR',
          rate: 1.1050,
          timestamp: DateTime.now()),
    ];

    when(mockForexService.getHistoricalRates(any, any))
        .thenAnswer((_) async => rates);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          forexServiceProvider.overrideWithValue(mockForexService),
        ],
        child: const MaterialApp(
          home: ForexChartScreen(symbol: 'EUR/USD'),
        ),
      ),
    );

    // Wait for data
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('1.10500'), findsOneWidget); // Current price
    expect(find.textContaining('+0.00500'), findsOneWidget); // Change
    expect(find.text('TRADE'), findsOneWidget);
  });

  testWidgets('ForexChartScreen shows error and handles retry', (WidgetTester tester) async {
    // Arrange: Throw error initially
    when(mockForexService.getHistoricalRates(any, any))
        .thenThrow(Exception('Network Error'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          forexServiceProvider.overrideWithValue(mockForexService),
        ],
        child: const MaterialApp(
          home: ForexChartScreen(symbol: 'EUR/USD'),
        ),
      ),
    );

    // Wait for error state
    await tester.pumpAndSettle();

    // Assert Error UI
    expect(find.textContaining('Error loading data'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // Arrange: Success on retry
    final rates = [
      ForexRate(
          baseCurrency: 'USD',
          quoteCurrency: 'EUR',
          rate: 1.2000,
          timestamp: DateTime.now()),
    ];
    when(mockForexService.getHistoricalRates(any, any))
        .thenAnswer((_) async => rates);

    // Act: Tap Retry
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    // Assert Success UI
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('1.20000'), findsOneWidget);
  });
}