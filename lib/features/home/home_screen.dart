// Path: lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; // Make sure you have this in pubspec.yaml

// FIXED: Use correct relative paths
import '../../models/forex_rate.dart';
import '../../providers/forex_providers.dart';
import 'widgets/rate_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXED: Use the correct provider from your forex_providers.dart
    final timeSeriesData = ref.watch(timeSeriesProvider);
    final latestRateData = ref.watch(latestRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Dashboard'),
      ),
      body: timeSeriesData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (rates) { // FIXED: Use the correct data type 'rates' which is a List<ForexRate>
          if (rates.isEmpty) {
            return const Center(child: Text('No data available.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              latestRateData.when(
                loading: () => const RateCard(rate: null), // Show a loading state
                error: (err, stack) => const Text('Could not load latest rate'),
                data: (latestRate) => RateCard(rate: ForexRate(rate: latestRate, date: DateTime.now())),
              ),
              const SizedBox(height: 24),
              Text(
                'Last 7 Days (USD to PKR)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                // FIXED: Simplified and corrected LineChart implementation
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: rates.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.rate);
                        }).toList(),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
