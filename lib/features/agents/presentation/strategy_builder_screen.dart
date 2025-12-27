import 'package:flutter/material.dart';

class StrategyBuilderScreen extends StatefulWidget {
  const StrategyBuilderScreen({super.key});

  @override
  State<StrategyBuilderScreen> createState() => _StrategyBuilderScreenState();
}

class _StrategyBuilderScreenState extends State<StrategyBuilderScreen> {
  final List<String> _indicators = ['RSI', 'MACD', 'Bollinger Bands', 'EMA', 'SMA'];
  final List<String> _selectedIndicators = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategy Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Define Entry Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _indicators.map((indicator) {
                final isSelected = _selectedIndicators.contains(indicator);
                return FilterChip(
                  label: Text(indicator),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedIndicators.add(indicator);
                      } else {
                        _selectedIndicators.remove(indicator);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Logic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_selectedIndicators.isEmpty)
              const Text('Select indicators to build logic.', style: TextStyle(color: Colors.grey))
            else
              Column(
                children: _selectedIndicators.map((ind) => Card(
                  child: ListTile(
                    title: Text(ind),
                    trailing: const Icon(Icons.settings),
                    subtitle: const Text('Condition: Crosses Above 50'),
                  ),
                )).toList(),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedIndicators.isEmpty ? null : () {},
                child: const Text('Save Strategy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}