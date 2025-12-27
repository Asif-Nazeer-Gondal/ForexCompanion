import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/forex/presentation/glossary_screen.dart';

void main() {
  testWidgets('GlossaryScreen displays terms and expands definitions', (WidgetTester tester) async {
    // Build the GlossaryScreen widget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: GlossaryScreen()),
      ),
    );

    // Wait for data to load
    await tester.pumpAndSettle();

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

    // --- Test Search Functionality ---
    
    // Enter 'Pip' into the search field
    await tester.enterText(find.byType(TextField), 'Pip');
    await tester.pumpAndSettle();

    // Verify 'Pip' is visible
    expect(find.text('Pip'), findsOneWidget);
    
    // Verify 'Ask Price' is NOT visible (filtered out)
    expect(find.text('Ask Price'), findsNothing);

    // Clear search using the clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    // Verify 'Ask Price' is visible again
    expect(find.text('Ask Price'), findsOneWidget);

    // --- Test Favorites Functionality ---

    // Find the favorite button for 'Ask Price' (it's the leading widget)
    // Since there are multiple favorite borders, we find the one associated with the tile
    // However, simply finding by icon is easier if we assume order or uniqueness in test context
    final favoriteButtonFinder = find.widgetWithIcon(IconButton, Icons.favorite_border).first;
    
    // Tap to favorite 'Ask Price' (which is sorted first)
    await tester.tap(favoriteButtonFinder);
    await tester.pumpAndSettle();

    // Verify icon changed to filled favorite
    expect(find.widgetWithIcon(IconButton, Icons.favorite), findsOneWidget);

    // Toggle "Show Favorites Only" in AppBar
    await tester.tap(find.widgetWithIcon(IconButton, Icons.favorite_border).last); // The action button
    await tester.pumpAndSettle();

    // Verify 'Ask Price' (favorite) is visible
    expect(find.text('Ask Price'), findsOneWidget);

    // Verify 'Spread' (not favorite) is hidden
    expect(find.text('Spread'), findsNothing);
  });
}