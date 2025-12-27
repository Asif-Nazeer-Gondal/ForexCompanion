import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/portfolio_metrics.dart';
import '../data/portfolio_websocket_service.dart';

enum SortOrder { none, ascending, descending }

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortOrder _sortOrder = SortOrder.none;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(portfolioMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Portfolio'),
      ),
      body: metricsAsync.when(
        data: (metrics) {
          final filteredPositions = metrics.openPositions
              .where((position) =>
                  position.symbol.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          if (_sortOrder != SortOrder.none) {
            filteredPositions.sort((a, b) {
              final comparison = a.unrealizedPnl.compareTo(b.unrealizedPnl);
              return _sortOrder == SortOrder.ascending ? comparison : -comparison;
            });
          }

          return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildMetricCard(
              context,
              'Equity',
              '\$${metrics.equity.toStringAsFixed(2)}',
              Colors.blue,
              isLarge: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Balance',
                    '\$${metrics.balance.toStringAsFixed(2)}',
                    Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'P&L',
                    '\$${metrics.unrealizedPnl.toStringAsFixed(2)}',
                    metrics.unrealizedPnl >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricCard(
              context,
              'Margin Level',
              '${metrics.marginLevel.toStringAsFixed(1)}%',
              metrics.marginLevel > 100 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Used Margin',
                    '\$${metrics.marginUsed.toStringAsFixed(2)}',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Free Margin',
                    '\$${metrics.freeMargin.toStringAsFixed(2)}',
                    Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Open Positions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                PopupMenuButton<SortOrder>(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort by PnL',
                  initialValue: _sortOrder,
                  onSelected: (SortOrder result) {
                    setState(() {
                      _sortOrder = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOrder>>[
                    const PopupMenuItem<SortOrder>(
                      value: SortOrder.none,
                      child: Text('Default'),
                    ),
                    const PopupMenuItem<SortOrder>(
                      value: SortOrder.descending,
                      child: Text('Highest PnL First'),
                    ),
                    const PopupMenuItem<SortOrder>(
                      value: SortOrder.ascending,
                      child: Text('Lowest PnL First'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Filter by Symbol',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            if (filteredPositions.isEmpty && metrics.openPositions.isNotEmpty)
              const Center(child: Text('No positions match your filter'))
            else
              ...filteredPositions.map((position) => _buildPositionCard(context, ref, position)),
          ],
        );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting to Portfolio Stream...'),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    Color color, {
    bool isLarge = false,
  }) {
    return Card(
      elevation: isLarge ? 4 : 2,
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                    fontSize: isLarge ? 18 : 14,
                  ),
            ),
            SizedBox(height: isLarge ? 12 : 8),
            Text(
              value,
              style: isLarge
                  ? Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      )
                  : Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionCard(BuildContext context, WidgetRef ref, OpenPosition position) {
    final isProfit = position.unrealizedPnl >= 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isProfit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          child: Icon(
            isProfit ? Icons.trending_up : Icons.trending_down,
            color: isProfit ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          position.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${position.units} units'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showModifyDialog(context, ref, position),
            ),
            Text(
              '\$${position.unrealizedPnl.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isProfit ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await ref.read(portfolioWebSocketProvider).closePosition(position.symbol);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Closed position for ${position.symbol}')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModifyDialog(
      BuildContext context, WidgetRef ref, OpenPosition position) async {
    final slController =
        TextEditingController(text: position.stopLoss?.toString() ?? '');
    final tpController =
        TextEditingController(text: position.takeProfit?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modify ${position.symbol}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: slController,
              decoration: const InputDecoration(
                labelText: 'Stop Loss',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tpController,
              decoration: const InputDecoration(
                labelText: 'Take Profit',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final sl = double.tryParse(slController.text);
              final tp = double.tryParse(tpController.text);
              await ref
                  .read(portfolioWebSocketProvider)
                  .modifyPosition(position.symbol, sl, tp);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}