// lib/features/product/domain/usecases/update_product_usecase.dart

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/entities/product.dart';

class UpdateProductUsecase implements BaseUseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(Product params) async {
    return await repository.updateProduct(params);
  }
}