// lib/features/sentiment/domain/models/sentiment_data.dart
class SentimentData {
  final double overallScore; // 0 to 100 (0 = Extreme Bearish, 100 = Extreme Bullish)
  final String sentimentLabel; // Bearish, Neutral, Bullish
  final int newsVolume;
  final int socialVolume;
  final double newsSentiment; // 0.0 to 1.0
  final double socialSentiment; // 0.0 to 1.0
  final List<String> trendingTopics;

  SentimentData({
    required this.overallScore,
    required this.sentimentLabel,
    required this.newsVolume,
    required this.socialVolume,
    required this.newsSentiment,
    required this.socialSentiment,
    required this.trendingTopics,
  });
}