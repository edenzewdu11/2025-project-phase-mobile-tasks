// test/features/product/data/datasources/product_remote_data_source_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:contracts_of_data_sources/core/errors/exceptions.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';

// Mock ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    dataSource = ProductRemoteDataSourceImpl(apiService: mockApiService);
  });

  // Test data
  final tProductJson = {
    'id': '1',
    'title': 'Test Product',
    'description': 'Test Description',
    'imageUrl': 'http://test.com/image.jpg',
    'price': 99.99,
  };
  
  final tProductList = [tProductJson, {
    'id': '2',
    'title': 'Another Product',
    'description': 'Another Description',
    'imageUrl': 'http://test.com/another.jpg',
    'price': 199.99,
  }];
  
  final tProductModel = ProductModel.fromJson(tProductJson);

  group('getAllProductModels', () {
    test('should return List<ProductModel> when the API call is successful', () async {
      // Arrange
      when(() => mockApiService.get('/products'))
          .thenAnswer((_) async => tProductList);

      // Act
      final result = await dataSource.getAllProductModels();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, tProductList.length);
      expect(result[0].id, tProductList[0]['id']);
      verify(() => mockApiService.get('/products')).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.get('/products'))
          .thenThrow(ServerException('Failed to load products'));

      // Act & Assert
      expect(
        () => dataSource.getAllProductModels(), 
        throwsA(isA<ServerException>())
      );
      verify(() => mockApiService.get('/products')).called(1);
    });
  });

  group('getProductModelById', () {
    test('should return ProductModel when the API call is successful', () async {
      // Arrange
      final id = '1';
      when(() => mockApiService.get('/products/$id'))
          .thenAnswer((_) async => tProductJson);

      // Act
      final result = await dataSource.getProductModelById(id);

      // Assert
      expect(result, isA<ProductModel>());
      expect(result?.id, tProductJson['id']);
      verify(() => mockApiService.get('/products/$id')).called(1);
    });

    test('should return null when the product is not found', () async {
      // Arrange
      final id = '9999';
      when(() => mockApiService.get('/products/$id'))
          .thenAnswer((_) async => null);

      // Act
      final result = await dataSource.getProductModelById(id);

      // Assert
      expect(result, isNull);
      verify(() => mockApiService.get('/products/$id')).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      final id = '1';
      when(() => mockApiService.get('/products/$id'))
          .thenThrow(ServerException('Server Error'));

      // Act & Assert
      expect(
        () => dataSource.getProductModelById(id), 
        throwsA(isA<ServerException>())
      );
      verify(() => mockApiService.get('/products/$id')).called(1);
    });
  });

  group('createProductModel', () {
    final tProductModelToCreate = ProductModel(
      id: '',
      title: 'New Product',
      description: 'A brand new product.',
      imageUrl: 'http://new.com/image.jpg',
      price: 50.0,
    );

    test('should complete successfully when the API call is successful', () async {
      // Arrange
      when(() => mockApiService.post(
        '/products',
        tProductModelToCreate.toJson(),
      )).thenAnswer((_) async => tProductJson);

      // Act
      await dataSource.createProductModel(tProductModelToCreate);

      // Assert
      verify(() => mockApiService.post(
        '/products',
        tProductModelToCreate.toJson(),
      )).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.post(any(), any()))
          .thenThrow(ServerException('Failed to create'));

      // Act & Assert
      await expectLater(
        () => dataSource.createProductModel(tProductModelToCreate),
        throwsA(isA<ServerException>()),
      );
      
      verify(() => mockApiService.post(
        '/products',
        tProductModelToCreate.toJson(),
      )).called(1);
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

    test('should complete successfully when the API call is successful', () async {
      // Arrange
      when(() => mockApiService.put(
        '/products/${tProductModelToUpdate.id}',
        tProductModelToUpdate.toJson(),
      )).thenAnswer((_) async => tProductJson);

      // Act
      await dataSource.updateProductModel(tProductModelToUpdate);

      // Assert
      verify(() => mockApiService.put(
        '/products/${tProductModelToUpdate.id}',
        tProductModelToUpdate.toJson(),
      )).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.put(any(), any()))
          .thenThrow(ServerException('Failed to update'));

      // Act & Assert
      await expectLater(
        () => dataSource.updateProductModel(tProductModelToUpdate),
        throwsA(isA<ServerException>()),
      );
      
      verify(() => mockApiService.put(
        '/products/${tProductModelToUpdate.id}',
        tProductModelToUpdate.toJson(),
      )).called(1);
    });
  });

  group('deleteProductModel', () {
    const idToDelete = '1';

    test('should complete successfully when the API call is successful', () async {
      // Arrange
      when(() => mockApiService.delete('/products/$idToDelete'))
          .thenAnswer((_) async => null);

      // Act
      await dataSource.deleteProductModel(idToDelete);

      // Assert
      verify(() => mockApiService.delete('/products/$idToDelete')).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.delete('/products/$idToDelete'))
          .thenThrow(ServerException('Failed to delete'));

      // Act & Assert
      await expectLater(
        () => dataSource.deleteProductModel(idToDelete),
        throwsA(isA<ServerException>()),
      );
      verify(() => mockApiService.delete('/products/$idToDelete')).called(1);
    });
  });
}