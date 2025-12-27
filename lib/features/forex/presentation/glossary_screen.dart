import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'glossary_providers.dart';

class GlossaryScreen extends ConsumerStatefulWidget {
  const GlossaryScreen({super.key});

  @override
  ConsumerState<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends ConsumerState<GlossaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final termsAsync = ref.watch(glossaryTermsProvider);
    final favorites = ref.watch(favoriteGlossaryTermsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Glossary'),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            tooltip: _showFavoritesOnly ? 'Show All' : 'Show Favorites Only',
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Terms',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: termsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (terms) {
                // Filter terms based on search query
                final filteredTerms = terms.where((term) {
                  final query = _searchQuery.toLowerCase();
                  final matchesSearch = term.term.toLowerCase().contains(query) ||
                      term.definition.toLowerCase().contains(query);
                  final matchesFavorite = !_showFavoritesOnly || favorites.contains(term.id);
                  return matchesSearch && matchesFavorite;
                }).toList();

                // Sort terms alphabetically
                filteredTerms.sort((a, b) => a.term.compareTo(b.term));

                if (filteredTerms.isEmpty) {
                  return const Center(child: Text('No terms found'));
                }

                return ListView.builder(
                  itemCount: filteredTerms.length,
                  itemBuilder: (context, index) {
                    final term = filteredTerms[index];
                    final isFavorite = favorites.contains(term.id);
                    return ExpansionTile(
                      leading: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          ref.read(favoriteGlossaryTermsProvider.notifier).toggleFavorite(term.id);
                        },
                      ),
                      title: Text(term.term),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(term.definition),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}