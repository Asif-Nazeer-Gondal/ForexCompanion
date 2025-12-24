// lib/features/forex/domain/repositories/forex_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../utils/app_logger.dart';
import '../../data/forex_service.dart';
import '../models/forex_rate.dart';
import 'forex_repository.dart';

class ForexRepositoryImpl implements ForexRepository {
  final ForexService _forexService;
  final NetworkInfo _networkInfo;

  ForexRepositoryImpl({
    required ForexService forexService,
    required NetworkInfo networkInfo,
  })  : _forexService = forexService,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ForexRate>>> getForexRates() async {
    // Check network connectivity first
    if (!await _networkInfo.isConnected) {
      AppLogger.warning('No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      AppLogger.info('Fetching forex rates...');
      final rates = await _forexService.fetchRates();
      AppLogger.info('Successfully fetched ${rates.length} forex rates');
      return Right(rates);
    } on NetworkException catch (e) {
      AppLogger.error('Network error while fetching rates', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error while fetching rates', e);
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching rates', e, stackTrace);
      return Left(ForexApiFailure('Failed to fetch rates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ForexRate>> getSpecificRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      AppLogger.info('Fetching rate for $fromCurrency to $toCurrency');
      final rate = await _forexService.fetchSpecificRate(
        from: fromCurrency,
        to: toCurrency,
      );
      return Right(rate);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ForexApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ForexRate>>> getHistoricalRates({
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final rates = await _forexService.fetchHistoricalRates(
        currency: currency,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(rates);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ForexApiFailure(e.toString()));
    }
  }
}