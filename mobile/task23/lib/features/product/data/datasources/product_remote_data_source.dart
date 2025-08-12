import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

// ✅ Constants for endpoints
const String _baseUrl =
    'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  // ✅ Unified GET handler
  Future<http.Response> _getRequest(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException();
    }
  }

  // ✅ Unified PUT handler
  Future<void> _putRequest(Uri url, Map<String, dynamic> body) async {
    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  // ✅ Unified DELETE handler
  Future<void> _deleteRequest(Uri url) async {
    final response = await client.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  // ✅ Multipart request for file upload
  Future<void> _postMultipartProduct(ProductModel product) async {
    final uri = Uri.parse(_baseUrl);

    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = product.name
      ..fields['description'] = product.description
      ..fields['price'] = product.price.toString();

    // Check if imageUrl is a local file path or a URL
    if (product.imageUrl.startsWith('http://') || product.imageUrl.startsWith('https://')) {
      // It's a URL, don't add as file
      print('Image URL detected, skipping file upload: ${product.imageUrl}');
    } else {
      // It's a local file path
      try {
        final imageFile = File(product.imageUrl);
        if (await imageFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
          print('Local image file added: ${imageFile.path}');
        } else {
          print('Local image file not found: ${imageFile.path}');
        }
      } catch (e) {
        print('Error handling local image file: $e');
      }
    }

    print('Sending request to: $uri');
    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // Try to get products from API first
      final response = await _getRequest(Uri.parse(_baseUrl));
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> jsonList = decoded['data'];

      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      print('API call failed, returning mock products: $e');
      // Return mock products if API fails
      return _getMockProducts();
    }
  }

  // Mock products for demo purposes
  List<ProductModel> _getMockProducts() {
    return [
      // Phones
      const ProductModel(
        id: '1',
        name: 'iPhone 15 Pro',
        price: 999.99,
        description: 'Latest iPhone with A17 Pro chip, titanium design, and pro camera system',
        imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '2',
        name: 'Samsung Galaxy S24',
        price: 799.99,
        description: 'Premium Android phone with AI features and stunning display',
        imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '3',
        name: 'Google Pixel 8',
        price: 699.99,
        description: 'Best camera phone with Google AI and clean Android experience',
        imageUrl: 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=400&h=400&fit=crop',
      ),
      
      // Shoes
      const ProductModel(
        id: '4',
        name: 'Nike Air Max 270',
        price: 150.00,
        description: 'Comfortable running shoes with Air Max technology and stylish design',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '5',
        name: 'Adidas Ultraboost 22',
        price: 180.00,
        description: 'Premium running shoes with responsive cushioning and energy return',
        imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '6',
        name: 'Converse Chuck Taylor',
        price: 65.00,
        description: 'Classic canvas sneakers perfect for casual wear and street style',
        imageUrl: 'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=400&h=400&fit=crop',
      ),
      
      // Clothes
      const ProductModel(
        id: '7',
        name: 'Premium Cotton T-Shirt',
        price: 29.99,
        description: 'Soft, breathable cotton t-shirt available in multiple colors',
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '8',
        name: 'Denim Jacket',
        price: 89.99,
        description: 'Classic denim jacket with modern fit and comfortable stretch fabric',
        imageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400&h=400&fit=crop',
      ),
      const ProductModel(
        id: '9',
        name: 'Hooded Sweatshirt',
        price: 49.99,
        description: 'Warm and cozy hoodie perfect for casual and athletic wear',
        imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f51209cc?w=400&h=400&fit=crop',
      ),
    ];
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _getRequest(Uri.parse('$_baseUrl/$id'));
      final Map<String, dynamic> decoded = json.decode(response.body);
      return ProductModel.fromJson(decoded['data']);
    } catch (e) {
      print('API call failed for product $id, returning mock product: $e');
      // Return mock product if API fails
      final mockProducts = _getMockProducts();
      final product = mockProducts.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      return product;
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await _postMultipartProduct(product);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _putRequest(Uri.parse('$_baseUrl/${product.id}'), {
      'name': product.name,
      'description': product.description,
      'price': product.price,
    });
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _deleteRequest(Uri.parse('$_baseUrl/$id'));
  }
}
