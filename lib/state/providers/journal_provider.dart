// lib/state/providers/journal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/journal/domain/models/journal_entry.dart';

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([]);

  void addEntry(String title, String content) {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      date: DateTime.now(),
    );
    state = [entry, ...state];
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier();
});