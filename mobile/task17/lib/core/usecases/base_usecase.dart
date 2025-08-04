// lib/core/usecases/base_usecase.dart

import 'package:equatable/equatable.dart'; // ADDED for NoParams

abstract class BaseUseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}