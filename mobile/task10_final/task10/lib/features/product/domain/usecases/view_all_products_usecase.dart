import '../../../../core/entities/product.dart';
import '../../../../core/usecases/base_usecase.dart'; // Updated import
import '../repositories/product_repository.dart';

class ViewAllProductsUsecase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}