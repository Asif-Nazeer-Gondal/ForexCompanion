// lib/features/watchlist/presentation/watchlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../state/providers/watchlist_provider.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistState = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(watchlistProvider.notifier).fetchRates();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPairDialog(context, ref),
          ),
        ],
      ),
      body: watchlistState.rates.when(
        data: (rates) {
          if (rates.isEmpty && watchlistState.symbols.isNotEmpty) {
             return const Center(child: CircularProgressIndicator());
          }
          if (watchlistState.symbols.isEmpty) {
            return const Center(child: Text('Watchlist is empty. Add a pair!'));
          }
          
          return ListView.builder(
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final rate = rates[index];
              final symbol = '${rate.baseCurrency}/${rate.quoteCurrency}';
              
              return Dismissible(
                key: Key(symbol),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref.read(watchlistProvider.notifier).removeSymbol(symbol);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      rate.baseCurrency,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(rate.timestamp)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rate.rate.toStringAsFixed(5),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    context.push('/chart', extra: symbol);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddPairDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Currency Pair'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. EUR/USD',
            labelText: 'Symbol',
            helperText: 'Format: BASE/QUOTE',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final symbol = controller.text.trim().toUpperCase();
              if (symbol.contains('/') && symbol.length >= 7) {
                ref.read(watchlistProvider.notifier).addSymbol(symbol);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}