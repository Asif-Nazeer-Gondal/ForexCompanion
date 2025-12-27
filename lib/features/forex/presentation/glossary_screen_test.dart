import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/state/providers/glossary_screen.dart';

void main() {
  testWidgets('GlossaryScreen displays terms and expands definitions', (WidgetTester tester) async {
    // Build the GlossaryScreen widget
    await tester.pumpWidget(const MaterialApp(home: GlossaryScreen()));

    // Verify the title is displayed
    expect(find.text('Forex Glossary'), findsOneWidget);

    // Verify that terms are displayed (sorted alphabetically)
    // "Ask Price" should be near the top
    expect(find.text('Ask Price'), findsOneWidget);

    // Verify that definitions are initially hidden
    // We look for the definition of "Ask Price"
    final definitionFinder = find.text('The price at which the market is prepared to sell a specific currency pair.');
    expect(definitionFinder, findsNothing);

    // Tap on the term "Ask Price" to expand the tile
    await tester.tap(find.text('Ask Price'));
    
    // Wait for the animation to finish
    await tester.pumpAndSettle();

    // Verify that the definition is now visible
    expect(definitionFinder, findsOneWidget);

    // Verify scrolling works for items further down the list
    // "Spread" is likely further down
    final spreadTermFinder = find.text('Spread');
    
    // Scroll until "Spread" is visible
    await tester.scrollUntilVisible(spreadTermFinder, 500.0);
    expect(spreadTermFinder, findsOneWidget);
    
    // Verify its definition is hidden
    final spreadDefFinder = find.text('The difference between the bid and the ask price of a currency pair.');
    expect(spreadDefFinder, findsNothing);
    
    // Expand "Spread"
    await tester.tap(spreadTermFinder);
    await tester.pumpAndSettle();
    
    // Verify definition is visible
    expect(spreadDefFinder, findsOneWidget);
  });
}