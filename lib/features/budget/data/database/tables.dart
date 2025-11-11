import 'package:drift/drift.dart';

class BudgetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().withLength(min: 1, max: 255)();
  RealColumn get amount => real()();
  TextColumn get category => text().withLength(min: 1, max: 50)();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
}
