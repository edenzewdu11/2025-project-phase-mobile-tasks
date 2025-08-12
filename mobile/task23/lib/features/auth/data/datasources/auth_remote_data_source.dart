import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls API to login user, returns access token
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Calls API to register user, returns user data
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  /// Calls API to get currently logged-in user info
  Future<UserModel> getLoggedInUser({required String token});
}

// 🔗 Base URL
  const String _baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 30)); // Add 30 second timeout

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return AuthResponseModel.fromJson(decoded);
      } else {
        print('Login failed with status: ${response.statusCode}, body: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Login request failed: $e');
      if (e.toString().contains('timeout')) {
        throw ServerException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 30)); // Add 30 second timeout

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return UserModel.fromJson(decoded['data']);
      } else {
        print('Register failed with status: ${response.statusCode}, body: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Register request failed: $e');
      if (e.toString().contains('timeout')) {
        throw ServerException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getLoggedInUser({required String token}) async {
    final url = Uri.parse('$_baseUrl/users/me');

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30)); // Add 30 second timeout

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return UserModel.fromJson(decoded['data']);
      } else {
        print('Get user failed with status: ${response.statusCode}, body: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Get user request failed: $e');
      if (e.toString().contains('timeout')) {
        throw ServerException();
      }
      rethrow;
    }
  }
}
