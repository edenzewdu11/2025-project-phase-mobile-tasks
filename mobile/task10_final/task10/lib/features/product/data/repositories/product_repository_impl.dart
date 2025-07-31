// lib/features/product/data/repositories/product_repository_impl.dart

import 'package:uuid/uuid.dart'; // Ensure uuid package is added to pubspec.yaml

import '../../../../core/entities/product.dart'; // <--- VERIFY THIS PATH!
import '../../domain/repositories/product_repository.dart'; // <--- VERIFY THIS PATH!
import '../models/product_model.dart'; // <--- VERIFY THIS PATH!

class ProductRepositoryImpl implements ProductRepository {
  // Simulates an in-memory database or a remote data source
  // Now stores ProductModel objects internally
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

  final Uuid _uuid = const Uuid(); // Initialize Uuid for unique IDs

  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 700)); // Simulate network delay
    return _productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final productModel = _productModels.firstWhere((model) => model.id == id);
      return productModel.toEntity();
    } catch (e) {
      return null; // Product not found
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Create a new ProductModel from the entity and assign a unique ID
    final newProductModel = ProductModel.fromEntity(product).copyWith(id: _uuid.v4());
    _productModels.add(newProductModel);
    print('Product created: ${newProductModel.title} (ID: ${newProductModel.id})');
  }

  @override
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _productModels.indexWhere((model) => model.id == product.id);
    if (index != -1) {
      _productModels[index] = ProductModel.fromEntity(product); // Update existing model
      print('Product updated: ${product.title} (ID: ${product.id})');
    } else {
      throw Exception("Product with ID ${product.id} not found for update.");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final initialLength = _productModels.length;
    _productModels.removeWhere((model) => model.id == id);
    if (_productModels.length < initialLength) {
      print('Product with ID $id deleted successfully.');
    } else {
      throw Exception("Product with ID $id not found for deletion.");
    }
  }
}