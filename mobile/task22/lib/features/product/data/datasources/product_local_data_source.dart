import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProductList();
  Future<ProductModel> getProductById(String id);
  Future<void> cacheProductList(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

// ignore: constant_identifier_names
const CACHED_PRODUCT_LIST = 'CACHED_PRODUCT_LIST';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProductList() async {
    final productList = await _readCachedProductList();
    if (productList != null) {
      return productList;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final productList = await _readCachedProductList();

    if (productList != null) {
      try {
        return productList.firstWhere((product) => product.id == id);
      } catch (_) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProductList(List<ProductModel> products) async {
    await _writeProductListToCache(products);
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final currentList = await _readCachedProductList() ?? [];
    currentList.removeWhere((p) => p.id == product.id);
    currentList.add(product);
    await _writeProductListToCache(currentList);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final currentList = await _readCachedProductList();

    if (currentList != null) {
      final updatedList = currentList
          .where((product) => product.id != id)
          .toList();
      await _writeProductListToCache(updatedList);
    } else {
      throw CacheException();
    }
  }

  // 🔁 Reusable helper: Read list from cache
  Future<List<ProductModel>?> _readCachedProductList() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCT_LIST);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
    }
    return null;
  }

  // 🔁 Reusable helper: Write list to cache
  Future<void> _writeProductListToCache(List<ProductModel> products) async {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(CACHED_PRODUCT_LIST, jsonString);
  }
}
