import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_companion/features/budget/data/database/app_database.dart';
import 'package:forex_companion/features/budget/data/repository/budget_repository.dart';

class BudgetStateNotifier extends StateNotifier<List<BudgetEntry>> {
  final BudgetRepository _repository;

  BudgetStateNotifier(this._repository) : super([]) {
    _repository.watchAllEntries().listen((entries) {
      state = entries;
    });
  }

  double calculateTotalBalance() {
    // FIX: Removed unnecessary null check on amount because Drift models ensure non-null fields.
    return state.fold(0.0, (previous, entry) => previous + entry.amount);
  }

  Future<void> addEntry({
    required DateTime date,
    required String description,
    required double amount,
    required String category,
    bool isRecurring = false,
  }) async {
    await _repository.addEntry(
      date: date,
      description: description,
      amount: amount,
      category: category,
      isRecurring: isRecurring,
    );
  }

  Future<void> deleteEntry(int id) async {
    await _repository.deleteEntry(id);
  }
}
