import 'dart:async';

// 1. Importing ForexSummary (Assumes file is now in lib/core/ - up two levels)
import '../../forex_summary.dart';

// 2. Importing ForexAccessUseCase (Sibling in use_cases folder)
import 'forex_access_use_case.dart';

// 3. Importing ForexService (3 steps up to lib/ then down into features/forex/data)
import '../../../features/forex/data/forex_service.dart';

// 4. Importing ForexRate (3 steps up to lib/ then down into features/forex/domain/models)
import '../../../features/forex/domain/models/forex_rate.dart';

/// Concrete implementation of the ForexAccessUseCase.
/// This acts as a bridge, pulling raw data from the ForexService (Data Layer)
/// and mapping it to the simplified ForexSummary model used by the Core Domain.
class ForexAccessUseCaseImpl implements ForexAccessUseCase {
  final ForexService _service;

  ForexAccessUseCaseImpl(this._service);

  /// Fetches the current live rates and converts them into a ForexSummary.
  @override
  Future<ForexSummary> getCurrentRates() async {
    // Note: The ForexService provides a Future<List<ForexRate>>, typically from
    // an API call. We utilize the data structure it returns.
    final rates = await _service.fetchExchangeRates();

    // Since this is fetching live data, we use the current time as the last update.
    final lastUpdated = DateTime.now();

    // The ForexSummary constructor is now correctly visible.
    return ForexSummary(
      currentRates: rates,
      lastUpdated: lastUpdated,
    );
  }
}