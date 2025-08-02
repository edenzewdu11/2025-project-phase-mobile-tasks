// lib/core/network/network_info_impl.dart

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true); // Always connected for this task
}