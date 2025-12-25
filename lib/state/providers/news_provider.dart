// lib/state/providers/news_provider.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../core/network/network_info.dart';
import '../../features/news/data/news_service.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/repositories/news_repository_impl.dart';
import '../../features/news/domain/models/news_article.dart';

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(connectivity: Connectivity());
});

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService(
    client: http.Client(),
    apiKey: dotenv.env['NEWS_API_KEY'],
  );
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    newsService: ref.watch(newsServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final newsProvider = FutureProvider.autoDispose<List<NewsArticle>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  final result = await repository.getForexNews();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (articles) => articles,
  );
});