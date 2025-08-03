// test/features/product/data/repositories/product_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // For mocking
import 'package:contracts_of_data_sources/core/entities/product.dart'; // Adjust 'contracts_of_data_sources' to your project name
import 'package:contracts_of_data_sources/core/network/network_info.dart'; // Adjust project name
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart'; // Adjust project name
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart'; // Adjust project name
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart'; // Adjust project name
import 'package:contracts_of_data_sources/features/product/data/repositories/product_repository_impl.dart'; // Adjust project name

// Mocks for dependencies
class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Test data
  const tProductModel = ProductModel(
    id: '1',
    title: 'Test Product',
    description: 'Test Description',
    imageUrl: 'http://test.com/image.jpg',
    price: 100.0,
  );
  final tProduct = tProductModel.toEntity();
  final List<ProductModel> tProductModelList = [tProductModel];
  final List<Product> tProductList = [tProduct];


  group('getAllProducts', () {
    test('should return remote data when the device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllProductModels())
          .thenAnswer((_) async => tProductModelList);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(() => mockRemoteDataSource.getAllProductModels()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource); // Local data source should not be called
      expect(result, equals(tProductList));
    });

    test('should return local data when the device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getAllProductModels())
          .thenAnswer((_) async => tProductModelList);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(() => mockLocalDataSource.getAllProductModels()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource); // Remote data source should not be called
      expect(result, equals(tProductList));
    });

    test('should return local data when remote call fails and device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getAllProductModels())
          .thenAnswer((_) async => tProductModelList);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(() => mockLocalDataSource.getAllProductModels()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      expect(result, equals(tProductList));
    });
  });

  group('getProductById', () {
    test('should return remote data when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getProductModelById(any()))
          .thenAnswer((_) async => tProductModel);

      final result = await repository.getProductById('1');

      verify(() => mockRemoteDataSource.getProductModelById('1')).called(1);
      expect(result, equals(tProduct));
    });

    test('should return local data when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getProductModelById(any()))
          .thenAnswer((_) async => tProductModel);

      final result = await repository.getProductById('1');

      verify(() => mockLocalDataSource.getProductModelById('1')).called(1);
      expect(result, equals(tProduct));
    });
  });

  group('createProduct', () {
    test('should call remote data source when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.createProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.createProduct(tProduct);

      verify(() => mockRemoteDataSource.createProductModel(tProductModel)).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should call local data source when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.createProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.createProduct(tProduct);

      verify(() => mockLocalDataSource.createProductModel(tProductModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('updateProduct', () {
    test('should call remote data source when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.updateProduct(tProduct);

      verify(() => mockRemoteDataSource.updateProductModel(tProductModel)).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should call local data source when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.updateProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.updateProduct(tProduct);

      verify(() => mockLocalDataSource.updateProductModel(tProductModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('deleteProduct', () {
    test('should call remote data source when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.deleteProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.deleteProduct('1');

      verify(() => mockRemoteDataSource.deleteProductModel('1')).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should call local data source when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.deleteProductModel(any()))
          .thenAnswer((_) async => Future.value());

      await repository.deleteProduct('1');

      verify(() => mockLocalDataSource.deleteProductModel('1')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}