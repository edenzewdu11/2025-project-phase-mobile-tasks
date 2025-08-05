// lib/features/product/data/datasources/product_remote_data_source.dart

import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
// You might also need to import your custom exceptions if they are thrown here
// For example: import 'package:contracts_of_data_sources/core/errors/exceptions.dart';

/// Contract for remote data source operations for products.
/// This defines the API that the data layer can use to interact with remote data sources.
abstract class ProductRemoteDataSource {
  /// Fetches all products from the remote data source.
  /// Returns a list of [ProductModel] if the call is successful.
  /// Throws a [ServerException] for all error cases.
  Future<List<ProductModel>> getAllProductModels();

  /// Fetches a single product by its [id] from the remote data source.
  /// Returns the [ProductModel] if found, or null if not found.
  /// Throws a [ServerException] for all error cases.
  Future<ProductModel?> getProductModelById(String id);

  /// Creates a new product in the remote data source.
  /// Returns the created [ProductModel] if successful.
  /// Throws a [ServerException] for all error cases.
  Future<void> createProductModel(ProductModel product); // MODIFIED: returns Future<void>

  /// Updates an existing product in the remote data source.
  /// Returns the updated [ProductModel] if successful.
  /// Throws a [ServerException] for all error cases.
  Future<void> updateProductModel(ProductModel product); // MODIFIED: returns Future<void>

  /// Deletes a product from the remote data source by its [id].
  /// Throws a [ServerException] for all error cases.
  Future<void> deleteProductModel(String id);
}