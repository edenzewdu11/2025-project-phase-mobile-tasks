part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// Initial state before anything happens
final class IntialState extends ProductState {}

// Loading state shown while fetching products
final class LoadingState extends ProductState {}

// Loaded state with the list of products
final class LoadedAllProductState extends ProductState {
  final List<Product> products;

  const LoadedAllProductState({required this.products});

  @override
  List<Object> get props => [products];
}

final class LoadedSingleProductState extends ProductState {
  final Product product;

  const LoadedSingleProductState({required this.product});

  @override
  List<Object> get props => [product];
}

// Error state shown when something goes wrong
final class ErrorState extends ProductState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
