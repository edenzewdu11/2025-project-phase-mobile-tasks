// ignore: depend_on_referenced_packages
import 'package:contracts_of_data_sources/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

// Mock class for InternetConnectionChecker
class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockChecker;

  setUp(() {
    mockChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () {
        // Arrange
        final tHasConnectionFuture = Future.value(true);
        when(mockChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

        // Act
        final result = networkInfo.isConnected; // Not awaiting here

        // Assert
        verify(
          mockChecker.hasConnection,
        ); // Check that hasConnection was called
        expect(
          result,
          tHasConnectionFuture,
        ); // Check the returned Future is the same
      },
    );
  });
}
