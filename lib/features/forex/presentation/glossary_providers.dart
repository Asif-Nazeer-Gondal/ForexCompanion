import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/glossary_repository.dart';
import '../domain/models/glossary_term.dart';

final glossaryRepositoryProvider = Provider<GlossaryRepository>((ref) {
  return GlossaryRepository();
});

final glossaryTermsProvider = FutureProvider<List<GlossaryTerm>>((ref) async {
  final repository = ref.watch(glossaryRepositoryProvider);
  return repository.fetchTerms();
});

class FavoriteGlossaryTermsNotifier extends StateNotifier<Set<String>> {
  FavoriteGlossaryTermsNotifier() : super({});

  void toggleFavorite(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }
}

final favoriteGlossaryTermsProvider = StateNotifierProvider<FavoriteGlossaryTermsNotifier, Set<String>>((ref) {
  return FavoriteGlossaryTermsNotifier();
});