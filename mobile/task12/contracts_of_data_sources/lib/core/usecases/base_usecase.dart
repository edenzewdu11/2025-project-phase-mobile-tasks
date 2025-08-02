// lib/core/usecases/base_usecase.dart

abstract class BaseUseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {} // For use cases that don't require any parameters