// lib/features/product/data/datasources/product_local_data_source_impl.dart

import '../models/product_model.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final List<ProductModel> _localProductModels = []; // In-memory local storage

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _localProductModels;
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _localProductModels.firstWhere((model) => model.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _localProductModels.add(product);
    print('LocalDataSource: Product created: ${product.title}');
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _localProductModels.indexWhere((model) => model.id == product.id);
    if (index != -1) {
      _localProductModels[index] = product;
      print('LocalDataSource: Product updated: ${product.title}');
    } else {
      throw Exception("LocalDataSource: Product with ID ${product.id} not found for update.");
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final initialLength = _localProductModels.length;
    _localProductModels.removeWhere((model) => model.id == id);
    if (_localProductModels.length < initialLength) {
      print('LocalDataSource: Product with ID $id deleted successfully.');
    } else {
      throw Exception("LocalDataSource: Product with ID $id not found for deletion.");
    }
  }
}