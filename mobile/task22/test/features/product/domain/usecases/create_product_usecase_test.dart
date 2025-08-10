import 'package:dartz/dartz.dart';
import 'package:contracts_of_data_sources/core/error/failure.dart';
import 'package:contracts_of_data_sources/core/usecases/usecase_params.dart';
import 'package:contracts_of_data_sources/features/product/domain/entities/product.dart';
import 'package:contracts_of_data_sources/features/product/domain/repositories/product_repository.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// ✅ 1. Create a mock class
// 👇 This tells mockito to generate a fake/mock class for ProductRepository
@GenerateMocks([ProductRepository])
import 'create_product_usecase_test.mocks.dart';

void main() {
  // Declare the variables we will use
  late CreateProductUsecase usecase;
  late MockProductRepository mockRepository;

  // Runs before each test
  setUp(() {
    mockRepository = MockProductRepository(); // use the generated mock
    usecase = CreateProductUsecase(mockRepository); // inject the mock
  });

  // We'll write actual test cases here next
  test(
    'should call createProduct on the repository and return Right(unit)',
    () async {
      // Arrange
      final testProduct = const Product(
        id: '1',
        imageUrl: 'https://example.com/image.png',
        name: 'Test Product',
        price: 99.99,
        description: 'This is a test product',
      );

      when(
        mockRepository.createProduct(testProduct),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await usecase(ProductParams(testProduct));

      // Assert
      expect(result, const Right(unit)); // check the result is correct
      verify(
        mockRepository.createProduct(testProduct),
      ).called(1); // verify called once
      verifyNoMoreInteractions(mockRepository); // no more method calls
    },
  );
  test(
    'should return ServerFailure when repository fails to create product',
    () async {
      // Arrange
      final testProduct = const Product(
        id: '1',
        imageUrl: 'https://example.com/image.png',
        name: 'Test Product',
        price: 99.99,
        description: 'This is a test product',
      );

      when(
        mockRepository.createProduct(testProduct),
      ).thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase(ProductParams(testProduct));

      // Assert
      expect(result, Left(ServerFailure())); // check the result is failure
      verify(
        mockRepository.createProduct(testProduct),
      ).called(1); // verify called once
      verifyNoMoreInteractions(mockRepository); // no more method calls
    },
  );
}
