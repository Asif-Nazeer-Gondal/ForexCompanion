import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 🛑 Import the necessary providers and model
import 'package:forex_companion/features/forex/forex_providers.dart';
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart'; // Ensure this path is correct

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the FutureProvider that fetches the API data
    final forexDataAsync = ref.watch(forexDataFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Companion'),
        actions: [
          // Refresh button: invalidates the provider to refetch data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(forexDataFutureProvider),
          ),
        ],
      ),
      // 2. Use AsyncValue.when to handle loading/error/data states
      body: forexDataAsync.when(
        // === Loading State ===
        loading: () => const Center(child: CircularProgressIndicator()),

        // === Error State ===
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                const Text('Failed to load exchange rates.', style: TextStyle(fontSize: 16)),
                Text('Error: ${err.toString()}', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),

        // === Data State ===
        data: (rates) {
          if (rates.isEmpty) {
            return const Center(child: Text('No exchange rates found.'));
          }
          return ListView.builder(
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final rate = rates[index];
              return ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.teal),
                title: Text(
                  rate.currencyPair,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  rate.rate.toStringAsFixed(4), // Display rate with 4 decimal places
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                subtitle: Text('Last updated: ${DateTime.now().toLocal().toString().substring(11, 16)}'),
              );
            },
          );
        },
      ),
    );
  }
}