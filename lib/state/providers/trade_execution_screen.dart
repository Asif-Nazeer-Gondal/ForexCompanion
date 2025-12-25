// lib/features/trading/presentation/trade_execution_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/trade_order.dart';
import '../../../state/providers/trade_provider.dart';

class TradeExecutionScreen extends ConsumerStatefulWidget {
  final String symbol;
  final double currentPrice;

  const TradeExecutionScreen({
    super.key,
    required this.symbol,
    required this.currentPrice,
  });

  @override
  ConsumerState<TradeExecutionScreen> createState() => _TradeExecutionScreenState();
}

class _TradeExecutionScreenState extends ConsumerState<TradeExecutionScreen> {
  final _amountController = TextEditingController();
  TradeType _selectedType = TradeType.buy;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _executeTrade() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    await ref.read(tradeProvider.notifier).executeTrade(
          symbol: widget.symbol,
          type: _selectedType,
          amount: amount,
          price: widget.currentPrice,
        );

    if (mounted) {
      final state = ref.read(tradeProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_selectedType.name.toUpperCase()} order executed successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tradeState = ref.watch(tradeProvider);
    final theme = Theme.of(context);
    final isBuy = _selectedType == TradeType.buy;

    return Scaffold(
      appBar: AppBar(title: Text('Trade ${widget.symbol}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Price Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current Price', style: theme.textTheme.titleMedium),
                    Text(
                      widget.currentPrice.toStringAsFixed(5),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buy/Sell Toggle
            SegmentedButton<TradeType>(
              segments: const [
                ButtonSegment(
                  value: TradeType.buy,
                  label: Text('BUY'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TradeType.sell,
                  label: Text('SELL'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<TradeType> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return _selectedType == TradeType.buy ? Colors.green : Colors.red;
                  }
                  return null;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Amount Input
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount (Units)',
                prefixIcon: const Icon(Icons.numbers),
                suffixText: widget.symbol.split('/').first,
              ),
            ),
            const Spacer(),

            // Execute Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: tradeState.isLoading ? null : _executeTrade,
                style: FilledButton.styleFrom(
                  backgroundColor: isBuy ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: tradeState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '${isBuy ? 'BUY' : 'SELL'} ${widget.symbol}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}