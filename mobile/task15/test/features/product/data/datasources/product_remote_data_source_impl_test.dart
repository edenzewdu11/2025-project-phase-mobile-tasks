// test/features/product/data/datasources/product_remote_data_source_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  
  setUp(() {
    dataSource = ProductRemoteDataSourceImpl(client: http.Client());
  });

  // Test data
  final tProduct1 = ProductModel(
    id: '1',
    title: 'Test Product 1',
    description: 'Description 1',
    imageUrl: 'http://test.com/1.jpg',
    price: 99.99,
  );

  final tProduct2 = ProductModel(
    id: '2',
    title: 'Test Product 2',
    description: 'Description 2',
    imageUrl: 'http://test.com/2.jpg',
    price: 199.99,
  );

  group('getAllProductModels', () {
    test('should return a list of products', () async {
      // Act
      final result = await dataSource.getAllProductModels();
      
      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.isNotEmpty, true);
      expect(result[0], isA<ProductModel>());
    });
  });

  group('getProductModelById', () {
    test('should return a product when it exists', () async {
      // Act
      final result = await dataSource.getProductModelById('1');
      
      // Assert
      expect(result, isNotNull);
      expect(result?.id, '1');
    });

    test('should return null when product does not exist', () async {
      // Act
      final result = await dataSource.getProductModelById('999');
      
      // Assert
      expect(result, isNull);
    });
  });

  group('createProductModel', () {
    final tProductModelToCreate = ProductModel(
      id: '', // ID will be assigned
      title: 'New Product',
      description: 'A brand new product.',
      imageUrl: 'http://new.com/image.jpg',
      price: 50.0,
    );

    test('should add a new product', () async {
      // Act
      await dataSource.createProductModel(tProductModelToCreate);
      
      // Get all products to verify
      final products = await dataSource.getAllProductModels();
      
      // Assert
      expect(products.any((p) => p.title == 'New Product'), isTrue);
    });
  });

  group('updateProductModel', () {
    final tProductModelToUpdate = ProductModel(
      id: '1',
      title: 'Updated Product',
      description: 'Updated Description',
      imageUrl: 'http://updated.com/image.jpg',
      price: 120.0,
    );

    test('should update an existing product', () async {
      // Act
      await dataSource.updateProductModel(tProductModelToUpdate);
      
      // Get the updated product
      final updatedProduct = await dataSource.getProductModelById('1');
      
      // Assert
      expect(updatedProduct?.title, 'Updated Product');
      expect(updatedProduct?.description, 'Updated Description');
    });

    test('should throw when product does not exist', () async {
      // Arrange
      final nonExistentProduct = ProductModel(
        id: '999',
        title: 'Non-existent',
        description: 'This should not exist',
        imageUrl: 'http://test.com/999.jpg',
        price: 0.0,
      );
      
      // Act & Assert
      expect(
        () => dataSource.updateProductModel(nonExistentProduct),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteProductModel', () {
    test('should delete an existing product', () async {
      // Arrange
      final initialProducts = await dataSource.getAllProductModels();
      final initialCount = initialProducts.length;
      
      // Act
      await dataSource.deleteProductModel('1');
      
      // Get all products after deletion
      final productsAfterDeletion = await dataSource.getAllProductModels();
      
      // Assert
      expect(productsAfterDeletion.length, initialCount - 1);
      expect(productsAfterDeletion.any((p) => p.id == '1'), isFalse);
    });

    test('should throw when product does not exist', () async {
      // Act & Assert
      expect(
        () => dataSource.deleteProductModel('999'),
        throwsA(isA<Exception>()),
      );
    });
  });
}