// lib/features/product/data/datasources/product_local_data_source_impl.dart

import 'dart:convert';
import 'package:contracts_of_data_sources/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';
import 'package:uuid/uuid.dart'; // ADDED

const String CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Uuid uuid; // ADDED

  ProductLocalDataSourceImpl({required this.sharedPreferences, Uuid? uuid})
      : uuid = uuid ?? const Uuid(); // MODIFIED: Initialize uuid

  @override
  Future<void> cacheProductModels(List<ProductModel> products) {
    try {
      final String jsonString =
          json.encode(products.map((p) => p.toJson()).toList());
      return sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache products: $e');
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    try {
      // For local, generate a UUID for new products if not already set
      final newProduct = product.copyWith(id: product.id.isEmpty ? uuid.v4() : product.id);
      final List<ProductModel> existingProducts = await getAllProductModels();
      existingProducts.add(newProduct);
      return cacheProductModels(existingProducts);
    } catch (e) {
      throw CacheException('Failed to create product locally: $e');
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    try {
      List<ProductModel> products = await getAllProductModels();
      products.removeWhere((p) => p.id == id);
      return cacheProductModels(products);
    } catch (e) {
      throw CacheException('Failed to delete product locally: $e');
    }
  }

  @override
  Future<List<ProductModel>> getAllProductModels() {
    try {
      final String? jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return Future.value(jsonList.map((json) => ProductModel.fromJson(json)).toList());
      } else {
        return Future.value([]); // Return empty list if no cached data
      }
    } catch (e) {
      throw CacheException('Failed to retrieve cached products: $e');
    }
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    try {
      final List<ProductModel> products = await getAllProductModels();
      try { // Use a nested try-catch for firstWhere to distinguish not found from other errors
        return products.firstWhere((p) => p.id == id);
      } on StateError { // Catch StateError if firstWhere finds no element
        return null; // Product not found locally
      }
    } catch (e) {
      throw CacheException('Failed to get product $id locally: $e');
    }
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    try {
      List<ProductModel> products = await getAllProductModels();
      int index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        return cacheProductModels(products);
      } else {
        throw CacheException('Product with ID ${product.id} not found for update locally.');
      }
    } catch (e) {
      throw CacheException('Failed to update product locally: $e');
    }
  }
}