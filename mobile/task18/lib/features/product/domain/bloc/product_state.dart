// lib/features/product/domain/bloc/product_state.dart

import 'package:equatable/equatable.dart';
import 'package:contracts_of_data_sources/core/entities/product.dart'; // Corrected import

/// Base class for all Product BLoC states.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

/// Initial state of the BLoC.
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// State indicating that data is being loaded.
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// State representing all products successfully loaded.
class ProductLoadedAll extends ProductState {
  final List<Product> products;
  const ProductLoadedAll(this.products);

  @override
  List<Object> get props => [products];
}

/// State representing a single product successfully loaded.
class ProductLoadedSingle extends ProductState {
  final Product product;
  const ProductLoadedSingle(this.product);

  @override
  List<Object> get props => [product];
}

/// State indicating an error has occurred.
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

/// State indicating a product operation (create/update/delete) was successful.
/// This can be used to trigger a refresh of the product list.
class ProductOperationSuccess extends ProductState {
  final String message;
  const ProductOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}