import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/agents/presentation/technical_indicators_widget.dart';

void main() {
  group('TechnicalIndicatorsWidget', () {
    testWidgets('renders RSI and MACD headers when data is provided', (WidgetTester tester) async {
      final rsiData = [50.0, 55.0, 60.0];
      final macdData = [
        const MacdData(macd: 0.001, signal: 0.002, histogram: -0.001),
        const MacdData(macd: 0.002, signal: 0.002, histogram: 0.0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechnicalIndicatorsWidget(
              rsiData: rsiData,
              macdData: macdData,
            ),
          ),
        ),
      );

      expect(find.text('RSI (14)'), findsOneWidget);
      expect(find.text('MACD (12, 26, 9)'), findsOneWidget);
      expect(find.byType(CustomPaint), findsNWidgets(2));
    });

    testWidgets('renders only RSI when MACD data is empty', (WidgetTester tester) async {
      final rsiData = [50.0, 55.0, 60.0];
      final macdData = <MacdData>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechnicalIndicatorsWidget(
              rsiData: rsiData,
              macdData: macdData,
            ),
          ),
        ),
      );

      expect(find.text('RSI (14)'), findsOneWidget);
      expect(find.text('MACD (12, 26, 9)'), findsNothing);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('renders only MACD when RSI data is empty', (WidgetTester tester) async {
      final rsiData = <double>[];
      final macdData = [
        const MacdData(macd: 0.001, signal: 0.002, histogram: -0.001),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechnicalIndicatorsWidget(
              rsiData: rsiData,
              macdData: macdData,
            ),
          ),
        ),
      );

      expect(find.text('RSI (14)'), findsNothing);
      expect(find.text('MACD (12, 26, 9)'), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('renders nothing when both data lists are empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TechnicalIndicatorsWidget(
              rsiData: [],
              macdData: [],
            ),
          ),
        ),
      );

      expect(find.text('RSI (14)'), findsNothing);
      expect(find.text('MACD (12, 26, 9)'), findsNothing);
      expect(find.byType(CustomPaint), findsNothing);
    });
  });
}