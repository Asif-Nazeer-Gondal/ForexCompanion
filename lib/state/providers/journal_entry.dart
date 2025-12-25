// lib/features/journal/domain/models/journal_entry.dart
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
}