import 'package:flutter/material.dart';
import '../domain/services/risk_calculator_service.dart';

class PositionSizeCalculatorScreen extends StatefulWidget {
  const PositionSizeCalculatorScreen({super.key});

  @override
  State<PositionSizeCalculatorScreen> createState() => _PositionSizeCalculatorScreenState();
}

class _PositionSizeCalculatorScreenState extends State<PositionSizeCalculatorScreen> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _riskController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();

  final RiskCalculatorService _service = RiskCalculatorService();
  RiskCalculationResult? _result;

  // Default to EUR/USD
  String _selectedPair = 'EUR/USD';

  // Mock pip values for demonstration (Standard Lot $100k)
  // In a real app, these would be dynamic based on current exchange rates
  final Map<String, double> _pipValues = {
    'EUR/USD': 10.0,
    'GBP/USD': 10.0,
    'AUD/USD': 10.0,
    'NZD/USD': 10.0,
    'USD/JPY': 9.09, // Approx 1000 JPY / 110.00
    'USD/CAD': 7.40, // Approx 10 CAD / 1.35
    'USD/CHF': 10.86, // Approx 10 CHF / 0.92
    'EUR/GBP': 12.80, // Approx 10 GBP / 0.78
  };

  @override
  void initState() {
    super.initState();
    _balanceController.text = '10000';
    _riskController.text = '1.0';
    _stopLossController.text = '20';
    _calculate();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text) ?? 0.0;
    final risk = double.tryParse(_riskController.text) ?? 0.0;
    final stopLoss = double.tryParse(_stopLossController.text) ?? 0.0;
    final pipValue = _pipValues[_selectedPair] ?? 10.0;

    setState(() {
      _result = _service.calculateRisk(
        accountBalance: balance,
        riskPercentage: risk,
        stopLossPips: stopLoss,
        pipValue: pipValue,
      );
    });
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _riskController.dispose();
    _stopLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position Size Calculator'),
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
                    DropdownButtonFormField<String>(
                      value: _selectedPair,
                      decoration: const InputDecoration(
                        labelText: 'Currency Pair',
                        border: OutlineInputBorder(),
                      ),
                      items: _pipValues.keys.map((String pair) {
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
                    TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Account Balance',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _riskController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Risk (%)',
                              suffixText: '%',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _calculate(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _stopLossController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Stop Loss (Pips)',
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
            if (_result != null) ...[
              Text(
                'Recommended Position',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      context,
                      'Standard Lots',
                      _result!.standardLots.toStringAsFixed(2),
                      Colors.blue.shade100,
                      Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResultCard(
                      context,
                      'Units',
                      _result!.positionSizeUnits.toStringAsFixed(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                context,
                'Risk Amount',
                '\$${_result!.riskAmount.toStringAsFixed(2)}',
                Colors.red.shade100,
                Colors.red.shade900,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    String label,
    String value, [
    Color? bgColor,
    Color? textColor,
  ]) {
    return Card(
      color: bgColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}