import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:forex_companion/features/budget/data/database/app_database.dart';
import 'package:forex_companion/features/budget/data/repository/budget_repository.dart';
// Note: BudgetStateNotifier logic will be moved into the generated Notifier class
// or you can keep it separate and initialize it here if preferred.
import 'package:forex_companion/features/budget/domain/state/budget_state_notifier.dart';
import 'package:forex_companion/features/budget/budget_providers.dart'; // Import itself for dependency injection

// REQUIRED: This links the annotated code to the generated file.
part 'budget_providers.g.dart';

// --- 1. Database Provider ---
// @Riverpod(keepAlive: true) ensures a single instance lives for the app duration.
@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) {
  return AppDatabase();
}

// --- 2. Repository Provider ---
// Automatically injects dependencies by watching the generated databaseProvider.
@Riverpod(keepAlive: true)
BudgetRepository budgetRepository(BudgetRepositoryRef ref) {
  // ref.watch(databaseProvider) is now ref.watch(databaseProvider)
  final db = ref.watch(databaseProvider);
  return BudgetRepository(db);
}

// --- 3. State Notifier Provider (Mutable State) ---
// We replace StateNotifierProvider with the Notifier class pattern.
// This is the new standard for mutable state that requires business logic.
@Riverpod(keepAlive: false) // Auto-disposes when no longer listened to.
class BudgetEntriesState extends _$BudgetEntriesState {

  // The build method initializes the state and acts as the setup function.
  @override
  List<BudgetEntry> build() {
    final repository = ref.watch(budgetRepositoryProvider);

    // You can instantiate your existing StateNotifier here if it holds complex methods
    // or rewrite the logic directly into this BudgetEntriesState Notifier.
    return BudgetStateNotifier(repository).state;

    // ALTERNATIVE: Rewrite BudgetStateNotifier logic directly into methods of this class.
  }

// Example of a method to expose (e.g., BudgetStateNotifier.addEntry)
// Future<void> addEntry(BudgetEntry entry) { ... }
}

// --- 4. Stream Provider for all budget entries (Read-only) ---
// Automatically wraps the stream creation logic.
@Riverpod(keepAlive: true)
Stream<List<BudgetEntry>> budgetEntriesStream(BudgetEntriesStreamRef ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllEntries();
}