// lib/core/errors/failures.dart

/// Base class for all failures in the application.
abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

/// Represents a failure originating from a server (e.g., API errors).
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

/// Represents a failure originating from local cache operations.
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

/// Represents a failure due to network connectivity issues.
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

/// Represents a failure when a requested resource is not found.
class NotFoundFailure extends Failure {
  NotFoundFailure(String message) : super(message);
}

/// Represents an unexpected or unhandled failure.
class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}