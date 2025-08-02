// lib/features/product/data/repositories/product_repository_impl.dart

import '../../../../core/entities/product.dart';
import '../../../../core/network/network_info.dart'; // NEW
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart'; // NEW
import '../datasources/product_remote_data_source.dart'; // NEW
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo; // NEW

  // Constructor now takes data sources and network info as dependencies
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      final remoteProducts = await remoteDataSource.getAllProductModels();
      // Optionally, cache remote data locally here if needed
      // localDataSource.cacheAllProductModels(remoteProducts);
      return remoteProducts.map((model) => model.toEntity()).toList();
    } else {
      final localProducts = await localDataSource.getAllProductModels();
      return localProducts.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      final remoteProduct = await remoteDataSource.getProductModelById(id);
      return remoteProduct?.toEntity();
    } else {
      final localProduct = await localDataSource.getProductModelById(id);
      return localProduct?.toEntity();
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      await remoteDataSource.createProductModel(productModel);
    } else {
      // Handle offline creation, maybe queue for later sync
      await localDataSource.createProductModel(productModel);
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateProductModel(productModel);
    } else {
      // Handle offline update
      await localDataSource.updateProductModel(productModel);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteProductModel(id);
    } else {
      // Handle offline deletion
      await localDataSource.deleteProductModel(id);
    }
  }
}