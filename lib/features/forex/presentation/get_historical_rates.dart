import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../models/forex_rate.dart';
import '../repositories/forex_repository.dart';

class GetHistoricalRates {
  final ForexRepository repository;

  GetHistoricalRates(this.repository);

  Future<Either<Failure, List<ForexRate>>> call(String symbol, String period) {
    return repository.getHistoricalRates(symbol, period);
  }
}