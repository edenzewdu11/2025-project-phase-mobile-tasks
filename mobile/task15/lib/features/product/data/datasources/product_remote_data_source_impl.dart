// lib/features/product/data/datasources/product_remote_data_source_impl.dart

import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  // List of hardcoded English products
  final List<Map<String, dynamic>> _englishProducts = [
    {
      'id': '1',
      'title': 'Wireless Headphones',
      'description': 'High-quality wireless headphones with noise cancellation',
      'imageUrl': 'https://via.placeholder.com/150/00FF00?text=Headphones',
      'price': 99.99,
    },
    {
      'id': '2',
      'title': 'Smartphone',
      'description': 'Latest model smartphone with advanced features',
      'imageUrl': 'https://via.placeholder.com/150/0000FF?text=Smartphone',
      'price': 699.99,
    },
    {
      'id': '3',
      'title': 'Laptop',
      'description': 'Powerful laptop for work and entertainment',
      'imageUrl': 'https://via.placeholder.com/150/FF0000?text=Laptop',
      'price': 1299.99,
    },
    {
      'id': '4',
      'title': 'Smart Watch',
      'description': 'Feature-rich smartwatch with health monitoring',
      'imageUrl': 'https://via.placeholder.com/150/FFFF00?text=Smartwatch',
      'price': 199.99,
    },
  ];

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _englishProducts
        .map((product) => ProductModel(
              id: product['id'].toString(),
              title: product['title'],
              description: product['description'],
              imageUrl: product['imageUrl'],
              price: product['price'],
            ))
        .toList();
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final product = _englishProducts.firstWhere(
        (p) => p['id'].toString() == id,
      );
      return ProductModel(
        id: product['id'].toString(),
        title: product['title'],
        description: product['description'],
        imageUrl: product['imageUrl'],
        price: product['price'],
      );
    } catch (e) {
      return null; // Product not found
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Add new product to the list
    _englishProducts.add({
      'id': (_englishProducts.length + 1).toString(),
      'title': product.title,
      'description': product.description,
      'imageUrl': 'https://via.placeholder.com/150/CCCCCC?text=New+Product',
      'price': product.price,
    });
    
    print('Product created successfully (simulated).');
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _englishProducts.indexWhere((p) => p['id'] == product.id);
    if (index != -1) {
      _englishProducts[index] = {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'imageUrl': _englishProducts[index]['imageUrl'], // Keep existing image
        'price': product.price,
      };
      print('Product updated successfully (simulated).');
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final initialLength = _englishProducts.length;
    _englishProducts.removeWhere((p) => p['id'] == id);
    
    if (_englishProducts.length < initialLength) {
      print('Product deleted successfully (simulated).');
    } else {
      throw Exception('Product not found');
    }
  }
}