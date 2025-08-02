// lib/features/product/domain/usecases/delete_product_usecase.dart

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/repositories/product_repository.dart';

class DeleteProductUsecase implements BaseUseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String params) async {
    return await repository.deleteProduct(params);
  }
}