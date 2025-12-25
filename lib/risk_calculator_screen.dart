// lib/features/tools/presentation/risk_calculator_screen.dart
import 'package:flutter/material.dart';

class RiskCalculatorScreen extends StatefulWidget {
  const RiskCalculatorScreen({super.key});

  @override
  State<RiskCalculatorScreen> createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _balanceController = TextEditingController();
  final _riskPercentController = TextEditingController(text: '1.0');
  final _stopLossPipsController = TextEditingController(text: '50');

  double _riskAmount = 0.0;
  double _positionSizeUnits = 0.0;
  double _standardLots = 0.0;

  @override
  void dispose() {
    _balanceController.dispose();
    _riskPercentController.dispose();
    _stopLossPipsController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState?.validate() ?? false) {
      final balance = double.tryParse(_balanceController.text) ?? 0.0;
      final riskPercent = double.tryParse(_riskPercentController.text) ?? 0.0;
      final stopLossPips = double.tryParse(_stopLossPipsController.text) ?? 0.0;

      if (stopLossPips == 0) return;

      setState(() {
        _riskAmount = balance * (riskPercent / 100);
        
        // Assuming USD account and USD quote pair (e.g., EUR/USD)
        // 1 Standard Lot (100,000 units) => $10 per pip
        // Pip Value per unit = $0.0001 (approx)
        // Position Size (Units) = Risk Amount / (Stop Loss Pips * 0.0001)
        
        const double pipValuePerUnit = 0.0001; 
        
        _positionSizeUnits = _riskAmount / (stopLossPips * pipValuePerUnit);
        _standardLots = _positionSizeUnits / 100000;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Calculator'),
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
                      TextFormField(
                        controller: _balanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Account Balance',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter balance';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _riskPercentController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Risk Percentage',
                          suffixText: '%',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter risk %';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _stopLossPipsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Stop Loss (Pips)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter stop loss';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Calculate Position Size', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              if (_positionSizeUnits > 0) ...[
                const Text(
                  'Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildResultTile(
                  context,
                  'Amount at Risk',
                  '\$${_riskAmount.toStringAsFixed(2)}',
                  Colors.red,
                ),
                const SizedBox(height: 8),
                _buildResultTile(
                  context,
                  'Position Size (Units)',
                  _positionSizeUnits.toStringAsFixed(0),
                  Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                _buildResultTile(
                  context,
                  'Standard Lots',
                  _standardLots.toStringAsFixed(2),
                  Theme.of(context).colorScheme.secondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}