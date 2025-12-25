// lib/state/providers/sentiment_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/sentiment/domain/models/sentiment_data.dart';
import 'news_provider.dart';

final sentimentProvider = FutureProvider.autoDispose<SentimentData>((ref) async {
  // 1. Get News Data
  final newsArticles = await ref.watch(newsProvider.future);
  
  // 2. Analyze News Sentiment (Simple keyword analysis)
  int bullishKeywords = 0;
  int bearishKeywords = 0;
  
  for (var article in newsArticles) {
    final text = (article.title + (article.description)).toLowerCase();
    if (text.contains('rise') || text.contains('gain') || text.contains('bull') || text.contains('high') || text.contains('growth') || text.contains('positive')) {
      bullishKeywords++;
    }
    if (text.contains('fall') || text.contains('loss') || text.contains('bear') || text.contains('low') || text.contains('crash') || text.contains('negative')) {
      bearishKeywords++;
    }
  }

  final totalNewsKeywords = bullishKeywords + bearishKeywords;
  double newsScore = 0.5; // Neutral default
  if (totalNewsKeywords > 0) {
    newsScore = bullishKeywords / totalNewsKeywords;
  }

  // 3. Simulate Social Media Data (Randomized for demonstration)
  // In a real app, this would fetch from Twitter/Reddit APIs
  const socialScore = 0.65; // Slightly bullish
  const socialVolume = 1250;

  // 4. Aggregate: Weight 60% News, 40% Social
  final aggregateScore = (newsScore * 0.6) + (socialScore * 0.4);
  final normalizedScore = aggregateScore * 100; // 0-100 scale

  String label;
  if (normalizedScore >= 60) label = 'Bullish';
  else if (normalizedScore <= 40) label = 'Bearish';
  else label = 'Neutral';

  return SentimentData(
    overallScore: normalizedScore,
    sentimentLabel: label,
    newsVolume: newsArticles.length,
    socialVolume: socialVolume,
    newsSentiment: newsScore,
    socialSentiment: socialScore,
    trendingTopics: ['#EURUSD', '#Inflation', '#Fed', '#Crypto', '#Gold'],
  );
});