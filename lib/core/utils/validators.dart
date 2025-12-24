class Validators {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Enter a valid number';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > 1000000000) {
      return 'Amount is too large';
    }

    return null;
  }

  static String? validateCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return 'Currency is required';
    }

    if (value.length != 3) {
      return 'Currency code must be 3 characters';
    }

    return null;
  }

  static String? validateBudgetName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Budget name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }
}