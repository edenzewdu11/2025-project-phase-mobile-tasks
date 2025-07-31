import '../../../../core/entities/product.dart';
import '../../../../core/usecases/base_usecase.dart'; // Updated import
import '../repositories/product_repository.dart';

class UpdateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.updateProduct(product);
  }
}