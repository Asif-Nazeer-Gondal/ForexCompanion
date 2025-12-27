import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'portfolio_metrics.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(portfolioMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: metricsAsync.when(
        data: (metrics) => RefreshIndicator(
          onRefresh: () async {
            return ref.refresh(portfolioMetricsProvider.future);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _SummaryCard(metrics: metrics),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Open Positions (${metrics.openPositions.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              if (metrics.openPositions.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No open positions')),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final position = metrics.openPositions[index];
                      return _PositionCard(position: position);
                    },
                    childCount: metrics.openPositions.length,
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error loading portfolio: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(portfolioMetricsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final PortfolioMetrics metrics;

  const _SummaryCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfitable = metrics.unrealizedPnl >= 0;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Equity', style: theme.textTheme.titleMedium),
                    Text(
                      '\$${metrics.equity.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Unrealized P/L', style: theme.textTheme.titleMedium),
                    Text(
                      '${isProfitable ? '+' : ''}\$${metrics.unrealizedPnl.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isProfitable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, 'Balance', '\$${metrics.balance.toStringAsFixed(2)}'),
                _buildStatItem(context, 'Margin', '\$${metrics.marginUsed.toStringAsFixed(2)}'),
                _buildStatItem(context, 'Free Margin', '\$${metrics.freeMargin.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  final OpenPosition position;

  const _PositionCard({required this.position});

  @override
  Widget build(BuildContext context) {
    final isLong = position.units > 0;
    final isProfitable = position.unrealizedPnl >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLong ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isLong ? 'BUY' : 'SELL',
                        style: TextStyle(
                          color: isLong ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      position.symbol,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  '${isProfitable ? '+' : ''}\$${position.unrealizedPnl.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isProfitable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Size: ${position.units.abs()}'),
                Text('Entry: ${position.entryPrice.toStringAsFixed(5)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}