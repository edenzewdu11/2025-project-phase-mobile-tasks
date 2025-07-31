import '../../../../core/usecases/base_usecase.dart'; // Updated import
import '../repositories/product_repository.dart';

class DeleteProductUsecase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String productId) async {
    await repository.deleteProduct(productId);
  }
}