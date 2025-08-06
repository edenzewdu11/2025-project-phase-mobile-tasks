// lib/core/services/api_service.dart

import 'dart:convert';
import 'dart:io'; // For SocketException, TlsException
import 'package:http/http.dart' as http;
import 'package:contracts_of_data_sources/core/errors/exceptions.dart'; // Import custom exceptions
import 'package:contracts_of_data_sources/core/constants/api_constants.dart'; // Import API constants

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$kBaseUrl$path');
    try {
      final response = await client.get(uri, headers: kApiHeaders);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TlsException {
      throw ServerException('SSL/TLS certificate error.');
    } catch (e) {
      throw UnknownException('An unknown error occurred during GET request: $e');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$kBaseUrl$path');
    try {
      final response = await client.post(
        uri,
        headers: kApiHeaders,
        body: json.encode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TlsException {
      throw ServerException('SSL/TLS certificate error.');
    } catch (e) {
      throw UnknownException('An unknown error occurred during POST request: $e');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$kBaseUrl$path');
    try {
      final response = await client.put(
        uri,
        headers: kApiHeaders,
        body: json.encode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TlsException {
      throw ServerException('SSL/TLS certificate error.');
    } catch (e) {
      throw UnknownException('An unknown error occurred during PUT request: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$kBaseUrl$path');
    try {
      final response = await client.delete(uri, headers: kApiHeaders);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TlsException {
      throw ServerException('SSL/TLS certificate error.');
    } catch (e) {
      throw UnknownException('An unknown error occurred during DELETE request: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null; // For 204 No Content, or successful delete with empty body
    } else if (response.statusCode == 404) {
      throw NotFoundException('Resource not found for ${response.request?.url.path}.');
    } else {
      throw ServerException(
        'Server error: ${response.statusCode} ${response.reasonPhrase ?? ''}',
        statusCode: response.statusCode,
      );
    }
  }
}