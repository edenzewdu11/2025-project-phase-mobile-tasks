// lib/features/product/presentation/pages/product_page_arguments.dart
import '../../domain/entities/product.dart';

class ProductPageArguments {
  final Product? product;
  final bool isEditing;

  ProductPageArguments({required this.product, required this.isEditing});
}
