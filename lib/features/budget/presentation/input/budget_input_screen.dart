import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_companion/features/budget/budget_providers.dart';
import 'package:intl/intl.dart';

const List<String> categories = ['Income', 'Food', 'Bills', 'Investment', 'Entertainment', 'Other'];

class BudgetInputScreen extends ConsumerStatefulWidget {
  // FIX: Using super.key for modern constructor syntax
  const BudgetInputScreen({super.key});

  @override
  ConsumerState<BudgetInputScreen> createState() => _BudgetInputScreenState();
}

class _BudgetInputScreenState extends ConsumerState<BudgetInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories.first;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final budgetNotifier = ref.read(budgetStateNotifierProvider.notifier);
    try {
      final amount = double.tryParse(_amountController.text);
      if (amount == null) return;

      await budgetNotifier.addEntry(
        date: _selectedDate,
        description: _descriptionController.text.trim(),
        amount: amount,
        category: _selectedCategory!,
        isRecurring: false,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget entry added successfully!')),
        );
        _descriptionController.clear();
        _amountController.clear();
      }
    } catch (e) {
      if (mounted) {
        // FIX: Corrected string interpolation syntax for error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add entry: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Budget Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                    labelText: 'Amount (+ Income, - Expense)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                // NOTE: 'value' is deprecated, but functionally correct here for setting initial state
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() { _selectedCategory = value; });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FIX: Corrected string interpolation syntax for date display
                  Text(
                    'Date: ${DateFormat('EEE, MMM d, y').format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Change Date'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}