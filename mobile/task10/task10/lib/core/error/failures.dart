// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure &&
      other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// Represents a failure when data cannot be retrieved or found.
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// Represents a failure due to network connectivity issues.
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

// Represents a failure when an item is not found (e.g., product by ID).
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

// Represents a failure due to invalid input data.
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}

// Add more specific failure types as needed (e.g., AuthFailure, ValidationFailure)