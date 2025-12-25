// lib/features/learning/presentation/glossary_screen.dart
import 'package:flutter/material.dart';

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  final List<Map<String, String>> _terms = const [
    {
      'term': 'Pip',
      'definition': 'Percentage in Point. The smallest price move that a given exchange rate can make based on market convention.'
    },
    {
      'term': 'Spread',
      'definition': 'The difference between the bid and the ask price of a currency pair.'
    },
    {
      'term': 'Leverage',
      'definition': 'The use of borrowed capital to increase the potential return of an investment.'
    },
    {
      'term': 'Margin',
      'definition': 'The amount of money that a trader needs to put forward in order to open a trade.'
    },
    {
      'term': 'Bid Price',
      'definition': 'The price at which the market is prepared to buy a specific currency pair.'
    },
    {
      'term': 'Ask Price',
      'definition': 'The price at which the market is prepared to sell a specific currency pair.'
    },
    {
      'term': 'Long Position',
      'definition': 'Buying a currency pair with the expectation that it will rise in value.'
    },
    {
      'term': 'Short Position',
      'definition': 'Selling a currency pair with the expectation that it will fall in value.'
    },
    {
      'term': 'Bullish',
      'definition': 'A market sentiment where prices are expected to rise.'
    },
    {
      'term': 'Bearish',
      'definition': 'A market sentiment where prices are expected to fall.'
    },
    {
      'term': 'Lot',
      'definition': 'The standardized quantity of the instrument being traded. Standard lot is 100,000 units.'
    },
    {
      'term': 'Stop Loss',
      'definition': 'An order placed with a broker to sell a security when it reaches a certain price to limit loss.'
    },
    {
      'term': 'Take Profit',
      'definition': 'An order specifying the exact price at which to close out an open position for a profit.'
    },
    {
      'term': 'Slippage',
      'definition': 'The difference between the expected price of a trade and the price at which the trade is executed.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Sort terms alphabetically
    final sortedTerms = List<Map<String, String>>.from(_terms)
      ..sort((a, b) => a['term']!.compareTo(b['term']!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Glossary'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedTerms.length,
        itemBuilder: (context, index) {
          final item = sortedTerms[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                item['term']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['definition']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}