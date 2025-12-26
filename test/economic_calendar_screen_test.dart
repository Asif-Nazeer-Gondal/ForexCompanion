import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/calendar/presentation/economic_calendar_screen.dart';

void main() {
  group('EconomicCalendarScreen', () {
    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: EconomicCalendarScreen()));

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the mock service delay to finish
      await tester.pumpAndSettle();
    });

    testWidgets('displays events after loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: EconomicCalendarScreen()));
      await tester.pumpAndSettle();

      // Verify mock data titles are displayed
      expect(find.text('GDP Growth Rate QoQ'), findsOneWidget);
      expect(find.text('Unemployment Rate'), findsOneWidget);
      expect(find.text('Retail Sales MoM'), findsOneWidget);

      // Verify currencies are displayed
      expect(find.text('USD'), findsOneWidget);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('GBP'), findsOneWidget);
    });

    testWidgets('displays impact indicators correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: EconomicCalendarScreen()));
      await tester.pumpAndSettle();

      // Verify impact labels are present
      expect(find.text('HIGH'), findsAtLeastNWidgets(1));
      expect(find.text('MEDIUM'), findsAtLeastNWidgets(1));
      expect(find.text('LOW'), findsAtLeastNWidgets(1));
    });

    testWidgets('date picker opens on action button tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: EconomicCalendarScreen()));
      await tester.pumpAndSettle();

      // Tap the calendar icon in the app bar
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // Verify DatePickerDialog appears
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}