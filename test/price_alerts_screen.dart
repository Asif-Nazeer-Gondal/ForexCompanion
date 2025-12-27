import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/models/price_alert.dart';
import 'providers/price_alerts_provider.dart';
import '../../../core/services/background_service.dart';

class PriceAlertsScreen extends ConsumerStatefulWidget {
  const PriceAlertsScreen({super.key});

  @override
  ConsumerState<PriceAlertsScreen> createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends ConsumerState<PriceAlertsScreen> {
  String _filter = 'All';
  String _sortBy = 'Symbol';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addAlert() async {
    final result = await showDialog<PriceAlert>(
      context: context,
      builder: (context) => const _AddAlertDialog(),
    );

    if (result != null) {
      ref.read(priceAlertsProvider.notifier).addAlert(result);
    }
  }

  Future<void> _editAlert(PriceAlert alert) async {
    final result = await showDialog<PriceAlert>(
      context: context,
      builder: (context) => _AddAlertDialog(alert: alert),
    );

    if (result != null) {
      ref.read(priceAlertsProvider.notifier).updateAlert(result);
    }
  }

  Future<void> _deleteAlert(String id) async {
    ref.read(priceAlertsProvider.notifier).deleteAlert(id);
  }

  Future<void> _toggleAlert(String id) async {
    ref.read(priceAlertsProvider.notifier).toggleAlert(id);
  }

  void _shareAlert(PriceAlert alert) {
    final condition =
        alert.condition == AlertCondition.above ? 'above' : 'below';
    Share.share(
        'Forex Alert: ${alert.symbol} target $condition ${alert.targetPrice}');
  }

  Future<void> _configureBackgroundMonitoring() async {
    final backgroundService = BackgroundService();
    await backgroundService.initialize();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Background Check Frequency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Every 15 minutes'),
              onTap: () {
                backgroundService.registerPeriodicPriceCheck(
                    frequency: const Duration(minutes: 15));
                Navigator.pop(context);
                _showStatusMessage('Enabled: 15 min interval');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Every 30 minutes'),
              onTap: () {
                backgroundService.registerPeriodicPriceCheck(
                    frequency: const Duration(minutes: 30));
                Navigator.pop(context);
                _showStatusMessage('Enabled: 30 min interval');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Every 1 hour'),
              onTap: () {
                backgroundService.registerPeriodicPriceCheck(
                    frequency: const Duration(hours: 1));
                Navigator.pop(context);
                _showStatusMessage('Enabled: 1 hour interval');
              },
            ),
            ListTile(
              leading: const Icon(Icons.stop, color: Colors.red),
              title: const Text('Disable Monitoring'),
              onTap: () {
                backgroundService.cancelAll();
                Navigator.pop(context);
                _showStatusMessage('Background monitoring disabled');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsState = ref.watch(priceAlertsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : null,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search symbol...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              )
            : const Text('Price Alerts'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search Alerts',
              onPressed: () => setState(() => _isSearching = true),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Alerts',
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Alerts')),
              const PopupMenuItem(value: 'Active', child: Text('Active Only')),
              const PopupMenuItem(value: 'Inactive', child: Text('Inactive Only')),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Alerts',
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Symbol', child: Text('Sort by Symbol')),
              const PopupMenuItem(value: 'Price', child: Text('Sort by Price')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configure Background Check',
            onPressed: _configureBackgroundMonitoring,
          ),
        ],
      ),
      body: alertsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (alerts) {
          final filteredAlerts = alerts.where((a) {
            if (_filter == 'Active' && !a.isActive) return false;
            if (_filter == 'Inactive' && a.isActive) return false;

            if (_searchController.text.isNotEmpty &&
                !a.symbol
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
              return false;
            }
            return true;
          }).toList();

          filteredAlerts.sort((a, b) {
            if (_sortBy == 'Price') {
              return a.targetPrice.compareTo(b.targetPrice);
            }
            return a.symbol.compareTo(b.symbol);
          });

          if (filteredAlerts.isEmpty) {
            if (alerts.isEmpty) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No active alerts',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('Tap + to create a new price alert'),
                    ],
                  ),
                );
            }
            return Center(child: Text('No ${_filter.toLowerCase()} alerts found'));
          }

          return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = filteredAlerts[index];
                    return Dismissible(
                      key: Key(alert.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                  "Are you sure you want to delete this alert?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _deleteAlert(alert.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('${alert.symbol} alert deleted')),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () => _editAlert(alert),
                          leading: CircleAvatar(
                            backgroundColor: alert.isActive
                                ? Theme.of(context).primaryColor.withOpacity(0.1)
                                : Colors.grey.shade200,
                            child: Icon(
                              alert.condition == AlertCondition.above
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: alert.isActive
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          title: Text(
                            alert.symbol,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${alert.condition == AlertCondition.above ? 'Above' : 'Below'} ${alert.targetPrice.toStringAsFixed(5)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => _shareAlert(alert),
                            ),
                            Switch(
                              value: alert.isActive,
                              onChanged: (_) => _toggleAlert(alert.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteAlert(alert.id),
                            ),
                          ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlert,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddAlertDialog extends StatefulWidget {
  final PriceAlert? alert;
  const _AddAlertDialog({this.alert});

  @override
  State<_AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<_AddAlertDialog> {
  final _symbolController = TextEditingController();
  final _priceController = TextEditingController();
  AlertCondition _condition = AlertCondition.above;

  // Mock symbols
  final List<String> _symbols = [
    'EUR/USD', 'GBP/USD', 'USD/JPY', 'AUD/USD', 'USD/CAD'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alert != null) {
      _symbolController.text = widget.alert!.symbol;
      _priceController.text = widget.alert!.targetPrice.toString();
      _condition = widget.alert!.condition;
    } else {
      _symbolController.text = _symbols.first;
    }
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.alert == null ? 'New Price Alert' : 'Edit Price Alert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _symbolController.text,
              decoration: const InputDecoration(labelText: 'Symbol'),
              items: _symbols.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _symbolController.text = val);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Target Price',
                hintText: 'e.g. 1.0500',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AlertCondition>(
              value: _condition,
              decoration: const InputDecoration(labelText: 'Condition'),
              items: const [
                DropdownMenuItem(
                  value: AlertCondition.above,
                  child: Text('Price Goes Above'),
                ),
                DropdownMenuItem(
                  value: AlertCondition.below,
                  child: Text('Price Goes Below'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _condition = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final price = double.tryParse(_priceController.text);
            if (price == null) return;

            final alert = PriceAlert(
              id: widget.alert?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              symbol: _symbolController.text,
              targetPrice: price,
              condition: _condition,
              isActive: widget.alert?.isActive ?? true,
            );
            Navigator.pop(context, alert);
          },
          child: Text(widget.alert == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}