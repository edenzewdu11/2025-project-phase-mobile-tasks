// lib/features/product/data/datasources/product_local_data_source.dart

import '../../data/models/product_model.dart';

/// Contract for local data source operations for products.
/// This defines the API that the data layer can use to interact with local storage.
abstract class ProductLocalDataSource {
  /// Retrieves all cached product models.
  Future<List<ProductModel>> getAllProductModels();

  /// Retrieves a single product model by its [id] from the cache.
  Future<ProductModel?> getProductModelById(String id);

  /// Creates a new product in the cache.
  Future<void> createProductModel(ProductModel product);

  /// Updates an existing product in the cache.
  Future<void> updateProductModel(ProductModel product);

  /// Deletes a product from the cache by its [id].
  Future<void> deleteProductModel(String id);
  
  /// Caches a list of [ProductModel] instances.
  /// This should replace any existing cache with the new list of products.
  Future<void> cacheProductModels(List<ProductModel> products);
}