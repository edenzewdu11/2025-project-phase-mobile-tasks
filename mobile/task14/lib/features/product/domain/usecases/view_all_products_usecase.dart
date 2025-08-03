// lib/features/product/domain/usecases/view_all_products_usecase.dart

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/entities/product.dart';

class ViewAllProductsUsecase implements BaseUseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}