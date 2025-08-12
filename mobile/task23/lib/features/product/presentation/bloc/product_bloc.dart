// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../../../core/util/Uuid_generator.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/view_product_by_id_usecase.dart';
import '../../domain/usecases/view_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateProductUsecase createProduct;
  final DeleteProductUsecase deleteProduct;
  final UpdateProductUsecase updateProduct;
  final ViewProductUsecase viewProduct;
  final ViewProductByIdUsecase viewSingleProduct;
  final InputConverter inputConverter;
  final IdGenerator idGenerator;

  ProductBloc({
    required this.createProduct,
    required this.deleteProduct,
    required this.updateProduct,
    required this.viewProduct,
    required this.viewSingleProduct,
    required this.inputConverter,
    required this.idGenerator,
  }) : super(InitialState()) {
    print('ProductBloc initialized successfully');
    
    // Dependencies are already required, no need for null checks
    
    on<CreateProductEvent>((event, emit) async {
      print('CreateProductEvent received: ${event.product.name} - \$${event.product.price}');
      emit(LoadingState());
      
      try {
        final priceString = event.product.price.toString();
        print('Price string: $priceString');
        final inputEither = inputConverter.stringToPositiveDouble(priceString);

        await inputEither.fold(
          (failure) async {
            print('Price validation failed: $failure');
            emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (parsedPrice) async {
            print('Price validation successful: $parsedPrice');
            // 1) await the create‐usecase result
            final String id = event.product.id.isEmpty
                ? idGenerator.generate()
                : event.product.id;

            final productToCreate = event.product.copyWith(
              id: id,
              price: parsedPrice,
            );
            print('Calling createProduct usecase...');
            final result = await createProduct(ProductParams(productToCreate));
            print('CreateProduct result: $result');

            // 2) await the fold so its async callbacks complete here
            await result.fold(
              (failure) async {
                print('CreateProduct failed: ${_mapFailureToMessage(failure)}');
                emit(ErrorState(message: _mapFailureToMessage(failure)));
              },
              (_) async {
                print('CreateProduct successful, fetching updated products...');
                // After successful creation, fetch the updated products list
                final productsOrFailure = await viewProduct(NoParams());

                // 3) and await this fold too
                await productsOrFailure.fold(
                  (failure) async =>
                      emit(ErrorState(message: _mapFailureToMessage(failure))),
                  (products) async =>
                      emit(LoadedAllProductState(products: products)),
                );
              },
            );
          },
        );
      } catch (e) {
        print('CreateProductEvent error: $e');
        emit(const ErrorState(message: 'An unexpected error occurred'));
      }
    });

    on<LoadAllProductEvent>((event, emit) async {
      emit(LoadingState());

      try {
        final failureOrProducts = await viewProduct(NoParams());

        failureOrProducts.fold(
          (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
          (products) => emit(LoadedAllProductState(products: products)),
        );
      } catch (e) {
        print('LoadAllProductEvent error: $e');
        emit(const ErrorState(message: 'An unexpected error occurred'));
      }
    });

    on<GetSingleProductEvent>((event, emit) async {
      emit(LoadingState());
      
      try {
        // For ID validation, we just need to check if it's not empty
        if (event.id.isEmpty) {
          emit(const ErrorState(message: 'Product ID cannot be empty'));
          return;
        }

        final result = await viewSingleProduct(IdParams(event.id));

        result.fold(
          (failure) =>
              emit(ErrorState(message: _mapFailureToMessage(failure))),
          (product) => emit(LoadedSingleProductState(product: product)),
        );
      } catch (e) {
        print('GetSingleProductEvent error: $e');
        emit(const ErrorState(message: 'An unexpected error occurred'));
      }
    });
    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      
      try {
        final priceString = event.product.price.toString();
        final inputEither = inputConverter.stringToPositiveDouble(priceString);

        await inputEither.fold(
          (failure) async {
            emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (parsedPrice) async {
            final productToUpdate = event.product.copyWith(price: parsedPrice);
            final result = await updateProduct(ProductParams(productToUpdate));

            await result.fold(
              (failure) async =>
                  emit(ErrorState(message: _mapFailureToMessage(failure))),
              (_) async {
                final productsResult = await viewSingleProduct(
                  IdParams(event.product.id),
                );

                productsResult.fold(
                  (failure) =>
                      emit(ErrorState(message: _mapFailureToMessage(failure))),
                  (products) => emit(LoadedSingleProductState(product: products)),
                );
              },
            );
          },
        );
      } catch (e) {
        print('UpdateProductEvent error: $e');
        emit(const ErrorState(message: 'An unexpected error occurred'));
      }
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(LoadingState());

      try {
        final result = await deleteProduct(IdParams(event.id));

        await result.fold(
          (failure) async {
            emit(ErrorState(message: _mapFailureToMessage(failure)));
          },
          (_) async {
            final productsResult = await viewProduct(NoParams());

            productsResult.fold(
              (failure) =>
                  emit(ErrorState(message: _mapFailureToMessage(failure))),
              (products) => emit(LoadedAllProductState(products: products)),
            );
          },
        );
      } catch (e) {
        print('DeleteProductEvent error: $e');
        emit(const ErrorState(message: 'An unexpected error occurred'));
      }
    });
  }
}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The price must be a positive number.';

String _mapFailureToMessage(Failure failure) {
  if (failure is ServerFailure) {
    return SERVER_FAILURE_MESSAGE;
  } else if (failure is CacheFailure) {
    return CACHE_FAILURE_MESSAGE;
  } else if (failure is NetworkFailure) {
    return 'Network connection failed. Please check your internet connection.';
  } else {
    return 'An unexpected error occurred. Please try again.';
  }
}
