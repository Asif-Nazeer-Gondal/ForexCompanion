import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  late TextEditingController _volumeController;
  late TextEditingController _slController;
  late TextEditingController _tpController;
  bool _isBuy = true;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController(text: '0.01');
    _slController = TextEditingController();
    _tpController = TextEditingController();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _slController.dispose();
    _tpController.dispose();
    super.dispose();
  }

  void _executeTrade() {
    // In a real implementation, this would call a provider to execute the trade
    // e.g., ref.read(tradeProvider.notifier).executeOrder(...)
    
    final volume = double.tryParse(_volumeController.text) ?? 0.01;
    final sl = double.tryParse(_slController.text);
    final tp = double.tryParse(_tpController.text);

    // Mock execution feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_isBuy ? "BUY" : "SELL"} ${widget.symbol} $volume lots executed at ${widget.currentPrice}',
        ),
        backgroundColor: _isBuy ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade ${widget.symbol}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Price Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Price',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.currentPrice.toStringAsFixed(5),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Direction Selector
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isBuy = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _isBuy ? Colors.green.withOpacity(0.2) : null,
                        border: Border.all(
                          color: _isBuy ? Colors.green : theme.dividerColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_upward, color: _isBuy ? Colors.green : Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            'BUY',
                            style: TextStyle(
                              color: _isBuy ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isBuy = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: !_isBuy ? Colors.red.withOpacity(0.2) : null,
                        border: Border.all(
                          color: !_isBuy ? Colors.red : theme.dividerColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_downward, color: !_isBuy ? Colors.red : Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            'SELL',
                            style: TextStyle(
                              color: !_isBuy ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Volume
            TextField(
              controller: _volumeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volume (Lots)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.layers),
              ),
            ),
            const SizedBox(height: 16),

            // Stop Loss & Take Profit
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _slController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Stop Loss',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _tpController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Take Profit',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_circle_outline, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Execute Button
            ElevatedButton(
              onPressed: _executeTrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBuy ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'EXECUTE ${_isBuy ? "BUY" : "SELL"}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}