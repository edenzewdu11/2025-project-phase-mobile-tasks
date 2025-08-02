// lib/features/product/data/datasources/product_remote_data_source_impl.dart

import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _productModels = [
    ProductModel(
      id: const Uuid().v4(),
      title: 'Gaming Laptop',
      description: 'High-performance laptop for demanding games and creative tasks.',
      imageUrl: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=2950&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 1800.00,
    ),
    ProductModel(
      id: const Uuid().v4(),
      title: 'Smartwatch Ultra',
      description: 'Advanced smartwatch with health tracking and GPS.',
      imageUrl: 'https://images.unsplash.com/photo-1620000713501-c88f28c2e0bb?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 350.00,
    ),
    ProductModel(
      id: const Uuid().v4(),
      title: 'Mechanical Keyboard',
      description: 'Tactile and responsive keyboard for typing and gaming.',
      imageUrl: 'https://images.unsplash.com/photo-1587820155099-0f01908d132c?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 130.00,
    ),
    ProductModel(
      id: const Uuid().v4(),
      title: '4K Monitor',
      description: 'High-resolution monitor for crisp visuals and productivity.',
      imageUrl: 'https://images.unsplash.com/photo-1586520261908-111c8a164132?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 450.00,
    ),
  ];

  final Uuid _uuid = const Uuid();

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _productModels;
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _productModels.firstWhere((model) => model.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newProductModel = product.copyWith(id: _uuid.v4());
    _productModels.add(newProductModel);
    print('RemoteDataSource: Product created: ${newProductModel.title} (ID: ${newProductModel.id})');
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _productModels.indexWhere((model) => model.id == product.id);
    if (index != -1) {
      _productModels[index] = product;
      print('RemoteDataSource: Product updated: ${product.title} (ID: ${product.id})');
    } else {
      throw Exception("RemoteDataSource: Product with ID ${product.id} not found for update.");
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final initialLength = _productModels.length;
    _productModels.removeWhere((model) => model.id == id);
    if (_productModels.length < initialLength) {
      print('RemoteDataSource: Product with ID $id deleted successfully.');
    } else {
      throw Exception("RemoteDataSource: Product with ID $id not found for deletion.");
    }
  }
}