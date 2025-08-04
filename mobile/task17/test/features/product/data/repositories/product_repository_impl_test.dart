// test/features/product/data/datasources/product_local_data_source_impl_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contracts_of_data_sources/core/errors/exceptions.dart'; // ADDED
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
import 'package:uuid/uuid.dart'; // ADDED

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockUuid extends Mock implements Uuid {} // ADDED

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  late MockUuid mockUuid; // ADDED

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockUuid = MockUuid(); // ADDED
    dataSource = ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences, uuid: mockUuid); // MODIFIED
  });

  // Test data
  const tProductModel = ProductModel(
    id: '1',
    title: 'Test Product',
    description: 'Test Description',
    imageUrl: 'http://test.com/image.jpg',
    price: 100.0,
  );
  final tProductModelList = [tProductModel];
  final tProductModelJsonList = [tProductModel.toJson()];
  final tProductModelJsonString = json.encode(tProductModelJsonList);


  group('getAllProductModels', () {
    test('should return List<ProductModel> from SharedPreferences when data is present', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(tProductModelJsonString);

      // Act
      final result = await dataSource.getAllProductModels();

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      expect(result, equals(tProductModelList));
    });

    test('should return an empty list from SharedPreferences when no data is present', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(null);

      // Act
      final result = await dataSource.getAllProductModels();

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      expect(result, isEmpty);
    });

    test('should throw CacheException when getting products fails', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenThrow(Exception('Failed to read from cache'));

      // Act & Assert
      expect(() => dataSource.getAllProductModels(), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
    });
  });

  group('getProductModelById', () {
    test('should return ProductModel from SharedPreferences if found', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(tProductModelJsonString);

      // Act
      final result = await dataSource.getProductModelById('1');

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      expect(result, equals(tProductModel));
    });

    test('should return null from SharedPreferences if not found', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(json.encode([])); // Empty list

      // Act
      final result = await dataSource.getProductModelById('non_existent_id');

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      expect(result, isNull);
    });

    test('should throw CacheException when getting product by ID fails', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenThrow(Exception('Failed to read from cache'));

      // Act & Assert
      expect(() => dataSource.getProductModelById('1'), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
    });
  });

  group('createProductModel', () {
    final productToCreate = ProductModel(
      id: '', // Empty ID, will be generated
      title: 'New Local Product',
      description: 'New Description',
      imageUrl: 'http://new.com/new.jpg',
      price: 200.0,
    );
    final generatedId = 'generated-uuid-123';
    final productWithGeneratedId = productToCreate.copyWith(id: generatedId);

    test('should add a new product to SharedPreferences with generated ID', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(json.encode([])); // Start with empty cache
      when(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any()))
          .thenAnswer((_) async => true); // Mock setString success
      when(() => mockUuid.v4()).thenReturn(generatedId); // Mock UUID generation

      // Act
      await dataSource.createProductModel(productToCreate);

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verify(() => mockSharedPreferences.setString(CACHED_PRODUCTS, json.encode([productWithGeneratedId.toJson()]))).called(1);
      verify(() => mockUuid.v4()).called(1);
    });

    test('should throw CacheException when creating product fails', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenThrow(Exception('Failed to read from cache'));
      when(() => mockUuid.v4()).thenReturn(generatedId);

      // Act & Assert
      expect(() => dataSource.createProductModel(productToCreate), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });
  });

  group('updateProductModel', () {
    final updatedProductModel = tProductModel.copyWith(title: 'Updated Title');

    test('should update an existing product in SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(tProductModelJsonString); // Cache contains original product
      when(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any()))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.updateProductModel(updatedProductModel);

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verify(() => mockSharedPreferences.setString(CACHED_PRODUCTS, json.encode([updatedProductModel.toJson()]))).called(1);
    });

    test('should throw CacheException if product to update is not found', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(json.encode([])); // Empty cache

      // Act & Assert
      expect(() => dataSource.updateProductModel(updatedProductModel),
          throwsA(isA<CacheException>().having((e) => e.message, 'message', contains('not found for update locally'))));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });

    test('should throw CacheException when updating product fails', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenThrow(Exception('Failed to read from cache'));

      // Act & Assert
      expect(() => dataSource.updateProductModel(updatedProductModel), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });
  });

  group('deleteProductModel', () {
    test('should delete a product from SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(tProductModelJsonString); // Cache contains product
      when(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any()))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.deleteProductModel('1');

      // Assert
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verify(() => mockSharedPreferences.setString(CACHED_PRODUCTS, json.encode([]))).called(1); // Should be empty list
    });

    test('should throw CacheException if product to delete is not found', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(json.encode([])); // Empty cache

      // Act & Assert
      expect(() => dataSource.deleteProductModel('non_existent_id'),
          throwsA(isA<CacheException>().having((e) => e.message, 'message', contains('not found for deletion'))));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });

    test('should throw CacheException when deleting product fails', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenThrow(Exception('Failed to read from cache'));

      // Act & Assert
      expect(() => dataSource.deleteProductModel('1'), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS)).called(1);
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });
  });

  group('cacheProductModels', () {
    test('should call setString on SharedPreferences to cache data', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any()))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheProductModels(tProductModelList);

      // Assert
      verify(() => mockSharedPreferences.setString(CACHED_PRODUCTS, tProductModelJsonString)).called(1);
    });

    test('should throw CacheException when caching products fails', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any()))
          .thenThrow(Exception('Failed to write to cache'));

      // Act & Assert
      expect(() => dataSource.cacheProductModels(tProductModelList), throwsA(isA<CacheException>()));
      verify(() => mockSharedPreferences.setString(CACHED_PRODUCTS, any())).called(1);
    });
  });
}