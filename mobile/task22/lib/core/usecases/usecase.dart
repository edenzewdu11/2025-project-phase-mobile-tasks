import 'package:dartz/dartz.dart';
import '../error/failure.dart';

/// Base UseCase class with generics for flexible input and output types.
/// Enforces a `call` method to keep use cases consistent.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
