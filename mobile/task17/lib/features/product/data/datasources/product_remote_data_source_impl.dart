// lib/features/product/data/datasources/product_remote_data_source_impl.dart

import 'package:contracts_of_data_sources/core/errors/exceptions.dart'; // Import custom exceptions
import 'package:contracts_of_data_sources/core/services/api_service.dart'; // Import ApiService
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService; // Dependency on ApiService

  ProductRemoteDataSourceImpl({required this.apiService});

  // Helper to convert JSONPlaceholder Post to ProductModel with English content
  ProductModel _postToProductModel(Map<String, dynamic> json) {
    // Generate English product data based on the ID
    final productId = int.tryParse(json['id'].toString()) ?? 0;
    
    // List of sample English product titles
    final List<String> englishTitles = [
      'Premium Smartphone',
      'Wireless Headphones',
      '4K Smart TV',
      'Laptop Pro',
      'Smart Watch',
      'Bluetooth Speaker',
      'Gaming Console',
      'Digital Camera',
      'Tablet Device',
      'Fitness Tracker'
    ];
    
    // List of sample English product descriptions
    final List<String> englishDescriptions = [
      'High-performance device with advanced features and long battery life.',
      'Crystal clear sound with noise cancellation technology.',
      'Ultra HD display with smart features and streaming apps.',
      'Powerful computing performance for work and entertainment.',
      'Track your fitness and stay connected with smart notifications.',
      'Portable speaker with deep bass and long battery life.',
      'Next-gen gaming experience with high-quality graphics.',
      'Capture your memories in stunning detail and clarity.',
      'Lightweight and portable for entertainment on the go.',
      'Monitor your health and daily activities with precision.'
    ];
    
    // Use the product ID to select a title and description, cycling through the lists
    final titleIndex = productId % englishTitles.length;
    final descIndex = productId % englishDescriptions.length;
    
    return ProductModel(
      id: json['id'].toString(),
      title: '${englishTitles[titleIndex]} ${productId + 1}', // Add ID to make titles unique
      description: englishDescriptions[descIndex],
      imageUrl: 'https://picsum.photos/300/200?random=$productId', // Random but consistent image
      price: 99.99 + (productId * 10.0), // Generate varying prices
    );
  }

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    try {
      final jsonList = await apiService.get('/posts'); // Use apiService.get
      // Take only the first 5 items and convert them to ProductModel
      return (jsonList as List).take(5).map((json) => _postToProductModel(json)).toList();
    } on AppException { // Catch specific app exceptions
      rethrow; // Re-throw them for repository to handle
    } catch (e) {
      throw UnknownException('Failed to get all products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    try {
      final jsonMap = await apiService.get('/posts/$id'); // Use apiService.get
      return _postToProductModel(jsonMap);
    } on NotFoundException {
      return null; // Return null if not found (as per contract)
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get product $id: ${e.toString()}');
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    try {
      await apiService.post( // Use apiService.post
        '/posts',
        {
          'title': product.title,
          'body': product.description,
          'userId': 1, // Dummy user ID for JSONPlaceholder
        },
      );
      print('RemoteDataSource: Product created successfully (simulated).');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    try {
      await apiService.put( // Use apiService.put
        '/posts/${product.id}',
        {
          'id': int.parse(product.id), // JSONPlaceholder expects int ID for posts
          'title': product.title,
          'body': product.description,
          'userId': 1, // Dummy user ID
        },
      );
      print('RemoteDataSource: Product updated successfully (simulated).');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    try {
      await apiService.delete('/posts/$id'); // Use apiService.delete
      print('RemoteDataSource: Product deleted successfully (simulated).');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete product: ${e.toString()}');
    }
  }
}