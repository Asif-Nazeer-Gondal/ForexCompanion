// lib/features/home/presentation/widgets/dashboard_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../state/providers/portfolio_provider.dart';
import '../../../../state/providers/sentiment_provider.dart';
import '../../../../state/providers/budget_provider.dart';

class DashboardWidget extends ConsumerWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);
    final sentimentAsync = ref.watch(sentimentProvider);
    final budgetState = ref.watch(budgetProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Market Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
              ],
            ),
            const SizedBox(height: 20),
            
            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    'Balance',
                    currencyFormat.format(budgetState.balance),
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: portfolioAsync.when(
                    data: (holdings) {
                      final totalValue = holdings.fold(0.0, (sum, h) => sum + h.currentValue);
                      return _buildMetricTile(
                        context,
                        'Portfolio',
                        currencyFormat.format(totalValue),
                        Icons.pie_chart,
                        Colors.purple,
                      );
                    },
                    loading: () => const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    error: (_, __) => _buildMetricTile(context, 'Portfolio', 'Error', Icons.error, Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sentiment Row
            sentimentAsync.when(
              data: (data) {
                Color color;
                if (data.overallScore >= 60) color = Colors.green;
                else if (data.overallScore <= 40) color = Colors.red;
                else color = Colors.orange;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.show_chart, color: color),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Market Sentiment',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                            ),
                            Text(
                              data.sentimentLabel,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${data.overallScore.toStringAsFixed(0)}/100',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}