import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/forex/domain/models/economic_event.dart';
import 'package:forex_companion/features/forex/presentation/economic_calendar_providers.dart';
import 'package:forex_companion/features/forex/presentation/economic_calendar_screen.dart';

void main() {
  testWidgets('EconomicCalendarScreen displays events and handles filtering', (WidgetTester tester) async {
    // Arrange
    final now = DateTime.now();
    final events = [
      EconomicEvent(
        id: '1',
        title: 'High Impact Event',
        currency: 'USD',
        impact: 'High',
        time: now,
        forecast: '100',
        previous: '90',
      ),
      EconomicEvent(
        id: '2',
        title: 'Low Impact Event',
        currency: 'EUR',
        impact: 'Low',
        time: now.add(const Duration(hours: 1)),
        forecast: '50',
        previous: '40',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          economicCalendarProvider.overrideWith((ref) => events),
        ],
        child: const MaterialApp(
          home: EconomicCalendarScreen(),
        ),
      ),
    );

    // Wait for data to load
    await tester.pumpAndSettle();

    // Assert: Both events are visible initially
    expect(find.text('High Impact Event'), findsOneWidget);
    expect(find.text('Low Impact Event'), findsOneWidget);

    // Act: Deselect 'Low' impact
    await tester.tap(find.widgetWithText(FilterChip, 'Low'));
    await tester.pumpAndSettle();

    // Assert: Low impact event should be gone
    expect(find.text('High Impact Event'), findsOneWidget);
    expect(find.text('Low Impact Event'), findsNothing);

    // Act: Deselect 'High' impact
    await tester.tap(find.widgetWithText(FilterChip, 'High'));
    await tester.pumpAndSettle();

    // Assert: Both gone
    expect(find.text('High Impact Event'), findsNothing);
    expect(find.text('Low Impact Event'), findsNothing);
    expect(find.text('No events found'), findsOneWidget);
  });
}