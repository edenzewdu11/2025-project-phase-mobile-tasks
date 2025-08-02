// lib/features/product/data/datasources/product_remote_data_source.dart

import '../../data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProductModels();
  Future<ProductModel?> getProductModelById(String id);
  Future<void> createProductModel(ProductModel product);
  Future<void> updateProductModel(ProductModel product);
  Future<void> deleteProductModel(String id);
}