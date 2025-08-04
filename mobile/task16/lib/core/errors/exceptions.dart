// lib/core/errors/exceptions.dart

/// Base exception for data source errors.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'AppException: $message (Status: $statusCode)';
  }
}

/// Thrown for server-related errors (e.g., 4xx, 5xx status codes).
class ServerException extends AppException {
  ServerException(String message, {int? statusCode}) : super(message, statusCode: statusCode);
}

/// Thrown when a requested resource is not found on the server (e.g., 404).
class NotFoundException extends ServerException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

/// Thrown for local data source errors (e.g., Shared Preferences issues, data not found locally).
class CacheException extends AppException {
  CacheException(String message) : super(message);
}

/// Thrown when there's an issue with network connectivity (e.g., no internet).
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

/// Thrown for any unexpected or unhandled errors.
class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}