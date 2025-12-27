import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../models/forex_rate.dart';
import '../repositories/forex_repository.dart';

class GetForexRates {
  final ForexRepository repository;

  GetForexRates(this.repository);

  Future<Either<Failure, List<ForexRate>>> call() {
    return repository.getLatestRates();
  }
}