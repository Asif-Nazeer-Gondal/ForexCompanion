// lib/features/forex/presentation/forex_chart_screen.dart
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../state/providers/forex_provider.dart';

class ForexChartScreen extends ConsumerStatefulWidget {
  final String symbol;

  const ForexChartScreen({
    super.key,
    this.symbol = 'EUR/USD',
  });

  @override
  ConsumerState<ForexChartScreen> createState() => _ForexChartScreenState();
}

class _ForexChartScreenState extends ConsumerState<ForexChartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(forexChartProvider.notifier).setSymbol(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartState = ref.watch(forexChartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(chartState.symbol),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {},
          ),
        ],
      ),
      body: chartState.rates.when(
        data: (rates) {
          if (rates.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final spots = rates.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.rate);
          }).toList();

          final currentPrice = rates.last.rate;
          final startPrice = rates.first.rate;
          final change = currentPrice - startPrice;
          final isPositive = change >= 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Header
                Text(
                  currentPrice.toStringAsFixed(4),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${change.toStringAsFixed(4)} (${(change / startPrice * 100).toStringAsFixed(2)}%)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Chart
                AspectRatio(
                  aspectRatio: 1.5,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 0.001,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: theme.dividerColor.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(3),
                                style: theme.textTheme.labelSmall,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: spots.length.toDouble() - 1,
                      minY: spots.map((e) => e.y).reduce(min) * 0.999,
                      maxY: spots.map((e) => e.y).reduce(max) * 1.001,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: theme.colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.3),
                                theme.colorScheme.primary.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Timeframe Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['1D', '1W', '1M', '3M', '1Y'].map((tf) {
                    final isSelected = chartState.timeframe == tf;
                    return InkWell(
                      onTap: () => ref.read(forexChartProvider.notifier).setTimeframe(tf),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tf,
                          style: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      context.push('/trade', extra: {
                        'symbol': chartState.symbol,
                        'price': currentPrice,
                      });
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('Trade'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error loading data: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(forexChartProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}