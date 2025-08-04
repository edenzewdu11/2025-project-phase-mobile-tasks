// test/features/product/data/datasources/product_remote_data_source_impl_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail
import 'package:http/http.dart' as http; // Still needed for MockHttpClient (though ApiService abstracts it)
import 'package:contracts_of_data_sources/core/constants/api_constants.dart';
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

  // Test data (JSONPlaceholder 'post' format)
  final tPostJson = {
    'userId': 1,
    'id': 1,
    'title': 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
    'body': 'quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto',
  };
  final tPostJsonList = [tPostJson, {'userId': 1, 'id': 2, 'title': 'qui est esse', 'body': 'est rerum tempore vitae sequi sint nihil reprehenderit dolor beatae ea dolores neque fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis qui aperiam non debitis possimus qui sint et et veritatis est rerum tempore vitae sequi sint nihil reprehenderit dolor beatae ea dolores neque fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis qui aperiam non debitis possimus qui sint et et veritatis'}];

  // Helper to convert JSONPlaceholder Post to ProductModel
  ProductModel _postToProductModel(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['body'],
      imageUrl: 'https://via.placeholder.com/150/00FF00?text=Product+${json['id']}',
      price: (json['id'] % 100) + 9.99,
    );
  }

  group('getAllProductModels', () {
    test('should return List<ProductModel> when the API call is successful', () async {
      // Arrange
      when(() => mockApiService.get(any()))
          .thenAnswer((_) async => tPostJsonList);

      // Act
      final result = await dataSource.getAllProductModels();

      // Assert
      expect(result, equals(tPostJsonList.map((json) => _postToProductModel(json)).toList()));
      verify(() => mockApiService.get('/posts')).called(1);
    });

    test('should throw ServerException when the API call returns a server error', () async {
      // Arrange
      when(() => mockApiService.get(any()))
          .thenThrow(ServerException('Failed to load products', statusCode: 500));

      // Act & Assert
      expect(() => dataSource.getAllProductModels(), throwsA(isA<ServerException>()));
      verify(() => mockApiService.get('/posts')).called(1);
    });

    test('should throw NetworkException when no internet', () async {
      // Arrange
      when(() => mockApiService.get(any()))
          .thenThrow(NetworkException('No internet connection.'));

      // Act & Assert
      expect(() => dataSource.getAllProductModels(), throwsA(isA<NetworkException>()));
      verify(() => mockApiService.get('/posts')).called(1);
    });
  });

  group('getProductModelById', () {
    test('should return ProductModel when the API call is successful', () async {
      // Arrange
      final id = '1';
      when(() => mockApiService.get(any()))
          .thenAnswer((_) async => tPostJson);

      // Act
      final result = await dataSource.getProductModelById(id);

      // Assert
      expect(result, equals(_postToProductModel(tPostJson)));
      verify(() => mockApiService.get('/posts/$id')).called(1);
    });

    test('should return null when the API call returns NotFoundException', () async {
      // Arrange
      final id = '9999';
      when(() => mockApiService.get(any()))
          .thenThrow(NotFoundException('Resource not found for /posts/$id.'));

      // Act
      final result = await dataSource.getProductModelById(id);

      // Assert
      expect(result, isNull);
      verify(() => mockApiService.get('/posts/$id')).called(1);
    });

    test('should throw ServerException when the API call returns a server error', () => {
      // Arrange
      final id = '1';
      when(() => mockApiService.get(any()))
          .thenThrow(ServerException('Server Error', statusCode: 500));

      // Act & Assert
      expect(() => dataSource.getProductModelById(id), throwsA(isA<ServerException>()));
      verify(() => mockApiService.get('/posts/$id')).called(1);
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
    final requestBody = {
      'title': tProductModelToCreate.title,
      'body': tProductModelToCreate.description,
      'userId': 1,
    };

    test('should return void when the API call is successful (201 created)', () async {
      // Arrange
      when(() => mockApiService.post(any(), any()))
          .thenAnswer((_) async => {'id': 101, 'title': 'New Product'});

      // Act
      await dataSource.createProductModel(tProductModelToCreate);

      // Assert
      verify(() => mockApiService.post('/posts', requestBody)).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.post(any(), any()))
          .thenThrow(ServerException('Failed to create', statusCode: 400));

      // Act & Assert
      expect(() => dataSource.createProductModel(tProductModelToCreate), throwsA(isA<ServerException>()));
      verify(() => mockApiService.post('/posts', requestBody)).called(1);
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
    final requestBody = {
      'id': int.parse(tProductModelToUpdate.id),
      'title': tProductModelToUpdate.title,
      'body': tProductModelToUpdate.description,
      'userId': 1,
    };

    test('should return void when the API call is successful (200 OK)', () async {
      // Arrange
      when(() => mockApiService.put(any(), any()))
          .thenAnswer((_) async => {'id': 1, 'title': 'Updated Product'});

      // Act
      await dataSource.updateProductModel(tProductModelToUpdate);

      // Assert
      verify(() => mockApiService.put('/posts/${tProductModelToUpdate.id}', requestBody)).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.put(any(), any()))
          .thenThrow(ServerException('Failed to update', statusCode: 400));

      // Act & Assert
      expect(() => dataSource.updateProductModel(tProductModelToUpdate), throwsA(isA<ServerException>()));
      verify(() => mockApiService.put('/posts/${tProductModelToUpdate.id}', requestBody)).called(1);
    });
  });

  group('deleteProductModel', () {
    final idToDelete = '1';

    test('should return void when the API call is successful (200 OK)', () async {
      // Arrange
      when(() => mockApiService.delete(any()))
          .thenAnswer((_) async => null);

      // Act
      await dataSource.deleteProductModel(idToDelete);

      // Assert
      verify(() => mockApiService.delete('/posts/$idToDelete')).called(1);
    });

    test('should throw ServerException when the API call fails', () async {
      // Arrange
      when(() => mockApiService.delete(any()))
          .thenThrow(ServerException('Failed to delete', statusCode: 500));

      // Act & Assert
      expect(() => dataSource.deleteProductModel(idToDelete), throwsA(isA<ServerException>()));
      verify(() => mockApiService.delete('/posts/$idToDelete')).called(1);
    });
  });
}