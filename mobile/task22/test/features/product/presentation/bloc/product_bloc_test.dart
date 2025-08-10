// ignore_for_file: unused_element

import 'package:dartz/dartz.dart';

import 'package:contracts_of_data_sources/core/error/failure.dart';
import 'package:contracts_of_data_sources/core/usecases/usecase_params.dart';
import 'package:contracts_of_data_sources/core/util/Uuid_generator.dart';
import 'package:contracts_of_data_sources/core/util/input_converter.dart';
import 'package:contracts_of_data_sources/features/product/domain/entities/product.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/update_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_product_by_id_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProductUsecase,
  DeleteProductUsecase,
  UpdateProductUsecase,
  ViewProductUsecase,
  ViewProductByIdUsecase,
  InputConverter,
  IdGenerator,
])
void main() {
  late ProductBloc bloc;
  late MockCreateProductUsecase mockCreateProduct;
  late MockDeleteProductUsecase mockDeleteProductEvent;
  late MockUpdateProductUsecase mockUpdateProductEvent;
  late MockViewProductUsecase mockViewProducts;
  late MockViewProductByIdUsecase mockViewProductById;
  late MockInputConverter mockInputConverter;
  late MockIdGenerator mockIdGenerator;

  setUp(() {
    mockCreateProduct = MockCreateProductUsecase();
    mockDeleteProductEvent = MockDeleteProductUsecase();
    mockUpdateProductEvent = MockUpdateProductUsecase();
    mockViewProducts = MockViewProductUsecase();
    mockViewProductById = MockViewProductByIdUsecase();
    mockInputConverter = MockInputConverter();
    mockIdGenerator = MockIdGenerator();
    bloc = ProductBloc(
      createProduct: mockCreateProduct,
      deleteProduct: mockDeleteProductEvent,
      updateProduct: mockUpdateProductEvent,
      viewProduct: mockViewProducts,
      viewSingleProduct: mockViewProductById,
      inputConverter: mockInputConverter,
      idGenerator: mockIdGenerator,
    );
  });

  final tParsedPrice = 199;

  final tProduct = const Product(
    id: '1',
    imageUrl: 'https://example.com/image.png',
    name: 'Test Product',
    price: 199.0,
    description: 'A sample product for testing',
  );

  final tProductList = [tProduct];

  void setUpMockInputConverterSuccess() {
    when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Right(tParsedPrice));
  }

  test('initialState should be IntialState', () {
    // assert
    expect(bloc.state, equals(IntialState()));
  });

  // You'll add blocTest() here to test specific events and states

  group('CreateProductEvent', () {
    const tPriceString = '199.0';
    final tParsedPrice = 199;

    void setUpMockInputConverterSuccess() {
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Right(tParsedPrice));
    }

    void setUpMockInputConverterFailure() {
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));
    }

    // This is the product coming from the UI (e.g. a form)

    test(
      'should call InputConverter to validate and convert the product price from string',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;

        // Ensure the mock returns the parsed int
        when(
          mockInputConverter.stringToUnsignedInteger(inputPrice),
        ).thenReturn(Right(parsedPrice));

        // mock createProduct and viewProduct to return valid responses
        when(mockCreateProduct(any)).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Right(tProductList));

        final product = Product(
          id: '1',
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: double.parse(inputPrice),
          description: 'A sample product for testing',
        );

        // assert before acting
        final expectedStates = [
          LoadingState(),
          LoadedAllProductState(
            products: tProductList,
          ), // your mocked product list
        ];
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // act
        bloc.add(CreateProductEvent(product));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        verify(mockInputConverter.stringToUnsignedInteger(inputPrice));
      },
    );

    test(
      'should emit [ErrorState] when the input is invalid (i.e., inputConverter returns Left)',
      () async {
        // arrange
        const inputPrice =
            'invalid_price'; // This simulates the invalid string input

        final product = const Product(
          id: '1',
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: double.nan, // just a placeholder; it won't be used
          description: 'Invalid input product',
        );

        when(
          mockInputConverter.stringToUnsignedInteger(any),
        ).thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expected = [
          const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(CreateProductEvent(product));
      },
    );

    test(
      'should call createProduct use case with correct ProductParams',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;

        final product = Product(
          id: '1',
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: parsedPrice.toDouble(),
          description: 'A test product',
        );

        when(
          mockInputConverter.stringToUnsignedInteger(inputPrice),
        ).thenReturn(Right(parsedPrice));

        when(mockCreateProduct(any)).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Right(tProductList));

        // act
        bloc.add(CreateProductEvent(product));
        await untilCalled(mockCreateProduct(any));

        // assert
        verify(mockCreateProduct(ProductParams(product)));
      },
    );

    test(
      'should emit [LoadingState, LoadedAllProductState] when product is created successfully',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;
        final product = Product(
          id: '1',
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: parsedPrice.toDouble(),
          description: 'A test product',
        );

        when(
          mockInputConverter.stringToUnsignedInteger(inputPrice),
        ).thenReturn(Right(parsedPrice));

        when(mockCreateProduct(any)).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Right(tProductList));

        // assert
        final expected = [
          LoadingState(),
          LoadedAllProductState(products: tProductList),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(
          CreateProductEvent(product),
        ); // or CreateProductEvent(tProduct)
      },
    );

    test(
      'should emit [LoadingState, ErrorState] with SERVER_FAILURE_MESSAGE when createProduct fails with ServerFailure',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;

        when(
          mockInputConverter.stringToUnsignedInteger(inputPrice),
        ).thenReturn(Right(parsedPrice));

        when(
          mockCreateProduct(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // assert
        final expected = [
          LoadingState(),
          const ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(CreateProductEvent(tProduct));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] with CACHE_FAILURE_MESSAGE when createProduct fails with CacheFailure',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;

        when(
          mockInputConverter.stringToUnsignedInteger(inputPrice),
        ).thenReturn(Right(parsedPrice));

        when(
          mockCreateProduct(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert
        final expected = [
          LoadingState(),
          const ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(CreateProductEvent(tProduct));
      },
    );
  });

  group('LoadAllProductEvent', () {
    final tProductList = [tProduct]; // Your test product list

    test('should get data from the viewProduct use case', () async {
      when(mockViewProducts(any)).thenAnswer((_) async => Right(tProductList));

      bloc.add(const LoadAllProductEvent());

      await untilCalled(mockViewProducts(any));

      verify(mockViewProducts(NoParams()));
    });

    test(
      'should emit [LoadingState, LoadedAllProductState] when data is gotten successfully',
      () async {
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Right(tProductList));

        final expected = [
          LoadingState(),
          LoadedAllProductState(products: tProductList),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(const LoadAllProductEvent());
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when getting data fails',
      () async {
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          LoadingState(),
          const ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(const LoadAllProductEvent());
      },
    );

    test(
      'should emit [LoadingState, ErrorState] with proper message on CacheFailure',
      () async {
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        final expected = [
          LoadingState(),
          const ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        bloc.add(const LoadAllProductEvent());
      },
    );
  });

  group('LoadProductById', () {
    const tProductIdString = '123';
    const tProductIdParsed = 123;
    final tProduct = const Product(
      id: tProductIdString,
      imageUrl: 'https://example.com/image.png',
      name: 'Test Product',
      price: 199.0,
      description: 'A sample product',
    );

    test(
      'should call InputConverter to validate and convert the string to an integer',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductIdString),
        ).thenReturn(const Right(tProductIdParsed));
        when(mockViewProductById(any)).thenAnswer((_) async => Right(tProduct));

        // act
        bloc.add(const GetSingleProductEvent(tProductIdString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tProductIdString));
      },
    );

    test('should emit [ErrorState] when the input is invalid', () async {
      // arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetSingleProductEvent('invalid'));
    });

    test(
      'should get product by ID from the use case when input is valid',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductIdString),
        ).thenReturn(const Right(tProductIdParsed));
        when(mockViewProductById(any)).thenAnswer((_) async => Right(tProduct));

        // act
        bloc.add(const GetSingleProductEvent(tProductIdString));
        await untilCalled(mockViewProductById(any));

        // assert
        verify(mockViewProductById(const IdParams(tProductIdString)));
      },
    );

    test(
      'should emit [LoadingState, LoadedAllProductState] when data is gotten successfully',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductIdString),
        ).thenReturn(const Right(tProductIdParsed));
        when(mockViewProductById(any)).thenAnswer((_) async => Right(tProduct));

        // assert later
        final expected = [
          LoadingState(),
          LoadedSingleProductState(product: tProduct),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetSingleProductEvent(tProductIdString));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when getting data fails',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductIdString),
        ).thenReturn(const Right(tProductIdParsed));
        when(
          mockViewProductById(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingState(),
          const ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetSingleProductEvent(tProductIdString));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] with proper message on CacheFailure',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductIdString),
        ).thenReturn(const Right(tProductIdParsed));
        when(
          mockViewProductById(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingState(),
          const ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetSingleProductEvent(tProductIdString));
      },
    );
  });

  group('UpdateProductEvent', () {
    final tProduct = const Product(
      id: '1',
      name: 'Updated Product',
      description: 'Updated Description',
      price: 300.0,
      imageUrl: 'https://example.com/image.png',
    );

    final tParsedPrice = 300;
    final tProducts = [tProduct]; // Returned from viewProduct()

    setUp(() {
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Right(tParsedPrice));
    });

    test('should validate input and update product via use case', () async {
      // arrange
      when(
        mockUpdateProductEvent(any),
      ).thenAnswer((_) async => const Right(unit));
      when(
        mockViewProductById(any),
      ).thenAnswer((_) async => Right(tProducts[0]));

      // act
      bloc.add(UpdateProductEvent(tProduct));
      await untilCalled(mockUpdateProductEvent(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger('300.0'));
      verify(mockUpdateProductEvent(ProductParams(tProduct)));
    });

    test('should emit [ErrorState] when input is invalid', () async {
      // arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(UpdateProductEvent(tProduct));
    });

    test(
      'should emit [LoadingState, Success, LoadedAllProductState] on successful update',
      () async {
        // arrange
        when(
          mockUpdateProductEvent(any),
        ).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProductById(any),
        ).thenAnswer((_) async => Right(tProducts[0]));

        // assert
        final expected = [
          LoadingState(),
          LoadedSingleProductState(product: tProducts[0]),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(UpdateProductEvent(tProduct));
      },
    );

    test('should emit [LoadingState, ErrorState] on update failure', () async {
      // arrange
      when(
        mockUpdateProductEvent(any),
      ).thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        LoadingState(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(UpdateProductEvent(tProduct));
    });

    test(
      'should emit [Success, ErrorState] if product reload fails after update',
      () async {
        // arrange
        when(
          mockUpdateProductEvent(any),
        ).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProductById(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert
        final expected = [
          LoadingState(),
          const ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(UpdateProductEvent(tProduct));
      },
    );
  });

  group('DeleteProductEvent', () {
    const tProductId = '1';
    final tProductsAfterDeletion = <Product>[]; // Example: IntialState list

    test('should call DeleteProductEvent use case', () async {
      // arrange
      when(
        mockDeleteProductEvent(any),
      ).thenAnswer((_) async => const Right(unit));
      when(
        mockViewProducts(any),
      ).thenAnswer((_) async => Right(tProductsAfterDeletion));

      // act
      bloc.add(const DeleteProductEvent(tProductId));
      await untilCalled(mockDeleteProductEvent(any));

      // assert
      verify(mockDeleteProductEvent(const IdParams(tProductId)));
    });

    test(
      'should emit [LoadingState, Success, LoadedAllProductState] on successful delete',
      () async {
        // arrange
        when(
          mockDeleteProductEvent(any),
        ).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Right(tProductsAfterDeletion));

        // assert
        final expected = [
          LoadingState(),
          LoadedAllProductState(products: tProductsAfterDeletion),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const DeleteProductEvent(tProductId));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when deletion fails',
      () async {
        // arrange
        when(
          mockDeleteProductEvent(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // assert
        final expected = [
          LoadingState(),
          const ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const DeleteProductEvent(tProductId));
      },
    );

    test(
      'should emit [Success, ErrorState] when reload fails after successful delete',
      () async {
        // arrange
        when(
          mockDeleteProductEvent(any),
        ).thenAnswer((_) async => const Right(unit));
        when(
          mockViewProducts(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert
        final expected = [
          LoadingState(),

          const ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const DeleteProductEvent(tProductId));
      },
    );
  });
}
