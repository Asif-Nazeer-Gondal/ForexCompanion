import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/presentation/correlation_matrix_screen.dart';

void main() {
  group('CorrelationMatrixScreen', () {
    testWidgets('renders table with correct headers and data', (WidgetTester tester) async {
      // Pump the widget wrapped in MaterialApp
      await tester.pumpWidget(const MaterialApp(home: CorrelationMatrixScreen()));

      // Verify App Bar Title
      expect(find.text('Correlation Matrix'), findsOneWidget);

      // Verify Section Title
      expect(find.text('Currency Correlations (Daily)'), findsOneWidget);

      // Verify Legend text exists
      expect(find.textContaining('Green: Positive Correlation'), findsOneWidget);

      // Verify DataTable is present
      expect(find.byType(DataTable), findsOneWidget);

      // Verify Column Headers
      // The widget replaces '/' with '\n' for column headers to save space
      expect(find.text('EUR\nUSD'), findsOneWidget);
      expect(find.text('USD\nJPY'), findsOneWidget);

      // Verify Row Headers (these retain the '/')
      expect(find.text('EUR/USD'), findsOneWidget);
      expect(find.text('USD/JPY'), findsOneWidget);

      // Verify Data Cells
      // Self correlation is 1.00. Since there are 7 pairs in the mock service,
      // we expect at least 7 occurrences (one for each diagonal).
      expect(find.text('1.00'), findsAtLeastNWidgets(7));

      // Check specific correlation values based on the hardcoded service data
      // EUR/USD - GBP/USD: 0.89
      expect(find.text('0.89'), findsAtLeastNWidgets(1));

      // EUR/USD - USD/CHF: -0.94
      expect(find.text('-0.94'), findsAtLeastNWidgets(1));
    });

    testWidgets('contains horizontal scroll view for table', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CorrelationMatrixScreen()));

      // There should be a SingleChildScrollView with horizontal axis
      expect(find.byWidgetPredicate((widget) => widget is SingleChildScrollView && widget.scrollDirection == Axis.horizontal), findsOneWidget);
    });
  });
}