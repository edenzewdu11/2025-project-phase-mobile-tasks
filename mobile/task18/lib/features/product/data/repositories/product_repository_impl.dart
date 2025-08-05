// lib/features/product/data/repositories/product_repository_impl.dart

import 'package:contracts_of_data_sources/core/errors/exceptions.dart'; // Import exceptions
import 'package:contracts_of_data_sources/core/errors/failures.dart'; // Import failures
import 'package:contracts_of_data_sources/core/network/network_info.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
import 'package:contracts_of_data_sources/core/entities/product.dart'; // CORRECTED IMPORT PATH
import 'package:contracts_of_data_sources/features/product/domain/repositories/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProductModels();
        await localDataSource.cacheProductModels(remoteProducts); // Cache on success
        return remoteProducts;
      } on ServerException catch (e) {
        throw ServerFailure(e.message); // Map to ServerFailure
      } on NetworkException catch (e) {
        throw NetworkFailure(e.message); // Map to NetworkFailure
      } on NotFoundException catch (e) {
        throw NotFoundFailure(e.message); // Map to NotFoundFailure
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred: ${e.toString()}');
      }
    } else {
      try {
        final localProducts = await localDataSource.getAllProductModels();
        if (localProducts.isNotEmpty) {
          return localProducts;
        } else {
          // If no network and no local data, this is still a network issue
          throw NetworkFailure('No internet connection and no cached data available.');
        }
      } on CacheException catch (e) {
        throw CacheFailure(e.message); // Map to CacheFailure
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred during local data access: ${e.toString()}');
      }
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductModelById(id);
        // We don't necessarily cache single product lookups aggressively unless needed.
        return remoteProduct;
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on NetworkException catch (e) {
        throw NetworkFailure(e.message);
      } on NotFoundException {
        return null; // Explicitly return null if not found on server
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred: ${e.toString()}');
      }
    } else {
      try {
        final localProduct = await localDataSource.getProductModelById(id);
        return localProduct; // Returns null if not found locally
      } on CacheException catch (e) {
        throw CacheFailure(e.message);
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred during local data access: ${e.toString()}');
      }
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createProductModel(productModel);
        // For simplicity, we assume remote success implies local consistency
        // A more robust solution might re-fetch all products or update local cache specifically.
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on NetworkException catch (e) {
        throw NetworkFailure(e.message);
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection to create product remotely.');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProductModel(productModel);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on NetworkException catch (e) {
        throw NetworkFailure(e.message);
      } on NotFoundException catch (e) {
        throw NotFoundFailure(e.message);
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection to update product remotely.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProductModel(id);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on NetworkException catch (e) {
        throw NetworkFailure(e.message);
      } on NotFoundException catch (e) {
        throw NotFoundFailure(e.message);
      } on Exception catch (e) {
        throw UnknownFailure('An unexpected error occurred: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection to delete product remotely.');
    }
  }
}