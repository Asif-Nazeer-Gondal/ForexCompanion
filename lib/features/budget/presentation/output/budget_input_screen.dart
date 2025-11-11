import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_companion/features/budget/budget_providers.dart';
import 'package:intl/intl.dart';

// Define a simple list of categories for the input form
const List<String> categories = [
  'Income',
  'Food',
  'Bills',
  'Investment',
  'Entertainment',
  'Other',
];

class BudgetInputScreen extends ConsumerStatefulWidget {
  const BudgetInputScreen({super.key});

  @override
  ConsumerState<BudgetInputScreen> createState() => _BudgetInputScreenState();
}

class _BudgetInputScreenState extends ConsumerState<BudgetInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  // Form State Variables
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories.first; // Initialize with the first category
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // --- Date Picker Logic ---
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

  // --- Submission Logic ---
  void _submitForm() async {
    // Validate all form fields
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    // Read the StateNotifier to call the insertion method
    final budgetNotifier = ref.read(budgetStateNotifierProvider.notifier);

    try {
      final amount = double.tryParse(_amountController.text);
      if (amount == null) return; // Should be handled by validator, but for safety

      // Call the addEntry method on the StateNotifier
      await budgetNotifier.addEntry(
        date: _selectedDate,
        description: _descriptionController.text.trim(),
        amount: amount,
        category: _selectedCategory!, // Guaranteed not null by logic
        isRecurring: false, // For simplicity now, could be added later
      );

      // Show success message and navigate back/clear form
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget entry added successfully!')),
        );
        // Clear inputs after successful submission
        _descriptionController.clear();
        _amountController.clear();
        // Optionally pop the screen if it was pushed as a modal
        // Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add entry: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. Description Field
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

              // 2. Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                    labelText: 'Amount (Positive for Income, Negative for Expense)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 3. Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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

              // 5. Submit Button
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