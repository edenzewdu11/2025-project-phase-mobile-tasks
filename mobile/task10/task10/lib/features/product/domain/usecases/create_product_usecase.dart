import '../../../../core/entities/product.dart';
import '../../../../core/usecases/base_usecase.dart'; // Updated import
import '../repositories/product_repository.dart';

class CreateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.createProduct(product);
  }
}