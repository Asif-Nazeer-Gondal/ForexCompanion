// lib/state/providers/budget_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/budget/models/transaction_model.dart';

class BudgetState {
  final double balance;
  final List<TransactionModel> transactions;

  BudgetState({required this.balance, required this.transactions});
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  // Initialize with some dummy data for demonstration
  BudgetNotifier() : super(BudgetState(
    balance: 25000.00,
    transactions: [
      TransactionModel(
        id: '1',
        title: 'Initial Deposit',
        amount: 25000.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isExpense: false,
      ),
    ],
  ));

  void addTransaction(String title, double amount, bool isExpense) {
    final newTransaction = TransactionModel(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      isExpense: isExpense,
    );

    final newBalance = isExpense ? state.balance - amount : state.balance + amount;
    
    state = BudgetState(
      balance: newBalance,
      transactions: [newTransaction, ...state.transactions],
    );
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});