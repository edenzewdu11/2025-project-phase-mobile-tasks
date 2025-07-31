import '../../../../core/entities/product.dart';
import '../../../../core/usecases/base_usecase.dart'; // Updated import
import '../repositories/product_repository.dart';

class ViewProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(String productId) async {
    return await repository.getProductById(productId);
  }
}