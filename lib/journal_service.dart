import '../models/journal_entry.dart';

class JournalService {
  // Mock data storage
  final List<JournalEntry> _entries = [
    JournalEntry(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Reflecting on EUR/USD Loss',
      content: 'I entered too early without waiting for confirmation candle. Need to be more patient.',
      tags: ['Psychology', 'EUR/USD', 'Loss'],
    ),
    JournalEntry(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Weekly Review',
      content: 'Good week overall. 3 wins, 1 loss. Risk management was on point.',
      tags: ['Review', 'Weekly'],
    ),
  ];

  Future<List<JournalEntry>> getEntries() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_entries);
  }

  Future<void> addEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _entries.insert(0, entry);
  }

  Future<void> deleteEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((e) => e.id == id);
  }
}