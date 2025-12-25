// lib/features/sentiment/presentation/market_sentiment_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/providers/sentiment_provider.dart';

class MarketSentimentScreen extends ConsumerWidget {
  const MarketSentimentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentimentAsync = ref.watch(sentimentProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Sentiment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(sentimentProvider),
          ),
        ],
      ),
      body: sentimentAsync.when(
        data: (data) {
          Color sentimentColor;
          if (data.overallScore >= 60) sentimentColor = Colors.green;
          else if (data.overallScore <= 40) sentimentColor = Colors.red;
          else sentimentColor = Colors.orange;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Gauge Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Overall Sentiment',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              PieChart(
                                PieChartData(
                                  startDegreeOffset: 180,
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 70,
                                  sections: [
                                    PieChartSectionData(
                                      color: sentimentColor,
                                      value: data.overallScore,
                                      title: '',
                                      radius: 20,
                                    ),
                                    PieChartSectionData(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      value: 100 - data.overallScore,
                                      title: '',
                                      radius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data.overallScore.toStringAsFixed(0),
                                      style: theme.textTheme.displayMedium?.copyWith(
                                        color: sentimentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.sentimentLabel,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: sentimentColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Breakdown
                Text('Sentiment Breakdown', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildSentimentBar(
                  context,
                  'News Sentiment',
                  data.newsSentiment,
                  data.newsVolume.toString(),
                  Icons.newspaper,
                ),
                const SizedBox(height: 16),
                _buildSentimentBar(
                  context,
                  'Social Media',
                  data.socialSentiment,
                  '${data.socialVolume} posts',
                  Icons.people,
                ),
                const SizedBox(height: 24),

                // Trending Topics
                Text('Trending Topics', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.trendingTopics.map((topic) {
                    return Chip(
                      label: Text(topic),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      side: BorderSide.none,
                    );
                  }).toList(),
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

  Widget _buildSentimentBar(BuildContext context, String label, double value, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    final percentage = (value * 100).clamp(0, 100);
    Color color;
    if (value >= 0.6) color = Colors.green;
    else if (value <= 0.4) color = Colors.red;
    else color = Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.secondary),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.titleMedium),
            const Spacer(),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${percentage.toStringAsFixed(0)}% Bullish', style: theme.textTheme.labelSmall),
        ),
      ],
    );
  }
}