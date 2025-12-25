// lib/features/trading/presentation/trade_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../state/providers/trade_provider.dart';
import '../domain/models/trade_order.dart';

class TradeHistoryScreen extends ConsumerWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeState = ref.watch(tradeProvider);
    final orders = tradeState.orders.reversed.toList(); // Show newest first

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade History'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No trades executed yet'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isBuy = order.type == TradeType.buy;
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      child: Icon(
                        isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isBuy ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      '${isBuy ? 'BUY' : 'SELL'} ${order.symbol}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().add_jm().format(order.timestamp),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${order.amount} units',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '@ ${order.price.toStringAsFixed(5)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}