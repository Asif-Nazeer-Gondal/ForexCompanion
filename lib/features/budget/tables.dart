import 'package:drift/drift.dart';

// Defines the BudgetEntry table schema
class BudgetEntries extends Table {
  // Primary key auto-incremented ID
  IntColumn get id => integer().autoIncrement()();

  // Date of the transaction/entry
  DateTimeColumn get date => dateTime()();

  // Description (e.g., "Grocery Shopping", "Salary")
  TextColumn get description => text().withLength(min: 1, max: 255)();

  // Amount (can be negative for expenses, positive for income)
  RealColumn get amount => real()();

  // Category (e.g., 'Income', 'Food', 'Bills', 'Investment')
  TextColumn get category => text().withLength(min: 1, max: 50)();

  // Is this a repeating budget item (e.g., a monthly bill)
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
}