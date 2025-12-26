import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/journal_screen.dart';

void main() {
  group('JournalScreen', () {
    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JournalScreen()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(); // Finish animations/futures
    });

    testWidgets('displays journal entries after loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JournalScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Reflecting on EUR/USD Loss'), findsOneWidget);
      expect(find.text('Weekly Review'), findsOneWidget);
      expect(find.text('Psychology'), findsOneWidget);
    });

    testWidgets('can add a new entry', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JournalScreen()));
      await tester.pumpAndSettle();

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill dialog
      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'New Trade');
      await tester.enterText(find.widgetWithText(TextField, 'Content'), 'Trade content');
      await tester.enterText(find.widgetWithText(TextField, 'Tags (comma separated)'), 'Tag1, Tag2');

      // Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify new entry
      expect(find.text('New Trade'), findsOneWidget);
      expect(find.text('Trade content'), findsOneWidget);
      expect(find.text('Tag1'), findsOneWidget);
    });

    testWidgets('can delete an entry', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JournalScreen()));
      await tester.pumpAndSettle();

      // Verify entry exists
      expect(find.text('Reflecting on EUR/USD Loss'), findsOneWidget);

      // Tap delete on the first card
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // Verify entry is removed
      expect(find.text('Reflecting on EUR/USD Loss'), findsNothing);
    });
  });
}