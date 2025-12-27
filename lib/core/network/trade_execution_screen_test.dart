import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/forex/presentation/trade_execution_screen.dart';

void main() {
  testWidgets('TradeExecutionScreen renders correctly and handles state changes', (WidgetTester tester) async {
    const symbol = 'EUR/USD';
    const price = 1.12345;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TradeExecutionScreen(
            symbol: symbol,
            currentPrice: price,
          ),
        ),
      ),
    );

    // Verify AppBar title contains the symbol
    expect(find.text('Trade $symbol'), findsOneWidget);

    // Verify Current Price is displayed
    expect(find.text(price.toStringAsFixed(5)), findsOneWidget);

    // Verify Input fields exist
    expect(find.widgetWithText(TextField, 'Volume (Lots)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Stop Loss'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Take Profit'), findsOneWidget);

    // Verify default state is BUY
    // The button text should be 'EXECUTE BUY'
    expect(find.text('EXECUTE BUY'), findsOneWidget);

    // Act: Tap the SELL button
    await tester.tap(find.text('SELL'));
    await tester.pump();

    // Assert: Verify state changed to SELL
    // The button text should now be 'EXECUTE SELL'
    expect(find.text('EXECUTE SELL'), findsOneWidget);
    expect(find.text('EXECUTE BUY'), findsNothing);
  });
}