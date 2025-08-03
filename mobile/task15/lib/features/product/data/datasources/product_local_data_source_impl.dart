// lib/features/product/data/datasources/product_local_data_source_impl.dart

import 'dart:convert'; // Required for json.encode/decode
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../models/product_model.dart';
import 'product_local_data_source.dart';

// Key for storing products in SharedPreferences
const String CACHED_PRODUCTS_KEY = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Constructor now takes SharedPreferences instance
  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      // Return empty list if no cached data
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    final List<ProductModel> products = await getAllProductModels();
    try {
      return products.firstWhere((model) => model.id == id);
    } catch (e) {
      return null; // Product not found locally
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    final List<ProductModel> products = await getAllProductModels();
    products.add(product); // Add new product
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(CACHED_PRODUCTS_KEY, jsonString);
    print('LocalDataSource: Product created and cached: ${product.title}');
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    final List<ProductModel> products = await getAllProductModels();
    final index = products.indexWhere((model) => model.id == product.id);
    if (index != -1) {
      products[index] = product; // Update existing product
      final jsonString = json.encode(products.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(CACHED_PRODUCTS_KEY, jsonString);
      print('LocalDataSource: Product updated and cached: ${product.title}');
    } else {
      throw Exception("LocalDataSource: Product with ID ${product.id} not found for update.");
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    final List<ProductModel> products = await getAllProductModels();
    final initialLength = products.length;
    products.removeWhere((model) => model.id == id); // Remove product
    if (products.length < initialLength) {
      final jsonString = json.encode(products.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(CACHED_PRODUCTS_KEY, jsonString);
      print('LocalDataSource: Product with ID $id deleted from cache.');
    } else {
      throw Exception("LocalDataSource: Product with ID $id not found for deletion.");
    }
  }
}