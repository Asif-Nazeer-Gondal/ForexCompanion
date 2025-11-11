// lib/core/domain/use_cases/budget_access_use_case.dart

import '../models/budget_summary.dart';

/// Contract for accessing simplified, read-only budget information.
/// This allows features like Jarvis to depend on the CORE contract, not the Budget feature implementation.
abstract class BudgetAccessUseCase {
  /// Fetches a summary of the user's financial activity for the most recent month.
  Future<BudgetSummary> getMonthlySummary();
}