// lib/core/domain/models/budget_summary.dart

/// Represents summarized financial data used by features like Jarvis.
/// This prevents Jarvis from depending on complex Budget feature models.
class BudgetSummary {
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> expensesByCategory;
  final DateTime summaryPeriodStart;
  final DateTime summaryPeriodEnd;

  BudgetSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.expensesByCategory,
    required this.summaryPeriodStart,
    required this.summaryPeriodEnd,
  });

  /// Converts the summary data into a concise string for AI consumption.
  String toPromptString() {
    final categoryStrings = expensesByCategory.entries
        .map((e) => '- ${e.key}: \$${e.value.toStringAsFixed(2)}')
        .join('\n');

    return """
User Financial Summary (Period: ${summaryPeriodStart.year}-${summaryPeriodStart.month} to ${summaryPeriodEnd.year}-${summaryPeriodEnd.month}):
- Total Income: \$${totalIncome.toStringAsFixed(2)}
- Total Expenses: \$${totalExpenses.toStringAsFixed(2)}
- Net Balance: \$${(totalIncome - totalExpenses).toStringAsFixed(2)}

Expense Breakdown by Category:
$categoryStrings
""";
  }
}