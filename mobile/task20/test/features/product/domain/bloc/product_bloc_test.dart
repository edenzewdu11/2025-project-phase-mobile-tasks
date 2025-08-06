// test/features/product/domain/bloc/product_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:contracts_of_data_sources/core/entities/product.dart';
import 'package:contracts_of_data_sources/core/errors/failures.dart';
import 'package:contracts_of_data_sources/core/usecases/base_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/get_single_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/update_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_all_products_usecase.dart';

// Mocks for Use Cases
class MockViewAllProductsUsecase extends Mock implements ViewAllProductsUsecase {}
class MockGetSingleProductUsecase extends Mock implements GetSingleProductUsecase {}
class MockCreateProductUsecase extends Mock implements CreateProductUsecase {}
class MockUpdateProductUsecase extends Mock implements UpdateProductUsecase {}
class MockDeleteProductUsecase extends Mock implements DeleteProductUsecase {}

void main() {
  late ProductBloc productBloc;
  late MockViewAllProductsUsecase mockViewAllProductsUsecase;
  late MockGetSingleProductUsecase mockGetSingleProductUsecase;
  late MockCreateProductUsecase mockCreateProductUsecase;
  late MockUpdateProductUsecase mockUpdateProductUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;

  // Test data
  const tProduct = Product(
    id: '1',
    title: 'Test Product',
    description: 'Test Description',
    imageUrl: 'http://test.com/image.jpg',
    price: 100.0,
  );
  final tProductList = [tProduct];
  const tErrorMessage = 'Something went wrong!';

  setUp(() {
    mockViewAllProductsUsecase = MockViewAllProductsUsecase();
    mockGetSingleProductUsecase = MockGetSingleProductUsecase();
    mockCreateProductUsecase = MockCreateProductUsecase();
    mockUpdateProductUsecase = MockUpdateProductUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();

    productBloc = ProductBloc(
      viewAllProductsUsecase: mockViewAllProductsUsecase,
      getSingleProductUsecase: mockGetSingleProductUsecase,
      createProductUsecase: mockCreateProductUsecase,
      updateProductUsecase: mockUpdateProductUsecase,
      deleteProductUsecase: mockDeleteProductUsecase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  test('initial state should be ProductInitial', () {
    expect(productBloc.state, const ProductInitial());
  });

  group('LoadAllProductsEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadedAll] when ViewAllProductsUsecase is successful',
      build: () {
        when(() => mockViewAllProductsUsecase(const NoParams())) // MODIFIED: const NoParams()
            .thenAnswer((_) async => tProductList);
        return productBloc;
      },
      act: (bloc) => bloc.add(const LoadAllProductsEvent()),
      expect: () => [
        const ProductLoading(),
        ProductLoadedAll(tProductList),
      ],
      verify: (_) {
        verify(() => mockViewAllProductsUsecase(const NoParams())).called(1); // MODIFIED: const NoParams()
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when ViewAllProductsUsecase fails',
      build: () {
        when(() => mockViewAllProductsUsecase(const NoParams())) // MODIFIED: const NoParams()
            .thenThrow(ServerFailure(tErrorMessage));
        return productBloc;
      },
      act: (bloc) => bloc.add(const LoadAllProductsEvent()),
      expect: () => [
        const ProductLoading(),
        const ProductError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => mockViewAllProductsUsecase(const NoParams())).called(1); // MODIFIED: const NoParams()
      },
    );
  });

  group('GetSingleProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadedSingle] when GetSingleProductUsecase is successful',
      build: () {
        when(() => mockGetSingleProductUsecase(any()))
            .thenAnswer((_) async => tProduct);
        return productBloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
      expect: () => [
        const ProductLoading(),
        const ProductLoadedSingle(tProduct),
      ],
      verify: (_) {
        verify(() => mockGetSingleProductUsecase('1')).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when GetSingleProductUsecase returns null',
      build: () {
        when(() => mockGetSingleProductUsecase(any()))
            .thenAnswer((_) async => null);
        return productBloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
      expect: () => [
        const ProductLoading(),
        const ProductError('Product not found.'),
      ],
      verify: (_) {
        verify(() => mockGetSingleProductUsecase('1')).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when GetSingleProductUsecase fails',
      build: () {
        when(() => mockGetSingleProductUsecase(any()))
            .thenThrow(NetworkFailure(tErrorMessage));
        return productBloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
      expect: () => [
        const ProductLoading(),
        const ProductError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => mockGetSingleProductUsecase('1')).called(1);
      },
    );
  });

  group('CreateProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductOperationSuccess, ProductLoadedAll] when CreateProductUsecase is successful',
      build: () {
        when(() => mockCreateProductUsecase(any()))
            .thenAnswer((_) async => Future.value());
        when(() => mockViewAllProductsUsecase(const NoParams())) // MODIFIED: const NoParams()
            .thenAnswer((_) async => tProductList); // For subsequent LoadAllProductsEvent
        return productBloc;
      },
      act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
      expect: () => [
        const ProductLoading(),
        const ProductOperationSuccess('Product created successfully!'),
        const ProductLoading(), // Triggered by LoadAllProductsEvent
        ProductLoadedAll(tProductList),
      ],
      verify: (_) {
        verify(() => mockCreateProductUsecase(tProduct)).called(1);
        verify(() => mockViewAllProductsUsecase(const NoParams())).called(1); // MODIFIED: const NoParams()
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when CreateProductUsecase fails',
      build: () {
        when(() => mockCreateProductUsecase(any()))
            .thenThrow(ServerFailure(tErrorMessage));
        return productBloc;
      },
      act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
      expect: () => [
        const ProductLoading(),
        const ProductError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => mockCreateProductUsecase(tProduct)).called(1);
        verifyNever(() => mockViewAllProductsUsecase(const NoParams())); // MODIFIED: const NoParams()
      },
    );
  });

  group('UpdateProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductOperationSuccess, ProductLoadedAll] when UpdateProductUsecase is successful',
      build: () {
        when(() => mockUpdateProductUsecase(any()))
            .thenAnswer((_) async => Future.value());
        when(() => mockViewAllProductsUsecase(const NoParams())) // MODIFIED: const NoParams()
            .thenAnswer((_) async => tProductList);
        return productBloc;
      },
      act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
      expect: () => [
        const ProductLoading(),
        const ProductOperationSuccess('Product updated successfully!'),
        const ProductLoading(),
        ProductLoadedAll(tProductList),
      ],
      verify: (_) {
        verify(() => mockUpdateProductUsecase(tProduct)).called(1);
        verify(() => mockViewAllProductsUsecase(const NoParams())).called(1); // MODIFIED: const NoParams()
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when UpdateProductUsecase fails',
      build: () {
        when(() => mockUpdateProductUsecase(any()))
            .thenThrow(CacheFailure(tErrorMessage));
        return productBloc;
      },
      act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
      expect: () => [
        const ProductLoading(),
        const ProductError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => mockUpdateProductUsecase(tProduct)).called(1);
        verifyNever(() => mockViewAllProductsUsecase(const NoParams())); // MODIFIED: const NoParams()
      },
    );
  });

  group('DeleteProductEvent', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductOperationSuccess, ProductLoadedAll] when DeleteProductUsecase is successful',
      build: () {
        when(() => mockDeleteProductUsecase(any()))
            .thenAnswer((_) async => Future.value());
        when(() => mockViewAllProductsUsecase(const NoParams())) // MODIFIED: const NoParams()
            .thenAnswer((_) async => []); // Simulate empty list after delete
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProductEvent('1')),
      expect: () => [
        const ProductLoading(),
        const ProductOperationSuccess('Product deleted successfully!'),
        const ProductLoading(),
        const ProductLoadedAll([]),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUsecase('1')).called(1);
        verify(() => mockViewAllProductsUsecase(const NoParams())).called(1); // MODIFIED: const NoParams()
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when DeleteProductUsecase fails',
      build: () {
        when(() => mockDeleteProductUsecase(any()))
            .thenThrow(NotFoundFailure(tErrorMessage));
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProductEvent('1')),
      expect: () => [
        const ProductLoading(),
        const ProductError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUsecase('1')).called(1);
        verifyNever(() => mockViewAllProductsUsecase(const NoParams())); // MODIFIED: const NoParams()
      },
    );
  });
}