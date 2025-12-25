// lib/features/news/domain/repositories/news_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/news_service.dart';
import '../models/news_article.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsService _newsService;
  final NetworkInfo _networkInfo;

  NewsRepositoryImpl({
    required NewsService newsService,
    required NetworkInfo networkInfo,
  })  : _newsService = newsService,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NewsArticle>>> getForexNews() async {
    if (!await _networkInfo.isConnected) {
      AppLogger.warning('No internet connection');
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final articles = await _newsService.fetchForexNews();
      return Right(articles);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching news', e, stackTrace);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}