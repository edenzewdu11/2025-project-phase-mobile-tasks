import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    try {
      // Add a timeout to the connection check
      final hasConnection = await connectionChecker.hasConnection.timeout(
        const Duration(seconds: 5),
        onTimeout: () => true, // Assume connected if timeout
      );
      print('Network check result: $hasConnection');
      return hasConnection;
    } catch (e) {
      print('Network check failed: $e, assuming connected');
      return true; // Assume connected if check fails
    }
  }
}
