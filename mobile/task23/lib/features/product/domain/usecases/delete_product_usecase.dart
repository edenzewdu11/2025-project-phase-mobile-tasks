import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase extends UseCase<Unit, IdParams> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(IdParams params) async {
    return await repository.deleteProduct(params.id);
  }
}
