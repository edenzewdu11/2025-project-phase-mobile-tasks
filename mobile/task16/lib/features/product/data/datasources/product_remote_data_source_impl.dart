// lib/features/product/data/datasources/product_remote_data_source_impl.dart

// ... imports ...
import 'package:contracts_of_data_sources/core/errors/exceptions.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;
  final List<Map<String, dynamic>> _products = [];

  ProductRemoteDataSourceImpl({required this.apiService}) {
    // Initialize with sample data
    _products.addAll([
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
        'description': 'Latest model smartphone with advanced camera features',
        'imageUrl': 'https://via.placeholder.com/150/0000FF?text=Smartphone',
        'price': 699.99,
      },
      {
        'id': '3',
        'title': 'Laptop',
        'description': 'Powerful laptop for work and entertainment',
        'imageUrl': 'https://via.placeholder.com/150/FF0000?text=Laptop',
        'price': 999.99,
      },
      {
        'id': '4',
        'title': 'Smart Watch',
        'description': 'Fitness tracking and smart notifications',
        'imageUrl': 'https://via.placeholder.com/150/FFFF00?text=Smart+Watch',
        'price': 199.99,
      },
      {
        'id': '5',
        'title': 'Bluetooth Speaker',
        'description': 'Portable speaker with 12-hour battery life',
        'imageUrl': 'https://via.placeholder.com/150/FF00FF?text=Speaker',
        'price': 79.99,
      },
    ]);
  }

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    try {
      // In a real app, you would call the API here
      // final response = await apiService.get('/products');
      // return (response as List).map((json) => ProductModel.fromJson(json)).toList();
      
      // For now, return the sample data
      return _products.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw UnknownException('Failed to get all products: $e');
    }
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    try {
      // In a real app, you would call the API here
      // final response = await apiService.get('/products/$id');
      // return ProductModel.fromJson(response);
      
      // For now, use the sample data
      final product = _products.firstWhere(
        (product) => product['id'] == id,
        orElse: () => throw NotFoundException('Product not found'),
      );
      return ProductModel.fromJson(product);
    } on NotFoundException {
      return null;
    } catch (e) {
      throw UnknownException('Failed to get product $id: $e');
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    try {
      // In a real app, you would call the API here
      // await apiService.post('/products', product.toJson());
      
      // For now, add to the local list
      _products.add(product.toJson());
    } catch (e) {
      throw UnknownException('Failed to create product: $e');
    }
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    try {
      // In a real app, you would call the API here
      // await apiService.put('/products/${product.id}', product.toJson());
      
      // For now, update in the local list
      final index = _products.indexWhere((p) => p['id'] == product.id);
      if (index != -1) {
        _products[index] = product.toJson();
      } else {
        throw NotFoundException('Product not found');
      }
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    try {
      // In a real app, you would call the API here
      // await apiService.delete('/products/$id');
      
      // For now, remove from the local list
      _products.removeWhere((product) => product['id'] == id);
    } catch (e) {
      throw UnknownException('Failed to delete product: $e');
    }
  }
}