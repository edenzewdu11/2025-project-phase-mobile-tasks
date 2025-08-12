// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../lib/core/error/failure.dart';
import '../../../../../../lib/core/usecases/usecase_params.dart';
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
  }) : super(IntialState()) {
    on<CreateProductEvent>((event, emit) async {
      emit(LoadingState());
      final priceString = event.product.price.toString();
      final inputEither = inputConverter.stringToUnsignedInteger(priceString);

      await inputEither.fold(
        (failure) async {
          emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (parsedPrice) async {
          // 1) await the create‐usecase result
          final String id = event.product.id.isEmpty
              ? idGenerator.generate()
              : event.product.id;

          final productToCreate = event.product.copyWith(
            id: id,
            price: parsedPrice.toDouble(),
          );
          final result = await createProduct(ProductParams(productToCreate));

          // 2) await the fold so its async callbacks complete here
          await result.fold(
            (failure) async {
              emit(ErrorState(message: _mapFailureToMessage(failure)));
            },
            (_) async {
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
    });

    on<LoadAllProductEvent>((event, emit) async {
      emit(LoadingState());

      final failureOrProducts = await viewProduct(NoParams());

      failureOrProducts.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (products) => emit(LoadedAllProductState(products: products)),
      );
    });

    on<GetSingleProductEvent>((event, emit) async {
      emit(LoadingState());
      final inputEither = inputConverter.stringToUnsignedInteger(event.id);

      await inputEither.fold(
        (failure) async {
          emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (parsedId) async {
          final result = await viewSingleProduct(IdParams(parsedId.toString()));

          result.fold(
            (failure) =>
                emit(ErrorState(message: _mapFailureToMessage(failure))),
            (product) => emit(LoadedSingleProductState(product: product)),
          );
        },
      );
    });
    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      final priceString = event.product.price.toString();
      final inputEither = inputConverter.stringToUnsignedInteger(priceString);

      await inputEither.fold(
        (failure) async {
          emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (parsedPrice) async {
          final result = await updateProduct(ProductParams(event.product));

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
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(LoadingState());

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
    });
  }
}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case ServerFailure _:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure _:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected ErrorState';
  }
}
