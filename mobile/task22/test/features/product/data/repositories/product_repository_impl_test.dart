import 'package:dartz/dartz.dart';
import 'package:contracts_of_data_sources/core/error/exception.dart';
import 'package:contracts_of_data_sources/core/error/failure.dart';
import 'package:contracts_of_data_sources/core/network/network_info.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
import 'package:contracts_of_data_sources/features/product/data/repositories/product_repository_impl.dart';
import 'package:contracts_of_data_sources/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllProducts', () {
    final testProductModel = const ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'https://example.com/image.png',
      price: 99.99,
      description: 'Test description',
    );

    final List<ProductModel> testProductModelList = [testProductModel];
    final List<Product> testProductList = testProductModelList;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getAllProducts(),
      ).thenAnswer((_) async => testProductModelList);

      // act
      await repository.getAllProducts();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => testProductModelList);

          // act
          final result = await repository.getAllProducts();

          // assert
          verify(mockRemoteDataSource.getAllProducts());
          expect(result, equals(Right(testProductList)));
        },
      );

      test(
        'should cache the products locally when remote call is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => testProductModelList);

          // act
          await repository.getAllProducts();

          // assert
          verify(mockRemoteDataSource.getAllProducts());
          verify(mockLocalDataSource.cacheProductList(testProductModelList));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getAllProducts(),
          ).thenThrow(ServerException());

          // act
          final result = await repository.getAllProducts();

          // assert
          verify(mockRemoteDataSource.getAllProducts());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when cache is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getLastProductList(),
          ).thenAnswer((_) async => testProductModelList);

          // act
          final result = await repository.getAllProducts();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastProductList());
          expect(result, equals(Right(testProductList)));
        },
      );

      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getLastProductList(),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getAllProducts();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastProductList());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getProductById', () {
    const tId = '1';
    final testProductModel = const ProductModel(
      id: tId,
      name: 'Test Product',
      imageUrl: 'https://example.com/image.png',
      price: 99.99,
      description: 'Test description',
    );
    final Product testProduct = testProductModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getProductById(tId),
      ).thenAnswer((_) async => testProductModel);

      // act
      await repository.getProductById(tId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getProductById(tId),
          ).thenAnswer((_) async => testProductModel);

          // act
          final result = await repository.getProductById(tId);

          // assert
          verify(mockRemoteDataSource.getProductById(tId));
          expect(result, equals(Right(testProduct)));
        },
      );

      test(
        'should cache the product locally when remote call is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getProductById(tId),
          ).thenAnswer((_) async => testProductModel);

          // act
          await repository.getProductById(tId);

          // assert
          verify(mockRemoteDataSource.getProductById(tId));
          verify(mockLocalDataSource.cacheProduct(testProductModel));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getProductById(tId),
          ).thenThrow(ServerException());

          // act
          final result = await repository.getProductById(tId);

          // assert
          verify(mockRemoteDataSource.getProductById(tId));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached product when cache is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getProductById(tId),
          ).thenAnswer((_) async => testProductModel);

          // act
          final result = await repository.getProductById(tId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getProductById(tId));
          expect(result, equals(Right(testProduct)));
        },
      );

      test(
        'should return CacheFailure when no cached product is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getProductById(tId),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getProductById(tId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getProductById(tId));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('createProduct', () {
    final testProduct = const Product(
      id: '1',
      name: 'New Product',
      imageUrl: 'https://example.com/image.png',
      price: 49.99,
      description: 'Product description',
    );
    final testProductModel = ProductModel.fromEntity(testProduct);

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.createProduct(testProductModel),
      ).thenAnswer((_) async {});

      // act
      await repository.createProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should create product on remote data source and cache it',
        () async {
          // arrange
          when(
            mockRemoteDataSource.createProduct(testProductModel),
          ).thenAnswer((_) async {});

          // act
          final result = await repository.createProduct(testProduct);

          // assert
          verify(mockRemoteDataSource.createProduct(testProductModel));
          verify(mockLocalDataSource.cacheProduct(testProductModel));
          expect(result, equals(const Right(unit)));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.createProduct(testProductModel),
          ).thenThrow(ServerException());

          // act
          final result = await repository.createProduct(testProduct);

          // assert
          verify(mockRemoteDataSource.createProduct(testProductModel));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.createProduct(testProduct);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });

  group('updateProduct', () {
    final testProduct = const Product(
      id: '1',
      name: 'Updated Product',
      imageUrl: 'https://example.com/image.png',
      price: 59.99,
      description: 'Updated description',
    );
    final testProductModel = ProductModel.fromEntity(testProduct);

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.updateProduct(testProductModel),
      ).thenAnswer((_) async {});

      // act
      await repository.updateProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should update product on remote data source and cache locally',
        () async {
          // arrange
          when(
            mockRemoteDataSource.updateProduct(testProductModel),
          ).thenAnswer((_) async {});

          // act
          final result = await repository.updateProduct(testProduct);

          // assert
          verify(mockRemoteDataSource.updateProduct(testProductModel));
          verify(mockLocalDataSource.cacheProduct(testProductModel));
          expect(result, equals(const Right(unit)));
        },
      );

      test(
        'should return ServerFailure when remote update throws ServerException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.updateProduct(testProductModel),
          ).thenThrow(ServerException());

          // act
          final result = await repository.updateProduct(testProduct);

          // assert
          verify(mockRemoteDataSource.updateProduct(testProductModel));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.updateProduct(testProduct);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });

  group('deleteProduct', () {
    final testId = '1';

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.deleteProduct(testId),
      ).thenAnswer((_) async => Future.value());
      when(
        mockLocalDataSource.deleteProduct(testId),
      ).thenAnswer((_) async => Future.value());

      // act
      await repository.deleteProduct(testId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should delete product from remote and local data sources',
        () async {
          // arrange
          when(
            mockRemoteDataSource.deleteProduct(testId),
          ).thenAnswer((_) async => Future.value());
          when(
            mockLocalDataSource.deleteProduct(testId),
          ).thenAnswer((_) async => Future.value());

          // act
          final result = await repository.deleteProduct(testId);

          // assert
          verify(mockRemoteDataSource.deleteProduct(testId));
          verify(mockLocalDataSource.deleteProduct(testId));
          expect(result, equals(const Right(unit)));
        },
      );

      test(
        'should return ServerFailure when remote delete throws ServerException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.deleteProduct(testId),
          ).thenThrow(ServerException());

          // act
          final result = await repository.deleteProduct(testId);

          // assert
          verify(mockRemoteDataSource.deleteProduct(testId));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.deleteProduct(testId);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });
}
