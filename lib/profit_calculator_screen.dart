import 'package:flutter/material.dart';
import '../domain/services/profit_calculator_service.dart';

class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  State<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends State<ProfitCalculatorScreen> {
  final ProfitCalculatorService _service = ProfitCalculatorService();

  final TextEditingController _openPriceController = TextEditingController();
  final TextEditingController _closePriceController = TextEditingController();
  final TextEditingController _lotsController = TextEditingController();

  String _selectedPair = 'EUR/USD';
  // [Buy, Sell]
  final List<bool> _tradeTypeSelection = [true, false];
  ProfitCalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _lotsController.text = '1.0';
    _openPriceController.text = '1.0850';
    _closePriceController.text = '1.0900';
    _calculate();
  }

  void _calculate() {
    final open = double.tryParse(_openPriceController.text) ?? 0.0;
    final close = double.tryParse(_closePriceController.text) ?? 0.0;
    final lots = double.tryParse(_lotsController.text) ?? 0.0;
    final isBuy = _tradeTypeSelection[0];

    setState(() {
      _result = _service.calculateProfit(
        pair: _selectedPair,
        isBuy: isBuy,
        openPrice: open,
        closePrice: close,
        lots: lots,
      );
    });
  }

  @override
  void dispose() {
    _openPriceController.dispose();
    _closePriceController.dispose();
    _lotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = (_result?.profit ?? 0) >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Currency Pair Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPair,
                      decoration: const InputDecoration(
                        labelText: 'Currency Pair',
                        border: OutlineInputBorder(),
                      ),
                      items: _service.availablePairs.map((String pair) {
                        return DropdownMenuItem<String>(
                          value: pair,
                          child: Text(pair),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPair = newValue;
                            _calculate();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Buy/Sell Toggle
                    ToggleButtons(
                      isSelected: _tradeTypeSelection,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _tradeTypeSelection.length; i++) {
                            _tradeTypeSelection[i] = i == index;
                          }
                          _calculate();
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
                      fillColor: _tradeTypeSelection[0] ? Colors.green.shade100 : Colors.red.shade100,
                      selectedColor: _tradeTypeSelection[0] ? Colors.green.shade900 : Colors.red.shade900,
                      children: const [
                        Text('Buy / Long'),
                        Text('Sell / Short'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Volume (Lots)
                    TextField(
                      controller: _lotsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Volume (Lots)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),

                    // Open & Close Prices
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _openPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Open Price',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _calculate(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _closePriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Close Price',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _calculate(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Results
            if (_result != null) ...[
              Text(
                'Estimated Profit/Loss',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                color: isProfit ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        '\$${_result!.profit.toStringAsFixed(2)}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_result!.pips.toStringAsFixed(1)} Pips',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}