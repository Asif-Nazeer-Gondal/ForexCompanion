import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:forex_companion/core/network/network_info.dart';
import 'package:forex_companion/features/forex/data/forex_service.dart';
import 'package:forex_companion/features/forex/data/repositories/forex_repository_impl.dart';
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart';

import 'forex_repository_impl_test.mocks.dart';

@GenerateMocks([ForexService, NetworkInfo])
void main() {
  late ForexRepositoryImpl repository;
  late MockForexService mockForexService;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockForexService = MockForexService();
    mockNetworkInfo = MockNetworkInfo();
    repository = ForexRepositoryImpl(
      remoteDataSource: mockForexService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getLatestRates', () {
    final tForexRates = <ForexRate>[];

    test('should check if the device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockForexService.getLatestRates()).thenAnswer((_) async => tForexRates);

      // Act
      await repository.getLatestRates();

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    test('should return remote data when the call to remote data source is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockForexService.getLatestRates()).thenAnswer((_) async => tForexRates);

      // Act
      final result = await repository.getLatestRates();

      // Assert
      verify(mockForexService.getLatestRates());
      expect(result, equals(Right(tForexRates)));
    });
  });
}