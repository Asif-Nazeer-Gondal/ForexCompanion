import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:forex_companion/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to InternetConnectionChecker.hasConnection', () async {
      // Arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      // Act
      final result = networkInfo.isConnected;

      // Assert
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });

  group('onConnectivityChanged', () {
    test('should return stream of bool based on InternetConnectionStatus', () {
      // Arrange
      final tStatusStream = Stream.fromIterable([
        InternetConnectionStatus.connected,
        InternetConnectionStatus.disconnected,
      ]);
      when(mockInternetConnectionChecker.onStatusChange)
          .thenAnswer((_) => tStatusStream);

      // Act
      final result = networkInfo.onConnectivityChanged;

      // Assert
      expect(result, emitsInOrder([true, false]));
      verify(mockInternetConnectionChecker.onStatusChange);
    });
  });
}