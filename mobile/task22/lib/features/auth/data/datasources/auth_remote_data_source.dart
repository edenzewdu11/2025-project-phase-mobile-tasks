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
    'https://g5-flutter-learning-path-be.onrender.com/api/v2';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final decoded = json.decode(response.body);
      return AuthResponseModel.fromJson(decoded);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final decoded = json.decode(response.body);
      return UserModel.fromJson(decoded['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getLoggedInUser({required String token}) async {
    final url = Uri.parse('$_baseUrl/users/me');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return UserModel.fromJson(decoded['data']);
    } else {
      throw ServerException();
    }
  }
}
