import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/forex_rate.dart';
import '../../domain/repositories/forex_repository.dart';
import '../forex_service.dart';

class ForexRepositoryImpl implements ForexRepository {
  final ForexService remoteDataSource;
  final NetworkInfo networkInfo;

  ForexRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ForexRate>>> getLatestRates() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRates = await remoteDataSource.getLatestRates();
        return Right(remoteRates);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ForexRate>>> getHistoricalRates(String symbol, String period) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRates = await remoteDataSource.getHistoricalRates(symbol, period);
        return Right(remoteRates);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}