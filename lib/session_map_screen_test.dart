import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/presentation/session_map_screen.dart';

void main() {
  group('SessionMapScreen', () {
    testWidgets('renders static UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SessionMapScreen()));

      expect(find.text('Market Sessions'), findsOneWidget);
      expect(find.text('Current Time (UTC)'), findsOneWidget);
      expect(find.text('Major Markets'), findsOneWidget);
    });

    testWidgets('renders all session cards with correct time ranges', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SessionMapScreen()));

      final sessions = ['Sydney', 'Tokyo', 'London', 'New York'];
      for (final session in sessions) {
        expect(find.text(session), findsOneWidget);
      }

      // Check for time ranges
      expect(find.text('21:00 - 06:00 UTC'), findsOneWidget);
      expect(find.text('00:00 - 09:00 UTC'), findsOneWidget);
      expect(find.text('07:00 - 16:00 UTC'), findsOneWidget);
      expect(find.text('12:00 - 21:00 UTC'), findsOneWidget);
    });

    testWidgets('renders status indicators for all sessions', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SessionMapScreen()));

      // We expect 4 status indicators (either OPEN or CLOSED)
      final openFinder = find.text('OPEN');
      final closedFinder = find.text('CLOSED');

      final openCount = openFinder.evaluate().length;
      final closedCount = closedFinder.evaluate().length;

      expect(openCount + closedCount, 4);
    });

    testWidgets('timer runs without error', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SessionMapScreen()));
      await tester.pump(const Duration(seconds: 2));
    });
  });
}