// lib/features/news/domain/models/news_article.dart
class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String source;
  final DateTime publishedAt;
  final String? imageUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.publishedAt,
    this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? 'No Description',
      url: json['url'] as String? ?? '',
      source: (json['source'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown Source',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ?? DateTime.now(),
      imageUrl: json['urlToImage'] as String?,
    );
  }
}