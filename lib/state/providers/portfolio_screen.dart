// lib/features/portfolio/presentation/portfolio_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../state/providers/portfolio_provider.dart';
import '../domain/models/portfolio_holding.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(portfolioProvider),
          ),
        ],
      ),
      body: portfolioAsync.when(
        data: (holdings) {
          if (holdings.isEmpty) {
            return const Center(
              child: Text('No active holdings. Start trading!'),
            );
          }

          final totalValue = holdings.fold(0.0, (sum, h) => sum + h.currentValue);
          final totalPL = holdings.fold(0.0, (sum, h) => sum + h.profitLoss);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
                _buildSummaryCard(context, totalValue, totalPL, currencyFormat),
                const SizedBox(height: 24),

                // Allocation Chart
                Text(
                  'Allocation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _getSections(holdings, totalValue),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Holdings List
                Text(
                  'Holdings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: holdings.length,
                  itemBuilder: (context, index) {
                    final holding = holdings[index];
                    final isProfit = holding.profitLoss >= 0;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          holding.symbol,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${holding.amount.toStringAsFixed(2)} units @ ${holding.averagePrice.toStringAsFixed(4)}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currencyFormat.format(holding.currentValue),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${isProfit ? '+' : ''}${currencyFormat.format(holding.profitLoss)} (${holding.profitLossPercent.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                color: isProfit ? Colors.green : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double totalValue, double totalPL, NumberFormat format) {
    final isProfit = totalPL >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Portfolio Value',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            format.format(totalValue),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isProfit ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Text(
                '${isProfit ? '+' : ''}${format.format(totalPL)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections(List<PortfolioHolding> holdings, double totalValue) {
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];
    return List.generate(holdings.length, (i) {
      final holding = holdings[i];
      final percentage = (holding.currentValue / totalValue) * 100;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}