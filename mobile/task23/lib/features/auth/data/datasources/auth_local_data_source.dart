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
  Future<void> cacheToken(String token) async {
    print('Caching token: ${token.substring(0, 10)}...');
    await sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
    print('Token cached successfully');
  }

  @override
  Future<String> getCachedToken() async {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (token != null) {
      print('Retrieved cached token: ${token.substring(0, 10)}...');
      return token;
    } else {
      print('No cached token found');
      throw CacheException(); // you can define this in your core/error
    }
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }
}
