// lib/features/product/domain/usecases/get_single_product_usecase.dart

import 'package:contracts_of_data_sources/core/entities/product.dart';
import 'package:contracts_of_data_sources/core/usecases/base_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/repositories/product_repository.dart';

class GetSingleProductUsecase extends BaseUseCase<Product?, String> {
  final ProductRepository repository;

  GetSingleProductUsecase(this.repository);

  @override
  Future<Product?> call(String id) {
    return repository.getProductById(id);
  }
}