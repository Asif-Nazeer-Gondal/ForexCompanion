import 'package:forex_companion/features/budget/data/database/app_database.dart';
import 'package:drift/drift.dart';

class BudgetRepository {
  final AppDatabase _db;

  BudgetRepository(this._db);

  Stream<List<BudgetEntry>> watchAllEntries() {
    return _db.watchAllEntries();
  }

  Future<void> addEntry(
      {required DateTime date,
        required String description,
        required double amount,
        required String category,
        bool isRecurring = false}) async {

    final companion = BudgetEntriesCompanion(
      date: Value(date),
      description: Value(description),
      amount: Value(amount),
      category: Value(category),
      isRecurring: Value(isRecurring),
    );

    await _db.insertEntry(companion);
  }

  Future<void> deleteEntry(int id) async {
    await _db.deleteEntry(id);
  }
}
