// lib/features/product/domain/bloc/product_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contracts_of_data_sources/core/errors/failures.dart'; // Import failures
import 'package:contracts_of_data_sources/core/usecases/base_usecase.dart'; // Import NoParams
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/update_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/get_single_product_usecase.dart'; // ADDED
// Corrected import

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUsecase viewAllProductsUsecase;
  final GetSingleProductUsecase getSingleProductUsecase; // ADDED
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  ProductBloc({
    required this.viewAllProductsUsecase,
    required this.getSingleProductUsecase, // ADDED
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  }) : super(const ProductInitial()) {
    // Register event handlers
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await viewAllProductsUsecase(const NoParams()); // MODIFIED: NoParams is const
      emit(ProductLoadedAll(products));
    } on Failure catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final product = await getSingleProductUsecase(event.id);
      if (product != null) {
        emit(ProductLoadedSingle(product));
      } else {
        emit(const ProductError('Product not found.'));
      }
    } on Failure catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await createProductUsecase(event.product);
      emit(const ProductOperationSuccess('Product created successfully!'));
      add(const LoadAllProductsEvent()); // Trigger refresh of all products
    } on Failure catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await updateProductUsecase(event.product);
      emit(const ProductOperationSuccess('Product updated successfully!'));
      add(const LoadAllProductsEvent()); // Trigger refresh of all products
    } on Failure catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await deleteProductUsecase(event.id);
      emit(const ProductOperationSuccess('Product deleted successfully!'));
      add(const LoadAllProductsEvent()); // Trigger refresh of all products
    } on Failure catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}