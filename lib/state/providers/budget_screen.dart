// lib/features/budget/presentation/budget_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../state/providers/budget_provider.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetState = ref.watch(budgetProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Management'),
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(budgetState.balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Transactions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              itemCount: budgetState.transactions.length,
              itemBuilder: (context, index) {
                final transaction = budgetState.transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.isExpense
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    child: Icon(
                      transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: transaction.isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text(transaction.title),
                  subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                  trailing: Text(
                    '${transaction.isExpense ? "-" : "+"}${currencyFormat.format(transaction.amount)}',
                    style: TextStyle(
                      color: transaction.isExpense ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isExpense = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Type: '),
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: isExpense,
                    onSelected: (selected) => setState(() => isExpense = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: !isExpense,
                    onSelected: (selected) => setState(() => isExpense = false),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (titleController.text.isNotEmpty && amount > 0) {
                  ref.read(budgetProvider.notifier).addTransaction(
                        titleController.text,
                        amount,
                        isExpense,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}