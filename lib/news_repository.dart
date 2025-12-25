// lib/features/news/domain/repositories/news_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../models/news_article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> getForexNews();
}