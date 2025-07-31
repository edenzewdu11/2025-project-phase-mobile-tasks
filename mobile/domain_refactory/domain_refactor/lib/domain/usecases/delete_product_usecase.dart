import '../repositories/product_repository.dart';
import './base/usecase.dart';

class DeleteProductUsecase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String productId) async {
    await repository.deleteProduct(productId);
  }
}