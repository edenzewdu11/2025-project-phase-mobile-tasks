// lib/core/network/network_info_impl.dart

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionCheckerPlus connectionChecker;

  // Constructor that takes an InternetConnectionCheckerPlus instance
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}