import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String> getCachedToken();
  Future<void> clearToken(); // for logout
}

// ignore: constant_identifier_names
const CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
  }

  @override
  Future<String> getCachedToken() async {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (token != null) {
      return token;
    } else {
      throw CacheException(); // you can define this in your core/error
    }
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }
}
