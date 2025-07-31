import '../../models/product.dart';
import '../repositories/product_repository.dart';
import './base/usecase.dart';

class UpdateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.updateProduct(product);
  }
}