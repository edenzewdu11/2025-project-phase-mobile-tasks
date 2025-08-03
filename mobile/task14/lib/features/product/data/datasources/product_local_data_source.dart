// lib/features/product/data/datasources/product_local_data_source.dart

import '../../data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProductModels();
  Future<ProductModel?> getProductModelById(String id);
  Future<void> createProductModel(ProductModel product);
  Future<void> updateProductModel(ProductModel product);
  Future<void> deleteProductModel(String id);
}