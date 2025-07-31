// Abstract base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Special class for use cases that don't require parameters
class NoParams {}