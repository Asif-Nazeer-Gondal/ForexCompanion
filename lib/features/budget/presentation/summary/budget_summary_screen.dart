import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forex_companion/features/budget/budget_providers.dart';
// FIX: Using the correct generated file which exports BudgetEntry
import 'package:forex_companion/features/budget/data/database/app_database.dart';
import 'package:intl/intl.dart';

// Note: BudgetEntry is defined in app_database.dart (after code generation)

final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
final dateFormatter = DateFormat('MMM d, yyyy');

class BudgetSummaryScreen extends ConsumerWidget {
  const BudgetSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIX: Using correct type inference after code generation
    final budgetEntriesAsync = ref.watch(budgetEntriesStreamProvider);
    final budgetNotifier = ref.watch(budgetStateNotifierProvider.notifier);
    final totalBalance = budgetNotifier.calculateTotalBalance();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              context.goNamed('budget_input');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(budgetEntriesStreamProvider),
          ),
        ],
      ),

      body: Column(
        children: [
          BudgetBalanceCard(totalBalance: totalBalance),

          Expanded(
            // FIX: Correct usage of AsyncValue.when arguments (loading, error, data)
            child: budgetEntriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              // FIX: Corrected syntax for error block string interpolation
              error: (err, stack) => Center(child: Text('Error: \$err')),

              // FIX: Correctly placed 'data' parameter function
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(child: Text('No budget entries recorded yet.'));
                }
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return BudgetEntryTile(entry: entry);
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

class BudgetBalanceCard extends StatelessWidget {
  final double totalBalance;

  // FIX: Parameter 'key' corrected to super parameter usage
  const BudgetBalanceCard({required this.totalBalance, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balanceColor = totalBalance >= 0 ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Balance',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(totalBalance),
              style: theme.textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: balanceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NOTE: The compiler expects BudgetEntry to be defined via app_database.dart after code generation
class BudgetEntryTile extends ConsumerWidget {
  final BudgetEntry entry;

  // FIX: Parameter 'key' corrected to super parameter usage
  const BudgetEntryTile({required this.entry, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = entry.amount >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    final budgetNotifier = ref.read(budgetStateNotifierProvider.notifier);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        budgetNotifier.deleteEntry(entry.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // FIX: Corrected string interpolation syntax
            content: Text('\${entry.description} deleted.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.invalidate(budgetEntriesStreamProvider);
              },
            ),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Icon(
          entry.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
        title: Text(entry.description),
        subtitle: Text(entry.category),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currencyFormatter.format(entry.amount),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              dateFormatter.format(entry.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
