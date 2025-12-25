// lib/features/alerts/presentation/price_alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/providers/price_alerts_provider.dart';

class PriceAlertsScreen extends ConsumerWidget {
  const PriceAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(priceAlertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Alerts'),
      ),
      body: alerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No alerts set'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Dismissible(
                  key: Key(alert.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    ref.read(priceAlertsProvider.notifier).removeAlert(alert.id);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: alert.isActive
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.grey.withOpacity(0.2),
                        child: Icon(
                          alert.isAbove ? Icons.trending_up : Icons.trending_down,
                          color: alert.isActive
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        alert.symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: alert.isActive ? null : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        'Alert when ${alert.isAbove ? "above" : "below"} ${alert.targetPrice.toStringAsFixed(5)}',
                      ),
                      trailing: Switch(
                        value: alert.isActive,
                        onChanged: (value) {
                          ref.read(priceAlertsProvider.notifier).toggleAlert(alert.id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAlertDialog(context, ref),
        child: const Icon(Icons.add_alert),
      ),
    );
  }

  void _showAddAlertDialog(BuildContext context, WidgetRef ref) {
    final symbolController = TextEditingController();
    final priceController = TextEditingController();
    bool isAbove = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Set Price Alert'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(
                  labelText: 'Symbol',
                  hintText: 'e.g. EUR/USD',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Target Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Condition: '),
                  ChoiceChip(
                    label: const Text('Above'),
                    selected: isAbove,
                    onSelected: (selected) => setState(() => isAbove = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Below'),
                    selected: !isAbove,
                    onSelected: (selected) => setState(() => isAbove = false),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);
                final symbol = symbolController.text.trim().toUpperCase();
                
                if (symbol.isNotEmpty && price != null) {
                  ref.read(priceAlertsProvider.notifier).addAlert(
                        symbol,
                        price,
                        isAbove,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Set Alert'),
            ),
          ],
        ),
      ),
    );
  }
}