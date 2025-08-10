import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase extends UseCase<Unit, ProductParams> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ProductParams params) async {
    return await repository.createProduct(params.product);
  }
}
