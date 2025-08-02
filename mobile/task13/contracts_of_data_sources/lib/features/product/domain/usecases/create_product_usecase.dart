// lib/features/product/domain/usecases/create_product_usecase.dart

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/entities/product.dart';

class CreateProductUsecase implements BaseUseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(Product params) async {
    return await repository.createProduct(params);
  }
}