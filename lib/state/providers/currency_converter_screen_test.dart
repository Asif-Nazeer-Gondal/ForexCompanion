import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/presentation/currency_converter_screen.dart';

void main() {
  group('CurrencyConverterScreen Logic Tests', () {
    testWidgets('Initial state calculates correctly (1 USD to EUR)', (WidgetTester tester) async {
      // Pump the widget
      await tester.pumpWidget(const MaterialApp(home: CurrencyConverterScreen()));

      // Default state: Amount 1, From USD (1.0), To EUR (0.85)
      // Calculation: 1 / 1.0 * 0.85 = 0.85
      expect(find.text('0.85 EUR'), findsOneWidget);
    });

    testWidgets('Updates result when amount changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CurrencyConverterScreen()));

      // Find the amount text field
      final amountField = find.byType(TextField);

      // Enter '100'
      await tester.enterText(amountField, '100');
      await tester.pump(); // Rebuild to trigger logic

      // Calculation: 100 / 1.0 * 0.85 = 85.00
      expect(find.text('85.00 EUR'), findsOneWidget);
    });

    testWidgets('Updates result when "From" currency changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CurrencyConverterScreen()));

      // Find DropdownButtonFormFields. There are two: From and To.
      final dropdowns = find.byType(DropdownButtonFormField<String>);
      final fromDropdown = dropdowns.at(0);

      // Tap "From" dropdown
      await tester.tap(fromDropdown);
      await tester.pumpAndSettle();

      // Select 'GBP' (Rate: 0.73)
      // Note: find.text('GBP') might find the selected item and the menu item, so we take the last one (menu item)
      await tester.tap(find.text('GBP').last);
      await tester.pumpAndSettle();

      // Calculation: 1 GBP -> EUR
      // 1 / 0.73 (GBP rate) * 0.85 (EUR rate) = 1.1643...
      // Display format is fixed to 2 decimals
      expect(find.text('1.16 EUR'), findsOneWidget);
    });

    testWidgets('Updates result when "To" currency changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CurrencyConverterScreen()));

      // Find "To" dropdown (second one)
      final dropdowns = find.byType(DropdownButtonFormField<String>);
      final toDropdown = dropdowns.at(1);

      // Tap "To" dropdown
      await tester.tap(toDropdown);
      await tester.pumpAndSettle();

      // Select 'JPY' (Rate: 110.0)
      await tester.tap(find.text('JPY').last);
      await tester.pumpAndSettle();

      // Calculation: 1 USD -> JPY
      // 1 / 1.0 * 110.0 = 110.00
      expect(find.text('110.00 JPY'), findsOneWidget);
    });
  });
}