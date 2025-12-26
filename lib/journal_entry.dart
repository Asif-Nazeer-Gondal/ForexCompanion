class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.tags = const [],
  });
}