import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'product_card_item.dart';

class ProductCardList extends StatelessWidget {
  final List<Product> products;
  final bool isInDetailPage;
  final void Function(String productName)? onDelete;
  final void Function(Product updatedProduct)? onUpdate;

  const ProductCardList({
    super.key,
    required this.products,
    this.isInDetailPage = false,
    this.onDelete,
    this.onUpdate, required BuildContext context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products
          .map(
            (product) => ProductCardItem(
              context: context,
              product: product,
              isInDetailPage: isInDetailPage,
              onDelete: onDelete,
              onUpdate: onUpdate,
            ),
          )
          .toList(),
    );
  }
}
