import '../../models/product.dart';
import '../repositories/product_repository.dart';
import './base/usecase.dart';

class CreateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.createProduct(product);
  }
}