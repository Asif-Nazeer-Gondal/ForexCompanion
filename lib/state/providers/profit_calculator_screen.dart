// lib/features/tools/presentation/profit_calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/providers/watchlist_provider.dart';

class ProfitCalculatorScreen extends ConsumerStatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  ConsumerState<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends ConsumerState<ProfitCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _openPriceController = TextEditingController();
  final _closePriceController = TextEditingController();
  final _tradeSizeController = TextEditingController(text: '1.0'); // Standard lots

  String _accountCurrency = 'USD';
  String _pair = 'EUR/USD';
  bool _isBuy = true;

  double? _profit;
  bool _isLoading = false;
  String? _error;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF'];
  final List<String> _pairs = [
    'EUR/USD', 'GBP/USD', 'USD/JPY', 'USD/CHF', 'AUD/USD', 'USD/CAD', 'NZD/USD',
    'EUR/GBP', 'EUR/JPY', 'GBP/JPY', 'AUD/JPY', 'CAD/JPY', 'CHF/JPY'
  ];

  @override
  void dispose() {
    _openPriceController.dispose();
    _closePriceController.dispose();
    _tradeSizeController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _profit = null;
    });

    try {
      final openPrice = double.parse(_openPriceController.text);
      final closePrice = double.parse(_closePriceController.text);
      final lots = double.parse(_tradeSizeController.text);
      final units = lots * 100000;

      // 1. Calculate raw profit in Quote Currency
      // For Buy: (Close - Open)
      // For Sell: (Open - Close)
      double priceDiff;
      if (_isBuy) {
        priceDiff = closePrice - openPrice;
      } else {
        priceDiff = openPrice - closePrice;
      }

      final rawProfit = priceDiff * units;

      // 2. Determine Quote Currency
      final pairParts = _pair.split('/');
      final quoteCurrency = pairParts[1];

      // 3. Convert to Account Currency
      double exchangeRate = 1.0;

      if (quoteCurrency != _accountCurrency) {
        final repository = ref.read(forexRepositoryProvider);
        final result = await repository.getSpecificRate(
          fromCurrency: quoteCurrency,
          toCurrency: _accountCurrency,
        );

        result.fold(
          (failure) => throw Exception(failure.message),
          (rate) => exchangeRate = rate.rate,
        );
      }

      final finalProfit = rawProfit * exchangeRate;

      setState(() {
        _profit = finalProfit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Calculation failed: ${e.toString().replaceAll('Exception:', '')}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Account Currency
                      DropdownButtonFormField<String>(
                        value: _accountCurrency,
                        decoration: const InputDecoration(labelText: 'Account Currency'),
                        items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _accountCurrency = v!),
                      ),
                      const SizedBox(height: 16),

                      // Currency Pair
                      DropdownButtonFormField<String>(
                        value: _pair,
                        decoration: const InputDecoration(labelText: 'Currency Pair'),
                        items: _pairs.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                        onChanged: (v) => setState(() => _pair = v!),
                      ),
                      const SizedBox(height: 16),

                      // Trade Size (Lots)
                      TextFormField(
                        controller: _tradeSizeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Trade Size (Standard Lots)'),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Direction
                      Row(
                        children: [
                          const Text('Direction: '),
                          const SizedBox(width: 16),
                          ChoiceChip(
                            label: const Text('Buy'),
                            selected: _isBuy,
                            onSelected: (selected) => setState(() => _isBuy = true),
                            selectedColor: Colors.green.withOpacity(0.2),
                            labelStyle: TextStyle(color: _isBuy ? Colors.green : null),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Sell'),
                            selected: !_isBuy,
                            onSelected: (selected) => setState(() => _isBuy = false),
                            selectedColor: Colors.red.withOpacity(0.2),
                            labelStyle: TextStyle(color: !_isBuy ? Colors.red : null),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Open Price
                      TextFormField(
                        controller: _openPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Open Price'),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Close Price
                      TextFormField(
                        controller: _closePriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Close Price'),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Calculate Button
              FilledButton(
                onPressed: _isLoading ? null : _calculate,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Calculate', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 24),

              // Error Message
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Results
              if (_profit != null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _profit! >= 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _profit! >= 0 ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _profit! >= 0 ? 'Profit' : 'Loss',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _profit! >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_accountCurrency ${_profit!.abs().toStringAsFixed(2)}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: _profit! >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}