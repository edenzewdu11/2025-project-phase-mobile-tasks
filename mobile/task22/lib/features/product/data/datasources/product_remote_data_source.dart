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

    final imageFile = File(product.imageUrl);
    if (!await imageFile.exists()) {
      throw Exception('Image file not found at path: ${imageFile.path}');
    }

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _getRequest(Uri.parse(_baseUrl));
    final Map<String, dynamic> decoded = json.decode(response.body);
    final List<dynamic> jsonList = decoded['data'];

    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _getRequest(Uri.parse('$_baseUrl/$id'));
    final Map<String, dynamic> decoded = json.decode(response.body);
    return ProductModel.fromJson(decoded['data']);
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
