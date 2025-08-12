import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}
