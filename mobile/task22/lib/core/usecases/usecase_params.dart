import 'package:equatable/equatable.dart';

import '../../features/product/domain/entities/product.dart';

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdParams extends Equatable {
  final String id;

  const IdParams(this.id);

  @override
  List<Object?> get props => [id];
}

class ProductParams extends Equatable {
  final Product product;

  const ProductParams(this.product);

  @override
  List<Object> get props => [product];
}
