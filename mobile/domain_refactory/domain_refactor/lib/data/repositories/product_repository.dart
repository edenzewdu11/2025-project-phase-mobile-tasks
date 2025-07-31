import 'package:uuid/uuid.dart'; // Make sure you've added uuid to your pubspec.yaml

import '../../models/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Simulates an in-memory database or a remote data source
  // In a real application, this would interact with an API, database, etc.
  final List<Product> _products = [
    Product(
      id: const Uuid().v4(),
      title: 'Gaming Laptop',
      description: 'High-performance laptop for demanding games and creative tasks.',
      imageUrl: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=2950&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 1800.00,
    ),
    Product(
      id: const Uuid().v4(),
      title: 'Smartwatch Ultra',
      description: 'Advanced smartwatch with health tracking and GPS.',
      imageUrl: 'https://images.unsplash.com/photo-1620000713501-c88f28c2e0bb?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 350.00,
    ),
    Product(
      id: const Uuid().v4(),
      title: 'Wireless Headphones',
      description: 'Noise-cancelling headphones for immersive audio experience.',
      imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf4727?q=80&w=2952&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 250.00,
    ),
    Product(
      id: const Uuid().v4(),
      title: 'Mechanical Keyboard',
      description: 'Tactile and responsive keyboard for typing and gaming.',
      imageUrl: 'https://images.unsplash.com/photo-1587820155099-0f01908d132c?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 130.00,
    ),
    Product(
      id: const Uuid().v4(),
      title: '4K Monitor',
      description: 'High-resolution monitor for crisp visuals and productivity.',
      imageUrl: 'https://images.unsplash.com/photo-1586520261908-111c8a164132?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: 450.00,
    ),
  ];

  final Uuid _uuid = const Uuid();

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate network delay or database fetch
    await Future.delayed(const Duration(milliseconds: 700));
    return List.from(_products); // Return a copy to prevent external modification
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null; // Product not found
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Assign a new unique ID before adding (assuming ID is generated server-side or locally)
    final newProduct = product.copyWith(id: _uuid.v4());
    _products.add(newProduct);
    print('Product created: ${newProduct.title} (ID: ${newProduct.id})');
  }

  @override
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product; // Replace with the updated product
      print('Product updated: ${product.title} (ID: ${product.id})');
    } else {
      throw Exception("Product with ID ${product.id} not found for update.");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    if (_products.length < initialLength) {
      print('Product with ID $id deleted successfully.');
    } else {
      throw Exception("Product with ID $id not found for deletion.");
    }
  }
}